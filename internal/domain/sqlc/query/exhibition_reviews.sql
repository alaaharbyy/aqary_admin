

-- name: CreateExhibitionReview :one 
INSERT INTO exhibition_reviews (
	exhibition_id,
	reviewer,
	clean,
	location,
	facilities,
	securities,
	title,
	review,
	review_date
	)
VALUES (
	$1, 
	$2, 
	$3, 
	$4,
	$5, 
	$6, 
	$7, 
	$8,
	$9
	)RETURNING *;



-- name: GetExhibitionReviewByID :one 
SELECT * 
FROM exhibition_reviews
WHERE id=$1;



-- name: GetAllExhibitionsReviews :many 
SELECT * FROM exhibition_reviews;



-- name: UpdateExhibitionReviewByID :one

UPDATE exhibition_reviews 

SET 

	clean=coalesce(sqlc.narg('clean'), clean),

	location=coalesce(sqlc.narg('location'), location),

	facilities=coalesce(sqlc.narg('facilities'), facilities),

	securities=coalesce(sqlc.narg('securities'), securities),

	title=coalesce(sqlc.narg('title'), title),

	review=coalesce(sqlc.narg('review'), review),

	review_date=$3

FROM (

	SELECT  exhibitions.id,exhibitions.event_status FROM exhibitions where exhibitions.id=$1

)x

WHERE exhibition_reviews.id=$2 AND x.event_status!=5

RETURNING x.id, event_status, exhibition_reviews.id, exhibition_id, reviewer, clean, location, facilities, securities, title, review, review_date;



-- name: GetAllExhibitionReviews :many 
SELECT er.id,er.title,er.review,er.review_date,p.first_name,p.last_name,p.profile_image_url, (er.clean+er.facilities+er.location+er.securities)/4 AS "rating"
FROM exhibition_reviews er
INNER JOIN users u
		ON 	er.reviewer = u.id 
INNER JOIN profiles p 
	ON u.profiles_id=p.id 
ORDER BY er.id DESC 
LIMIT $1 
OFFSET $2;



-- name: GetNumberOfAllExhibitionReviews :one
SELECT COUNT(id) FROM exhibition_reviews WHERE exhibition_id = $1;



-- name: GetAllReviewsForExhibition :many
SELECT er.id,er.title,er.review,er.review_date,p.first_name,p.last_name,p.profile_image_url, (er.clean+er.facilities+er.location+er.securities)/4 AS "rating"
FROM exhibition_reviews er
INNER JOIN users u
		ON 	er.reviewer = u.id 
INNER JOIN profiles p 
	ON u.profiles_id=p.id 
WHERE er.exhibition_id=$1
ORDER BY er.id DESC 
LIMIT $2 
OFFSET $3;



-- name: GetExhibitionByIdWithNumberOfReviews :one
SELECT exhibitions.*, (SELECT COUNT(exhibition_reviews.id) FROM exhibition_reviews WHERE exhibition_id=exhibitions.id) AS number_of_reviews
	FROM exhibitions 
WHERE 
	exhibitions.id=$1 AND event_status!=5;

