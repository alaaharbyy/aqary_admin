-- name: CreateUnitPlans :one
INSERT INTO unit_plans (
    img_url,
    title,
    units_id,
    created_at,
    updated_at
)VALUES (
    $1 ,$2, $3, $4, $5
) RETURNING *;

-- name: UpdateUnitPlansUrls :one
UPDATE unit_plans
SET img_url = $2,
updated_at = $3
WHERE id = $1
RETURNING *;

-- name: GetUnitPlansByTitleAndUnitId :one
SELECT * FROM unit_plans 
WHERE title ILIKE $1 AND units_id = $2 LIMIT 1;

-- name: GetUnitPlans :one
SELECT * FROM unit_plans 
WHERE id = $1 LIMIT 1;

-- name: UpdateUnitPlans :one
UPDATE unit_plans
SET img_url = $2,
    title = $3,
    units_id = $4,
    created_at = $5,
    updated_at = $6
WHERE id = $1
RETURNING *;

-- name: GetAllUnitPlansByUnit :many
SELECT * FROM unit_plans
WHERE units_id = $3
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;

-- name: GetAllUnitPlansByUnitWithoutPagination :many
SELECT * FROM unit_plans
WHERE units_id = $1
ORDER BY created_at DESC;

-- name: GetCountAllUnitPlansByUnit :one
SELECT COUNT(*) FROM unit_plans
WHERE units_id = $1;

-- name: DeleteUnitPlansSingleFile :one
UPDATE unit_plans
SET img_url = array_remove(img_url, @fileurl::VARCHAR)
WHERE id = $1
RETURNING *;

-- name: DeleteUnitPlans :exec
DELETE FROM unit_plans
Where id = $1;