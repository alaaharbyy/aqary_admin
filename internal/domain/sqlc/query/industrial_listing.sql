-- name: GetCountAllIndustrialProperties :one
WITH x AS(
select id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id, broker_companies_id, broker_company_agents, is_show_owner_info, property, countries_id, ref_no, developer_company_name, sub_developer_company_name, is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name, from_xml 
from industrial_broker_agent_properties where status != 5 and status !=6
union all
select id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id, broker_companies_branches_id as broker_companies_id, broker_company_branches_agents as broker_company_agents, is_show_owner_info, property, countries_id, ref_no, developer_company_name, sub_developer_company_name, is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name, from_xml 

from industrial_broker_agent_properties_branch where status != 5 and status !=6

union all

select id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id, 0 as broker_companies_id, 0 as broker_company_agents, is_show_owner_info, property, countries_id, ref_no,'' as developer_company_name,'' as sub_developer_company_name, false as is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name,false as from_xml 

from industrial_owner_properties where status != 5 and status != 6

union all

select id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id,0 as broker_companies_id,0 as broker_company_agents, is_show_owner_info, property, countries_id, ref_no,'' as developer_company_name,'' as sub_developer_company_name,false as is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name,false as from_xml 

from industrial_freelancer_properties where status != 5 and status != 6

) SELECT COUNT(*) AS total_count from x;


-- name: GetAllIndustrialProperties :many
WITH x AS(
select id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id, broker_companies_id, broker_company_agents, is_show_owner_info, property, countries_id, ref_no, developer_company_name, sub_developer_company_name, is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name, from_xml 
from industrial_broker_agent_properties where status != 5 and status !=6
union all
select id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id, broker_companies_branches_id as broker_companies_id, broker_company_branches_agents as broker_company_agents, is_show_owner_info, property, countries_id, ref_no, developer_company_name, sub_developer_company_name, is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name, from_xml 
from industrial_broker_agent_properties_branch where status != 5 and status !=6
union all
select id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id, 0 as broker_companies_id, 0 as broker_company_agents, is_show_owner_info, property, countries_id, ref_no,'' as developer_company_name,'' as sub_developer_company_name, false as is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name,false as from_xml 
from industrial_owner_properties where status != 5 and status != 6
union all
select id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id,0 as broker_companies_id,0 as broker_company_agents, is_show_owner_info, property, countries_id, ref_no,'' as developer_company_name,'' as sub_developer_company_name,false as is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name,false as from_xml 
from industrial_freelancer_properties where status != 5 and status != 6
) select id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id, broker_companies_id, broker_company_agents, is_show_owner_info, property, countries_id, ref_no, developer_company_name, sub_developer_company_name, is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name, from_xml 
FROM x ORDER BY property_rank DESC, is_verified DESC,
    CASE property_rank
        WHEN 4 THEN 1
        WHEN 3 THEN 2
        WHEN 2 THEN 3
        WHEN 1 THEN 4
        ELSE 5
    END
 LIMIT $1 OFFSET $2;


-- name: FilterIndustrialProperties :many
With x As(
 SELECT industrial_freelancer_properties.id, industrial_freelancer_properties.property_title,industrial_freelancer_properties.property_name, industrial_freelancer_properties.property_title_arabic, industrial_freelancer_properties.description, industrial_freelancer_properties.description_arabic, industrial_freelancer_properties.is_verified, industrial_freelancer_properties.property_rank, industrial_freelancer_properties.addresses_id, industrial_freelancer_properties.locations_id, industrial_freelancer_properties.property_types_id, industrial_freelancer_properties.users_id, industrial_freelancer_properties.facilities_id, industrial_freelancer_properties.amenities_id, industrial_freelancer_properties.status, industrial_freelancer_properties.created_at AS created_time, industrial_freelancer_properties.updated_at, industrial_freelancer_properties.is_show_owner_info, industrial_freelancer_properties.property, industrial_freelancer_properties.countries_id, industrial_freelancer_properties.ref_no, FALSE AS is_branch, 0 AS broker_companies_id,
 industrial_properties_facts.price AS unit_price,
 industrial_properties_facts.bedroom AS unit_bedroom 
 from industrial_freelancer_properties
 LEFT JOIN addresses ON industrial_freelancer_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON industrial_freelancer_properties.property_types_id = property_types.id
 LEFT JOIN industrial_properties_facts ON industrial_freelancer_properties.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 2
 LEFT JOIN industrial_freelancer_properties_media ON industrial_freelancer_properties.id = industrial_freelancer_properties_media.industrial_freelancer_properties_id
 WHERE 
    addresses.countries_id = @country_id::bigint
	--         -- city
	AND cities.city ILIKE @city::varchar
	
	AND LOWER(industrial_freelancer_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%' OR  industrial_freelancer_properties.ref_no ILIKE @ref::varchar)
	--         -- price
	AND(industrial_properties_facts.price BETWEEN @min_price::bigint AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [], 1) IS NULL OR industrial_properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [], 1) IS NULL
		OR industrial_properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		industrial_properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		industrial_properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			industrial_properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			industrial_properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			industrial_properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			industrial_properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		industrial_properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR industrial_properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			industrial_properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			industrial_properties_facts.service_charge <= @max_service_charges::bigint
		END)
	--  amenities
	AND(
		CASE WHEN ARRAY_LENGTH(@amenities::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			amenities_id && @amenities::bigint []
		END)
	--  unit views
	AND(
		CASE WHEN ARRAY_LENGTH(@views::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			industrial_properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(industrial_freelancer_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(industrial_freelancer_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(industrial_freelancer_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(industrial_freelancer_properties_media.panaroma_url,
				@panaroma_url) IS NOT NULL))
	---------------------- from here normal sale section --------------------------
	AND(ARRAY_LENGTH(@unit_rank::bigint [],
			1) IS NULL
		OR industrial_freelancer_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR industrial_freelancer_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			industrial_freelancer_properties.property_title ILIKE @search::varchar
			OR industrial_freelancer_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND industrial_freelancer_properties.status != 5
	AND industrial_freelancer_properties.status != 6
           UNION ALL 
 SELECT industrial_owner_properties.id, industrial_owner_properties.property_title,industrial_owner_properties.property_name, industrial_owner_properties.property_title_arabic, industrial_owner_properties.description, industrial_owner_properties.description_arabic, industrial_owner_properties.is_verified, industrial_owner_properties.property_rank, industrial_owner_properties.addresses_id, industrial_owner_properties.locations_id, industrial_owner_properties.property_types_id, industrial_owner_properties.users_id, industrial_owner_properties.facilities_id, industrial_owner_properties.amenities_id, industrial_owner_properties.status, industrial_owner_properties.created_at AS created_time, industrial_owner_properties.updated_at, industrial_owner_properties.is_show_owner_info, industrial_owner_properties.property, industrial_owner_properties.countries_id, industrial_owner_properties.ref_no, FALSE AS is_branch, 0 AS broker_companies_id,
 industrial_properties_facts.price AS unit_price,
 industrial_properties_facts.bedroom AS unit_bedroom 
 from industrial_owner_properties
 LEFT JOIN addresses ON industrial_owner_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON industrial_owner_properties.property_types_id = property_types.id
 LEFT JOIN industrial_properties_facts ON industrial_owner_properties.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 4
 LEFT JOIN industrial_owner_properties_media ON industrial_owner_properties.id = industrial_owner_properties_media.industrial_owner_properties_id
 WHERE 
    addresses.countries_id = @country_id::bigint
	--         -- city
	AND cities.city ILIKE @city::varchar
	
	AND LOWER(industrial_owner_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  industrial_owner_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(industrial_properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR industrial_properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR industrial_properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		industrial_properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		industrial_properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			industrial_properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			industrial_properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			industrial_properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			industrial_properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		industrial_properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR industrial_properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			industrial_properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			industrial_properties_facts.service_charge <= @max_service_charges::bigint
		END)
	--  amenities
	AND(
		CASE WHEN ARRAY_LENGTH(@amenities::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			amenities_id && @amenities::bigint []
		END)
	--  unit views
	AND(
		CASE WHEN ARRAY_LENGTH(@views::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			industrial_properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(industrial_owner_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(industrial_owner_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(industrial_owner_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(industrial_owner_properties_media.panaroma_url,
				@panaroma_url) IS NOT NULL))
	---------------------- from here normal sale section --------------------------
	AND(ARRAY_LENGTH(@unit_rank::bigint [],
			1) IS NULL
		OR industrial_owner_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR industrial_owner_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			industrial_owner_properties.property_title ILIKE @search::varchar
			OR industrial_owner_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND industrial_owner_properties.status != 5
	AND industrial_owner_properties.status != 6
 UNION ALL 
 SELECT industrial_broker_agent_properties.id, industrial_broker_agent_properties.property_title,industrial_broker_agent_properties.property_name, industrial_broker_agent_properties.property_title_arabic, industrial_broker_agent_properties.description, industrial_broker_agent_properties.description_arabic, industrial_broker_agent_properties.is_verified, industrial_broker_agent_properties.property_rank, industrial_broker_agent_properties.addresses_id, industrial_broker_agent_properties.locations_id, industrial_broker_agent_properties.property_types_id, industrial_broker_agent_properties.users_id, industrial_broker_agent_properties.facilities_id, industrial_broker_agent_properties.amenities_id, industrial_broker_agent_properties.status, industrial_broker_agent_properties.created_at AS created_time, industrial_broker_agent_properties.updated_at, industrial_broker_agent_properties.is_show_owner_info, industrial_broker_agent_properties.property, industrial_broker_agent_properties.countries_id, industrial_broker_agent_properties.ref_no, industrial_broker_agent_properties.is_branch, industrial_broker_agent_properties.broker_companies_id,
 industrial_properties_facts.price AS unit_price,
 industrial_properties_facts.bedroom AS unit_bedroom 
 from industrial_broker_agent_properties
 LEFT JOIN addresses ON industrial_broker_agent_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON industrial_broker_agent_properties.property_types_id = property_types.id 
 LEFT JOIN industrial_properties_facts ON industrial_broker_agent_properties.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 3
 LEFT JOIN industrial_broker_agent_properties_media ON industrial_broker_agent_properties.id = industrial_broker_agent_properties_media.industrial_broker_agent_properties_id
 LEFT JOIN broker_company_agents ON industrial_broker_agent_properties.broker_company_agents = broker_company_agents.id
 LEFT JOIN users ON broker_company_agents.users_id = users.id
 LEFT JOIN broker_companies ON broker_company_agents.broker_companies_id = broker_companies.id
 LEFT JOIN broker_company_agent_properties_media ON industrial_broker_agent_properties.id = broker_company_agent_properties_media.id
 WHERE 
     addresses.countries_id = @country_id::bigint
	--         -- city
	AND cities.city ILIKE @city::varchar
	--         -- section
	AND LOWER(industrial_broker_agent_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  industrial_broker_agent_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(industrial_properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR industrial_properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR industrial_properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		industrial_properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		industrial_properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			industrial_properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			industrial_properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			industrial_properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			industrial_properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		industrial_properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR industrial_properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			industrial_properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			industrial_properties_facts.service_charge <= @max_service_charges::bigint
		END)
	--  amenities
	AND(
		CASE WHEN ARRAY_LENGTH(@amenities::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			amenities_id && @amenities::bigint []
		END)
	--  unit views
	AND(
		CASE WHEN ARRAY_LENGTH(@views::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			industrial_properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(industrial_broker_agent_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(industrial_broker_agent_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(industrial_broker_agent_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(industrial_broker_agent_properties_media.panaroma_url,
				@panaroma_url) IS NOT NULL))
	--  tags or keywords
	--  todo ...
	--  agent or agency
	AND((@agent_agency::varchar = '%%'
		OR LOWER(users.username)
		ILIKE LOWER(@agent_agency::varchar))
	OR(@agent_agency::varchar = '%%'
		OR LOWER(broker_companies.company_name)
		ILIKE LOWER(@agent_agency::varchar)))
	---------------------- from here normal sale section --------------------------
	AND(ARRAY_LENGTH(@unit_rank::bigint [],
			1) IS NULL
		OR industrial_broker_agent_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR industrial_broker_agent_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			industrial_broker_agent_properties.property_title ILIKE @search::varchar
			OR industrial_broker_agent_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND industrial_broker_agent_properties.status != 5
	AND industrial_broker_agent_properties.status != 6
        UNION ALL
 SELECT industrial_broker_agent_properties_branch.id, industrial_broker_agent_properties_branch.property_title,industrial_broker_agent_properties_branch.property_name, industrial_broker_agent_properties_branch.property_title_arabic, industrial_broker_agent_properties_branch.description, industrial_broker_agent_properties_branch.description_arabic, industrial_broker_agent_properties_branch.is_verified, industrial_broker_agent_properties_branch.property_rank, industrial_broker_agent_properties_branch.addresses_id, industrial_broker_agent_properties_branch.locations_id, industrial_broker_agent_properties_branch.property_types_id, industrial_broker_agent_properties_branch.users_id, industrial_broker_agent_properties_branch.facilities_id, industrial_broker_agent_properties_branch.amenities_id, industrial_broker_agent_properties_branch.status, industrial_broker_agent_properties_branch.created_at AS created_time, industrial_broker_agent_properties_branch.updated_at, industrial_broker_agent_properties_branch.is_show_owner_info, industrial_broker_agent_properties_branch.property, industrial_broker_agent_properties_branch.countries_id, industrial_broker_agent_properties_branch.ref_no, industrial_broker_agent_properties_branch.is_branch, industrial_broker_agent_properties_branch.broker_companies_branches_id AS broker_companies_id,
 industrial_properties_facts.price AS unit_price,
 industrial_properties_facts.bedroom AS unit_bedroom 
 from industrial_broker_agent_properties_branch 
 LEFT JOIN addresses ON industrial_broker_agent_properties_branch.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON industrial_broker_agent_properties_branch.property_types_id = property_types.id
 LEFT JOIN industrial_properties_facts ON industrial_broker_agent_properties_branch.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 3
 LEFT JOIN industrial_broker_agent_properties_branch_media ON industrial_broker_agent_properties_branch.id = industrial_broker_agent_properties_branch_media.industrial_broker_agent_properties_branch_id
 LEFT JOIN broker_company_branches_agents ON industrial_broker_agent_properties_branch.broker_company_branches_agents = broker_company_branches_agents.id
 LEFT JOIN users ON broker_company_branches_agents.users_id = users.id
 LEFT JOIN broker_companies_branches ON broker_company_branches_agents.broker_companies_branches_id = broker_companies_branches.id
 LEFT JOIN broker_company_agent_properties_media_branch ON industrial_broker_agent_properties_branch.id = broker_company_agent_properties_media_branch.id
 WHERE 
     addresses.countries_id = @country_id::bigint
	--         -- city
	AND cities.city ILIKE @city::varchar
	--         -- section
	AND LOWER(industrial_broker_agent_properties_branch.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  industrial_broker_agent_properties_branch.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(industrial_properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR industrial_properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR industrial_properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		industrial_properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		industrial_properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			industrial_properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			industrial_properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			industrial_properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			industrial_properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		industrial_properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR industrial_properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			industrial_properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			industrial_properties_facts.service_charge <= @max_service_charges::bigint
		END)
	--  amenities
	AND(
		CASE WHEN ARRAY_LENGTH(@amenities::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			amenities_id && @amenities::bigint []
		END)
	--  unit views
	AND(
		CASE WHEN ARRAY_LENGTH(@views::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			industrial_properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(industrial_broker_agent_properties_branch_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(industrial_broker_agent_properties_branch_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(industrial_broker_agent_properties_branch_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(industrial_broker_agent_properties_branch_media.panaroma_url,
				@panaroma_url) IS NOT NULL))
	--  tags or keywords
	--  todo ...
	--  agent or agency
	AND((@agent_agency::varchar = '%%'
		OR LOWER(users.username)
		ILIKE LOWER(@agent_agency::varchar))
	OR(@agent_agency::varchar = '%%'
		OR LOWER(broker_companies_branches.company_name)
		ILIKE LOWER(@agent_agency::varchar)))
	---------------------- from here normal sale section --------------------------
	AND(ARRAY_LENGTH(@unit_rank::bigint [],
			1) IS NULL
		OR industrial_broker_agent_properties_branch.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR industrial_broker_agent_properties_branch.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			industrial_broker_agent_properties_branch.property_title ILIKE @search::varchar
			OR industrial_broker_agent_properties_branch.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND industrial_broker_agent_properties_branch.status != 5
	AND industrial_broker_agent_properties_branch.status != 6
) SELECT id,property_title,property_name,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,users_id,facilities_id,amenities_id,status,created_time,updated_at,is_show_owner_info,property, countries_id,ref_no,is_branch, broker_companies_id FROM x ORDER BY
 CASE WHEN @rank::bigint = 5 THEN
		unit_bedroom
	END DESC NULLS LAST,
	CASE WHEN @rank::bigint = 4 THEN
		unit_bedroom
	END,
	CASE WHEN @rank::bigint = 3 THEN
		unit_price
	END DESC,
	CASE WHEN @rank::bigint = 2 THEN
		unit_price
	END,
	CASE WHEN @rank::bigint = 1 THEN
		created_time
	END DESC,
    property_rank desc,
    is_verified desc,
    RANDOM()
LIMIT $1 OFFSET $2;


-- name: FilterCountIndustrialProperties :one
With x As(
 SELECT industrial_freelancer_properties.id, industrial_freelancer_properties.property_title,industrial_freelancer_properties.property_name, industrial_freelancer_properties.property_title_arabic, industrial_freelancer_properties.description, industrial_freelancer_properties.description_arabic, industrial_freelancer_properties.is_verified, industrial_freelancer_properties.property_rank, industrial_freelancer_properties.addresses_id, industrial_freelancer_properties.locations_id, industrial_freelancer_properties.property_types_id, industrial_freelancer_properties.users_id, industrial_freelancer_properties.facilities_id, industrial_freelancer_properties.amenities_id, industrial_freelancer_properties.status, industrial_freelancer_properties.created_at AS created_time, industrial_freelancer_properties.updated_at, industrial_freelancer_properties.is_show_owner_info, industrial_freelancer_properties.property, industrial_freelancer_properties.countries_id, industrial_freelancer_properties.ref_no, FALSE AS is_branch, 0 AS broker_companies_id,
 industrial_properties_facts.price AS unit_price,
 industrial_properties_facts.bedroom AS unit_bedroom 
 from industrial_freelancer_properties
 INNER JOIN addresses ON industrial_freelancer_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON industrial_freelancer_properties.property_types_id = property_types.id
 INNER JOIN industrial_properties_facts ON industrial_freelancer_properties.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 2
 WHERE 
         industrial_freelancer_properties.category = $8 and
         addresses.countries_id = $1 AND
         ($2::bigint[] is NULL OR industrial_freelancer_properties.property_rank = ANY($2::bigint[]))  AND
          cities.city ILIKE '%' || $3 || '%'  AND                 
          communities.community ILIKE '%' || $4 || '%'  AND       
          sub_communities.sub_community ILIKE '%' || $5 || '%'
         AND ($6::bool is NULL OR is_verified = $6::bool)
         AND (  
             industrial_freelancer_properties.property_title ILIKE '%' || $7 || '%'  OR 
             industrial_freelancer_properties.property_title_arabic ILIKE '%' || $7 || '%'  OR   
             property_types.type  ILIKE '%' || $7 || '%'  OR 
             cities.city ILIKE '%' || $7 || '%' OR
             communities.community ILIKE '%' || $7 || '%' OR
             sub_communities.sub_community ILIKE '%' || $7 || '%'
         ) AND industrial_freelancer_properties.status != 5 AND industrial_freelancer_properties.status != 6
           UNION ALL 
 SELECT industrial_owner_properties.id, industrial_owner_properties.property_title,industrial_owner_properties.property_name, industrial_owner_properties.property_title_arabic, industrial_owner_properties.description, industrial_owner_properties.description_arabic, industrial_owner_properties.is_verified, industrial_owner_properties.property_rank, industrial_owner_properties.addresses_id, industrial_owner_properties.locations_id, industrial_owner_properties.property_types_id, industrial_owner_properties.users_id, industrial_owner_properties.facilities_id, industrial_owner_properties.amenities_id, industrial_owner_properties.status, industrial_owner_properties.created_at AS created_time, industrial_owner_properties.updated_at, industrial_owner_properties.is_show_owner_info, industrial_owner_properties.property, industrial_owner_properties.countries_id, industrial_owner_properties.ref_no, FALSE AS is_branch, 0 AS broker_companies_id,
 industrial_properties_facts.price AS unit_price,
 industrial_properties_facts.bedroom AS unit_bedroom 
 from industrial_owner_properties
 INNER JOIN addresses ON industrial_owner_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON industrial_owner_properties.property_types_id = property_types.id
 INNER JOIN industrial_properties_facts ON industrial_owner_properties.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 4
 WHERE 
          industrial_owner_properties.category = $8 and
          addresses.countries_id = $1 AND
         ($2::bigint[] is NULL OR industrial_owner_properties.property_rank = ANY($2::bigint[]))  AND
          cities.city ILIKE '%' || $3 || '%'  AND                 
          communities.community ILIKE '%' || $4 || '%'  AND       
          sub_communities.sub_community ILIKE '%' || $5 || '%'
         AND ($6::bool is NULL OR is_verified = $6::bool)
         AND (
             industrial_owner_properties.property_title ILIKE '%' || $7 || '%'  OR 
             industrial_owner_properties.property_title_arabic ILIKE '%' || $7 || '%'  OR   
             property_types.type  ILIKE '%' || $7 || '%'  OR 
             cities.city ILIKE '%' || $7 || '%' OR
             communities.community ILIKE '%' || $7 || '%' OR
             sub_communities.sub_community ILIKE '%' || $7 || '%'
       ) AND industrial_owner_properties.status != 5 AND industrial_owner_properties.status != 6
                   UNION ALL 
 SELECT industrial_broker_agent_properties.id, industrial_broker_agent_properties.property_title,industrial_broker_agent_properties.property_name, industrial_broker_agent_properties.property_title_arabic, industrial_broker_agent_properties.description, industrial_broker_agent_properties.description_arabic, industrial_broker_agent_properties.is_verified, industrial_broker_agent_properties.property_rank, industrial_broker_agent_properties.addresses_id, industrial_broker_agent_properties.locations_id, industrial_broker_agent_properties.property_types_id, industrial_broker_agent_properties.users_id, industrial_broker_agent_properties.facilities_id, industrial_broker_agent_properties.amenities_id, industrial_broker_agent_properties.status, industrial_broker_agent_properties.created_at AS created_time, industrial_broker_agent_properties.updated_at, industrial_broker_agent_properties.is_show_owner_info, industrial_broker_agent_properties.property, industrial_broker_agent_properties.countries_id, industrial_broker_agent_properties.ref_no, industrial_broker_agent_properties.is_branch, industrial_broker_agent_properties.broker_companies_id,
 industrial_properties_facts.price AS unit_price,
 industrial_properties_facts.bedroom AS unit_bedroom 
 from industrial_broker_agent_properties
 INNER JOIN addresses ON industrial_broker_agent_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON industrial_broker_agent_properties.property_types_id = property_types.id
 INNER JOIN industrial_properties_facts ON industrial_broker_agent_properties.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 3
 WHERE 
          industrial_broker_agent_properties.category = $8 and
          addresses.countries_id = $1 AND
         ($2::bigint[] is NULL OR industrial_broker_agent_properties.property_rank = ANY($2::bigint[]))  AND
          cities.city ILIKE '%' || $3 || '%'  AND                 
          communities.community ILIKE '%' || $4 || '%'  AND       
          sub_communities.sub_community ILIKE '%' || $5 || '%'
         AND ($6::bool is NULL OR is_verified = $6::bool)
         AND (
             industrial_broker_agent_properties.property_title ILIKE '%' || $7 || '%'  OR 
             industrial_broker_agent_properties.property_title_arabic ILIKE '%' || $7 || '%'  OR   
             property_types.type  ILIKE '%' || $7 || '%'  OR 
             cities.city ILIKE '%' || $7 || '%' OR
             communities.community ILIKE '%' || $7 || '%' OR
             sub_communities.sub_community ILIKE '%' || $7 || '%'
       ) AND industrial_broker_agent_properties.status != 5 AND industrial_broker_agent_properties.status != 6
        UNION ALL
 SELECT industrial_broker_agent_properties_branch.id, industrial_broker_agent_properties_branch.property_title,industrial_broker_agent_properties_branch.property_name, industrial_broker_agent_properties_branch.property_title_arabic, industrial_broker_agent_properties_branch.description, industrial_broker_agent_properties_branch.description_arabic, industrial_broker_agent_properties_branch.is_verified, industrial_broker_agent_properties_branch.property_rank, industrial_broker_agent_properties_branch.addresses_id, industrial_broker_agent_properties_branch.locations_id, industrial_broker_agent_properties_branch.property_types_id, industrial_broker_agent_properties_branch.users_id, industrial_broker_agent_properties_branch.facilities_id, industrial_broker_agent_properties_branch.amenities_id, industrial_broker_agent_properties_branch.status, industrial_broker_agent_properties_branch.created_at AS created_time, industrial_broker_agent_properties_branch.updated_at, industrial_broker_agent_properties_branch.is_show_owner_info, industrial_broker_agent_properties_branch.property, industrial_broker_agent_properties_branch.countries_id, industrial_broker_agent_properties_branch.ref_no, industrial_broker_agent_properties_branch.is_branch, industrial_broker_agent_properties_branch.broker_companies_branches_id AS broker_companies_id,
 industrial_properties_facts.price AS unit_price,
 industrial_properties_facts.bedroom AS unit_bedroom 
 from industrial_broker_agent_properties_branch 
 INNER JOIN addresses ON industrial_broker_agent_properties_branch.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON industrial_broker_agent_properties_branch.property_types_id = property_types.id
 INNER JOIN industrial_properties_facts ON industrial_broker_agent_properties_branch.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 3
 WHERE 
          industrial_broker_agent_properties_branch.category = $8 and
           addresses.countries_id = $1 AND
         ($2::bigint[] is NULL OR industrial_broker_agent_properties_branch.property_rank = ANY($2::bigint[]))  AND
          cities.city ILIKE '%' || $3 || '%'  AND                 
          communities.community ILIKE '%' || $4 || '%'  AND       
          sub_communities.sub_community ILIKE '%' || $5 || '%'
         AND ($6::bool is NULL OR is_verified = $6::bool)
         AND (
             industrial_broker_agent_properties_branch.property_title ILIKE '%' || $7 || '%'  OR 
             industrial_broker_agent_properties_branch.property_title_arabic ILIKE '%' || $7 || '%'  OR   
             property_types.type  ILIKE '%' || $7 || '%'  OR 
             cities.city ILIKE '%' || $7 || '%' OR
             communities.community ILIKE '%' || $7 || '%' OR
             sub_communities.sub_community ILIKE '%' || $7 || '%'
       ) AND industrial_broker_agent_properties_branch.status != 5 AND industrial_broker_agent_properties_branch.status != 6
) SELECT COUNT(*) FROM x;






