-- name: CreateRole :one
INSERT INTO roles (
    role,
    department_id,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3, $4
) RETURNING *;



-- name: GetRole :one
SELECT * FROM roles 
WHERE id = $1;
 
-- name: GetRoleByDepartment :one
SELECT * FROM roles 
WHERE id = $1 AND department_id = $2;
 
-- name: GetRoleByRole :one
SELECT * FROM roles 
WHERE LOWER(role) = LOWER(@role) AND department_id = @department_id;

-- name: GetAllRole :many
SELECT * FROM roles
WHERE 
( @search='%%'
  OR roles."role" ILIKE  @search)
AND department_id = @department_id
ORDER BY updated_at DESC 
LIMIT $1
OFFSET $2;

-- name: GetAllRoleWithoutPagination :many
SELECT * FROM roles
WHERE LOWER(role) !=  'super admin'
ORDER BY id;


-- name: GetCountAllRoles :one
SELECT COUNT(*) FROM roles
WHERE department_id = @department_id;


-- name: UpdateRole :one
UPDATE roles
SET role = $3,
  updated_at = $4
Where id = $1 AND department_id = $2
RETURNING *;

-- name: DeleteRole :exec
DELETE FROM roles
Where id = $1 AND department_id = $2;


-- name: GetAllRoleWithRolePermissionChecked :many
SELECT 
    r.role, r.id,
    CASE 
        WHEN rp.roles_id IS NOT NULL THEN true
        ELSE false
    END as IsAvailableInRolesPermissions
FROM 
    roles r
LEFT JOIN 
    roles_permissions rp ON r.id = rp.roles_id
   
WHERE r."role" NOT ILIKE '%super admin%' ORDER BY role ASC;


-- name: GetRoleByUserId :one
SELECT roles.* FROM users
INNER JOIN roles ON roles.id = users.roles_id WHERE users.id = $1;

