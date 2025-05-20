-- Create a new subscription order and return the inserted row
-- name: CreateSubscriptionOrder :one
INSERT INTO "subscription_order" (
    "order_no", 
    "subscriber_id", 
    "subscriber_type", 
    "start_date", 
    "end_date", 
    "sign_date", 
    "total_amount", 
    "vat", 
    "no_of_payments", 
    "payment_plan", 
    "notes", 
    "status", 
    "created_by",
    "draft_contract"
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14
)
RETURNING *;




-- Get a subscription order by ID
-- name: GetSubscriptionOrder :one
SELECT * FROM "subscription_order"
WHERE "id" = $1;

-- Update a subscription order and return the updated row
-- name: UpdateSubscriptionOrder :one
UPDATE "subscription_order"
SET  
    "start_date" = $2, 
    "end_date" = $3, 
    "total_amount" = $4, 
    "no_of_payments" = $5, 
    "payment_plan" = $6, 
    "notes" = $7, 
    "updated_at" = $8
WHERE "id" = $1
RETURNING *;


-- Delete a subscription order by ID
-- name: DeleteSubscriptionOrder :exec
DELETE FROM "subscription_order"
WHERE "id" = $1;

-- List all subscription orders
-- name: ListSubscriptionOrders :many
SELECT * FROM "subscription_order"
ORDER BY "created_at" DESC;


-- name: GetSubscriptionOrderBySubscriberIDAndType :many
SELECT * FROM subscription_order 
WHERE subscriber_id = $1 AND subscriber_type = $2;

-- name: GetSubscriptionOrderBySubscriberID :one
SELECT * FROM subscription_order 
WHERE subscriber_id = $1;

-- name: GetCompaniesByLocationAndTypeID :many
SELECT companies.id, companies.company_name
FROM companies 
LEFT JOIN addresses ON companies.addresses_id = addresses.id
WHERE companies.company_type = @company_type::bigint
AND companies.status NOT IN (5,6)
AND 
(CASE WHEN @country_id::bigint = 0 THEN true ELSE addresses.countries_id = @country_id::bigint END)
AND 
(CASE WHEN @sub_communities::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_communities::bigint END)
AND
(CASE WHEN @communities::bigint = 0 THEN true  ELSE addresses.communities_id = @communities::bigint END)
AND
(CASE WHEN @cities::bigint = 0 THEN true ELSE addresses.cities_id = @cities::bigint END)
AND
(CASE WHEN @states::bigint = 0 THEN true  ELSE addresses.states_id = @states::bigint END);

-- name: CheckIfSubscriptionOrderExistBySubscriberId :one
SELECT * FROM subscription_order WHERE status != 4 AND subscriber_id = $1 AND subscriber_type = $2 AND total_amount = $3;

-- name: CreateOrderPayment :one
INSERT INTO payments(
    order_id,
    due_date,
    payment_method,
    amount,
    payment_date,
    bank,
    cheque_no,
    invoice_file,
    status,
    created_by
)VALUES(
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10
)RETURNING *;

-- name: CreateInitialOrderPaymentBulk :exec
INSERT INTO payments(
    order_id,
    due_date,
    amount,
    created_by
)VALUES(
    @order_id,
    unnest(@due_date::timestamptz[]),
    @amount,
    @created_by
);

-- name: UpdateOrderPayment :one
UPDATE payments
SET payment_method = $2,
    payment_date = $3,
    bank = $4,
    cheque_no = $5,
    invoice_file = $6,
    reference_no = $7,
    status = $8
WHERE id = $1
RETURNING *;

-- name: ActivateSubscriptionOrder :one
UPDATE subscription_order
SET status = @status
WHERE id = @id
RETURNING *;

-- name: GetOrderPaymentById :one
SELECT payments.*,order_no FROM payments
INNER JOIN subscription_order ON subscription_order.id = payments.order_id
WHERE payments.id = $1;

-- name: GetLatestSubscriptionProductCost :many
WITH RankedCosts AS (
    SELECT
        sc.id,
        sc.price_per_unit,
        sp.id AS product_id,
        sp.product,
        sc.created_at,
        ROW_NUMBER() OVER (
            PARTITION BY sc.product
            ORDER BY sc.created_at DESC
        ) AS rn
    FROM
        subscription_cost sc
        INNER JOIN subscription_products sp ON sp.id = sc.product
        LEFT JOIN companies ON companies.id = @subscriber_id AND @subscriber_type_id::bigint = 1 -- when  subscriber type is company
        LEFT JOIN addresses a1 ON a1.id = companies.addresses_id
        LEFT JOIN company_activities ON company_activities.id = ANY(companies.company_activities_id)
        LEFT JOIN company_category ON company_category.id = company_activities.company_category_id
        LEFT JOIN users ON users.id = @subscriber_id AND @subscriber_type_id::bigint != 1 -- when  subscriber type is freelancer or owner
        LEFT JOIN profiles ON profiles.users_id = users.id
        LEFT JOIN addresses a2 ON a2.id = profiles.addresses_id
    WHERE
        sc.subscriber_type_id = @subscriber_type_id::bigint
        AND (CASE WHEN @subscriber_type_id::bigint = 1 THEN sc.countries_id = a1.countries_id ELSE sc.countries_id = a2.countries_id END)
        AND (
            @subscriber_type_id::bigint != 1 -- when  subscriber type is freelancer or owner
            OR sc.category_id = company_category.id -- when subscriber type is company
        ) AND sp.id = ANY(@product_constant_ids::bigint[])
)
SELECT
    id,
    price_per_unit,
    product_id,
    product AS product_name
FROM
    RankedCosts
WHERE
    rn = 1;

-- name: GetSubscriptionOrderPackageDetail :many
SELECT 
    subscription_order.id,
    subscription_order.order_no,
    subscription_order.start_date AS subscription_start_date,
    subscription_order.end_date AS subscription_end_date,
    subscription_products.product,
    subscription_package.no_of_products,
    subscription_package.original_price_per_unit,
    subscription_package.product_discount,
    subscription_package.start_date,
    subscription_package.end_date
FROM subscription_order
INNER JOIN subscription_package ON subscription_package.subscription_order_id = subscription_order.id
INNER JOIN subscription_products ON subscription_package.product = subscription_products.id
WHERE subscription_order.order_no = $1;


-- -- name: GetCompanyLatestActiveSubscriptionOrder :many
-- SELECT
--     subscription_products.product,
--     subscription_products.id AS product_id,
--     SUM(subscription_package.no_of_products) AS total_no_of_products
-- FROM
--     subscription_order
-- INNER JOIN
--     subscription_package ON subscription_order.id = subscription_package.subscription_order_id
-- INNER JOIN
--     subscription_products ON subscription_package.product = subscription_products.id
-- WHERE
--     subscriber_id = @company_id
--     AND subscriber_type = 1
--     AND subscription_order.status = 2 -- active subscription order
-- GROUP BY 
--     subscription_products.id, subscription_products.product
-- ORDER BY 
--     subscription_products.id;





-- name: GetSubscriptionOrderPackageDetailByUserID :many
SELECT
    subscription_order.id as order_id, 
    subscription_package.id, 
    subscription_products.product, 
  	subscription_package.no_of_products,
  	subscription_package.product_discount,
  	subscription_package.original_price_per_unit,
  	 -- total units 
  	 subscription_order.total_amount,
  	 -- duration
  	  subscription_package.start_date,
  	  subscription_package.end_date,
  	  subscription_order.status
FROM subscription_order
INNER JOIN subscription_package ON subscription_package.subscription_order_id = subscription_order.id
INNER JOIN subscription_products ON subscription_package.product = subscription_products.id 
WHERE  subscription_order.subscriber_type = @subscription_type AND CASE WHEN @free=0 THEN true ELSE  subscription_order.total_amount  = 0  END
AND CASE WHEN @paid=0 THEN true ELSE  subscription_order.total_amount  != 0  END AND subscription_order.subscriber_id = @subscriber_id; 



-- name: DeleteSubscriptionOrderPayments :exec
DELETE FROM payments
USING subscription_order
WHERE payments.order_id = subscription_order.id 
AND subscription_order.order_no = $1 
AND payments.status = 1 -- only unpaid
AND subscription_order.status = 1;  -- only draft subscription order

-- name: InActiveSubscriptionOrder :one
UPDATE subscription_order
SET status = 3
WHERE order_no = $1 AND status != 4 -- exclude expired subscription order
RETURNING *;

-- name: GetSubscriptionOrderByOrderNo :many
SELECT * FROM subscription_order
WHERE order_no = $1;

-- name: GetSubscriptionByOrderNo :one
SELECT * FROM subscription_order
WHERE order_no = $1;

-- name: GetSubscriptionOrderDetailsForContract :many
WITH licenses AS (
SELECT * FROM license WHERE license.license_type_id IN (1,2) AND entity_type_id IN (6,9)
)SELECT
    so.id AS subscription_order_id,
    so.start_date AS contract_start_date,
    so.end_date AS contract_end_date,
    so.total_amount,
    
   CASE WHEN so.subscriber_type IN (2,3) THEN CONCAT(p.first_name, ' ', p.last_name) ELSE companies.company_name END::VARCHAR AS subscriber_name,
   CASE WHEN so.subscriber_type IN (2,3) THEN p.ref_no ELSE companies.ref_no END::VARCHAR AS ref_no,
    
    companies.vat_no AS tax_registration_no,
    
    CONCAT(p.first_name, ' ', p.last_name)::VARCHAR AS user_name,
   a.email::VARCHAR AS email,
    a.phone_number AS user_phone,
   addr.full_address::VARCHAR AS address,
   a.user_types_id::bigint AS user_type,
    notes,
    -- Aggregate the license numbers into single columns
    MAX(CASE WHEN licenses.license_type_id = 1 THEN licenses.license_no ELSE '' END)::VARCHAR AS commercial_no,
    MAX(CASE WHEN licenses.license_type_id = 2 THEN licenses.license_no ELSE '' END)::VARCHAR AS rera_no
FROM
    subscription_order so
    LEFT JOIN companies ON companies.id = so.subscriber_id AND so.subscriber_type = 1
        LEFT JOIN users a ON a.id = CASE WHEN so.subscriber_type = 1 THEN companies.users_id ELSE so.subscriber_id END
    LEFT JOIN profiles p ON p.users_id = a.id
    LEFT JOIN addresses addr ON addr.id = CASE WHEN so.subscriber_type = 1 THEN companies.addresses_id ELSE p.addresses_id END
    LEFT JOIN licenses ON licenses.entity_id = companies.id  AND so.subscriber_type = 1
    
WHERE
    order_no = $1
    GROUP BY
    so.id,
    companies.id,
    p.id,
    a.id,
    addr.id;

-- name: GetPackageDetailsForContract :one
SELECT
      subscription_order_id, 
    
 	COALESCE(MAX(CASE WHEN product = 1 THEN no_of_products END),0)::bigint AS standard,
    COALESCE(MAX(CASE WHEN product = 1 THEN product_discount END),0)::float AS standard_discount,
    COALESCE(MAX(CASE WHEN product = 1 THEN original_price_per_unit END),0)::float AS standard_unit_price,
  COALESCE( MAX(CASE WHEN product = 1 THEN start_date END),'0001-01-01')::DATE AS standard_start_date,
    COALESCE(MAX(CASE WHEN product = 1 THEN end_date  END),'0001-01-01')::DATE AS standard_end_date,
   
    
   COALESCE(MAX(CASE WHEN product = 2 THEN no_of_products END),0)::bigint AS featured,
   COALESCE(MAX(CASE WHEN product = 2 THEN product_discount END),0)::float AS featured_discount,
   COALESCE(MAX(CASE WHEN product = 2 THEN original_price_per_unit END),0)::float AS featured_unit_price,
  COALESCE(  MAX(CASE WHEN product = 2 THEN start_date END),'0001-01-01')::DATE AS featured_start_date,
  COALESCE(  MAX(CASE WHEN product = 2 THEN end_date END),'0001-01-01')::DATE AS featured_end_date,
    
    
   COALESCE(MAX(CASE WHEN product = 3 THEN no_of_products END),0)::bigint AS premium,
   COALESCE(MAX(CASE WHEN product = 3 THEN product_discount END),0)::float AS premium_discount,
   COALESCE(MAX(CASE WHEN product = 3 THEN original_price_per_unit END),0)::float AS premium_unit_price,
  COALESCE(  MAX(CASE WHEN product = 3 THEN start_date END),'0001-01-01')::DATE AS premium_start_date,
 COALESCE(   MAX(CASE WHEN product = 3 THEN end_date END),'0001-01-01')::DATE AS premium_end_date, 
    
    COALESCE(MAX(CASE WHEN product = 4 THEN no_of_products END),0)::bigint AS topdeals,
   COALESCE(MAX(CASE WHEN product = 4 THEN product_discount END),0)::float AS topdeals_discount,
   COALESCE(MAX(CASE WHEN product = 4 THEN original_price_per_unit END),0)::float AS topdeals_unit_price,
  COALESCE(  MAX(CASE WHEN product = 4 THEN start_date END),'0001-01-01')::DATE AS topdeals_start_date,
  COALESCE(  MAX(CASE WHEN product = 4 THEN end_date END),'0001-01-01')::DATE AS topdeals_end_date
FROM (
    SELECT 
    
        subscription_order_id, 
        no_of_products,
        product, 
        product_discount,
        original_price_per_unit,
        start_date,
        end_date, 
        ROW_NUMBER() OVER (PARTITION BY subscription_order_id ORDER BY id) AS row_num
    FROM 
        subscription_package
    WHERE 
        subscription_order_id = $1
) AS numbered_packages
GROUP BY subscription_order_id;

-- name: GetAllSubscriberContracts :many
SELECT 
companies.ref_no,companies.company_name,
subscription_order.start_date,subscription_order.end_date,
subscription_order.status,subscription_order.order_no,
subscription_order.contract_file,
subscription_order.draft_contract,
COUNT(subscription_order.id) OVER() AS total_count
FROM subscription_order
LEFT JOIN companies ON companies.id = subscription_order.subscriber_id AND subscription_order.subscriber_type = 1 -- company subscriber
WHERE companies.status IN (8,9)
LIMIT sqlc.narg('limit') OFFSET sqlc.narg('offset');


-- name: AddFinalContractFile :exec
UPDATE subscription_order SET contract_file = $1 WHERE id = $2;

-- name: AddDraftContractFile :exec
UPDATE subscription_order SET draft_contract = $1 WHERE id = $2;