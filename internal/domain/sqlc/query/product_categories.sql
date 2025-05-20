-- name: CreateProductCategory :one
INSERT INTO product_categories (
    parent_categories_id,
    category_name,
    description,
    icon_url,
    created_at
) VALUES (
    $1, $2, $3, $4, $5
) RETURNING *;

-- name: GetProductCategoryByID :one
SELECT * FROM product_categories 
WHERE id = $1 LIMIT 1;

-- name: GetAllProductCategories :many
SELECT * FROM product_categories
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: GetCountProductCategories :one
SELECT COUNT(*) FROM product_categories;

-- name: UpdateProductCategory :one
UPDATE product_categories
SET  
    parent_categories_id = $2,
    category_name = $3,
    description = $4,
    icon_url = $5,
    created_at = $6
WHERE id = $1
RETURNING *;

-- name: DeleteProductCategory :exec
DELETE FROM product_categories
WHERE id = $1;