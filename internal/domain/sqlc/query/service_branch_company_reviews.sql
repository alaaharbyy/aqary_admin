-- name: CreateServiceBranchCompanyReviews :one
INSERT INTO service_branch_company_reviews (
 rating,
 review,
 profiles_id,
 status,
 service_company_branches_id,
 created_at,
 updated_at,
 users_id
)VALUES (
    $1, $2, $3, $4, $5,$6,$7, $8
) RETURNING *;

-- name: GetServiceBranchCompanyReviews :one
SELECT * FROM service_branch_company_reviews 
WHERE id = $1 LIMIT $1;

-- name: GetServiceBranchCompanyReviewsByCompanyId :many
SELECT * FROM service_branch_company_reviews 
WHERE  service_company_branches_id = $3 LIMIT $1 OFFSET $2;

-- name: GetAllServiceBranchCompanyReviews :many
SELECT * FROM service_branch_company_reviews
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateServiceBranchCompanyReviews :one
UPDATE service_branch_company_reviews
SET   
 rating = $2,
 review = $3,
 profiles_id = $4,
 status = $5,
 service_company_branches_id = $6,
 created_at = $7,
 updated_at = $8,
 users_id = $9
Where id = $1
RETURNING *;


-- name: DeleteServiceBranchCompanyReviews :exec
DELETE FROM service_branch_company_reviews
Where id = $1;


-- name: GetAvgServiceBranchCompanyReview :one
SELECT AVG(rating::bigint)::NUMERIC(2,1) FROM service_branch_company_reviews WHERE  service_company_branches_id = $1;
