

-- name: GetAllHolidayHomeStayReviews :one
WITH averages AS (
            SELECT 
                AVG(comfortness) AS avg_comfortness, 
                AVG(communications) AS avg_communications, 
                AVG(cleanliness) AS avg_cleanliness, 
                AVG(location) AS avg_location
            FROM 
                holiday_stay_reviews
            WHERE 
                holiday_home_id = $1
        )
        SELECT 
            ROUND((
                (avg_comfortness + avg_communications + avg_cleanliness + avg_location) / 4
            )::numeric, 1) AS overall_average,
            avg_comfortness,
            avg_communications,
            avg_cleanliness,
            avg_location
        FROM 
            averages;



-- name: GetHolidayHomeStayReviews :many
select * from holiday_stay_reviews where holiday_home_id = $1;



-- name: GetAllHolidayHomeStayReviewUser :many
select hsr.*,
ROUND(((comfortness + communications + cleanliness + location) / 4)::numeric, 1) AS user_average, 
u.username from holiday_stay_reviews hsr JOIN users u
ON hsr.user_id = u.id
where holiday_home_id = $1;



-- name: CreateHolidayHomeStayReview :one
INSERT INTO holiday_stay_reviews (
    holiday_home_id, 
    review_date, 
    user_id, 
    comfortness, 
    communications, 
    cleanliness, 
    location, 
    title, 
    review
) VALUES (
    $1,
    $2,
    $3,
    $4,                                    
    $5,                                  
    $6,                                    
    $7,                                  
    $8,                        
    $9
) RETURNING *;



-- name: UpdateHolidayHomeStayReview :one
UPDATE holiday_stay_reviews
SET
    holiday_home_id = $1,
    review_date = $2,
    user_id = $3,
    comfortness = $4,
    communications = $5,
    cleanliness = $6,
    location = $7,
    title = $8,
    review = $9
WHERE
    id = $10 RETURNING *;

