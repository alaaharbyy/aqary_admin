
-- name: CreateDeveloperBranchCompanyReview :one
INSERT INTO developer_branch_company_reviews (
    rating,
    review,
    profiles_id,
    status,
    developer_company_branches_id,
    created_at,
    updated_at,
    users_id
)VALUES (
   $1 ,$2, $3, $4, $5, $6, $7, $8
) RETURNING *;


-- name: GetDeveloperBranchCompanyReview :one
SELECT * FROM developer_branch_company_reviews 
WHERE id = $1 LIMIT $1;

-- name: GetAllDeveloperBranchCompanyReview :many
SELECT * FROM developer_branch_company_reviews
ORDER BY id
LIMIT $1
OFFSET $2;


-- name: GetAllDeveloperBranchCompanyReviewByBranchCompanyId :many
SELECT * FROM developer_branch_company_reviews
Where developer_company_branches_id = $1
LIMIT $2
OFFSET $3;

-- name: UpdateDeveloperBranchCompanyReview :one
UPDATE developer_branch_company_reviews
SET  rating = $2,
    review = $3,
    profiles_id = $4,
    status = $5,
    developer_company_branches_id = $6,
    created_at = $7,
    updated_at = $8,
    users_id = $9
Where id = $1
RETURNING *;


-- name: DeleteDeveloperBranchCompanyReview :exec
DELETE FROM developer_branch_company_reviews
Where id = $1;



-- name: GetAvgDeveloperBranchReviews :one
SELECT AVG(rating::NUMERIC)::NUMERIC(2,1)  FROM developer_branch_company_reviews WHERE developer_company_branches_id =  $1;