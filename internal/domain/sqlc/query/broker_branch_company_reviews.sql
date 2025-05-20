-- name: CreateBrokerBranchCompanyReviews :one
INSERT INTO broker_branch_company_reviews (
 rating,
 review,
 profiles_id,
 status,
 broker_companies_branches_id,
 created_at,
 updated_at,
 users_id

)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- name: GetBrokerBranchCompanyReviews :one
SELECT * FROM broker_branch_company_reviews 
WHERE id = $1 LIMIT $1;

-- name: GetAvgBrokerBranchCompanyReviews :one
SELECT AVG(rating::NUMERIC)::NUMERIC(2,1) FROM broker_branch_company_reviews WHERE  broker_companies_branches_id = $1;

 
-- name: GetBrokerBranchCompanyReviewsByCompanyId :many
SELECT * FROM broker_branch_company_reviews 
WHERE  broker_companies_branches_id = $3 LIMIT $1 OFFSET $2;

-- name: GetAllBrokerBranchCompanyReviews :many
SELECT * FROM broker_branch_company_reviews
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateBrokerBranchCompanyReviews :one
UPDATE broker_branch_company_reviews
SET   
  rating = $2,
 review = $3,
 profiles_id = $4,
 status = $5,
 broker_companies_branches_id = $6,
 created_at = $7,
 updated_at = $8,
 users_id = $9
Where id = $1
RETURNING *;


-- name: DeleteBrokerBranchCompanyReviews :exec
DELETE FROM broker_branch_company_reviews
Where id = $1;