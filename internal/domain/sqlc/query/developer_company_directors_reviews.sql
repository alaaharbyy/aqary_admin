-- name: CreateDeveloperCompanyDirectorReview :one
INSERT INTO developer_company_directors_reviews (
    rating,
    review,
    profiles_id,
    status,
    developer_company_directors_id,
    created_at,
    updated_at,
    users_id
)VALUES (
    $1 ,$2, $3, $4, $5, $6 ,$7, $8
) RETURNING *;


-- name: GetDeveloperCompanyDirectorReview :one
SELECT * FROM developer_company_directors_reviews 
WHERE id = $1 LIMIT $1;


-- name: GetAllDeveloperCompanyDirectorReviewCompanyDirectorsId :many
SELECT * FROM developer_company_directors_reviews
Where developer_company_directors_id = $1
LIMIT $2
OFFSET $3;

-- name: GetAllDeveloperCompanyDirectorReview :many
SELECT * FROM developer_company_directors_reviews
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateDeveloperCompanyDirectorReview :one
UPDATE developer_company_directors_reviews
SET  rating = $2,
    review = $3,
    profiles_id = $4,
    status = $5,
    developer_company_directors_id = $6,
    created_at = $7,
    updated_at = $8,
    users_id = $9
Where id = $1
RETURNING *;


-- name: DeleteDeveloperCompanyDirectorReview :exec
DELETE FROM developer_company_directors_reviews
Where id = $1;


-- name: GetAvgDeveloperCompanyDirectorsReviews :one
SELECT AVG(rating::NUMERIC)::NUMERIC(2,1)  FROM developer_company_directors_reviews WHERE developer_company_directors_id = $1;