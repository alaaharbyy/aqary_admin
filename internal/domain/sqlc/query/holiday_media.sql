-- name: CreateHolidayMedia :one
INSERT INTO holiday_media (
    image_url, 
    image360_url, 
    video_url, 
    panaroma_url, 
    main_media_section, 
    holiday_home_id
    )
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING *;
 
-- name: UpdateHolidayMedia :one
UPDATE holiday_media
SET 
	image_url = $2, 
	image360_url = $3, 
	video_url = $4, 
	panaroma_url = $5, 
	main_media_section = $6, 
	holiday_home_id = $7,
	updated_at = $8
	WHERE id = $1
RETURNING *;
 
-- name: GetAllHolidayMedia :many
SELECT * FROM holiday_media LIMIT $1 OFFSET $2;
 
 
-- name: GetHolidayMedia :one
SELECT * FROM holiday_media WHERE id = $1;
 
-- name: DeleteHolidayMedia :exec
DELETE FROM holiday_media
Where id = $1;


-- name: GetHolidayMediaByHolidayId :one
SELECT * FROM holiday_media WHERE holiday_home_id = $1;

-- name: GetHolidayMediasByHolidayId :many
SELECT * FROM holiday_media WHERE holiday_home_id = $1;
 
-- name: GetHolidayMediaByHolidayIdAndMainMediaSection :one 
SELECT *
FROM 
	holiday_media 
WHERE 
	holiday_home_id=$1 AND main_media_section =$2;

-- name: GetCountHolidayMedia :one
SELECT COUNT(*) FROM holiday_media;

-- name: DeleteHolidayMediaByHolidayID :exec
DELETE FROM holiday_media
WHERE holiday_home_id= $1;

-- name: GetAllHolidayMediaByHolidayId :many
SELECT hm.*
FROM	
	holiday_media AS hm 
WHERE hm.holiday_home_id=$1
GROUP BY (
	hm.main_media_section,hm.id)
	LIMIT $2 OFFSET $3;

-- name: GetAllHolidayMedias :many
SELECT * FROM holiday_media;

-- name: GetCountAllHolidayMediaByHolidayId :one
WITH x AS(
SELECT id,image_url AS url,1::bigint AS media_type,main_media_section,holiday_home_id FROM  holiday_media WHERE holiday_media.holiday_home_id = $1 AND image_url IS NOT NULL
UNION ALL
SELECT id,image360_url AS url,2::bigint AS media_type,main_media_section,holiday_home_id FROM  holiday_media WHERE holiday_media.holiday_home_id = $1 AND image360_url IS NOT NULL
UNION ALL
SELECT id,video_url AS url,3::bigint AS media_type,main_media_section,holiday_home_id FROM  holiday_media WHERE holiday_media.holiday_home_id = $1 AND video_url IS NOT NULL
UNION ALL
SELECT id,panaroma_url AS url,4::bigint AS media_type,main_media_section,holiday_home_id FROM  holiday_media WHERE holiday_media.holiday_home_id = $1 AND panaroma_url IS NOT NULL
) SELECT count(*) FROM x;

-- name: GetAllHolidayMediaByHolidayHomeId :many
With x As (
SELECT  main_media_section FROM holiday_media
WHERE holiday_home_id = $1
) SELECT main_media_section From x;
 
 
-- name: GetAllHolidayMediaByMainMediaSectionAndId :one
with x As (
SELECT * FROM holiday_media
WHERE main_media_section = $2 AND holiday_home_id = $1
) SELECT * From x;