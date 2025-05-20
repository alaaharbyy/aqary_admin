-- name: CreateActivityDetails :one
INSERT INTO contacts_activity_details (
    contacts_activity_header_id,
    contacts_activity_type,
    interval,
    interval_type
) VALUES (
    $1, $2, $3, $4
) RETURNING *;

-- name: GetSingleActivityDetail :one
SELECT * FROM contacts_activity_details WHERE id = $1;

-- name: GetAllActivityDetailsByContactActivityHeaderId :many
SELECT * FROM contacts_activity_details cad JOIN contacts_activity_header cah on cad.contacts_activity_header_id = cah.id WHERE cad.contacts_activity_header_id = $1 AND cah.status != 6 LIMIT $2 OFFSET $3;