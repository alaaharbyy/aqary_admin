-- name: CreateCollectionName :one
INSERT INTO collection_name (
    name,
    image_url,
    access_type,
    access_granted_users,
    users_id,
    created_at,
    updated_at
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7
) RETURNING *;

-- name: GetCollectionName :one
SELECT * FROM collection_name 
WHERE id = $1 LIMIT 1;

-- name: GetCollectionNameByName :one
SELECT * FROM collection_name 
WHERE name = $1 AND users_id = $2 LIMIT 1;

-- name: GetAllCollectionName :many
SELECT * FROM collection_name
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: GetAllCollectionNameWithoutPagination :many
SELECT * FROM collection_name
Where users_id = $1
ORDER BY name;

-- name: UpdateCollectionName :one
UPDATE collection_name
SET  
    name = $2,
    image_url = $3,
    access_type = $4,
    access_granted_users = $5,
    users_id = $6,
    created_at = $7,
    updated_at = $8
Where id = $1
RETURNING *;


-- name: DeleteCollectionName :exec
DELETE FROM collection_name
Where id = $1;

 

