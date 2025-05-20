-- name: CreateTags :one
INSERT INTO tags (tag_name) VALUES ($1) RETURNING *;

-- name: UpdateTags :one
UPDATE tags SET tag_name = $2 WHERE id = $1 RETURNING *;

-- name: GetAllTags :many
SELECT * FROM tags LIMIT $1 OFFSET $2;

-- name: SearchForTags :many
SELECT * FROM tags WHERE tag_name ILIKE $1 LIMIT $2 OFFSET $3;

-- name: DeleteTag :one
DELETE FROM tags WHERE id = $1 RETURNING *;

-- name: GetTagsByID :one
SELECT * FROM tags WHERE id=$1;

-- name: GetAllTagsCount :many
SELECT COUNT(*) FROM tags;

-- name: GetSearchedTagsCount :many
SELECT COUNT(*) FROM tags WHERE tag_name ILIKE $1;