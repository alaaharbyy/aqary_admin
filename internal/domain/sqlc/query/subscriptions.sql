

-- name: CreateSubscriptionPrice :one
INSERT INTO subscriptions_price (
    countries_id, subscription_name, price, created_by, created_at, updated_at
) VALUES (
    $1, $2, $3, $4, NOW(), NOW()
) RETURNING id, countries_id, subscription_name, price, created_by, created_at, updated_at;



-- name: GetSubscriptionPrice :one
SELECT id, countries_id, subscription_name, price, created_by, created_at, updated_at
FROM subscriptions_price
WHERE id = $1;


-- name: GetSubscriptionPriceByName :one
SELECT *
FROM subscriptions_price
WHERE subscription_name = $1 AND countries_id = $2;



-- name: ListSubscriptionsPrice :many
SELECT id, countries_id, subscription_name, price, created_by, created_at, updated_at
FROM subscriptions_price
ORDER BY id LIMIT $1 OFFSET $2;


-- name: CountSubscriptionsPrice :one
SELECT COUNT(*) FROM subscriptions_price;



-- name: UpdateSubscriptionPrice :one
UPDATE subscriptions_price
SET countries_id = $2,
    subscription_name = $3,
    price = $4,
    updated_at = NOW()
WHERE id = $1
RETURNING id, countries_id, subscription_name, price, created_by, created_at, updated_at;


-- name: DeleteSubscriptionPrice :one
DELETE FROM subscriptions_price
WHERE id = $1 AND countries_id= $2
RETURNING *;
