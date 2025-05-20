-- name: CreateAgentSubscriptionQuotaBranch :one
INSERT INTO agent_subscription_quota_branch (
     standard,
     featured,
     premium,
     top_deal,
    created_at,
    updated_at,
    broker_company_branches_agents_id,
    ref_no
)VALUES (
    $1, $2, $3,$4, $5, $6, $7, $8
) RETURNING *;


-- name: GetAgentSubscriptionQuotaBranch :one
SELECT * FROM agent_subscription_quota_branch 
WHERE id = $1 LIMIT $1;

 
 
-- name: GetAllAgentSubscriptionQuotaBranch :many
SELECT * FROM agent_subscription_quota_branch
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateAgentSubscriptionQuotaBranch :one
UPDATE agent_subscription_quota_branch
SET  standard = $2,
    featured = $3,
    premium = $4,
    top_deal = $5,
    created_at = $6,
    updated_at = $7,
    broker_company_branches_agents_id = $8,
    ref_no = $9
Where id = $1
RETURNING *;


-- name: DeleteAgentSubscriptionQuotaBranch :exec
DELETE FROM agent_subscription_quota_branch
Where id = $1;



-- name: GetAgentSubscriptionQuotaBranchByBrokerCompanyAgentID :one
SELECT * FROM agent_subscription_quota_branch
Where broker_company_branches_agents_id = $1;



-- name: UpdateAgentSubscriptionQuotaBranchByBrokerCompanyBranchAgentID :one
UPDATE agent_subscription_quota_branch
SET  standard = $2,
    featured = $3,
    premium = $4,
    top_deal = $5,
    updated_at = $6
Where  broker_company_branches_agents_id = $1
RETURNING *;
