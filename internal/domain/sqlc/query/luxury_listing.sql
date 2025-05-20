-- name: FilterLuxuryProperties :many
With x As(
 SELECT freelancers_properties.id, freelancers_properties.property_title,freelancers_properties.property_name, freelancers_properties.property_title_arabic, freelancers_properties.description, freelancers_properties.description_arabic, freelancers_properties.is_verified, freelancers_properties.property_rank, freelancers_properties.addresses_id, freelancers_properties.locations_id, freelancers_properties.property_types_id, freelancers_properties.profiles_id, freelancers_properties.facilities_id, freelancers_properties.amenities_id, freelancers_properties.status, freelancers_properties.created_at AS created_time, freelancers_properties.updated_at, freelancers_properties.is_show_owner_info, freelancers_properties.property, freelancers_properties.countries_id, freelancers_properties.ref_no,freelancers_properties.users_id, FALSE AS is_branch,0 AS broker_company_agents, 0 AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from freelancers_properties
 INNER JOIN addresses ON freelancers_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON freelancers_properties.property_types_id = property_types.id
 INNER JOIN properties_facts ON freelancers_properties.id = properties_facts.properties_id and properties_facts.property = 2
 WHERE 
         freelancers_properties.category = $11 AND
         addresses.countries_id = $1 AND
         ($2::bigint[] is NULL OR freelancers_properties.property_rank = ANY($2::bigint[]))  AND
          cities.city ILIKE '%' || $3 || '%'  AND                 
          communities.community ILIKE '%' || $4 || '%'  AND       
          sub_communities.sub_community ILIKE '%' || $5 || '%'
         AND ($6::bool is NULL OR is_verified = $6::bool)
         AND (properties_facts.life_style = 3 OR properties_facts.life_style = 4)
         AND (  
             freelancers_properties.property_title ILIKE '%' || $7 || '%'  OR 
             freelancers_properties.property_title_arabic ILIKE '%' || $7 || '%'  OR   
             property_types.type  ILIKE '%' || $7 || '%'  OR 
             cities.city ILIKE '%' || $7 || '%' OR
             communities.community ILIKE '%' || $7 || '%' OR
             sub_communities.sub_community ILIKE '%' || $7 || '%'
         ) AND freelancers_properties.status != 5 AND freelancers_properties.status != 6
           UNION ALL
 SELECT owner_properties.id, owner_properties.property_title,owner_properties.property_name, owner_properties.property_title_arabic, owner_properties.description, owner_properties.description_arabic, owner_properties.is_verified, owner_properties.property_rank, owner_properties.addresses_id, owner_properties.locations_id, owner_properties.property_types_id, owner_properties.profiles_id, owner_properties.facilities_id, owner_properties.amenities_id, owner_properties.status, owner_properties.created_at AS created_time, owner_properties.updated_at, owner_properties.is_show_owner_info, owner_properties.property, owner_properties.countries_id, owner_properties.ref_no,owner_properties.users_id, FALSE AS is_branch,0 AS broker_company_agents, 0 AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from owner_properties
 INNER JOIN addresses ON owner_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON owner_properties.property_types_id = property_types.id
 INNER JOIN properties_facts ON owner_properties.id = properties_facts.properties_id and properties_facts.property = 4
 WHERE 
          owner_properties.category = $11 AND
          addresses.countries_id = $1 AND
         ($2::bigint[] is NULL OR owner_properties.property_rank = ANY($2::bigint[]))  AND
          cities.city ILIKE '%' || $3 || '%'  AND                 
          communities.community ILIKE '%' || $4 || '%'  AND       
          sub_communities.sub_community ILIKE '%' || $5 || '%'
         AND ($6::bool is NULL OR is_verified = $6::bool)
         AND (properties_facts.life_style = 3 OR properties_facts.life_style = 4)
         AND (
             owner_properties.property_title ILIKE '%' || $7 || '%'  OR 
             owner_properties.property_title_arabic ILIKE '%' || $7 || '%'  OR   
             property_types.type  ILIKE '%' || $7 || '%'  OR 
             cities.city ILIKE '%' || $7 || '%' OR
             communities.community ILIKE '%' || $7 || '%' OR
             sub_communities.sub_community ILIKE '%' || $7 || '%'
       ) AND owner_properties.status != 5 AND owner_properties.status != 6
                   UNION ALL 
 SELECT broker_company_agent_properties.id, broker_company_agent_properties.property_title,broker_company_agent_properties.property_name, broker_company_agent_properties.property_title_arabic, broker_company_agent_properties.description, broker_company_agent_properties.description_arabic, broker_company_agent_properties.is_verified, broker_company_agent_properties.property_rank, broker_company_agent_properties.addresses_id, broker_company_agent_properties.locations_id, broker_company_agent_properties.property_types_id, broker_company_agent_properties.profiles_id, broker_company_agent_properties.facilities_id, broker_company_agent_properties.amenities_id, broker_company_agent_properties.status, broker_company_agent_properties.created_at AS created_time, broker_company_agent_properties.updated_at, broker_company_agent_properties.is_show_owner_info, broker_company_agent_properties.property, broker_company_agent_properties.countries_id, broker_company_agent_properties.ref_no,broker_company_agent_properties.users_id, broker_company_agent_properties.is_branch, broker_company_agents, broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from broker_company_agent_properties
 INNER JOIN addresses ON broker_company_agent_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON broker_company_agent_properties.property_types_id = property_types.id
 INNER JOIN properties_facts ON broker_company_agent_properties.id = properties_facts.properties_id and properties_facts.property = 3
 WHERE 
          broker_company_agent_properties.category = $11 AND
          addresses.countries_id = $1 AND
         ($2::bigint[] is NULL OR broker_company_agent_properties.property_rank = ANY($2::bigint[]))  AND
          cities.city ILIKE '%' || $3 || '%'  AND                 
          communities.community ILIKE '%' || $4 || '%'  AND       
          sub_communities.sub_community ILIKE '%' || $5 || '%'
         AND ($6::bool is NULL OR is_verified = $6::bool)
         AND (properties_facts.life_style = 3 OR properties_facts.life_style = 4)
         AND (
             broker_company_agent_properties.property_title ILIKE '%' || $7 || '%'  OR 
             broker_company_agent_properties.property_title_arabic ILIKE '%' || $7 || '%'  OR   
             property_types.type  ILIKE '%' || $7 || '%'  OR 
             cities.city ILIKE '%' || $7 || '%' OR
             communities.community ILIKE '%' || $7 || '%' OR
             sub_communities.sub_community ILIKE '%' || $7 || '%'
       ) AND broker_company_agent_properties.status != 5 AND broker_company_agent_properties.status != 6
        UNION ALL 
 SELECT broker_company_agent_properties_branch.id, broker_company_agent_properties_branch.property_title,broker_company_agent_properties_branch.property_name, broker_company_agent_properties_branch.property_title_arabic, broker_company_agent_properties_branch.description, broker_company_agent_properties_branch.description_arabic, broker_company_agent_properties_branch.is_verified, broker_company_agent_properties_branch.property_rank, broker_company_agent_properties_branch.addresses_id, broker_company_agent_properties_branch.locations_id, broker_company_agent_properties_branch.property_types_id, broker_company_agent_properties_branch.profiles_id, broker_company_agent_properties_branch.facilities_id, broker_company_agent_properties_branch.amenities_id, broker_company_agent_properties_branch.status, broker_company_agent_properties_branch.created_at AS created_time, broker_company_agent_properties_branch.updated_at, broker_company_agent_properties_branch.is_show_owner_info, broker_company_agent_properties_branch.property, broker_company_agent_properties_branch.countries_id, broker_company_agent_properties_branch.ref_no,broker_company_agent_properties_branch.users_id, broker_company_agent_properties_branch.is_branch,broker_company_branches_agents AS broker_company_agents, broker_companies_branches_id AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from broker_company_agent_properties_branch 
 INNER JOIN addresses ON broker_company_agent_properties_branch.addresses_id = addresses.id
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON broker_company_agent_properties_branch.property_types_id = property_types.id
 INNER JOIN properties_facts ON broker_company_agent_properties_branch.id = properties_facts.properties_id and properties_facts.property = 3
 WHERE 
           broker_company_agent_properties_branch.category = $11 AND
           addresses.countries_id = $1 AND
         ($2::bigint[] is NULL OR broker_company_agent_properties_branch.property_rank = ANY($2::bigint[]))  AND
          cities.city ILIKE '%' || $3 || '%'  AND                 
          communities.community ILIKE '%' || $4 || '%'  AND       
          sub_communities.sub_community ILIKE '%' || $5 || '%'
         AND ($6::bool is NULL OR is_verified = $6::bool)
         AND (properties_facts.life_style = 3 OR properties_facts.life_style = 4)
         AND (
             broker_company_agent_properties_branch.property_title ILIKE '%' || $7 || '%'  OR 
             broker_company_agent_properties_branch.property_title_arabic ILIKE '%' || $7 || '%'  OR   
             property_types.type  ILIKE '%' || $7 || '%'  OR 
             cities.city ILIKE '%' || $7 || '%' OR
             communities.community ILIKE '%' || $7 || '%' OR
             sub_communities.sub_community ILIKE '%' || $7 || '%'
       ) AND broker_company_agent_properties_branch.status != 5 AND broker_company_agent_properties_branch.status != 6
) SELECT id,property_title,property_name,property_title_arabic,description,description_arabic,is_verified,property_rank,addresses_id,locations_id,property_types_id,profiles_id,facilities_id,amenities_id,status,created_time,updated_at,is_show_owner_info,property, countries_id,ref_no,users_id ,is_branch,broker_company_agents, broker_companies_id FROM x ORDER BY
    CASE WHEN $10::bigint = 5 THEN unit_bedroom END DESC,
    CASE WHEN $10::bigint = 4 THEN unit_bedroom END,
    CASE WHEN $10::bigint = 3 THEN unit_price END DESC,
    CASE WHEN $10::bigint = 2 THEN unit_price END,
    CASE WHEN $10::bigint = 1 THEN created_time END DESC,
    property_rank desc,
    is_verified desc 
LIMIT $8 OFFSET $9;


-- name: FilterCountLuxuryProperty :many
With x As(
 SELECT freelancers_properties.id, freelancers_properties.property_title,freelancers_properties.property_name, freelancers_properties.property_title_arabic, freelancers_properties.description, freelancers_properties.description_arabic, freelancers_properties.is_verified, freelancers_properties.property_rank, freelancers_properties.addresses_id, freelancers_properties.locations_id, freelancers_properties.property_types_id, freelancers_properties.profiles_id, freelancers_properties.facilities_id, freelancers_properties.amenities_id, freelancers_properties.status, freelancers_properties.created_at AS created_time, freelancers_properties.updated_at, freelancers_properties.is_show_owner_info, freelancers_properties.property, freelancers_properties.countries_id, freelancers_properties.ref_no, FALSE AS is_branch, 0 AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from freelancers_properties
 INNER JOIN addresses ON freelancers_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON freelancers_properties.property_types_id = property_types.id
 INNER JOIN properties_facts ON freelancers_properties.id = properties_facts.properties_id and properties_facts.property = 2
 WHERE 
         freelancers_properties.category = $8 AND
         addresses.countries_id = $1 AND
         ($2::bigint[] is NULL OR freelancers_properties.property_rank = ANY($2::bigint[]))  AND
          cities.city ILIKE '%' || $3 || '%'  AND                 
          communities.community ILIKE '%' || $4 || '%'  AND       
         sub_communities.sub_community ILIKE '%' || $5 || '%'
         AND ($6::bool is NULL OR is_verified = $6::bool)
         AND (properties_facts.life_style = 3 OR properties_facts.life_style = 4)
         AND (  
             freelancers_properties.property_title ILIKE '%' || $7 || '%'  OR 
             freelancers_properties.property_title_arabic ILIKE '%' || $7 || '%'  OR   
             property_types.type  ILIKE '%' || $7 || '%'  OR 
             cities.city ILIKE '%' || $7 || '%' OR
             communities.community ILIKE '%' || $7 || '%' OR
             sub_communities.sub_community ILIKE '%' || $7 || '%'
         ) AND freelancers_properties.status != 5 AND freelancers_properties.status != 6
           UNION ALL 
 SELECT owner_properties.id, owner_properties.property_title,owner_properties.property_name, owner_properties.property_title_arabic, owner_properties.description, owner_properties.description_arabic, owner_properties.is_verified, owner_properties.property_rank, owner_properties.addresses_id, owner_properties.locations_id, owner_properties.property_types_id, owner_properties.profiles_id, owner_properties.facilities_id, owner_properties.amenities_id, owner_properties.status, owner_properties.created_at AS created_time, owner_properties.updated_at, owner_properties.is_show_owner_info, owner_properties.property, owner_properties.countries_id, owner_properties.ref_no, FALSE AS is_branch, 0 AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from owner_properties
 INNER JOIN addresses ON owner_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON owner_properties.property_types_id = property_types.id
 INNER JOIN properties_facts ON owner_properties.id = properties_facts.properties_id and properties_facts.property = 4
 WHERE 
          owner_properties.category = $8 AND
          addresses.countries_id = $1 AND
         ($2::bigint[] is NULL OR owner_properties.property_rank = ANY($2::bigint[]))  AND
          cities.city ILIKE '%' || $3 || '%'  AND                 
          communities.community ILIKE '%' || $4 || '%'  AND       
          sub_communities.sub_community ILIKE '%' || $5 || '%'
         AND ($6::bool is NULL OR is_verified = $6::bool)
         AND (properties_facts.life_style = 3 OR properties_facts.life_style = 4)
         AND (
             owner_properties.property_title ILIKE '%' || $7 || '%'  OR 
             owner_properties.property_title_arabic ILIKE '%' || $7 || '%'  OR   
             property_types.type  ILIKE '%' || $7 || '%'  OR 
             cities.city ILIKE '%' || $7 || '%' OR
             communities.community ILIKE '%' || $7 || '%' OR
             sub_communities.sub_community ILIKE '%' || $7 || '%'
       ) AND owner_properties.status != 5 AND owner_properties.status != 6
                   UNION ALL 
 SELECT broker_company_agent_properties.id, broker_company_agent_properties.property_title,broker_company_agent_properties.property_name, broker_company_agent_properties.property_title_arabic, broker_company_agent_properties.description, broker_company_agent_properties.description_arabic, broker_company_agent_properties.is_verified, broker_company_agent_properties.property_rank, broker_company_agent_properties.addresses_id, broker_company_agent_properties.locations_id, broker_company_agent_properties.property_types_id, broker_company_agent_properties.profiles_id, broker_company_agent_properties.facilities_id, broker_company_agent_properties.amenities_id, broker_company_agent_properties.status, broker_company_agent_properties.created_at AS created_time, broker_company_agent_properties.updated_at, broker_company_agent_properties.is_show_owner_info, broker_company_agent_properties.property, broker_company_agent_properties.countries_id, broker_company_agent_properties.ref_no, broker_company_agent_properties.is_branch, broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from broker_company_agent_properties
 INNER JOIN addresses ON broker_company_agent_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON broker_company_agent_properties.property_types_id = property_types.id
 INNER JOIN properties_facts ON broker_company_agent_properties.id = properties_facts.properties_id and properties_facts.property = 3
 WHERE 
          broker_company_agent_properties.category = $8 AND
          addresses.countries_id = $1 AND
         ($2::bigint[] is NULL OR broker_company_agent_properties.property_rank = ANY($2::bigint[]))  AND
          cities.city ILIKE '%' || $3 || '%'  AND                 
          communities.community ILIKE '%' || $4 || '%'  AND       
          sub_communities.sub_community ILIKE '%' || $5 || '%'
         AND ($6::bool is NULL OR is_verified = $6::bool)
         AND (properties_facts.life_style = 3 OR properties_facts.life_style = 4)
         AND (
             broker_company_agent_properties.property_title ILIKE '%' || $7 || '%'  OR 
             broker_company_agent_properties.property_title_arabic ILIKE '%' || $7 || '%'  OR   
             property_types.type  ILIKE '%' || $7 || '%'  OR 
             cities.city ILIKE '%' || $7 || '%' OR
             communities.community ILIKE '%' || $7 || '%' OR
             sub_communities.sub_community ILIKE '%' || $7 || '%'
       ) AND broker_company_agent_properties.status != 5 AND broker_company_agent_properties.status != 6
        UNION ALL 
 SELECT broker_company_agent_properties_branch.id, broker_company_agent_properties_branch.property_title,broker_company_agent_properties_branch.property_name, broker_company_agent_properties_branch.property_title_arabic, broker_company_agent_properties_branch.description, broker_company_agent_properties_branch.description_arabic, broker_company_agent_properties_branch.is_verified, broker_company_agent_properties_branch.property_rank, broker_company_agent_properties_branch.addresses_id, broker_company_agent_properties_branch.locations_id, broker_company_agent_properties_branch.property_types_id, broker_company_agent_properties_branch.profiles_id, broker_company_agent_properties_branch.facilities_id, broker_company_agent_properties_branch.amenities_id, broker_company_agent_properties_branch.status, broker_company_agent_properties_branch.created_at AS created_time, broker_company_agent_properties_branch.updated_at, broker_company_agent_properties_branch.is_show_owner_info, broker_company_agent_properties_branch.property, broker_company_agent_properties_branch.countries_id, broker_company_agent_properties_branch.ref_no, broker_company_agent_properties_branch.is_branch, broker_companies_branches_id AS broker_companies_id,
 properties_facts.price AS unit_price,
 properties_facts.bedroom AS unit_bedroom 
 from broker_company_agent_properties_branch 
 INNER JOIN addresses ON broker_company_agent_properties_branch.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON broker_company_agent_properties_branch.property_types_id = property_types.id
 INNER JOIN properties_facts ON broker_company_agent_properties_branch.id = properties_facts.properties_id and properties_facts.property = 3
 WHERE 
           broker_company_agent_properties_branch.category = $8 AND
           addresses.countries_id = $1 AND
         ($2::bigint[] is NULL OR broker_company_agent_properties_branch.property_rank = ANY($2::bigint[]))  AND
          cities.city ILIKE '%' || $3 || '%'  AND                 
          communities.community ILIKE '%' || $4 || '%'  AND       
          sub_communities.sub_community ILIKE '%' || $5 || '%'
         AND ($6::bool is NULL OR is_verified = $6::bool)
         AND (properties_facts.life_style = 3 OR properties_facts.life_style = 4)
         AND (
             broker_company_agent_properties_branch.property_title ILIKE '%' || $7 || '%'  OR 
             broker_company_agent_properties_branch.property_title_arabic ILIKE '%' || $7 || '%'  OR   
             property_types.type  ILIKE '%' || $7 || '%'  OR 
             cities.city ILIKE '%' || $7 || '%' OR
             communities.community ILIKE '%' || $7 || '%' OR
             sub_communities.sub_community ILIKE '%' || $7 || '%'
       ) AND broker_company_agent_properties_branch.status != 5 AND broker_company_agent_properties_branch.status != 6
) SELECT COUNT(*) FROM x;
























