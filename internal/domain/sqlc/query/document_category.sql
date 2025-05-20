-- name: CreateDocumentCategory :exec
INSERT INTO
    documents_category (category,category_ar, created_at, updated_at, status)
VALUES($1, $2, $3, $4,$5);


-- name: UpdateDocumentCategory :exec
UPDATE
    documents_category
SET
    category = $2,
    updated_at = $3,
	category_ar=$4
WHERE
    id = $1
    AND status != 6;
    
-- name: DeleteRestoreDocumentCategory :one
UPDATE 
	documents_category
SET 
	status=$2, 
	updated_at=$3
WHERE 
	id=$1 RETURNING id;

-- name: GetAllDocumentCategories :many
SELECT id,category,category_ar,updated_at
FROM 
	documents_category
WHERE 
	status=$1 
ORDER BY updated_at DESC 
LIMIT sqlc.narg('limit') OFFSET sqlc.narg('offset');

-- name: GetNumberOFCategories :one
SELECT COUNT(*) 
FROM 
	documents_category
WHERE 
	status=$1; 
	
	
-- name: GetDocumentCategry :one
SELECT id,category,category_ar
FROM 
	documents_category
WHERE 
	id=$1 AND status!=6; 