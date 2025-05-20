-- -- name: CreateHolidayRoomMedia :one
-- INSERT INTO holiday_rooms_media(holiday_rooms_id, image_url, video_url, video_360_url)
-- VALUES($1, $2, $3, $4) RETURNING *;
 
-- -- name: UpdateHolidayRoomMedia :one
-- UPDATE holiday_rooms_media
-- SET image_url = $2,
--     video_url = $3,
--     video_360_url = $4,
-- holiday_rooms_id = $5
-- WHERE id = $1 RETURNING *;
 
-- -- name: GetAllHolidayRoomsMedias :many
-- SELECT * FROM holiday_rooms_media;
 
-- -- name: GetHolidayRoomsMediaByID :one
-- SELECT * FROM holiday_rooms_media WHERE id=$1;


-- -- name: GetAllCountHolidayRoomsMedia :one
-- SELECT COUNT(*) FROM holiday_rooms_media ;


-- -- name: DeleteHolidayRoomsMediaByID :exec
-- DELETE FROM holiday_rooms_media
-- Where id = $1;

-- -- name: DeleteAllHolidayRoomsMedia :exec
-- DELETE FROM holiday_rooms_media;

-- -- name: GetHolidayRoomsMediaByRoomsID :one
-- SELECT * FROM holiday_rooms_media WHERE holiday_rooms_id=$1;