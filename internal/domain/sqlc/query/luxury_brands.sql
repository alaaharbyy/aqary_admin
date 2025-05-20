-- name: CreateLuxuryBrand :one
INSERT INTO luxury_brands(
    brand_name,
    description,
    logo_url,
    status,
    created_at,
    updated_at
)VALUES($1,$2,$3,$4,$5,$6)
RETURNING *;

-- name: GetLuxuryBrands :many
SELECT sqlc.embed(luxury_brands) 
FROM 
    luxury_brands 
WHERE status!=6 
ORDER BY updated_at DESC
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');


-- name: GetLuxuryBrandsCount :one
SELECT count(luxury_brands.id) 
FROM 
    luxury_brands 
WHERE status!=6;


-- name: UpdateLuxuryBrand :one
UPDATE luxury_brands 
SET 
    brand_name=$2,
    description=$3,
    logo_url=$4,
    updated_at=$5
WHERE id=$1
RETURNING *;

-- name: UpdateLuxuryBrandStatus :one
UPDATE luxury_brands 
SET 
    status=$2
WHERE id=$1
RETURNING *;


-- name: GetLuxuryBrand :one
SELECT sqlc.embed(luxury_brands) 
FROM 
    luxury_brands 
WHERE id=$1;


-- name: GetLuxuryBrandByName :one
SELECT 
    sqlc.embed(luxury_brands) 
FROM 
    luxury_brands 
WHERE brand_name=$1;

-- name: DeleteLuxuryBrand :exec
DELETE  FROM luxury_brands 
WHERE id=$1;
