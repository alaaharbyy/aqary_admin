




 






 






------------------------------------------------------------------------------------



















-- name: GetAllSubscriptionOrders :many    
SELECT
    so.id,
    so.order_no,
    so.start_date,
    so.end_date,
    so.total_amount,
    so.no_of_payments,
    so.payment_plan,
    so.status,
    ad.countries_id,
    TRIM(CONCAT(countries.alpha3_code, ', ', states.state)) AS location,
    CASE
        WHEN so.subscriber_type = 1 THEN companies.company_name
        ELSE TRIM(CONCAT(pr.first_name, ' ', pr.last_name))
    END::VARCHAR AS "subscriber_name",
    so.subscriber_type,
    CASE
        WHEN so.subscriber_type = 2 THEN 'Freelancer'
        WHEN so.subscriber_type = 3 THEN 'Owner'
        ELSE company_category.category_name
    END::VARCHAR AS "category_name",
    CASE WHEN (so.contract_file IS NULL OR so.contract_file = '') THEN so.draft_contract ELSE so.contract_file END::VARCHAR AS contract_file 
FROM
    subscription_order so
    LEFT JOIN companies ON so.subscriber_type = 1
    AND companies.status != 6
    AND companies.id = so.subscriber_id
    LEFT JOIN users ON so.subscriber_type IN (2, 3)
    AND users.status != 6
    AND users.id = so.subscriber_id 
    AND users.user_types_id IN (3, 4)
    LEFT JOIN profiles pr ON so.subscriber_type IN (2, 3)
    AND users.id = pr.users_id
    LEFT JOIN company_activities ON companies.company_activities_id[1] = company_activities.id
    LEFT JOIN company_category ON company_activities.company_category_id = company_category.id
    LEFT JOIN addresses ad ON ad.id = CASE WHEN so.subscriber_type = 2 THEN pr.addresses_id WHEN  so.subscriber_type = 3 THEN pr.addresses_id WHEN so.subscriber_type = 1 THEN companies.addresses_id END
    LEFT JOIN countries ON ad.countries_id = countries.id
    LEFT JOIN states ON ad.states_id = states.id
WHERE
      (users.status!=6 OR companies.status!=6)
ORDER BY so.updated_at DESC 
LIMIT $1 
OFFSET $2;


-- name: GetNumberOFSubscriptionOrders :one
SELECT
    COUNT(*)
FROM
    subscription_order so
LEFT JOIN companies ON so.subscriber_type = 1
    AND companies.status != 6
    AND companies.id = so.subscriber_id
    LEFT JOIN users ON so.subscriber_type IN (2, 3)
    AND users.status != 6
    AND users.id = so.subscriber_id 
    AND users.user_types_id=  so.subscriber_type

WHERE
    so.status != 6 AND (users.status!=6 OR companies.status!=6);


-- name: GetSubscriptionOrdersByCompany :many    
SELECT 
  so.id AS subscription_order_id, 
  so.order_no,
  companies.company_name::VARCHAR AS "subscriber_name", 
  so.start_date, 
  so.end_date, 
  so.total_amount, 
  so.status,
  JSON_AGG(
    JSON_BUILD_OBJECT(
      'product', sp.product, 'product_name', 
      spp.product, 'no_of_products', sp.no_of_products, 
      'product_discount', sp.product_discount,
      'original_price_per_unit', sp.original_price_per_unit,
      'start_date', sp.start_date,
      'end_date', sp.end_date
    )
  ) AS products 
FROM 
  subscription_order so 
  JOIN subscription_package sp ON so.id = sp.subscription_order_id 
  LEFT JOIN subscription_products spp ON sp.product = spp.id 
  LEFT JOIN companies ON companies.id = so.subscriber_id 
  AND companies.status != 6
  LEFT JOIN addresses ad ON ad.id = companies.addresses_id 
  LEFT JOIN countries ON ad.countries_id = countries.id 
  LEFT JOIN states ON ad.states_id = states.id 
WHERE 
  so.subscriber_id = @company_id::bigint
  AND so.subscriber_type = 1 
  AND so.status != 6
  AND CASE WHEN @type::bigint = 0 THEN so.total_amount = 0 ELSE so.total_amount > 0 END 
GROUP BY 
  so.id, 
  companies.company_name, 
  so.start_date, 
  so.end_date, 
  so.total_amount 
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');


-- name: GetSubscriptionOrdersCountByCompany :one
SELECT
    COUNT(*)
FROM
    subscription_order so
LEFT JOIN companies ON companies.id = so.subscriber_id
WHERE
    so.status != 6 AND companies.status!=6
    AND companies.id = @company_id::bigint
    AND so.subscriber_type = 1 
    AND CASE WHEN @type::bigint = 0 THEN so.total_amount = 0 ELSE so.total_amount > 0 END ;


-- name: GetSubscriptionOrderDetail :many  
SELECT so.*,
CASE
        WHEN so.subscriber_type = 1 THEN companies.company_name
        ELSE TRIM(CONCAT(pr.first_name, ' ', pr.last_name))
    END::VARCHAR AS "subscriber_name",
    company_types.id AS company_type_id,
    company_types.title AS company_type_title,
    company_types.title_ar AS company_type_title_ar,
    JSON_AGG(subscription_package) AS packages FROM  subscription_order so
INNER JOIN subscription_package ON subscription_package.subscription_order_id = so.id
LEFT JOIN companies ON so.subscriber_type = 1
    AND companies.id = so.subscriber_id
 LEFT JOIN company_types ON company_types.id = companies.company_type
    LEFT JOIN users ON so.subscriber_type IN (2, 3)
    AND users.id = so.subscriber_id 
    AND users.user_types_id IN (3, 4)
    LEFT JOIN profiles pr ON so.subscriber_type IN (2, 3)
    AND users.id = pr.users_id
WHERE order_no = $1
GROUP BY so.id,companies.id,pr.id,company_types.id;


-- name: GetAllPaymentsBySubscriptionOrder :many
SELECT p.*, so.order_no
-- ba.bank_name AS bank
FROM payments p
INNER JOIN subscription_order so ON p.order_id = so.id
-- LEFT JOIN bank_account_details ba ON p.bank != null
-- AND p.bank = ba.id
WHERE so.id = $3
ORDER BY p.updated_at DESC 
LIMIT $1 
OFFSET $2;

-- name: GetAllPaymentsBySubscriptionOrderCounts :one
SELECT COUNT(p.id)
FROM payments p
WHERE p.order_id = $1;

-- name: GetOverDuePayments :many
SELECT id, order_id, due_date, amount
FROM payments
WHERE due_date < CURRENT_TIMESTAMP
AND status = 1 
AND order_id = $1
ORDER BY due_date ASC;



-- name: GetAgentProductByUserID :many   
SELECT 
    u.id AS user_id,
   subscription_products.product,
    ap.no_of_products
FROM 
    users u
JOIN 
    company_users cu ON u.id = cu.users_id
LEFT JOIN 
    agent_products ap ON cu.id = ap.company_user_id
    
INNER JOIN subscription_products ON ap.product =  subscription_products.id
WHERE 
    u.id = @user_id;  


-- name: GetAgentProducts :one
SELECT * FROM agent_products
WHERE company_user_id = @company_user_id AND product = @product_id;