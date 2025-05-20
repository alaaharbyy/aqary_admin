-- name: CreateHotelBooking :one
INSERT INTO hotel_bookings(ref_no, booking_ref_no, hotel_rooms_id, book_date, check_in, check_out, hotel_booking_portals_id,status)
VALUES($1, $2, $3, $4, $5, $6, $7,$8) RETURNING *;
 
-- name: UpdateHotelBooking :one
UPDATE hotel_bookings
SET ref_no = $2,
    booking_ref_no = $3,
    hotel_rooms_id = $4,
    book_date = $5,
    check_in = $6,
    check_out = $7,
    hotel_booking_portals_id = $8,
    status = $9
WHERE id = $1 RETURNING *;
 
-- name: GetAllHotelBookings :many
SELECT * FROM hotel_bookings LIMIT $1 OFFSET $2;
 
-- name: GetHotelBookingByID :one
SELECT * FROM hotel_bookings WHERE id=$1;

-- name: UpdateHotelBookingStatus :one
UPDATE hotel_bookings
SET status = $2
WHERE id = $1 RETURNING *;