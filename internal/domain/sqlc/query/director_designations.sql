-- name: CreateDesignation :one
INSERT INTO designations (
    designation,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3
) RETURNING *;

-- name: GetDesignation :one
SELECT * FROM designations 
WHERE id = $1 LIMIT $1;

-- name: GetDesignationByName :one
SELECT * FROM designations 
WHERE designation = $2 LIMIT $1;

-- name: GetAllDesignation :many
SELECT * FROM designations
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateDesignation :one
UPDATE designations
SET  designation = $2,
    created_at = $3,
    updated_at = $4
Where id = $1
RETURNING *;


-- name: DeleteDesignation :exec
DELETE FROM designations
Where id = $1;

