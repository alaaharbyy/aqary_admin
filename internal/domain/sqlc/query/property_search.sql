
-- name: LatestFilterePropertiesCount :one
WITH facilities_and_amenities AS(
    SELECT 
        p.id, 
        fa."type",
        array_agg(DISTINCT coalesce(fae.facility_amenity_id,0))::bigint[] AS facilities_amenities
    FROM property p
    LEFT JOIN facilities_amenities_entity fae ON fae.entity_id = p.id AND fae.entity_type_id = @property_entity_type::bigint
    LEFT JOIN facilities_amenities fa ON fae.facility_amenity_id = fa.id
    GROUP BY p.id, fa."type"
),
-- Streamlined property media with direct coalescing
property_media_agg AS (
    SELECT
        entity_id,
        entity_type_id,
        array_agg(DISTINCT media_type ORDER BY media_type) AS media
    FROM global_media
    WHERE entity_type_id IN (@property_entity_type::bigint, @propertyversions_entity_type::bigint)
    GROUP BY entity_id, entity_type_id
),
-- Optimized downpayment calculation
downpayment AS (
    SELECT 
        pv.id as property_id, 
        ARRAY_AGG(pi.percentage) as percentages
    FROM property_versions pv
    JOIN payment_plans_packages ppp ON ppp.entity_id = pv.id 
        AND ppp.entity_type_id = @propertyversions_entity_type::bigint
    JOIN LATERAL (
        SELECT 
            pp.id AS payment_plans,
            pi.percentage
        FROM plan_installments pi
        JOIN unnest(ppp.payment_plans_id) pp(id) ON pi.payment_plans = pp.id
        ORDER BY pi."date"
        LIMIT 1
    ) pi ON true
    GROUP BY pv.id
),
-- Optimized desired countries
DesiredCountries AS (
    SELECT 
        pv.id AS property_id,
        ARRAY_AGG(a.countries_id) AS "countries" 
    FROM property_versions pv
    JOIN swap_requirement sr ON sr.entity_id = pv.id 
        AND sr.entity_type = @propertyversions_entity_type::bigint
    JOIN swap_requirment_address sra ON sra.swap_requirment_id = sr.id
    JOIN addresses a ON a.id = sra.addresses_id
    WHERE pv.category = 3
    GROUP BY pv.id
),
-- Pre-filtered wishlist check
wishlisted_properties AS (
    SELECT DISTINCT entity_id
    FROM wishlist
    WHERE entity_type_id = @propertyversions_entity_type::bigint
    AND platform_user_id = @platform_user::bigint
)
SELECT 
    count(pv.id)
FROM property_versions pv 
JOIN property p ON pv.property_id = p.id
LEFT JOIN phases ON phases.id = p.entity_id AND p.entity_type_id = @phases_entity_type::bigint 
LEFT JOIN property_media_agg pma1 ON pma1.entity_id = pv.id AND pma1.entity_type_id = @propertyversions_entity_type::bigint
LEFT JOIN property_media_agg pma2 ON pma2.entity_id = p.id AND pma2.entity_type_id = @property_entity_type::bigint AND pma1.media IS NULL
JOIN global_property_type gpt ON gpt.id = p.property_type_id
JOIN addresses a ON p.addresses_id = a.id
LEFT JOIN countries ON countries.id = a.countries_id
LEFT JOIN states st ON a.states_id = st.id
LEFT JOIN cities ci ON a.cities_id = ci.id
LEFT JOIN communities com ON a.communities_id = com.id
LEFT JOIN sub_communities subcom ON a.sub_communities_id = subcom.id
LEFT JOIN locations ON locations.id = a.locations_id
LEFT JOIN properties_map_location ON properties_map_location.id = a.property_map_location_id
LEFT JOIN downpayment ON downpayment.property_id = pv.id
LEFT JOIN facilities_and_amenities f ON f.id = p.id AND f."type" = 1
LEFT JOIN facilities_and_amenities am ON am.id = p.id AND am."type" = 2
JOIN company_users cu ON cu.users_id = pv.agent_id
JOIN users ON users.id = cu.users_id
LEFT JOIN DesiredCountries ON DesiredCountries.property_id = pv.id AND 3 = ANY(@category::bigint[])
LEFT JOIN wishlisted_properties wp ON wp.entity_id = pv.id
WHERE
    (CASE WHEN @hotdeal::bool IS NULL OR @hotdeal::bool = false THEN true ELSE pv.is_hotdeal = @hotdeal::bool END)
    AND
    (CASE WHEN @is_verified::bool IS NULL OR @is_verified::bool = false THEN true ELSE pv.is_verified = @is_verified::bool END)
    AND
    (CASE WHEN ARRAY_LENGTH(@views::bigint[], 1) IS NULL THEN TRUE ELSE (string_to_array(trim(both '[]' from p.facts->>'views'), ',')::BIGINT[]) &&  @views::BIGINT[] END)
    AND
	    (CASE WHEN @phase_id::BIGINT= 0 THEN TRUE ELSE phases.id= @phase_id::BIGINT END)
    AND
        (case WHEN (ARRAY_LENGTH(@desired_countries::bigint[],1)) is null then true else DesiredCountries.countries && @desired_countries::bigint[] end)
    AND
        (CASE WHEN  ARRAY_LENGTH(@broker_company_id::bigint [], 1) IS NULL THEN TRUE ELSE cu.company_id= ANY(@broker_company_id::bigint []) END) AND users.status=2
     AND (-- facilities
        array_length(@facilities::bigint[], 1) IS NULL
        OR f.facilities_amenities::bigint[] && @facilities::bigint[]
    )
    AND (--  amenities
        array_length(@amenities::bigint[], 1) IS NULL
        OR am.facilities_amenities::bigint[] && @amenities::bigint[]
    )
    AND
    (CASE WHEN ARRAY_LENGTH(@property_rank::bigint [],1) IS NULL THEN TRUE ELSE
            p.property_rank = ANY (@property_rank::bigint []) END)
    AND
        (case WHEN @downpayment::VARCHAR= '' then true else @downpayment= any(downpayment.percentages) END)
    AND
          pv.status  not in (1,6,5)
    AND
    	(case WHEN @life_style::BIGINT= 0 then true else (pv.facts->>'life_style')::BIGINT= @life_style::BIGINT end)
    AND
        (CASE WHEN  ARRAY_LENGTH(@property_usage::BIGINT[],1) IS NULL then true else gpt."usage"= ANY(@property_usage::BIGINT[]) end) -- commercial, residential, agricultural, industrial
    AND
        (CASE WHEN @property_types::bigint=0 THEN TRUE ELSE p.property_type_id= @property_types::bigint END) -- lux , ind,etc
    AND
        (CASE WHEN @ref_no::varchar='' THEN TRUE ELSE pv.ref_no= @ref_no::varchar END)
    AND 
        (CASE WHEN  ARRAY_LENGTH(@agent_id::bigint[],1) IS NULL then true else pv.agent_id= ANY(@agent_id::bigint[]) end)
    AND
        (CASE WHEN ARRAY_LENGTH(@developer_company_id::bigint[],1) IS NULL THEN TRUE ELSE p.company_id= ANY(@developer_company_id::bigint[]) END)
    AND 
        (ARRAY_LENGTH(@category::BIGINT[], 1) IS NULL OR pv.category = ANY(@category::BIGINT[]))  -- rent sale swap
    AND
        (CASE WHEN ARRAY_LENGTH(@search::VARCHAR[], 1) IS NULL --keywords
        THEN TRUE ELSE
        pv.ref_no ILIKE ANY(@search::VARCHAR[])
        OR
        pv.title ILIKE ANY(@search::VARCHAR[])
        OR pv.title_arabic ILIKE ANY(@search::VARCHAR[])
        OR pv.description ILIKE ANY(@search::VARCHAR[])
        OR st."state" ILIKE ANY(@search::VARCHAR[])
        OR ci.city ILIKE ANY(@search::VARCHAR[])
        OR com.community ILIKE ANY(@search::VARCHAR[])
        OR subcom.sub_community ILIKE ANY(@search::VARCHAR[])
        OR gpt."type" ILIKE ANY(@search::VARCHAR[])
        END) 
    AND
        (CASE WHEN  @country_id::bigint=0 THEN TRUE ELSE a.countries_id = @country_id::bigint end) 
    AND
        (CASE WHEN  @states_id::bigint=0 THEN TRUE ELSE a.states_id = @states_id::bigint end)
    AND    -- location
        (CASE WHEN @city_id::bigint=0 THEN TRUE ELSE a.cities_id= @city_id::bigint END)
    AND
        (CASE WHEN @communities_id::bigint=0 THEN TRUE ELSE a.communities_id= @communities_id::bigint END)
    AND
        (CASE WHEN @sub_communities_id::bigint=0 THEN TRUE ELSE a.sub_communities_id= @sub_communities_id::bigint END)
    AND
        (CASE WHEN @property_map_location_id::bigint=0 THEN TRUE ELSE a.property_map_location_id= @property_map_location_id::bigint END)
    -- facts start
    AND
        (CASE WHEN @completion_status::bigint IS NULL THEN
            TRUE
        WHEN @completion_status::bigint = 0 THEN
            TRUE
        ELSE
            (p.facts->>'completion_status')::bigint = @completion_status::bigint
        END)
    AND
        (case  WHEN @is_leased::bool= false then true else (p.facts->>'roi')::bool = @is_leased::bool end)
    AND
        (CASE WHEN @is_exclusive::bool IS NULL OR @is_exclusive::bool = false THEN true ELSE pv.exclusive = @is_exclusive::bool END)
    AND
        (case  WHEN @is_investment::bool= false then true else (pv.facts->>'investment')::bool = @is_investment::bool end)
    AND
    (CASE WHEN @min_completion_percentage::float IS NULL THEN
            TRUE
        WHEN @min_completion_percentage::float = 0.0 THEN
            TRUE
        ELSE
            (p.facts->>'completion_percentage')::float >= @min_completion_percentage::float
        END
        AND
        CASE WHEN @max_completion_percentage::float IS NULL THEN
            TRUE
        WHEN @max_completion_percentage::float = 0.0 THEN
            TRUE
        ELSE
            (p.facts->>'completion_percentage')::float <= @max_completion_percentage::float
        END)
     AND
        (CASE WHEN ARRAY_LENGTH(@rent_type::bigint[], 1) IS NULL THEN TRUE ELSE  (pv.facts->>'rent_type')::bigint = ANY(@rent_type::bigint[]) END)
    AND
        (CASE WHEN @handover_date::timestamp IS NULL THEN TRUE ELSE (p.facts->>'handover_date')::timestamp = @handover_date::timestamp END)
    AND
        (CASE WHEN @completion_date::timestamp IS NULL THEN TRUE ELSE (p.facts->>'completion_date')::timestamptz = @completion_date::timestamp END)
    AND
        (CASE WHEN ARRAY_LENGTH(@service_charge::bigint[], 1) IS NULL THEN TRUE ELSE  (p.facts->>'service_charge')::bigint = ANY(@service_charge::bigint[]) END)
    AND
        (CASE WHEN ARRAY_LENGTH(@bedroom::VARCHAR[], 1) IS NULL THEN TRUE ELSE (p.facts->>'bedroom')::varchar = ANY(@bedroom::VARCHAR[]) END)
    AND
        (CASE WHEN ARRAY_LENGTH(@bathroom::bigint[], 1) IS NULL THEN TRUE ELSE (p.facts->>'bathroom')::bigint = ANY(@bathroom::bigint[]) END)
    AND
        (CASE WHEN ARRAY_LENGTH(@no_of_floor::bigint[], 1) IS NULL THEN TRUE ELSE (p.facts->>'no_of_floor')::bigint = ANY(@no_of_floor::bigint[]) END)   
    AND
        (CASE WHEN ARRAY_LENGTH(@furnished::bigint[], 1) IS NULL THEN TRUE ELSE (p.facts->>'furnished')::bigint = ANY(@furnished::bigint[]) END)
    AND
        (CASE WHEN ARRAY_LENGTH(@ownership::bigint[], 1) IS NULL THEN TRUE ELSE (p.facts->>'ownership')::bigint = ANY(@ownership::bigint[]) END)
    AND
        (CASE WHEN ARRAY_LENGTH(@parking::bigint[], 1) IS NULL THEN TRUE ELSE (p.facts->>'parking')::bigint = ANY(@parking::bigint[]) END)
    AND -- build up area
        (CASE WHEN @min_built_up_area::float IS NULL THEN
            TRUE
        WHEN @min_built_up_area::float = 0.0 THEN
            TRUE
        ELSE
            (p.facts->>'built_up_area')::float >= @min_built_up_area::float
        END
        AND
        CASE WHEN @max_built_up_area::float IS NULL THEN
            TRUE
        WHEN @max_built_up_area::float = 0.0 THEN
            TRUE
        ELSE
            (p.facts->>'built_up_area')::float <= @max_built_up_area::float
        END)    
    AND -- plot area
    (CASE WHEN @min_plot_area::float IS NULL THEN
                TRUE
            WHEN @min_plot_area::float = 0.0 THEN
                TRUE
            ELSE
                (p.facts->>'plot_area')::float >= @min_plot_area::float
            END
            -- max plot area
            AND CASE WHEN @max_plot_area::float IS NULL THEN
                TRUE
            WHEN @max_plot_area::float = 0.0 THEN
                TRUE
            ELSE
                (p.facts->>'plot_area')::float <= @max_plot_area::float
            END)
    AND 
        (CASE WHEN @min_price::float IS NULL THEN
                TRUE
            WHEN @min_price::float = 0.0 THEN
                TRUE
            ELSE
                (p.facts->>'price')::float >= @min_price::float
            END
            -- max plot area
            AND CASE WHEN @max_price::float IS NULL THEN
                TRUE
            WHEN  @max_price::float = 0.0 THEN
                TRUE
            ELSE
                (p.facts->>'price')::float <=  @max_price::float
            END)
    AND 
    (pma1.media IS NOT NULL OR pma2.media IS NOT NULL)
    AND
       CASE 
        -- If media parameter is empty, return TRUE (so it matches all rows)
        WHEN ARRAY_LENGTH(@media::BIGINT[], 1) IS NULL THEN TRUE
        ELSE EXISTS (
            SELECT pt
            FROM unnest(COALESCE(pma1.media, pma2.media)) AS pt
            WHERE EXISTS (
                SELECT 1
                FROM unnest(@media::BIGINT[]) AS search_terms
                WHERE pt = search_terms
            )
        )
        END;