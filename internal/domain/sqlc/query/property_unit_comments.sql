-- name: CreatePropertyUnitComment :one
INSERT INTO property_unit_comments (
    property_unit_id,
    which_property_unit,
    which_propertyhub_key,
    users_id,
    comment,
    created_at,
    updated_at
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7
) RETURNING *;

-- name: GetPropertyUnitComment :one
SELECT * FROM property_unit_comments 
WHERE id = $1 LIMIT 1;

-- name: GetAllPropertyUnitComment :many
SELECT * FROM property_unit_comments
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdatePropertyUnitComment :one
UPDATE property_unit_comments
SET  
   property_unit_id = $2,
    which_property_unit = $3,
    which_propertyhub_key = $4,
    users_id = $5,
    comment = $6,
    created_at = $7,
    updated_at = $8
Where id = $1
RETURNING *;


-- name: DeletePropertyUnitComment :exec
DELETE FROM property_unit_comments
Where id = $1;

 

