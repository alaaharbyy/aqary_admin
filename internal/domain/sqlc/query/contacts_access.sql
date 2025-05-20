-- name: CreateContactNotes :one
INSERT INTO contacts_access (
    contacts_id,
    access_name,
    created_at,
    updated_at
) VALUES (
    $1, $2, $3, $4
) RETURNING *;

-- name: UpdateSingleContactNotesContactID :one
UPDATE contacts_access SET contacts_id = $1 WHERE id = $2 RETURNING *;
 
-- name: UpdateMultipleContactNotesConactID :one
UPDATE contacts_access SET contacts_id = $1 WHERE id = ANY($2::bigint[]) RETURNING *;

-- name: GetAllContactNotes :many
SELECT * FROM contacts_access WHERE contacts_id = $1 LIMIT $2 OFFSET $3;

-- name: GetAllContactNotesWithoutPagination :many
SELECT * FROM contacts_access WHERE contacts_id = $1;

-- name: GetCountAllContactNotes :one
SELECT COUNT(*) FROM contacts_access WHERE contacts_id = $1;
