
-- name: GetAllIndustrialPropertiesByCategory :many
WITH x AS (
 SELECT
 id,
 property_title,
 property_title_arabic,
 description,
 description_arabic,
 is_verified,
 property_rank,
 addresses_id,
 locations_id,
 property_types_id,
 facilities_id,
 amenities_id,
 status,
 created_at,
 updated_at,
 is_show_owner_info,
 property,
 countries_id,
  ref_no,
 FALSE AS is_branch,
 category
 FROM
 industrial_freelancer_properties
 WHERE
 category = LOWER($3)
 AND(status != 5
 AND status != 6)
 UNION ALL
 SELECT
 id,
 property_title,
 property_title_arabic,
 description,
 description_arabic,
 is_verified,
 property_rank,
 addresses_id,
  locations_id,
 property_types_id,
 facilities_id,
 amenities_id,
 status,
 created_at,
 updated_at,
 is_show_owner_info,
 property,
 countries_id,
 ref_no,
 FALSE AS is_branch,
 category
 FROM
 industrial_owner_properties
 WHERE
 category = LOWER($3)
 AND(status != 5
 AND status != 6)
 UNION ALL
 SELECT
 id,
 property_title,
 property_title_arabic,
 description,
 description_arabic,
 is_verified,
 property_rank,
 addresses_id,
 locations_id,
 property_types_id,
 facilities_id,
 amenities_id,
 status,
 created_at,
 updated_at,
 is_show_owner_info,
 property,
 countries_id,
 ref_no,
 is_branch,
 category
 FROM
 industrial_broker_agent_properties
 WHERE
 category = LOWER($3)
 AND(status != 5
 AND status != 6)
 UNION ALL
 SELECT
 id,
 property_title,
 property_title_arabic,
 description,
 description_arabic,
 is_verified,
 property_rank,
 addresses_id,
 locations_id,
 property_types_id,
 facilities_id,
 amenities_id,
 status,
 created_at,
 updated_at,
 is_show_owner_info,
 property,
 countries_id,
 ref_no,
 is_branch,
 category 
 FROM
 industrial_broker_agent_properties_branch
 WHERE
 category = LOWER($3)
 AND(status != 5
 AND status != 6)
 )
 SELECT
 *
 FROM
 x
 ORDER BY
 id
LIMIT $1 OFFSET $2;
 
 
-- name: GetCountAllIndustrialPropertiesByCategory :one
WITH x AS (
 SELECT
 id
 FROM
 industrial_freelancer_properties
 WHERE
 category = LOWER($1)
 AND(status != 5
 AND status != 6)
 UNION ALL
 SELECT
 id
 FROM
 industrial_owner_properties
 WHERE
  category = LOWER($1)
 AND(status != 5
 AND status != 6)
 UNION ALL
 SELECT
 id
 FROM
 industrial_broker_agent_properties
 WHERE
 category = LOWER($1)
 AND(status != 5
 AND status != 6)
 UNION ALL
 SELECT
 id
 FROM
 industrial_broker_agent_properties_branch
 WHERE
 category = LOWER($1)
 AND(status != 5
 AND status != 6)
) SELECT COUNT(*) FROM x;


-- name: GetCountAllIndustrialPropertiesByNotEqualCountry :one
WITH x AS (
 SELECT id
 FROM
 industrial_freelancer_properties 
 WHERE
 industrial_freelancer_properties.countries_id != $1
 AND(status != 5
 AND status != 6)
 UNION ALL
 SELECT
 id
 FROM
 industrial_owner_properties
 WHERE
 industrial_owner_properties.countries_id != $1
 AND(status != 5
 AND status != 6)
 UNION ALL
 SELECT
 id
 FROM
 industrial_broker_agent_properties
 WHERE
 industrial_broker_agent_properties.countries_id != $1
 AND(status != 5
 AND status != 6)
 UNION ALL
 SELECT
 id
 FROM
 industrial_broker_agent_properties_branch
 WHERE
 industrial_broker_agent_properties_branch.countries_id != $1
 AND(status != 5
 AND status != 6)
)SELECT COUNT(*) FROM x;


-- name: GetCountAllIndustrialPropertiesByCountry :one
WITH x AS (
 SELECT
 id
 FROM
 industrial_freelancer_properties
 WHERE
 industrial_freelancer_properties.countries_id = $1
 AND(status != 5
 AND status != 6)
 UNION ALL
 SELECT
 id
 FROM
 industrial_owner_properties
 WHERE
 industrial_owner_properties.countries_id = $1
 AND(status != 5
 AND status != 6)
 UNION ALL
 SELECT
 id
 FROM
 industrial_broker_agent_properties
 WHERE
 industrial_broker_agent_properties.countries_id = $1
 AND(status != 5
 AND status != 6)
 UNION ALL
 SELECT
 id
 FROM
 industrial_broker_agent_properties_branch
 WHERE
 industrial_broker_agent_properties_branch.countries_id = $1
 AND(status != 5
 AND status != 6)
) SELECT COUNT(*) FROM x;


-- name: GetAllIndustrialPropertiesByNotEqualCountry :many
WITH x AS (
SELECT
id,
property_title,
property_title_arabic,
description,
description_arabic,
is_verified,
property_rank,
addresses_id,
locations_id,
property_types_id,
facilities_id,
amenities_id,
status,
created_at,
updated_at,
is_show_owner_info,
property,
countries_id,
ref_no,
FALSE AS is_branch,
category,
property_name
FROM
industrial_freelancer_properties
WHERE
industrial_freelancer_properties.countries_id != $3
AND(status != 5
AND status != 6)
UNION ALL
SELECT
id,
property_title,
property_title_arabic,
description,
description_arabic,
is_verified,
property_rank,
addresses_id,
locations_id,
property_types_id,
facilities_id,
amenities_id,
status,
created_at,
updated_at,
is_show_owner_info,
property,
countries_id,
ref_no,
FALSE AS is_branch,
category,
property_name
FROM
industrial_owner_properties
WHERE
industrial_owner_properties.countries_id != $3
AND(status != 5
AND status != 6)
UNION ALL
SELECT
id,
property_title,
property_title_arabic,
description,
description_arabic,
is_verified,
property_rank,
addresses_id,
locations_id,
property_types_id,
facilities_id,
amenities_id,
status,
created_at,
updated_at,
is_show_owner_info,
property,
countries_id,
ref_no,
is_branch,
category,
property_name
FROM
industrial_broker_agent_properties
WHERE
industrial_broker_agent_properties.countries_id != $3
AND(status != 5
AND status != 6)
UNION ALL
SELECT
id,
property_title,
property_title_arabic,
description,
description_arabic,
is_verified,
property_rank,
addresses_id,
locations_id,
property_types_id,
facilities_id,
amenities_id,
status,
created_at,
updated_at,
is_show_owner_info,
property,
countries_id,
ref_no,
is_branch,
category,
property_name
FROM
industrial_broker_agent_properties_branch
WHERE
industrial_broker_agent_properties_branch.countries_id != $3
AND(status != 5
AND status != 6)
)
SELECT
*
FROM
x
ORDER BY
id
LIMIT $1 OFFSET $2;


-- name: GetAllIndustrialPropertiesByCountry :many
WITH x AS (
SELECT
id,
property_title,
property_title_arabic,
description,
description_arabic,
is_verified,
property_rank,
addresses_id,
locations_id,
property_types_id,
facilities_id,
amenities_id,
status,
created_at,
updated_at,
is_show_owner_info,
property,
countries_id,
ref_no,
FALSE AS is_branch,
category,
property_name
FROM
industrial_freelancer_properties
WHERE
industrial_freelancer_properties.countries_id = $3
AND(status != 5
AND status != 6)
UNION ALL
SELECT
id,
property_title,
property_title_arabic,
description,
description_arabic,
is_verified,
property_rank,
addresses_id,
locations_id,
property_types_id,
facilities_id,
amenities_id,
status,
created_at,
updated_at,
is_show_owner_info,
property,
countries_id,
ref_no,
FALSE AS is_branch,
category,
property_name
FROM
industrial_owner_properties
WHERE
industrial_owner_properties.countries_id = $3
AND(status != 5
AND status != 6)
UNION ALL
SELECT
id,
property_title,
property_title_arabic,
description,
description_arabic,
is_verified,
property_rank,
addresses_id,
locations_id,
property_types_id,
facilities_id,
amenities_id,
status,
created_at,
updated_at,
is_show_owner_info,
property,
countries_id,
ref_no,
is_branch,
category,
property_name
FROM
industrial_broker_agent_properties
WHERE
industrial_broker_agent_properties.countries_id = $3
AND(status != 5
AND status != 6)
UNION ALL
SELECT
id,
property_title,
property_title_arabic,
description,
description_arabic,
is_verified,
property_rank,
addresses_id,
locations_id,
property_types_id,
facilities_id,
amenities_id,
status,
created_at,
updated_at,
is_show_owner_info,
property,
countries_id,
ref_no,
is_branch,
category,
property_name
FROM
industrial_broker_agent_properties_branch
WHERE
industrial_broker_agent_properties_branch.countries_id = $3
AND(status != 5
AND status != 6)
)
SELECT
 *
 FROM
 x
 ORDER BY
 id
LIMIT $1 OFFSET $2;


-- name: UpdateIndustrialFreelancerPropertyRank :one
UPDATE industrial_freelancer_properties SET property_rank = $2 WHERE id = $1 RETURNING *;

-- name: GetAllIndustrialPropertiesDetails :many
WITH x AS (
SELECT
industrial_freelancer_properties.id,
industrial_freelancer_properties.ref_no,
industrial_freelancer_properties.status,
property_name,
industrial_freelancer_properties.category,
'industrial' AS section,
FALSE AS is_branch,
industrial_freelancer_properties.property,
industrial_freelancer_properties.addresses_id,
industrial_freelancer_properties.users_id,
industrial_freelancer_properties.property_types_id,
industrial_freelancer_properties.unit_types,
property_types. "type"
, industrial_properties_facts.bedroom, industrial_properties_facts.bathroom, industrial_properties_facts.min_area, industrial_properties_facts.max_area, industrial_properties_facts.price, industrial_properties_facts.plot_area
,countries.id as "countries_id", countries.country, states.id as "states_id", states.state, cities.id as "cities_id", cities.city, communities.id as "communities_id", communities.community, sub_communities.id as "sub_communities_id", sub_communities.sub_community, locations.lat, locations.lng

FROM
industrial_freelancer_properties
JOIN property_types ON property_types_id = property_types.id
LEFT JOIN industrial_properties_facts ON  industrial_properties_facts.properties_id = industrial_freelancer_properties.id
LEFT JOIN addresses ON addresses.id = industrial_freelancer_properties.addresses_id
LEFT JOIN countries ON countries.id = addresses.country_id
LEFT JOIN states ON states.id = addresses.state_id
LEFT JOIN cities ON cities.id = addresses.city_id
LEFT JOIN communities ON communities.id = addresses.community_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_community_id
LEFT JOIN locations ON locations.id = addresses.locations_id

WHERE industrial_properties_facts.property = 2 AND industrial_properties_facts.is_branch = false AND
industrial_freelancer_properties.category = $1 and industrial_properties_facts.min_area >= $2 and industrial_properties_facts.max_area <= $3 and industrial_properties_facts.price >= $4 and industrial_properties_facts.price <= $5 and industrial_properties_facts.bedroom = $6 and industrial_properties_facts.bathroom = $7
UNION ALL
SELECT
industrial_broker_agent_properties.id,
industrial_broker_agent_properties.ref_no,
industrial_broker_agent_properties.status,
industrial_broker_agent_properties.property_name,
industrial_broker_agent_properties.category,
'industrial' AS section,
FALSE AS is_branch,
industrial_broker_agent_properties.property,
industrial_broker_agent_properties.addresses_id,
industrial_broker_agent_properties.users_id,
industrial_broker_agent_properties.property_types_id,
industrial_broker_agent_properties.unit_types,
property_types. "type"
, industrial_properties_facts.bedroom, industrial_properties_facts.bathroom, industrial_properties_facts.min_area, industrial_properties_facts.max_area, industrial_properties_facts.price, industrial_properties_facts.plot_area
,countries.id as "countries_id", countries.country, states.id as "states_id", states.state, cities.id as "cities_id", cities.city, communities.id as "communities_id", communities.community, sub_communities.id as "sub_communities_id", sub_communities.sub_community, locations.lat, locations.lng

FROM
industrial_broker_agent_properties
JOIN property_types ON property_types_id = property_types.id
LEFT JOIN industrial_properties_facts ON  industrial_properties_facts.properties_id = industrial_broker_agent_properties.id
LEFT JOIN addresses ON addresses.id = industrial_broker_agent_properties.addresses_id
LEFT JOIN countries ON countries.id = addresses.country_id
LEFT JOIN states ON states.id = addresses.state_id
LEFT JOIN cities ON cities.id = addresses.city_id
LEFT JOIN communities ON communities.id = addresses.community_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_community_id
LEFT JOIN locations ON locations.id = addresses.locations_id

WHERE industrial_properties_facts.property = 3 AND industrial_properties_facts.is_branch = false AND
industrial_broker_agent_properties.category = $1 and industrial_properties_facts.min_area >= $2 and industrial_properties_facts.max_area <= $3 and industrial_properties_facts.price >= $4 and industrial_properties_facts.price <= $5 and industrial_properties_facts.bedroom = $6 and industrial_properties_facts.bathroom = $7
UNION ALL
SELECT
industrial_broker_agent_properties_branch.id,
industrial_broker_agent_properties_branch.ref_no,
industrial_broker_agent_properties_branch.status,
industrial_broker_agent_properties_branch.property_name,
industrial_broker_agent_properties_branch.category,
'industrial' AS section,
TRUE AS is_branch,
industrial_broker_agent_properties_branch.property,
industrial_broker_agent_properties_branch.addresses_id,
industrial_broker_agent_properties_branch.users_id,
industrial_broker_agent_properties_branch.property_types_id,
industrial_broker_agent_properties_branch.unit_types,
property_types. "type"
, industrial_properties_facts.bedroom, industrial_properties_facts.bathroom, industrial_properties_facts.min_area, industrial_properties_facts.max_area, industrial_properties_facts.price, industrial_properties_facts.plot_area
,countries.id as "countries_id", countries.country, states.id as "states_id", states.state, cities.id as "cities_id", cities.city, communities.id as "communities_id", communities.community, sub_communities.id as "sub_communities_id", sub_communities.sub_community, locations.lat, locations.lng

FROM
industrial_broker_agent_properties_branch
JOIN property_types ON property_types_id = property_types.id
LEFT JOIN industrial_properties_facts ON  industrial_properties_facts.properties_id = industrial_broker_agent_properties_branch.id
LEFT JOIN addresses ON addresses.id = industrial_broker_agent_properties_branch.addresses_id
LEFT JOIN countries ON countries.id = addresses.country_id
LEFT JOIN states ON states.id = addresses.state_id
LEFT JOIN cities ON cities.id = addresses.city_id
LEFT JOIN communities ON communities.id = addresses.community_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_community_id
LEFT JOIN locations ON locations.id = addresses.locations_id

WHERE industrial_properties_facts.property = 3 AND industrial_properties_facts.is_branch = true AND
industrial_broker_agent_properties_branch.category = $1 and industrial_properties_facts.min_area >= $2 and industrial_properties_facts.max_area <= $3 and industrial_properties_facts.price >= $4 and industrial_properties_facts.price <= $5 and industrial_properties_facts.bedroom = $6 and industrial_properties_facts.bathroom = $7
UNION ALL
SELECT
industrial_owner_properties.id,
industrial_owner_properties.ref_no,
industrial_owner_properties.status,
industrial_owner_properties.property_name,
industrial_owner_properties.category,
'industrial' AS section,
FALSE AS is_branch,
industrial_owner_properties.property,
industrial_owner_properties.addresses_id,
industrial_owner_properties.users_id,
industrial_owner_properties.property_types_id,
industrial_owner_properties.unit_types,
property_types. "type"
, industrial_properties_facts.bedroom, industrial_properties_facts.bathroom, industrial_properties_facts.min_area, industrial_properties_facts.max_area, industrial_properties_facts.price, industrial_properties_facts.plot_area
,countries.id as "countries_id", countries.country, states.id as "states_id", states.state, cities.id as "cities_id", cities.city, communities.id as "communities_id", communities.community, sub_communities.id as "sub_communities_id", sub_communities.sub_community, locations.lat, locations.lng

FROM
industrial_owner_properties
JOIN property_types ON property_types_id = property_types.id
LEFT JOIN industrial_properties_facts ON  industrial_properties_facts.properties_id = industrial_owner_properties.id
LEFT JOIN addresses ON addresses.id = industrial_owner_properties.addresses_id
LEFT JOIN countries ON countries.id = addresses.country_id
LEFT JOIN states ON states.id = addresses.state_id
LEFT JOIN cities ON cities.id = addresses.city_id
LEFT JOIN communities ON communities.id = addresses.community_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_community_id
LEFT JOIN locations ON locations.id = addresses.locations_id

WHERE industrial_properties_facts.property = 4 AND industrial_properties_facts.is_branch = false AND
industrial_owner_properties.category = $1 and industrial_properties_facts.min_area >= $2 and industrial_properties_facts.max_area <= $3 and industrial_properties_facts.price >= $4 and industrial_properties_facts.price <= $5 and industrial_properties_facts.bedroom = $6 and industrial_properties_facts.bathroom = $7
)
SELECT
*
FROM
x;