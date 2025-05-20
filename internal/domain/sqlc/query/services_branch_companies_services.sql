-- name: CreateServicesCompaniesBranchesServices :one
INSERT INTO services_branch_companies_services (
    service_company_branches_id,
    services_id,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3, $4
) RETURNING *;
 
-- name: GetServicesCompaniesBranchesServices :one
SELECT * FROM services_branch_companies_services 
WHERE id = $1 LIMIT $1;

-- name: GetServicesCompaniesBranchesServicesByServiceId :many
SELECT * FROM services_branch_companies_services 
WHERE $3::bigint = ANY(services_id) LIMIT $1 OFFSET $2;

-- name: GetCountServicesCompaniesBranchesServicesByServiceId :one
SELECT Count(*) FROM services_branch_companies_services 
WHERE $1::bigint = ANY(services_id);

-- name: GetServicesCompaniesBranchesServicesByServiceCompanyBranchId :one
SELECT * FROM services_branch_companies_services 
WHERE service_company_branches_id = $3 LIMIT $1 OFFSET $2;

-- name: GetAllServicesCompaniesBranchesServices :many
SELECT * FROM services_branch_companies_services
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateServicesCompaniesBranchesServices :one
UPDATE services_branch_companies_services
SET service_company_branches_id = $2,
    services_id = $3
Where id = $1
RETURNING *;

-- name: DeleteServicesCompaniesBranchesServices :exec
DELETE FROM services_branch_companies_services
Where id = $1;

-- -- name: GetAllMainServicesAndServicesByServicesCompanyBranchId :many
-- SELECT 
-- 	main_services.id AS main_services_id,
-- 	main_services.title AS main_services,
-- 	services.id AS services_id,
-- 	services.title AS services 
-- FROM main_services
-- INNER JOIN services ON services.main_services_id = main_services.id AND (services.status != 5 AND services.status != 6)
-- INNER JOIN services_branch_companies_services ON services_branch_companies_services.services_id = services.id AND services_branch_companies_services.service_company_branches_id = $1
-- WHERE main_services.status != 5 AND main_services.status != 6
-- ORDER BY main_services_id DESC, services_id DESC;

-- name: DeleteAllServicesCompaniesBranchesServicesByCompanyId :exec
DELETE FROM services_branch_companies_services
WHERE service_company_branches_id = $1;