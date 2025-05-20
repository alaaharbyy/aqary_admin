-- -- name: CreateHolidayRooms :one
-- INSERT INTO holiday_rooms (
--     ref_no,
--     holiday_home_id,
--     room_types_id,
--     room_number,
--     title,
--     title_ar,
--     description,
--     description_ar,
--     price_night,
--     is_booked,
--     created_at,
--     updated_at,
--     max_pax,
--     bedrooms,
--     common_bathroom,
--     private_bathroom,
--     status
-- )VALUES (
--       $1 ,$2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17
-- ) RETURNING *;


-- -- name: GetHolidayRooms :one
-- SELECT * FROM holiday_rooms
-- WHERE id = $1 and status != 6 LIMIT 1;

-- -- name: GetAllHolidayRooms :many
-- SELECT * FROM holiday_rooms WHERE status != 6
-- ORDER BY id
-- LIMIT $1
-- OFFSET $2;

-- -- name: UpdateHolidayRooms :one
-- UPDATE holiday_rooms
-- SET  ref_no = $2,
--      holiday_home_id = $3,
--      room_types_id = $4,
--      room_number = $5,
--      title = $6,
--      title_ar = $7,
--      description = $8,
--      description_ar = $9,
--      price_night = $10,
--      is_booked = $11,
--      created_at = $12,
--      updated_at = $13,
--      max_pax = $14,
--      bedrooms = $15,
--      common_bathroom = $16,
--      private_bathroom = $17,
--      status = $18
-- WHERE id = $1
-- RETURNING *;


-- -- name: DeleteHolidayRooms :exec
-- DELETE FROM holiday_rooms
-- Where id = $1;

-- -- name: GetCountHolidayRooms :one
-- SELECT COUNT(*) FROM holiday_rooms;
 
-- -- name: UpdateHolidayRoomsStatus :one
-- UPDATE holiday_rooms
-- SET  updated_at = $2,
--      status = $3
-- WHERE id = $1
-- RETURNING *;