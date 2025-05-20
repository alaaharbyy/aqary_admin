-- name: CreateSession :one
INSERT INTO sessions (
   users_id,
   refresh_token,
   is_blocked,
   expired_at,
   created_at,
   updated_at
)VALUES (
    $1, $2, $3,$4, $5, $6
) RETURNING *;

 
-- name: GetSession :one
SELECT * FROM sessions 
WHERE id = $1 LIMIT $1;
 

-- name: GetAllSession :many
SELECT * FROM sessions
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateSession :one
UPDATE sessions
SET   users_id = $2,
   refresh_token = $3,
   is_blocked = $4,
   expired_at = $5,
   created_at = $6,
   updated_at = $7
Where id = $1
RETURNING *;

-- name: DeleteSession :exec
DELETE FROM sessions
Where id = $1;
 