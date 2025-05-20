-- name: CreatePropertyPostMedia :one
INSERT INTO aqary_property_post_media (
    image_url,
    image360_url,
    video_url,
    panaroma_url,
    main_media_section,
    aqary_property_posts_id,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- name: GetAllAqaryPropertyPostMediaByPostId :many
SELECT * FROM aqary_property_post_media WHERE aqary_property_posts_id = $3 LIMIT $1 OFFSET $2;
 
-- -- name: GetAqaryPropertyPostMedia :many
SELECT * FROM aqary_property_post_media WHERE id = $3 LIMIT $1 OFFSET $2;
 
-- name: DeleteAqaryPropertyPostMediaByPostId :one
DELETE FROM aqary_property_post_media WHERE id = $1 RETURNING *;
-- name: DeleteAqaryPropertyPostMediaByPostID :many
DELETE FROM aqary_property_post_media WHERE aqary_property_posts_id = $1 RETURNING *;

-- name: UpdateAqaryPropertyPostMedia :one
-- UPDATE aqary_property_post_media 
-- SET aqary_property_posts_id = $2, 
-- media_type = $3, 
-- image_url=$4, 
-- image360_url = $5, 
-- video_url = $6, 
-- panaroma_url = $7, 
-- main_media_section = $8  
-- WHERE id = $1 RETURNING *;