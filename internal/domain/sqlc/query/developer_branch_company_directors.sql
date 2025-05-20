
-- name: CreateDeveloperBranchCompanyDirector :one
INSERT INTO developer_branch_company_directors (
    profile_image,
    name,
    description,
    director_designations_id,
    developer_company_branches,
    created_at,
    updated_at,
    ref_no
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- name: GetDeveloperBranchCompanyDirector :one
SELECT * FROM developer_branch_company_directors 
WHERE id = $1 LIMIT $1;


-- name: GetDeveloperBranchCompanyDirectorByCompanyId :many
SELECT * FROM developer_branch_company_directors 
WHERE developer_company_branches = $2 LIMIT $1;


-- name: GetDeveloperBranchCompanyDirectorByCompanyIdWithoutPagination :many
SELECT * FROM developer_branch_company_directors 
WHERE developer_company_branches = $1;

-- name: GetAllDeveloperBranchCompanyDirector :many
SELECT * FROM developer_branch_company_directors
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateDeveloperBranchCompanyDirector :one
UPDATE developer_branch_company_directors
SET   profile_image = $2,
    name = $3,
    description = $4,
    director_designations_id = $5,
    developer_company_branches = $6,
    created_at = $7,
    updated_at = $8,
    ref_no = $9
Where id = $1
RETURNING *;

-- 
-- name: DeleteDeveloperBranchCompanyDirector :exec
DELETE FROM developer_branch_company_directors
Where id = $1;