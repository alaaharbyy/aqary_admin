
-- name: FilterPropertyHub :many
With x As(
 SELECT freelancers_properties.id, freelancers_properties.property_title,freelancers_properties.property_name, freelancers_properties.property_title_arabic, freelancers_properties.description, freelancers_properties.description_arabic, freelancers_properties.is_verified, freelancers_properties.property_rank, freelancers_properties.addresses_id, freelancers_properties.locations_id, freelancers_properties.property_types_id, freelancers_properties.profiles_id, freelancers_properties.facilities_id, freelancers_properties.amenities_id, freelancers_properties.status, freelancers_properties.created_at AS created_time, freelancers_properties.updated_at, freelancers_properties.is_show_owner_info, freelancers_properties.property, freelancers_properties.countries_id, freelancers_properties.ref_no,freelancers_properties.users_id, FALSE AS is_branch,0 AS broker_company_agents, 0 AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from freelancers_properties
 LEFT JOIN addresses ON freelancers_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON freelancers_properties.property_types_id = property_types.id
 LEFT JOIN properties_facts ON freelancers_properties.id = properties_facts.properties_id and properties_facts.property = 2
 LEFT JOIN freelancers_properties_media ON freelancers_properties.id = freelancers_properties_media.id
 WHERE 
        addresses.countries_id = @country_id::bigint
	--         -- city
	AND cities.city ILIKE @city::varchar
	
	AND LOWER(freelancers_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  freelancers_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(freelancers_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(freelancers_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(freelancers_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(freelancers_properties_media.panaroma_url,
				@panaroma_url) IS NOT NULL))
	---------------------- from here normal sale section --------------------------
	AND(ARRAY_LENGTH(@unit_rank::bigint [],
			1) IS NULL
		OR freelancers_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR freelancers_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			freelancers_properties.property_title ILIKE @search::varchar
			OR freelancers_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND freelancers_properties.status != 5
	AND freelancers_properties.status != 6
           UNION ALL
 SELECT owner_properties.id, owner_properties.property_title,owner_properties.property_name, owner_properties.property_title_arabic, owner_properties.description, owner_properties.description_arabic, owner_properties.is_verified, owner_properties.property_rank, owner_properties.addresses_id, owner_properties.locations_id, owner_properties.property_types_id, owner_properties.profiles_id, owner_properties.facilities_id, owner_properties.amenities_id, owner_properties.status, owner_properties.created_at AS created_time, owner_properties.updated_at, owner_properties.is_show_owner_info, owner_properties.property, owner_properties.countries_id, owner_properties.ref_no,owner_properties.users_id, FALSE AS is_branch,0 AS broker_company_agents, 0 AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from owner_properties
 LEFT JOIN addresses ON owner_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON owner_properties.property_types_id = property_types.id
 LEFT JOIN properties_facts ON owner_properties.id = properties_facts.properties_id and properties_facts.property = 4
 LEFT JOIN owner_properties_media ON owner_properties.id = owner_properties_media.id
 WHERE 
        addresses.countries_id = @country_id::bigint
	--         -- city
	AND cities.city ILIKE @city::varchar
	--         -- section
	AND LOWER(owner_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  owner_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(owner_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(owner_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(owner_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(owner_properties_media.panaroma_url,
				@panaroma_url) IS NOT NULL))
	---------------------- from here normal sale section --------------------------
	AND(ARRAY_LENGTH(@unit_rank::bigint [],
			1) IS NULL
		OR owner_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR owner_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			owner_properties.property_title ILIKE @search::varchar
			OR owner_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND owner_properties.status != 5
	AND owner_properties.status != 6
                   UNION ALL 
 SELECT broker_company_agent_properties.id, broker_company_agent_properties.property_title,broker_company_agent_properties.property_name, broker_company_agent_properties.property_title_arabic, broker_company_agent_properties.description, broker_company_agent_properties.description_arabic, broker_company_agent_properties.is_verified, broker_company_agent_properties.property_rank, broker_company_agent_properties.addresses_id, broker_company_agent_properties.locations_id, broker_company_agent_properties.property_types_id, broker_company_agent_properties.profiles_id, broker_company_agent_properties.facilities_id, broker_company_agent_properties.amenities_id, broker_company_agent_properties.status, broker_company_agent_properties.created_at AS created_time, broker_company_agent_properties.updated_at, broker_company_agent_properties.is_show_owner_info, broker_company_agent_properties.property, broker_company_agent_properties.countries_id, broker_company_agent_properties.ref_no,broker_company_agent_properties.users_id, broker_company_agent_properties.is_branch, broker_company_agents, broker_company_agent_properties.broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from broker_company_agent_properties
 LEFT JOIN addresses ON broker_company_agent_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON broker_company_agent_properties.property_types_id = property_types.id
 LEFT JOIN properties_facts ON broker_company_agent_properties.id = properties_facts.properties_id and properties_facts.property = 3
 LEFT JOIN broker_company_agents ON broker_company_agent_properties.broker_company_agents = broker_company_agents.id
 LEFT JOIN users ON broker_company_agents.users_id = users.id
 LEFT JOIN broker_companies ON broker_company_agents.broker_companies_id = broker_companies.id
 LEFT JOIN broker_company_agent_properties_media ON broker_company_agent_properties.id = broker_company_agent_properties_media.id
 WHERE 
    addresses.countries_id = @country_id::bigint
	--         -- city
	AND cities.city ILIKE @city::varchar
	--         -- section
	AND LOWER(broker_company_agent_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  broker_company_agent_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(broker_company_agent_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media.panaroma_url,
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
		OR broker_company_agent_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR broker_company_agent_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			broker_company_agent_properties.property_title ILIKE @search::varchar
			OR broker_company_agent_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND broker_company_agent_properties.status != 5
	AND broker_company_agent_properties.status != 6
        UNION ALL 
 SELECT broker_company_agent_properties_branch.id, broker_company_agent_properties_branch.property_title,broker_company_agent_properties_branch.property_name, broker_company_agent_properties_branch.property_title_arabic, broker_company_agent_properties_branch.description, broker_company_agent_properties_branch.description_arabic, broker_company_agent_properties_branch.is_verified, broker_company_agent_properties_branch.property_rank, broker_company_agent_properties_branch.addresses_id, broker_company_agent_properties_branch.locations_id, broker_company_agent_properties_branch.property_types_id, broker_company_agent_properties_branch.profiles_id, broker_company_agent_properties_branch.facilities_id, broker_company_agent_properties_branch.amenities_id, broker_company_agent_properties_branch.status, broker_company_agent_properties_branch.created_at AS created_time, broker_company_agent_properties_branch.updated_at, broker_company_agent_properties_branch.is_show_owner_info, broker_company_agent_properties_branch.property, broker_company_agent_properties_branch.countries_id, broker_company_agent_properties_branch.ref_no,broker_company_agent_properties_branch.users_id, broker_company_agent_properties_branch.is_branch,broker_company_agent_properties_branch.broker_company_branches_agents AS broker_company_agents, broker_company_agent_properties_branch.broker_companies_branches_id AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from broker_company_agent_properties_branch 
 LEFT JOIN addresses ON broker_company_agent_properties_branch.addresses_id = addresses.id
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON broker_company_agent_properties_branch.property_types_id = property_types.id
 LEFT JOIN properties_facts ON broker_company_agent_properties_branch.id = properties_facts.properties_id and properties_facts.property = 3
 LEFT JOIN broker_company_branches_agents ON broker_company_agent_properties_branch.broker_company_branches_agents = broker_company_branches_agents.id
 LEFT JOIN users ON broker_company_branches_agents.users_id = users.id
 LEFT JOIN broker_companies_branches ON broker_company_branches_agents.broker_companies_branches_id = broker_companies_branches.id
 LEFT JOIN broker_company_agent_properties_media_branch ON broker_company_agent_properties_branch.id = broker_company_agent_properties_media_branch.id

 WHERE 
    addresses.countries_id = @country_id::bigint
	--         -- city
	AND cities.city ILIKE @city::varchar
	--         -- section
	AND LOWER(broker_company_agent_properties_branch.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  broker_company_agent_properties_branch.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(broker_company_agent_properties_media_branch.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media_branch.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media_branch.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media_branch.panaroma_url,
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
		OR broker_company_agent_properties_branch.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR broker_company_agent_properties_branch.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			broker_company_agent_properties_branch.property_title ILIKE @search::varchar
			OR broker_company_agent_properties_branch.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND broker_company_agent_properties_branch.status != 5
	AND broker_company_agent_properties_branch.status != 6
) SELECT id,property_title,property_name,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_time,updated_at,is_show_owner_info,property, countries_id,ref_no,users_id ,is_branch,broker_company_agents, broker_companies_id FROM x ORDER BY
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
	property_rank DESC,
	is_verified DESC,
	RANDOM()
LIMIT $1 OFFSET $2;

-- name: FilterCountPropertyHub :many
With x As(
 SELECT freelancers_properties.id, freelancers_properties.property_title,freelancers_properties.property_name, freelancers_properties.property_title_arabic, freelancers_properties.description, freelancers_properties.description_arabic, freelancers_properties.is_verified, freelancers_properties.property_rank, freelancers_properties.addresses_id, freelancers_properties.locations_id, freelancers_properties.property_types_id, freelancers_properties.profiles_id, freelancers_properties.facilities_id, freelancers_properties.amenities_id, freelancers_properties.status, freelancers_properties.created_at AS created_time, freelancers_properties.updated_at, freelancers_properties.is_show_owner_info, freelancers_properties.property, freelancers_properties.countries_id, freelancers_properties.ref_no,freelancers_properties.users_id, FALSE AS is_branch,0 AS broker_company_agents, 0 AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from freelancers_properties
 LEFT JOIN addresses ON freelancers_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON freelancers_properties.property_types_id = property_types.id
 LEFT JOIN properties_facts ON freelancers_properties.id = properties_facts.properties_id and properties_facts.property = 2
 LEFT JOIN freelancers_properties_media ON freelancers_properties.id = freelancers_properties_media.id
 WHERE 
        addresses.countries_id = @country_id::bigint
	--         -- city
	AND cities.city ILIKE @city::varchar
	--         -- section
	AND LOWER(freelancers_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  freelancers_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(freelancers_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(freelancers_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(freelancers_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(freelancers_properties_media.panaroma_url,
				@panaroma_url) IS NOT NULL))
	---------------------- from here normal sale section --------------------------
	AND(ARRAY_LENGTH(@unit_rank::bigint [],
			1) IS NULL
		OR freelancers_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR freelancers_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			freelancers_properties.property_title ILIKE @search::varchar
			OR freelancers_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND freelancers_properties.status != 5
	AND freelancers_properties.status != 6
           UNION ALL
 SELECT owner_properties.id, owner_properties.property_title,owner_properties.property_name, owner_properties.property_title_arabic, owner_properties.description, owner_properties.description_arabic, owner_properties.is_verified, owner_properties.property_rank, owner_properties.addresses_id, owner_properties.locations_id, owner_properties.property_types_id, owner_properties.profiles_id, owner_properties.facilities_id, owner_properties.amenities_id, owner_properties.status, owner_properties.created_at AS created_time, owner_properties.updated_at, owner_properties.is_show_owner_info, owner_properties.property, owner_properties.countries_id, owner_properties.ref_no,owner_properties.users_id, FALSE AS is_branch,0 AS broker_company_agents, 0 AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from owner_properties
 LEFT JOIN addresses ON owner_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON owner_properties.property_types_id = property_types.id
 LEFT JOIN properties_facts ON owner_properties.id = properties_facts.properties_id and properties_facts.property = 4
 LEFT JOIN owner_properties_media ON owner_properties.id = owner_properties_media.id
 WHERE 
        addresses.countries_id = @country_id::bigint
	--         -- city
	AND cities.city ILIKE @city::varchar
	--         -- section
	AND LOWER(owner_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  owner_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(owner_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(owner_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(owner_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(owner_properties_media.panaroma_url,
				@panaroma_url) IS NOT NULL))
	---------------------- from here normal sale section --------------------------
	AND(ARRAY_LENGTH(@unit_rank::bigint [],
			1) IS NULL
		OR owner_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR owner_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			owner_properties.property_title ILIKE @search::varchar
			OR owner_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND owner_properties.status != 5
	AND owner_properties.status != 6
                   UNION ALL 
 SELECT broker_company_agent_properties.id, broker_company_agent_properties.property_title,broker_company_agent_properties.property_name, broker_company_agent_properties.property_title_arabic, broker_company_agent_properties.description, broker_company_agent_properties.description_arabic, broker_company_agent_properties.is_verified, broker_company_agent_properties.property_rank, broker_company_agent_properties.addresses_id, broker_company_agent_properties.locations_id, broker_company_agent_properties.property_types_id, broker_company_agent_properties.profiles_id, broker_company_agent_properties.facilities_id, broker_company_agent_properties.amenities_id, broker_company_agent_properties.status, broker_company_agent_properties.created_at AS created_time, broker_company_agent_properties.updated_at, broker_company_agent_properties.is_show_owner_info, broker_company_agent_properties.property, broker_company_agent_properties.countries_id, broker_company_agent_properties.ref_no,broker_company_agent_properties.users_id, broker_company_agent_properties.is_branch, broker_company_agents, broker_company_agent_properties.broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from broker_company_agent_properties
 LEFT JOIN addresses ON broker_company_agent_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON broker_company_agent_properties.property_types_id = property_types.id
 LEFT JOIN properties_facts ON broker_company_agent_properties.id = properties_facts.properties_id and properties_facts.property = 3
 LEFT JOIN broker_company_agents ON broker_company_agent_properties.broker_company_agents = broker_company_agents.id
 LEFT JOIN users ON broker_company_agents.users_id = users.id
 LEFT JOIN broker_companies ON broker_company_agents.broker_companies_id = broker_companies.id
 LEFT JOIN broker_company_agent_properties_media ON broker_company_agent_properties.id = broker_company_agent_properties_media.id
 WHERE 
    addresses.countries_id = @country_id::bigint
	--         -- city
	AND cities.city ILIKE @city::varchar
	--         -- section
	AND LOWER(broker_company_agent_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  broker_company_agent_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(broker_company_agent_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media.panaroma_url,
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
		OR broker_company_agent_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR broker_company_agent_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			broker_company_agent_properties.property_title ILIKE @search::varchar
			OR broker_company_agent_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND broker_company_agent_properties.status != 5
	AND broker_company_agent_properties.status != 6
        UNION ALL 
 SELECT broker_company_agent_properties_branch.id, broker_company_agent_properties_branch.property_title,broker_company_agent_properties_branch.property_name, broker_company_agent_properties_branch.property_title_arabic, broker_company_agent_properties_branch.description, broker_company_agent_properties_branch.description_arabic, broker_company_agent_properties_branch.is_verified, broker_company_agent_properties_branch.property_rank, broker_company_agent_properties_branch.addresses_id, broker_company_agent_properties_branch.locations_id, broker_company_agent_properties_branch.property_types_id, broker_company_agent_properties_branch.profiles_id, broker_company_agent_properties_branch.facilities_id, broker_company_agent_properties_branch.amenities_id, broker_company_agent_properties_branch.status, broker_company_agent_properties_branch.created_at AS created_time, broker_company_agent_properties_branch.updated_at, broker_company_agent_properties_branch.is_show_owner_info, broker_company_agent_properties_branch.property, broker_company_agent_properties_branch.countries_id, broker_company_agent_properties_branch.ref_no,broker_company_agent_properties_branch.users_id, broker_company_agent_properties_branch.is_branch,broker_company_agent_properties_branch.broker_company_branches_agents AS broker_company_agents, broker_company_agent_properties_branch.broker_companies_branches_id AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from broker_company_agent_properties_branch 
 LEFT JOIN addresses ON broker_company_agent_properties_branch.addresses_id = addresses.id
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON broker_company_agent_properties_branch.property_types_id = property_types.id
 LEFT JOIN properties_facts ON broker_company_agent_properties_branch.id = properties_facts.properties_id and properties_facts.property = 3
 LEFT JOIN broker_company_branches_agents ON broker_company_agent_properties_branch.broker_company_branches_agents = broker_company_branches_agents.id
 LEFT JOIN users ON broker_company_branches_agents.users_id = users.id
 LEFT JOIN broker_companies_branches ON broker_company_branches_agents.broker_companies_branches_id = broker_companies_branches.id
 LEFT JOIN broker_company_agent_properties_media_branch ON broker_company_agent_properties_branch.id = broker_company_agent_properties_media_branch.id

 WHERE 
    addresses.countries_id = @country_id::bigint
	--         -- city
	AND cities.city ILIKE @city::varchar
	--         -- section
	AND LOWER(broker_company_agent_properties_branch.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  broker_company_agent_properties_branch.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(broker_company_agent_properties_media_branch.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media_branch.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media_branch.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media_branch.panaroma_url,
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
		OR broker_company_agent_properties_branch.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR broker_company_agent_properties_branch.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			broker_company_agent_properties_branch.property_title ILIKE @search::varchar
			OR broker_company_agent_properties_branch.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND broker_company_agent_properties_branch.status != 5
	AND broker_company_agent_properties_branch.status != 6
) SELECT count(*) FROM x;


-- name: GetCountStatePropertyHub :one
With x As(
 SELECT freelancers_properties.id, freelancers_properties.property_title,freelancers_properties.property_name, freelancers_properties.property_title_arabic, freelancers_properties.description, freelancers_properties.description_arabic, freelancers_properties.is_verified, freelancers_properties.property_rank, freelancers_properties.addresses_id, freelancers_properties.locations_id, freelancers_properties.property_types_id, freelancers_properties.profiles_id, freelancers_properties.facilities_id, freelancers_properties.amenities_id, freelancers_properties.status, freelancers_properties.created_at AS created_time, freelancers_properties.updated_at, freelancers_properties.is_show_owner_info, freelancers_properties.property, freelancers_properties.countries_id, freelancers_properties.ref_no,freelancers_properties.users_id, FALSE AS is_branch,0 AS broker_company_agents, 0 AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from freelancers_properties
 LEFT JOIN addresses ON freelancers_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON freelancers_properties.property_types_id = property_types.id
 LEFT JOIN properties_facts ON freelancers_properties.id = properties_facts.properties_id and properties_facts.property = 2
 LEFT JOIN freelancers_properties_media ON freelancers_properties.id = freelancers_properties_media.id
 WHERE 
    addresses.cities_id = @cities_id::bigint
	--         -- section
	AND LOWER(freelancers_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  freelancers_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(freelancers_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(freelancers_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(freelancers_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(freelancers_properties_media.panaroma_url,
				@panaroma_url) IS NOT NULL))
	---------------------- from here normal sale section --------------------------
	AND(ARRAY_LENGTH(@unit_rank::bigint [],
			1) IS NULL
		OR freelancers_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR freelancers_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			freelancers_properties.property_title ILIKE @search::varchar
			OR freelancers_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND freelancers_properties.status != 5
	AND freelancers_properties.status != 6
           UNION ALL
 SELECT owner_properties.id, owner_properties.property_title,owner_properties.property_name, owner_properties.property_title_arabic, owner_properties.description, owner_properties.description_arabic, owner_properties.is_verified, owner_properties.property_rank, owner_properties.addresses_id, owner_properties.locations_id, owner_properties.property_types_id, owner_properties.profiles_id, owner_properties.facilities_id, owner_properties.amenities_id, owner_properties.status, owner_properties.created_at AS created_time, owner_properties.updated_at, owner_properties.is_show_owner_info, owner_properties.property, owner_properties.countries_id, owner_properties.ref_no,owner_properties.users_id, FALSE AS is_branch,0 AS broker_company_agents, 0 AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from owner_properties
 LEFT JOIN addresses ON owner_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON owner_properties.property_types_id = property_types.id
 LEFT JOIN properties_facts ON owner_properties.id = properties_facts.properties_id and properties_facts.property = 4
 LEFT JOIN owner_properties_media ON owner_properties.id = owner_properties_media.id
 WHERE 
    addresses.cities_id = @cities_id::bigint
	--         -- section
	AND LOWER(owner_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  owner_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(owner_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(owner_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(owner_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(owner_properties_media.panaroma_url,
				@panaroma_url) IS NOT NULL))
	---------------------- from here normal sale section --------------------------
	AND(ARRAY_LENGTH(@unit_rank::bigint [],
			1) IS NULL
		OR owner_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR owner_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			owner_properties.property_title ILIKE @search::varchar
			OR owner_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND owner_properties.status != 5
	AND owner_properties.status != 6
                   UNION ALL 
 SELECT broker_company_agent_properties.id, broker_company_agent_properties.property_title,broker_company_agent_properties.property_name, broker_company_agent_properties.property_title_arabic, broker_company_agent_properties.description, broker_company_agent_properties.description_arabic, broker_company_agent_properties.is_verified, broker_company_agent_properties.property_rank, broker_company_agent_properties.addresses_id, broker_company_agent_properties.locations_id, broker_company_agent_properties.property_types_id, broker_company_agent_properties.profiles_id, broker_company_agent_properties.facilities_id, broker_company_agent_properties.amenities_id, broker_company_agent_properties.status, broker_company_agent_properties.created_at AS created_time, broker_company_agent_properties.updated_at, broker_company_agent_properties.is_show_owner_info, broker_company_agent_properties.property, broker_company_agent_properties.countries_id, broker_company_agent_properties.ref_no,broker_company_agent_properties.users_id, broker_company_agent_properties.is_branch, broker_company_agents, broker_company_agent_properties.broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from broker_company_agent_properties
 LEFT JOIN addresses ON broker_company_agent_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON broker_company_agent_properties.property_types_id = property_types.id
 LEFT JOIN properties_facts ON broker_company_agent_properties.id = properties_facts.properties_id and properties_facts.property = 3
 LEFT JOIN broker_company_agents ON broker_company_agent_properties.broker_company_agents = broker_company_agents.id
 LEFT JOIN users ON broker_company_agents.users_id = users.id
 LEFT JOIN broker_companies ON broker_company_agents.broker_companies_id = broker_companies.id
 LEFT JOIN broker_company_agent_properties_media ON broker_company_agent_properties.id = broker_company_agent_properties_media.id
 WHERE 
    addresses.cities_id = @cities_id::bigint
	--         -- section
	AND LOWER(broker_company_agent_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  broker_company_agent_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(broker_company_agent_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media.panaroma_url,
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
		OR broker_company_agent_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR broker_company_agent_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			broker_company_agent_properties.property_title ILIKE @search::varchar
			OR broker_company_agent_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND broker_company_agent_properties.status != 5
	AND broker_company_agent_properties.status != 6
        UNION ALL 
 SELECT broker_company_agent_properties_branch.id, broker_company_agent_properties_branch.property_title,broker_company_agent_properties_branch.property_name, broker_company_agent_properties_branch.property_title_arabic, broker_company_agent_properties_branch.description, broker_company_agent_properties_branch.description_arabic, broker_company_agent_properties_branch.is_verified, broker_company_agent_properties_branch.property_rank, broker_company_agent_properties_branch.addresses_id, broker_company_agent_properties_branch.locations_id, broker_company_agent_properties_branch.property_types_id, broker_company_agent_properties_branch.profiles_id, broker_company_agent_properties_branch.facilities_id, broker_company_agent_properties_branch.amenities_id, broker_company_agent_properties_branch.status, broker_company_agent_properties_branch.created_at AS created_time, broker_company_agent_properties_branch.updated_at, broker_company_agent_properties_branch.is_show_owner_info, broker_company_agent_properties_branch.property, broker_company_agent_properties_branch.countries_id, broker_company_agent_properties_branch.ref_no,broker_company_agent_properties_branch.users_id, broker_company_agent_properties_branch.is_branch,broker_company_agent_properties_branch.broker_company_branches_agents AS broker_company_agents, broker_company_agent_properties_branch.broker_companies_branches_id AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from broker_company_agent_properties_branch 
 LEFT JOIN addresses ON broker_company_agent_properties_branch.addresses_id = addresses.id
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON broker_company_agent_properties_branch.property_types_id = property_types.id
 LEFT JOIN properties_facts ON broker_company_agent_properties_branch.id = properties_facts.properties_id and properties_facts.property = 3
 LEFT JOIN broker_company_branches_agents ON broker_company_agent_properties_branch.broker_company_branches_agents = broker_company_branches_agents.id
 LEFT JOIN users ON broker_company_branches_agents.users_id = users.id
 LEFT JOIN broker_companies_branches ON broker_company_branches_agents.broker_companies_branches_id = broker_companies_branches.id
 LEFT JOIN broker_company_agent_properties_media_branch ON broker_company_agent_properties_branch.id = broker_company_agent_properties_media_branch.id

 WHERE 
    addresses.cities_id = @cities_id::bigint
	--         -- section
	AND LOWER(broker_company_agent_properties_branch.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  broker_company_agent_properties_branch.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(broker_company_agent_properties_media_branch.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media_branch.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media_branch.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media_branch.panaroma_url,
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
		OR broker_company_agent_properties_branch.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR broker_company_agent_properties_branch.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			broker_company_agent_properties_branch.property_title ILIKE @search::varchar
			OR broker_company_agent_properties_branch.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND broker_company_agent_properties_branch.status != 5
	AND broker_company_agent_properties_branch.status != 6
) SELECT count(*) FROM x;

-- name: GetCountCommunityPropertyHub :one
With x As(
 SELECT freelancers_properties.id, freelancers_properties.property_title,freelancers_properties.property_name, freelancers_properties.property_title_arabic, freelancers_properties.description, freelancers_properties.description_arabic, freelancers_properties.is_verified, freelancers_properties.property_rank, freelancers_properties.addresses_id, freelancers_properties.locations_id, freelancers_properties.property_types_id, freelancers_properties.profiles_id, freelancers_properties.facilities_id, freelancers_properties.amenities_id, freelancers_properties.status, freelancers_properties.created_at AS created_time, freelancers_properties.updated_at, freelancers_properties.is_show_owner_info, freelancers_properties.property, freelancers_properties.countries_id, freelancers_properties.ref_no,freelancers_properties.users_id, FALSE AS is_branch,0 AS broker_company_agents, 0 AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from freelancers_properties
 LEFT JOIN addresses ON freelancers_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON freelancers_properties.property_types_id = property_types.id
 LEFT JOIN properties_facts ON freelancers_properties.id = properties_facts.properties_id and properties_facts.property = 2
 LEFT JOIN freelancers_properties_media ON freelancers_properties.id = freelancers_properties_media.id
 WHERE 
    addresses.communities_id = @communities_id::bigint
	--         -- section
	AND LOWER(freelancers_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  freelancers_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(freelancers_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(freelancers_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(freelancers_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(freelancers_properties_media.panaroma_url,
				@panaroma_url) IS NOT NULL))
	---------------------- from here normal sale section --------------------------
	AND(ARRAY_LENGTH(@unit_rank::bigint [],
			1) IS NULL
		OR freelancers_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR freelancers_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			freelancers_properties.property_title ILIKE @search::varchar
			OR freelancers_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND freelancers_properties.status != 5
	AND freelancers_properties.status != 6
           UNION ALL
 SELECT owner_properties.id, owner_properties.property_title,owner_properties.property_name, owner_properties.property_title_arabic, owner_properties.description, owner_properties.description_arabic, owner_properties.is_verified, owner_properties.property_rank, owner_properties.addresses_id, owner_properties.locations_id, owner_properties.property_types_id, owner_properties.profiles_id, owner_properties.facilities_id, owner_properties.amenities_id, owner_properties.status, owner_properties.created_at AS created_time, owner_properties.updated_at, owner_properties.is_show_owner_info, owner_properties.property, owner_properties.countries_id, owner_properties.ref_no,owner_properties.users_id, FALSE AS is_branch,0 AS broker_company_agents, 0 AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from owner_properties
 LEFT JOIN addresses ON owner_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON owner_properties.property_types_id = property_types.id
 LEFT JOIN properties_facts ON owner_properties.id = properties_facts.properties_id and properties_facts.property = 4
 LEFT JOIN owner_properties_media ON owner_properties.id = owner_properties_media.id
 WHERE 
    addresses.communities_id = @communities_id::bigint
	--         -- section
	AND LOWER(owner_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  owner_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::bigint [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::bigint []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(owner_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(owner_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(owner_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(owner_properties_media.panaroma_url,
				@panaroma_url) IS NOT NULL))
	---------------------- from here normal sale section --------------------------
	AND(ARRAY_LENGTH(@unit_rank::bigint [],
			1) IS NULL
		OR owner_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR owner_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			owner_properties.property_title ILIKE @search::varchar
			OR owner_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND owner_properties.status != 5
	AND owner_properties.status != 6
                   UNION ALL 
 SELECT broker_company_agent_properties.id, broker_company_agent_properties.property_title,broker_company_agent_properties.property_name, broker_company_agent_properties.property_title_arabic, broker_company_agent_properties.description, broker_company_agent_properties.description_arabic, broker_company_agent_properties.is_verified, broker_company_agent_properties.property_rank, broker_company_agent_properties.addresses_id, broker_company_agent_properties.locations_id, broker_company_agent_properties.property_types_id, broker_company_agent_properties.profiles_id, broker_company_agent_properties.facilities_id, broker_company_agent_properties.amenities_id, broker_company_agent_properties.status, broker_company_agent_properties.created_at AS created_time, broker_company_agent_properties.updated_at, broker_company_agent_properties.is_show_owner_info, broker_company_agent_properties.property, broker_company_agent_properties.countries_id, broker_company_agent_properties.ref_no,broker_company_agent_properties.users_id, broker_company_agent_properties.is_branch, broker_company_agents, broker_company_agent_properties.broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from broker_company_agent_properties
 LEFT JOIN addresses ON broker_company_agent_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON broker_company_agent_properties.property_types_id = property_types.id
 LEFT JOIN properties_facts ON broker_company_agent_properties.id = properties_facts.properties_id and properties_facts.property = 3
 LEFT JOIN broker_company_agents ON broker_company_agent_properties.broker_company_agents = broker_company_agents.id
 LEFT JOIN users ON broker_company_agents.users_id = users.id
 LEFT JOIN broker_companies ON broker_company_agents.broker_companies_id = broker_companies.id
 LEFT JOIN broker_company_agent_properties_media ON broker_company_agent_properties.id = broker_company_agent_properties_media.id
 WHERE 
    addresses.communities_id = @communities_id::bigint
	--         -- section
	AND LOWER(broker_company_agent_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  broker_company_agent_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::bigint [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::bigint []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(broker_company_agent_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media.panaroma_url,
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
		OR broker_company_agent_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR broker_company_agent_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			broker_company_agent_properties.property_title ILIKE @search::varchar
			OR broker_company_agent_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND broker_company_agent_properties.status != 5
	AND broker_company_agent_properties.status != 6
        UNION ALL 
 SELECT broker_company_agent_properties_branch.id, broker_company_agent_properties_branch.property_title,broker_company_agent_properties_branch.property_name, broker_company_agent_properties_branch.property_title_arabic, broker_company_agent_properties_branch.description, broker_company_agent_properties_branch.description_arabic, broker_company_agent_properties_branch.is_verified, broker_company_agent_properties_branch.property_rank, broker_company_agent_properties_branch.addresses_id, broker_company_agent_properties_branch.locations_id, broker_company_agent_properties_branch.property_types_id, broker_company_agent_properties_branch.profiles_id, broker_company_agent_properties_branch.facilities_id, broker_company_agent_properties_branch.amenities_id, broker_company_agent_properties_branch.status, broker_company_agent_properties_branch.created_at AS created_time, broker_company_agent_properties_branch.updated_at, broker_company_agent_properties_branch.is_show_owner_info, broker_company_agent_properties_branch.property, broker_company_agent_properties_branch.countries_id, broker_company_agent_properties_branch.ref_no,broker_company_agent_properties_branch.users_id, broker_company_agent_properties_branch.is_branch,broker_company_agent_properties_branch.broker_company_branches_agents AS broker_company_agents, broker_company_agent_properties_branch.broker_companies_branches_id AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from broker_company_agent_properties_branch 
 LEFT JOIN addresses ON broker_company_agent_properties_branch.addresses_id = addresses.id
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON broker_company_agent_properties_branch.property_types_id = property_types.id
 LEFT JOIN properties_facts ON broker_company_agent_properties_branch.id = properties_facts.properties_id and properties_facts.property = 3
 LEFT JOIN broker_company_branches_agents ON broker_company_agent_properties_branch.broker_company_branches_agents = broker_company_branches_agents.id
 LEFT JOIN users ON broker_company_branches_agents.users_id = users.id
 LEFT JOIN broker_companies_branches ON broker_company_branches_agents.broker_companies_branches_id = broker_companies_branches.id
 LEFT JOIN broker_company_agent_properties_media_branch ON broker_company_agent_properties_branch.id = broker_company_agent_properties_media_branch.id

 WHERE 
    addresses.communities_id = @communities_id::bigint
	--         -- section
	AND LOWER(broker_company_agent_properties_branch.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  broker_company_agent_properties_branch.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::bigint [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::bigint []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(broker_company_agent_properties_media_branch.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media_branch.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media_branch.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media_branch.panaroma_url,
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
		OR broker_company_agent_properties_branch.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR broker_company_agent_properties_branch.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			broker_company_agent_properties_branch.property_title ILIKE @search::varchar
			OR broker_company_agent_properties_branch.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND broker_company_agent_properties_branch.status != 5
	AND broker_company_agent_properties_branch.status != 6
) SELECT count(*) FROM x;


-- name: GetCountSubCommunityPropertyHub :one
With x As(
 SELECT freelancers_properties.id, freelancers_properties.property_title,freelancers_properties.property_name, freelancers_properties.property_title_arabic, freelancers_properties.description, freelancers_properties.description_arabic, freelancers_properties.is_verified, freelancers_properties.property_rank, freelancers_properties.addresses_id, freelancers_properties.locations_id, freelancers_properties.property_types_id, freelancers_properties.profiles_id, freelancers_properties.facilities_id, freelancers_properties.amenities_id, freelancers_properties.status, freelancers_properties.created_at AS created_time, freelancers_properties.updated_at, freelancers_properties.is_show_owner_info, freelancers_properties.property, freelancers_properties.countries_id, freelancers_properties.ref_no,freelancers_properties.users_id, FALSE AS is_branch,0 AS broker_company_agents, 0 AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from freelancers_properties
 LEFT JOIN addresses ON freelancers_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON freelancers_properties.property_types_id = property_types.id
 LEFT JOIN properties_facts ON freelancers_properties.id = properties_facts.properties_id and properties_facts.property = 2
 LEFT JOIN freelancers_properties_media ON freelancers_properties.id = freelancers_properties_media.id
 WHERE 
    addresses.sub_communities_id  = @sub_communities_id::bigint
	--         -- section
	AND LOWER(freelancers_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  freelancers_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(freelancers_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(freelancers_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(freelancers_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(freelancers_properties_media.panaroma_url,
				@panaroma_url) IS NOT NULL))
	---------------------- from here normal sale section --------------------------
	AND(ARRAY_LENGTH(@unit_rank::bigint [],
			1) IS NULL
		OR freelancers_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR freelancers_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			freelancers_properties.property_title ILIKE @search::varchar
			OR freelancers_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND freelancers_properties.status != 5
	AND freelancers_properties.status != 6
           UNION ALL
 SELECT owner_properties.id, owner_properties.property_title,owner_properties.property_name, owner_properties.property_title_arabic, owner_properties.description, owner_properties.description_arabic, owner_properties.is_verified, owner_properties.property_rank, owner_properties.addresses_id, owner_properties.locations_id, owner_properties.property_types_id, owner_properties.profiles_id, owner_properties.facilities_id, owner_properties.amenities_id, owner_properties.status, owner_properties.created_at AS created_time, owner_properties.updated_at, owner_properties.is_show_owner_info, owner_properties.property, owner_properties.countries_id, owner_properties.ref_no,owner_properties.users_id, FALSE AS is_branch,0 AS broker_company_agents, 0 AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from owner_properties
 LEFT JOIN addresses ON owner_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON owner_properties.property_types_id = property_types.id
 LEFT JOIN properties_facts ON owner_properties.id = properties_facts.properties_id and properties_facts.property = 4
 LEFT JOIN owner_properties_media ON owner_properties.id = owner_properties_media.id
 WHERE 
     addresses.sub_communities_id  = @sub_communities_id::bigint
	--         -- section
	AND LOWER(owner_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  owner_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(owner_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(owner_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(owner_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(owner_properties_media.panaroma_url,
				@panaroma_url) IS NOT NULL))
	---------------------- from here normal sale section --------------------------
	AND(ARRAY_LENGTH(@unit_rank::bigint [],
			1) IS NULL
		OR owner_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR owner_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			owner_properties.property_title ILIKE @search::varchar
			OR owner_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND owner_properties.status != 5
	AND owner_properties.status != 6
                   UNION ALL 
 SELECT broker_company_agent_properties.id, broker_company_agent_properties.property_title,broker_company_agent_properties.property_name, broker_company_agent_properties.property_title_arabic, broker_company_agent_properties.description, broker_company_agent_properties.description_arabic, broker_company_agent_properties.is_verified, broker_company_agent_properties.property_rank, broker_company_agent_properties.addresses_id, broker_company_agent_properties.locations_id, broker_company_agent_properties.property_types_id, broker_company_agent_properties.profiles_id, broker_company_agent_properties.facilities_id, broker_company_agent_properties.amenities_id, broker_company_agent_properties.status, broker_company_agent_properties.created_at AS created_time, broker_company_agent_properties.updated_at, broker_company_agent_properties.is_show_owner_info, broker_company_agent_properties.property, broker_company_agent_properties.countries_id, broker_company_agent_properties.ref_no,broker_company_agent_properties.users_id, broker_company_agent_properties.is_branch, broker_company_agents, broker_company_agent_properties.broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from broker_company_agent_properties
 LEFT JOIN addresses ON broker_company_agent_properties.addresses_id = addresses.id 
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON broker_company_agent_properties.property_types_id = property_types.id
 LEFT JOIN properties_facts ON broker_company_agent_properties.id = properties_facts.properties_id and properties_facts.property = 3
 LEFT JOIN broker_company_agents ON broker_company_agent_properties.broker_company_agents = broker_company_agents.id
 LEFT JOIN users ON broker_company_agents.users_id = users.id
 LEFT JOIN broker_companies ON broker_company_agents.broker_companies_id = broker_companies.id
 LEFT JOIN broker_company_agent_properties_media ON broker_company_agent_properties.id = broker_company_agent_properties_media.id
 WHERE 
     addresses.sub_communities_id  = @sub_communities_id::bigint
	--         -- section
	AND LOWER(broker_company_agent_properties.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  broker_company_agent_properties.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(broker_company_agent_properties_media.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media.panaroma_url,
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
		OR broker_company_agent_properties.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR broker_company_agent_properties.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			broker_company_agent_properties.property_title ILIKE @search::varchar
			OR broker_company_agent_properties.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND broker_company_agent_properties.status != 5
	AND broker_company_agent_properties.status != 6
        UNION ALL 
 SELECT broker_company_agent_properties_branch.id, broker_company_agent_properties_branch.property_title,broker_company_agent_properties_branch.property_name, broker_company_agent_properties_branch.property_title_arabic, broker_company_agent_properties_branch.description, broker_company_agent_properties_branch.description_arabic, broker_company_agent_properties_branch.is_verified, broker_company_agent_properties_branch.property_rank, broker_company_agent_properties_branch.addresses_id, broker_company_agent_properties_branch.locations_id, broker_company_agent_properties_branch.property_types_id, broker_company_agent_properties_branch.profiles_id, broker_company_agent_properties_branch.facilities_id, broker_company_agent_properties_branch.amenities_id, broker_company_agent_properties_branch.status, broker_company_agent_properties_branch.created_at AS created_time, broker_company_agent_properties_branch.updated_at, broker_company_agent_properties_branch.is_show_owner_info, broker_company_agent_properties_branch.property, broker_company_agent_properties_branch.countries_id, broker_company_agent_properties_branch.ref_no,broker_company_agent_properties_branch.users_id, broker_company_agent_properties_branch.is_branch,broker_company_agent_properties_branch.broker_company_branches_agents AS broker_company_agents, broker_company_agent_properties_branch.broker_companies_branches_id AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from broker_company_agent_properties_branch 
 LEFT JOIN addresses ON broker_company_agent_properties_branch.addresses_id = addresses.id
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 LEFT JOIN property_types ON broker_company_agent_properties_branch.property_types_id = property_types.id
 LEFT JOIN properties_facts ON broker_company_agent_properties_branch.id = properties_facts.properties_id and properties_facts.property = 3
 LEFT JOIN broker_company_branches_agents ON broker_company_agent_properties_branch.broker_company_branches_agents = broker_company_branches_agents.id
 LEFT JOIN users ON broker_company_branches_agents.users_id = users.id
 LEFT JOIN broker_companies_branches ON broker_company_branches_agents.broker_companies_branches_id = broker_companies_branches.id
 LEFT JOIN broker_company_agent_properties_media_branch ON broker_company_agent_properties_branch.id = broker_company_agent_properties_media_branch.id

 WHERE 
    addresses.sub_communities_id  = @sub_communities_id::bigint
	--         -- section
	AND LOWER(broker_company_agent_properties_branch.category)
	ILIKE @category_section::varchar
	--         -- category or type
	AND property_types.type ILIKE @property_type::varchar
		--  reference number
    AND (@ref::varchar = '%%'
		OR  broker_company_agent_properties_branch.ref_no ILIKE @ref::varchar)

	--         -- price
	AND(properties_facts.price BETWEEN @min_price::bigint
		AND @max_price::bigint)
	--         -- bedroom
	AND(ARRAY_LENGTH(@bedrooms::varchar [],
			1) IS NULL
		OR properties_facts.bedroom = ANY (@bedrooms::varchar []))
	--       	-- bathroom
	AND(ARRAY_LENGTH(@bathrooms::bigint [],
			1) IS NULL
		OR properties_facts.bathroom = ANY (@bathrooms::bigint []))
	--      	-- completion status
	AND CASE WHEN @completion_status::bigint IS NULL THEN
		TRUE
	WHEN @completion_status::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.completion_status = @completion_status::bigint
	END
	--  ownership
	AND CASE WHEN @ownership::bigint IS NULL THEN
		TRUE
	WHEN @ownership::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.ownership = @ownership::bigint
	END
	--     	--  plot area
	AND(
		CASE WHEN @min_plot_area::float IS NULL THEN
			TRUE
		WHEN @min_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area >= @min_plot_area::float
		END
		-- max plot area
		AND CASE WHEN @max_plot_area::float IS NULL THEN
			TRUE
		WHEN @max_plot_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.plot_area <= @max_plot_area::float
		END)
	--         --   build-up area
	AND(
		CASE WHEN @min_buildup_area::float IS NULL THEN
			TRUE
		WHEN @min_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area >= @min_buildup_area::float
		END
		-- max builup area
		AND CASE WHEN @max_buildup_area::float IS NULL THEN
			TRUE
		WHEN @max_buildup_area::float = 0.0 THEN
			TRUE
		ELSE
			properties_facts.built_up_area <= @max_buildup_area::float
		END)
	--  	     --  furnishing
	AND CASE WHEN @furnished::bigint IS NULL THEN
		TRUE
	WHEN @furnished::bigint = 0 THEN
		TRUE
	ELSE
		properties_facts.furnished = @furnished::bigint
	END
	--  	     --  Parking
	AND(ARRAY_LENGTH(@parkings::bigint [],
			1) IS NULL
		OR properties_facts.parking = ANY (@parkings::bigint []))
	--  	     --  service charges
	AND(
		CASE WHEN @min_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @min_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge >= @min_service_charges::bigint
		END
		-- max service charges
		AND CASE WHEN @max_service_charges::bigint IS NULL THEN
			TRUE
		WHEN @max_service_charges::bigint = 0 THEN
			TRUE
		ELSE
			properties_facts.service_charge <= @max_service_charges::bigint
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
			properties_facts. "view" && @views::bigint []
		END)
	-- media
	AND(@media::bigint = 0
		OR(array_length(broker_company_agent_properties_media_branch.image_url,
				@image_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media_branch.image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media_branch.video_url,
				@video_url) IS NOT NULL)
		OR(array_length(broker_company_agent_properties_media_branch.panaroma_url,
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
		OR broker_company_agent_properties_branch.property_rank = ANY (@unit_rank::bigint []))
	AND(communities.community ILIKE @community::varchar
		OR communities.community IS NULL)
	AND(sub_communities.sub_community ILIKE @sub_community::varchar
		OR sub_communities.sub_community IS NULL)
	AND(@is_verified::bool IS NULL
		OR broker_company_agent_properties_branch.is_verified = @is_verified::bool)
	--  search purpose
	AND(
		CASE WHEN @search::varchar IS NULL THEN
			TRUE
		ELSE
			broker_company_agent_properties_branch.property_title ILIKE @search::varchar
			OR broker_company_agent_properties_branch.property_title_arabic ILIKE @search::varchar
			OR property_types.type ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
		END)
	--  removing the blocked and deleted units only
	AND broker_company_agent_properties_branch.status != 5
	AND broker_company_agent_properties_branch.status != 6
) SELECT count(*) FROM x;


-- name: GetAllPropertyHubCount :one
WITH x AS(
SELECT id, property_rank FROM freelancers_properties 
 Where  status != 5 AND status != 6 
 UNION ALL
 SELECT id, property_rank FROM owner_properties 
 Where  status != 5 AND status != 6 
 UNION ALL
select id, property_rank FROM broker_company_agent_properties 
 Where  status != 5 AND status != 6 
 UNION ALL
 SELECT id, property_rank FROM broker_company_agent_properties_branch 
 Where  status != 5 AND status != 6 
 )
SELECT COUNT(id) AS total_count FROM x;


-- name: SearchAllSubCommunities :many
select  id, sub_community from sub_communities
where lower(sub_community) ilike lower($1);

-- name: SearchAllCommunities :many
select id, community from communities
where lower(community) ilike lower($1);

-- name: SearchAllCities :many
select  id, city  from cities 
where lower(city) ilike lower($1);

-- name: SearchAllState :many
select  id, state from states 
where lower(city) ilike lower($1);

-- name: GetAllAddressesByState :many
select id from addresses where states_id = $1;

-- name: GetAllAddressesByCities :many
select id from addresses where cities_id = $1;

-- name: GetAllAddressesByCommunities :many
select id from addresses where communities_id = $1;

-- name: GetAllAddressesBySubCommunities :many
select id from addresses where sub_communities_id = $1;





-- name: GetCountAllPropertyHubByFacts :one
 WITH x AS( 
 SELECT id,property_title,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_at,updated_at,is_show_owner_info,property, countries_id,ref_no,FALSE AS is_branch, 0 as broker_companies_id 
 FROM freelancers_properties
 WHERE freelancers_properties.property_rank = 4 AND(status!= 5 AND status!= 6)
 UNION ALL
 SELECT id,property_title,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_at,updated_at,is_show_owner_info,property, countries_id,ref_no,FALSE AS is_branch, 0 as broker_companies_id
 FROM freelancers_properties
 WHERE freelancers_properties.property_rank = 3 AND(status!= 5 AND status!= 6)
 UNION ALL
 SELECT id,property_title,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_at,updated_at,is_show_owner_info,property, countries_id,ref_no,FALSE AS is_branch, 0 as broker_companies_id
 FROM freelancers_properties
 WHERE freelancers_properties.property_rank = 2 AND(status!= 5 AND status!= 6)
 UNION ALL
 SELECT id,property_title,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_at,updated_at,is_show_owner_info,property, countries_id,ref_no,FALSE AS is_branch, 0 as broker_companies_id
 FROM freelancers_properties
 WHERE freelancers_properties.property_rank = 1 AND(status!= 5 AND status!= 6)
 UNION all
 SELECT id,property_title,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_at,updated_at,is_show_owner_info,property, countries_id,ref_no,FALSE AS is_branch, 0 as broker_companies_id
 FROM owner_properties
 WHERE owner_properties.property_rank = 4 AND(status!= 5 AND status!= 6)
 UNION all
 SELECT id,property_title,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_at,updated_at,is_show_owner_info,property, countries_id,ref_no,FALSE AS is_branch, 0 as broker_companies_id
 FROM owner_properties
 WHERE owner_properties.property_rank = 3 AND(status!= 5 AND status!= 6)
 UNION all 
 SELECT id,property_title,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_at,updated_at,is_show_owner_info,property, countries_id,ref_no,FALSE AS is_branch, 0 as broker_companies_id
 FROM owner_properties
 WHERE owner_properties.property_rank = 2 AND(status!= 5 AND status!= 6)
 UNION all
 SELECT id,property_title,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_at,updated_at,is_show_owner_info,property, countries_id,ref_no,FALSE AS is_branch, 0 as broker_companies_id
 FROM owner_properties
 WHERE owner_properties.property_rank = 1 AND(status!= 5 AND status!= 6)
 UNION ALL
 SELECT id,property_title,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_at,updated_at,is_show_owner_info,property, countries_id,ref_no,is_branch,broker_companies_id FROM broker_company_agent_properties
 WHERE broker_company_agent_properties.property_rank = 4 and (status!= 5 AND status!= 6)
 UNION ALL
 SELECT id,property_title,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_at,updated_at,is_show_owner_info,property, countries_id,ref_no,is_branch,broker_companies_id FROM broker_company_agent_properties
 WHERE broker_company_agent_properties.property_rank = 3 and (status!= 5 AND status!= 6)
 UNION ALL
 SELECT id,property_title,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_at,updated_at,is_show_owner_info,property, countries_id,ref_no,is_branch,broker_companies_id FROM broker_company_agent_properties
 WHERE broker_company_agent_properties.property_rank = 2 and (status!= 5 AND status!= 6)
 UNION ALL
 SELECT id,property_title,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_at,updated_at,is_show_owner_info,property, countries_id,ref_no,is_branch,broker_companies_id FROM broker_company_agent_properties
 WHERE broker_company_agent_properties.property_rank = 1  and (status!= 5 AND status!= 6)
 UNION ALL
  SELECT id,property_title,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_at,updated_at,is_show_owner_info,property, countries_id,ref_no,is_branch,broker_companies_branches_id as broker_companies_id FROM broker_company_agent_properties_branch
  WHERE broker_company_agent_properties_branch.property_rank = 4 and (status!= 5 AND status!= 6)
 -- premium
 UNION ALL
 SELECT id,property_title,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_at,updated_at,is_show_owner_info,property, countries_id,ref_no,is_branch,broker_companies_branches_id as broker_companies_id FROM broker_company_agent_properties_branch
 WHERE broker_company_agent_properties_branch.property_rank = 3 and (status!= 5 AND status!= 6)
 -- featured
  UNION ALL
 SELECT id,property_title,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_at,updated_at,is_show_owner_info,property, countries_id,ref_no,is_branch,broker_companies_branches_id as broker_companies_id FROM broker_company_agent_properties_branch
 WHERE broker_company_agent_properties_branch.property_rank = 2 and (status!= 5 AND status!= 6)
 -- standard
  UNION ALL
 SELECT id,property_title,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_at,updated_at,is_show_owner_info,property, countries_id,ref_no,is_branch,broker_companies_branches_id as broker_companies_id FROM broker_company_agent_properties_branch
 WHERE broker_company_agent_properties_branch.property_rank = 1 and (status!= 5 AND status!= 6)
 )
   SELECT COUNT(*) AS total_count
FROM x
JOIN properties_facts pf ON x.id = pf.properties_id;





-- name: GetPropertyUnitLikeByPropertyIdAndWhichPropertyAndWhichPropertyHubKey :one
SELECT id, property_unit_id, which_property_unit, which_propertyhub_key, is_branch, is_liked, like_reaction_id, users_id, created_at, updated_at FROM property_unit_likes 
WHERE  property_unit_id = $1 And which_property_unit = $2 AND is_branch = $3 and which_propertyhub_key = $4 AND users_id = $5  LIMIT 1;


-- name: GetPropertyUnitSavedByPropertyIdAndIdAndWhichPropertyAndWhichPropertyHubKey :one
SELECT * FROM property_unit_saved 
WHERE  property_unit_id = $1 And which_property_unit = $2 and which_propertyhub_key = $3 AND is_branch = $4 AND users_id = $5  LIMIT 1;



-- name: GetAllPropertyUnitSavedByPropertyIdAndIdAndWhichPropertyAndWhichPropertyHubKey :many
SELECT id FROM property_unit_saved 
WHERE property_unit_id = $1 And which_property_unit = $2 AND is_branch = $3 AND users_id = $4 and  which_propertyhub_key= $5 AND is_saved=TRUE;


-- name: GetOverallPropertyHubCountByCountryAndSectionId :one
With x As(
 select count(*) from freelancers_properties where freelancers_properties.countries_id = $1 and freelancers_properties.category = $2 and freelancers_properties.status != 5 and freelancers_properties.status != 6 
 union all 
 select count(*) from owner_properties where owner_properties.countries_id = $1 and owner_properties.category = $2 and owner_properties.status != 5 and owner_properties.status != 6 
union all 
select count(*) from broker_company_agent_properties where broker_company_agent_properties.countries_id = $1 and broker_company_agent_properties.category = $2 and broker_company_agent_properties.status != 5 and broker_company_agent_properties.status != 6 
union all 
select count(*) from broker_company_agent_properties_branch where broker_company_agent_properties_branch.countries_id = $1 and broker_company_agent_properties_branch.category = $2 and broker_company_agent_properties_branch.status != 5 and broker_company_agent_properties_branch.status != 6 
) SELECT SUM(count) AS counts FROM x;