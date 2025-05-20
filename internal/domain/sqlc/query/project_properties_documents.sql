-- name: CreateProjectPropertyDocument :one
INSERT INTO project_properties_documents (
    documents_category_id,
    documents_subcategory_id,
    file_url,
    created_at,
    updated_at,
    project_properties_id,
    status
)VALUES (
    $1, $2, $3, $4, $5, $6, $7
) RETURNING *;

-- name: GetProjectPropertyDocument :one
SELECT project_properties_documents.*,project_properties.property_name 
FROM project_properties_documents 
INNER JOIN project_properties ON project_properties.id = project_properties_documents.project_properties_id
WHERE project_properties_documents.id = $1 LIMIT 1;


-- name: GetAllProjectPropertyDocument :many
SELECT * FROM project_properties_documents
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateProjectPropertyDocument :one
UPDATE project_properties_documents
SET    documents_category_id = $2,
    documents_subcategory_id = $3,
    file_url = $4,
    created_at = $5,
    updated_at = $6,
    project_properties_id = $7,
    status = $8
Where id = $1
RETURNING *;


-- name: DeleteProjectPropertyDocument :exec
DELETE FROM project_properties_documents
Where id = $1;


-- name: GetAllProjectPropertyDocByProjectPropertyId :many
SELECT project_properties_documents.id, 
project_properties_documents.documents_category_id,
 project_properties_documents.documents_subcategory_id,
  project_properties_documents.file_url,
   project_properties_documents.created_at,
    project_properties_documents.updated_at, project_properties_documents.project_properties_id,
     project_properties_documents.status, documents_category.category,documents_category.category_ar,
     documents_subcategory.sub_category 
FROM project_properties_documents 
LEFT JOIN documents_category ON documents_category.id = project_properties_documents.documents_category_id 
LEFT JOIN documents_subcategory ON documents_subcategory.id = project_properties_documents.documents_subcategory_id 
WHERE project_properties_documents.project_properties_id = $3 LIMIT $1 OFFSET $2;



-- name: GetCountProjectPropertyDocByProjectPropertyId :one
SELECT count(*) FROM project_properties_documents 
WHERE project_properties_documents.project_properties_id = $1;


-- name: GetProjectPropertyDocByProjectPropertyDocId :one
SELECT project_properties_documents.id, project_properties_documents.documents_category_id, 
project_properties_documents.documents_subcategory_id, project_properties_documents.file_url,
 project_properties_documents.created_at, project_properties_documents.updated_at,
 project_properties_documents.project_properties_id, project_properties_documents.status, 
 documents_category.category,documents_category.category_ar,documents_subcategory.sub_category,project_properties.property_name 
FROM project_properties_documents
LEFT JOIN documents_category ON documents_category.id = project_properties_documents.documents_category_id 
LEFT JOIN documents_subcategory ON documents_subcategory.id = project_properties_documents.documents_subcategory_id 
INNER JOIN project_properties ON project_properties.id = project_properties_documents.project_properties_id 
WHERE project_properties_documents.id = $1 LIMIT 1;


-- name: GetProjetPropertyDocumentsByProjectIdAndDocCatIdAndSubDocCatId :one
SELECT  * FROM project_documents
WHERE  projects_id = $1 AND  documents_category_id = $2 AND documents_subcategory_id = $3;


-- name: GetProjetPropertyDocumentsByProjectPropertyIdAndDocCatIdAndSubDocCatId :one
SELECT * FROM project_properties_documents 
WHERE project_properties_id= $1
AND
  documents_category_id = $2
AND
documents_subcategory_id = $3;


-- name: GetProjectPropertyDocumentByProjPropertyId :one
SELECT id, documents_category_id, documents_subcategory_id, file_url, created_at, updated_at, project_properties_id, status FROM project_properties_documents 
WHERE project_properties_id = $1 and documents_category_id=$2 and documents_subcategory_id=$3 LIMIT 1;

-- name: GetAllDocsByProjectPropertyIDWithOutPagination :many
SELECT project_properties_documents.*, documents_category.category,documents_category.category_ar,documents_subcategory.sub_category FROM project_properties_documents 
LEFT JOIN documents_category ON documents_category.id = project_properties_documents.documents_category_id 
LEFT JOIN documents_subcategory ON documents_subcategory.id = project_properties_documents.documents_subcategory_id 
WHERE project_properties_documents.project_properties_id = $1;


-- name: GetAllDocsByProjectPropertyUnitByIDWithOutPagination :many
SELECT units_documents.*, documents_category.category,documents_category.category_ar,documents_subcategory.sub_category FROM units_documents 
LEFT JOIN documents_category ON documents_category.id = units_documents.documents_category_id 
LEFT JOIN documents_subcategory ON documents_subcategory.id = units_documents.documents_subcategory_id 
WHERE units_documents.units_id = $1;

-- name: GetProjPhaseDocCatAndSubCatByProjProp :many
WITH x AS(
SELECT projects_id AS id,documents_category_id,documents_subcategory_id
FROM project_documents
UNION ALL
SELECT phases_id AS id,documents_category_id,documents_subcategory_id
FROM phases_documents
)SELECT x.*,documents_category.category AS documents_category, documents_category.category_ar as documents_category_ar, documents_subcategory.sub_category AS documents_subcategory FROM x
INNER JOIN project_properties ON project_properties.id = @project_properties_id
AND 
CASE 
WHEN project_properties.is_multiphase IS TRUE THEN project_properties.phases_id = x.id 
ELSE project_properties.projects_id = x.id 
END
INNER JOIN documents_category ON documents_category.id = x.documents_category_id
INNER JOIN documents_subcategory ON documents_subcategory.id = x.documents_subcategory_id
ORDER BY documents_category.id;

-- name: UpdateProjectPropertyDocumentFiles :one
UPDATE project_properties_documents 
SET file_url = $2,
    updated_at = $3
WHERE id = $1
RETURNING *;