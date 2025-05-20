-- name: CreateProjectDocuments :one
INSERT INTO project_documents (
    documents_category_id,
    documents_subcategory_id,
    file_url,
    created_at,
    updated_at,
    projects_id,
    status
)VALUES (
    $1, $2, $3, $4, $5, $6, $7
) RETURNING *;

-- name: GetProjectDocuments :one
SELECT * FROM project_documents
WHERE id = $1 LIMIT $1;

-- name: GetAllProjectDocuments :many
SELECT * FROM project_documents
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateProjectDocuments :one
UPDATE project_documents
SET   documents_category_id = $2,
      documents_subcategory_id = $3,
      file_url = $4,
      created_at =$5,
      updated_at = $6,
      projects_id = $7,
      status = $8
Where id = $1
RETURNING *;

-- name: DeleteProjectDocuments :exec
DELETE FROM project_documents
Where id = $1;

-- name: GetAllDocsByProjectID :many
SELECT project_documents.*, documents_category.category,documents_category.category_ar,documents_subcategory.sub_category FROM project_documents 
LEFT JOIN documents_category ON documents_category.id = project_documents.documents_category_id 
LEFT JOIN documents_subcategory ON documents_subcategory.id = project_documents.documents_subcategory_id 
WHERE project_documents.projects_id = $3 ORDER BY project_documents.created_at DESC LIMIT $1 OFFSET $2;



-- name: GetAllDocsByProjectIDWithOutPagination :many
SELECT project_documents.*, documents_category.category,documents_category.category_ar,documents_subcategory.sub_category FROM project_documents 
LEFT JOIN documents_category ON documents_category.id = project_documents.documents_category_id 
LEFT JOIN documents_subcategory ON documents_subcategory.id = project_documents.documents_subcategory_id 
WHERE project_documents.projects_id = $1;


-- name: GetProjectDocById :one
SELECT project_documents.*,documents_category.category,documents_category.category_ar,documents_subcategory.sub_category FROM project_documents
LEFT JOIN documents_category ON documents_category.id = project_documents.documents_category_id 
LEFT JOIN documents_subcategory ON documents_subcategory.id = project_documents.documents_subcategory_id 
WHERE project_documents.id = $1;

-- name: GetCountDocsByProjectId :one  
SELECT COUNT(*) FROM project_documents WHERE project_documents.projects_id = $1;

-- name: GetProjectDocByIdandCategory :one
SELECT project_documents.id, project_documents.documents_category_id, project_documents.documents_subcategory_id, project_documents.file_url, project_documents.created_at, project_documents.updated_at, project_documents.projects_id, project_documents.status,documents_category.category,documents_subcategory.sub_category FROM project_documents
LEFT JOIN documents_category ON documents_category.id = project_documents.documents_category_id
LEFT JOIN documents_subcategory ON documents_subcategory.id = project_documents.documents_subcategory_id
WHERE project_documents.projects_id = $1 AND  project_documents.documents_category_id = $2 AND project_documents.documents_subcategory_id = $3;

-- name: GetProjectDocCategoriesByPhase :many
SELECT 
documents_category.id AS documents_category_id, 
documents_category.category AS documents_category,
documents_category.category_ar AS document_category_ar,
documents_subcategory.id AS documents_subcategory_id,
documents_subcategory.sub_category AS documents_subcategory
FROM project_documents
INNER JOIN phases ON phases.id = @phase_id AND phases.projects_id = project_documents.projects_id
INNER JOIN documents_category ON documents_category.id = project_documents.documents_category_id
INNER JOIN documents_subcategory ON documents_subcategory.id = project_documents.documents_subcategory_id
ORDER BY documents_category.id;

-- name: GetProjectPropDocCategoriesByUnit :many
SELECT 
documents_category.id AS documents_category_id, 
documents_category.category AS documents_category,
documents_category.category_ar AS document_category_ar,
documents_subcategory.id AS documents_subcategory_id,
documents_subcategory.sub_category AS documents_subcategory
FROM project_properties_documents
INNER JOIN units ON units.id = @unit_id AND units.properties_id = project_properties_documents.project_properties_id AND units.property = 1
INNER JOIN documents_category ON documents_category.id = project_properties_documents.documents_category_id
INNER JOIN documents_subcategory ON documents_subcategory.id = project_properties_documents.documents_subcategory_id
ORDER BY documents_category.id;

-- name: UpdateProjectDocumentFiles :one
UPDATE project_documents
SET file_url = $2,
updated_at = $3
Where id = $1
RETURNING *;