-- name: GetAllRetailCategoryWithoutPagination :many
select * from retail_category;

-- name: GetRetailCategory :one
SELECT * FROM retail_category WHERE id = $1 LIMIT 1;

-- name: GetAllRetailCategory :one
SELECT * FROM retail_category;