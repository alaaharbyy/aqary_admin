-- name: CreateCompanyProduct :one
INSERT INTO companies_products (
    product_code,
    model_number,
    serial_number,
    companies_id,
    products_categories_id,
    product_name,
    description,
    price,
    created_at,
    is_branch
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10
) RETURNING *;

-- name: GetCompanyProductByID :one
SELECT * FROM companies_products 
WHERE id = $1 LIMIT 1;

-- name: GetAllCompanyProducts :many
SELECT * FROM companies_products
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: GetCountCompanyProducts :one
SELECT COUNT(*) FROM companies_products;

-- name: UpdateCompanyProduct :one
UPDATE companies_products
SET  
    product_code = $2,
    model_number = $3,
    serial_number = $4,
    companies_id = $5,
    products_categories_id = $6,
    product_name = $7,
    description = $8,
    price = $9,
    created_at = $10,
    is_branch = $11
WHERE id = $1
RETURNING *;

-- name: DeleteCompanyProduct :exec
DELETE FROM companies_products
WHERE id = $1;

-- name: GetAllProductsByCompanyID :many
SELECT cu.serial_number, cu.product_name, cu.description, 
AVG(pr.review_quality + pr.review_price + pr.customer_service + pr.order_experience) AS "rating"
FROM companies_products cu
LEFT JOIN product_reviews pr ON cu.id = pr.companies_products_id
WHERE cu.companies_id = $1
GROUP BY cu.serial_number, cu.product_name, cu.description LIMIT $2 OFFSET $3;

-- name: GetCountAllProductsByCompanyID :one
SELECT COUNT(*)
FROM companies_products cu
WHERE cu.companies_id = $1;