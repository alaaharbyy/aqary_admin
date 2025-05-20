
-- name: CreateDeveloperCompanyDirector :one
INSERT INTO developer_company_directors (
    profile_image ,
    name,
    description,
    director_designations_id,
    developer_companies_id,
    created_at,
    updated_at,
    ref_no
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7, $8
) RETURNING *;


-- name: GetDeveloperCompanyDirector :one
SELECT * FROM developer_company_directors 
WHERE id = $1 LIMIT $1;


-- name: GetAllDeveloperCompanyDirectorByCompanyId :many
SELECT * FROM companies_leadership 
WHERE companies_id = $1; --LIMIT $1;

-- name: GetAllDeveloperCompanyDirectorByCompanyIdWithoutPagination :many
SELECT * FROM developer_company_directors 
WHERE developer_companies_id = $1;

-- name: GetAllDeveloperCompanyDirector :many
SELECT * FROM developer_company_directors
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateDeveloperCompanyDirector :one
UPDATE developer_company_directors
SET   profile_image = $2,
    name = $3,
    description = $4,
    director_designations_id = $5,
    developer_companies_id = $6,
    created_at = $7,
    updated_at = $8,
    ref_no = $9
Where id = $1
RETURNING *;


-- name: DeleteDeveloperCompanyDirector :exec
DELETE FROM developer_company_directors
Where id = $1;

