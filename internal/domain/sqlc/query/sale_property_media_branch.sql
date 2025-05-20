-- name: CreateSalePropertyMediaBranch :one
INSERT INTO sale_property_media_branch (
    image_url,
    image360_url,
    video_url,
    panaroma_url,
    main_media_section,
    sale_property_units_branch_id,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3,$4, $5, $6, $7, $8
) RETURNING *;

-- name: GetSalePropertyMediaBranch :one
SELECT * FROM sale_property_media_branch 
WHERE id = $1 LIMIT $1;

-- name: GetAllSalePropertyMediaBranch :many
SELECT * FROM sale_property_media_branch
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateSalePropertyMediaBranch :one
UPDATE sale_property_media_branch
SET  image_url = $2,
    image360_url = $3,
    video_url = $4,
    panaroma_url = $5,
    main_media_section = $6,
    sale_property_units_branch_id = $7,
    created_at = $8,
    updated_at = $9
Where id = $1
RETURNING *;

-- name: DeleteSalePropertyMediaBranch :exec
DELETE FROM sale_property_media_branch
Where id = $1;

-- name: GetSalePropertyMediaBranchByUnitIdAndMediaSection :one
SELECT * FROM sale_property_media_branch
WHERE sale_property_units_branch_id = $1 AND main_media_section = $2;

-- name: GetAllSaleUnitMediaBranchByUnitId :many
SELECT id, image_url, image360_url, video_url, panaroma_url, 
main_media_section, sale_property_units_branch_id, 
 created_at, updated_at 
 FROM sale_property_media_branch 
WHERE sale_property_units_branch_id = $1;


-- name: DeleteOneSalePropertyMediaBranchImagesByIdAndFile :one
UPDATE sale_property_media_branch
SET image_url = array_remove(image_url, $2)
WHERE id = $1
RETURNING *;

-- name: DeleteOneSalePropertyMediaBranchImages360ByIdAndFile :one
UPDATE sale_property_media_branch
SET image360_url = array_remove(image360_url, $2)
WHERE id = $1
RETURNING *;


-- name: DeleteOneSalePropertyMediaBranchVideoByIdAndFile :one
UPDATE sale_property_media_branch
SET video_url = array_remove(video_url, $2)
WHERE id = $1
RETURNING *;

-- name: DeleteOneSalePropertyMediaBranchPanaromaByIdAndFile :one
UPDATE sale_property_media_branch
SET panaroma_url = array_remove(panaroma_url, $2)
WHERE id = $1
RETURNING *;


-- name: GetSalePropertyMediaBranchBySaleId :one
SELECT * FROM sale_property_media_branch
WHERE sale_property_units_branch_id = $1 LIMIT 1;

 
