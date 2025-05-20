-- name: CreatePropertyTypeFacts :one
INSERT INTO property_type_facts (
    title,
    status,
    created_at,
    updated_at ,
    icon  
)VALUES (
    $1, $2, $3,$4, $5
) RETURNING *;

-- name: GetPropertyTypeFacts :one
SELECT * FROM property_type_facts 
WHERE id = $1 LIMIT $1;

-- name: GetPropertyTypeFactByTitle :one
SELECT * FROM property_type_facts 
WHERE title = $1 LIMIT 1;

 
-- name: GetAllPropertyTypeFacts :many
SELECT * FROM property_type_facts
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdatePropertyTypeFacts :one
UPDATE property_type_facts
SET  title = $2,
    status = $3,
    created_at = $4,
    updated_at = $5,
    icon  = $6
Where id = $1
RETURNING *;


-- name: DeletePropertyTypeFacts :exec
DELETE FROM property_type_facts
Where id = $1;


-- name: GetAllPropertyTypeFactsByIds :many
SELECT id,title AS label FROM property_type_facts WHERE id = ANY($1::bigint[]);


