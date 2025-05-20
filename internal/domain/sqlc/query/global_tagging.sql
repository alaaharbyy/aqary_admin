-- name: AddGlobalTag :one
INSERT INTO global_tagging
(section,tag_name,created_at)
VALUES($1,$2,$3)
RETURNING *;
 
-- name: GetAllGlobalTagsBySection :many
SELECT * FROM global_tagging WHERE section=$1;
 
-- name: GetAllGlobalTags :many
SELECT * FROM global_tagging;
 
-- name: GetSingleGlobalTagBySection :one
SELECT * FROM global_tagging WHERE section=$1 AND id=$2;
 
 
-- name: GetSingleGlobalTag :one
SELECT * FROM global_tagging WHERE id=$1;