-- name: CreateHotelBookingReview :one
INSERT INTO hotel_booking_reviews(posted_hotel_booking, review_date, user_id, comfort, rooms, cleanliness, building, title, review)
VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *;
 
-- name: UpdateHotelBookingReview :one
UPDATE hotel_booking_reviews
SET posted_hotel_booking = $2,
    review_date = $3,
    user_id = $4,
    comfort = $5,
    rooms = $6,
    cleanliness = $7,
    building = $8,
    title = $9,
    review = $10
WHERE id = $1 RETURNING *;
 
-- name: GetAllHotelBookingReviews :many
SELECT * FROM hotel_booking_reviews;
 
-- name: GetHotelBookingReviews :one
SELECT * FROM hotel_booking_reviews WHERE id=$1;