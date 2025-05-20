-- name: CreateFreelancerPropertyMedia :one
INSERT INTO freelancers_properties_media (
    image_url,
    image360_url,
    video_url,
    panaroma_url,
    main_media_section,
    freelancers_properties_id,
    created_at, 
    updated_at
)VALUES (
    $1, $2, $3,$4, $5, $6, $7, $8
) RETURNING *;

-- name: GetFreelancerPropertyMedia :one
SELECT * FROM freelancers_properties_media 
WHERE id = $1 LIMIT $1;

-- name: GetFreelancerPropertyMediaByFreelancerPropertyId :many
SELECT * FROM freelancers_properties_media 
WHERE freelancers_properties_id = $2 LIMIT $1;


-- name: GetFreelancerPropertyMediaByProjectId :many
SELECT * FROM freelancers_properties_media 
WHERE freelancers_properties_id = $2 LIMIT $1;

-- name: GetAllFreelancerPropertyMedia :many
SELECT * FROM freelancers_properties_media 
ORDER By id
LIMIT $1
OFFSET $2;
 
 
 
-- name: UpdateFreelancerPropertyMedia :one
UPDATE freelancers_properties_media
SET    image_url = $2,
     image360_url = $3,
     video_url = $4,
     panaroma_url = $5,
    main_media_section = $6,
    freelancers_properties_id = $7,
    created_at = $8, 
    updated_at = $9
Where id = $1
RETURNING *;


-- name: DeleteFreelancerPropertyMedia :exec
DELETE FROM freelancers_properties_media
Where id = $1;


-- name: GetFreelancerPropertyMediaByUnitIdAndMediaSection :one
SELECT * FROM freelancers_properties_media
WHERE freelancers_properties_id = $1 AND main_media_section = $2;


-- name: GetAllFreelanceMediaByUnitId :many
SELECT id, image_url, 
image360_url, video_url,
 panaroma_url, main_media_section,
  freelancers_properties_id, 
   created_at, updated_at 
   FROM freelancers_properties_media 
WHERE freelancers_properties_id  = $1;


-- name: DeleteOneFreelancerPropertyMediaImagesByIdAndFile :one
UPDATE freelancers_properties_media
SET image_url = array_remove(image_url, $2)
WHERE id = $1
RETURNING *;

-- name: DeleteOneFreelancerPropertyMediaImage360ByIdAndFile :one
UPDATE freelancers_properties_media
SET image360_url = array_remove(image360_url, $2)
WHERE id = $1
RETURNING *;


-- name: DeleteOneFreelancerPropertyMediaVideoByIdAndFile :one
UPDATE freelancers_properties_media
SET video_url = array_remove(video_url, $2)
WHERE id = $1
RETURNING *;


-- name: DeleteOneFreelancerPropertyMediaParanomaByIdAndFile :one
UPDATE freelancers_properties_media
SET panaroma_url = array_remove(panaroma_url, $2)
WHERE id = $1
RETURNING *;

-- name: GetFreelancerPropertyMediaByPropertyIdAndMainMediaSection :one
SELECT * FROM freelancers_properties_media WHERE freelancers_properties_id=$1 AND main_media_section=$2;


-- name: GetAllFreelancerPropertyMediaByid :many
SELECT * FROM freelancers_properties_media WHERE freelancers_properties_id=$1;

-- name: GetAllFreelancersPropertiesMainMediaSectionById :many
With x As (
 SELECT  main_media_section FROM freelancers_properties_media
 WHERE freelancers_properties_id = $1
) SELECT * From x; 


-- name: GetAllFreelancersPropertiesByMainMediaSectionAndId :one
with x As (
 SELECT * FROM freelancers_properties_media
 WHERE main_media_section = $2 AND freelancers_properties_id = $1
) SELECT * From x; 
