-- name: CreateSectionPermission :one
INSERT INTO section_permission (
    title,
    sub_title, 
    created_at,
    updated_at
)VALUES (
    $1,$2, $3, $4
) RETURNING *;

-- name: GetSectionPermission :one
SELECT * FROM section_permission 
WHERE id = $1;


-- name: GetSectionPermissionByTitle :one
SELECT * FROM section_permission 
WHERE LOWER(title) = LOWER(@title);


-- name: GetAllSectionPermission :many
SELECT * FROM section_permission
WHERE       
      (@search = '%%'
       OR section_permission.title ILIKE @search
       )
ORDER BY section_permission.updated_at DESC
LIMIT $1
OFFSET $2;


-- name: GetCountAllSectionPermission :one
SELECT COUNT(section_permission.id) FROM section_permission
WHERE       
    ( @search = '%%'
       OR section_permission.title ILIKE @search
);
-- SELECT COUNT(*) FROM section_permission;


-- name: GetAllSectionPermissionWithoutPagination :many
SELECT * FROM section_permission
ORDER BY id;

-- name: GetAllSectionPermissionWithoutPaginationMV :many
SELECT * FROM section_permission_mv
Where (
   @search = '%%'
   OR title ILIKE  @search
)
ORDER BY id;
-- SELECT * FROM section_permission_mv
-- ORDER BY id;


-- name: GetAllSectionPermissionMV :many
SELECT * FROM section_permission_mv
WHERE (@search='%%' 
   OR section_permission_mv.title ILIKE @search
)
ORDER BY id LIMIT $1 OFFSET $2;


-- name: GetSectionPermissionMV :one
SELECT * FROM section_permission_mv
WHERE id =  $1;


-- name: GetCountAllSectionPermissionMV :one
SELECT COUNT(section_permission_mv.id) FROM section_permission_mv 
WHERE (@search='%%' 
   OR section_permission_mv.title ILIKE @search
);


-- name: UpdateSectionPermission :one
UPDATE section_permission
SET title = $2,
    sub_title = $3,  
    created_at= $4,
    updated_at = $5
Where id = $1
RETURNING *;


-- name: DeleteSectionPermission :exec
DELETE FROM section_permission
Where id = $1;

-- name: GetAllSections :many
SELECT s.id, s.title
FROM section_permission s
WHERE 
COALESCE(@search, '') = '' 
OR s.title ILIKE @search;