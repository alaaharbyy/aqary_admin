-- name: CreateSubDocumentCategory :one
INSERT INTO 
	documents_subcategory (sub_category,created_at,updated_at,documents_category_id,status,sub_category_ar)
SELECT $1,$2,$3,$4,$5,$6
FROM 
	documents_category
WHERE 
	id= $4::BIGINT AND status!=6
RETURNING 1; 
	

-- name: UpdateSubDocumentCategory :exec
UPDATE 
	documents_subcategory
SET 
	sub_category=$2,
	updated_at=$3,
	sub_category_ar=$4
WHERE	
	id=$1 AND status!=6;
    

-- name: GetAllSubDocumentCategories :many
SELECT id,sub_category,updated_at,sub_category_ar
FROM 
	documents_subcategory
WHERE 
	status=$1 AND documents_category_id= @document_category_id::BIGINT
ORDER BY updated_at DESC 
LIMIT sqlc.narg('limit') OFFSET sqlc.narg('offset');

-- name: GetNumberOfSubDocumentCategories :one
SELECT COUNT(*) 
FROM 
	documents_subcategory
WHERE 
	status=$1 AND documents_category_id= @document_category_id::BIGINT;
	
	
-- name: GetSubDocumentCategoryByID :one
SELECT id,sub_category,sub_category_ar
FROM 
	documents_subcategory
WHERE 
	id=$1 AND status!=6; 
	

-- name: DeleteRestoreSubDocumentCategory :one
UPDATE documents_subcategory
SET 
	status=$2, 
	updated_at=$3 
WHERE 
	id=$1 RETURNING id; 