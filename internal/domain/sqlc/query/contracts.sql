-- name: CreateContracts :one
INSERT INTO contracts(
    company_type,
    company_id,
    is_branch,
    file_url,
    created_at,
    updated_at,
    status
)VALUES(
    $1, $2, $3, $4, $5, $6, $7
)RETURNING *;

-- name: GetAllContracts :many
SELECT COUNT(contracts.*) OVER() AS total_count, 
contracts.*,
COALESCE(
    CASE 
        WHEN contracts.company_type = 1 AND contracts.is_branch = FALSE THEN broker_companies.company_name
        WHEN contracts.company_type = 1 AND contracts.is_branch = TRUE THEN broker_companies_branches.company_name
        WHEN contracts.company_type = 2 AND contracts.is_branch = FALSE THEN developer_companies.company_name
        WHEN contracts.company_type = 2 AND contracts.is_branch = TRUE THEN developer_company_branches.company_name
        WHEN contracts.company_type = 3 AND contracts.is_branch = FALSE THEN services_companies.company_name
        WHEN contracts.company_type = 3 AND contracts.is_branch = TRUE THEN service_company_branches.company_name
    END, '')::VARCHAR AS company_name
FROM contracts 
LEFT JOIN broker_companies ON broker_companies.id = contracts.company_id AND contracts.company_type = 1 AND contracts.is_branch = FALSE
LEFT JOIN broker_companies_branches ON broker_companies_branches.id = contracts.company_id AND contracts.company_type = 1 AND contracts.is_branch = TRUE
LEFT JOIN developer_companies ON developer_companies.id = contracts.company_id AND contracts.company_type = 2 AND contracts.is_branch = FALSE
LEFT JOIN developer_company_branches ON developer_company_branches.id = contracts.company_id AND contracts.company_type = 2 AND contracts.is_branch = TRUE
LEFT JOIN services_companies ON services_companies.id = contracts.company_id AND contracts.company_type = 3 AND contracts.is_branch = FALSE
LEFT JOIN service_company_branches ON service_company_branches.id = contracts.company_id AND contracts.company_type = 3 AND contracts.is_branch = TRUE
WHERE contracts.status NOT IN (5, 6)
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;

-- name: GetContractsByCompany :one
SELECT * FROM contracts WHERE company_type = $1 AND company_id = $2 AND is_branch = $3;