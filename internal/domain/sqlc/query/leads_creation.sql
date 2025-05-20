-- name: CreateLeadCreation :one
insert into leads_creation (
    leads_id,
    lead_details,
    reference_details,
    notification,
    documents,
    internal_notes,
    properties
) values ( $1, $2, $3, $4, $5, $6, $7) RETURNING *;
 
-- name: UpdateLeadCreation :one
UPDATE leads_creation SET
    lead_details = $2,
    reference_details = $3,
    notification = $4,
    documents = $5,
    internal_notes = $6,
    properties = $7 WHERE leads_id = $1 RETURNING *;

-- name: GetSingleLeadCreation :one
SELECT * FROM leads_creation where leads_id = $1 LIMIT 1;

-- name: UpdateLeadCreationProperties :one
UPDATE leads_creation SET properties = $2 WHERE leads_id = $1 RETURNING *;

-- name: UpdateLeadCreationDocument :one
UPDATE leads_creation SET documents = $2 WHERE leads_id = $1 RETURNING *;

-- name: UpdateLeadCreationNotification :one
UPDATE leads_creation SET notification = $2 WHERE leads_id = $1 RETURNING *;
 
-- name: UpdateLeadCreationInternalNotes :one
UPDATE leads_creation SET internal_notes = $2 WHERE leads_id = $1 RETURNING *;