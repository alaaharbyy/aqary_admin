-- name: CreateCompaniesActivitiesHistory :one
INSERT INTO companies_activities_history (
    title,
    module_name,
    field_value,
    created_by,
    activity_date
)VALUES (
    $1, $2, $3, $4, $5
)RETURNING *;

-- name: GetAllCompaniesActivitiesHistory :many
SELECT COUNT(companies_activities_history.id) OVER() AS total_count,
companies_activities_history.id,
title,
activity_date,
module_name,
(profiles.first_name ||' '|| profiles.last_name)::VARCHAR AS user, 
field_value
FROM companies_activities_history
INNER JOIN users ON users.id = companies_activities_history.created_by
INNER JOIN profiles ON profiles.users_id = users.id
ORDER BY id DESC
LIMIT $1 OFFSET $2;