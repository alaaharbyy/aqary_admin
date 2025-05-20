-- name: CreateUnitBranchType :one
INSERT INTO unit_types_branch (
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
 bedrooms,
 description_ar,
 status,
 ref_no
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18
) RETURNING *;

-- name: GetUnitBranchType :one
SELECT * FROM unit_types_branch 
WHERE id = $1 LIMIT $1;

-- name: GetAllUnitBranchType :many
SELECT * FROM unit_types_branch
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateUnitBranchType :one
UPDATE unit_types_branch
SET   
  description = $2,
 image_url = $3,
 min_area = $4,
 max_area = $5,
 min_price = $6,
 max_price = $7,
 parking = $8,
 balcony = $9,
 properties_id  = $10,
 property = $11,
 property_types_id = $12,
 created_at= $13,
 updated_at = $14,
 title = $15,
 bedrooms = $16,
 description_ar = $17,
  status = $18,
  ref_no = $19
Where id = $1
RETURNING *;


-- name: DeleteUnitBranchType :exec
DELETE FROM unit_types_branch
Where id = $1;

-- name: GetAllUnitBranchTypeByPropertyId :many
SELECT * FROM unit_types_branch 
WHERE property = $1 AND properties_id = $2;

-- name: GetAllUnitTypeBranchByPropertyIdAndBedroom :many
SELECT * FROM unit_types_branch 
INNER JOIN property_types On unit_types_branch.property_types_id = property_types.id
WHERE property = $1 AND properties_id = $2 AND property_types.id = $3 AND CASE WHEN bedrooms IS NULL THEN TRUE ELSE bedrooms ILIKE $4 END;

-- name: GetAllUnitTypeBranchByPropertyIdAndBedroomAndUnitId :many
SELECT * FROM unit_types_branch
WHERE property = $1 AND properties_id = $2 AND  bedrooms  ILIKE  $3 AND unit_types_branch.id = $4;


-- name: GetAllUnitBranchTypeByPropertyIdWithPagination :many
SELECT * FROM unit_types_branch 
WHERE property = $3 AND properties_id = $4  LIMIT $1 OFFSET $2;


-- name: GetCountUnitBranchTypeByPropertyIdWithPagination :one
SELECT Count(*) FROM unit_types_branch 
WHERE property = $1 AND properties_id = $2;
 
