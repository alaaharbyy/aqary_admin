-- name: CreatePublishInfo :one
INSERT INTO publish_info(
company_types_id,
companies_id,
is_branch,
is_project,
project_id,
is_property,
is_property_branch,
is_unit_branch,
unit_id,
owners_info,
unit_no,
price,
social_media_platfrom,
web_portals,
created_at,
created_by,
phase_id,
is_enabled,
property_id
) VALUES(
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19
)RETURNING *;

-- name: GetPublishInfoByProjectAndPhaseID :one
SELECT * FROM publish_info 
WHERE 
CASE
WHEN is_project = TRUE AND project_id = $1 AND phase_id IS NULL THEN TRUE
ELSE is_project = TRUE AND project_id = $1 AND phase_id = $2 END;

-- name: GetPublishInfoByProjectPropertyId :one
SELECT * FROM publish_info 
WHERE is_property = TRUE AND property_id = $1;

-- name: UpdatePublichInfoWebPortals :one
UPDATE publish_info SET web_portals = $2, is_enabled = $3 WHERE id =  $1 RETURNING *;

-- name: UpdatePublichInfoIsEnableCheck :one
UPDATE publish_info 
SET is_enabled = $2 
WHERE id = $1
RETURNING *;

-- name: DeletePublishInfoByProject :exec
DELETE FROM publish_info
WHERE 
CASE 
WHEN is_project = TRUE AND phase_id IS NULL AND project_id = $1
THEN TRUE
ELSE is_project = TRUE AND phase_id = $2 AND project_id = $1
END;