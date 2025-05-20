-- name: CreateBrokerAgent :one
INSERT INTO broker_company_agents (
    brn,
    experience_since,
    users_id,
    nationalities,
    brn_expiry,
    verification_document_url,
    about,
    about_arabic,
    linkedin_profile_url,
    facebook_profile_url,
    twitter_profile_url,
    broker_companies_id,
    created_at,
    updated_at,
    status,
    is_verified,
    profiles_id,
    telegram,
    botim,
    tawasal,
    service_areas,
    agent_rank
)VALUES (
    $1 ,$2, $3, $4, $5,$6,$7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22
) RETURNING *;


-- name: GetBrokerAgent :one
SELECT * FROM broker_company_agents 
WHERE id = $1 LIMIT $1;


-- -- name: GetBrokerAgentByCountryId :many
-- SELECT * FROM broker_company_agents 
-- WHERE broker_companies_id = $3 LIMIT $1 OFFSET $2;

-- name: GetCountBrokerAgentByCompanyId :one
SELECT COUNT(*) FROM broker_company_agents 
WHERE broker_companies_id = $1 LIMIT 1;

-- name: GetAllBrokerAgent :many
SELECT * FROM broker_company_agents
ORDER BY id
LIMIT $1
OFFSET $2;


-- name: GetAllBrokerAgentByCompanyId :many
SELECT * FROM broker_company_agents
Where broker_companies_id = $1
LIMIT $2
OFFSET $3;


-- name: GetAllBrokerAgentByCompanyIdWithoutLimit :many
SELECT * FROM broker_company_agents
Where broker_companies_id = $1;


-- name: UpdateBrokerAgent :one
UPDATE broker_company_agents
SET  
    brn = $2,
    experience_since = $3,
    users_id = $4,
    nationalities = $5,
    brn_expiry = $6,
    verification_document_url = $7,
    about = $8,
    about_arabic = $9,
    linkedin_profile_url = $10,
    facebook_profile_url = $11,
    twitter_profile_url = $12,
    broker_companies_id = $13,
    created_at = $14,
    updated_at = $15,
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


-- name: DeleteBrokerAgent :exec
DELETE FROM broker_company_agents
Where id = $1;





-- name: GetAllBrokerAgentNamesByBrokerCompId :many
SELECT profiles.id AS profile_id,profiles.first_name,profiles.last_name,broker_company_agents.broker_companies_id AS broker_company_id,broker_company_agents.id AS broker_company_agent_id, users.id AS user_id 
FROM broker_companies 
RIGHT JOIN broker_company_agents ON broker_company_agents.broker_companies_id = broker_companies.id 
RIGHT JOIN users ON users.id = broker_company_agents.users_id 
RIGHT JOIN profiles ON profiles.users_id = users.id
WHERE broker_companies.id = $1;

-- name: GetAllBrokerAgentNamesByBrokerCompIdWithoutFreelance :many
SELECT profiles.id AS profile_id,profiles.first_name,profiles.last_name,broker_company_agents.broker_companies_id AS broker_company_id,broker_company_agents.id AS broker_company_agent_id ,users.id AS user_id
FROM broker_companies
RIGHT JOIN broker_company_agents ON broker_company_agents.broker_companies_id = broker_companies.id
RIGHT JOIN users ON users.id = broker_company_agents.users_id
RIGHT JOIN profiles ON profiles.users_id = users.id
WHERE broker_companies.id = $1;


-- name: GetAllBrokerAgentNamesByBrokerCompIdWithPagination :many
SELECT profiles.id AS profile_id,profiles.first_name,profiles.last_name,broker_company_agents.broker_companies_id AS broker_company_id,broker_company_agents.id AS broker_company_agent_id ,users.id AS user_id 
FROM broker_companies 
LEFT JOIN broker_company_agents ON broker_company_agents.broker_companies_id = broker_companies.id 
LEFT JOIN users ON users.id = broker_company_agents.users_id 
LEFT JOIN profiles ON profiles.users_id = users.id
WHERE broker_companies.id = $3 LIMIT $1 OFFSET $2;


-- name: GetAllFreelancerNames :many
SELECT freelancers.id,profiles.id AS profile_id,profiles.first_name,profiles.last_name,users.id AS user_id 
FROM freelancers
 LEFT JOIN users ON users.id=freelancers.users_id 
LEFT JOIN profiles ON profiles.users_id = users.id;


-- name: GetBrokerCompanyAgentByUsername :one
SELECT broker_company_agents.* FROM broker_company_agents LEFT JOIN users ON users.id = broker_company_agents.users_id WHERE users.user_types_id = 2 AND users.username = $1;




-- name: GetCompanyUserAgentAndQuotaByUserId :one
SELECT
	broker_company_agents.id AS broker_company_agents_id,
	broker_company_agents.brn,
	broker_company_agents.experience_since,
	broker_company_agents.nationalities,
	broker_company_agents.brn_expiry,
	broker_company_agents.verification_document_url,
	broker_company_agents.about,
	broker_company_agents.about_arabic,
	broker_company_agents.linkedin_profile_url,
	broker_company_agents.facebook_profile_url,
	broker_company_agents.twitter_profile_url,
	broker_company_agents.is_verified,
	broker_company_agents.profiles_id,
	broker_company_agents.service_areas,
	agent_subscription_quota.id AS agent_subscription_quota_id,
	agent_subscription_quota.standard,
	agent_subscription_quota.featured,
	agent_subscription_quota.premium,
	agent_subscription_quota.top_deal
FROM
	broker_company_agents
	LEFT JOIN agent_subscription_quota ON agent_subscription_quota.broker_company_agents_id = broker_company_agents.id
WHERE
	broker_company_agents.users_id = $1;





-- name: SearchAllAgent :many
With x As (
 SELECT users.id, users.username, users.phone_number FROM broker_company_agents
  INNER JOIN users ON broker_company_agents.users_id = users.id
  INNER JOIN profiles ON broker_company_agents.profiles_id = profiles.id
  
  WHERE  
        users.username ILIKE $1 OR
        profiles.first_name ILIKE $1 OR
        profiles.last_name ILIKE $1 OR 
        users.phone_number ILIKE $1
    UNION ALL 
    
  SELECT users.id, users.username,users.phone_number FROM broker_company_branches_agents
  INNER JOIN users ON broker_company_branches_agents.users_id = users.id
  INNER JOIN profiles ON broker_company_branches_agents.profiles_id = profiles.id
  
  WHERE  
             users.username ILIKE $1 OR
        profiles.first_name ILIKE $1 OR
        profiles.last_name ILIKE $1 OR 
        users.phone_number ILIKE $1
              
  
  UNION ALL
  
  SELECT users.id, users.username,users.phone_number FROM freelancers
  INNER JOIN users ON freelancers.users_id = users.id
  INNER JOIN profiles ON freelancers.profiles_id = profiles.id
  
  WHERE  
        users.username ILIKE $1 OR
        profiles.first_name ILIKE $1 OR
        profiles.last_name ILIKE $1 OR 
        users.phone_number ILIKE $1
) SELECT * FROM x LIMIT 50;


-- name: GetAgentFromAll :one
With x As (
 SELECT users.id, users.username  FROM broker_company_agents
  INNER JOIN users ON broker_company_agents.users_id = users.id
  WHERE  
        users.id = $1
    UNION ALL 
  SELECT users.id, users.username  FROM broker_company_branches_agents
  INNER JOIN users ON broker_company_branches_agents.users_id = users.id
  WHERE  
            users.id = $1
  UNION ALL
  SELECT users.id, users.username  FROM freelancers
  INNER JOIN users ON freelancers.users_id = users.id  
  WHERE  
       users.id = $1
) SELECT * FROM x LIMIT 1;


-- name: GetBrokerAgentByUserId :one
SELECT * FROM broker_company_agents WHERE users_id = $1;


-- name: GetBrokerBranchAgentByUserId :one
SELECT * FROM broker_company_branches_agents WHERE users_id = $1;

-- name: UpdateBrokerAgentByStatus :one
UPDATE broker_company_agents SET status = $2 WHERE id = $1 RETURNING *;

-- name: GetBrokerAgentsByUserID :one
select * from broker_company_agents where users_id=$1;