-- name: CreateNewLeadGeneralRequest :one
INSERT INTO lead_general_requests (
    ref_no,
    contact_id,
    lead_id,
    request_type,
    view_appointment_id,
    request_date,
    request_status
) VALUES (
    $1, $2, $3, $4, $5, $6, $7
) RETURNING *;

-- -- name: GetAllGeneralRequests :many
-- SELECT lgr.ref_no AS lead_general_request_ref_no,
--        c.name AS contact_name,
--        scd.mobile AS mobile,
--        scd.email AS email,
--        l.ref_no AS lead_ref_no,
--        lgr.request_status
-- FROM lead_general_requests lgr
-- JOIN leads l ON lgr.lead_id = l.id
-- JOIN contacts c ON lgr.contact_id = c.id
-- JOIN shareable_contact_details scd ON c.id = scd.contacts_id
-- WHERE lgr.request_type = $1
-- ORDER BY lgr.id
-- LIMIT $2
-- OFFSET $3;

-- name: GetCountAllGeneralRequests :one
SELECT count(*)
FROM lead_general_requests lgr JOIN leads l ON lgr.lead_id = l.id
JOIN contacts c ON lgr.contact_id = c.id WHERE request_type = $1;