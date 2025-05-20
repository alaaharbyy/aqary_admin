-- name: CreateDepartment :one
INSERT INTO department (
    department,
    department_ar,
    created_at,
    status,
    company_id,
    updated_at
)VALUES (
    $1, $2, $3, $4, $5, $6
) RETURNING *;

-- name: GetDepartment :one
SELECT * FROM department 
 WHERE 
    CASE WHEN  @company_id = 0 THEN true ELSE department.company_id = @company_id END
  AND 
department.id = @department_id;



-- name: GetDepartmentByDepartment :one
SELECT * FROM department 
WHERE  
 CASE WHEN  @company_id = 0 THEN true ELSE department.company_id = @company_id END
 AND LOWER(department.department) = LOWER(@department) LIMIT 1;


-- name: GetAllDepartment :many
SELECT * FROM department
WHERE 
 CASE 
 WHEN @company_id = 0 THEN department.company_id IS NULL
 ELSE department.company_id = @company_id END
 AND ( @search = '%%'
  OR department.department ILIKE @search
  OR department.department_ar ILIKE @search
 )
ORDER BY updated_at DESC
LIMIT $1
OFFSET $2;


-- name: GetAllDepartmentWithoutPagination :many
SELECT * FROM department
ORDER BY id;

-- name: GetCountAllDepartment :one
SELECT COUNT(department.id) FROM department
WHERE 
CASE WHEN @company_id = 0 THEN department.company_id IS NULL
 ELSE department.company_id = @company_id END
AND
 ( @search = '%%'
  OR department.department ILIKE @search
  OR department.department_ar ILIKE @search
 );
-- SELECT COUNT(*) FROM department;


-- name: UpdateDepartment :one
UPDATE department
SET department = $2,
    department_ar = $3,
    updated_at = $4
Where 
 CASE WHEN @company_id = 0 THEN true ELSE department.company_id = @company_id END
 AND
 id = $1 
RETURNING *;



-- name: DeleteDepartment :exec
DELETE FROM department
Where 
 CASE WHEN @company_id = 0 THEN true ELSE department.company_id = @company_id END
AND id = $1;