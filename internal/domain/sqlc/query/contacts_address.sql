-- name: GetContactAddressByID :one
SELECT * FROM contacts_address WHERE id = $1 LIMIT 1;

-- name: GetContactAddressByContactID :one
SELECT * FROM contacts_address WHERE contacts_id = $1 LIMIT 1;

-- name: GetContactAddressByAddressType :one
SELECT * FROM contacts_address
WHERE contacts_id = $1 AND address_type_id = $2 LIMIT 1;