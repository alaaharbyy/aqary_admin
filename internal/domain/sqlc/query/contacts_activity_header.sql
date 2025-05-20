-- name: CreateContactActivityHeader :one
INSERT INTO contacts_activity_header (
    title,
    created_by,
    assigned_to,
    contacts_activity_type,
    reference_no,
    moving_date,
    phone_number,
    email,
    subject,
    comments,
    created_at,
    updated_at,
    status,
    contacts_id
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14
)
RETURNING *;

-- name: UpdateSingleContactActivityHeaderContactID :one
UPDATE contacts_activity_header SET contacts_id = $1 WHERE id = $2 RETURNING *;

-- name: UpdateMultipleContactActivityHeaderConactID :one
UPDATE contacts_activity_header SET contacts_id = $1 WHERE id = ANY($2::bigint[]) RETURNING *;

-- name: UpdateContactActivityHeader :one
UPDATE contacts_activity_header
SET
    title = $2,
    created_by = $3,
    assigned_to = $4,
    contacts_activity_type = $5,
    reference_no = $6,
    moving_date = $7,
    phone_number = $8,
    email = $9,
    subject = $10,
    comments = $11,
    updated_at = $12,
    status = $13
WHERE
    contacts_id = $1 RETURNING *;

-- name: GetAllContactActivityHeaderByContactIdWithoutPagination :one
SELECT * FROM contacts_activity_header WHERE contacts_id = $1;

-- name: GetSingleActivityHeader :one
SELECT * FROM contacts_activity_header WHERE id = $1;

-- name: GetAllContactActivityHeaderByContactId :many
select cah.*, l.* from contacts_activity_header cah 
left join leads l on l.ref_no = cah.reference_no where cah.contacts_id = $1 ORDER BY cah.id LIMIT $2 OFFSET $3;

-- name: GetCountAllContactActivityHeaderByContactId :one
select count(*) from contacts_activity_header where contacts_id = $1;