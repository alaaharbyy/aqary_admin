-- name: CreateConnectionsSettings :one
INSERT INTO connections_settings (
    user_id,
    connection_request,
    follow_me,
    post_and_comments,
    gallery,
    public_profile_info,
    messaging,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9
) RETURNING *;

-- name: GetConnectionsSettings :one
SELECT * FROM connections_settings 
WHERE id = $1 LIMIT $1;

-- name: GetAllConnectionsSettings :many
SELECT * FROM connections_settings
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateConnectionsSettings :one
UPDATE connections_settings
SET user_id = $2,
    connection_request = $3,
    follow_me = $4,
    post_and_comments = $5,
    gallery = $6,
    public_profile_info = $7,
    messaging = $8,
    created_at = $9,
    updated_at = $10
Where id = $1
RETURNING *;

-- name: DeleteConnectionsSettings :exec
DELETE FROM connections_settings
Where id = $1;

-- name: GetConnectionsSettingsByUserId :one
SELECT * FROM connections_settings 
WHERE user_id = $1 LIMIT $1;

-- name: UpdateConnectionsSettingsByUserID :one
UPDATE connections_settings
SET connection_request = $2,
    follow_me = $3,
    post_and_comments = $4,
    gallery = $5,
    public_profile_info = $6,
    messaging = $7,
    created_at = $8,
    updated_at = $9
Where user_id = $1
RETURNING *;