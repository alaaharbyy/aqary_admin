-- name: CreateUnitMedia :one
INSERT INTO unit_media (
    file_urls,
    gallery_type,
    media_type,
    units_id,
    created_at
)VALUES (
    $1, $2, $3,$4, $5
) RETURNING *;

-- name: UpdateUnitMedia :one
UPDATE unit_media
SET file_urls = $2,
    gallery_type = $3,
    media_type = $4,
    units_id = $5,
    updated_at = $6
Where id = $1
RETURNING *;

-- name: UpdateUnitMediaFiles :one
UPDATE unit_media
SET file_urls = $2,
    updated_at = $3
Where id = $1
RETURNING *;

-- name: GetSumOfUnitMedia :one
SELECT
    COALESCE(SUM(array_length(file_urls, 1)),0)::INTEGER AS media_sum
FROM
    global_media
WHERE
     entity_type_id = @entity_type_id AND entity_id = @entity_id;
-- SELECT
--     COALESCE(SUM(array_length(file_urls, 1)),0)::INTEGER AS media_sum
-- FROM
--     unit_media
-- WHERE
--     units_id = $1;

-- name: GetUnitMediaByGalleryAndMediaType :one
SELECT * FROM unit_media
WHERE units_id = $1 AND gallery_type = $2 AND media_type = $3;

-- name: GetAllUnitMediaByUnitId :many
SELECT *,COUNT(id) OVER() AS total_count FROM  unit_media 
WHERE units_id = $3
LIMIT $1 OFFSET $2;


-- name: GetAllUnitMediaByUnitIdWithoutPagination :many
SELECT * FROM  unit_media 
WHERE units_id = $1;

-- -- name: GetCountAllUnitMediaByUnitId :one
-- WITH x AS(
-- SELECT id,image_url AS url,1::bigint AS media_type,main_media_section,units_id FROM  unit_media WHERE unit_media.units_id = $1 AND image_url IS NOT NULL
-- UNION ALL
-- SELECT id,image360_url AS url,2::bigint AS media_type,main_media_section,units_id FROM  unit_media WHERE unit_media.units_id = $1 AND image360_url IS NOT NULL
-- UNION ALL
-- SELECT id,video_url AS url,3::bigint AS media_type,main_media_section,units_id FROM  unit_media WHERE unit_media.units_id = $1 AND video_url IS NOT NULL
-- UNION ALL
-- SELECT id,panaroma_url AS url,4::bigint AS media_type,main_media_section,units_id FROM  unit_media WHERE unit_media.units_id = $1 AND panaroma_url IS NOT NULL
-- ) SELECT COUNT(*) FROM x;

-- name: GetUnitMedia :one
SELECT * FROM unit_media 
WHERE id = $1 LIMIT 1;

-- name: DeleteUnitMedia :exec
DELETE FROM unit_media
WHERE id = $1;

-- name: DeleteOneUnitMediaFileByIdAndFile :one
UPDATE unit_media
SET file_urls = array_remove(file_urls, @fileurl::VARCHAR)
WHERE id = $1
RETURNING *;


-- -- name: DeleteOneUnitMediaImages360ByIdAndFile :one
-- UPDATE unit_media
-- SET image360_url = 
--   CASE 
--     WHEN array_remove(image360_url, @fileurl::VARCHAR) = '{}' THEN NULL
--     ELSE array_remove(image360_url, @fileurl::VARCHAR)
--   END
-- WHERE id = $1
-- RETURNING *;


-- -- name: DeleteOneUnitMediaVideoByIdAndFile :one
-- UPDATE unit_media
-- SET video_url = 
--   CASE 
--     WHEN array_remove(video_url, @fileurl::VARCHAR) = '{}' THEN NULL
--     ELSE array_remove(video_url, @fileurl::VARCHAR)
--   END
-- WHERE id = $1
-- RETURNING *;


-- -- name: DeleteOneUnitMediaPanaromaByIdAndFile :one
-- UPDATE unit_media
-- SET panaroma_url = 
--   CASE 
--     WHEN array_remove(panaroma_url, @fileurl::VARCHAR) = '{}' THEN NULL
--     ELSE array_remove(panaroma_url, @fileurl::VARCHAR)
--   END
-- WHERE id = $1
-- RETURNING *;


-- name: GetProjProGalleryTypeByUnit :many
SELECT DISTINCT(gallery_type)
FROM properties_media
LEFT JOIN units ON units.properties_id = properties_media.properties_id AND units.property = 1
WHERE units.id = $1 AND properties_media.property = 1;

-- name: GetProjectPropertyMediaByIdAndGallery :many
SELECT * FROM properties_media 
WHERE properties_id = $1 AND property = 1 AND gallery_type = $2 LIMIT 1;