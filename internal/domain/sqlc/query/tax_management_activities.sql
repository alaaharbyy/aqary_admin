-- name: CreateTaxMangementActivities :one
 
INSERT INTO tax_management_activities (
    ref_activity_id,
    company_types_id,
    companies_id,
    is_branch,
    activity_type,
    module_name,
    activity,
    activity_date,
    user_id
) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING *;
 
-- name: GetTaxMangementActivities :many
SELECT * FROM tax_management_activities;
 
-- name: GetTaxMangementActivitiesWithPg :many
SELECT * FROM tax_management_activities LIMIT $1 OFFSET $2;
 
-- name: GetTaxMangementActivitiesById :one
SELECT * FROM tax_management_activities WHERE id = $1;
 
-- name: UpdateTaxMangementActivities :one
UPDATE tax_management_activities
SET
    ref_activity_id = $2,
    company_types_id = $3,
    companies_id = $4, 
    is_branch = $5,
    activity_type = $6,
    module_name = $7,
    activity = $8,
    activity_date = $9,
    user_id = $10
WHERE id = $1 RETURNING *;
 
-- name: DeleteTaxMangementActivities :exec
DELETE FROM tax_management_activities
WHERE id = $1;
 
-- name: GetTaxMangementActivityByRefIdAndModuleName :one
SELECT
*
FROM
    tax_management_activities
WHERE
     ref_activity_id = $1 and module_name=$2;

-- name: GetTaxManagementActivities :many
SELECT * FROM tax_management_activities WHERE activity_type = $1 
LIMIT $2 OFFSET $3;
 
 
-- name: GetTaxManagementActivitiesChanges :many
SELECT tax_man_act.id, act_chan.activity_date, act_chan.field_name, act_chan.before, act_chan.after FROM activity_changes AS act_chan
INNER JOIN tax_management_activities AS tax_man_act
ON act_chan.activities_id = tax_man_act.id
WHERE act_chan.activities_id = $1;