-- name: CreateBrokerCompanyReview :one
INSERT INTO broker_company_reviews (
    rating,
    review,
    profiles_id,
    status,
    broker_companies_id,
    created_at,
    updated_at,
    users_id

)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- name: GetBrokerCompanyReview :one
SELECT * FROM broker_company_reviews 
WHERE id = $1 LIMIT $1;

-- name: GetAllBrokerCompanyReviewByCountry :many
SELECT * FROM broker_company_reviews 
WHERE broker_companies_id = $3 LIMIT $1 OFFSET $2;

-- name: GetAllBrokerCompanyReview :many
SELECT * FROM broker_company_reviews
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateBrokerCompanyReview :one
UPDATE broker_company_reviews
SET    rating = $2,
    review = $3,
    profiles_id = $4,
    status = $5,
    broker_companies_id = $6,
    created_at = $7,
    updated_at = $8,
    users_id = $9
Where id = $1
RETURNING *;


-- name: DeleteBrokerCompanyReview :exec
DELETE FROM broker_company_reviews
Where id = $1;


-- name: GetAvgBrokerCompanyReviews :one
SELECT AVG(rating::NUMERIC)::NUMERIC(2,1) FROM broker_company_reviews WHERE broker_companies_id = $1;
