-- name: CreateRentPropertyUnitPlan :one
INSERT INTO rent_property_unit_plans (
    img_url,
    title,
rent_property_units_id,
created_at,
updated_at
)VALUES (
    $1 ,$2, $3, $4, $5
) RETURNING *;

-- name: GetRentPropertyUnitPlan :one
SELECT * FROM rent_property_unit_plans 
WHERE id = $1 LIMIT 1;

-- name: GetAllRentPropertyUnitPlan :many
SELECT * FROM rent_property_unit_plans
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateRentPropertyUnitPlan :one
UPDATE rent_property_unit_plans
SET img_url = $2,
title = $3,
rent_property_units_id = $4,
created_at = $5,
updated_at = $6
Where id = $1
RETURNING *;


-- name: DeleteRentPropertyUnitPlan :exec
DELETE FROM rent_property_unit_plans
Where id = $1;

-- name: GetRentPropertyUnitPlanByTitleAndUnitId :one
SELECT * FROM rent_property_unit_plans 
WHERE title ILIKE $1 AND rent_property_units_id = $2;

-- name: UpdateRentPropertyUnitPlanUrls :one
UPDATE rent_property_unit_plans
SET img_url = $2,
updated_at = $3
Where id = $1
RETURNING *;

-- name: GetAllRentPropertyUnitPlanByUnit :many
SELECT * FROM rent_property_unit_plans
WHERE rent_property_units_id = $3
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;

-- name: GetCountAllRentPropertyUnitPlanByUnit :one
SELECT COUNT(*) FROM rent_property_unit_plans
WHERE rent_property_units_id = $1;

-- name: DeleteRentPropertyUnitPlanSingleFile :one
UPDATE rent_property_unit_plans
SET img_url = array_remove(img_url, @fileurl::VARCHAR)
WHERE id = $1
RETURNING *;