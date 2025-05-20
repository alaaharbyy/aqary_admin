-- name: CreateToggleCheck :one
INSERT INTO "toggles_check" (
    "entity_type",
    "entity_id",
    "status_type",
    "start_date",
    "end_date",
    "company_id",
    "doc",
    "created_at",
    "updated_at"
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, DEFAULT, DEFAULT
) RETURNING *;


-- name: GetToggleCheckByEntityIDAndEntityTypeID :one
SELECT * from toggles_check
WHERE entity_id = $1 AND entity_type = $2;


