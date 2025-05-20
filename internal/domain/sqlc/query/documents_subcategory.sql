
-- name: CreateDocumentsSubCategory :one
INSERT INTO documents_subcategory (
    sub_category,
     created_at, 
    updated_at,
    documents_category_id,
    status
)VALUES (
  $1, $2, $3, $4, $5
) RETURNING *;

-- name: GetDocumentsSubCategory :one
SELECT * FROM documents_subcategory
WHERE id = $1 LIMIT 1;

-- name: GetDocumentsSubCategoryBySubCategory :one
SELECT * FROM documents_subcategory
WHERE sub_category = $1;

-- name: GetAllDocumentsSubCategory :many
SELECT * FROM documents_subcategory
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateDocumentsSubCategory :one
UPDATE documents_subcategory
SET sub_category = $2,
    created_at = $3, 
    updated_at = $4,
    documents_category_id = $5,
    status = $6
Where id = $1
RETURNING *;

-- name: DeleteDocumentsSubCategory :exec
DELETE FROM documents_subcategory
Where id = $1;


-- name: GetAllSubCategoryBySubCatId :many
SELECT documents_subcategory.* FROM documents_subcategory 
WHERE id = ANY($1::int[]);

-- name: GetCountDocumentSubCategory :one
SELECT count(*) FROM documents_subcategory;

-- name: GetAllDocumentsSubCategoryByDocId :many
SELECT  * FROM documents_subcategory
WHERE documents_category_id = $1;