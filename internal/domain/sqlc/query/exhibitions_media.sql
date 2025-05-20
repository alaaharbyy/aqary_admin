-- name: CreateExhibitionsMedia :one
INSERT INTO exhibitions_media (
	exhibitions_id, 
	gallery_type, 
	media_type, 
	media_url, 
	created_at, 
	updated_at)
VALUES(
	$1, 
	$2, 
	$3, 
	$4, 
	$5, 
	$6) RETURNING *;
 
-- name: GetExhibitionsMediaByExhibitionID :many
SELECT exhibitions_media.id, exhibitions_media.exhibitions_id, exhibitions_media.gallery_type, exhibitions_media.media_type, exhibitions_media.media_url, exhibitions_media.created_at, exhibitions_media.updated_at
FROM
    exhibitions_media 
INNER JOIN exhibitions 
	ON exhibitions.id=exhibitions_media.exhibitions_id AND exhibitions.event_status!=5
WHERE exhibitions_id=$1
ORDER BY exhibitions_media.updated_at DESC
LIMIT $2
OFFSET $3;

-- name: GetExhibitionMediaByID :one
	SELECT * 
	FROM exhibitions_media 
	WHERE id=$1;

-- name: GetAllGalleryTypesForMediaTypeExhibitionGraph :many
SELECT 
	id,gallery_type,cardinality(media_url) as "counter",CAST(media_url[1] AS VARCHAR) as "media_url"
FROM 
	exhibitions_media 
WHERE 
	exhibitions_id=$1 AND media_type=$2;



-- name: GetExhibitionsMediaByExhibitionIDAndGalleryAndMediaType :one
SELECT exhibitions_media.id,exhibitions_media.media_url
FROM
    exhibitions_media 
INNER JOIN exhibitions 
	ON   exhibitions.id=exhibitions_media.exhibitions_id AND exhibitions.event_status!=5
WHERE exhibitions_media.exhibitions_id=$1 AND exhibitions_media.gallery_type=$2 AND exhibitions_media.media_type=$3;



-- name: GetNumberOfMediaForExhibition :one
SELECT COUNT(id) FROM exhibitions_media WHERE exhibitions_id=$1;



-- name: DeleteExhibitionMediaByExhibitionIdMediaGalleryType :one
DELETE FROM exhibitions_media 
WHERE exhibitions_media.id=$1 AND (SELECT event_status FROM exhibitions WHERE id=exhibitions_media.exhibitions_id)!=5 RETURNING *;

