-- name: GetAllPropertyhubsByCountry :many
-- WITH x AS (
-- 	SELECT
-- 		id,
-- 		property_name,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		FALSE AS is_branch,
-- 		FALSE AS from_xml,
-- 		category
-- 	FROM
-- 		freelancers_properties
-- 	WHERE
-- 		freelancers_properties.countries_id = $3
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_name,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		FALSE AS is_branch,
-- 		FALSE AS from_xml,
-- 		category
-- 	FROM
-- 		owner_properties
-- 	WHERE
-- 		owner_properties.countries_id = $3
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_name,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		is_branch,
-- 		from_xml,
-- 		category
-- 	FROM
-- 		broker_company_agent_properties
-- 	WHERE
-- 		broker_company_agent_properties.countries_id = $3
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_name,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		is_branch,
-- 		from_xml,
-- 		category
-- 	FROM
-- 		broker_company_agent_properties_branch
-- 	WHERE
-- 		broker_company_agent_properties_branch.countries_id = $3
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- )
-- SELECT
-- 	id,
-- 	property_name,
-- 	property_title,
-- 	property_title_arabic,
-- 	description,
-- 	description_arabic,
-- 	is_verified,
-- 	property_rank,
-- 	addresses_id,
-- 	locations_id,
-- 	property_types_id,
-- 	profiles_id,
-- 	facilities_id,
-- 	amenities_id,
-- 	status,
-- 	created_at,
-- 	updated_at,
-- 	is_show_owner_info,
-- 	property,
-- 	countries_id,
-- 	ref_no,
-- 	is_branch,
-- 	from_xml,
-- 	category
-- FROM
-- 	x
-- ORDER BY
-- 	id
-- LIMIT
-- 	$1 OFFSET $2;

-- name: GetAllPropertyhubsByCountryNotEqual :many
-- WITH x AS (
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_name,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		FALSE AS is_branch,
-- 		FALSE AS from_xml,
-- 		category
-- 	FROM
-- 		freelancers_properties
-- 	WHERE
-- 		freelancers_properties.countries_id != $3
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_name,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		FALSE AS is_branch,
-- 		FALSE AS from_xml,
-- 		category
-- 	FROM
-- 		owner_properties
-- 	WHERE
-- 		owner_properties.countries_id != $3
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_name,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		is_branch,
-- 		from_xml,
-- 		category
-- 	FROM
-- 		broker_company_agent_properties
-- 	WHERE
-- 		broker_company_agent_properties.countries_id != $3
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_name,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		is_branch,
-- 		from_xml,
-- 		category
-- 	FROM
-- 		broker_company_agent_properties_branch
-- 	WHERE
-- 		broker_company_agent_properties_branch.countries_id != $3
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- )
-- SELECT
-- 	id,
-- 	property_name,
-- 	property_title,
-- 	property_title_arabic,
-- 	description,
-- 	description_arabic,
-- 	is_verified,
-- 	property_rank,
-- 	addresses_id,
-- 	locations_id,
-- 	property_types_id,
-- 	profiles_id,
-- 	facilities_id,
-- 	amenities_id,
-- 	status,
-- 	created_at,
-- 	updated_at,
-- 	is_show_owner_info,
-- 	property,
-- 	countries_id,
-- 	ref_no,
-- 	is_branch,
-- 	from_xml,
-- 	category
-- FROM
-- 	x
-- ORDER BY
-- 	created_at DESC
-- LIMIT
-- 	$1 OFFSET $2;

-- name: GetCountPropertyhubsByCountry :one
-- WITH x AS (
--     SELECT
--         id
--     FROM
--         freelancers_properties fp
--     WHERE
--     CASE
--          WHEN $1 = 0 THEN true
--          WHEN $1 = 1 THEN fp.countries_id = $5
--          WHEN $1 = 2 THEN fp.countries_id != $5
--     END
--     AND
--     CASE
--         WHEN $2 = 0 THEN true
--         WHEN $2 = 1 THEN fp.addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $6)
--         WHEN $2 = 2 THEN fp.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $6 AND communities_id = ANY($7::bigint[]))
--         WHEN $2 = 3 THEN fp.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $6 AND communities_id = ANY($7::bigint[]) AND sub_communities_id = ANY($8::bigint[]))
--         WHEN $2 = 4 THEN fp.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $6 AND communities_id = ANY($7::bigint[]) AND sub_communities_id = ANY($8::bigint[]) AND addresses.locations_id = $9)
--     END
--     AND 
--     CASE
--          WHEN $3 = 0 THEN (fp.status != 5 AND fp.status != 6)
--          WHEN $3 = 1 THEN fp.status = $10
--     END
--     AND
--     CASE
--          WHEN $4 = 0 THEN true
--          WHEN $4 = 1 THEN fp.property_rank BETWEEN 1 AND 4
--     END
--     UNION ALL
--     SELECT
--         id
--     FROM
--         owner_properties op
--     WHERE
--           CASE
--          WHEN $1 = 0 THEN true
--          WHEN $1 = 1 THEN op.countries_id = $5
--          WHEN $1 = 2 THEN op.countries_id != $5
--     END
--     AND
--     CASE
--         WHEN $2 = 0 THEN true
--         WHEN $2 = 1 THEN op.addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $6)
--         WHEN $2 = 2 THEN op.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $6 AND communities_id = ANY($7::bigint[]))
--         WHEN $2 = 3 THEN op.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $6 AND communities_id = ANY($7::bigint[]) AND sub_communities_id = ANY($8::bigint[]))
--         WHEN $2 = 4 THEN op.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $6 AND communities_id = ANY($7::bigint[]) AND sub_communities_id = ANY($8::bigint[]) AND addresses.locations_id = $9)
--     END
--     AND 
--     CASE
--          WHEN $3 = 0 THEN (op.status != 5 AND op.status != 6)
--          WHEN $3 = 1 THEN op.status = $10
--     END
--     AND
--     CASE
--          WHEN $4 = 0 THEN true
--          WHEN $4 = 1 THEN op.property_rank BETWEEN 1 AND 4
--     END
--     UNION ALL
--     SELECT
--         id
--     FROM
--         broker_company_agent_properties bcap
--     WHERE
--     CASE
--          WHEN $1 = 0 THEN true
--          WHEN $1 = 1 THEN bcap.countries_id = $5
--          WHEN $1 = 2 THEN bcap.countries_id != $5
--     END
--     AND
--     CASE
--         WHEN $2 = 0 THEN true
--         WHEN $2 = 1 THEN bcap.addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $6)
--         WHEN $2 = 2 THEN bcap.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $6 AND communities_id = ANY($7::bigint[]))
--         WHEN $2 = 3 THEN bcap.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $6 AND communities_id = ANY($7::bigint[]) AND sub_communities_id = ANY($8::bigint[]))
--         WHEN $2 = 4 THEN bcap.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $6 AND communities_id = ANY($7::bigint[]) AND sub_communities_id = ANY($8::bigint[]) AND addresses.locations_id = $9)
--     END
--     AND 
--     CASE
--          WHEN $3 = 0 THEN (bcap.status != 5 AND bcap.status != 6)
--          WHEN $3 = 1 THEN bcap.status = $10
--     END
--     AND
--     CASE
--          WHEN $4 = 0 THEN true
--          WHEN $4 = 1 THEN bcap.property_rank BETWEEN 1 AND 4
--     END
--     UNION ALL
--     SELECT
--         id
--     FROM
--         broker_company_agent_properties_branch bcapb
--     WHERE
--           CASE
--          WHEN $1 = 0 THEN true
--          WHEN $1 = 1 THEN bcapb.countries_id = $5
--          WHEN $1 = 2 THEN bcapb.countries_id != $5
--     END
--     AND
--     CASE
--         WHEN $2 = 0 THEN true
--         WHEN $2 = 1 THEN bcapb.addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $6)
--         WHEN $2 = 2 THEN bcapb.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $6 AND communities_id = ANY($7::bigint[]))
--         WHEN $2 = 3 THEN bcapb.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $6 AND communities_id = ANY($7::bigint[]) AND sub_communities_id = ANY($8::bigint[]))
--         WHEN $2 = 4 THEN bcapb.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $6 AND communities_id = ANY($7::bigint[]) AND sub_communities_id = ANY($8::bigint[]) AND addresses.locations_id = $9)
--     END
--     AND 
--     CASE
--          WHEN $3 = 0 THEN (bcapb.status != 5 AND bcapb.status != 6)
--          WHEN $3 = 1 THEN bcapb.status = $10
--     END
--     AND
--     CASE
--          WHEN $4 = 0 THEN true
--          WHEN $4 = 1 THEN bcapb.property_rank BETWEEN 1 AND 4
--     END
-- )
-- SELECT
--     Count(*)
-- FROM x;

-- name: GetCountPropertyhubsByCountryNotEqual :one
-- WITH x AS (
-- 	SELECT
-- 		id,
-- 		countries_id
-- 	FROM
-- 		freelancers_properties
-- 	WHERE
-- 		freelancers_properties.countries_id != $1
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		countries_id
-- 	FROM
-- 		owner_properties
-- 	WHERE
-- 		owner_properties.countries_id != $1
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		countries_id
-- 	FROM
-- 		broker_company_agent_properties
-- 	WHERE
-- 		broker_company_agent_properties.countries_id != $1
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		countries_id
-- 	FROM
-- 		broker_company_agent_properties_branch
-- 	WHERE
-- 		broker_company_agent_properties_branch.countries_id != $1
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- )
-- SELECT
-- 	Count(*)
-- FROM
-- 	x;

-- name: UpdateBrokerAgentPropertyhubStatus :one
-- UPDATE
-- 	broker_company_agent_properties
-- SET
-- 	status = $2
-- Where
-- 	id = $1 RETURNING *;

-- name: UpdateOwnerPropertyhubStatus :one
-- UPDATE
-- 	owner_properties
-- SET
-- 	status = $2
-- Where
-- 	id = $1 RETURNING *;

-- name: GetAllPropertiesByStatus :many
-- WITH x AS(
-- 	SELECT
-- 		freelancers_properties.id,
-- 		freelancers_properties.property_name,
-- 		freelancers_properties.property_title,
-- 		freelancers_properties.addresses_id,
-- 		freelancers_properties.property_types_id,
-- 		freelancers_properties.property,
-- 		freelancers_properties.ref_no,
-- 		FALSE AS is_branch
-- 	FROM
-- 		freelancers_properties
-- 	WHERE
-- 		freelancers_properties.status = $3 :: bigint
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		owner_properties.id,
-- 		owner_properties.property_name,
-- 		owner_properties.property_title,
-- 		owner_properties.addresses_id,
-- 		owner_properties.property_types_id,
-- 		owner_properties.property,
-- 		owner_properties.ref_no,
-- 		FALSE AS is_branch
-- 	FROM
-- 		owner_properties
-- 	WHERE
-- 		owner_properties.status = $3 :: bigint
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		broker_company_agent_properties.id,
-- 		broker_company_agent_properties.property_name,
-- 		broker_company_agent_properties.property_title,
-- 		broker_company_agent_properties.addresses_id,
-- 		broker_company_agent_properties.property_types_id,
-- 		broker_company_agent_properties.property,
-- 		broker_company_agent_properties.ref_no,
-- 		broker_company_agent_properties.is_branch AS is_branch
-- 	FROM
-- 		broker_company_agent_properties
-- 	WHERE
-- 		broker_company_agent_properties.status = $3 :: bigint
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		broker_company_agent_properties_branch.id,
-- 		broker_company_agent_properties_branch.property_name,
-- 		broker_company_agent_properties_branch.property_title,
-- 		broker_company_agent_properties_branch.addresses_id,
-- 		broker_company_agent_properties_branch.property_types_id,
-- 		broker_company_agent_properties_branch.property,
-- 		broker_company_agent_properties_branch.ref_no,
-- 		broker_company_agent_properties_branch.is_branch AS is_branch
-- 	FROM
-- 		broker_company_agent_properties_branch
-- 	WHERE
-- 		broker_company_agent_properties_branch.status = $3 :: bigint
-- )
-- SELECT
-- 	id,
-- 	property_name,
-- 	property_title,
-- 	addresses_id,
-- 	property_types_id,
-- 	property,
-- 	ref_no,
-- 	is_branch
-- FROM
-- 	x
-- ORDER BY
-- 	id
-- LIMIT
-- 	$1 OFFSET $2;

-- name: GetCountAllPropertiesByStatus :one
-- WITH x AS(
-- 	SELECT
-- 		id
-- 	FROM
-- 		freelancers_properties
-- 	WHERE
-- 		freelancers_properties.status = $1 :: bigint
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id
-- 	FROM
-- 		owner_properties
-- 	WHERE
-- 		owner_properties.status = $1 :: bigint
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id
-- 	FROM
-- 		broker_company_agent_properties
-- 	WHERE
-- 		broker_company_agent_properties.status = $1 :: bigint
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id
-- 	FROM
-- 		broker_company_agent_properties_branch
-- 	WHERE
-- 		broker_company_agent_properties_branch.status = $1 :: bigint
-- )
-- SELECT
-- 	COUNT(*)
-- FROM
-- 	x;

-- name: GetAllPropertyHubProperty :many
-- WITH x AS(
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		users_id,
-- 		FALSE AS is_branch,
-- 	    0 as broker_company_agents,
-- 		0 as broker_companies_id
-- 	FROM
-- 		freelancers_properties
-- 	WHERE
-- 		freelancers_properties.property_rank = 4
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		users_id,
-- 		FALSE AS is_branch,
-- 		0 as broker_company_agents,
-- 		0 as broker_companies_id
-- 	FROM
-- 		freelancers_properties
-- 	WHERE
-- 		freelancers_properties.property_rank = 3
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		users_id,
-- 		FALSE AS is_branch,
-- 		0 as broker_company_agents,
-- 		0 as broker_companies_id
-- 	FROM
-- 		freelancers_properties
-- 	WHERE
-- 		freelancers_properties.property_rank = 2
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		users_id,
-- 		FALSE AS is_branch,
-- 		0 as broker_company_agents,
-- 		0 as broker_companies_id
-- 	FROM
-- 		freelancers_properties
-- 	WHERE
-- 		freelancers_properties.property_rank = 1
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	all
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		users_id,
-- 		FALSE AS is_branch,
-- 		0 as broker_company_agents,
-- 		0 as broker_companies_id
-- 	FROM
-- 		owner_properties
-- 	WHERE
-- 		owner_properties.property_rank = 4
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	all
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		users_id,
-- 		FALSE AS is_branch,
-- 		0 as broker_company_agents,
-- 		0 as broker_companies_id
-- 	FROM
-- 		owner_properties
-- 	WHERE
-- 		owner_properties.property_rank = 3
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	all
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		users_id,
-- 		FALSE AS is_branch,
-- 		0 as broker_company_agents,
-- 		0 as broker_companies_id
-- 	FROM
-- 		owner_properties
-- 	WHERE
-- 		owner_properties.property_rank = 2
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	all
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		users_id,
-- 		FALSE AS is_branch,
-- 		0 as broker_company_agents,
-- 		0 as broker_companies_id
-- 	FROM
-- 		owner_properties
-- 	WHERE
-- 		owner_properties.property_rank = 1
-- 		AND(
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		users_id,
-- 		is_branch,
-- 		broker_company_agents,
-- 		broker_companies_id
		
-- 	FROM
-- 		broker_company_agent_properties
-- 	WHERE
-- 		broker_company_agent_properties.property_rank = 4
-- 		and (
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		users_id,
-- 		is_branch,
-- 		broker_company_agents,
-- 		broker_companies_id
-- 	FROM
-- 		broker_company_agent_properties
-- 	WHERE
-- 		broker_company_agent_properties.property_rank = 3
-- 		and (
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		users_id,
-- 		is_branch,
-- 		broker_company_agents,
-- 		broker_companies_id
-- 	FROM
-- 		broker_company_agent_properties
-- 	WHERE
-- 		broker_company_agent_properties.property_rank = 2
-- 		and (
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		users_id,
-- 		is_branch,
-- 		broker_company_agents,
-- 		broker_companies_id
-- 	FROM
-- 		broker_company_agent_properties
-- 	WHERE
-- 		broker_company_agent_properties.property_rank = 1
-- 		and (
-- 			status != 5
-- 			AND status != 6
-- 		)
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		users_id,
-- 		is_branch,
-- 		broker_company_branches_agents as broker_company_agents,
-- 		broker_companies_branches_id as broker_companies_id
-- 	FROM
-- 		broker_company_agent_properties_branch
-- 	WHERE
-- 		broker_company_agent_properties_branch.property_rank = 4
-- 		and (
-- 			status != 5
-- 			AND status != 6
-- 		) -- premium
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		users_id,
-- 		is_branch,
-- 		broker_company_branches_agents as broker_company_agents,
-- 		broker_companies_branches_id as broker_companies_id
-- 	FROM
-- 		broker_company_agent_properties_branch
-- 	WHERE
-- 		broker_company_agent_properties_branch.property_rank = 3
-- 		and (
-- 			status != 5
-- 			AND status != 6
-- 		) -- featured
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		users_id,
-- 		is_branch,
-- 		broker_company_branches_agents as broker_company_agents,
-- 		broker_companies_branches_id as broker_companies_id
-- 	FROM
-- 		broker_company_agent_properties_branch
-- 	WHERE
-- 		broker_company_agent_properties_branch.property_rank = 2
-- 		and (
-- 			status != 5
-- 			AND status != 6
-- 		) -- standard
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		id,
-- 		property_title,
-- 		property_title_arabic,
-- 		description,
-- 		description_arabic,
-- 		is_verified,
-- 		property_rank,
-- 		addresses_id,
-- 		locations_id,
-- 		property_types_id,
-- 		profiles_id,
-- 		facilities_id,
-- 		amenities_id,
-- 		status,
-- 		created_at,
-- 		updated_at,
-- 		is_show_owner_info,
-- 		property,
-- 		countries_id,
-- 		ref_no,
-- 		users_id,
-- 		is_branch,
-- 		broker_company_branches_agents as broker_company_agents,
-- 		broker_companies_branches_id as broker_companies_id
-- 	FROM
-- 		broker_company_agent_properties_branch
-- 	WHERE
-- 		broker_company_agent_properties_branch.property_rank = 1
-- 		and (
-- 			status != 5
-- 			AND status != 6
-- 		)
-- )
-- SELECT
-- 	id,
-- 	property_title,
-- 	property_title_arabic,
-- 	description,
-- 	description_arabic,
-- 	is_verified,
-- 	property_rank,
-- 	addresses_id,
-- 	locations_id,
-- 	property_types_id,
-- 	profiles_id,
-- 	facilities_id,
-- 	amenities_id,
-- 	status,
-- 	created_at,
-- 	updated_at,
-- 	is_show_owner_info,
-- 	property,
-- 	countries_id,
-- 	ref_no,
-- 	users_id,
-- 	is_branch,
-- 	broker_company_agents,
-- 	broker_companies_id
-- FROM
-- 	x
-- LIMIT
-- 	$1 OFFSET $2;

-- name: GetOwnerPropertiesByPropertyId :many
-- SELECT
-- 	*
-- FROM
-- 	owner_properties_media opm
-- WHERE
-- 	opm.owner_properties_id = $1;

-- name: GetFreelancerPropertiesByPropertyId :many
-- SELECT
-- 	*
-- FROM
-- 	freelancers_properties_media fpm
-- WHERE
-- 	fpm.freelancers_properties_id = $1;

-- name: GetBrokerCompanyAgentPropertiesByPropertyId :many
-- SELECT
-- 	*
-- FROM
-- 	broker_company_agent_properties_media
-- WHERE
-- 	broker_company_agent_properties_id = $1;

-- name: GetBrokerBranchCompanyAgentPropertiesByPropertyId :many
-- SELECT * FROM broker_company_agent_properties_media_branch bcapmb 



-- WHERE bcapmb.broker_company_agent_properties_branch_id  = $1;





 


 


-- name: GetAllPropertyhubsByFilters :many
WITH x AS (
    SELECT
        id,
        property_name,
        property_title,
        property_title_arabic,
        description,
        description_arabic,
        is_verified,
        property_rank,
        addresses_id,
        locations_id,
        property_types_id,
        profiles_id,
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
        FALSE AS from_xml,
        category
    FROM
        freelancers_properties fp
    WHERE
    CASE
         WHEN $3 = 0 THEN true
         WHEN $3 = 1 THEN fp.countries_id = $6
         WHEN $3 = 2 THEN fp.countries_id != $6
    END
    AND
    CASE
        WHEN $4 = 0 THEN true
        WHEN $4 = 1 THEN fp.addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $7)
        WHEN $4 = 2 THEN fp.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $7 AND communities_id = ANY($8::bigint[]))
        WHEN $4 = 3 THEN fp.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $7 AND communities_id = ANY($8::bigint[]) AND sub_communities_id = ANY($9::bigint[]))
        WHEN $4 = 4 THEN fp.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $7 AND communities_id = ANY($8::bigint[]) AND sub_communities_id = ANY($9::bigint[]) AND addresses.locations_id = $10)
    END
    AND 
    CASE
         WHEN $5 = 0 THEN (fp.status != 5 AND fp.status != 6)
         WHEN $5 = 1 THEN fp.status = $11
    END
    AND
    CASE
         WHEN $12 = 0 THEN true
         WHEN $12 = 1 THEN fp.property_rank BETWEEN 1 AND 4
    END
    UNION ALL
    SELECT
        id,
        property_name,
        property_title,
        property_title_arabic,
        description,
        description_arabic,
        is_verified,
        property_rank,
        addresses_id,
        locations_id,
        property_types_id,
        profiles_id,
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
        FALSE AS from_xml,
        category
    FROM
        owner_properties op
    WHERE
        CASE
         WHEN $3 = 0 THEN true
         WHEN $3 = 1 THEN op.countries_id = $6
         WHEN $3 = 2 THEN op.countries_id != $6
    END
    AND
    CASE
        WHEN $4 = 0 THEN true
        WHEN $4 = 1 THEN op.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $7)
        WHEN $4 = 2 THEN op.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $7 AND communities_id = ANY($8::bigint[]))
        WHEN $4 = 3 THEN op.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $7 AND communities_id = ANY($8::bigint[]) AND sub_communities_id = ANY($9::bigint[]))
        WHEN $4 = 4 THEN op.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $7 AND communities_id = ANY($8::bigint[]) AND sub_communities_id = ANY($9::bigint[]) AND locations_id = $10)
    END
    AND 
    CASE
         WHEN $5 = 0 THEN (op.status != 5 AND op.status != 6)
         WHEN $5 = 1 THEN op.status = $11
    END
    AND
    CASE
         WHEN $12 = 0 THEN true
         WHEN $12 = 1 THEN op.property_rank BETWEEN 1 AND 4
    END
    UNION ALL
    SELECT
        id,
        property_name,
        property_title,
        property_title_arabic,
        description,
        description_arabic,
        is_verified,
        property_rank,
        addresses_id,
        locations_id,
        property_types_id,
        profiles_id,
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
        from_xml,
        category
    FROM
        broker_company_agent_properties bcap
    WHERE
        CASE
         WHEN $3 = 0 THEN true
         WHEN $3 = 1 THEN bcap.countries_id = $6
         WHEN $3 = 2 THEN bcap.countries_id != $6
    END
    AND
    CASE
        WHEN $4 = 0 THEN true
        WHEN $4 = 1 THEN bcap.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $7)
        WHEN $4 = 2 THEN bcap.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $7 AND communities_id = ANY($8::bigint[]))
        WHEN $4 = 3 THEN bcap.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $7 AND communities_id = ANY($8::bigint[]) AND sub_communities_id = ANY($9::bigint[]))
        WHEN $4 = 4 THEN bcap.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $7 AND communities_id = ANY($8::bigint[]) AND sub_communities_id = ANY($9::bigint[]) AND locations_id = $10)
    END
    AND 
    CASE
         WHEN $5 = 0 THEN (bcap.status != 5 AND bcap.status != 6)
         WHEN $5 = 1 THEN bcap.status = $11
    END
    AND
    CASE
         WHEN $12 = 0 THEN true
         WHEN $12 = 1 THEN bcap.property_rank BETWEEN 1 AND 4
    END
    UNION ALL
    SELECT
        id,
        property_name,
        property_title,
        property_title_arabic,
        description,
        description_arabic,
        is_verified,
        property_rank,
        addresses_id,
        locations_id,
        property_types_id,
        profiles_id,
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
        from_xml,
        category
    FROM
        broker_company_agent_properties_branch bcapb
    WHERE
        CASE
         WHEN $3 = 0 THEN true
         WHEN $3 = 1 THEN bcapb.countries_id = $6
         WHEN $3 = 2 THEN bcapb.countries_id != $6
    END
    AND
    CASE
        WHEN $4 = 0 THEN true
        WHEN $4 = 1 THEN bcapb.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $7)
        WHEN $4 = 2 THEN bcapb.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $7 AND communities_id = ANY($8::bigint[]))
        WHEN $4 = 3 THEN bcapb.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $7 AND communities_id = ANY($8::bigint[]) AND sub_communities_id = ANY($9::bigint[]))
        WHEN $4 = 4 THEN bcapb.addresses_id IN (SELECT id FROM addresses WHERE cities_id = $7 AND communities_id = ANY($8::bigint[]) AND sub_communities_id = ANY($9::bigint[]) AND locations_id = $10)
    END
    AND 
    CASE
         WHEN $5 = 0 THEN (bcapb.status != 5 AND bcapb.status != 6)
         WHEN $5 = 1 THEN bcapb.status = $11
    END
    AND
    CASE
         WHEN $12 = 0 THEN true
         WHEN $12 = 1 THEN bcapb.property_rank BETWEEN 1 AND 4
    END
)
SELECT
    id,property_name, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, profiles_id, facilities_id, amenities_id, status, created_at, updated_at, is_show_owner_info, property, countries_id, ref_no, is_branch, from_xml, category
FROM x ORDER BY created_at DESC LIMIT $1 OFFSET $2;

-- name: ValidateUserForPropertyHub :many
WITH x AS (
    (
        SELECT
            id
        FROM
            freelancers_properties fp
        WHERE
            CASE
                WHEN $1 :: bigint = 0 THEN true
                WHEN $1 :: bigint = 1 THEN addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2)
                WHEN $1 :: bigint = 2 THEN addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2 AND communities_id = ANY($3 :: bigint []))
                WHEN $1 :: bigint = 3 THEN addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2 AND communities_id = ANY($3 :: bigint []) AND sub_communities_id = ANY($4 :: bigint []))
                WHEN $1 :: bigint = 4 THEN addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2 AND communities_id = ANY($3 :: bigint []) AND sub_communities_id = ANY($4 :: bigint []) AND addresses.locations_id = $5)
            END
            AND status != 5 AND status != 6
            AND fp.id = $6
AND fp.property = $7 LIMIT 1
    )
    UNION
    ALL (
        SELECT
            id
        FROM
            broker_company_agent_properties_branch bcapb
        WHERE
            CASE
                WHEN $1 :: bigint = 0 THEN true
                WHEN $1 :: bigint = 1 THEN addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2)
                WHEN $1 :: bigint = 2 THEN addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2 AND communities_id = ANY($3 :: bigint []))
                WHEN $1 :: bigint = 3 THEN addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2 AND communities_id = ANY($3 :: bigint []) AND sub_communities_id = ANY($4 :: bigint []))
                WHEN $1 :: bigint = 4 THEN addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2 AND communities_id = ANY($3 :: bigint []) AND sub_communities_id = ANY($4 :: bigint []) AND addresses.locations_id = $5)
            END
            AND status != 5 AND status != 6
            AND bcapb.id = $6
AND bcapb.property = $7
        LIMIT
            1
    )
    UNION
    ALL (
        SELECT
            id
        FROM
            broker_company_agent_properties bcap
        WHERE
            CASE
                WHEN $1 :: bigint = 0 THEN true
                WHEN $1 :: bigint = 1 THEN addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2)
                WHEN $1 :: bigint = 2 THEN addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2 AND communities_id = ANY($3 :: bigint []))
                WHEN $1 :: bigint = 3 THEN addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2 AND communities_id = ANY($3 :: bigint []) AND sub_communities_id = ANY($4 :: bigint []))
                WHEN $1 :: bigint = 4 THEN addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2 AND communities_id = ANY($3 :: bigint []) AND sub_communities_id = ANY($4 :: bigint []) AND addresses.locations_id = $5)
            END
            AND status != 5 AND status != 6
            AND bcap.id = $6
           AND bcap.property = $7
        LIMIT
            1
    )
    UNION
    ALL (
        SELECT
            id
        FROM
            owner_properties op
        WHERE
            CASE
                WHEN $1 :: bigint = 0 THEN true
                WHEN $1 :: bigint = 1 THEN addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2)
                WHEN $1 :: bigint = 2 THEN addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2 AND communities_id = ANY($3 :: bigint []))
                WHEN $1 :: bigint = 3 THEN addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2 AND communities_id = ANY($3 :: bigint []) AND sub_communities_id = ANY($4 :: bigint []))
                WHEN $1 :: bigint = 4 THEN addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2 AND communities_id = ANY($3 :: bigint []) AND sub_communities_id = ANY($4 :: bigint []) AND addresses.locations_id = $5)
            END
            AND status != 5 AND status != 6
            AND op.id = $6
AND op.property = $7
        LIMIT
            1
    )
)
SELECT
    id
FROM
    x;

-- name: GetAllProjectHubRefrenceNumber :many
WITH x AS(
SELECT ref_no FROM broker_company_agent_properties
UNION ALL
SELECT ref_no FROM broker_company_agent_properties_branch
UNION ALL
SELECT ref_no FROM owner_properties
UNION ALL
SELECT ref_no FROM freelancers_properties
) SELECT * FROM x LIMIT $1 OFFSET $2;

-- name: GetAllPropertyHubRefNo :many
WITH x AS (
SELECT id,ref_no,false AS is_branch,property,property_types_id  FROM freelancers_properties
UNION ALL
SELECT id,ref_no,false AS is_branch,property,property_types_id  FROM broker_company_agent_properties
UNION ALL
SELECT id,ref_no,true AS is_branch,property,property_types_id  FROM broker_company_agent_properties_branch
UNION ALL
SELECT id,ref_no,false AS is_branch,property,property_types_id  FROM owner_properties
)
SELECT id, ref_no, is_branch, property FROM x LIMIT $1 OFFSET $2;

-- name: GetPropertyHubRefNoBySearch :many
WITH x AS (
SELECT id,ref_no,false AS is_branch,property FROM freelancers_properties WHERE freelancers_properties.ref_no ILIKE $1
UNION ALL
SELECT id,ref_no,false AS is_branch,property FROM broker_company_agent_properties WHERE broker_company_agent_properties.ref_no ILIKE $1
UNION ALL
SELECT id,ref_no,true AS is_branch,property FROM broker_company_agent_properties_branch WHERE broker_company_agent_properties_branch.ref_no ILIKE $1
UNION ALL
SELECT id,ref_no,false AS is_branch,property FROM owner_properties WHERE owner_properties.ref_no ILIKE $1
)
SELECT * FROM x;

-- name: GetAllPropertiesDetails :many
with x as (
SELECT freelancers_properties.id, freelancers_properties.ref_no, freelancers_properties.status,  freelancers_properties.property_name, freelancers_properties.category,'property_hub' AS section, false as is_branch , freelancers_properties.property, freelancers_properties.addresses_id, freelancers_properties.users_id, freelancers_properties.property_types_id, freelancers_properties.unit_types,
property_types."type" , properties_facts.bedroom, properties_facts.bathroom, properties_facts.min_area, properties_facts.max_area, properties_facts.price, properties_facts.plot_area , countries.id as "countries_id", countries.country, states.id as "states_id", states.state, cities.id as "cities_id", cities.city, communities.id as "communities_id", communities.community, sub_communities.id as "sub_communities_id", sub_communities.sub_community, locations.lat, locations.lng
 FROM freelancers_properties
JOIN property_types ON freelancers_properties.property_types_id = property_types.id
LEFT JOIN properties_facts ON properties_facts.properties_id = freelancers_properties.id 
LEFT JOIN addresses ON addresses.id = freelancers_properties.addresses_id
LEFT JOIN countries ON countries.id = addresses.country_id
LEFT JOIN states ON states.id = addresses.state_id
LEFT JOIN cities ON cities.id = addresses.city_id
LEFT JOIN communities ON communities.id = addresses.community_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_community_id
LEFT JOIN locations ON locations.id = addresses.locations_id

WHERE properties_facts.property = 2 AND properties_facts.life_style != 3 AND freelancers_properties.category = $1 AND property_types.is_commercial = $2 and properties_facts.min_area >= $3 and properties_facts.max_area <= $4 and properties_facts.price >= $5 and properties_facts.price <= $6 and properties_facts.bedroom = $7 and properties_facts.bathroom = $8
UNION ALL
 
SELECT broker_company_agent_properties.id, broker_company_agent_properties.ref_no, broker_company_agent_properties.status,  property_name, broker_company_agent_properties.category,'property_hub' AS section, false as is_branch , broker_company_agent_properties.property, broker_company_agent_properties.addresses_id, broker_company_agent_properties.users_id, broker_company_agent_properties.property_types_id , broker_company_agent_properties.unit_types, property_types."type" , properties_facts.bedroom, properties_facts.bathroom, properties_facts.min_area, properties_facts.max_area, properties_facts.price, properties_facts.plot_area , countries.id as "countries_id", countries.country, states.id as "states_id", states.state, cities.id as "cities_id", cities.city, communities.id as "communities_id", communities.community, sub_communities.id as "sub_communities_id", sub_communities.sub_community, locations.lat, locations.lng
 FROM broker_company_agent_properties
JOIN property_types ON broker_company_agent_properties.property_types_id = property_types.id
LEFT JOIN properties_facts ON properties_facts.properties_id = broker_company_agent_properties.id 
LEFT JOIN addresses ON addresses.id = broker_company_agent_properties.addresses_id
LEFT JOIN countries ON countries.id = addresses.country_id
LEFT JOIN states ON states.id = addresses.state_id
LEFT JOIN cities ON cities.id = addresses.city_id
LEFT JOIN communities ON communities.id = addresses.community_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_community_id
LEFT JOIN locations ON locations.id = addresses.locations_id

WHERE properties_facts.property = 3 AND properties_facts.life_style != 3 AND properties_facts.is_branch = false AND broker_company_agent_properties.category = $1 AND property_types.is_commercial = $2 and properties_facts.min_area >= $3 and properties_facts.max_area <= $4 and properties_facts.price >= $5 and properties_facts.price <= $6 and properties_facts.bedroom = $7 and properties_facts.bathroom = $8
UNION ALL
 
SELECT broker_company_agent_properties_branch.id, broker_company_agent_properties_branch.ref_no, broker_company_agent_properties_branch.status,  broker_company_agent_properties_branch.property_name, broker_company_agent_properties_branch.category,'property_hub' AS section, true as is_branch , broker_company_agent_properties_branch.property, addresses_id, users_id, broker_company_agent_properties_branch.property_types_id , broker_company_agent_properties_branch.unit_types, property_types."type" , properties_facts.bedroom, properties_facts.bathroom, properties_facts.min_area, properties_facts.max_area, properties_facts.price, properties_facts.plot_area , countries.id as "countries_id", countries.country, states.id as "states_id", states.state, cities.id as "cities_id", cities.city, communities.id as "communities_id", communities.community, sub_communities.id as "sub_communities_id", sub_communities.sub_community, locations.lat, locations.lng
 FROM broker_company_agent_properties_branch
JOIN property_types ON broker_company_agent_properties_branch.property_types_id = property_types.id
LEFT JOIN properties_facts ON properties_facts.properties_id = broker_company_agent_properties_branch.id 
LEFT JOIN addresses ON addresses.id = broker_company_agent_properties_branch.addresses_id
LEFT JOIN countries ON countries.id = addresses.country_id
LEFT JOIN states ON states.id = addresses.state_id
LEFT JOIN cities ON cities.id = addresses.city_id
LEFT JOIN communities ON communities.id = addresses.community_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_community_id
LEFT JOIN locations ON locations.id = addresses.locations_id

WHERE properties_facts.property = 3 AND properties_facts.life_style != 3 AND properties_facts.is_branch = false and broker_company_agent_properties_branch.category = $1 AND property_types.is_commercial = $2 and properties_facts.min_area >= $3 and properties_facts.max_area <= $4 and properties_facts.price >= $5 and properties_facts.price <= $6 and properties_facts.bedroom = $7 and properties_facts.bathroom = $8
UNION ALL
 
SELECT owner_properties.id, owner_properties.ref_no, owner_properties.status,  owner_properties.property_name, owner_properties.category,'proeprty_hub' AS section, false as is_branch , owner_properties.property, owner_properties.addresses_id, owner_properties.users_id, owner_properties.property_types_id , owner_properties.unit_types, property_types."type" , properties_facts.bedroom, properties_facts.bathroom, properties_facts.min_area, properties_facts.max_area, properties_facts.price, properties_facts.plot_area , countries.id as "countries_id", countries.country, states.id as "states_id", states.state, cities.id as "cities_id", cities.city, communities.id as "communities_id", communities.community, sub_communities.id as "sub_communities_id", sub_communities.sub_community, locations.lat, locations.lng
 FROM owner_properties
JOIN property_types ON owner_properties.property_types_id = property_types.id
LEFT JOIN properties_facts ON properties_facts.properties_id = owner_properties.id 
LEFT JOIN addresses ON addresses.id = owner_properties.addresses_id
LEFT JOIN countries ON countries.id = addresses.country_id
LEFT JOIN states ON states.id = addresses.state_id
LEFT JOIN cities ON cities.id = addresses.city_id
LEFT JOIN communities ON communities.id = addresses.community_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_community_id
LEFT JOIN locations ON locations.id = addresses.locations_id

WHERE properties_facts.property = 4 AND properties_facts.life_style != 3 AND owner_properties.category = $1 AND property_types.is_commercial = $2 and properties_facts.min_area >= $3 and properties_facts.max_area <= $4 and properties_facts.price >= $5 and properties_facts.price <= $6 and properties_facts.bedroom = $7 and properties_facts.bathroom = $8
) select * from x;