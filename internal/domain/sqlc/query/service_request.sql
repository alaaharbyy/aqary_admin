-- name: CreateServiceRequest :one
INSERT INTO service_request (
    ref_no,
    company_types_id,
    is_branch,
    companies_id,
    request_date,
    services_id,
    requested_by,
    status
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- name: GetServiceRequestByID :one
SELECT * FROM service_request 
WHERE id = $1 LIMIT 1;

-- -- name: GetServiceRequestDetailsByID :one
-- SELECT
--     sr.id,
--     sr.ref_no,
--     sr.company_types_id,
--     sr.is_branch,
--     sr.companies_id,
--     sr.request_date,
--     sr.services_id,
--     sr.requested_by,
--     sr.status,
--     p.id AS profile_id,
--     p.first_name,
--     p.last_name,
--     p.phone_number,
--     p.company_number,
--     s.title AS service_title,
--     ms.title AS main_service_title,
--     srh.reason,
--     srh.id as service_request_id
-- FROM
--     service_request AS sr
-- INNER JOIN
--     users AS u ON sr.requested_by = u.id
-- INNER JOIN
--     profiles AS p ON u.profiles_id = p.id
-- INNER JOIN
--     services AS s ON sr.services_id = s.id
-- INNER JOIN 
--     main_services AS ms ON s.main_services_id=ms.id
-- INNER JOIN
--     service_request_history AS srh ON srh.service_request_id = sr.id
-- WHERE
--     sr.id=$1
--     AND sr.status= srh.status
--     AND sr.status != 6
--     AND s.status != 6
--     AND s.status != 5
--     AND srh.status!=6;

-- name: GetServiceRequestsByStatus :many
SELECT * FROM service_request 
WHERE status = $1;

-- -- name: GetAllServiceRequests :many
-- SELECT
--     sr.id,
--     sr.ref_no,
--     sr.company_types_id,
--     sr.is_branch,
--     sr.companies_id,
--     sr.request_date,
--     sr.services_id,
--     sr.requested_by,
--     sr.status,
--     p.id AS profile_id,
--     p.first_name,
--     p.last_name,
--     p.phone_number,
--     p.company_number,
--     s.title AS service_title,
--     ms.title AS main_service_title,
--     srh.reason
-- FROM
--     service_request AS sr
-- INNER JOIN
--     users AS u ON sr.requested_by = u.id
-- INNER JOIN
--     profiles AS p ON u.profiles_id = p.id
-- INNER JOIN
--     services AS s ON sr.services_id = s.id
-- INNER JOIN 
--     main_services AS ms ON s.main_services_id=ms.id
-- LEFT JOIN
--     service_request_history AS srh ON srh.service_request_id = sr.id AND sr.status=srh.status AND srh.status!=6
-- WHERE
--     sr.status != 6
--     AND s.status != 6
--     AND s.status != 5
-- OFFSET $1 LIMIT  $2;

-- name: GetCountServiceRequests :one
SELECT COUNT(*) FROM service_request WHERE status != 6;

-- name: UpdateServiceRequestStatus :one
UPDATE service_request
SET  
    status = $2
WHERE id = $1
RETURNING *;

-- name: DeleteServiceRequest :exec
DELETE FROM service_request
WHERE id = $1;