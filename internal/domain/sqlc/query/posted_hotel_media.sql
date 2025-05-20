-- name: CreatePostedHotelMedia :one
INSERT INTO posted_hotel_media(posted_hotel_id, image_url, video_url, video_360_url)
VALUES($1, $2, $3, $4) RETURNING *;
 
-- name: UpdatePostedHotelMedia :one
UPDATE posted_hotel_media
SET image_url = $2,
    video_url = $3,
    video_360_url = $4
WHERE id = $1 RETURNING *;
 
-- name: GetAllPostedHotelMedia :many
SELECT * FROM posted_hotel_media;
 
-- name: GetPostedHotelMediaByID :one
SELECT * FROM posted_hotel_media WHERE id=$1;

-- name: GetHotelBookingMediaByPostedHotelId :one 
SELECT * 
FROM posted_hotel_media
WHERE posted_hotel_id =$1;

-- name: DeletePostedHotelBookingMediaById :exec
DELETE FROM posted_hotel_media
WHERE id = $1;