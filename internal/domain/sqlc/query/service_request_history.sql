-- name: CreateServiceRequestHistory :one
INSERT INTO service_request_history
(service_request_id, history_date, reason,status,updated_by) 
VALUES ($1,$2,$3,$4,$5)
RETURNING *;