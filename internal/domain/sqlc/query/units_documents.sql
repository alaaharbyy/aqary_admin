-- name: CreateUnitsDocuments :one
INSERT INTO units_documents (
    documents_category_id,
    documents_subcategory_id,
    file_url,
    created_at, 
    updated_at,
    units_id, 
    status
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7
) RETURNING *;

-- name: GetUnitsDocumentsByUnitIdAndDocCatIdAndSubDocCatId :one
SELECT id, documents_category_id, documents_subcategory_id, 
file_url, created_at, updated_at, units_id, status 
FROM units_documents 
WHERE units_id = $1 AND documents_category_id = $2 AND documents_subcategory_id = $3;

-- name: UpdateUnitDocFileUrls :one
UPDATE units_documents
SET file_url = $2,
  updated_at = $3
Where id = $1
RETURNING *;

-- name: GetAllUnitDocsByUnitId :many
SELECT units_documents.*,documents_category.category AS documents_category, documents_category.category_ar AS documents_category_ar,documents_subcategory.sub_category AS documents_subcategory
FROM units_documents 
INNER JOIN documents_category ON units_documents.documents_category_id = documents_category.id
INNER JOIN documents_subcategory ON units_documents.documents_subcategory_id = documents_subcategory.id
WHERE units_id = $3 AND (units_documents.status != 5 AND units_documents.status != 6)
LIMIT $1 OFFSET $2;

-- name: GetCountAllUnitDocsByUnitId :one
SELECT COUNT(*) 
FROM units_documents 
INNER JOIN documents_category ON units_documents.documents_category_id = documents_category.id
INNER JOIN documents_subcategory ON units_documents.documents_subcategory_id = documents_subcategory.id
WHERE units_id = $1 AND (units_documents.status != 5 AND units_documents.status != 6);

-- name: GetUnitsDocuments :one
SELECT units_documents.*,documents_category.category AS documents_category, documents_category.category_ar AS documents_category_ar, documents_subcategory.sub_category AS documents_subcategory
FROM units_documents 
INNER JOIN documents_category ON units_documents.documents_category_id = documents_category.id
INNER JOIN documents_subcategory ON units_documents.documents_subcategory_id = documents_subcategory.id 
WHERE units_documents.id = $1;

-- name: DeleteUnitsDocuments :exec
DELETE FROM units_documents
WHERE id = $1;

-- name: DeleteOneUnitDocByIdAndFile :one
UPDATE units_documents
SET file_url = array_remove(file_url, $2)
WHERE id = $1
RETURNING *;