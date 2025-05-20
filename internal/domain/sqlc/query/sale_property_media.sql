-- name: CreateSalePropertyMedia :one
INSERT INTO sale_property_media (
    image_url,
    image360_url,
    video_url,
    panaroma_url,
    main_media_section,
    sale_property_units_id,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3,$4, $5, $6, $7, $8
) RETURNING *;

-- name: GetSalePropertyMedia :one
SELECT * FROM sale_property_media 
WHERE id = $1 LIMIT $1;

-- name: GetSalePropertyMediaBySaleId :one
SELECT * FROM sale_property_media 
WHERE sale_property_units_id = $1;

-- name: GetAllSalePropertyMedia :many
SELECT * FROM sale_property_media
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateSalePropertyMedia :one
UPDATE sale_property_media
SET  image_url = $2,
    image360_url = $3,
    video_url = $4,
    panaroma_url = $5,
    main_media_section = $6,
    sale_property_units_id = $7,
    created_at = $8,
    updated_at = $9

Where id = $1
RETURNING *;


-- name: DeleteSalePropertyMedia :exec
DELETE FROM sale_property_media
Where id = $1;

-- name: GetSalePropertyMediaByUnitIdAndMediaSection :one
SELECT * FROM sale_property_media
WHERE sale_property_units_id = $1 AND main_media_section = $2;

-- name: GetAllSaleUnitMediaByUnitId :many
SELECT id, image_url, image360_url, video_url, panaroma_url, 
main_media_section, sale_property_units_id, 
 created_at, updated_at 
 FROM sale_property_media 
WHERE sale_property_units_id = $1;


-- name: DeleteOneSalePropertyMediaImagesByIdAndFile :one
UPDATE sale_property_media
SET image_url = 
  CASE 
    WHEN array_remove(image_url, @fileurl::VARCHAR) = '{}' THEN NULL
    ELSE array_remove(image_url, @fileurl::VARCHAR)
  END
WHERE id = $1
RETURNING *;


-- name: DeleteOneSalePropertyMediaImages360ByIdAndFile :one
UPDATE sale_property_media
SET image360_url = 
  CASE 
    WHEN array_remove(image360_url, @fileurl::VARCHAR) = '{}' THEN NULL
    ELSE array_remove(image360_url, @fileurl::VARCHAR)
  END
WHERE id = $1
RETURNING *;


-- name: DeleteOneSalePropertyMediaVideoByIdAndFile :one
UPDATE sale_property_media
SET video_url = 
  CASE 
    WHEN array_remove(video_url, @fileurl::VARCHAR) = '{}' THEN NULL
    ELSE array_remove(video_url, @fileurl::VARCHAR)
  END
WHERE id = $1
RETURNING *;


-- name: DeleteOneSalePropertyMediaPanaromaByIdAndFile :one
UPDATE sale_property_media
SET panaroma_url = 
  CASE 
    WHEN array_remove(panaroma_url, @fileurl::VARCHAR) = '{}' THEN NULL
    ELSE array_remove(panaroma_url, @fileurl::VARCHAR)
  END
WHERE id = $1
RETURNING *;



-- name: GetAllSaleMainMediaSectionById :many
With x As (
 SELECT  main_media_section FROM sale_property_media
 WHERE sale_property_units_id = $1
) SELECT * From x; 


-- name: GetAllSaleByMainMediaSectionAndId :one
with x As (
 SELECT * FROM sale_property_media
 WHERE main_media_section = $2 AND sale_property_units_id = $1
) SELECT * From x; 

 
-- name: GetAllSaleMediaByMainMediaSection :many
SELECT 
    sub.main_media_section, 
    array_to_json(array_agg(COALESCE(sub.image_url, ''))) as image_urls,
    array_to_json(array_agg(COALESCE(sub.video_url, ''))) as video_urls,
    array_to_json(array_agg(COALESCE(sub.panaroma_url, ''))) as panaroma_urls,
    array_to_json(array_agg(COALESCE(sub.image360_url, ''))) as image360_urls
FROM (
    SELECT 
        unnest(image_url) as image_url, 
        unnest(video_url) as video_url, 
        unnest(panaroma_url) as panaroma_url,
        unnest(image360_url) as image360_url,
        main_media_section
    FROM sale_property_media
    WHERE sale_property_units_id = $1
) as sub
GROUP BY sub.main_media_section;
 


-- SELECT
--     json_build_object(
--         'imageUrl', json_agg(json_build_object('imageUrl', image_url, 'counts', cardinality(image_url))),
--         'image360Url', json_agg(json_build_object('image360Url', image360_url, 'counts', cardinality(image360_url))),
--         'videoUrl', json_agg(json_build_object('videoUrl', video_url, 'counts', cardinality(video_url))),
--         'panaromaUrl', json_agg(json_build_object('panaromaUrl', panaroma_url, 'counts', cardinality(panaroma_url)))
--     ) as media
-- FROM
--     sale_property_media
-- WHERE
--     sale_property_units_id = $1
-- GROUP BY
--     sale_property_units_id;


-- name: GetAllSalePropertyMediaByUnitId :many
WITH x AS(
SELECT id,image_url AS url,1::bigint AS media_type,main_media_section,sale_property_units_id FROM  sale_property_media WHERE sale_property_media.sale_property_units_id = $3 AND image_url IS NOT NULL
UNION ALL
SELECT id,image360_url AS url,2::bigint AS media_type,main_media_section,sale_property_units_id FROM  sale_property_media WHERE sale_property_media.sale_property_units_id = $3 AND image360_url IS NOT NULL
UNION ALL
SELECT id,video_url AS url,3::bigint AS media_type,main_media_section,sale_property_units_id FROM  sale_property_media WHERE sale_property_media.sale_property_units_id = $3 AND video_url IS NOT NULL
UNION ALL
SELECT id,panaroma_url AS url,4::bigint AS media_type,main_media_section,sale_property_units_id FROM  sale_property_media WHERE sale_property_media.sale_property_units_id = $3 AND panaroma_url IS NOT NULL
) SELECT * FROM x LIMIT $1 OFFSET $2;

-- name: GetCountAllSalePropertyMediaByUnitId :one
WITH x AS(
SELECT id,image_url AS url,1::bigint AS media_type,main_media_section,sale_property_units_id FROM  sale_property_media WHERE sale_property_media.sale_property_units_id = $1 AND image_url IS NOT NULL
UNION ALL
SELECT id,image360_url AS url,2::bigint AS media_type,main_media_section,sale_property_units_id FROM  sale_property_media WHERE sale_property_media.sale_property_units_id = $1 AND image360_url IS NOT NULL
UNION ALL
SELECT id,video_url AS url,3::bigint AS media_type,main_media_section,sale_property_units_id FROM  sale_property_media WHERE sale_property_media.sale_property_units_id = $1 AND video_url IS NOT NULL
UNION ALL
SELECT id,panaroma_url AS url,4::bigint AS media_type,main_media_section,sale_property_units_id FROM  sale_property_media WHERE sale_property_media.sale_property_units_id = $1 AND panaroma_url IS NOT NULL
) SELECT COUNT(*) FROM x;

-- name: GetSumOfSaleMedia :one
SELECT
	COALESCE(
	SUM(
	    COALESCE(array_length(image_url, 1), 0) + 
	    COALESCE(array_length(image360_url, 1), 0) + 
	    COALESCE(array_length(video_url, 1), 0) + 
	    COALESCE(array_length(panaroma_url, 1), 0)
    ), 0)::INTEGER AS media_sum
FROM
    sale_property_media
WHERE
    sale_property_units_id = $1;

