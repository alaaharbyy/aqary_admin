-- name: CreateRoomType :one
INSERT INTO room_types (company_types_id, is_branch, companies_id, title, title_ar, smart_room, is_luxury, views, facilities,created_at,status) 
VALUES ( $1, $2, $3, $4, $5, $6, $7, $8, $9,$10,$11) RETURNING *;

-- name: GetAllRoomTypes :many
SELECT
  *
FROM
    room_types
ORDER BY
    id
LIMIT $1
OFFSET $2;
 
 
-- name: GetRoomTypeByID :one
SELECT * FROM room_types WHERE id=$1; 
 
-- name: UpdateRoomType :one
UPDATE room_types 
SET 
    company_types_id = $2,
    is_branch = $3,
    companies_id = $4,
    title = $5,
    title_ar =$6,
    smart_room = $7,
    is_luxury = $8,
    views = $9,
    facilities = $10,
    created_at = $11,
    status = $12
WHERE id = $1
RETURNING *;

-- name: UpdateRoomTypeStatus :one
UPDATE room_types 
SET 
    status = $2
WHERE id = $1
RETURNING *;

-- name: GetAllRoomType :many
SELECT  * FROM room_types;