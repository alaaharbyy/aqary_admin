-- name: UpdateMultipleContactsTransactionID :one
UPDATE contacts_transaction SET contacts_id= $1 WHERE id = ANY($2::bigint[]) RETURNING *;

-- name: UpdateSingleContactsTransactionID :one
UPDATE contacts_transaction SET contacts_id= $1 WHERE id = $2 RETURNING *;

-- name: GetSingleTransaction :one
SELECT * FROM contacts_transaction WHERE id = $1 LIMIT 1;

-- name: GetAllContactTransaction :many
SELECT ct.*, l.ref_no, l.lead_type FROM contacts_transaction ct JOIN leads l ON l.id = ct.leads_id WHERE ct.contacts_id = $1 ORDER BY ct.id DESC LIMIT $2 OFFSET $3;


-- name: GetCountAllContactTransaction :one
SELECT count(*) FROM contacts_transaction WHERE contacts_id = $1 ;