
-- name: CreateIndustrialOwnerPropertyMedia :one
INSERT INTO industrial_owner_properties_media (
    image_url,
    image360_url,
    video_url,
    panaroma_url,
    main_media_section,
    industrial_owner_properties_id,
    created_at,
    updated_at,
    is_branch
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9
) RETURNING *;

-- name: GetIndustrialOwnerPropertyMedia :one
SELECT * FROM industrial_owner_properties_media 
WHERE id = $1 LIMIT $1;


-- name: GetAllIndustrialOwnerPropertyMedia :many
SELECT * FROM industrial_owner_properties_media
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateIndustrialOwnerPropertyMedia :one
UPDATE industrial_owner_properties_media
SET   image_url = $2,
    image360_url = $3,
    video_url = $4,
    panaroma_url = $5,
    main_media_section = $6,
    industrial_owner_properties_id = $7,
    created_at = $8,
    updated_at = $9,
     is_branch = $10
Where id = $1
RETURNING *;


-- name: DeleteIndustrialOwnerPropertyMedia :exec
DELETE FROM industrial_owner_properties_media
Where id = $1;


-- name: GetIndustrialOwnerPropertyMediaByPropertyIdAndMediaSection :one
SELECT * FROM industrial_owner_properties_media
WHERE industrial_owner_properties_id = $1 AND LOWER(main_media_section)=LOWER($2);


-- name: GetAllIndustrialOwnerPropertyMediaByPropertyId :many
SELECT * FROM industrial_owner_properties_media
WHERE industrial_owner_properties_id = $1 ORDER BY id;

-- -- name: GetIndustrialOwnerPropertyMediaByPropertyIdAndMediaSection :one
-- SELECT * FROM industrial_owner_properties_media
-- WHERE industrial_owner_properties_id = $1 AND main_media_section = $2;
 