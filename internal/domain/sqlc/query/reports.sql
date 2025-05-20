-- name: CreateReport :one
INSERT INTO reports (
    entity_id, entity_type_id, category, message, status, created_by, created_at, updated_at
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
)
RETURNING *;

-- name: GetReport :one
SELECT * FROM reports
WHERE id = $1;

-- name: ListReports :many
SELECT * FROM reports
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;

-- -- name: UpdateReport :one
-- UPDATE reports
-- SET 
--     entity_id = $2,
--     entity_type_id = $3,
--     category = $4,
--     message = $5,
--     status = $6,
--     updated_at = $7
-- WHERE id = $1
-- RETURNING *;

-- name: DeleteReport :exec
DELETE FROM reports
WHERE id = $1;
