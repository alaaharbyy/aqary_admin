-- name: UpdateMultipleContactsOtherContactConactID :one
UPDATE contacts_other_contact SET contacts_id = $1 WHERE id = ANY($2::bigint[]) RETURNING *;

-- name: CheckOtherContact :one
SELECT * FROM contacts_other_contact WHERE contacts_id = $1 AND other_contacts_id = $2 LIMIT 1;