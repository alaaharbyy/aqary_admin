-- name: AddPost :one
INSERT INTO aqary_property_posts (ref_no, company_types_id, companies_id, is_branch, title, property_unit_id, post_category, description, tags, posted_by,is_property_branch,post_schema,property_hub_category, is_public, is_verified) VALUES
($1, $2, $3, $4, $5, $6, $7, $8, $9, $10,$11,$12,$13, $14, $15) RETURNING *;

-- name: UpdatePost :one
UPDATE aqary_property_posts SET ref_no = $2 ,company_types_id=$3,companies_id=$4,is_branch=$5,title=$6,property_unit_id=$7,
post_category=$8,description=$9,tags=$10,posted_by=$11,is_property_branch=$12,post_schema=$13,property_hub_category=$14 WHERE id = $1 RETURNING *;

-- name: GetAllPosts :many
SELECT * FROM aqary_property_posts app JOIN users u ON app.posted_by = u.id LIMIT $1 OFFSET $2;

-- name: GetAllPostsByPostedBy :many
SELECT * FROM aqary_property_posts app JOIN users u ON app.posted_by = u.id WHERE app.posted_by = $3 LIMIT $1 OFFSET $2;

-- name: GetPostByID :one
SELECT * FROM aqary_property_posts app JOIN users u ON app.posted_by = u.id WHERE app.id = $1 LIMIT 1;

-- name: DeletePost :exec
DELETE FROM aqary_property_posts WHERE id = $1;

-- name: GetPostByIDAndCategory :one
SELECT * FROM aqary_property_posts app JOIN users u ON app.posted_by = u.id WHERE app.id = $1 AND app.post_category = $2 LIMIT 1;

-- name: GetCountAllPropertyPostsByPostedBy :one
SELECT count(*) FROM aqary_property_posts  WHERE posted_by = $1;

-- name: GetAllAqaryMediaPosts :many
WITH x AS (
SELECT 
	id,
	ref_no,
	company_types_id,
	companies_id,
	is_branch, 
	title,
	project_id AS project_or_property_unit_id,
	is_project_branch AS project_or_property_isBranch,
	'project' AS post_category,
	description,
	post_schema,
	tags,
	posted_by,
	date_posted,
	0 as property_hub_category
	FROM aqary_project_posts
	UNION ALL
	SELECT id,
	ref_no,
	company_types_id,
	companies_id,
	is_branch, 
	title,
	property_unit_id  AS project_or_property_unit_id,
	is_property_branch AS project_or_property_isBranch,
	post_category,
	description,
	post_schema,
	tags,
	posted_by,
	date_posted,
	property_hub_category FROM aqary_property_posts
) SELECT * FROM x LIMIT $1 OFFSET $2;

-- name: UpdatePostIsVerified :one
UPDATE aqary_property_posts SET is_verified = $2 WHERE id = $1 RETURNING *;