
-- name: LatestFilterUnitsCount :one
WITH facilities_and_amenities AS(
    SELECT uv.id,
    fa."type",
    array_agg(DISTINCT coalesce(fae.facility_amenity_id,0))::bigint[] AS facilities_amenities
    FROM unit_versions uv
    JOIN units u on u.id=uv.unit_id
    LEFT JOIN facilities_amenities_entity fae ON fae.entity_id=u.id AND fae.entity_type_id= 5::bigint
    LEFT JOIN facilities_amenities fa ON fae.facility_amenity_id=fa.id 
    group by uv.id, fa."type" 
),
unit_media_agg AS (
    SELECT
        entity_id,entity_type_id,
        array_agg(DISTINCT media_type ORDER BY media_type) AS media
    FROM 
        global_media
    WHERE global_media.entity_type_id = @unit_entity_type::bigint
    OR global_media.entity_type_id = @unitversions_entity_type::bigint
    GROUP BY 
        entity_id,entity_type_id
),
MinDates AS (
    SELECT 
    	unit_versions.id as unit_id,
        plan_installments.payment_plans,
        MIN(plan_installments."date") AS earliest_date
    FROM 
        unit_versions
    JOIN 
        payment_plans_packages 
        ON payment_plans_packages.entity_id = unit_versions.id 
        AND payment_plans_packages.entity_type_id = @unitversions_entity_type::bigint
    JOIN 
        plan_installments 
        ON plan_installments.payment_plans = ANY(payment_plans_packages.payment_plans_id)
    GROUP BY 
        plan_installments.payment_plans,unit_versions.id
),
downpayment as(
    SELECT 
        unit_versions.id as unit_id, 
        ARRAY_AGG(plan_installments.percentage) as percentages
    FROM unit_versions
    LEFT JOIN MinDates ON  MinDates.unit_id=unit_versions.id
    left JOIN 
        plan_installments 
        ON plan_installments.payment_plans = MinDates.payment_plans 
        AND plan_installments."date" = MinDates.earliest_date
    group by unit_versions.id
),
DesiredCountries as (
    SELECT unit_versions.id AS unit_id,ARRAY_AGG(addresses.countries_id) AS "countries" FROM unit_versions 
    JOIN swap_requirement ON swap_requirement.entity_id=unit_versions.id AND swap_requirement.entity_type= @unitversions_entity_type::BIGINT
    JOIN swap_requirment_address ON swap_requirment_address.swap_requirment_id=swap_requirement.id
    JOIN addresses ON addresses.id=swap_requirment_address.addresses_id
    WHERE unit_versions."type"= 3
    GROUP BY unit_versions.id
)
SELECT
count(uv.id)
FROM unit_versions uv
JOIN units u on u.id=uv.unit_id
JOIN unit_type ut on ut.id=u.unit_type_id
JOIN addresses a on u.addresses_id=a.id
LEFT JOIN states ON a.states_id= states.id
LEFT JOIN cities ci ON a.cities_id = ci.id
LEFT JOIN communities com ON a.communities_id = com.id
LEFT JOIN sub_communities subcom ON a.sub_communities_id = subcom.id
join unit_media_agg on (
	case WHEN uv.has_gallery is null OR uv.has_gallery=FALSE then unit_media_agg.entity_id=u.id and unit_media_agg.entity_type_id= @unit_entity_type::bigint 
	ELSE  unit_media_agg.entity_id=uv.id and unit_media_agg.entity_type_id= @unitversions_entity_type::BIGINT END)
left join downpayment ON downpayment.unit_id = uv.id
LEFT JOIN facilities_and_amenities f ON f.id=uv.id AND f."type"=1
LEFT JOIN facilities_and_amenities am ON am.id=uv.id AND am."type"=2
LEFT JOIN property p ON p.id=u.entity_id AND u.entity_type_id= @property_entity_type::bigint
JOIN company_users cu ON cu.users_id=uv.listed_by
JOIN users ON users.id=cu.users_id
LEFT JOIN DesiredCountries ON DesiredCountries.unit_id=uv.id AND 3 = ANY(@category::bigint[])
WHERE

    (CASE WHEN ARRAY_LENGTH(@views::bigint[], 1) IS NULL THEN TRUE ELSE (string_to_array(trim(both '[]' from u.facts->>'views'), ',')::BIGINT[]) &&  @views::BIGINT[] END)
    AND
        (CASE WHEN  ARRAY_LENGTH(@broker_company_id::bigint [], 1) IS NULL THEN TRUE ELSE cu.company_id= ANY(@broker_company_id::bigint []) END) AND users.status=2
    AND
        (CASE WHEN @property_id::bigint=0 THEN TRUE ELSE p.id= @property_id::bigint END)
    AND
        (ARRAY_LENGTH(@unit_usage::BIGINT[], 1) IS NULL OR ut."usage" = ANY(@unit_usage::BIGINT[])) -- commercial, residential, agricultural, industrial
    AND 
        (ARRAY_LENGTH(@category::BIGINT[], 1) IS NULL OR uv."type" = ANY(@category::BIGINT[])) -- rent sale swap
    AND 
        (case WHEN (ARRAY_LENGTH(@desired_countries::bigint[],1)) is null then true else DesiredCountries.countries && @desired_countries::bigint[] end)
    AND
    	(case WHEN @life_style::BIGINT= 0 then true else (uv.facts->>'life_style')::BIGINT= @life_style::BIGINT end)
    AND
        (ARRAY_LENGTH( @unit_rank::bigint[], 1) IS NULL OR uv.unit_rank = ANY(@unit_rank::bigint[]))
    AND
      uv.status  not in (1,6,5)
    AND
    -- listed by company
        (CASE WHEN ARRAY_LENGTH(@developer_company_id::bigint [], 1) IS NULL THEN TRUE ELSE u.company_id= ANY(@developer_company_id::bigint []) END)
    AND
    -- listed by agent
        (CASE WHEN  ARRAY_LENGTH(@agent_id::bigint [],1) is null THEN TRUE ELSE uv.listed_by= ANY(@agent_id::bigint []) END)
    AND
        (case WHEN @downpayment::VARCHAR= '' then true else @downpayment= any(downpayment.percentages) END)
    AND
    (CASE WHEN @hotdeal::bool IS NULL OR @hotdeal::bool = false THEN true ELSE uv.is_hotdeal = @hotdeal::bool END)
    AND
    (CASE WHEN @is_verified::bool IS NULL OR @is_verified::bool = false THEN true ELSE uv.is_verified = @is_verified::bool END)
    AND
        -- from unit type table
        (CASE WHEN @unit_types::bigint= 0 THEN TRUE ELSE u.unit_type_id = @unit_types::bigint END)  
    AND
        (case WHEN @unit_no::varchar='' then true else  u.unit_no = @unit_no::varchar AND  u.unitno_is_public = TRUE end )
    
    AND
        (CASE WHEN @ref_no::varchar='' THEN TRUE ELSE uv.ref_no = @ref_no::varchar END)
    AND
        (CASE WHEN ARRAY_LENGTH(@keywords::VARCHAR[], 1) IS NULL --keywords
        THEN TRUE ELSE
        uv.title ILIKE ANY(@keywords::VARCHAR[])
        OR uv.ref_no ILIKE ANY(@keywords::VARCHAR[])
        OR uv.description ILIKE ANY(@keywords::VARCHAR[])
        OR states."state" ILIKE ANY(@keywords::VARCHAR[])
        OR ci.city ILIKE ANY(@keywords::VARCHAR[])
        OR com.community ILIKE ANY(@keywords::VARCHAR[])
        OR subcom.sub_community ILIKE ANY(@keywords::VARCHAR[])
        OR ut."type" ILIKE ANY(@keywords::VARCHAR[])
        END)
    AND
        (CASE WHEN  @country_id::bigint=0 THEN TRUE ELSE a.countries_id = @country_id::bigint end) 
    AND
        (CASE WHEN  @state_id::bigint=0 THEN TRUE ELSE a.states_id = @state_id::bigint end) 
    AND   -- location
        (CASE WHEN @city_id::bigint=0 THEN TRUE ELSE a.cities_id= @city_id::bigint END)
        AND
        (CASE WHEN @communities_id::bigint=0 THEN TRUE ELSE a.communities_id= @communities_id::bigint END)
        AND
        (CASE WHEN @sub_communities_id::bigint=0 THEN TRUE ELSE a.sub_communities_id= @sub_communities_id::bigint END)
        AND
        (CASE WHEN @property_map_location_id::bigint=0 THEN TRUE ELSE a.property_map_location_id= @property_map_location_id::bigint END)
    --FACTS STUFF--
     AND
       (CASE WHEN ARRAY_LENGTH(@rent_type::bigint[], 1) IS NULL THEN TRUE ELSE  (uv.facts->>'rent_type')::bigint = ANY(@rent_type::bigint[]) END)
    AND
        (CASE WHEN @completion_status::bigint IS NULL THEN
            TRUE
        WHEN @completion_status::bigint = 0 THEN
            TRUE
        ELSE
            (u.facts->>'completion_status')::bigint = @completion_status::bigint
        END)
    AND
        (case  WHEN @is_leased::bool = false then true else (u.facts->>'roi')::bool = @is_leased::bool end)
    AND
        (CASE WHEN @is_exclusive::bool IS NULL OR @is_exclusive::bool = false THEN true ELSE uv.exclusive = @is_exclusive::bool END)
    AND
         (case  WHEN @is_investment::bool = false then true else (uv.facts->>'investment')::bool = @is_investment::bool end)
    AND
        (CASE WHEN ARRAY_LENGTH(@no_of_floor::bigint[], 1) IS NULL THEN TRUE ELSE (u.facts->>'no_of_floor')::bigint = ANY(@no_of_floor::bigint[]) END)
    AND

    (CASE WHEN @min_completion_percentage::float IS NULL THEN
            TRUE
        WHEN @min_completion_percentage::float = 0.0 THEN
            TRUE
        ELSE
            (u.facts->>'completion_percentage')::float >= @min_completion_percentage::float
        END
        AND
        CASE WHEN @max_completion_percentage::float IS NULL THEN
            TRUE
        WHEN @max_completion_percentage::float = 0.0 THEN
            TRUE
        ELSE
            (u.facts->>'completion_percentage')::float <= @max_completion_percentage::float
        END)
    AND
        (CASE WHEN @handover_date::timestamp IS NULL THEN TRUE ELSE (u.facts->>'handover_date')::timestamp = @handover_date::timestamp END)
    AND
        (CASE WHEN @completion_date::timestamp IS NULL THEN TRUE ELSE (u.facts->>'completion_date')::timestamptz = @completion_date::timestamp END)
    AND
        (CASE WHEN ARRAY_LENGTH(@service_charge::bigint[], 1) IS NULL THEN TRUE ELSE  (u.facts->>'service_charge')::bigint = ANY(@service_charge::bigint[]) END)
    AND
        (CASE WHEN ARRAY_LENGTH(@bedroom::VARCHAR[], 1) IS NULL THEN TRUE ELSE (u.facts->>'bedroom')::varchar = ANY(@bedroom::VARCHAR[]) END)
    AND
        (CASE WHEN ARRAY_LENGTH(@bathroom::bigint[], 1) IS NULL THEN TRUE ELSE (u.facts->>'bathroom')::bigint = ANY(@bathroom::bigint[]) END)
    AND
        (CASE WHEN ARRAY_LENGTH(@furnished::bigint[], 1) IS NULL THEN TRUE ELSE (u.facts->>'furnished')::bigint = ANY(@furnished::bigint[]) END)
    AND
        (CASE WHEN ARRAY_LENGTH(@ownership::bigint[], 1) IS NULL THEN TRUE ELSE (u.facts->>'ownership')::bigint = ANY(@ownership::bigint[]) END)
    AND
        (CASE WHEN ARRAY_LENGTH(@parking::bigint[], 1) IS NULL THEN TRUE ELSE (u.facts->>'parking')::bigint = ANY(@parking::bigint[]) END)
    AND -- build up area
        (CASE WHEN @min_built_up_area::float IS NULL THEN
            TRUE
        WHEN @min_built_up_area::float = 0.0 THEN
            TRUE
        ELSE
            (u.facts->>'built_up_area')::float >= @min_built_up_area::float
        END
        AND
        CASE WHEN @max_built_up_area::float IS NULL THEN
            TRUE
        WHEN @max_built_up_area::float = 0.0 THEN
            TRUE
        ELSE
            (u.facts->>'built_up_area')::float <= @max_built_up_area::float
        END)    
    AND -- plot area
    (CASE WHEN @min_plot_area::float IS NULL THEN
                TRUE
            WHEN @min_plot_area::float = 0.0 THEN
                TRUE
            ELSE
                (u.facts->>'plot_area')::float >= @min_plot_area::float
            END
            -- max plot area
            AND CASE WHEN @max_plot_area::float IS NULL THEN
                TRUE
            WHEN @max_plot_area::float = 0.0 THEN
                TRUE
            ELSE
                (u.facts->>'plot_area')::float <= @max_plot_area::float
            END)
    AND
            (CASE WHEN @min_price::float IS NULL THEN
                TRUE
            WHEN @min_price::float = 0.0 THEN
                TRUE
            ELSE
                (uv.facts->>'price')::float >= @min_price::float
            END
            -- max plot area
            AND CASE WHEN @max_price::float IS NULL THEN
                TRUE
            WHEN  @max_price::float = 0.0 THEN
                TRUE
            ELSE
                (uv.facts->>'price')::float <=  @max_price::float
            END)
    AND
            (CASE WHEN @min_unit_area::bigint IS NULL THEN
                TRUE
            WHEN @min_unit_area::bigint = 0.0 THEN
                TRUE
            ELSE
                (u.facts->>'unit_area')::bigint >= @min_unit_area::bigint
            END
            -- max plot area
            AND CASE WHEN @max_unit_area::bigint IS NULL THEN
                TRUE
            WHEN  @max_unit_area::bigint = 0.0 THEN
                TRUE
            ELSE
                (u.facts->>'unit_area')::bigint <=  @max_unit_area::bigint
            END)
    -- media
    AND (
        CASE 
            -- If property_type is empty, return TRUE (so it matches all rows)
            WHEN ARRAY_LENGTH(@media::BIGINT[], 1) IS NULL THEN TRUE
            ELSE EXISTS (
                SELECT pt
                FROM unnest(unit_media_agg.media) AS pt
                WHERE EXISTS (
                    SELECT 1
                    FROM unnest(@media::BIGINT[]) AS search_terms
                    WHERE pt = search_terms
                )
            )
        END
    )
    AND (-- facilities
        array_length(@facilities::bigint[], 1) IS NULL
        OR f.facilities_amenities::bigint[] && @facilities::bigint[]
    )
    AND (--  amenities
        array_length(@amenities::bigint[], 1) IS NULL
        OR am.facilities_amenities::bigint[] && @amenities::bigint[]
    );