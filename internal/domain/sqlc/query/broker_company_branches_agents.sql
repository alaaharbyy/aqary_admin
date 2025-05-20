-- name: CreateBrokerBranchAgent :one
INSERT INTO broker_company_branches_agents (
    brn,
    experience_since,
    users_id,
    nationalities,
    brn_expiry,
    broker_companies_branches_id,
    created_at,
    updated_at,
    verification_document_url,
    about,
    about_arabic,
    linkedin_profile_url,
    facebook_profile_url,
    twitter_profile_url, 
    status,
    is_verified,
    profiles_id,
     telegram,
    botim,
    tawasal,
    service_areas,
    agent_rank
)VALUES (
    $1 ,$2, $3, $4, $5,$6,$7, $8, $9, $10, $11, $12, $13, $14, $15, $16,$17, $18, $19, $20, $21, $22
) RETURNING *;


-- name: GetBrokerBranchAgent :one
SELECT * FROM broker_company_branches_agents 
WHERE id = $1 LIMIT $1;



-- name: GetAllBrokerBranchAgent :many
SELECT * FROM broker_company_branches_agents
ORDER BY id
LIMIT $1
OFFSET $2;


 

-- name: UpdateBrokerBranchAgent :one
UPDATE broker_company_branches_agents
SET  
     brn = $2,
    experience_since = $3,
    users_id = $4,
    nationalities = $5,
    brn_expiry = $6,
    broker_companies_branches_id = $7,
    created_at = $8,
    updated_at = $9,
    verification_document_url = $10,
    about = $11,
    about_arabic = $12,
    linkedin_profile_url = $13,
    facebook_profile_url = $14,
    twitter_profile_url = $15, 
    status = $16,
    is_verified = $17,
    profiles_id = $18,
      telegram = $19,
    botim = $20,
    tawasal = $21,
    service_areas = $22,
    agent_rank = $23
Where id = $1
RETURNING *;


-- name: DeleteBrokerBranchAgent :exec
DELETE FROM broker_company_branches_agents
Where id = $1;



 

-- -- name: GetAllBrokerBranchAgentNamesByBrokerCompId :many
-- SELECT profiles.id AS profile_id,profiles.first_name,profiles.last_name,broker_company_branches_agents.broker_companies_id AS broker_company_id,broker_company_branches_agents.id AS broker_company_agent_id,broker_company_branches_agents.is_freelancer,users.id AS user_id 
-- FROM broker_companies 
-- LEFT JOIN broker_company_branches_agents ON broker_company_branches_agents.broker_companies_id = broker_companies.id 
-- LEFT JOIN users ON users.id = broker_company_branches_agents.users_id 
-- LEFT JOIN profiles ON profiles.id = users.profiles_id
-- WHERE broker_companies.id = $3 LIMIT $1 OFFSET $2;



-- name: GetBrokerCompanyBranchAgentByBrokerCompany :many
SELECT 
profiles.id AS profile_id,
profiles.first_name,
profiles.last_name,
broker_company_branches_agents.broker_companies_branches_id AS broker_branch_company_id,
broker_company_branches_agents.id AS broker_branch_company_agent_id,
users.id AS user_id
 FROM broker_companies_branches 
 RIGHT JOIN broker_company_branches_agents ON broker_company_branches_agents.broker_companies_branches_id=broker_companies_branches.id 
 RIGHT JOIN users ON users.id=broker_company_branches_agents.users_id 
 RIGHT JOIN profiles ON profiles.users_id=users.id 
 WHERE broker_companies_branches.id=$1;


-- name: GetBrokerCompanyBranchAgentByUsername :one
 SELECT broker_company_branches_agents.* FROM broker_company_branches_agents LEFT JOIN users ON users.id = broker_company_branches_agents.users_id WHERE users.user_types_id = 2 AND users.username = $1;


-- name: GetCompanyUserBranchAgentAndQuotaByUserId :one
SELECT
	broker_company_branches_agents.id AS broker_company_agents_id,
	broker_company_branches_agents.brn,
	broker_company_branches_agents.experience_since,
	broker_company_branches_agents.nationalities,
	broker_company_branches_agents.brn_expiry,
	broker_company_branches_agents.verification_document_url,
	broker_company_branches_agents.about,
	broker_company_branches_agents.about_arabic,
	broker_company_branches_agents.linkedin_profile_url,
	broker_company_branches_agents.facebook_profile_url,
	broker_company_branches_agents.twitter_profile_url,
	broker_company_branches_agents.is_verified,
	broker_company_branches_agents.profiles_id,
	broker_company_branches_agents.service_areas,
	agent_subscription_quota_branch.id AS agent_subscription_quota_branch_id,
	agent_subscription_quota_branch.standard,
	agent_subscription_quota_branch.featured,
	agent_subscription_quota_branch.premium,
	agent_subscription_quota_branch.top_deal
FROM
	broker_company_branches_agents
	LEFT JOIN agent_subscription_quota_branch ON agent_subscription_quota_branch.broker_company_branches_agents_id = broker_company_branches_agents.id
WHERE
	broker_company_branches_agents.users_id = $1;


-- name: UpdateBrokerBranchAgentByStatus :one
UPDATE broker_company_branches_agents SET status = $2 WHERE id = $1 RETURNING *;