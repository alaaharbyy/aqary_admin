-- name: CreateHotelRoomMedia :one
INSERT INTO hotel_rooms_media(hotel_rooms_id, image_url, video_url, video_360_url)
VALUES($1, $2, $3, $4) RETURNING *;
 
-- name: UpdateHotelRoomMedia :one
UPDATE hotel_rooms_media
SET image_url = $2,
    video_url = $3,
    video_360_url = $4
WHERE id = $1 RETURNING *;
 
-- name: GetAllHotelRoomsMedias :many
SELECT * FROM hotel_rooms_media
LIMIT $1
OFFSET $2;
 
-- name: GetHotelRoomMediaByID :one
SELECT * FROM hotel_rooms_media WHERE id=$1;

-- name: GetHotelRoomMediaByHotelRoomID :one 
SELECT *
FROM
	hotel_rooms_media
WHERE
	hotel_rooms_id = $1;

-- name: DeleteHotelRoomMediaById :exec
DELETE FROM hotel_rooms_media
WHERE id=$1;