
 


-- name: GetCountStateIndustrialProperties :one
With x As(
 SELECT count(*) FROM industrial_freelancer_properties
 INNER JOIN addresses ON industrial_freelancer_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON industrial_freelancer_properties.property_types_id = property_types.id
 INNER JOIN industrial_properties_facts ON industrial_freelancer_properties.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 2
 WHERE 
         industrial_freelancer_properties.category = $5 and
         addresses.cities_id = $1 and
         ($2::bigint[] is NULL OR industrial_freelancer_properties.property_rank = ANY($2::bigint[]))  
         AND ($3::bool is NULL OR is_verified = $3::bool)
         AND (
             industrial_freelancer_properties.property_title ILIKE '%' || $4 || '%'  OR 
             industrial_freelancer_properties.property_title_arabic ILIKE '%' || $4 || '%'  OR   
             property_types.type  ILIKE '%' || $4 || '%'  OR 
             cities.city ILIKE '%' || $4 || '%' OR
             communities.community ILIKE '%' || $4 || '%' OR
             sub_communities.sub_community ILIKE '%' || $4 || '%'
            ) AND industrial_freelancer_properties.status != 5 AND industrial_freelancer_properties.status != 6
 UNION ALL
 SELECT count(*) FROM industrial_owner_properties
 INNER JOIN addresses ON industrial_owner_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON industrial_owner_properties.property_types_id = property_types.id
 INNER JOIN industrial_properties_facts ON industrial_owner_properties.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 4
 WHERE 
         industrial_owner_properties.category = $5 and
         addresses.cities_id = $1 and
         ($2::bigint[] is NULL OR industrial_owner_properties.property_rank = ANY($2::bigint[]))  
         AND ($3::bool is NULL OR is_verified = $3::bool)
         AND (
             industrial_owner_properties.property_title ILIKE '%' || $4 || '%'  OR 
             industrial_owner_properties.property_title_arabic ILIKE '%' || $4 || '%'  OR   
             property_types.type  ILIKE '%' || $4 || '%'  OR 
             cities.city ILIKE '%' || $4 || '%' OR
             communities.community ILIKE '%' || $4 || '%' OR
             sub_communities.sub_community ILIKE '%' || $4 || '%'
            ) AND industrial_owner_properties.status != 5 AND industrial_owner_properties.status != 6
 UNION ALL
 SELECT count(*) FROM industrial_broker_agent_properties
 INNER JOIN addresses ON industrial_broker_agent_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON industrial_broker_agent_properties.property_types_id = property_types.id
 INNER JOIN industrial_properties_facts ON industrial_broker_agent_properties.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 3
 WHERE 
         industrial_broker_agent_properties.category = $5 and
         addresses.cities_id = $1 and
         ($2::bigint[] is NULL OR industrial_broker_agent_properties.property_rank = ANY($2::bigint[]))  
         AND ($3::bool is NULL OR is_verified = $3::bool)
         AND (
             industrial_broker_agent_properties.property_title ILIKE '%' || $4 || '%'  OR 
             industrial_broker_agent_properties.property_title_arabic ILIKE '%' || $4 || '%'  OR   
             property_types.type  ILIKE '%' || $4 || '%'  OR 
             cities.city ILIKE '%' || $4 || '%' OR
             communities.community ILIKE '%' || $4 || '%' OR
             sub_communities.sub_community ILIKE '%' || $4 || '%'
            ) AND industrial_broker_agent_properties.status != 5 AND industrial_broker_agent_properties.status != 6
 UNION ALL
 SELECT count(*) FROM industrial_broker_agent_properties_branch
 INNER JOIN addresses ON industrial_broker_agent_properties_branch.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON industrial_broker_agent_properties_branch.property_types_id = property_types.id
 INNER JOIN industrial_properties_facts ON industrial_broker_agent_properties_branch.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 3
 WHERE 
         industrial_broker_agent_properties_branch.category = $5 and
         addresses.cities_id = $1 and
         ($2::bigint[] is NULL OR industrial_broker_agent_properties_branch.property_rank = ANY($2::bigint[]))  
         AND ($3::bool is NULL OR is_verified = $3::bool)
         AND (
             industrial_broker_agent_properties_branch.property_title ILIKE '%' || $4 || '%'  OR 
             industrial_broker_agent_properties_branch.property_title_arabic ILIKE '%' || $4 || '%'  OR   
             property_types.type  ILIKE '%' || $4 || '%'  OR 
             cities.city ILIKE '%' || $4 || '%' OR
             communities.community ILIKE '%' || $4 || '%' OR
             sub_communities.sub_community ILIKE '%' || $4 || '%'
            ) AND industrial_broker_agent_properties_branch.status != 5 AND industrial_broker_agent_properties_branch.status != 6
) SELECT SUM(count) FROM x; 



-- name: GetCountCommunityIndustrialProperties :one
With x As(
 SELECT industrial_freelancer_properties.id from industrial_freelancer_properties
 INNER JOIN addresses ON industrial_freelancer_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON industrial_freelancer_properties.property_types_id = property_types.id
 INNER JOIN industrial_properties_facts ON industrial_freelancer_properties.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 2
 WHERE 
         addresses.communities_id = $1 and
         industrial_freelancer_properties.category = $5 and
         ($2::bigint[] is NULL OR industrial_freelancer_properties.property_rank = ANY($2::bigint[]))  
         AND ($3::bool is NULL OR is_verified = $3::bool)
         AND (
             industrial_freelancer_properties.property_title ILIKE '%' || $4 || '%'  OR 
             industrial_freelancer_properties.property_title_arabic ILIKE '%' || $4 || '%'  OR   
             property_types.type  ILIKE '%' || $4 || '%'  OR 
             cities.city ILIKE '%' || $4 || '%' OR
             communities.community ILIKE '%' || $4 || '%' OR
             sub_communities.sub_community ILIKE '%' || $4 || '%'
            ) AND industrial_freelancer_properties.status != 5 AND industrial_freelancer_properties.status != 6
 UNION ALL
 SELECT industrial_owner_properties.id FROM industrial_owner_properties
 INNER JOIN addresses ON industrial_owner_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON industrial_owner_properties.property_types_id = property_types.id
 INNER JOIN industrial_properties_facts ON industrial_owner_properties.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 4
 WHERE 
         addresses.cities_id = $1 and
         industrial_owner_properties.category = $5 and
         ($2::bigint[] is NULL OR industrial_owner_properties.property_rank = ANY($2::bigint[]))  
         AND ($3::bool is NULL OR is_verified = $3::bool)
         AND (
             industrial_owner_properties.property_title ILIKE '%' || $4 || '%'  OR 
             industrial_owner_properties.property_title_arabic ILIKE '%' || $4 || '%'  OR   
             property_types.type  ILIKE '%' || $4 || '%'  OR 
             cities.city ILIKE '%' || $4 || '%' OR
             communities.community ILIKE '%' || $4 || '%' OR
             sub_communities.sub_community ILIKE '%' || $4 || '%'
            ) AND industrial_owner_properties.status != 5 AND industrial_owner_properties.status != 6
 UNION ALL
 SELECT industrial_broker_agent_properties.id FROM industrial_broker_agent_properties
 INNER JOIN addresses ON industrial_broker_agent_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON industrial_broker_agent_properties.property_types_id = property_types.id
 INNER JOIN industrial_properties_facts ON industrial_broker_agent_properties.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 3
 WHERE 
         addresses.cities_id = $1 and
         industrial_broker_agent_properties.category = $5 and
         ($2::bigint[] is NULL OR industrial_broker_agent_properties.property_rank = ANY($2::bigint[]))  
         AND ($3::bool is NULL OR is_verified = $3::bool)
         AND (
             industrial_broker_agent_properties.property_title ILIKE '%' || $4 || '%'  OR 
             industrial_broker_agent_properties.property_title_arabic ILIKE '%' || $4 || '%'  OR   
             property_types.type  ILIKE '%' || $4 || '%'  OR 
             cities.city ILIKE '%' || $4 || '%' OR
             communities.community ILIKE '%' || $4 || '%' OR
             sub_communities.sub_community ILIKE '%' || $4 || '%'
            ) AND industrial_broker_agent_properties.status != 5 AND industrial_broker_agent_properties.status != 6
 UNION ALL
 SELECT industrial_broker_agent_properties_branch.id FROM industrial_broker_agent_properties_branch
 INNER JOIN addresses ON industrial_broker_agent_properties_branch.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON industrial_broker_agent_properties_branch.property_types_id = property_types.id
 INNER JOIN industrial_properties_facts ON industrial_broker_agent_properties_branch.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 3
 WHERE 
         addresses.cities_id = $1 and
         industrial_broker_agent_properties_branch.category = $5 and
         ($2::bigint[] is NULL OR industrial_broker_agent_properties_branch.property_rank = ANY($2::bigint[]))  
         AND ($3::bool is NULL OR is_verified = $3::bool)
         AND (
             industrial_broker_agent_properties_branch.property_title ILIKE '%' || $4 || '%'  OR 
             industrial_broker_agent_properties_branch.property_title_arabic ILIKE '%' || $4 || '%'  OR   
             property_types.type  ILIKE '%' || $4 || '%'  OR 
             cities.city ILIKE '%' || $4 || '%' OR
             communities.community ILIKE '%' || $4 || '%' OR
             sub_communities.sub_community ILIKE '%' || $4 || '%'
            ) AND industrial_broker_agent_properties_branch.status != 5 AND industrial_broker_agent_properties_branch.status != 6
) SELECT COUNT(id) FROM x;


-- name: GetCountSubCommunityIndustrialProperties :one
With x As(
 SELECT industrial_freelancer_properties.id from industrial_freelancer_properties
 INNER JOIN addresses ON industrial_freelancer_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON industrial_freelancer_properties.property_types_id = property_types.id
 INNER JOIN industrial_properties_facts ON industrial_freelancer_properties.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 2
 WHERE 
         addresses.sub_communities_id = $1 and
         industrial_freelancer_properties.category = $5 and
         ($2::bigint[] is NULL OR industrial_freelancer_properties.property_rank = ANY($2::bigint[]))  
         AND ($3::bool is NULL OR is_verified = $3::bool)
         AND (
             industrial_freelancer_properties.property_title ILIKE '%' || $4 || '%'  OR 
             industrial_freelancer_properties.property_title_arabic ILIKE '%' || $4 || '%'  OR   
             property_types.type  ILIKE '%' || $4 || '%'  OR 
             cities.city ILIKE '%' || $4 || '%' OR
             communities.community ILIKE '%' || $4 || '%' OR
             sub_communities.sub_community ILIKE '%' || $4 || '%'
            ) AND industrial_freelancer_properties.status != 5 AND industrial_freelancer_properties.status != 6
 UNION ALL
 SELECT industrial_owner_properties.id FROM industrial_owner_properties
 INNER JOIN addresses ON industrial_owner_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON industrial_owner_properties.property_types_id = property_types.id
 INNER JOIN industrial_properties_facts ON industrial_owner_properties.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 4
 WHERE 
         addresses.cities_id = $1 and
         industrial_owner_properties.category = $5 and
         ($2::bigint[] is NULL OR industrial_owner_properties.property_rank = ANY($2::bigint[]))  
         AND ($3::bool is NULL OR is_verified = $3::bool)
         AND (
             industrial_owner_properties.property_title ILIKE '%' || $4 || '%'  OR 
             industrial_owner_properties.property_title_arabic ILIKE '%' || $4 || '%'  OR   
             property_types.type  ILIKE '%' || $4 || '%'  OR 
             cities.city ILIKE '%' || $4 || '%' OR
             communities.community ILIKE '%' || $4 || '%' OR
             sub_communities.sub_community ILIKE '%' || $4 || '%'
            ) AND industrial_owner_properties.status != 5 AND industrial_owner_properties.status != 6
 UNION ALL
 SELECT industrial_broker_agent_properties.id FROM industrial_broker_agent_properties
 INNER JOIN addresses ON industrial_broker_agent_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON industrial_broker_agent_properties.property_types_id = property_types.id
 INNER JOIN industrial_properties_facts ON industrial_broker_agent_properties.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 3
 WHERE 
         addresses.cities_id = $1 and
         industrial_broker_agent_properties.category = $5 and
         ($2::bigint[] is NULL OR industrial_broker_agent_properties.property_rank = ANY($2::bigint[]))  
         AND ($3::bool is NULL OR is_verified = $3::bool)
         AND (
             industrial_broker_agent_properties.property_title ILIKE '%' || $4 || '%'  OR 
             industrial_broker_agent_properties.property_title_arabic ILIKE '%' || $4 || '%'  OR   
             property_types.type  ILIKE '%' || $4 || '%'  OR 
             cities.city ILIKE '%' || $4 || '%' OR
             communities.community ILIKE '%' || $4 || '%' OR
             sub_communities.sub_community ILIKE '%' || $4 || '%'
            ) AND industrial_broker_agent_properties.status != 5 AND industrial_broker_agent_properties.status != 6
 UNION ALL
 SELECT industrial_broker_agent_properties_branch.id FROM industrial_broker_agent_properties_branch
 INNER JOIN addresses ON industrial_broker_agent_properties_branch.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
 INNER JOIN property_types ON industrial_broker_agent_properties_branch.property_types_id = property_types.id
 INNER JOIN industrial_properties_facts ON industrial_broker_agent_properties_branch.id = industrial_properties_facts.properties_id and industrial_properties_facts.property = 3
 WHERE 
         addresses.cities_id = $1 and
         industrial_broker_agent_properties_branch.category = $5 and
         ($2::bigint[] is NULL OR industrial_broker_agent_properties_branch.property_rank = ANY($2::bigint[]))  
         AND ($3::bool is NULL OR is_verified = $3::bool)
         AND (
             industrial_broker_agent_properties_branch.property_title ILIKE '%' || $4 || '%'  OR 
             industrial_broker_agent_properties_branch.property_title_arabic ILIKE '%' || $4 || '%'  OR   
             property_types.type  ILIKE '%' || $4 || '%'  OR 
             cities.city ILIKE '%' || $4 || '%' OR
             communities.community ILIKE '%' || $4 || '%' OR
             sub_communities.sub_community ILIKE '%' || $4 || '%'
            ) AND industrial_broker_agent_properties_branch.status != 5 AND industrial_broker_agent_properties_branch.status != 6
) SELECT COUNT(id) FROM x;




 
 


