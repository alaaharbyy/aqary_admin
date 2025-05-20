-- name: CreateBrokerAgentReviews :one
INSERT INTO broker_agent_reviews (
    rating,
    review,
    profiles_id,
    localknowledge_rating,
    processexpertise_rating,
    responsiveness_rating,
    negotiationskills_rating,
    services_id,
    status,
    broker_company_agents_id,
    created_at,
    updated_at,
    users_id
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13 
) RETURNING *;


-- name: GetBrokerAgentReviews :one
SELECT * FROM broker_agent_reviews 
WHERE id = $1 LIMIT $1;


-- name: GetAllBrokerAgentReviewsByAgentId :many
SELECT * FROM broker_agent_reviews
Where broker_company_agents_id = $1
LIMIT $2
OFFSET $3;

-- name: GetAllBrokerAgentReviews :many
SELECT * FROM broker_agent_reviews
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateBrokerAgentReviews :one
UPDATE broker_agent_reviews
SET  rating = $2,
    review = $3,
    profiles_id = $4,
    localknowledge_rating = $5,
    processexpertise_rating = $6,
    responsiveness_rating = $7,
    negotiationskills_rating = $8,
    services_id = $9,
    status = $10,
    broker_company_agents_id = $11,
    created_at = $12,
    updated_at = $13,
    users_id = $14
Where id = $1
RETURNING *;


-- name: DeleteBrokerAgentReviews :exec
DELETE FROM broker_agent_reviews
Where id = $1;



-- name: GetAvgBrokerAgentReviews :one
SELECT AVG(rating::NUMERIC)::NUMERIC(2,1) FROM broker_agent_reviews Where broker_company_agents_id = $1;

-- name: GetAllBrokerAgentReviewsDetails :many
SELECT
    bar.id AS review_id,
    p.first_name,
	p.last_name,
	u.username,
	bc.company_name,
	u.email,
	bar.localknowledge_rating,
	bar.processexpertise_rating,
	bar.responsiveness_rating,
	bar.negotiationskills_rating,
	bar.review
FROM broker_agent_reviews AS bar
INNER JOIN profiles AS p ON p.id=bar.profiles_id
INNER JOIN broker_company_agents AS bca ON bca.id=bar.broker_company_agents_id
INNER JOIN broker_companies AS bc ON bc.id=bca.broker_companies_id
INNER JOIN users AS u ON u.id=bar.users_id
LIMIT $1 OFFSET $2;


-- name: GetBrokerAgentReviewsDetails :one
SELECT
    bar.id AS review_id,
    p.first_name,
	p.last_name,
	u.username,
	bc.company_name,
	u.email,
	bar.localknowledge_rating,
	bar.processexpertise_rating,
	bar.responsiveness_rating,
	bar.negotiationskills_rating,
	bar.review
FROM broker_agent_reviews AS bar
INNER JOIN profiles AS p ON p.id=bar.profiles_id
INNER JOIN broker_company_agents AS bca ON bca.id=bar.broker_company_agents_id
INNER JOIN broker_companies AS bc ON bc.id=bca.broker_companies_id
INNER JOIN users AS u ON u.id=bar.users_id
where bar.id=$1 LIMIT 1;

-- name: GetBrokerAgentReviewsCount :one
SELECT COUNT(*) FROM broker_agent_reviews;