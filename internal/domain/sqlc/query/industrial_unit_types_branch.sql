-- name: CreateIndustrialUnitTypesBranch :one
INSERT INTO industrial_unit_types_branch (
     description,
     image_url,
     min_area,
     max_area,
     min_price,
     max_price,
     parking,
     balcony,
     properties_id,
     property,
     property_types_id,
     created_at,
     updated_at,
     title,
     bedrooms
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15
) RETURNING *;

-- name: GetIndustrialUnitTypesBranch :one
SELECT * FROM industrial_unit_types_branch 
WHERE id = $1 LIMIT 1;

-- name: GetAllIndustrialUnitTypesBranch :many
SELECT * FROM industrial_unit_types_branch
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: GetAllIndustrialUnitTypesBranchWithoutPagination :many
SELECT * FROM industrial_unit_types_branch
ORDER BY id;

-- name: UpdateIndustrialUnitTypesBranch :one
UPDATE industrial_unit_types_branch
SET  description = $2,
     image_url = $3,
     min_area = $4,
     max_area = $5,
     min_price = $6,
     max_price = $7,
     parking = $8,
     balcony = $9,
     properties_id = $10,
     property = $11,
     property_types_id = $12,
     created_at = $13,
     updated_at = $14,
     title = $15,
     bedrooms = $16
Where id = $1
RETURNING *;


-- name: DeleteIndustrialUnitTypesBranch :exec
DELETE FROM industrial_unit_types_branch
Where id = $1;


-- name: GetAllIndustrialUnitTypeBranchByPropertyId :many
SELECT * FROM industrial_unit_types_branch 
WHERE property = $3 AND properties_id = $4  LIMIT $1 OFFSET $2;

-- name: GetCountAllIndustrialUnitTypeBranchByPropertyId :one
SELECT COUNT(*) FROM industrial_unit_types_branch
WHERE property = $1 AND properties_id = $2;