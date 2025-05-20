

-- name: CreateAgentProducts :one
INSERT INTO agent_products( 
   company_user_id, -- the current registered user 
   product, -- subscription_products
   no_of_products, -- how many units 
   created_by,
   created_at,
   updated_at    
)VALUES(
   $1,$2, $3, $4, $5, $6
) RETURNING *;



-- name: UpdateAgentProductsByCompUserID :one
Update agent_products
SET no_of_products = $2
WHERE company_user_id = $1 And agent_products.product =  @product_id
RETURNING *;


-- -- name: UpdateRemainingSubscriptionPackage :one
-- Update subscription_package
-- SET remained_units = $1
-- WHERE id = @package_id
-- RETURNING *;


-- -- name: GetRemainingCompanyQuota :many
-- SELECT DISTINCT ON (subscription_products.id)
--     subscription_products.id, subscription_products.product,
--     SUM(subscription_package.remained_units) OVER (PARTITION BY subscription_products.id) AS total_no_of_products
--  FROM 
--     subscription_order
-- INNER JOIN 
--     subscription_package ON subscription_order.id = subscription_package.subscription_order_id
-- INNER JOIN 
--     subscription_products ON subscription_package.product = subscription_products.id 
-- WHERE 
--     subscriber_id = @company_id 
--     AND subscriber_type = 1 
--     AND subscription_order.status = 1
-- ORDER BY
--     subscription_products.id,
--     subscription_products.product;

-- name: GetRemainingCreditToAssignAgentByCompany :many
WITH AssignedProducts AS (
    SELECT 
        sp.id AS product_id,
        SUM(ap.no_of_products) AS assigned
    FROM agent_products ap
    INNER JOIN subscription_products sp ON sp.id = ap.product
    INNER JOIN company_users cu ON cu.id = ap.company_user_id
    WHERE cu.company_id = $1
    GROUP BY sp.id
),
SubscribedProducts AS (
    SELECT 
        sp.id AS product_id,
        SUM(spk.no_of_products) AS total_no_of_products
    FROM subscription_order so
    INNER JOIN subscription_package spk ON so.id = spk.subscription_order_id
    INNER JOIN subscription_products sp ON spk.product = sp.id
    WHERE so.subscriber_id = $1
        AND so.subscriber_type = 1
        AND so.status = 2
    GROUP BY sp.id
)
SELECT 
    sp.id AS product_id,
    sp.product,
    COALESCE(spd.total_no_of_products, 0)::bigint AS total,
    (COALESCE(spd.total_no_of_products, 0) - COALESCE(ap.assigned, 0))::bigint AS remaining
FROM subscription_products sp
LEFT JOIN AssignedProducts ap ON sp.id = ap.product_id
INNER JOIN SubscribedProducts spd ON sp.id = spd.product_id
ORDER BY sp.id;

-- name: GetAssignCreditByAgentIdAndProduct :one
 SELECT
        ap.no_of_products AS assigned
    FROM agent_products ap
    INNER JOIN subscription_products sp ON sp.id = ap.product
    INNER JOIN company_users cu ON cu.id = ap.company_user_id
    WHERE ap.company_user_id = $1 AND sp.id = $2;
