-- name: CreateCategorySettings :exec
INSERT INTO
    categories(
        category,
        created_at,
        updated_at,
        updated_by,
        "type"
    )
VALUES($1,$2,$3,$4,$5);



-- name: UpdateCategorySettings :exec
UPDATE 
	categories
SET 
	category=$2, 
	updated_at=$3, 
	updated_by=$4, 
	"type"=$5
WHERE 
	id=$1; 


-- name: GetCategorySettingsByID :one
SELECT id,category,"type"
FROM 
	categories
WHERE 
	id=$1; 
	
-- name: GetAllCategoriesSettings :many
SELECT id,category,"type"
FROM 
	categories
WHERE
	@type::BIGINT =0 OR categories.type= @type::BIGINT
ORDER BY updated_at DESC 
LIMIT sqlc.narg('limit') OFFSET sqlc.narg('offset');

-- name: GetNumberOfCategoriesSettings :one
SELECT COUNT(*) 
FROM 
	categories
WHERE 
	@type::BIGINT =0 OR categories.type= @type::BIGINT;

-- name: DeleteCategorySettingsByID :one
DELETE FROM
    categories
WHERE
    id = $1 RETURNING 1;  


-- name: CheckIfFacilitiesAmenitiesHasCategoryID :one
SELECT 1
FROM 
	facilities_amenities 
WHERE categories=$1;