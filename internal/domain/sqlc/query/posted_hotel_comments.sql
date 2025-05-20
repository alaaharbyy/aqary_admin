-- name: CreatePostedHotelComment :one
INSERT INTO posted_hotel_comments(parent_comment, posted_hotel_booking, users_id, comment_date, comment, reaction_type_id, reacted_by)
VALUES($1, $2, $3, $4, $5, $6, $7) RETURNING *;
 
-- name: UpdatePostedHotelComment :one
 
UPDATE posted_hotel_comments
SET parent_comment = $2,
    posted_hotel_booking = $3,
    users_id = $4,
    comment_date = $5,
    comment = $6,
    reaction_type_id = $7,
    reacted_by = $8
WHERE id = $1 RETURNING *;
 
-- name: GetAllPostedHotelComments :many
SELECT * FROM posted_hotel_comments;
 
-- name: GetPostedHotelCommentByID :one
SELECT * FROM posted_hotel_comments WHERE id=$1;