-- name: CreatePageOrAdvertisment :one
INSERT INTO pages
(title, page_category, page_type, wysiwyg, status, created_at,updated_at)
VALUES
($1, $2, $3, $4, $5, $6,$7)
RETURNING *;

-- -- name: UpdatePage :one
-- UPDATE pages
-- SET title = $1,
--     page_type = $2,
--     description = $3,
--     status = $4,
--     updated_at = $5
-- WHERE id = $6
-- RETURNING *;
 
-- name: GetAllPages :many
SELECT *
FROM pages
WHERE status!=3 AND page_category=1
ORDER BY updated_at DESC
LIMIT $1 OFFSET $2;

-- name: GetSinglePage :one
SELECT
*
FROM
    pages
WHERE
    id = $1
AND page_category=1;

-- name: GetCountPages :one
SELECT COUNT(*)
FROM pages
WHERE status!=3 AND page_category=1;

-- name: CreatePageContent :one
INSERT INTO page_contents (content_category, title,contents, status,content_ref_id,media_type,media_url)
VALUES ($1, $2, $3,$4,$5,$6,$7)
RETURNING *;
 
 
-- name: UpdatePageContent :one
UPDATE page_contents
SET content_category = $1,
    title = $2, 
    contents=$3,
    content_ref_id=$4,
    media_type=$5,
    media_url=$6,
    status = $7
WHERE id = $8
RETURNING *;
 
 
-- name: GetAllPageContents :many
SELECT *
FROM page_contents
WHERE status!=3 AND content_category=$1
ORDER BY id DESC
LIMIT $3 OFFSET $2;
 
 
-- name: GetPageContentByID :one
SELECT *
FROM page_contents
WHERE id = $1;
 
 
-- name: UpdatePageContentStatus :one
UPDATE page_contents
SET status = $1
WHERE id = $2 
RETURNING *;

-- name: GetCountPageContent :one
SELECT COUNT(*)
FROM page_contents
WHERE status!=3 AND content_category=$1;

-- name: UpdatePageOrAdvertisment :one
UPDATE pages
SET
  title = $1,
  page_category = $2,
  page_type = $3,
  wysiwyg = $4,
  status = $5,
  updated_at = $6
WHERE id = $7
RETURNING *;

-- name: UpdatePageStatus :one
 
UPDATE pages
SET 
status=$1
WHERE id=$2 
RETURNING *;