-- name: GetAllDocumentsCategories :many
SELECT id, category,category_ar
FROM documents_category;