-- name: CreatePermission :one
INSERT INTO permissions (
    title,
    sub_title,
    section_permission_id,
    created_at,
    updated_at
)VALUES (
    $1,$2, $3, $4, $5
) RETURNING *;

-- name: GetPermission :one
SELECT * FROM permissions 
WHERE id = $1;

-- name: GetPermissionByTitle :one
SELECT * FROM permissions 
WHERE LOWER(title) = LOWER(@title);

-- name: GetPermissionBySubTitle :one
SELECT * FROM permissions 
WHERE LOWER(sub_title) = LOWER(@sub_title);


-- name: GetPermissionBySectionID :many
SELECT id FROM permissions WHERE permissions.section_permission_id = $1;

-- name: GetAllPermission :many
SELECT * FROM permissions
ORDER BY id
LIMIT $1
OFFSET $2;


-- name: GetAllPermissionSectionIds :many
SELECT id, section_permission_id FROM permissions ORDER by section_permission_id  LIMIT $1 OFFSET $2;


-- name: GetCountAllPermissionSectionIds :one
SELECT COUNT(*) FROM permissions;


-- name: GetAllPermissions :many
SELECT * FROM permissions ORDER by section_permission_id;

-- name: GetAllSubSectionPermissions :many
SELECT * FROM sub_section ORDER BY permissions_id;

-- SELECT p.* FROM permissions p
-- LEFT JOIN LATERAL (
--     SELECT UNNEST(permissions_id) as permission_id
--     FROM users
--     WHERE users.id = $1
-- ) u ON p.id = u.permission_id
-- WHERE ($1 != 6 AND u.permission_id IS NOT NULL) OR $1 = 6;


-- name: GetAllForSuperUserPermissionBySectionPermissionId :many
SELECT * FROM permissions
Where section_permission_id = $1 ORDER BY id;

-- name: GetAllForSuperUserPermissionBySectionPermissionIdMV :many
SELECT * FROM permissions_mv
Where 
    CASE WHEN @isSuperUserId::bigint = 0 THEN true ELSE id = ANY(@permission::bigint[]) END -- by zero it will be super user 
AND 
section_permission_id = @section_permission_id::bigint ORDER BY id;
-- SELECT * FROM permissions_mv
-- Where section_permission_id = $1 ORDER BY id;


-- name: GetPermissionMV :one
SELECT * FROM permissions_mv
Where id = $1;


-- name: GetAllPermissionBySectionPermissionId :many
SELECT * FROM permissions
WHERE permissions.section_permission_id = $1;
-- LEFT JOIN LATERAL (
--     SELECT UNNEST(permissions_id) as permission_id
--     FROM users
--     WHERE users.id = $1
-- ) u ON p.id = u.permission_id;


-- name: GetPermissionByIdAndSectionPermissionId :one
SELECT * FROM permissions
Where id = $1 AND section_permission_id = $2 ORDER BY id;


-- name: UpdatePermission :one
UPDATE permissions
SET title = $2,
    sub_title = $3,
    section_permission_id = $4,
    created_at = $5,
    updated_at = $6
Where id = $1
RETURNING *;


-- name: DeletePermission :exec
DELETE FROM permissions
Where id = $1;


 
-- name: CreateUserPermission :one
INSERT INTO user_company_permissions (
    user_id,
    company_id,
    permissions_id,
    sub_sections_id
)VALUES (
    $1,$2,$3, $4
) RETURNING *;



-- name: CreateUserPermissionTest :one
INSERT INTO user_company_permissions_test (
    user_id,
    company_id,
    permission_id,
    sub_section_id
)VALUES (
    $1, $2, $3, $4
) RETURNING *;


-- name: GetUserPermissionsByID :one
SELECT * FROM user_company_permissions 
WHERE 
(
    -- this mean it's a company user or not  
    CASE when @is_company_user != 0 then company_id = @company_id else true END
)
AND   user_id = @user_id;



-- name: GetAllSectionPermissionFromPermissionIDs :many 
SELECT DISTINCT sp.* 
FROM 
    section_permission_mv sp
LEFT JOIN 
    permissions p ON p.section_permission_id = sp.id
LEFT JOIN 
    sub_section ss ON ss.permissions_id = p.id
Where 
  CASE WHEN @is_super_user=0 THEN true ELSE p.id = ANY(@permission_id::bigint[]) END
ORDER BY 
    sp.id;


-- TODO: remove after checking ........
-- name: GetUserPermissionsTestByID :many
SELECT permission_id::bigint FROM user_company_permissions_test
WHERE 
(
    -- this mean it's a company user or not  
    CASE when @is_company_user != 0 then company_id = @company_id else true END
)
AND   user_id = @user_id;

-- name: GetUserSubSectionPermissionsTestByID :many
SELECT sub_section_id::bigint FROM user_company_permissions_test
WHERE 
(
    -- this mean it's a company user or not  
    CASE when @is_company_user != 0 then company_id = @company_id else true END
)
AND   user_id = @user_id;


-- name: GetAllPermissionFromUserByID :many 
SELECT permission_id FROM user_company_permissions_test
WHERE 
(
--     this mean it's a company user or not  
    CASE when @is_company_user != 0 then company_id = @company_id else true END
)
AND   user_id = @user_id;



-- name: UpdateUserPermissionsByID :one
Update user_company_permissions
SET permissions_id = @permission_id,
    sub_sections_id =  @sub_section_id
WHERE 
(
  -- this mean it's a company user or not
  CASE when @is_company != 0 then company_id = @company_id else true END
)
AND  user_id = @user_id
RETURNING *;




-- name: GetUserCompanyPermissionsByID :one
SELECT permissions_id::bigint[] FROM user_company_permissions 
WHERE 
(
    -- this mean it's a company user or not  
    CASE when @is_company_user != 0 then company_id = @company_id else true END
)
AND   user_id = @user_id;

-- name: GetUserCompanySubSectionPermissionsByID :one
SELECT sub_sections_id::bigint[] FROM user_company_permissions
WHERE 
(
    -- this mean it's a company user or not  
    CASE when @is_company_user != 0 then company_id = @company_id else true END
)
AND   user_id = @user_id;