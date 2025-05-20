-- name: CreateBrokerCompaniesBranchesServices :one
INSERT INTO broker_companies_branches_services (
    broker_companies_branches_id,
    services_id,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3, $4
) RETURNING *;
 
-- name: GetBrokerCompaniesBranchesServices :one
SELECT * FROM broker_companies_branches_services 
WHERE id = $1 LIMIT $1;

-- name: GetBrokerCompaniesBranchesServicesByServiceId :many
SELECT * FROM broker_companies_branches_services 
WHERE $3::bigint = ANY(services_id) LIMIT $1 OFFSET $2;

 
-- name: GetCountBrokerCompaniesBranchesServicesByServiceId :one
SELECT Count(*) FROM broker_companies_branches_services 
WHERE $1::bigint = ANY(services_id);


-- name: GetBrokerCompaniesBranchesServicesByBrokerCompanyBranchId :one
SELECT id, broker_companies_branches_id, services_id, created_at, updated_at FROM broker_companies_branches_services
WHERE broker_companies_branches_id = $1;




-- name: GetAllBrokerCompaniesBranchesServices :many
SELECT * FROM broker_companies_branches_services
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateBrokerCompaniesBranchesServices :one
UPDATE broker_companies_branches_services
SET  broker_companies_branches_id = $2,
    services_id = $3
Where id = $1
RETURNING *;


-- name: DeleteBrokerCompaniesBranchesServices :exec
DELETE FROM broker_companies_branches_services
Where id = $1;


-- -- name: GetAllMainServicesAndServicesByBrokerCompanyBranchId :many
-- SELECT 
-- 	main_services.id AS main_services_id,
-- 	main_services.title AS main_services,
-- 	services.id AS services_id,
-- 	services.title AS services 
-- FROM main_services
-- INNER JOIN services ON services.main_services_id = main_services.id AND (services.status != 5 AND services.status != 6)
-- INNER JOIN broker_companies_branches_services ON broker_companies_branches_services.services_id = services.id AND broker_companies_branches_services.broker_companies_branches_id = $1
-- WHERE main_services.status != 5 AND main_services.status != 6
-- ORDER BY main_services_id DESC, services_id DESC;

-- name: DeleteAllBrokerCompaniesBranchesServicesByCompanyId :exec
DELETE FROM broker_companies_branches_services 
WHERE broker_companies_branches_id = $1;