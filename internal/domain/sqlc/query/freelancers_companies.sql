-- name: CreateFreelancerCompanies :one
INSERT INTO freelancers_companies (
    company_name,
    commercial_license_no,
    commercial_license_file,
    commercial_license_issue_date,
    commercial_license_expiry_date,
    status,
    created_at,
    updated_at
)VALUES (
    $1 ,$2, $3, $4, $5,$6,$7,$8
) RETURNING *;


-- name: GetFreelancerCompaniess :one
SELECT * FROM freelancers_companies 
WHERE id = $1 LIMIT $1;

 
-- name: GetAllFreelancerCompanies :many
SELECT * FROM freelancers_companies
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateFreelancerCompanies :one
UPDATE freelancers_companies
SET   
    company_name = $2,
    commercial_license_no = $3,
    commercial_license_file = $4,
    commercial_license_issue_date = $5,
    commercial_license_expiry_date = $6,
    status = $7,
    created_at = $8,
    updated_at = $9
Where id = $1
RETURNING *;


-- name: DeleteFreelancerCompanies :exec
DELETE FROM freelancers_companies
Where id = $1;

