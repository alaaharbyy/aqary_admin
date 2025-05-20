-- name: AddProjectPost :one
INSERT INTO aqary_project_posts (ref_no, company_types_id, companies_id, is_branch, title, project_id, description, tags, posted_by,is_project_branch,post_schema, is_public, is_verified) VALUES
($1, $2, $3, $4, $5, $6, $7, $8, $9, $10,$11, $12, $13) RETURNING *;

-- name: UpdateProjectPost :one
UPDATE aqary_project_posts SET ref_no = $2 ,company_types_id=$3,companies_id=$4,is_branch=$5,title=$6,project_id=$7,description=$8,tags=$9,posted_by=$10,is_project_branch=$11,post_schema=$12 WHERE id = $1 RETURNING *;

-- name: GetAllProjectPosts :many
SELECT * FROM aqary_project_posts app JOIN users u ON app.posted_by = u.id LIMIT $1 OFFSET $2;

-- name: GetAllProjectPostsByPostedBy :many
SELECT * FROM aqary_project_posts app JOIN users u ON app.posted_by = u.id WHERE app.posted_by = $3 LIMIT $1 OFFSET $2;

-- name: GetProjectPostByID :one
SELECT * FROM aqary_project_posts app JOIN users u ON app.posted_by = u.id WHERE app.id = $1 LIMIT 1;

-- name: DeleteProjectPost :exec
DELETE FROM aqary_project_posts WHERE id = $1;

-- name: GetCountAllProjectPosts :one
SELECT count(*) FROM aqary_project_posts;

-- name: GetCountAllProjectPostsByPostedBy :one
SELECT count(*) FROM aqary_project_posts WHERE posted_by = $1;

-- name: UpdateProjectPostIsVerified :one
UPDATE aqary_project_posts SET is_verified = $2 WHERE id = $1 RETURNING *;