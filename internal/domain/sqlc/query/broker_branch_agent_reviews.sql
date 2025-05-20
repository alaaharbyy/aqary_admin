-- name: CreateBrokerBranchAgentReviews :one
INSERT INTO broker_branch_agent_reviews (
    rating,
    review,
    profiles_id,
    localknowledge_rating,
    processexpertise_rating,
    responsiveness_rating,
    negotiationskills_rating,
    services_id,
    status,
    broker_company_branches_agents_id,
    created_at,
    updated_at,
    users_id
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13 
) RETURNING *;

-- name: GetBrokerBranchAgentReviews :one
SELECT * FROM broker_branch_agent_reviews 
WHERE id = $1 LIMIT $1;

-- name: GetAvgBrokerBranchAgentReviews :one
SELECT AVG(rating::NUMERIC)::NUMERIC(2,1) FROM broker_branch_agent_reviews WHERE broker_company_branches_agents_id = $1;

 
-- name: GetBrokerBranchAgentReviewsByCompanyId :many
SELECT * FROM broker_branch_agent_reviews 
WHERE  broker_company_branches_agents_id = $3 LIMIT $1 OFFSET $2;

-- name: GetAllBrokerBranchAgentReviews :many
SELECT * FROM broker_branch_agent_reviews
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateBrokerBranchAgentReviews :one
UPDATE broker_branch_agent_reviews
SET   
rating = $2,
    review = $3,
    profiles_id = $4,
    localknowledge_rating = $5,
    processexpertise_rating = $6,
    responsiveness_rating = $7,
    negotiationskills_rating = $8,
    services_id = $9,
    status = $10,
    broker_company_branches_agents_id = $11,
    created_at = $12,
    updated_at = $13,
    users_id = $14
Where id = $1
RETURNING *;


-- name: DeleteBrokerBranchAgentReviews :exec
DELETE FROM broker_branch_agent_reviews
Where id = $1;