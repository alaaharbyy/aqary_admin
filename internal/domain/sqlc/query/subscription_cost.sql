-- name: CreateSubscriptionCost :exec
INSERT
    INTO subscription_cost(
        countries_id,
        subscriber_type_id,
        category_id,
        product,
        price_per_unit,
        created_by,
        created_at,
        updated_at,
        status
    )
VALUES(
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9
    );

-- name: UpdateSubscriptionCost :exec 
UPDATE 
    subscription_cost
SET 
    countries_id=$2, 
    subscriber_type_id=$3, 
    category_id=$4, 
    product=$5, 
    price_per_unit=$6, 
    updated_at=$7
WHERE id=$1 AND status!=6; 



-- name: GetSubscriptionCost :one
SELECT
    subscription_cost.*,
    company_category.category_name,
    company_category.category_name_ar,
    subscription_products.product,
    CASE
        subscription_cost.subscriber_type_id
        WHEN 1 THEN 'company'
        WHEN 2 THEN 'freelance'
        WHEN 3 THEN 'owner'
    END
FROM
    subscription_cost
    LEFT JOIN company_category ON company_category.id = subscription_cost.category_id
    AND company_category.status != 6
    INNER JOIN subscription_products ON subscription_products.id = subscription_cost.product
    AND subscription_products.status != 6
WHERE
    subscription_cost.id = $1
    AND subscription_cost.status != 6;



-- name: GetAllSubscriptionCost :many
SELECT
    subscription_cost.*,
    company_category.category_name,
    company_category.category_name_ar,
    subscription_products.product AS product_name,
    countries.country, 
    CASE
        subscription_cost.subscriber_type_id
        WHEN 1 THEN 'company'
        WHEN 2 THEN 'freelance'
        WHEN 3 THEN 'owner'
    END::VARCHAR AS  subscriber_type
FROM
    subscription_cost
    LEFT JOIN company_category ON company_category.id = subscription_cost.category_id
    AND company_category.status != 6
    INNER JOIN subscription_products ON subscription_products.id = subscription_cost.product
    AND subscription_products.status != 6
    INNER JOIN countries ON countries.id=subscription_cost.countries_id
WHERE
    subscription_cost.status = @status::BIGINT
ORDER BY subscription_cost.updated_at DESC
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');


-- name: GetAllSubscriptionCostCount :one
SELECT
    count(subscription_cost.id)
FROM
    subscription_cost
    INNER JOIN subscription_products ON subscription_products.id = subscription_cost.product
    AND subscription_products.status != 6
    INNER JOIN countries ON countries.id=subscription_cost.countries_id
WHERE
    subscription_cost.status = @status::BIGINT;


-- name: ChangeStatusSubscriptionCost :exec 
UPDATE 
    subscription_cost
SET 
    status=$1,
    updated_at=$2
WHERE id=$3; 
