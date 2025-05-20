
-- name: CreateDocumentsCategory :one
INSERT INTO documents_category (
    category,
    created_at, 
    updated_at,
    status,
    category_ar
)VALUES (
    $1, $2, $3, $4,$5
) RETURNING *;

-- name: GetDocumentsCategory :one
SELECT * FROM documents_category
WHERE id = $1 LIMIT 1;

-- name: GetDocumentCategoryForContact :one
SELECT id, title,title_ar FROM document_categories
WHERE id = $1 AND parent_category_id is null LIMIT $1;

-- name: GetDocumentSubCategoryForContact :one
SELECT id, title,title_ar FROM document_categories
WHERE id = $1 AND parent_category_id is not null LIMIT $1;

-- name: GetDocumentsCategorByCategory :one
SELECT * FROM documents_category
WHERE category = $1;

-- name: GetAllDocumentsCategory :many
SELECT * FROM documents_category
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateDocumentsCategory :one
UPDATE documents_category
SET category = $2,
    created_at = $3, 
    updated_at = $4,
    status = $5,
    category_ar=$6
Where id = $1
RETURNING *;

-- name: DeleteDocumentsCategory :exec
DELETE FROM documents_category
Where id = $1;

