-- name: CreateReservationRequest :one
INSERT INTO reservation_requests (
    name, email, phone, nic_document, payment_proof,
    entity_type, entity_id, status, created_by, ref_no
) VALUES (
    $1, $2, $3, $4, $5,
    $6, $7, $8, $9, $10
)
RETURNING *;

-- name: GetReservationRequestByID :one
SELECT * FROM reservation_requests
WHERE id = $1;

-- name: GetReservationRequestByEmail :one
SELECT * FROM reservation_requests
WHERE email = $1;

-- name: ListReservationRequests :many
SELECT
  *
FROM reservation_requests
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;


-- name: ListReservationRequestsByEntityIDAndEntityType :many
SELECT  
  *
FROM reservation_requests
WHERE
entity_type = $3 AND entity_id = $4
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;

-- name: ListCountReservationRequestsByEntityIDAndEntityType :one
SELECT count(*) FROM reservation_requests
WHERE
entity_type = $1 AND entity_id = $2;

-- name: ListCountReservationRequests :one
SELECT count(*) FROM reservation_requests;

-- name: UpdateReservationRequest :exec
UPDATE reservation_requests
SET
    name = $2,
    email = $3,
    phone = $4,
    nic_document = $5,
    payment_proof = $6,
    entity_type = $7,
    entity_id = $8,
    created_by = $9,
    updated_at = now()
WHERE id = $1;


-- name: UpdateReservationRequestsStatus :exec
UPDATE reservation_requests
SET status = $2, updated_at = now()
WHERE id = $1;

-- name: DeleteReservationRequest :exec
DELETE FROM reservation_requests
WHERE id = $1;
