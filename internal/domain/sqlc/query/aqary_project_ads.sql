-- name: AddProjectAd :one
INSERT INTO aqary_project_ads (company_types_id, companies_id, is_branch, title, project_id, ads_category, created_by,is_project_branch,ads_schema,ads_status, is_public, is_verified, tags) VALUES
($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11,$12, $13) RETURNING *;
 
-- name: UpdateProjectAd :one
UPDATE aqary_project_ads SET company_types_id = $2 ,companies_id=$3,is_branch=$4,title=$5,project_id=$6,ads_category=$7,created_by=$8,is_project_branch=$9,ads_schema=$10,ads_status=$11, tags= $12 WHERE id = $1 RETURNING *; 

-- name: GetAllProjectAds :many
SELECT * FROM aqary_project_ads app JOIN users u ON app.created_by = u.id LIMIT $1 OFFSET $2;
 
-- name: GetAllProjectAdsByPostedBy :many
SELECT * FROM aqary_project_ads app JOIN users u ON app.created_by = u.id WHERE app.created_by = $3 LIMIT $1 OFFSET $2;
 
-- name: GetProjectAdByID :one
SELECT * FROM aqary_project_ads app JOIN users u ON app.created_by = u.id WHERE app.id = $1 LIMIT 1;
 
-- name: DeleteProjectAd :exec
DELETE FROM aqary_project_ads WHERE id = $1;

-- name: UpdateProjectAdIsVerified :one
UPDATE aqary_project_ads SET is_verified = $2 WHERE id = $1 RETURNING *;