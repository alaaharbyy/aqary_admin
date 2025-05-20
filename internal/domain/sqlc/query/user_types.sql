
-- name: CreateUserType :one
INSERT INTO user_types (
    user_type,
    user_type_ar
)VALUES (
    $1,$2
) RETURNING *;

-- name: GetUserType :one
SELECT * FROM user_types 
WHERE id = $1;


-- name: GetAllUserType :many
SELECT * FROM user_types
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: GetAllUserTypeWithoutPagination :many
SELECT * FROM user_types
ORDER BY id;

-- name: UpdateUserType :one
UPDATE user_types
SET 
    user_type = $2,
    user_type_ar = $3
Where id = $1
RETURNING *;

-- name: DeleteUserType :exec
DELETE FROM user_types
Where id = $1;



-- name: GetAddCompanyPermission :one
SELECT * FROM permissions
WHERE title % 'add company';

-- name: GetCompanySectionPermission :one
SELECT * FROM section_permission
Where title % 'companies' LIMIT 1;