-- name: CreateSubscriptionProduction :exec
INSERT INTO
    subscription_products (
        product,
        icon_url,
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
        $6
    );

-- name: UpdateSubscriptionProduction :exec
UPDATE
    subscription_products
SET
    product = $1,
    icon_url = $2,
    updated_at = $3
WHERE
    id = $4
    AND status != 6;

-- name: GetSingleSubscriptionProduction :one 
SELECT
    *
FROM
    subscription_products
WHERE
    id = $1
    AND status != 6;

-- name: GetAllSubscriptionProductions :many
SELECT
    *
FROM
    subscription_products
WHERE
    status = @status::BIGINT
ORDER BY updated_at DESC
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetAllSubscriptionProductionsCount :one
SELECT
    count(*)
FROM
    subscription_products
WHERE
    status = @status::BIGINT;


-- name: ChangeStatusSubscriptionProductions :one
UPDATE
    subscription_products
SET
    status = $2,
    updated_at = $3
WHERE
    subscription_products.id = $1
    AND (
        $2 != 6 OR NOT (
            EXISTS (
                SELECT 1
                FROM subscription_cost
                WHERE subscription_cost.product = $1
            )
            OR EXISTS (
                SELECT 1
                FROM subscription_package
                WHERE subscription_package.product = $1
            )
            OR EXISTS (
                SELECT 1
                FROM agent_products
                WHERE agent_products.product = $1
            )
            OR EXISTS (
                SELECT 1
                FROM subscription_consuming
                WHERE subscription_consuming.product = $1
            )
        )
    )RETURNING *;





