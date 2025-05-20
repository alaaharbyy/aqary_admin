-- Create a new subscription package
-- name: CreateSubscriptionPackage :one
INSERT INTO "subscription_package" (
    "subscription_order_id",
    "product",
    "no_of_products",
    "original_price_per_unit",
    "product_discount",
    "start_date",
    "end_date",
    "created_by"
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
)
RETURNING *;

-- Get a subscription package by ID
-- name: GetSubscriptionPackage :one
SELECT * FROM "subscription_package"
WHERE "id" = $1;

-- Update a subscription package and return the updated row
-- name: UpdateSubscriptionPackage :one
UPDATE "subscription_package"
SET
    "no_of_products" = $2,
    "product_discount" = $3, 
    "start_date" = $4,
    "end_date" = $5, 
    "updated_at" = $6
WHERE "id" = $1
RETURNING *;

-- Delete a subscription package by ID
-- name: DeleteSubscriptionPackage :exec
DELETE FROM "subscription_package"
WHERE "id" = $1;

-- List all subscription packages
-- name: ListSubscriptionPackages :many
SELECT * FROM "subscription_package"
ORDER BY "created_at" DESC;
