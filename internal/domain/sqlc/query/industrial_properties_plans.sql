-- name: CreateIndustrailPropertyPlan :one
INSERT INTO industrial_properties_plans (
    img_url,
    title,
    properties_id,
    property,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3, $4, $5, $6
) RETURNING *;

-- name: GetIndustrailPropertyPlan :one
SELECT * FROM industrial_properties_plans 
WHERE id = $1 LIMIT 1;

-- name: GetAllIndustrailPropertyPlan :many
SELECT * FROM industrial_properties_plans
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: GetAllIndustrailPropertyPlanWithoutPagination :many
SELECT * FROM industrial_properties_plans
ORDER BY id;

-- name: UpdateIndustrailPropertyPlan :one
UPDATE industrial_properties_plans
SET img_url = $2,
    title = $3,
    properties_id = $4,
    property = $5,
    created_at = $6,
    updated_at = $7
Where id = $1
RETURNING *;


-- name: DeleteIndustrailPropertyPlan :exec
DELETE FROM industrial_properties_plans
Where id = $1;

-- name: GetIndustrialPropertyPlanByTitle :one
SELECT * FROM industrial_properties_plans 
WHERE title ILIKE $1 AND properties_id = $2 AND property = $3;


-- name: GetAllIndustrialPropertyPlanById :many
 SELECT id, img_url, title, properties_id, property, created_at, updated_at 
 FROM industrial_properties_plans 
WHERE properties_id = $1 AND property = $2;