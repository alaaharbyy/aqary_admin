-- name: GetAllAgentReviews :many
SELECT 
    ar.id as agent_review_id,
    u.username as reviewer_username,
    ar.reviewer AS reviewer_user_id,
    p.first_name as agent_first_name,
    p.last_name as agent_last_name, 
    ar.agent_id,
    ar.agent_knowledge,
    ar.agent_expertise,
    ar.agent_responsiveness,
    ar.agent_negotiation,
    ar.review,
    COALESCE(bc.company_name, bcb.company_name) AS company_name
FROM agent_reviews ar 
JOIN users as u ON ar.reviewer=u.id
JOIN profiles as p ON p.id=ar.agent_id
LEFT JOIN broker_companies bc ON ar.companies_id = bc.id AND ar.is_branch = false
LEFT JOIN broker_companies_branches bcb ON ar.companies_id = bcb.id AND ar.is_branch = true
LIMIT $1
OFFSET $2;
 
-- name: GetCountAgentReviews :one
SELECT COUNT(*) FROM agent_reviews;

-- name: GetAgentsReviewsForCompanyCount :one
SELECT 
  count(*)
FROM agent_reviews ar 
where ar.companies_id=$1 and ar.is_branch=$2;

-- name: GetAllAgentReviewsForAgent :many
SELECT    
    ar.id as agent_review_id,
    -- reviewer details
    ar.reviewer AS reviewer_user_id,
    u.username as reviewer_username,
    u.email as reviewer_email,
    -- agent details
    ar.agent_id,
    COALESCE(bca.users_id, bcba.users_id) AS agent_user_id,
    COALESCE(bca.broker_companies_id, bcba.broker_companies_branches_id) AS companies_id,
    p.first_name as agent_first_name,
    p.last_name as agent_last_name,    
    -- review details
    ar.agent_knowledge,
    ar.agent_expertise,
    ar.agent_responsiveness,
    ar.agent_negotiation,
    ar.review,
   ar.proof_images,
   ar.title
FROM agent_reviews ar
JOIN users u on u.id=ar.reviewer
JOIN users ua on ua.id=$3
JOIN profiles p on p.id=ua.profiles_id
LEFT JOIN broker_company_agents bca ON bca.id = ar.agent_id AND ar.is_branch = false AND bca.broker_companies_id = ar.companies_id
LEFT JOIN broker_company_branches_agents bcba ON bcba.id = ar.agent_id AND ar.is_branch = true AND bcba.broker_companies_branches_id = ar.companies_id
WHERE COALESCE(bca.users_id, bcba.users_id) = $3
ORDER BY ar.id DESC
LIMIT $1
OFFSET $2;

-- name: GetAgentReviewsForAgentCount :one
SELECT    
count(*)
FROM agent_reviews ar
LEFT JOIN broker_company_agents bca ON bca.id = ar.agent_id AND ar.is_branch = false AND bca.broker_companies_id = ar.companies_id
LEFT JOIN broker_company_branches_agents bcba ON bcba.id = ar.agent_id AND ar.is_branch = true AND bcba.broker_companies_branches_id = ar.companies_id
WHERE COALESCE(bca.users_id, bcba.users_id) = $1;

-- name: GetAllAgentsReviewsForAdmin :many
SELECT 
    -- company details
    ar.companies_id,
    j.company_name,
    --reviewer details
    ar.reviewer AS reviewer_user_id,
    u.username as reviewer_username,
    u.email as reviewer_email,
     --agent details
     COALESCE(bca.users_id, bcba.users_id) as agent_user_id,
    p.first_name as agent_first_name,
    p.last_name as agent_last_name, 
    -- review details
    ar.id as agent_review_id,
    ar.agent_id,
    ar.agent_knowledge,
    ar.agent_expertise,
    ar.agent_responsiveness,
    ar.agent_negotiation,
    ar.review ,
   ar.proof_images,
   ar.title
FROM agent_reviews ar
JOIN users u on u.id=ar.reviewer
LEFT JOIN broker_company_agents bca ON bca.id = ar.agent_id AND ar.is_branch = false AND bca.broker_companies_id = ar.companies_id
LEFT JOIN broker_company_branches_agents bcba ON bcba.id = ar.agent_id AND ar.is_branch = true AND bcba.broker_companies_branches_id = ar.companies_id
JOIN (
        SELECT id AS company_id, 1 AS company_type, FALSE AS is_branch, users_id,company_name FROM broker_companies
        WHERE broker_companies.users_id = $1
        UNION ALL
        SELECT id AS company_id, 1 AS company_type, TRUE AS is_branch, users_id,company_name FROM broker_companies_branches
        WHERE broker_companies_branches.users_id = $1
) AS j
ON ar.companies_id = j.company_id AND ar.is_branch = j.is_branch
left JOIN users ua ON ua.id = COALESCE(bca.users_id, bcba.users_id)
left JOIN profiles p ON p.id = ua.profiles_id
order by j.company_id
LIMIT $2
OFFSET $3;

-- name: GetAgentsReviewsCountForAdmin :one
SELECT 
   count(*)
FROM agent_reviews ar
JOIN (
   
        SELECT id AS company_id, 1 AS company_type, FALSE AS is_branch, users_id,company_name FROM broker_companies
        WHERE broker_companies.users_id = $1
        UNION ALL
        SELECT id AS company_id, 1 AS company_type, TRUE AS is_branch, users_id,company_name FROM broker_companies_branches
        WHERE broker_companies_branches.users_id =$1
     
) AS x
ON ar.companies_id = x.company_id AND ar.is_branch = x.is_branch;