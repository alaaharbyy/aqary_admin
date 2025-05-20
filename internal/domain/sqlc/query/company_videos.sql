-- name: CreateCompanyVideo :one
INSERT INTO company_videos
(ref_no,company_types,is_branch,companies_id,video_url,is_deleted,created_by,created_at,title)VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING *;
 
-- name: DeleteCompanyVideo :one
UPDATE company_videos
SET 
is_deleted=TRUE
WHERE id=$1 RETURNING *;
 
-- name: GetAllCompanyVideos :many
 
SELECT * FROM company_videos
WHERE is_deleted!=TRUE
ORDER BY id DESC
LIMIT $1 OFFSET $2;
 
-- name: GetCountCompanyVideos :one
 
SELECT COUNT(*) FROM company_videos
WHERE is_deleted!=TRUE;
 
-- name: GetSingleCompanyVideo :one
 
SELECT * FROM company_videos WHERE id=$1;