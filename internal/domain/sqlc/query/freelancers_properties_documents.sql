-- name: CreateFreelancerPropertyDoc :one
INSERT INTO freelancers_properties_documents (
  documents_category_id,
  documents_subcategory_id,
  file_url,
  created_at, 
  updated_at,  
  freelancers_properties_id, 
  status
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7
) RETURNING *;
 

-- name: GetFreelancerPropertyDoc :one
SELECT * FROM freelancers_properties_documents 
WHERE id = $1 LIMIT 1;

-- name: GetAllFreelancerPropertyDoc :many
SELECT * FROM freelancers_properties_documents
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateFreelancerPropertyDoc :one
UPDATE freelancers_properties_documents
SET documents_category_id = $2,
  documents_subcategory_id = $3,
  file_url = $4,
  created_at = $5, 
  updated_at = $6,  
  freelancers_properties_id = $7, 
  status = $8
Where id = $1
RETURNING *;


-- name: DeleteFreelancerPropertyDoc :exec
DELETE FROM freelancers_properties_documents
Where id = $1;

-- name: GetFreelancerPropertyDocumentsByRentPropertyUnitIdAndDocCatIdAndSubDocCatId :one
SELECT id, documents_category_id, documents_subcategory_id,
 file_url, created_at, updated_at, freelancers_properties_id, status FROM freelancers_properties_documents 
WHERE freelancers_properties_id = $1 
AND documents_category_id = $2 AND documents_subcategory_id = $3;

-- name: UpdateFreelancerPropertyDocStatusById :one 
UPDATE freelancers_properties_documents
SET status = $2
WHERE id= $1
RETURNING *;



-- name: GetFreelancerPropertyDocumentsByFreelancerPropertyIdAndDocCatIdAndSubDocCatId :one
SELECT * FROM freelancers_properties_documents 
WHERE freelancers_properties_id=$1 AND documents_category_id=$2 AND documents_subcategory_id=$3;


-- name: GetFreelancerPropertyDocByFreelancerPropertyDocId :one
SELECT freelancers_properties_documents.id,freelancers_properties_documents.documents_category_id,freelancers_properties_documents.documents_subcategory_id,
freelancers_properties_documents.file_url,freelancers_properties_documents.created_at,freelancers_properties_documents.updated_at,
freelancers_properties_documents.freelancers_properties_id,
freelancers_properties_documents.status,
documents_category.category,documents_subcategory.sub_category 
FROM freelancers_properties_documents LEFT JOIN documents_category ON documents_category.id=freelancers_properties_documents.documents_category_id
 LEFT JOIN documents_subcategory ON documents_subcategory.id=freelancers_properties_documents.documents_subcategory_id 
 WHERE freelancers_properties_documents.id=$1;


-- name: GetAllFreelancerPropertyDocByFreelancerPropertyId :many
SELECT freelancers_properties_documents.id,freelancers_properties_documents.documents_category_id,freelancers_properties_documents.documents_subcategory_id,freelancers_properties_documents.file_url,freelancers_properties_documents.created_at,freelancers_properties_documents.updated_at,freelancers_properties_documents.freelancers_properties_id,freelancers_properties_documents.status,documents_category.category,documents_subcategory.sub_category FROM freelancers_properties_documents 
LEFT JOIN documents_category ON documents_category.id=freelancers_properties_documents.documents_category_id 
LEFT JOIN documents_subcategory ON documents_subcategory.id=freelancers_properties_documents.documents_subcategory_id 
WHERE freelancers_properties_documents.freelancers_properties_id=$3 ORDER BY freelancers_properties_documents.id LIMIT $1 OFFSET $2;


-- name: GetCountFreelancerPropertyDocByFreelancerPropertyId :one
SELECT count(*)FROM freelancers_properties_documents WHERE freelancers_properties_documents.freelancers_properties_id=$1;