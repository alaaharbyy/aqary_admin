-- name: CreateTowerMedia :one
INSERT INTO tower_media (
    towers_id,
    image_url,
    created_at,
    updated_by
) VALUES (
    $1, $2, $3, $4
) RETURNING *;

-- name: UpdateTowerMedia :one
UPDATE tower_media 
SET 
    image_url = $2,
    updated_by = $3,
    created_at =$4
WHERE id = $1
RETURNING *;

-- name: GetMediaByTowerID :one 
SELECT * 
FROM
	tower_media 
WHERE 
	tower_media.towers_id=$1;