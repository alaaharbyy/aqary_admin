-- name: CheckIfCategoryIsExist :one
SELECT EXISTS(SELECT 1 FROM categories WHERE id = $1)::boolean;