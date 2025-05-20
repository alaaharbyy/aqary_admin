-- name: CreateHolidayHomeBooking :one
INSERT INTO holiday_home_bookings (
    booking_ref_no,
    book_date,
    holiday_home_id,  
    check_in,
    check_out,
    status,
    customer_name,
    portal_id
    )
VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING *;


-- name: GetHolidayHomeBookings :one
SELECT * FROM holiday_home_bookings
WHERE id = $1 LIMIT 1;

-- name: GetAllHolidayHomeBooking :many
SELECT * FROM holiday_home_bookings  ORDER BY id DESC LIMIT $1 OFFSET $2;

-- -- name: UpdateHolidayHomeBookings :one
-- UPDATE holiday_home_bookings
-- SET  booking_ref_no = $2,
--      book_date = $3,
--      holiday_room_id = $4,
--      check_in = $5,
--      check_out = $6,
--      holiday_portals_id = $7,
--      status = $8
-- WHERE id = $1
-- RETURNING *;


-- name: DeleteHolidayHomeBookings :exec
DELETE FROM holiday_home_bookings
Where id = $1;

-- name: GetAllCountHolidayHomeBooking :one
SELECT COUNT(*) FROM holiday_home_bookings;

-- name: GetAllHolidayHomeBookingWithoutPg :many
SELECT * FROM holiday_home_bookings  ORDER BY id desc;

-- name: GetAllHolidayHomeBookingWithoutPgByHolidayId :many
SELECT * FROM holiday_home_bookings 
where holiday_home_id = $1 ORDER BY id DESC;
 
-- name: GetAllCountHolidayHomeBookingByHolidayId :one
SELECT COUNT(*) FROM holiday_home_bookings
where holiday_home_id = $1;
 
-- name: GetAllHolidayHomeBookingByHolidayId :many
SELECT * FROM holiday_home_bookings 
where holiday_home_id = $3
ORDER BY id DESC
LIMIT $1 OFFSET $2 ;