-- name: CreateBlog :one
INSERT INTO blog (
    company_types_id,
    is_branch,
    companies_id,
    blog_categories_id,
    title,
    sub_title,
    blog_article,
    is_public,
    status,
    created_by,
    created_at,
    media_type_id,
    media_url
) VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10,
    $11,
    $12,
    $13
) RETURNING *;
 
-- name: UpdateBlogByID :one
UPDATE blog
SET 
    company_types_id = $2,
    is_branch = $3,
    companies_id = $4,
    blog_categories_id = $5,
    title = $6,
    sub_title = $7,
    blog_article = $8,
    is_public = $9,
    created_by = $10,
    media_type_id = $11,
    media_url = $12
WHERE
    id = $1 AND blog.status !=6
RETURNING *;
 
 
-- name: DeleteBlogByID :exec
DELETE FROM blog
WHERE id = $1 AND blog.status !=6;
 
 
-- name: GetAllBlogs :many
SELECT *
FROM blog
WHERE blog.status!=6
ORDER BY blog.id
LIMIT $1
OFFSET $2;
 
 
-- name: GetBlogByID :one
SELECT *
FROM blog
INNER JOIN blog_categories 
	on blog.blog_categories_id = blog_categories.id 
WHERE blog.id = $1 AND blog.status!=6 AND blog_categories.status!=6;
 
 
-- name: GetAllBlogsForManage :many
SELECT
    blog.id,
    blog.title,
    blog.blog_article,
    blog.media_url,
    blog.blog_categories_id,
    blog_categories.category_title,
    blog_categories.category_title_ar,
    blog.companies_id,
    blog.created_by
FROM
    blog
INNER JOIN
    blog_categories ON blog.blog_categories_id=blog_categories.id AND blog_categories.status!=6
WHERE
    blog.status!=6
ORDER BY blog.id
LIMIT $1
OFFSET $2;

-- name: GetNumberOfBlogs :one
SELECT COUNT(id)
FROM blog
WHERE status!=6;

-- name: ChangeStatusOfBlogByID :one 
UPDATE blog
SET 
	status=$2  
WHERE
	id=$1 RETURNING *;

-- name: GetAllDeletedBlogs :many 
SELECT
    blog.id,
    blog.title,
    blog.blog_article,
    blog.media_url,
    blog.blog_categories_id,
    blog_categories.category_title,
    blog_categories.category_title_ar,
    blog.companies_id,
    blog.created_by
FROM
    blog
INNER JOIN
    blog_categories ON blog.blog_categories_id=blog_categories.id AND blog_categories.status!=6
WHERE
    blog.status=6
ORDER BY blog.id
LIMIT $1
OFFSET $2;
 
-- name: GetNumberOfDeletedBlogs :one
SELECT COUNT(id)
FROM
	blog
WHERE blog.status =6;