-- name: CreatePropertyVideo :one
 
INSERT INTO properties_videos
(ref_no,company_types,is_branch,companies_id,projects_id,phases_id,properties_id,title,is_deleted,created_by,created_at,video_url)VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12) RETURNING *;
 
 
-- name: DeletePropertyVideo :one
UPDATE properties_videos
SET 
is_deleted=TRUE
WHERE id=$1 RETURNING *;
 
-- name: GetAllPropertyVideos :many
 
SELECT * FROM properties_videos
WHERE is_deleted!=TRUE
ORDER BY id DESC
LIMIT $1 OFFSET $2;
 
 
-- name: GetCountPropertyVideos :one
 
SELECT COUNT(*) FROM properties_videos
WHERE is_deleted!=TRUE;
 
-- name: GetSinglePropertyVideo :one
 
SELECT * FROM properties_videos WHERE id=$1;
 
-- name: UpdatePropertiesVideo :one
UPDATE properties_videos
SET
    ref_no = $2,
    company_types = $3,
    is_branch = $4,
    companies_id = $5,
    projects_id = $6,
    phases_id = $7,
    properties_id = $8,
    title = $9,
    is_deleted = $10,
    created_by = $11,
    created_at = $12,
    video_url = $13
WHERE
    id = $1
RETURNING *;