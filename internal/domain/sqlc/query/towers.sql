-- name: CreateTower :one
INSERT INTO towers (
    countries_id,
    states_id,
    cities_id,
    community_id,
    subcommunity_id,
    title,
    title_ar,
    description,
    description_ar,
    image_url,
    created_at,
    updated_at, 
    created_by
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,$13
) RETURNING *;
 
-- name: GetTowerByID :one
SELECT * FROM towers WHERE id = $1;
 
-- name: UpdateTower :one
UPDATE towers 
SET countries_id = $2,
    states_id = $3,
    cities_id = $4,
    community_id = $5,
    subcommunity_id = $6,
    title = $7,
    title_ar = $8,
    description = $9,
    description_ar = $10,
    image_url = $11, 
    updated_at=$12
WHERE id = $1
RETURNING *;
 
-- name: GetAllTowers :many
SELECT 
	t.id,
	t.title,
	t.description,
	communities.id AS community_id,
	communities.community,
	tm.id AS tower_media_id,
	array_append(tm.image_url,t.image_url)
FROM towers t
INNER JOIN communities ON communities.id=t.community_id 
LEFT JOIN tower_media tm ON tm.towers_id=t.id
ORDER BY t.id DESC 
LIMIT $1 
OFFSET $2;
 
-- name: GetNumberOfTowers :one 
SELECT COUNT(id) from towers;
 
-- name: ListAllTowers :many
SELECT * FROM towers;

-- name: ChangeStatusOfTower :one
UPDATE towers
SET
    is_publish=$2
WHERE id=$1
RETURNING *;