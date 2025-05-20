-- name: FilterProjects :many
WITH property_types_agg AS (
    SELECT 
        property.entity_id,
        array_agg(gpt.id ORDER BY gpt.id) AS property_types  -- Assuming `type` is the column in `global_property_type`
    FROM 
        property
    LEFT JOIN 
        global_property_type gpt ON gpt.id = property.property_type_id  -- Join to get the global_property_type
    WHERE 
        property.entity_type_id = 1  -- Assuming 1 indicates a project-related entity
    GROUP BY 
        property.entity_id
),
project_properties_agg AS (
    SELECT
        properties_with_types.entity_id, 
        array_agg(property_types ORDER BY property_types) AS property_types_agg
    FROM (
        SELECT
            property.entity_id,
            global_property_type."type" AS property_types
        FROM
            property
        LEFT JOIN
            global_property_type ON global_property_type.id = property.property_type_id
    ) AS properties_with_types
    GROUP BY
        properties_with_types.entity_id
),
 project_media_agg AS (
    SELECT
        projects_id,
        array_agg(DISTINCT media_type ORDER BY media_type) AS media
    FROM 
        project_media
    GROUP BY 
        projects_id
),
project_reviews AS (
    SELECT projects_id, 
    ROUND(
        (CAST(AVG(project_clean) AS numeric) + 
         CAST(AVG(project_location) AS numeric) + 
         CAST(AVG(project_facilities) AS numeric) + 
         CAST(AVG(project_securities) AS numeric)) / 4.0, 
        2
    ) AS average_rating
    FROM project_reviews
    GROUP BY projects_id
)
SELECT 
    projects.*,
	property_types_agg.property_types,
    -- properties_facts.starting_price,
	project_properties_agg.property_types_agg,
	project_media_agg.media,
    COALESCE(NULLIF((projects.facts->>'starting_price')::bigint, NULL), 0) AS starting_price,
	COALESCE(project_reviews.average_rating, 0.0)::float AS average_rating
FROM
    projects  
-- LEFT JOIN
--     companies ON projects.developer_companies_id = companies.id
LEFT JOIN
    addresses ON projects.addresses_id = addresses.id
LEFT JOIN
    cities ON addresses.cities_id = cities.id
LEFT JOIN
    communities ON addresses.communities_id = communities.id
LEFT JOIN
    sub_communities ON addresses.sub_communities_id = sub_communities.id
LEFT JOIN 
    property_types_agg ON projects.id = property_types_agg.entity_id
LEFT JOIN 
    project_properties_agg ON projects.id = project_properties_agg.entity_id
LEFT JOIN 
    project_media_agg ON projects.id = project_media_agg.projects_id
LEFT JOIN 
    project_reviews ON project_reviews.projects_id = projects.id
WHERE

    addresses.countries_id = @country_id::bigint
    
	--         -- city
	AND cities.city ILIKE @city::varchar
    -- AND (CASE WHEN @developer_companies_id::bigint IS NULL THEN
	-- 	TRUE
	-- WHEN @developer_companies_id::bigint = 0 THEN
	-- 	TRUE
	-- ELSE
	-- 	projects.developer_companies_id = @developer_companies_id::bigint
	-- END)
	--project Type
	-- AND CASE
    --     -- If @property_type is NULL, we skip the filter and return all results
    --     WHEN @property_type::text[] IS NULL THEN TRUE
    --     -- Otherwise, check if any element in project_properties_agg.property_types_agg matches @property_type
    --     ELSE EXISTS (
    --         SELECT 1
    --         FROM unnest(project_properties_agg.property_types_agg) AS pt
    --         WHERE EXISTS (
    --             SELECT 1
    --             FROM unnest(@property_type::text[]) AS search_terms
    --             WHERE pt ILIKE '%' || search_terms || '%'
    --         )
    --     )
    -- END
-- 	AND CASE 
--     WHEN @property_type::text[] IS NULL THEN TRUE
--     ELSE EXISTS (
--         SELECT 1
--         FROM unnest(project_properties_agg.property_types_agg) AS pt
--         WHERE EXISTS (
--             SELECT 1
--             FROM unnest(@property_type::text[]) AS search_terms
--             WHERE pt ILIKE '%' || search_terms || '%'
--         )
--     )
-- END
	-- -- date posted
	-- AND (CASE
    --     WHEN @date_filter::bigint = 1 THEN DATE(projects.created_at) = CURRENT_DATE
    --     WHEN @date_filter::bigint = 2 THEN projects.created_at >= CURRENT_DATE - INTERVAL '7 DAY' 
    --     WHEN @date_filter::bigint = 3 THEN projects.created_at >= CURRENT_DATE - INTERVAL '1 month'
	-- 	WHEN @date_filter::bigint = 4 THEN projects.created_at >= CURRENT_DATE - INTERVAL '6 month'
    --     -- Add more cases for additional filters
    --     ELSE TRUE
    -- END)
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
    CAST(projects.facts ->> 'completion_status' AS bigint) = @completion_status::bigint
	END
	 -- ownership
	   AND (
    ARRAY_LENGTH(@ownership::bigint[], 1) IS NULL
    OR CAST(projects.facts ->> 'ownership' AS bigint) = ANY (@ownership::bigint[])
   )
		--  	     --  service charges
	 AND (
    CASE
        WHEN @min_service_charges::bigint IS NULL THEN
            TRUE
        WHEN @min_service_charges::bigint = 0 THEN
            TRUE
        ELSE
            CAST(projects.facts ->> 'service_charge' AS bigint) >= @min_service_charges::bigint
    END
    -- max service charges
    AND CASE
        WHEN @max_service_charges::bigint IS NULL THEN
            TRUE
        WHEN @max_service_charges::bigint = 0 THEN
            TRUE
        ELSE
            CAST(projects.facts ->> 'service_charge' AS bigint) <= @max_service_charges::bigint
    END
)

	--  	     --  furnishing
    AND(ARRAY_LENGTH(@furnished::bigint [],
			1) IS NULL
		OR CAST(projects.facts ->> 'furnished' AS bigint) = ANY (@furnished::bigint[])) -- properties_facts.furnished = ANY (@furnished::bigint []))
	--  amenities
	AND(
		CASE WHEN ARRAY_LENGTH(@amenities::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			projects.amenities_id && @amenities::bigint []
		END)
    --  facilities
	AND(
		CASE WHEN ARRAY_LENGTH(@facilities::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			projects.facilities_id && @facilities::bigint []
		END)
	--  unit views
    AND (
    CASE
        WHEN ARRAY_LENGTH(@views::bigint[], 1) IS NULL THEN
            TRUE
        ELSE
            -- Extracting 'view' from JSONB and converting it to an array of bigint for comparison
            (SELECT array_agg(CAST(value AS bigint))
             FROM jsonb_array_elements_text(projects.facts->'views')) && @views::bigint[]
    END
)
	-- media
	AND(@media::bigint = 0
		OR(array_length(media,
				@image_url) IS NOT NULL)
		OR(array_length(media,
				@image360_url) IS NOT NULL)
		OR(array_length(media,
				@video_url) IS NOT NULL)
		OR(array_length(media,
				@panaroma_url) IS NOT NULL))

	---------------------- from here normal project section --------------------------
	AND(ARRAY_LENGTH(@project_rank::bigint [], 1) IS NULL
	OR projects.project_rank = ANY (@project_rank::bigint []))
	AND(communities.community ILIKE @community::varchar OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS null OR projects.is_verified = @is_verified::bool)
    AND (
        projects.project_name ILIKE @search::varchar
        OR cities.city ILIKE @search::varchar
        OR communities.community ILIKE @search::varchar
        OR sub_communities.sub_community ILIKE @search::varchar
    )
    AND projects.status != 5 AND projects.status != 6 --AND companies.status != 6
	ORDER BY
   CASE 
        WHEN @rank::bigint = 3 THEN COALESCE(NULLIF((projects.facts->>'starting_price')::bigint, NULL), 0)
    END DESC,
    CASE 
        WHEN @rank::bigint = 4 THEN COALESCE(NULLIF((projects.facts->>'starting_price')::bigint, NULL), 0)
    END ASC,
CASE 
    WHEN @rank::bigint = 2 THEN projects.created_at
    END DESC,
CASE 
    WHEN @rank::bigint = 1 THEN COALESCE(average_rating, 0.0) 
    END DESC,
	project_rank DESC,
	is_verified DESC,
	RANDOM()
   LIMIT $1 OFFSET $2;



-- name: FilterCountProjects :one
WITH property_types_agg AS (
    SELECT 
        property.entity_id,
        array_agg(gpt.type ORDER BY gpt.type) AS property_types  -- Assuming `type` is the column in `global_property_type`
    FROM 
        property
    LEFT JOIN 
        global_property_type gpt ON gpt.id = property.property_type_id  -- Join to get the global_property_type
    WHERE 
        property.entity_type_id = 1  -- Assuming 1 indicates a project-related entity
    GROUP BY 
        property.entity_id
),
project_properties_agg AS (
    SELECT
        properties_with_types.entity_id, 
        array_agg(property_types ORDER BY property_types) AS property_types_agg
    FROM (
        SELECT
            property.entity_id,
            global_property_type."type" AS property_types
        FROM
            property
        LEFT JOIN
            global_property_type ON global_property_type.id = property.property_type_id
    ) AS properties_with_types
    GROUP BY
        properties_with_types.entity_id
),
project_media_agg AS (
    SELECT
        projects_id,
        array_agg(DISTINCT media_type ORDER BY media_type) AS media
    FROM 
        project_media
    GROUP BY 
        projects_id
)
SELECT 
   count(projects.*)
FROM
    projects  
LEFT JOIN
    addresses ON projects.addresses_id = addresses.id
-- LEFT JOIN
--     companies ON projects.developer_companies_id = companies.id
LEFT JOIN
    cities ON addresses.cities_id = cities.id
LEFT JOIN
    communities ON addresses.communities_id = communities.id
LEFT JOIN
    sub_communities ON addresses.sub_communities_id = sub_communities.id
LEFT JOIN 
    property_types_agg ON projects.id = property_types_agg.entity_id
LEFT JOIN 
    project_properties_agg ON projects.id = project_properties_agg.entity_id
LEFT JOIN 
    project_media_agg ON projects.id = project_media_agg.projects_id
WHERE
    addresses.countries_id = @country_id::bigint
	--         -- city
	AND cities.city ILIKE @city::varchar
    -- AND CASE WHEN @developer_companies_id::bigint IS NULL THEN
	-- 	TRUE
	-- WHEN @developer_companies_id::bigint = 0 THEN
	-- 	TRUE
	-- ELSE
	-- 	projects.developer_companies_id = @developer_companies_id::bigint
	-- END
	--project Type
-- 	AND CASE 
--     WHEN @property_type::text[] IS NULL THEN TRUE
--     ELSE EXISTS (
--         SELECT 1
--         FROM unnest(project_properties_agg.property_types_agg) AS pt
--         WHERE EXISTS (
--             SELECT 1
--             FROM unnest(@property_type::text[]) AS search_terms
--             WHERE pt ILIKE '%' || search_terms || '%'
--         )
--     )
-- END
	-- -- date posted
	-- AND (CASE
    --     WHEN @date_filter::bigint = 1 THEN DATE(projects.created_at) = CURRENT_DATE
    --     WHEN @date_filter::bigint = 2 THEN projects.created_at >= CURRENT_DATE - INTERVAL '7 DAY' 
    --     WHEN @date_filter::bigint = 3 THEN projects.created_at >= CURRENT_DATE - INTERVAL '1 month'
	-- 	WHEN @date_filter::bigint = 4 THEN projects.created_at >= CURRENT_DATE - INTERVAL '6 month'
    --     -- Add more cases for additional filters
    --     ELSE TRUE
    -- END)
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
    CAST(projects.facts ->> 'completion_status' AS bigint) = @completion_status::bigint
	END
	 -- ownership
	   AND (
    ARRAY_LENGTH(@ownership::bigint[], 1) IS NULL
    OR CAST(projects.facts ->> 'ownership' AS bigint) = ANY (@ownership::bigint[])
   )
		--  	     --  service charges
	 AND (
    CASE
        WHEN @min_service_charges::bigint IS NULL THEN
            TRUE
        WHEN @min_service_charges::bigint = 0 THEN
            TRUE
        ELSE
            CAST(projects.facts ->> 'service_charge' AS bigint) <= @min_service_charges::bigint
    END
    -- max service charges
    AND CASE
        WHEN @max_service_charges::bigint IS NULL THEN
            TRUE
        WHEN @max_service_charges::bigint = 0 THEN
            TRUE
        ELSE
            CAST(projects.facts ->> 'service_charge' AS bigint) >= @max_service_charges::bigint
    END
)

	--  	     --  furnishing
    AND(ARRAY_LENGTH(@furnished::bigint [],
			1) IS NULL
		OR CAST(projects.facts ->> 'furnished' AS bigint) = ANY (@furnished::bigint[])) -- properties_facts.furnished = ANY (@furnished::bigint []))
	--  amenities
	AND(
		CASE WHEN ARRAY_LENGTH(@amenities::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			projects.amenities_id && @amenities::bigint []
		END)
    --  facilities
	AND(
		CASE WHEN ARRAY_LENGTH(@facilities::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			projects.facilities_id && @facilities::bigint []
		END)
	--  unit views
    AND (
    CASE
        WHEN ARRAY_LENGTH(@views::bigint[], 1) IS NULL THEN
            TRUE
        ELSE
            -- Extracting 'view' from JSONB and converting it to an array of bigint for comparison
            (SELECT array_agg(CAST(value AS bigint))
             FROM jsonb_array_elements_text(projects.facts->'views')) && @views::bigint[]
    END
)
	-- media
	AND(@media::bigint = 0
		OR(array_length(media,
				@image_url) IS NOT NULL)
		OR(array_length(media,
				@image360_url) IS NOT NULL)
		OR(array_length(media,
				@video_url) IS NOT NULL)
		OR(array_length(media,
				@panaroma_url) IS NOT NULL))

	---------------------- from here normal project section --------------------------
	AND(ARRAY_LENGTH(@project_rank::bigint [], 1) IS NULL
	OR projects.project_rank = ANY (@project_rank::bigint []))
	AND(communities.community ILIKE @community::varchar OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS null OR projects.is_verified = @is_verified::bool)
    AND (
        projects.project_name ILIKE @search::varchar
        OR cities.city ILIKE @search::varchar
        OR communities.community ILIKE @search::varchar
        OR sub_communities.sub_community ILIKE @search::varchar
    )
    AND projects.status != 5 AND projects.status != 6; --AND companies.status != 6;
    -- AND properties_facts.starting_price = min_starting_prices.min_starting_price;



-- name: GetAllProjectPropertiesByProjectIdAndPropertyTypesId :many
SELECT 
    pp.id, 
    pp.property_name,
    COALESCE(units.unit_count, 0) AS total_unit_count
FROM property pp
LEFT JOIN (
    SELECT units.entity_id, units.entity_type_id, units.is_project_unit, COUNT(*) AS unit_count
    FROM units
    WHERE units.entity_type_id = 3
    GROUP BY units.entity_id, units.entity_type_id, units.is_project_unit
) units ON pp.id = units.entity_id AND units.is_project_unit = true
WHERE pp.entity_id = $1 
  AND pp.entity_type_id = $2
  AND pp.property_type_id = $3::bigint;

-- name: GetAllProjectPropertiesByProjectIdAndPropertyTypesIdAnsPhaseId :many
SELECT pp.id, 
       pp.property_name,
       COALESCE(units.unit_count, 0) AS total_unit_count
FROM property pp
LEFT JOIN (
    SELECT units.entity_id, units.entity_type_id, units.is_project_unit, COUNT(*) AS unit_count
    FROM units
    GROUP BY units.entity_id, units.entity_type_id, units.is_project_unit
) units ON pp.id = units.entity_id AND units.is_project_unit = true
WHERE pp.entity_id = $1
AND pp.entity_type_id = $2
AND pp.property_type_id = @property_type_id::bigint;

-- name: GetAllPhasesByProjectGraph :many
SELECT
	phases.*
FROM
	phases
   LEFT JOIN projects ON projects.id = phases.projects_id
WHERE
	 projects.id = $3 AND (phases.status != 5 AND phases.status != 6)
ORDER BY
	phases.created_at DESC
LIMIT $1 OFFSET $2;


-- name: GetAllProjectPropertiesByProjectIdAndPhaseId :many
SELECT * from property
Where property.entity_id = $1 AND property.entity_type_id = 2 LIMIT $2 OFFSET $3;

-- name: FilterCountProjectsState :one
WITH property_types_agg AS (
    SELECT 
        property.entity_id,
        array_agg(gpt.id ORDER BY gpt.id) AS property_types  -- Assuming `type` is the column in `global_property_type`
    FROM 
        property
    LEFT JOIN 
        global_property_type gpt ON gpt.id = property.property_type_id  -- Join to get the global_property_type
    WHERE 
        property.entity_type_id = 1  -- Assuming 1 indicates a project-related entity
    GROUP BY 
        property.entity_id
),
project_properties_agg AS (
    SELECT
        properties_with_types.entity_id, 
        array_agg(property_types ORDER BY property_types) AS property_types_agg
    FROM (
        SELECT
            property.entity_id,
            global_property_type."type" AS property_types
        FROM
            property
        LEFT JOIN
            global_property_type ON global_property_type.id = property.property_type_id
    ) AS properties_with_types
    GROUP BY
        properties_with_types.entity_id
),
project_media_agg AS (
    SELECT
        projects_id,
        array_agg(DISTINCT media_type ORDER BY media_type) AS media
    FROM 
        project_media
    GROUP BY 
        projects_id
)
SELECT 
   count(projects.*)
FROM
    projects  
LEFT JOIN
    addresses ON projects.addresses_id = addresses.id
LEFT JOIN
    cities ON addresses.cities_id = cities.id
LEFT JOIN
    companies ON projects.developer_companies_id = companies.id
LEFT JOIN
    communities ON addresses.communities_id = communities.id
LEFT JOIN
    sub_communities ON addresses.sub_communities_id = sub_communities.id
LEFT JOIN 
    property_types_agg ON projects.id = property_types_agg.entity_id
LEFT JOIN 
    project_properties_agg ON projects.id = project_properties_agg.entity_id
LEFT JOIN 
    project_media_agg ON projects.id = project_media_agg.projects_id
WHERE
     addresses.countries_id = @country_id::bigint  AND
     cities.id = @cities_id::bigint
     AND (CASE WHEN @developer_companies_id::bigint IS NULL THEN
		TRUE
	WHEN @developer_companies_id::bigint = 0 THEN
		TRUE
	ELSE
		projects.developer_companies_id = @developer_companies_id::bigint
	END)
--project Type
-- 	AND CASE 
--     WHEN @property_type::text[] IS NULL THEN TRUE
--     ELSE EXISTS (
--         SELECT 1
--         FROM unnest(project_properties_agg.property_types_agg) AS pt
--         WHERE EXISTS (
--             SELECT 1
--             FROM unnest(@property_type::text[]) AS search_terms
--             WHERE pt ILIKE '%' || search_terms || '%'
--         )
--     )
-- END
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
    CAST(projects.facts ->> 'completion_status' AS bigint) = @completion_status::bigint
	END
	 -- ownership
	   AND (
    ARRAY_LENGTH(@ownership::bigint[], 1) IS NULL
    OR CAST(projects.facts ->> 'ownership' AS bigint) = ANY (@ownership::bigint[])
   )
		--  	     --  service charges
	 AND (
    CASE
        WHEN @min_service_charges::bigint IS NULL THEN
            TRUE
        WHEN @min_service_charges::bigint = 0 THEN
            TRUE
        ELSE
            CAST(projects.facts ->> 'service_charge' AS bigint) <= @min_service_charges::bigint
    END
    -- max service charges
    AND CASE
        WHEN @max_service_charges::bigint IS NULL THEN
            TRUE
        WHEN @max_service_charges::bigint = 0 THEN
            TRUE
        ELSE
            CAST(projects.facts ->> 'service_charge' AS bigint) >= @max_service_charges::bigint
    END
)

	--  	     --  furnishing
    AND(ARRAY_LENGTH(@furnished::bigint [],
			1) IS NULL
		OR CAST(projects.facts ->> 'furnished' AS bigint) = ANY (@furnished::bigint[])) -- properties_facts.furnished = ANY (@furnished::bigint []))
	--  amenities
	AND(
		CASE WHEN ARRAY_LENGTH(@amenities::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			projects.amenities_id && @amenities::bigint []
		END)
    --  facilities
	AND(
		CASE WHEN ARRAY_LENGTH(@facilities::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			projects.facilities_id && @facilities::bigint []
		END)
	--  unit views
    AND (
    CASE
        WHEN ARRAY_LENGTH(@views::bigint[], 1) IS NULL THEN
            TRUE
        ELSE
            -- Extracting 'view' from JSONB and converting it to an array of bigint for comparison
            (SELECT array_agg(CAST(value AS bigint))
             FROM jsonb_array_elements_text(projects.facts->'views')) && @views::bigint[]
    END
)
	-- media
	AND(@media::bigint = 0
		OR(array_length(media,
				@image_url) IS NOT NULL)
		OR(array_length(media,
				@image360_url) IS NOT NULL)
		OR(array_length(media,
				@video_url) IS NOT NULL)
		OR(array_length(media,
				@panaroma_url) IS NOT NULL))

	---------------------- from here normal project section --------------------------
	AND(ARRAY_LENGTH(@project_rank::bigint [], 1) IS NULL
	OR projects.project_rank = ANY (@project_rank::bigint []))
	AND(communities.community ILIKE @community::varchar OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS null OR projects.is_verified = @is_verified::bool)
    AND (
        projects.project_name ILIKE @search::varchar
        OR cities.city ILIKE @search::varchar
        OR communities.community ILIKE @search::varchar
        OR sub_communities.sub_community ILIKE @search::varchar
    )
    AND projects.status != 5 AND projects.status != 6;-- AND companies.status != 6;

-- name: FilterCountProjectsCommunity :one
WITH property_types_agg AS (
    SELECT 
        property.entity_id,
        array_agg(gpt.id ORDER BY gpt.id) AS property_types  -- Assuming `type` is the column in `global_property_type`
    FROM 
        property
    LEFT JOIN 
        global_property_type gpt ON gpt.id = property.property_type_id  -- Join to get the global_property_type
    WHERE 
        property.entity_type_id = 1  -- Assuming 1 indicates a project-related entity
    GROUP BY 
        property.entity_id
),
project_properties_agg AS (
    SELECT
        properties_with_types.entity_id, 
        array_agg(property_types ORDER BY property_types) AS property_types_agg
    FROM (
        SELECT
            property.entity_id,
            global_property_type."type" AS property_types
        FROM
            property
        LEFT JOIN
            global_property_type ON global_property_type.id = property.property_type_id
    ) AS properties_with_types
    GROUP BY
        properties_with_types.entity_id
),
project_media_agg AS (
    SELECT
        projects_id,
        array_agg(DISTINCT media_type ORDER BY media_type) AS media
    FROM 
        project_media
    GROUP BY 
        projects_id
)
SELECT 
   count(projects.*)
    -- property_types_agg.property_types,
    -- properties_facts.starting_price 
FROM
    projects  
INNER JOIN
    addresses ON projects.addresses_id = addresses.id
LEFT JOIN
    cities ON addresses.cities_id = cities.id
LEFT JOIN
    companies ON projects.developer_companies_id = companies.id
LEFT JOIN
    communities ON addresses.communities_id = communities.id
LEFT JOIN
    sub_communities ON addresses.sub_communities_id = sub_communities.id
LEFT JOIN
    properties_facts ON projects.id = properties_facts.project_id and properties_facts.is_project_fact = true
LEFT JOIN 
    property_types_agg ON projects.id = property_types_agg.entity_id
LEFT JOIN 
    project_properties_agg ON projects.id = project_properties_agg.entity_id
LEFT JOIN 
    project_media_agg ON projects.id = project_media_agg.projects_id
WHERE
    addresses.cities_id = @cities_id AND
	addresses.communities_id = @communities_id::bigint
    AND (CASE WHEN @developer_companies_id::bigint IS NULL THEN
		TRUE
	WHEN @developer_companies_id::bigint = 0 THEN
		TRUE
	ELSE
		projects.developer_companies_id = @developer_companies_id::bigint
	END)
	--project Type
-- 	AND CASE 
--     WHEN @property_type::text[] IS NULL THEN TRUE
--     ELSE EXISTS (
--         SELECT 1
--         FROM unnest(project_properties_agg.property_types_agg) AS pt
--         WHERE EXISTS (
--             SELECT 1
--             FROM unnest(@property_type::text[]) AS search_terms
--             WHERE pt ILIKE '%' || search_terms || '%'
--         )
--     )
-- END
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
    CAST(projects.facts ->> 'completion_status' AS bigint) = @completion_status::bigint
	END
	 -- ownership
	   AND (
    ARRAY_LENGTH(@ownership::bigint[], 1) IS NULL
    OR CAST(projects.facts ->> 'ownership' AS bigint) = ANY (@ownership::bigint[])
   )
		--  	     --  service charges
	 AND (
    CASE
        WHEN @min_service_charges::bigint IS NULL THEN
            TRUE
        WHEN @min_service_charges::bigint = 0 THEN
            TRUE
        ELSE
            CAST(projects.facts ->> 'service_charge' AS bigint) <= @min_service_charges::bigint
    END
    -- max service charges
    AND CASE
        WHEN @max_service_charges::bigint IS NULL THEN
            TRUE
        WHEN @max_service_charges::bigint = 0 THEN
            TRUE
        ELSE
            CAST(projects.facts ->> 'service_charge' AS bigint) >= @max_service_charges::bigint
    END
)

	--  	     --  furnishing
    AND(ARRAY_LENGTH(@furnished::bigint [],
			1) IS NULL
		OR CAST(projects.facts ->> 'furnished' AS bigint) = ANY (@furnished::bigint[])) -- properties_facts.furnished = ANY (@furnished::bigint []))
	--  amenities
	AND(
		CASE WHEN ARRAY_LENGTH(@amenities::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			projects.amenities_id && @amenities::bigint []
		END)
    --  facilities
	AND(
		CASE WHEN ARRAY_LENGTH(@facilities::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			projects.facilities_id && @facilities::bigint []
		END)
	--  unit views
    AND (
    CASE
        WHEN ARRAY_LENGTH(@views::bigint[], 1) IS NULL THEN
            TRUE
        ELSE
            -- Extracting 'view' from JSONB and converting it to an array of bigint for comparison
            (SELECT array_agg(CAST(value AS bigint))
             FROM jsonb_array_elements_text(projects.facts->'views')) && @views::bigint[]
    END
)
	-- media
	AND(@media::bigint = 0
		OR(array_length(media,
				@image_url) IS NOT NULL)
		OR(array_length(media,
				@image360_url) IS NOT NULL)
		OR(array_length(media,
				@video_url) IS NOT NULL)
		OR(array_length(media,
				@panaroma_url) IS NOT NULL))

	---------------------- from here normal project section --------------------------
	AND(ARRAY_LENGTH(@project_rank::bigint [], 1) IS NULL
	OR projects.project_rank = ANY (@project_rank::bigint []))
	AND(communities.community ILIKE @community::varchar OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS null OR projects.is_verified = @is_verified::bool)
    AND (
        projects.project_name ILIKE @search::varchar
        OR cities.city ILIKE @search::varchar
        OR communities.community ILIKE @search::varchar
        OR sub_communities.sub_community ILIKE @search::varchar
    )
    AND projects.status != 5 AND projects.status != 6;-- AND companies.status != 6;


-- name: FilterCountProjectsSubCommunity :one
WITH property_types_agg AS (
    SELECT 
        property.entity_id,
        array_agg(gpt.id ORDER BY gpt.id) AS property_types  -- Assuming `type` is the column in `global_property_type`
    FROM 
        property
    LEFT JOIN 
        global_property_type gpt ON gpt.id = property.property_type_id  -- Join to get the global_property_type
    WHERE 
        property.entity_type_id = 1  -- Assuming 1 indicates a project-related entity
    GROUP BY 
        property.entity_id
),
project_properties_agg AS (
    SELECT
        properties_with_types.entity_id, 
        array_agg(property_types ORDER BY property_types) AS property_types_agg
    FROM (
        SELECT
            property.entity_id,
            global_property_type."type" AS property_types
        FROM
            property
        LEFT JOIN
            global_property_type ON global_property_type.id = property.property_type_id
    ) AS properties_with_types
    GROUP BY
        properties_with_types.entity_id
),
project_media_agg AS (
    SELECT
        projects_id,
        array_agg(DISTINCT media_type ORDER BY media_type) AS media
    FROM 
        project_media
    GROUP BY 
        projects_id
)
SELECT 
   count(projects.*)
    -- property_types_agg.property_types,
    -- properties_facts.starting_price 
FROM
    projects  
LEFT JOIN
    addresses ON projects.addresses_id = addresses.id
LEFT JOIN
    companies ON projects.developer_companies_id = companies.id
LEFT JOIN
    cities ON addresses.cities_id = cities.id
LEFT JOIN
    communities ON addresses.communities_id = communities.id
LEFT JOIN
    sub_communities ON addresses.sub_communities_id = sub_communities.id
-- LEFT JOIN
--     properties_facts ON projects.id = properties_facts.project_id and properties_facts.is_project_fact = true
LEFT JOIN 
    property_types_agg ON projects.id = property_types_agg.entity_id
LEFT JOIN 
    project_properties_agg ON projects.id = project_properties_agg.entity_id
LEFT JOIN 
    project_media_agg ON projects.id = project_media_agg.projects_id
WHERE
    addresses.sub_communities_id = @sub_communities_id::bigint
    AND (CASE WHEN @developer_companies_id::bigint IS NULL THEN
		TRUE
	WHEN @developer_companies_id::bigint = 0 THEN
		TRUE
	ELSE
		projects.developer_companies_id = @developer_companies_id::bigint
	END)
	--project Type
-- 	AND CASE 
--     WHEN @property_type::text[] IS NULL THEN TRUE
--     ELSE EXISTS (
--         SELECT 1
--         FROM unnest(project_properties_agg.property_types_agg) AS pt
--         WHERE EXISTS (
--             SELECT 1
--             FROM unnest(@property_type::text[]) AS search_terms
--             WHERE pt ILIKE '%' || search_terms || '%'
--         )
--     )
-- END
      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
    CAST(projects.facts ->> 'completion_status' AS bigint) = @completion_status::bigint
	END
	 -- ownership
	   AND (
    ARRAY_LENGTH(@ownership::bigint[], 1) IS NULL
    OR CAST(projects.facts ->> 'ownership' AS bigint) = ANY (@ownership::bigint[])
   )
		--  	     --  service charges
    AND (
    CASE
        WHEN @min_service_charges::bigint IS NULL THEN
            TRUE
        WHEN @min_service_charges::bigint = 0 THEN
            TRUE
        ELSE
            CAST(projects.facts ->> 'service_charge' AS bigint) <= @min_service_charges::bigint
    END
    -- max service charges
    AND CASE
        WHEN @max_service_charges::bigint IS NULL THEN
            TRUE
        WHEN @max_service_charges::bigint = 0 THEN
            TRUE
        ELSE
            CAST(projects.facts ->> 'service_charge' AS bigint) >= @max_service_charges::bigint
    END
)

	--  	     --  furnishing
    AND(ARRAY_LENGTH(@furnished::bigint [],
			1) IS NULL
		OR CAST(projects.facts ->> 'ownership' AS bigint) = ANY (@ownership::bigint[])) -- properties_facts.furnished = ANY (@furnished::bigint []))
	--  amenities
	AND(
		CASE WHEN ARRAY_LENGTH(@amenities::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			projects.amenities_id && @amenities::bigint []
		END)
    --  facilities
	AND(
		CASE WHEN ARRAY_LENGTH(@facilities::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			projects.facilities_id && @facilities::bigint []
		END)
	--  unit views
    AND (
    CASE
        WHEN ARRAY_LENGTH(@views::bigint[], 1) IS NULL THEN
            TRUE
        ELSE
            -- Extracting 'view' from JSONB and converting it to an array of bigint for comparison
            (SELECT array_agg(CAST(value AS bigint))
             FROM jsonb_array_elements_text(projects.facts->'view')) && @views::bigint[]
    END
)
	-- media
	AND(@media::bigint = 0
		OR(array_length(media,
				@image_url) IS NOT NULL)
		OR(array_length(media,
				@image360_url) IS NOT NULL)
		OR(array_length(media,
				@video_url) IS NOT NULL)
		OR(array_length(media,
				@panaroma_url) IS NOT NULL))

	---------------------- from here normal project section --------------------------
	AND(ARRAY_LENGTH(@project_rank::bigint [], 1) IS NULL
	OR projects.project_rank = ANY (@project_rank::bigint []))
	AND(communities.community ILIKE @community::varchar OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS null OR projects.is_verified = @is_verified::bool)
    AND (
        projects.project_name ILIKE @search::varchar
        OR cities.city ILIKE @search::varchar
        OR communities.community ILIKE @search::varchar
        OR sub_communities.sub_community ILIKE @search::varchar
    )
    AND projects.status != 5 AND projects.status != 6;-- AND companies.status != 6;

-- name: GetSingleProject :one
WITH property_types_agg AS (
    SELECT 
        property.entity_id,
        array_agg(gpt.id ORDER BY gpt.id) AS property_types  -- Assuming `type` is the column in `global_property_type`
    FROM 
        property
    LEFT JOIN 
        global_property_type gpt ON gpt.id = property.property_type_id  -- Join to get the global_property_type
    WHERE 
        property.entity_type_id = 1  -- Assuming 1 indicates a project-related entity
    GROUP BY 
        property.entity_id
)
SELECT
    projects.*,
    property_types_agg.property_types,
    COUNT(phases.id) AS no_of_phases
FROM
    projects
LEFT JOIN
    phases ON projects.id = phases.projects_id
LEFT JOIN 
    property_types_agg ON projects.id = property_types_agg.entity_id
WHERE
    projects.id = $1
GROUP BY
    projects.id,
    property_types_agg.property_types;


-- name: TopDealProjectPropertiesByProjectListing :many
select * from property
where entity_id = $1 and entity_type_id = $2 and id != $3 and status != 5 and status != 6
LIMIT 10 OFFSET 0;

-- name: GetProjectPropertiesBySameArea :many
select * from property
LEFT JOIN
    addresses ON property.addresses_id = addresses.id
LEFT JOIN
    cities ON addresses.cities_id = cities.id
INNER JOIN
    communities ON addresses.communities_id = communities.id
LEFT JOIN
    sub_communities ON addresses.sub_communities_id = sub_communities.id
where property.id != $1 and addresses.communities_id = $2 and  status != 5 and status != 6
LIMIT 10 OFFSET 0;

-- name: GetProjectReviewByProjectAndUserId :one
SELECT * FROM project_reviews
WHERE projects_id = $1 AND reviewer = $2;

-- name: CreateProjectReview :one
INSERT INTO project_reviews (
    ref_no,
	is_project,
	projects_id,
	project_clean,
	project_location,
	project_facilities,
	project_securities,
	description,
	reviewer,
	review_date,
	proof_images,
	title
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12
) RETURNING *;

-- name: GetProjectReviewsByProjectId :many 
SELECT * FROM project_reviews
WHERE projects_id = $1
LIMIT $2 OFFSET $3;

-- -- name: FilterCountSaleUnitListingStatus :one
-- with x as (
--     select count(units.id) as cnt 
-- 	from units
-- 	inner join sale_unit on  units.id = sale_unit.unit_id
-- 	INNER JOIN unit_facts ON units.id = unit_facts.unit_id and unit_facts.category = 'sale'
-- 	AND ($3::bigint[] is NULL OR units.property_unit_rank = ANY($3::bigint[]))
--     AND (@is_verified::bool IS null OR units.is_verified = @is_verified::bool)
--     where units.properties_id = $1 
-- 	and sale_unit.status = $2 
-- 	and section = 'project'
-- 	and units.property = 1 
--     AND unit_facts.bedroom IS NOT NULL
-- )
-- select sum(cnt) as total_count from x;

-- -- name: FilterCountRentUnitListingStatus :one
-- with x as (
-- 	select count(units.id) as cnt 
-- 	from units
-- 	inner join rent_unit on  units.id = rent_unit.unit_id
-- 	INNER JOIN unit_facts ON units.id = unit_facts.unit_id and unit_facts.category = 'rent'
-- 	AND ($3::bigint[] is NULL OR units.property_unit_rank = ANY($3::bigint[]))
--     AND (@is_verified::bool IS null OR units.is_verified = @is_verified::bool)
--     where units.properties_id = $1 
-- 	and rent_unit.status = $2 
-- 	and section = 'project'
-- 	and units.property = 1 
--     AND unit_facts.bedroom IS NOT NULL
-- )
-- select sum(cnt) as total_count from x;

-- -- name: FilterCountUnitListingStatus :one
-- with x as (
--     select count(units.id) as cnt 
-- 	from units
-- 	inner join sale_unit on  units.id = sale_unit.unit_id
-- 	INNER JOIN unit_facts ON units.id = unit_facts.unit_id and unit_facts.category = 'sale'
--     where units.properties_id = $1 
-- 	and sale_unit.status = $2 
-- 	and section = 'project'
-- 	and units.property = 1 
--     AND unit_facts.bedroom IS NOT NULL
-- 	union all
-- 	select count(units.id) as cnt 
-- 	from units
-- 	inner join rent_unit on  units.id = rent_unit.unit_id
-- 	INNER JOIN unit_facts ON units.id = unit_facts.unit_id and unit_facts.category = 'rent'
--     where units.properties_id = $1 
-- 	and rent_unit.status = $2 
-- 	and section = 'project'
-- 	and units.property = 1 
--     AND unit_facts.bedroom IS NOT NULL
-- )
-- select sum(cnt) as total_count from x;

-- -- name: FilterCountSaleUnitListingBedroom :many
-- WITH x AS (
-- 	SELECT unit_facts.bedroom
-- FROM units
-- INNER JOIN sale_unit ON sale_unit.unit_id = units.id
-- INNER JOIN unit_facts ON units.id = unit_facts.unit_id and unit_facts.category = 'sale'
-- AND (@rank_list::bigint[] is NULL OR units.property_unit_rank = ANY(@rank_list::bigint[]))
-- AND (@is_verified::bool IS null OR units.is_verified = @is_verified::bool)
-- WHERE units.properties_id = $1
--   AND units.property = 1
--   AND unit_facts.bedroom IS NOT NULL
-- )
-- SELECT bedroom, COUNT(*) AS total_count
-- FROM x 
-- GROUP BY bedroom
-- ORDER BY bedroom;

-- -- name: FilterCountRentUnitListingBedroom :many
-- WITH x AS (
--   select unit_facts.bedroom
--   from units
-- inner join rent_unit on rent_unit.unit_id = units.id 
-- INNER JOIN unit_facts ON units.id = unit_facts.unit_id and unit_facts.category = 'rent'
-- AND (@rank_list::bigint[] is NULL OR units.property_unit_rank = ANY(@rank_list::bigint[]))
-- AND (@is_verified::bool IS null OR units.is_verified = @is_verified::bool)
-- where units.properties_id = $1 
-- and units.property = 1 
-- AND unit_facts.bedroom IS NOT NULL
-- )
-- SELECT bedroom, COUNT(*) AS total_count
-- FROM x 
-- GROUP BY bedroom
-- ORDER BY bedroom;

-- -- name: GetProjectPropertySaleUnits :many
-- SELECT units.*, sale_unit.*
-- FROM units
-- INNER JOIN sale_unit ON sale_unit.unit_id = units.id
-- INNER JOIN unit_facts ON units.id = unit_facts.unit_id and unit_facts.category = 'sale'
-- WHERE units.properties_id = $1
--   AND units.property = 1
--   AND units."section" = $2
--   AND (@bedrooms::varchar[] IS NULL OR unit_facts.bedroom = ANY(@bedrooms::varchar[]))
--   AND (@status_list::int[] IS NULL OR sale_unit.status = ANY(@status_list::int[]))
--   AND (@rank_list::bigint[] IS NULL OR units.property_unit_rank = ANY(@rank_list::bigint[]))
--   AND (@is_verified::bool IS NULL OR units.is_verified = @is_verified::bool)
--   AND unit_facts.bedroom IS NOT NULL
-- ORDER BY 
--   CASE 
--     WHEN $3 = 1 THEN units.created_at
--     ELSE NULL
--   END DESC,
--   CASE 
--     WHEN $3 = 2 THEN unit_facts.price
--     ELSE NULL
--   END ASC,
--   CASE 
--     WHEN $3 = 3 THEN unit_facts.price
--     ELSE NULL
--   END DESC,
--   units.created_at DESC
--   LIMIT $4 OFFSET $5;


-- -- name: GetCountProjectPropertySaleUnits :one
-- SELECT count(units.*)
-- FROM units
-- INNER JOIN sale_unit ON sale_unit.unit_id = units.id
-- INNER JOIN unit_facts ON units.id = unit_facts.unit_id and unit_facts.category = 'sale'
-- WHERE units.properties_id = $1
--   AND units.property = 1
--   AND units."section" = $2
--   AND (@bedrooms::varchar[] IS NULL OR unit_facts.bedroom = ANY(@bedrooms::varchar[]))
--   AND (@status_list::int[] IS NULL OR sale_unit.status = ANY(@status_list::int[]))
--   AND (@rank_list::bigint[] is NULL OR units.property_unit_rank = ANY(@rank_list::bigint[]))
--   AND (@is_verified::bool IS null OR units.is_verified = @is_verified::bool)
--   AND unit_facts.bedroom IS NOT NULL;



-- -- name: GetProjectPropertyRentUnits :many
-- select *, rent_unit.* from units
-- inner join rent_unit on rent_unit.unit_id = units.id 
-- INNER JOIN unit_facts ON units.id = unit_facts.unit_id and unit_facts.category = 'rent'
-- where units.properties_id = $1 and units.property = 1 and units. "section" = $2 
-- AND (@bedrooms::varchar[] IS NULL OR unit_facts.bedroom = ANY(@bedrooms::varchar[]))
-- AND (@status_list::int[] IS NULL OR rent_unit.status = ANY(@status_list::int[]))
-- AND (@rank_list::bigint[] is NULL OR units.property_unit_rank = ANY(@rank_list::bigint[]))
-- AND (@is_verified::bool IS null OR units.is_verified = @is_verified::bool)
-- AND unit_facts.bedroom IS NOT NULL
-- ORDER BY 
--   CASE 
--     WHEN COALESCE($3, 0) = 1 THEN units.created_at
--     WHEN COALESCE($3, 0) = 2 THEN NULL
--     WHEN COALESCE($3, 0) = 3 THEN NULL
--     ELSE units.created_at  -- Default sorting by created_at if no parameter is passed
--   END DESC,
--   CASE 
--     WHEN COALESCE($3, 0) = 2 THEN unit_facts.price
--     ELSE NULL
--   END ASC,
--   CASE 
--     WHEN COALESCE($3, 0) = 3 THEN unit_facts.price
--     ELSE NULL
--   END DESC,
--   units.created_at DESC
--   LIMIT $4 OFFSET $5;

-- -- name: GetCountProjectPropertyRentUnits :one
-- select count(*) from units
-- inner join rent_unit on rent_unit.unit_id = units.id 
-- INNER JOIN unit_facts ON units.id = unit_facts.unit_id and unit_facts.category = 'rent'
-- where units.properties_id = $1 and units.property = 1 and units. "section" = $2 
-- AND (@bedrooms::varchar[] IS NULL OR unit_facts.bedroom = ANY(@bedrooms::varchar[]))
-- AND (@status_list::int[] IS NULL OR rent_unit.status = ANY(@status_list::int[]))
-- AND (@rank_list::bigint[] is NULL OR units.property_unit_rank = ANY(@rank_list::bigint[]))
-- AND (@is_verified::bool IS null OR units.is_verified = @is_verified::bool)
-- AND unit_facts.bedroom IS NOT NULL;

-- -- name: GetProjectSaleUnitCount :one
-- with x as (
--     select count(units.id) as cnt 
-- 	from units
-- 	inner join sale_unit on  units.id = sale_unit.unit_id
-- 	INNER JOIN unit_facts ON units.id = unit_facts.unit_id and unit_facts.category = 'sale'
-- 	AND (@bedrooms::varchar[] IS NULL OR unit_facts.bedroom = ANY(@bedrooms::varchar[]))
--     AND (@status_list::int[] IS NULL OR sale_unit.status = ANY(@status_list::int[]))
-- 	AND (@rank_list::bigint[] is NULL OR units.property_unit_rank = ANY(@rank_list::bigint[]))
--     AND (@is_verified::bool IS null OR units.is_verified = @is_verified::bool)
--     where units.properties_id = $1  
-- 	and section = 'project'
-- 	and units.property = 1 
--     AND unit_facts.bedroom IS NOT NULL
-- )
-- select sum(cnt) as total_count from x;

-- -- name: GetProjectRentUnitCount :one
-- with x as (
-- 	select count(units.id) as cnt 
-- 	from units
-- 	inner join rent_unit on  units.id = rent_unit.unit_id
-- 	INNER JOIN unit_facts ON units.id = unit_facts.unit_id and unit_facts.category = 'rent'
-- 	AND (@bedrooms::varchar[] IS NULL OR unit_facts.bedroom = ANY(@bedrooms::varchar[]))
--     AND (@status_list::int[] IS NULL OR sale_unit.status = ANY(@status_list::int[]))
-- 	AND (@rank_list::bigint[] is NULL OR units.property_unit_rank = ANY(@rank_list::bigint[]))
--     AND (@is_verified::bool IS null OR units.is_verified = @is_verified::bool)
--     where units.properties_id = $1  
-- 	and section = 'project'
-- 	and units.property = 1 
--     AND unit_facts.bedroom IS NOT NULL
-- )
-- select sum(cnt) as total_count from x;

-- -- name: GetSingleSaleUnits :one
-- select units.*, sale_unit.title, sale_unit.title_arabic, sale_unit.description, sale_unit.description_arabic, sale_unit.unit_id, sale_unit.status, sale_unit.unit_facts_id, sale_unit.contract_start_datetime, sale_unit.contract_end_datetime, sale_unit.contract_amount, sale_unit.contract_currency, projects.facilities_id from units
-- inner join sale_unit on sale_unit.unit_id = units.id
-- left join project_properties on units.properties_id  = project_properties.id and units.property = 1
-- left join projects on projects.id = project_properties.projects_id
-- where sale_unit.unit_id = $1 and units.is_branch = false;

-- -- name: GetSingleRentUnits :one
-- select units.*, rent_unit.title, rent_unit.title_arabic, rent_unit.description, rent_unit.description_arabic, rent_unit.unit_id, rent_unit.status, rent_unit.unit_facts_id, projects.facilities_id from units
-- inner join rent_unit on rent_unit.unit_id = units.id
-- left join project_properties on units.properties_id  = project_properties.id and units.property = 1
-- left join projects on projects.id = project_properties.projects_id
-- where rent_unit.unit_id = $1 and units.is_branch = false;


-- name: GetProjectReviewsByProjectIdWithIndividualAverages :many
WITH ReviewAverages AS (
    SELECT
        AVG(project_clean) AS avg_clean,
        AVG(project_location) AS avg_location,
        AVG(project_facilities) AS avg_facilities,
        AVG(project_securities) AS avg_securities,
        AVG((project_clean + project_location + project_facilities + project_securities) / 4.0)::float AS overall_avg
    FROM
        project_reviews
    WHERE
        projects_id = $1
)
SELECT
    project_reviews.id,
    project_reviews.ref_no,
    project_reviews.is_project,
    project_reviews.project_clean,
    project_reviews.project_location,
    project_reviews.project_facilities,
    project_reviews.project_securities,
    project_reviews.description,
    project_reviews.reviewer,
    project_reviews.review_date,
    project_reviews.proof_images,
    project_reviews.title,
    ra.avg_clean,
    ra.avg_location,
    ra.avg_facilities,
    ra.avg_securities,
    ra.overall_avg,
    ((project_reviews.project_clean + project_reviews.project_location + project_reviews.project_facilities + project_reviews.project_securities) / 4.0)::float AS avg,
    COUNT(*) OVER() AS total_count
FROM
    project_reviews
JOIN
    ReviewAverages ra ON true
WHERE
    project_reviews.projects_id = $1
LIMIT $2 OFFSET $3;


-- name: GetProjectMediaByIdAndMediaType :many
SELECT * FROM project_media WHERE projects_id = $1 AND media_type = $2;

-- name: GetAllProjectMediaByProjectIdAndGalleryType :many
With x As (
 SELECT  gallery_type,gallery_type_ar FROM global_media
 WHERE entity_id = $1 AND entity_type_id = 1
) SELECT * From x; 

-- name: GetAllProjectMediaByGalleryTypeAndId :one
with x As (
 SELECT * FROM global_media
 WHERE entity_id = $1 AND gallery_type = $2 AND entity_type_id = 1
) SELECT * From x;

-- -- name: GetProjectAmenitiesForPhase :one
-- select amenities from projects
-- left join phases on phases.projects_id = projects.id 
-- where projects.id = $1;

-- name: GetAllPhasesMediaByPhaseId :many
SELECT * FROM global_media WHERE entity_id = $1 AND entity_type_id = 2 ORDER BY id DESC;

-- name: GetProjectPropertyMediaByPropertyId :many
SELECT * FROM properties_media 
WHERE properties_id = $1 and property = 1 and media_type = 1;

-- name: GetUnitsProject :many
select units.*, unit_versions.* from units
inner join unit_versions on unit_versions.unit_id = units.id
where units.entity_id = $1 AND units.entity_type_id = $2 AND unit_versions.type = $3;

-- -- name: GetProjectFacilitiesForSinglePhase :one
-- select facilities_id from projects
-- where projects.id = $1;

-- -- name: GetProjectFacilitiesForMultiplePhase :one
-- select phases.facilities from phases
-- where phases.id = $1;

-- -- name: GetOpenHouseAppointmentByEmail :one
-- select * from appointment
-- inner join users on users.id = client_id
-- where  users.email = $1 and appointment.openhouse_id = $2;

-- name: GetCompanyLicenseByCompanyId :many
select license.*, license_type.name from license
LEFT JOIN license_type on license.license_type_id = license_type.id
where  entity_id = $1 AND entity_type_id = 6;

-- name: GetProjectPropertiesByProjectIdGraph :many
select * from property
where property.entity_id = $1 AND property.entity_type_id = 1;

-- -- name: GetPaymentPlansForProjectPropertyByPropertyId :many
-- select * from payment_plans_packages
-- where payment_plans_packages.properties_id = $1 AND payment_plans_packages.property = 1;

-- name: GetAllPropertyMediaByPropertyIdAndGalleryType :many
SELECT  gallery_type,gallery_type_ar,media_type FROM global_media
WHERE entity_id = $1 AND entity_type_id = 3;
 
-- name: GetAllPropertyMediaByGalleryTypeAndId :one
with x As (
SELECT * FROM global_media
WHERE gallery_type = $1 AND entity_id = $2 AND media_type = $3 AND entity_type_id = 3
) SELECT * From x;
 

-- name: GetAllPhasesMediaGalleryTypeById :many
With x As (
 SELECT  gallery_type,gallery_type_ar FROM global_media
 WHERE entity_id = $1 AND entity_type_id = 2
) SELECT * From x; 


-- name: GetAllPhasesMediaByMainMediaSectionAndId :one
with x As (
 SELECT * FROM global_media
 WHERE gallery_type = $2 AND entity_id = $1 AND entity_type_id = 2
) SELECT * From x; 


-- name: GetAllUnitMediaByUnitIdAndGalleryType :many
With x As (
 SELECT  gallery_type FROM unit_media
 WHERE units_id = $1
) SELECT * From x; 

-- name: GetAllUnitMediaByGalleryTypeAndId :one
with x As (
 SELECT * FROM unit_media
 WHERE gallery_type = $2 AND units_id = $1
) SELECT * From x;

-- -- name: TopDealProjectSaleUnitListing :many
-- With x As (
-- select units.*, sale_unit.title, sale_unit.title_arabic, sale_unit.description, sale_unit.description_arabic, sale_unit.unit_id, sale_unit.status, sale_unit.unit_facts_id, sale_unit.contract_start_datetime, sale_unit.contract_end_datetime, sale_unit.contract_amount, sale_unit.contract_currency from units
-- inner join sale_unit on sale_unit.unit_id = units.id
-- where sale_unit.unit_id != $1 and units.property_unit_rank = $2
-- ) SELECT * from x LIMIT 10 OFFSET 0;


-- -- name: TopDealProjectRentUnitListing :many
-- With x As (
-- select units.*, rent_unit.title, rent_unit.title_arabic, rent_unit.description, rent_unit.description_arabic, rent_unit.unit_id, rent_unit.status, rent_unit.unit_facts_id from units
-- inner join rent_unit on rent_unit.unit_id = units.id
-- where rent_unit.unit_id != $1 and units.property_unit_rank = $2
-- ) SELECT * from x LIMIT 10 OFFSET 0;

-- name: GetProjectSaleUnitListingBySameArea :many
With x As (
select units.*, sale_unit.title, sale_unit.title_arabic, sale_unit.description, sale_unit.description_arabic, sale_unit.unit_id, sale_unit.status, sale_unit.unit_facts_id, sale_unit.contract_start_datetime, sale_unit.contract_end_datetime, sale_unit.contract_amount, sale_unit.contract_currency from units
LEFT JOIN
    addresses ON units.addresses_id = addresses.id
LEFT JOIN
    cities ON addresses.cities_id = cities.id
INNER JOIN
    communities ON addresses.communities_id = communities.id
LEFT JOIN
    sub_communities ON addresses.sub_communities_id = sub_communities.id
inner join sale_unit on sale_unit.unit_id = units.id
where sale_unit.unit_id != $1 and addresses.communities_id = $2 and  status != 5 and status != 6
) SELECT * from x LIMIT 10 OFFSET 0;;

-- name: GetProjectRentUnitListingBySameArea :many
With x As (
select units.*, rent_unit.title, rent_unit.title_arabic, rent_unit.description, rent_unit.description_arabic, rent_unit.unit_id, rent_unit.status, rent_unit.unit_facts_id from units
LEFT JOIN
    addresses ON units.addresses_id = addresses.id
LEFT JOIN
    cities ON addresses.cities_id = cities.id
INNER JOIN
    communities ON addresses.communities_id = communities.id
LEFT JOIN
    sub_communities ON addresses.sub_communities_id = sub_communities.id
inner join rent_unit on rent_unit.unit_id = units.id
where rent_unit.unit_id != $1 and addresses.communities_id = $2 and  status != 5 and status != 6
) SELECT * from x LIMIT 10 OFFSET 0;

-- name: GetPropertyTypeNew :one
SELECT * FROM global_property_type 
WHERE id = $1 LIMIT $1;


-- name: GetAllPropertiesTypesByProjectsIds :one
SELECT
    array_agg(property_type_id)::bigint[] AS LIST
FROM
    property
WHERE
    property.entity_id = $1
    AND property.entity_type_id = $2;

-- name: GetAllPropertiesTypesByProjectsIdsAndPhaseId :one
SELECT
    array_agg(property_type_id)::bigint[] AS LIST
FROM
    property
WHERE
    property.entity_id = $1 
    AND property.entity_type_id = 2;

-- name: GetAllPropertyTypeFactsNew :many
WITH unnested AS (
  SELECT 
    t.id AS table_id, 
    (
      jsonb_each(t.property_type_facts :: jsonb)
    ).key AS key, 
    (
      jsonb_each(t.property_type_facts :: jsonb)
    ).value AS value 
  FROM 
    global_property_type t
), 
filtered as(
  SELECT 
    u.table_id, 
    u.key, 
    j ->> 'id' AS fact_id, 
    j ->> 'icon' AS icon, 
    j ->> 'slug' AS slug, 
    j ->> 'title' as title 
  FROM 
    unnested u, 
    jsonb_array_elements(u.value) AS j
) 
SELECT 
  DISTINCT(f.slug::varchar), 
  f.fact_id::varchar, 
  f.title::varchar, 
  f.icon::varchar 
FROM 
  filtered f;