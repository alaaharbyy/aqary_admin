-- name: CreateAdvertisment :one
INSERT INTO advertisements (title, pages_id, description, is_active)
VALUES ($1, $2, $3, $4)
RETURNING *;
 
-- name: UpdateAdvertisment :one
UPDATE advertisements
SET title = $1,
    pages_id = $2,
    description = $3,
    is_active = $4
WHERE id = $5
RETURNING *;
 
-- name: GetAllAdvertisments :many
 
SELECT *
FROM pages
WHERE status!=3 AND page_category=2
ORDER BY updated_at DESC
LIMIT $1 OFFSET $2;
 
-- name: GetSingleAdvertisement :one
SELECT
*
FROM
    pages
WHERE
    id = $1
AND page_category=2;
 
-- name: UpdateActiveStatusAdvertisement :one
UPDATE advertisements
SET is_active = $1
WHERE id = $2
RETURNING *;
 
-- name: GetAdvertisementsByPageID :many
SELECT 
a.id, a.title as ad_title, a.description as ad_description, is_active,
p.id as pages_id, p.title as pages_title, p.page_type as pages_type,
--  p.description as pages_description,
  p.status, p.created_at, p.updated_at
FROM advertisements AS a
JOIN pages p ON p.id=a.pages_id 
WHERE p.id= $1 AND p.status!=3
ORDER BY a.id DESC
LIMIT $2 OFFSET $3;

-- name: GetCountAdvertisement :one
SELECT COUNT(*) from pages WHERE status!=3 AND page_category=2;

-- name: UpdateAdvertisementIsActive :one
UPDATE advertisements
SET 
   is_active = $1
WHERE id = $2
RETURNING *;