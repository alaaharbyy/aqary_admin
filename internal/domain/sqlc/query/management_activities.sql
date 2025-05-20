-- name: CreateMangementActivities :one
INSERT INTO management_activities (
    activity_type,
    company_types_id,
    companies_id,
    is_branch,
    module_name,
    activity,
    activity_date,
    user_id
) VALUES ($1,$2,$3,$4,$5,$6,$7,$8) RETURNING *;
 
 
-- name: GetMangementActivities :many
SELECT * FROM management_activities;
 
-- name: GetMangementActivitiesWithPg :one
SELECT * FROM management_activities LIMIT $1 OFFSET $2;
 
-- name: GetMangementActivitiesById :one
SELECT * FROM management_activities WHERE id = $1;
 
 
-- name: UpdateMangementActivities :one
UPDATE management_activities
SET
    activity_type = $2,
    company_types_id = $3,
    companies_id = $4,
    is_branch = $5,
    module_name = $6,
    activity = $7,
    activity_date = $8,
    user_id = $9
WHERE id = $1 RETURNING *;
 
 
-- name: DeleteMangementActivities :exec
DELETE FROM management_activities
WHERE id = $1;

-- name: GetCountMangementActivities :many
SELECT Count(*) FROM management_activities;