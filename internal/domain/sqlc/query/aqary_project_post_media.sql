-- name: CreateProjectPostMedia :one
INSERT INTO aqary_project_post_media (
    image_url,
    image360_url,
    video_url,
    panaroma_url,
    main_media_section,
    aqary_project_posts,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;


-- name: GetAllAqaryProjectPostMediaByPostId :many
SELECT * FROM aqary_project_post_media WHERE aqary_project_posts = $3 LIMIT $1 OFFSET $2;
 
-- name: GetAqaryProjectPostMedia :one
SELECT * FROM aqary_project_post_media WHERE id = $3 LIMIT $1 OFFSET $2;
 
-- name: DeleteAqaryProjectPostMedia :one
DELETE FROM aqary_project_post_media WHERE id = $1 RETURNING *;
-- name: DeleteAqaryProjectPostMediaByPostID :many
DELETE FROM aqary_project_post_media WHERE aqary_project_posts = $1 RETURNING *;

-- name: UpdateAqaryProjectPostMedia :one
-- UPDATE aqary_project_post_media
--  SET aqary_project_posts = $2, 
--  media_type = $3, 
--  image_url=$4, 
--  image360_url = $5, 
--  video_url = $6, 
--  panaroma_url = $7, 
--  main_media_section = $8  
--  WHERE id = $1 RETURNING *;