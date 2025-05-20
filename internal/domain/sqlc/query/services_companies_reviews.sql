-- name: CreateServiceCompaniesReviews :one
INSERT INTO services_companies_reviews (
 rating,
 review,
 profiles_id,
 status,
 services_companies_id,
 created_at,
 updated_at,
 users_id
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- name: GetServiceCompaniesReviews :one
SELECT * FROM services_companies_reviews 
WHERE id = $1 LIMIT $1;

-- name: GetServiceCompaniesReviewsByCompanyId :many
SELECT * FROM services_companies_reviews 
WHERE services_companies_id = $3 LIMIT $1 OFFSET $2;

-- name: GetAllServiceCompaniesReviews :many
SELECT * FROM services_companies_reviews
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateServiceCompaniesReviews :one
UPDATE services_companies_reviews
SET   
 rating = $2,
 review = $3,
 profiles_id = $4,
 status = $5,
 services_companies_id = $6,
 created_at = $7,
 updated_at = $8,
 users_id = $9
Where id = $1
RETURNING *;


-- name: DeleteServiceCompaniesReviews :exec
DELETE FROM services_companies_reviews
Where id = $1;

-- name: GetAvgServiceCompanyReview :one
SELECT AVG(rating::bigint)::NUMERIC(2,1) FROM services_companies_reviews  Where services_companies_id = $1;