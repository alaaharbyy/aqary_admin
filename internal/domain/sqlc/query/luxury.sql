

-- name: GetAllLuxuryPropertiesByCountry :many
WITH x AS (
	SELECT
		broker_company_agent_properties.id,
		broker_company_agent_properties.property_title,
		broker_company_agent_properties.property_name,
		broker_company_agent_properties.property_title_arabic,
		broker_company_agent_properties.description,
		broker_company_agent_properties.description_arabic,
		broker_company_agent_properties.is_verified,
		broker_company_agent_properties.property_rank,
		broker_company_agent_properties.addresses_id,
		broker_company_agent_properties.locations_id,
		broker_company_agent_properties.property_types_id,
		broker_company_agent_properties.profiles_id,
		broker_company_agent_properties.facilities_id,
		broker_company_agent_properties.amenities_id,
		broker_company_agent_properties.status,
		broker_company_agent_properties.created_at,
		broker_company_agent_properties.updated_at,
		broker_company_agent_properties.is_show_owner_info,
		broker_company_agent_properties.property,
		broker_company_agent_properties.countries_id,
		broker_company_agent_properties.ref_no,
		FALSE AS is_branch,
		broker_company_agent_properties.from_xml
	FROM
		broker_company_agent_properties
	LEFT JOIN properties_facts ON properties_facts.properties_id = broker_company_agent_properties.id
WHERE
	properties_facts.property = 3
	AND properties_facts.life_style = 3
	AND broker_company_agent_properties.countries_id = $3
	AND broker_company_agent_properties.status != 5
	AND broker_company_agent_properties.status != 6
UNION ALL
SELECT
	broker_company_agent_properties_branch.id,
	broker_company_agent_properties_branch.property_title,
	broker_company_agent_properties_branch.property_name,
	broker_company_agent_properties_branch.property_title_arabic,
	broker_company_agent_properties_branch.description,
	broker_company_agent_properties_branch.description_arabic,
	broker_company_agent_properties_branch.is_verified,
	broker_company_agent_properties_branch.property_rank,
	broker_company_agent_properties_branch.addresses_id,
	broker_company_agent_properties_branch.locations_id,
	broker_company_agent_properties_branch.property_types_id,
	broker_company_agent_properties_branch.profiles_id,
	broker_company_agent_properties_branch.facilities_id,
	broker_company_agent_properties_branch.amenities_id,
	broker_company_agent_properties_branch.status,
	broker_company_agent_properties_branch.created_at,
	broker_company_agent_properties_branch.updated_at,
	broker_company_agent_properties_branch.is_show_owner_info,
	broker_company_agent_properties_branch.property,
	broker_company_agent_properties_branch.countries_id,
	broker_company_agent_properties_branch.ref_no,
	TRUE AS is_branch,
	broker_company_agent_properties_branch.from_xml
FROM
	broker_company_agent_properties_branch
	LEFT JOIN properties_facts ON properties_facts.properties_id = broker_company_agent_properties_branch.id
WHERE
	properties_facts.property = 3
	AND properties_facts.life_style = 3
	AND broker_company_agent_properties_branch.countries_id = $3
	AND broker_company_agent_properties_branch.status != 5
	AND broker_company_agent_properties_branch.status != 6
UNION ALL
SELECT
	freelancers_properties.id,
	freelancers_properties.property_title,
	freelancers_properties.property_name,
	freelancers_properties.property_title_arabic,
	freelancers_properties.description,
	freelancers_properties.description_arabic,
	freelancers_properties.is_verified,
	freelancers_properties.property_rank,
	freelancers_properties.addresses_id,
	freelancers_properties.locations_id,
	freelancers_properties.property_types_id,
	freelancers_properties.profiles_id,
	freelancers_properties.facilities_id,
	freelancers_properties.amenities_id,
	freelancers_properties.status,
	freelancers_properties.created_at,
	freelancers_properties.updated_at,
	freelancers_properties.is_show_owner_info,
	freelancers_properties.property,
	freelancers_properties.countries_id,
	freelancers_properties.ref_no,
	FALSE AS is_branch,
	FALSE AS from_xml
FROM
	freelancers_properties
	LEFT JOIN properties_facts ON properties_facts.properties_id = freelancers_properties.id
WHERE
	properties_facts.property = 2
	AND properties_facts.life_style = 3
	AND freelancers_properties.countries_id = $3
	AND freelancers_properties.status != 5
	AND freelancers_properties.status != 6
UNION ALL
SELECT
	owner_properties.id,
	owner_properties.property_title,
	owner_properties.property_name,
	owner_properties.property_title_arabic,
	owner_properties.description,
	owner_properties.description_arabic,
	owner_properties.is_verified,
	owner_properties.property_rank,
	owner_properties.addresses_id,
	owner_properties.locations_id,
	owner_properties.property_types_id,
	owner_properties.profiles_id,
	owner_properties.facilities_id,
	owner_properties.amenities_id,
	owner_properties.status,
	owner_properties.created_at,
	owner_properties.updated_at,
	owner_properties.is_show_owner_info,
	owner_properties.property,
	owner_properties.countries_id,
	owner_properties.ref_no,
	FALSE AS is_branch,
	FALSE AS from_xml
FROM
	owner_properties
	LEFT JOIN properties_facts ON properties_facts.properties_id = owner_properties.id
WHERE
	properties_facts.property = 4
	AND properties_facts.life_style = 3
	AND owner_properties.countries_id = $3
	AND owner_properties.status != 5
	AND owner_properties.status != 6
)
SELECT * FROM x ORDER BY x.id
LIMIT $1 OFFSET $2;


-- name: GetAllLuxuryPropertiesByNotEqualCountry :many
WITH x AS (
	SELECT
		broker_company_agent_properties.id,
		broker_company_agent_properties.property_title,
		broker_company_agent_properties.property_name,
		broker_company_agent_properties.property_title_arabic,
		broker_company_agent_properties.description,
		broker_company_agent_properties.description_arabic,
		broker_company_agent_properties.is_verified,
		broker_company_agent_properties.property_rank,
		broker_company_agent_properties.addresses_id,
		broker_company_agent_properties.locations_id,
		broker_company_agent_properties.property_types_id,
		broker_company_agent_properties.profiles_id,
		broker_company_agent_properties.facilities_id,
		broker_company_agent_properties.amenities_id,
		broker_company_agent_properties.status,
		broker_company_agent_properties.created_at,
		broker_company_agent_properties.updated_at,
		broker_company_agent_properties.is_show_owner_info,
		broker_company_agent_properties.property,
		broker_company_agent_properties.countries_id,
		broker_company_agent_properties.ref_no,
		FALSE AS is_branch,
		broker_company_agent_properties.from_xml
	FROM
		broker_company_agent_properties
	LEFT JOIN properties_facts ON properties_facts.properties_id = broker_company_agent_properties.id
WHERE
	properties_facts.property = 3
	AND properties_facts.life_style = 3
	AND broker_company_agent_properties.countries_id != $3
	AND broker_company_agent_properties.status != 5
	AND broker_company_agent_properties.status != 6
UNION ALL
SELECT
	broker_company_agent_properties_branch.id,
	broker_company_agent_properties_branch.property_title,
	broker_company_agent_properties_branch.property_name,
	broker_company_agent_properties_branch.property_title_arabic,
	broker_company_agent_properties_branch.description,
	broker_company_agent_properties_branch.description_arabic,
	broker_company_agent_properties_branch.is_verified,
	broker_company_agent_properties_branch.property_rank,
	broker_company_agent_properties_branch.addresses_id,
	broker_company_agent_properties_branch.locations_id,
	broker_company_agent_properties_branch.property_types_id,
	broker_company_agent_properties_branch.profiles_id,
	broker_company_agent_properties_branch.facilities_id,
	broker_company_agent_properties_branch.amenities_id,
	broker_company_agent_properties_branch.status,
	broker_company_agent_properties_branch.created_at,
	broker_company_agent_properties_branch.updated_at,
	broker_company_agent_properties_branch.is_show_owner_info,
	broker_company_agent_properties_branch.property,
	broker_company_agent_properties_branch.countries_id,
	broker_company_agent_properties_branch.ref_no,
	TRUE AS is_branch,
	broker_company_agent_properties_branch.from_xml
FROM
	broker_company_agent_properties_branch
	LEFT JOIN properties_facts ON properties_facts.properties_id = broker_company_agent_properties_branch.id
WHERE
	properties_facts.property = 3
	AND properties_facts.life_style = 3
	AND broker_company_agent_properties_branch.countries_id != $3
	AND broker_company_agent_properties_branch.status != 5
	AND broker_company_agent_properties_branch.status != 6
UNION ALL
SELECT
	freelancers_properties.id,
	freelancers_properties.property_title,
	freelancers_properties.property_name,
	freelancers_properties.property_title_arabic,
	freelancers_properties.description,
	freelancers_properties.description_arabic,
	freelancers_properties.is_verified,
	freelancers_properties.property_rank,
	freelancers_properties.addresses_id,
	freelancers_properties.locations_id,
	freelancers_properties.property_types_id,
	freelancers_properties.profiles_id,
	freelancers_properties.facilities_id,
	freelancers_properties.amenities_id,
	freelancers_properties.status,
	freelancers_properties.created_at,
	freelancers_properties.updated_at,
	freelancers_properties.is_show_owner_info,
	freelancers_properties.property,
	freelancers_properties.countries_id,
	freelancers_properties.ref_no,
	FALSE AS is_branch,
	FALSE AS from_xml
FROM
	freelancers_properties
	LEFT JOIN properties_facts ON properties_facts.properties_id = freelancers_properties.id
WHERE
	properties_facts.property = 2
	AND properties_facts.life_style = 3
	AND freelancers_properties.countries_id != $3
	AND freelancers_properties.status != 5
	AND freelancers_properties.status != 6
UNION ALL
SELECT
	owner_properties.id,
	owner_properties.property_title,
	owner_properties.property_name,
	owner_properties.property_title_arabic,
	owner_properties.description,
	owner_properties.description_arabic,
	owner_properties.is_verified,
	owner_properties.property_rank,
	owner_properties.addresses_id,
	owner_properties.locations_id,
	owner_properties.property_types_id,
	owner_properties.profiles_id,
	owner_properties.facilities_id,
	owner_properties.amenities_id,
	owner_properties.status,
	owner_properties.created_at,
	owner_properties.updated_at,
	owner_properties.is_show_owner_info,
	owner_properties.property,
	owner_properties.countries_id,
	owner_properties.ref_no,
	FALSE AS is_branch,
	FALSE AS from_xml
FROM
	owner_properties
	LEFT JOIN properties_facts ON properties_facts.properties_id = owner_properties.id
WHERE
	properties_facts.property = 4
	AND properties_facts.life_style = 3
	AND owner_properties.countries_id != $3
	AND owner_properties.status != 5
	AND owner_properties.status != 6
) SELECT * FROM x ORDER BY x.id LIMIT $1 OFFSET $2;


-- name: GetCountAllLuxuryPropertiesByCountry :one
WITH x AS (
	SELECT
		broker_company_agent_properties.id
	FROM
		broker_company_agent_properties
	LEFT JOIN properties_facts ON properties_facts.properties_id = broker_company_agent_properties.id
WHERE
	properties_facts.property = 3
	AND properties_facts.life_style = 3
	AND broker_company_agent_properties.countries_id = $1
	AND broker_company_agent_properties.status != 5
	AND broker_company_agent_properties.status != 6
UNION ALL
SELECT
	broker_company_agent_properties_branch.id
FROM
	broker_company_agent_properties_branch
	LEFT JOIN properties_facts ON properties_facts.properties_id = broker_company_agent_properties_branch.id
WHERE
	properties_facts.property = 3
	AND properties_facts.life_style = 3
	AND broker_company_agent_properties_branch.countries_id = $1
	AND broker_company_agent_properties_branch.status != 5
	AND broker_company_agent_properties_branch.status != 6
UNION ALL
SELECT
	freelancers_properties.id
FROM
	freelancers_properties
	LEFT JOIN properties_facts ON properties_facts.properties_id = freelancers_properties.id
WHERE
	properties_facts.property = 2
	AND properties_facts.life_style = 3
	AND freelancers_properties.countries_id = $1
	AND freelancers_properties.status != 5
	AND freelancers_properties.status != 6
UNION ALL
SELECT
	owner_properties.id
FROM
	owner_properties
	LEFT JOIN properties_facts ON properties_facts.properties_id = owner_properties.id
WHERE
	properties_facts.property = 4
	AND properties_facts.life_style = 3
	AND owner_properties.countries_id = $1
	AND owner_properties.status != 5
	AND owner_properties.status != 6
)SELECT COUNT(*) FROM x;

-- name: GetCountAllLuxuryPropertiesByNotEqualCountry :one
WITH x AS (
	SELECT
		broker_company_agent_properties.id
	FROM
		broker_company_agent_properties
	LEFT JOIN properties_facts ON properties_facts.properties_id = broker_company_agent_properties.id
WHERE
	properties_facts.property = 3
	AND properties_facts.life_style = 3
	AND broker_company_agent_properties.countries_id != $1
	AND broker_company_agent_properties.status != 5
	AND broker_company_agent_properties.status != 6
UNION ALL
SELECT
	broker_company_agent_properties_branch.id
FROM
	broker_company_agent_properties_branch
	LEFT JOIN properties_facts ON properties_facts.properties_id = broker_company_agent_properties_branch.id
WHERE
	properties_facts.property = 3
	AND properties_facts.life_style = 3
	AND broker_company_agent_properties_branch.countries_id != $1
	AND broker_company_agent_properties_branch.status != 5
	AND broker_company_agent_properties_branch.status != 6
UNION ALL
SELECT
	freelancers_properties.id
FROM
	freelancers_properties
	LEFT JOIN properties_facts ON properties_facts.properties_id = freelancers_properties.id
WHERE
	properties_facts.property = 2
	AND properties_facts.life_style = 3
	AND freelancers_properties.countries_id != $1
	AND freelancers_properties.status != 5
	AND freelancers_properties.status != 6
UNION ALL
SELECT
	owner_properties.id
FROM
	owner_properties
	LEFT JOIN properties_facts ON properties_facts.properties_id = owner_properties.id
WHERE
	properties_facts.property = 4
	AND properties_facts.life_style = 3
	AND owner_properties.countries_id != $1
	AND owner_properties.status != 5
	AND owner_properties.status != 6
) SELECT COUNT(*) FROM x;








-- name: GetAllLuxuryPropertiesByStatus :many
WITH x AS (
	SELECT
		freelancers_properties.id,
		freelancers_properties.property_name,
		freelancers_properties.property_title,
		freelancers_properties.addresses_id,
		freelancers_properties.property_types_id,
		freelancers_properties.property,
		freelancers_properties.ref_no,
		FALSE AS is_branch
	FROM
		freelancers_properties
	LEFT JOIN properties_facts ON properties_facts.properties_id = freelancers_properties.id
WHERE
	freelancers_properties.status = $3::bigint
	AND properties_facts.property = 2
	AND properties_facts.life_style = 3
UNION ALL
SELECT
	owner_properties.id,
	owner_properties.property_name,
	owner_properties.property_title,
	owner_properties.addresses_id,
	owner_properties.property_types_id,
	owner_properties.property,
	owner_properties.ref_no,
	FALSE AS is_branch
FROM
	owner_properties
	LEFT JOIN properties_facts ON properties_facts.properties_id = owner_properties.id
WHERE
	owner_properties.status = $3::bigint
	AND properties_facts.property = 4
	AND properties_facts.life_style = 3
UNION ALL
SELECT
	broker_company_agent_properties.id,
	broker_company_agent_properties.property_name,
	broker_company_agent_properties.property_title,
	broker_company_agent_properties.addresses_id,
	broker_company_agent_properties.property_types_id,
	broker_company_agent_properties.property,
	broker_company_agent_properties.ref_no,
	broker_company_agent_properties.is_branch AS is_branch
FROM
	broker_company_agent_properties
	LEFT JOIN properties_facts ON properties_facts.properties_id = broker_company_agent_properties.id
WHERE
	broker_company_agent_properties.status = $3::bigint
	AND properties_facts.property = 3
	AND properties_facts.life_style = 3
UNION ALL
SELECT
	broker_company_agent_properties_branch.id,
	broker_company_agent_properties_branch.property_name,
	broker_company_agent_properties_branch.property_title,
	broker_company_agent_properties_branch.addresses_id,
	broker_company_agent_properties_branch.property_types_id,
	broker_company_agent_properties_branch.property,
	broker_company_agent_properties_branch.ref_no,
	broker_company_agent_properties_branch.is_branch AS is_branch
FROM
	broker_company_agent_properties_branch
	LEFT JOIN properties_facts ON properties_facts.properties_id = broker_company_agent_properties_branch.id
WHERE
	broker_company_agent_properties_branch.status = $3::bigint
	AND properties_facts.property = 3
	AND properties_facts.life_style = 3
)
SELECT
	id, property_name, property_title,  addresses_id, property_types_id, property, ref_no, is_branch
FROM
	x
ORDER BY
	id
LIMIT $1 OFFSET $2;

