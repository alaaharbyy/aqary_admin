
-- name: CreateIndustrailFreelancerPropertyMedia :one
INSERT INTO industrial_freelancer_properties_media (
    image_url,
    image360_url,
    video_url,
    panaroma_url,
    main_media_section,
    industrial_freelancer_properties_id,
    created_at,
    updated_at,
    is_branch
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9
) RETURNING *;

-- name: GetIndustrailFreelancerPropertyMedia :one
SELECT * FROM industrial_freelancer_properties_media 
WHERE id = $1 LIMIT $1;


-- name: GetAllIndustrailFreelancerPropertyMedia :many
SELECT * FROM industrial_freelancer_properties_media
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateIndustrailFreelancerPropertyMedia :one
UPDATE industrial_freelancer_properties_media
SET   image_url = $2,
    image360_url = $3,
    video_url = $4,
    panaroma_url = $5,
    main_media_section = $6,
    industrial_freelancer_properties_id = $7,
    created_at = $8,
    updated_at = $9,
     is_branch = $10
Where id = $1
RETURNING *;


-- name: DeleteIndustrailFreelancerPropertyMedia :exec
DELETE FROM industrial_freelancer_properties_media
Where id = $1;


-- name: GetIndustrialFreelancerPropertyMediaByPropertyIdAndMainMediaSection :one
SELECT * FROM industrial_freelancer_properties_media WHERE industrial_freelancer_properties_id=$1 AND LOWER(main_media_section)=LOWER($2);


-- name: GetAllIndustrialFreelancerPropertyMediaByPropertyId :many
SELECT * FROM industrial_freelancer_properties_media WHERE industrial_freelancer_properties_id=$1 ORDER BY id;