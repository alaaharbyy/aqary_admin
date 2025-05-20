-- -- name: CreateBlogCategories :one
-- INSERT INTO blog_categories (
--      category_title,
--      category_title_ar,
--      description,
--      description_ar,
--      status     
-- )VALUES (
--     $1, $2 ,$3,$4,$5
-- ) RETURNING *;

-- name: GetAllBlogCategories :many
SELECT * FROM blog_categories
ORDER BY id
LIMIT $1
OFFSET $2;

-- -- name: UpdateBlogCategories :one
-- UPDATE blog_categories
-- SET  
--     category_title = $2,
--     category_title_ar=$3,
--     description=$4,
--     description_ar=$5,
--     status =$6
-- Where id = $1
-- RETURNING *;


-- -- name: DeleteBlogCategories :exec
-- DELETE FROM blog_categories
-- Where id = $1;

-- name: GetBlogCategoriesWithoutPagination :many
SELECT *
FROM blog_categories
WHERE blog_categories.status=$1;
 
-- name: GetBlogCategories :many
SELECT *
FROM blog_categories
WHERE blog_categories.status=$1
ORDER BY
	blog_categories.id
LIMIT $2 
OFFSET $3;
 
 
-- name: CreateBlogCategory :one
INSERT INTO blog_categories (
    category_title,
    category_title_ar,
    description,
    description_ar,
    status,    
    created_at,
    updated_at
) VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7
)RETURNING *;
 
-- name: UpdateBlogCategoryByID :one
UPDATE blog_categories
SET 
    category_title = $2,
    category_title_ar=$3,
    description=$4,
    description_ar=$5,
    updated_at = $6
WHERE
    id = $1 AND blog_categories.status!=6
RETURNING *;
 
-- name: DeleteBlogCategoryByID :exec 
DELETE FROM blog_categories
WHERE id = $1 AND blog_categories.status!=6;

-- name: GetBlogCategoryByID :one
SELECT *
FROM blog_categories 
WHERE id=$1 AND status=$2;
 
-- name: GetNumberOfBlogCategories :one
SELECT COUNT(id)
FROM blog_categories
WHERE status=$1;

-- name: RestoreBlogCategoryByID :one
UPDATE blog_categories
SET
	status=1
WHERE id =$1 AND status!=1 RETURNING *;