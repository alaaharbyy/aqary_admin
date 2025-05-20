-- name: CreateRanks :one
INSERT INTO ranks (
    rank,
    price,
    status,
    created_at,
    updated_at   
)VALUES (
    $1, $2, $3 ,$4, $5
) RETURNING *;

-- name: GetRanks :one
SELECT * FROM ranks 
WHERE id = $1 LIMIT $1;

-- name: GetRanksByRank :one
SELECT * FROM ranks 
WHERE rank = $1 LIMIT 1;

-- name: GetAllRanks :many
SELECT * FROM ranks
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateRanks :one
UPDATE ranks
SET   rank = $2,
    price = $3,
    status = $4,
    created_at = $5,
    updated_at = $6 
Where id = $1
RETURNING *;


-- name: DeleteRanks :exec
DELETE FROM ranks
Where id = $1;