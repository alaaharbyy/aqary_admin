
-- name: CreateOwnerPropertyMedia :one
INSERT INTO owner_properties_media (
     image_url,
    image360_url,
    video_url,
    panaroma_url,
    main_media_section,
    owner_properties_id,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- name: GetOwnerPropertyMedia :one
SELECT * FROM owner_properties_media 
WHERE id = $1 LIMIT $1;


-- name: GetAllOwnerPropertyMedia :many
SELECT * FROM owner_properties_media
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateOwnerPropertyMedia :one
UPDATE owner_properties_media
SET   image_url = $2,
    image360_url = $3,
    video_url = $4,
    panaroma_url = $5,
    main_media_section = $6,
    owner_properties_id = $7,
    created_at = $8,
    updated_at = $9
Where id = $1
RETURNING *;


-- name: DeleteOwnerPropertyMedia :exec
DELETE FROM owner_properties_media
Where id = $1;

-- name: GetAllOwnerPropertyMediaByid :many
SELECT * FROM owner_properties_media
WHERE owner_properties_id = $1;


-- name: GetOwnerPropertyMediaByPropertyIdAndMediaSection :one
SELECT * FROM owner_properties_media
WHERE owner_properties_id = $1 AND main_media_section = $2  LIMIT 1;


-- name: GetAllOwnerPropertiesMainMediaSectionById :many
With x As (
 SELECT  main_media_section FROM owner_properties_media
 WHERE owner_properties_id = $1
) SELECT * From x; 


-- name: GetAllOwnerPropertiesByMainMediaSectionAndId :one
with x As (
 SELECT * FROM owner_properties_media
 WHERE main_media_section = $2 AND owner_properties_id = $1
) SELECT * From x; 

