-- name: CreateProjectVideo :one
INSERT INTO project_videos
(ref_no,company_types,is_branch,companies_id,project_id,title,video_url,is_deleted,created_by,created_at)VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) RETURNING *;
 
-- name: DeleteProjectVideo :one
UPDATE project_videos
SET 
is_deleted=TRUE
WHERE id=$1 RETURNING *;
 
-- name: UpdateProjectVideo :one
UPDATE project_videos
SET
    ref_no = $1,
    company_types = $2,
    is_branch = $3,
    companies_id = $4,
    project_id = $5,
    title = $6,
    video_url = $7,
    is_deleted = $8,
    created_by = $9
WHERE
    id = $10
RETURNING *;
 
-- name: GetAllProjectVideos :many
SELECT
   *
FROM
    project_videos
WHERE is_deleted!=TRUE
ORDER BY
    id DESC
LIMIT $1 OFFSET $2;
 
-- name: GetSingleProjectVideo :one
SELECT
*
FROM
    project_videos
WHERE
    id = $1;

-- name: GetCountProjectVideos :one
SELECT COUNT(*) FROM project_videos WHERE is_deleted=FALSE;