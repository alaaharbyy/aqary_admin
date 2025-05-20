-- name: CreateMapSearch :one
INSERT INTO map_searches
(ref_no, company_types, is_branch, companies_id, map_search_type, video_url, banner_types_id, banner_url, created_at, created_by, target_url, description, is_deleted)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
RETURNING *;

-- name: UpdateMapSearch :one
UPDATE map_searches
SET
    ref_no = $2,
    company_types = $3,
    is_branch = $4,
    companies_id = $5,
    map_search_type = $6,
    video_url = $7,
    banner_types_id = $8,
    banner_url = $9,
    created_at = $10,
    created_by = $11,
    target_url = $12,
    description = $13,
    is_deleted = $14
WHERE
    id = $1
RETURNING *;

 
-- name: GetAllMapSearches :many
SELECT
 *
FROM
    map_searches
WHERE is_deleted!=TRUE
ORDER BY
    id DESC
LIMIT $1 OFFSET $2;
 
-- name: GetMapSearchById :one
SELECT
 *
FROM
    map_searches
WHERE
    id = $1;
-- name: DeleteMapSearch :one
UPDATE map_searches
SET
    is_deleted = TRUE
WHERE
    id = $1
RETURNING *;

-- name: GetCountMapSearch :one
SELECT
COUNT(*)
FROM
    map_searches
WHERE is_deleted!=TRUE;