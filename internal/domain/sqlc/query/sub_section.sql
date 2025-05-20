 
-- name: CreateSubSection :one
INSERT INTO sub_section (
  sub_section_name,
  sub_section_name_constant,   
  permissions_id,  
  indicator,  
  sub_section_button_id,  
  sub_section_button_action,  
  created_at
) VALUES
 ($1, $2, $3, $4, $5, $6, $7)
 RETURNING *;

-- name: GetSubSection :one
SELECT * FROM sub_section 
WHERE id = $1 LIMIT 1;

-- name: GetAllSubSection :many
SELECT * FROM sub_section;
 
-- name: GetAllSubSectionByPermissionID :many
SELECT * FROM sub_section 
Where permissions_id = $1 AND sub_section_button_id = $1;

-- name: GetAllSubSectionByPermissionIDMV :many
SELECT * FROM sub_section_mv 
Where permissions_id = $1 AND sub_section_button_id = $1;

-- name: GetAllSubSectionByPermissionIDMVWithRelation :many
SELECT * FROM sub_section_mv 
Where
  CASE WHEN @is_super_user::bigint=0 THEN true ELSE id = ANY(@sub_sections_id::bigint[]) END -- it will filtered on the basis of the other then super user
 AND permissions_id = @permissions_id::bigint AND sub_section_button_id = @permissions_id::bigint;




-- name: GetListSubSection :many
SELECT * FROM sub_section
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateSubSection :one
UPDATE sub_section
SET sub_section_name = $2,
  sub_section_name_constant = $3,   
  permissions_id = $4,  
  indicator = $5, 
  sub_section_button_id = $6,  
  sub_section_button_action = $7,  
  updated_at = $8
Where id = $1
RETURNING *;


-- name: DeleteSubSection :exec
DELETE FROM sub_section
Where id =$1;


-- name: GetAllSubSectionPermissionBySubSectionButtonID :many
SELECT * FROM sub_section
WHERE sub_section_button_id = $1;


-- name: GetAllSubSectionPermissionBySubSectionButtonIDMV :many
SELECT * FROM sub_section_mv
WHERE
 CASE WHEN @is_super_user::bigint=0 THEN true ELSE id = ANY(@sub_section_id::bigint[]) END
AND sub_section_button_id = @sub_section_button_id::bigint;
-- SELECT * FROM sub_section_mv
-- WHERE sub_section_button_id = $1;


-- name: GetAllIDANDPermissionsFromSubSectionPermission :many
SELECT id, permissions_id FROM sub_section
ORDER BY permissions_id LIMIT $1 OFFSET $2;

-- name: GetAllIDANDPermissionsFromSubSectionPermissionWithoutPagination :many
SELECT id, permissions_id FROM sub_section
ORDER BY permissions_id;
 
-- name: CountAllSubSection :one
SELECT COUNT(id) FROM sub_section;

-- name: FetchbuttonPermissionForSubSectionsForUser :many
SELECT DISTINCT ON (ss.sub_section_name) ss.*
FROM sub_section ss
JOIN (
    SELECT UNNEST(sub_sections_id) as sub_section_id
    FROM user_company_permissions
    WHERE user_company_permissions.user_id = @user_id
) u ON ss.id = u.sub_section_id
JOIN permissions p ON ss.permissions_id = p.id
WHERE
  ( p.title % @section_button_name AND ss.sub_section_button_id = p.id )
   OR
   ss.sub_section_button_id = (
      SELECT id
      FROM sub_section  
      WHERE sub_section.sub_section_name ILIKE @section_button_name AND ss.sub_section_button_id = sub_section.id
);

-- SELECT
--     ss.id,
--     ss.sub_section_name,
--     ss.sub_section_name_constant,
--     ss.permissions_id,
--     ss.indicator,
--     ss.sub_section_button_id,
--     ss.sub_section_button_action,
--     ss.created_at,
--     ss.updated_at
-- FROM
--     sub_section ss
-- JOIN (
--     SELECT UNNEST(sub_section_permission) as sub_section_permission
--     FROM users
--     WHERE users.id = $1
-- ) u ON ss.id = u.sub_section_permission
-- JOIN permissions p ON ss.permissions_id = p.id
-- WHERE
--     p.title ILIKE $2
--     AND (
--         ss.sub_section_button_id IS NOT NULL
--         AND ss.sub_section_button_id = COALESCE(
--             (
--                 SELECT id
--                 FROM sub_section
--                 WHERE sub_section.sub_section_name ILIKE $2
--             ),
--             ss.sub_section_button_id
--         )
--     );


-- name: GetAllRelatedIDFromSubSection :many
WITH RECURSIVE related_sub_sections AS (
    SELECT id, sub_section_button_id
    FROM sub_section
    WHERE sub_section.sub_section_button_id = $1
    UNION ALL
    SELECT s.id, s.sub_section_button_id
    FROM sub_section s
    INNER JOIN related_sub_sections r ON s.sub_section_button_id = r.id
)
SELECT id FROM related_sub_sections;


-- name: DeleteAllSubSection :exec
DELETE FROM sub_section
WHERE id = ANY($1::bigint[]);



 