-- name: CreateDropDownCategories :one
INSERT INTO dropdown_categories (
    category_name
)VALUES (
    $1
) RETURNING *;
 
-- name: GetAllDropDownCategories :many
SELECT * FROM dropdown_categories;
 
-- name: GetDropDownCategoriesById :one
SELECT * FROM dropdown_categories
WHERE id = 1;
 
-- name: UpdateDropDownCategories :one
UPDATE dropdown_categories
SET category_name = $2
WHERE id = $1 RETURNING *;
 
-- name: DeleteDropDownCategories :one
DELETE FROM dropdown_categories
WHERE id = 1 RETURNING *;
 
-- name: CreateDropDownItems :one
INSERT INTO dropdown_items (
    category_id,
    icon_url,
    item_name
)VALUES (
    $1, $2, $3
) RETURNING *;
 
-- name: GetAllDropDownItems :many
SELECT * FROM dropdown_items;
 
-- name: GetDropDownItemsById :one
SELECT * FROM dropdown_items
WHERE id = $1;
 
-- name: UpdateDropDownItems :one
UPDATE dropdown_items
SET  category_id = $2,
    icon_url = $3,
    item_name = $4
WHERE id = $1 RETURNING *;
 
-- name: DeleteDropDownItems :one
DELETE FROM dropdown_items
WHERE id = $1 RETURNING *;