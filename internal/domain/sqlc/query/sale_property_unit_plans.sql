-- name: CreateSalePropertyUnitPlan :one
INSERT INTO sale_property_unit_plans (
    img_url,
    title,
sale_property_units_id,
created_at,
updated_at
)VALUES (
    $1 ,$2, $3, $4, $5
) RETURNING *;



-- name: GetSalePropertyUnitPlan :one
SELECT * FROM sale_property_unit_plans 
WHERE id = $1 LIMIT 1;

-- name: GetAllSalePropertyUnitPlan :many
SELECT * FROM sale_property_unit_plans
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateSalePropertyUnitPlan :one
UPDATE sale_property_unit_plans
SET img_url = $2,
title = $3,
sale_property_units_id = $4,
created_at = $5,
updated_at = $6
Where id = $1
RETURNING *;


-- name: DeleteSalePropertyUnitPlan :exec
DELETE FROM sale_property_unit_plans
Where id = $1;

-- name: GetSalePropertyUnitPlanByTitleAndUnitId :one
SELECT * FROM sale_property_unit_plans 
WHERE title ILIKE $1 AND sale_property_units_id = $2;

-- name: UpdateSalePropertyUnitPlanUrls :one
UPDATE sale_property_unit_plans
SET img_url = $2,
updated_at = $3
Where id = $1
RETURNING *;

-- name: GetAllSalePropertyUnitPlanByUnit :many
SELECT * FROM sale_property_unit_plans
WHERE sale_property_units_id = $3
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;

-- name: GetCountAllSalePropertyUnitPlanByUnit :one
SELECT COUNT(*) FROM sale_property_unit_plans
WHERE sale_property_units_id = $1;


-- name: DeleteSalePropertyUnitPlanSingleFile :one
UPDATE sale_property_unit_plans
SET img_url = array_remove(img_url, @fileurl::VARCHAR)
WHERE id = $1
RETURNING *;