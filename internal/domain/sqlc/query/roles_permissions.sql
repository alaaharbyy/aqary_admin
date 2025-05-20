-- name: CreateRolePermission :one
INSERT INTO roles_permissions (
    roles_id,
    permissions_id,
    sub_section_permission,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3, $4, $5
) RETURNING *;

-- name: GetRolePermission :one
SELECT * FROM roles_permissions 
WHERE id = $1;

-- name: GetRolePermissionByRole :one
SELECT * FROM roles_permissions 
WHERE roles_id = $1;


-- -- name: GetAllRolePermissionByRole :many
-- SELECT rp.id, rp.roles_id,
--        CASE 
--            WHEN u.user_types_id = 6 THEN rp.permissions_id 
--            ELSE u.permissions_id 
--        END as permissions_id
-- FROM roles_permissions rp
-- CROSS JOIN LATERAL (
--     SELECT users.id, users.permissions_id, users.user_types_id
--     FROM users
--     WHERE users.id = $2
-- ) u
-- WHERE rp.roles_id = $1;



-- name: GetAllRolePermission :many
SELECT * FROM roles_permissions
INNER JOIN roles ON roles_permissions.roles_id = roles.id
WHERE  
      ( @search = '%%'
        OR roles."role" ILIKE @search
       )
ORDER BY roles_permissions.updated_at DESC
LIMIT $1
OFFSET $2;

-- name: GetAllRolePermissionWithoutPagination :many
SELECT * FROM roles_permissions
ORDER BY id;

-- name: GetCountAllRolePermission :one
SELECT COUNT(roles_permissions.id) FROM roles_permissions
INNER JOIN roles ON roles_permissions.roles_id = roles.id
WHERE  
      ( @search = '%%'
        OR roles."role" ILIKE @search
       );
-- SELECT COUNT(*) FROM roles_permissions;


-- name: GetRolePermissionRoles :many
SELECT id, roles_id FROM roles_permissions
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: GetCountRolePermissionRoles :one
SELECT COUNT(*) FROM roles_permissions
LIMIT $1
OFFSET $2;

-- name: GetAllRolePermissionRolesWithoutPagination :many
SELECT id, roles_id FROM roles_permissions
ORDER BY id;

-- name: UpdateRolePermission :one
UPDATE roles_permissions
 SET 
 permissions_id = $2,
 sub_section_permission = $3,
 updated_at = $4  
 Where roles_id = $1
RETURNING *;

-- name: DeleteRolePermission :exec
DELETE FROM roles_permissions
Where roles_id = $1;

-- name: DeleteOnePermissionInRole :one
UPDATE roles_permissions
SET permissions_id = array_remove(permissions_id, $2::bigint)
WHERE id = $1
RETURNING *;