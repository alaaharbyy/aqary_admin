-- name: CreateProjectMedia :one
INSERT INTO project_media (
    file_urls,
    gallery_type,
    media_type,
    projects_id,
    created_at
)VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: CreatePhasesMedia :one
INSERT INTO project_media (
    file_urls,
    gallery_type,
    media_type,
    phases_id,
    created_at
    )
VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: GetProjectMedia :one
SELECT project_media.*,projects.project_name 
FROM project_media 
INNER JOIN projects ON project_media.projects_id = projects.id
WHERE project_media.id = $1;

-- name: UpdateProjectPhaseMediaFiles :one
UPDATE project_media
SET file_urls = $2,
    updated_at = $3
WHERE id = $1
RETURNING *;

-- name: DeleteProjectMedia :exec
DELETE FROM project_media WHERE id = $1;

-- name: GetAllProjectMedia :many
SELECT * FROM project_media LIMIT $1 OFFSET $2;

-- name: GetProjectMediaByIdAndGalleryAndMediaType :one
SELECT * FROM global_media WHERE entity_id = $1 AND gallery_type = $2 AND media_type = $3 AND entity_type_id = $4;

-- name: GetProjectMediaByIdAndGalleryType :many
SELECT * FROM project_media WHERE projects_id = $1 AND gallery_type = $2;

-- -- name: GetAllProjectMediaByProjectId :many
-- SELECT * FROM project_media WHERE projects_id = $1;

-- name: GetAllProjectMediaWithPagination :many
SELECT * FROM  project_media 
WHERE projects_id = $3 
LIMIT $1 OFFSET $2;

-- name: GetCountAllProjectMediaWithPagination :one
SELECT COUNT(id) FROM project_media
WHERE projects_id = $1;


-- name: GetAllProjectMediaWithoutPagination :many
SELECT * FROM  project_media 
WHERE projects_id = $1
AND
CASE
    WHEN @galleryType::Text = '' THEN true
    WHEN @galleryType::Text != '' THEN project_media.gallery_type = @galleryType::Text
END
AND
CASE
    WHEN @mediaTypeId::bigint = 0 THEN true
    WHEN @mediaTypeId::bigint > 0 THEN project_media.media_type = @mediaTypeId::bigint
END;

-- -- name: GetCountAllProjectMediaByProjectId :one
-- WITH x AS(
-- SELECT id,image_url AS url,1::bigint AS media_type,main_media_section,projects_id FROM  project_media WHERE project_media.projects_id = $1 AND image_url IS NOT NULL
-- UNION ALL
-- SELECT id,image360_url AS url,2::bigint AS media_type,main_media_section,projects_id FROM  project_media WHERE project_media.projects_id = $1 AND image360_url IS NOT NULL
-- UNION ALL
-- SELECT id,video_url AS url,3::bigint AS media_type,main_media_section,projects_id FROM  project_media WHERE project_media.projects_id = $1 AND video_url IS NOT NULL
-- UNION ALL
-- SELECT id,panaroma_url AS url,4::bigint AS media_type,main_media_section,projects_id FROM  project_media WHERE project_media.projects_id = $1 AND panaroma_url IS NOT NULL
-- ) SELECT count(*) FROM x;

-- -- name: GetAllProjectMediaByProjectIdAndMainMediaSection :many
-- With x As (
--  SELECT  main_media_section FROM project_media
--  WHERE projects_id = $1
-- ) SELECT * From x; 

-- -- name: GetAllProjectMediaByMainMediaSectionAndId :one
-- with x As (
--  SELECT * FROM project_media
--  WHERE main_media_section = $2 AND projects_id = $1
-- ) SELECT * From x;

-- name: GetSumOfProjectMedia :one
SELECT
	COALESCE(SUM(array_length(file_urls, 1)),0)::INTEGER AS media_sum
FROM
    project_media
WHERE
    projects_id = $1;















 
 
-- name: DeletePhasesMedia :exec
DELETE FROM project_media WHERE id = $1;
 
 
-- -- name: GetAllPhasesMedia :many
-- SELECT * FROM phases_media LIMIT $1 OFFSET $2;


-- name: GetAllPhasesMediaWithPagination :many
SELECT *,COUNT(id) OVER() AS total_count FROM  project_media WHERE phases_id = $3
ORDER BY id DESC LIMIT $1 OFFSET $2;


-- name: GetAllPhasesMediByWithoutPagination :many
SELECT * FROM  project_media WHERE phases_id = $1 ORDER BY id DESC;


-- -- name: GetCountAllPhasesMediByPhaseId :one
-- WITH x AS(
-- SELECT id,image_url AS url,1::bigint AS media_type,main_media_section,phases_id FROM  phases_media WHERE phases_media.phases_id = $1 AND image_url IS NOT NULL
-- UNION ALL
-- SELECT id,image360_url AS url,2::bigint AS media_type,main_media_section,phases_id FROM  phases_media WHERE phases_media.phases_id = $1 AND image360_url IS NOT NULL
-- UNION ALL
-- SELECT id,video_url AS url,3::bigint AS media_type,main_media_section,phases_id FROM  phases_media WHERE phases_media.phases_id = $1 AND video_url IS NOT NULL
-- UNION ALL
-- SELECT id,panaroma_url AS url,4::bigint AS media_type,main_media_section,phases_id FROM  phases_media WHERE phases_media.phases_id = $1 AND panaroma_url IS NOT NULL
-- ) SELECT COUNT(*) FROM x;
 
-- name: GetPhaseMedia :one
SELECT project_media.*,phases.phase_name 
FROM project_media 
INNER JOIN phases ON phases.id = project_media.phases_id
WHERE project_media.id = $1;

-- name: GetPhaseMediaByIdAndGalleryAndMediaType :one
SELECT * FROM project_media WHERE phases_id = $1 AND gallery_type = $2 AND media_type = $3;
 
-- -- name: UpdatePhaseMedia :one
-- UPDATE phases_media
-- SET 
-- image_url =  $1, 
-- image360_url =   $2, 
-- video_url =   $3, 
-- panaroma_url =  $4, 
-- main_media_section =   $5, 
-- phases_id = $6,
-- updated_at = $7
-- WHERE id =  $8
-- RETURNING id, image_url, image360_url, video_url, panaroma_url, main_media_section, phases_id, created_at, updated_at;

-- name: GetSumOfPhasesMedia :one
SELECT
	COALESCE(SUM(array_length(file_urls, 1)),0)::INTEGER AS media_sum
FROM
    project_media
WHERE
    phases_id = $1;

-- name: GetProjectGalleryTypeByPhase :many
SELECT DISTINCT(gallery_type)
FROM project_media
INNER JOIN phases ON phases.projects_id = project_media.projects_id
WHERE phases.id = @phases_id;

-- name: GetProjectPhaseMediaById :one
SELECT * FROM project_media WHERE id = $1;

-- name: GetSumOfProjectMediaById :one
SELECT
    COALESCE(SUM(array_length(pm.file_urls, 1)), 0) :: INTEGER AS media_sum
FROM
    project_media pm
JOIN
    project_media pm_ref
ON
    pm.projects_id = pm_ref.projects_id
WHERE
    pm_ref.id = $1;

-- name: GetSumOfPhaseMediaById :one
SELECT
    COALESCE(SUM(array_length(pm.file_urls, 1)), 0) :: INTEGER AS media_sum
FROM
    project_media pm
JOIN
    project_media pm_ref
ON
    pm.phases_id = pm_ref.phases_id
WHERE
    pm_ref.id = $1;