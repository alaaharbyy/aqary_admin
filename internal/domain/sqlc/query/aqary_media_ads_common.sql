-- name: GetCountAllAqaryMediaPosts :one
WITH x AS (
 
SELECT 
	id
	FROM aqary_project_posts
 
	UNION ALL
 
	SELECT id
 
	FROM aqary_property_posts
 
) SELECT COUNT(*) FROM x;

-- name: GetAllAqaryMediaAds :many
WITH x AS (
SELECT 
	id,
	company_types_id,
	companies_id,
	is_branch, 
	title,
	project_id AS project_or_property_unit_id,
	is_project_branch AS project_or_property_isBranch,
	ads_category,
	ads_status,
	ads_schema,
	created_by,
	created_at,
	0 as property_hub_category
	FROM aqary_project_ads
	UNION ALL
	SELECT id,
	company_types_id,
	companies_id,
	is_branch, 
	title,
	property_unit_id  AS project_or_property_unit_id,
	is_property_unit_branch AS project_or_property_isBranch,
	ads_category,
	ads_status,
	ads_schema,
	created_by,
	created_at,
	property_hub_category FROM aqary_property_ads
) SELECT * FROM x LIMIT $1 OFFSET $2;
 
 
-- name: GetCountAllAqaryMediaAds :one
WITH x AS (
SELECT 
	id
	FROM aqary_project_ads
	UNION ALL
	SELECT id
	FROM aqary_property_ads
) SELECT COUNT(*) FROM x;