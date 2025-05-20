-- -- name: CreateHolidayHomeReviews :one
-- INSERT INTO holiday_home_reviews(holiday_home_id, review_date, user_id, comfort, rooms, cleanliness, building, title, review, status)
-- VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *;
 
-- -- name: UpdateHolidayHomeReviews :one
-- UPDATE holiday_home_reviews
-- SET holiday_home_id = $2,
--     review_date = $3,
--     user_id = $4,
--     comfort = $5,
--     rooms = $6,
--     cleanliness = $7,
--     building = $8,
--     title = $9,
--     review = $10,
--     status = $11
-- WHERE id = $1 RETURNING *;
 
-- -- name: GetAllHolidayHomeReviews :many
-- SELECT * FROM holiday_home_reviews WHERE status != 6;
 
-- -- name: GetHolidayHomeReviews :one
-- SELECT * FROM holiday_home_reviews WHERE id = $1 and status != 6;

-- -- name: GetAllCountHolidayHomeReviews :one
-- SELECT COUNT(*) FROM holiday_home_reviews WHERE status != 6;

-- -- name: DeleteHolidayHomeReviewByID :exec
-- DELETE FROM holiday_home_reviews
-- Where id = $1;