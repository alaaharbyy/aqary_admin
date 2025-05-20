
-- name: CreatePropertiesMedia :one
INSERT INTO properties_media (
    file_urls,
    gallery_type,
    media_type,
    properties_id,
    property,
    created_at
)VALUES (
    $1, $2, $3,$4, $5, $6
) RETURNING *;

-- name: GetPropertiesMedia :one
SELECT * FROM properties_media 
WHERE id = $1 LIMIT 1;

-- name: GetProjectPropertiesMedia :one
SELECT properties_media.*,project_properties.property_name 
FROM properties_media 
INNER JOIN project_properties ON project_properties.id = properties_media.properties_id AND properties_media.property = 1
WHERE properties_media.id = $1 LIMIT 1;


-- -- name: GetAllProjectPropertyMediaByPropertyId :many
-- SELECT * FROM project_property_media 
-- WHERE project_properties_id = $2 LIMIT $1;

-- name: GetAllProjectPropertyMediaWithPagenation :many
SELECT *,COUNT(id) OVER() AS total_count FROM  properties_media 
WHERE properties_id = $3 AND property = 1
LIMIT $1 OFFSET $2;

-- name: GetAllProjectPropertyMediaWithoutPagenation :many
SELECT * FROM  properties_media 
WHERE properties_id = $1 AND property = 1;

-- -- name: GetCountAllProjectPropertyMediaByPropertyId :one
-- WITH x AS(
-- SELECT id,image_url AS url,1::bigint AS media_type,main_media_section,project_properties_id,projects_id FROM  project_property_media WHERE project_property_media.project_properties_id = $1 AND image_url IS NOT NULL
-- UNION ALL
-- SELECT id,image360_url AS url,2::bigint AS media_type,main_media_section,project_properties_id,projects_id FROM  project_property_media WHERE project_property_media.project_properties_id = $1 AND image360_url IS NOT NULL
-- UNION ALL
-- SELECT id,video_url AS url,3::bigint AS media_type,main_media_section,project_properties_id,projects_id FROM  project_property_media WHERE project_property_media.project_properties_id = $1 AND video_url IS NOT NULL
-- UNION ALL
-- SELECT id,panaroma_url AS url,4::bigint AS media_type,main_media_section,project_properties_id,projects_id FROM  project_property_media WHERE project_property_media.project_properties_id = $1 AND panaroma_url IS NOT NULL
-- ) SELECT COUNT(*) FROM x;


-- -- name: GetProjectPropertyMediaByProjectId :many
-- SELECT * FROM project_property_media 
-- WHERE projects_id = $1;

-- -- name: GetAllProjectPropertyMedia :many
-- SELECT * FROM project_property_media 
-- ORDER By id
-- LIMIT $1
-- OFFSET $2;


-- -- name: GetAllProjectPropertyMediaImages :many
-- SELECT image_url FROM project_property_media 
-- Where projects_id = $1
-- LIMIT $2
-- OFFSET $3;
 
 
-- -- name: UpdateProjectPropertyMedia :one
-- UPDATE project_property_media
-- SET    image_url = $2,
--     image360_url = $3,
--     video_url = $4,
--     panaroma_url = $5,
--      main_media_section = $6,
--      projects_id = $7,
--     project_properties_id = $8,
--     created_at = $9,
--     updated_at = $10
-- Where id = $1
-- RETURNING *;


-- name: DeletePropertiesMedia :exec
DELETE FROM properties_media
WHERE id = $1;


-- name: GetProjectPropertyMediaByIdAndGalleryAndMediaType :one
SELECT * FROM properties_media 
WHERE properties_id = $1 AND property = 1 AND gallery_type = $2 AND media_type = $3 LIMIT 1;

-- name: UpdatePropertiesMediaFiles :one
UPDATE properties_media
SET file_urls = $2,
    updated_at = $3
WHERE id = $1
RETURNING *;


-- -- name: GetAllProjectPropertiesMainMediaSectionById :many
-- With x As (
--  SELECT  main_media_section FROM project_property_media
--  WHERE project_property_media.project_properties_id = $1
-- ) SELECT * From x; 


-- -- name: GetAllProjectPropertiesByMainMediaSectionAndId :one
-- with x As (
--  SELECT * FROM project_property_media
--  WHERE main_media_section = $2 AND project_properties_id = $1
-- ) SELECT * From x; 


-- name: GetSumOfProjectPropertyMedia :one
SELECT
	COALESCE(SUM(array_length(file_urls, 1)),0)::INTEGER AS media_sum
FROM
    properties_media
WHERE
    properties_id = $1 AND property = 1;

-- name: GetProjectPhaseGalleryTypeByProjProperty :many
SELECT DISTINCT(gallery_type) FROM project_media
INNER JOIN project_properties ON project_properties.id = @project_property_id 
AND 
CASE 
	WHEN project_properties.is_multiphase IS TRUE THEN project_properties.phases_id = project_media.phases_id 
	ELSE project_properties.projects_id = project_media.projects_id 
END;

-- name: GetProjectMediaByProjPropertyAndGalleryType :many
SELECT * FROM project_media
INNER JOIN project_properties ON project_properties.id = @project_property_id 
AND 
CASE 
	WHEN project_properties.is_multiphase IS TRUE THEN project_properties.phases_id = project_media.phases_id 
	ELSE project_properties.projects_id = project_media.projects_id 
END AND project_media.gallery_type = @gallery_type;