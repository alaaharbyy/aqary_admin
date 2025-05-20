-- name: CreateAgentSubscriptionQuota :one
INSERT INTO agent_subscription_quota (
     standard,
     featured,
     premium,
     top_deal,
     created_at,
     updated_at,
     broker_company_agents_id,
     ref_no
)VALUES (
    $1, $2, $3, $4 , $5, $6, $7, $8
) RETURNING *;

 
-- name: GetAgentSubscriptionQuota :one
SELECT * FROM agent_subscription_quota 
WHERE id = $1 LIMIT $1;

-- name: GetAllAgentSubscriptionQuota :many
SELECT * FROM agent_subscription_quota
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateAgentSubscriptionQuota :one
UPDATE agent_subscription_quota
SET standard = $2,
     featured = $3,
     premium = $4,
     top_deal = $5,
     created_at = $6,
     updated_at = $7,
     broker_company_agents_id = $8,
     ref_no= $9
Where id = $1
RETURNING *;

-- name: DeleteAgentSubscriptionQuota :exec
DELETE FROM agent_subscription_quota
Where id = $1;




-- name: GetAgentSubscriptionQuotaByBrokerCompanyAgentID :one
SELECT * FROM agent_subscription_quota
Where broker_company_agents_id = $1;



-- name: UpdateAgentSubscriptionQuotaByBrokerCompanyAgentID :one
UPDATE agent_subscription_quota
SET  standard = $2,
    featured = $3,
    premium = $4,
    top_deal = $5,
    updated_at = $6
Where  broker_company_agents_id = $1
RETURNING *;

