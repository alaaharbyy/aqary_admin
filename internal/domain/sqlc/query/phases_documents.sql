-- name: CreatePhasesDocuments :one
INSERT INTO phases_documents(
  phases_id,
  documents_category_id ,
  documents_subcategory_id,
  file_url,
  created_at,
  updated_at ,
  created_by,
  updated_by,
  status
  )
  VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9
  ) 
  RETURNING *;

-- name: GetPhasesDocuments :one
SELECT phases_documents.*,phases.phase_name FROM phases_documents
INNER JOIN phases ON phases.id = phases_documents.phases_id
WHERE phases_documents.id = $1;

-- name: GetAllPhasesDocuments :many
SELECT * FROM phases_documents
ORDER BY id
LIMIT $1 OFFSET $2;

-- name: DeletePhasesDocuments :exec
DELETE FROM phases_documents WHERE id = $1;

-- name: UpdatePhasesDocuments :one
UPDATE phases_documents
SET
  phases_id = $2,
  documents_category_id = $3,
  documents_subcategory_id = $4,
  file_url = $5,
  created_at = $6,
  updated_at = $7,
  created_by = $8,
  updated_by = $9,
  status = $10
WHERE id = $1
RETURNING *;

-- name: GetPhasesDocumentsByPhaseIdAndDocCatIdAndSubDocCatId :one
SELECT * FROM phases_documents
WHERE phases_id = $1
AND
documents_category_id = $2
AND
documents_subcategory_id = $3;

-- name: GetAllPhasesDocumentByPhaseId :many
SELECT phases_documents.*,documents_category.category,documents_category.category_ar,documents_subcategory.sub_category FROM phases_documents
LEFT JOIN documents_category ON documents_category.id = documents_category_id
LEFT JOIN documents_subcategory ON documents_subcategory.id= documents_subcategory_id
WHERE phases_id = $3
ORDER BY id
LIMIT $1 OFFSET $2;

-- name: GetCountAllPhasesDocumentByPhaseId :one
SELECT COUNT(phases_documents.id) FROM phases_documents
LEFT JOIN documents_category ON documents_category.id = documents_category_id
LEFT JOIN documents_subcategory ON documents_subcategory.id= documents_subcategory_id
WHERE phases_id = $1;

-- name: UpdatePhasesDocumentsFileUrls :one
UPDATE phases_documents
SET  file_url = $2,
  updated_at = $3,
  updated_by = $4
WHERE id = $1
RETURNING *;

-- name: GetAllDocsByPhaseIDWithOutPagination :many
SELECT phases_documents.*, documents_category.category,documents_category.category_ar,documents_subcategory.sub_category FROM phases_documents 
LEFT JOIN documents_category ON documents_category.id = phases_documents.documents_category_id 
LEFT JOIN documents_subcategory ON documents_subcategory.id = phases_documents.documents_subcategory_id 
WHERE phases_documents.phases_id = $1;