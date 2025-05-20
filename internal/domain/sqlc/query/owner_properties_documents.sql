-- name: CreateOwnerPropertyDocument :one
INSERT INTO owner_properties_documents (
    documents_category_id,
    documents_subcategory_id,
    file_url,
    created_at,
    updated_at,
    owner_properties_id,
    status
)VALUES (
    $1, $2, $3, $4, $5, $6, $7
) RETURNING *;

-- name: GetOwnerPropertyDocument :one
SELECT * FROM owner_properties_documents 
WHERE id = $1 LIMIT $1;


-- name: GetAllOwnerPropertyDocument :many
SELECT * FROM owner_properties_documents
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateOwnerPropertyDocument :one
UPDATE owner_properties_documents
SET    documents_category_id = $2,
    documents_subcategory_id = $3,
    file_url = $4,
    created_at = $5,
    updated_at = $6,
    owner_properties_id = $7,
    status = $8
Where id = $1
RETURNING *;


-- name: DeleteOwnerPropertyDocument :exec
DELETE FROM owner_properties_documents
Where id = $1;


-- name: GetOwnerPropertyDocumentsByOwnerPropertyIdAndDocCatIdAndSubDocCatId :one
SELECT * FROM owner_properties_documents
WHERE  owner_properties_id = $1
 AND
  documents_category_id = $2 
  AND
 documents_subcategory_id = $3;


-- name: GetAllOwnerPropertyDocumentsByOwnerPropertyId :many 
SELECT owner_properties_documents.*,documents_category.category,documents_subcategory.sub_category FROM owner_properties_documents LEFT JOIN documents_category ON documents_category.id=owner_properties_documents.documents_category_id LEFT JOIN documents_subcategory ON documents_subcategory.id=owner_properties_documents.documents_subcategory_id WHERE owner_properties_documents.owner_properties_id=$3 ORDER BY owner_properties_documents.id OFFSET $2 LIMIT $1; 

-- name: GetCountOwnerPropertyDocumentsByOwnerPropertyId :one
 SELECT count(*) FROM owner_properties_documents
  WHERE owner_properties_id = $1;

-- name: GetOwnerPropertyDocById :one
SELECT owner_properties_documents.*,documents_category.category,documents_subcategory.sub_category 
FROM owner_properties_documents 
LEFT JOIN documents_category ON documents_category.id = owner_properties_documents.documents_category_id 
LEFT JOIN documents_subcategory ON documents_subcategory.id = owner_properties_documents.documents_subcategory_id 
WHERE owner_properties_documents.id = $1;


-- name: GetFacilitiesIdByOwnerPropertyId :one
SELECT owner_properties.facilities_id FROM owner_properties WHERE id = $1;

-- name: GetAmenitiesIdByOwnerPropertyId :one
SELECT owner_properties.amenities_id FROM owner_properties WHERE id = $1;
