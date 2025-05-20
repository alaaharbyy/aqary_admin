-- name: CreateIndustrialFreelancerPropertyDoc :one
INSERT INTO industrial_freelancer_properties_documents (
    documents_category_id,
    documents_subcategory_id,
    file_url,
    created_at,
    updated_at,
    industrial_freelancer_properties_id,
    status
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7
) RETURNING *;

 
-- name: GetIndustrialFreelancerPropertyDoc :one
SELECT * FROM industrial_freelancer_properties_documents 
WHERE id = $1 LIMIT $1;

-- name: GetAllIndustrialFreelancerPropertyDoc :many
SELECT * FROM industrial_freelancer_properties_documents
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateIndustrialFreelancerPropertyDoc :one
UPDATE industrial_freelancer_properties_documents
SET documents_category_id = $2,
    documents_subcategory_id = $3,
    file_url = $4,
    created_at = $5,
    updated_at = $6,
    industrial_freelancer_properties_id = $7,
    status = $8
Where id = $1
RETURNING *;


-- name: DeleteIndustrialFreelancerPropertyDoc :exec
DELETE FROM industrial_freelancer_properties_documents
Where id = $1;

-- name: GetIndustrialFreelancerPropertyDocByFreelancerPropertyIdAndDocCatIdAndSubDocCatId :one
SELECT * FROM industrial_freelancer_properties_documents
WHERE industrial_freelancer_properties_id=$1 AND documents_category_id=$2 AND documents_subcategory_id=$3;


-- name: GetIndustrialFreelancerPropertyDocByFreelancerPropertyDocId :one
SELECT
 industrial_freelancer_properties_documents.id,
 industrial_freelancer_properties_documents.documents_category_id,
 industrial_freelancer_properties_documents.documents_subcategory_id,
 industrial_freelancer_properties_documents.file_url,
 industrial_freelancer_properties_documents.created_at, 
 industrial_freelancer_properties_documents.updated_at,
 industrial_freelancer_properties_documents.industrial_freelancer_properties_id,
 industrial_freelancer_properties_documents.status,
 documents_category.category,
 documents_subcategory.sub_category
 FROM
 industrial_freelancer_properties_documents
 LEFT JOIN documents_category ON documents_category.id = industrial_freelancer_properties_documents.documents_category_id
 LEFT JOIN documents_subcategory ON documents_subcategory.id = industrial_freelancer_properties_documents.documents_subcategory_id
WHERE industrial_freelancer_properties_documents.id = $1;

-- name: GetCountIndustrialFreelancerPropertyDocByFreelancerPropertyId :one
SELECT count(*)FROM industrial_freelancer_properties_documents WHERE industrial_freelancer_properties_documents.industrial_freelancer_properties_id=$1;


-- name: GetAllIndustrialFreelancerPropertyDocByFreelancerPropertyId :many

SELECT
industrial_freelancer_properties_documents.id,
industrial_freelancer_properties_documents.documents_category_id,
industrial_freelancer_properties_documents.documents_subcategory_id,
industrial_freelancer_properties_documents.file_url,
industrial_freelancer_properties_documents.created_at,
industrial_freelancer_properties_documents.updated_at,
industrial_freelancer_properties_documents.industrial_freelancer_properties_id,
industrial_freelancer_properties_documents.status,
documents_category.category,
documents_subcategory.sub_category
FROM
industrial_freelancer_properties_documents
LEFT JOIN documents_category ON documents_category.id = industrial_freelancer_properties_documents.documents_category_id
LEFT JOIN documents_subcategory ON documents_subcategory.id = industrial_freelancer_properties_documents.documents_subcategory_id
WHERE
industrial_freelancer_properties_documents.industrial_freelancer_properties_id = $3
ORDER BY
industrial_freelancer_properties_documents.id
LIMIT $1 OFFSET $2;