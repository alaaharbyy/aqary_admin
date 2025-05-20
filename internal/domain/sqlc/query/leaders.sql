-- name: CreateLeaders :one
INSERT INTO leaders (
    name,
    position,
    description,
    image_url,
    is_branch,
    company_type,
    company_id,
    users_id,
    created_at,
    updated_at
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7, $8, $9, $10
) RETURNING *;

-- name: GetLeaders :one
SELECT * FROM leaders 
WHERE id = $1 LIMIT 1;

-- name: GetAllLeaders :many
SELECT * FROM leaders
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: GetAllLeadersWithoutPagination :many
SELECT * FROM leaders
ORDER BY id;

-- name: UpdateLeaders :one
UPDATE leaders
SET    name = $2,
    position = $3,
    description = $4,
    image_url = $5,
    is_branch = $6,
    company_type = $7,
    company_id = $8,
    users_id = $9,
    created_at = $10,
    updated_at = $11
Where id = $1
RETURNING *;


-- name: DeleteLeaders :exec
DELETE FROM leaders
Where id = $1;


-- name: GetAllLeadersByCompany :many
SELECT * FROM leaders WHERE company_id = $3 AND company_type = $4 AND is_branch = $5  ORDER BY id  LIMIT $1  OFFSET $2;



-- name: GetCountAllLeadersByCompany :one
SELECT COUNT(*) FROM leaders WHERE company_id = $1 AND company_type = $2 AND is_branch = $3;