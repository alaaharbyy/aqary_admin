-- name: CreateRentPropertyMediaBranch :one
INSERT INTO rent_property_media_branch (
    image_url,
    image360_url,
    video_url,
    panaroma_url,
    main_media_section,
    rent_property_units_branch_id,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3,$4, $5, $6, $7, $8
) RETURNING *;

-- name: GetRentPropertyMediaBranch :one
SELECT * FROM rent_property_media_branch 
WHERE id = $1 LIMIT $1;

-- name: GetAllRentPropertyMediaBranch :many
SELECT * FROM rent_property_media_branch
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateRentPropertyMediaBranch :one
UPDATE rent_property_media_branch
SET  image_url = $2,
    image360_url = $3,
    video_url = $4,
    panaroma_url = $5,
    main_media_section = $6,
    rent_property_units_branch_id = $7,
    created_at = $8,
    updated_at = $9
Where id = $1
RETURNING *;


-- name: DeleteRentPropertyMediaBranch :exec
DELETE FROM rent_property_media_branch
Where id = $1;


-- name: GetRentPropertyMediaBranchByUnitIdAndMediaSection :one
SELECT * FROM rent_property_media_branch
WHERE rent_property_units_branch_id = $1 AND main_media_section = $2;

-- name: GetAllRentUnitMediaBranchByUnitId :many
SELECT id, image_url, 
image360_url, video_url, panaroma_url, 
main_media_section, rent_property_units_branch_id,
created_at, updated_at 
FROM rent_property_media_branch 
WHERE rent_property_units_branch_id = $1;


-- name: DeleteOneRentPropertyMediaBranchImagesByIdAndFile :one
UPDATE rent_property_media_branch
SET image_url = array_remove(image_url, $2)
WHERE id = $1
RETURNING *;

-- name: DeleteOneRentPropertyMediaBranchImages360ByIdAndFile :one
UPDATE rent_property_media_branch
SET image360_url = array_remove(image360_url, $2)
WHERE id = $1
RETURNING *;


-- name: DeleteOneRentPropertyMediaBranchVideoByIdAndFile :one
UPDATE rent_property_media_branch
SET video_url = array_remove(video_url, $2)
WHERE id = $1
RETURNING *;



-- name: DeleteOneRentPropertyMediaBranchPanaromaByIdAndFile :one
UPDATE rent_property_media_branch
SET panaroma_url = array_remove(panaroma_url, $2)
WHERE id = $1
RETURNING *;

 


-- name: GetRentPropertyMediaBranchByRentId :one
SELECT * FROM rent_property_media_branch
WHERE rent_property_units_branch_id = $1 LIMIT 1;