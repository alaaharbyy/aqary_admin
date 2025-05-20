-- name: CreateGlobalDocument :one
INSERT INTO global_documents (
    documents_category_id, 
    documents_subcategory_id, 
    file_url,
    entity_id,
    entity_type_id,
    created_at,
    updated_at
) VALUES (
    $1, 
    $2, 
    $3, 
    $4, 
    $5, 
    $6, 
    $7)RETURNING *;


-- name: UpdateGlobalDocument :one
Update global_documents 
SET 
	file_url=$1, 
	updated_at=$2 
WHERE 
	entity_type_id=$3 AND entity_id=$4 AND documents_category_id=$5 AND documents_subcategory_id=$6
RETURNING *; 





-- name: GetGlobalDocuments :one	
WITH status_calculation AS (
  SELECT CASE  @entity_type::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = @entity_id::BIGINT)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = @entity_id::BIGINT)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = @entity_id::BIGINT)
              -- WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = @entity_id::BIGINT)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = @entity_id::BIGINT)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = @entity_id::BIGINT)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = @entity_id::BIGINT)
               --WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = @entity_id::BIGINT)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = @entity_id::BIGINT)
              -- WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = @entity_id::BIGINT)
               ELSE 0::BIGINT
           END AS status
)
SELECT 
    COALESCE(global_documents.id, 0) AS "document_id",
    COALESCE(global_documents.file_url, ARRAY[]::VARCHAR[]) AS "file_urls",
    COALESCE(global_documents.entity_id, 0) AS "entity_id",
    COALESCE(status_calculation.status,-1::BIGINT) AS "status"
FROM 
    status_calculation 
LEFT JOIN 
    global_documents ON 
        global_documents.entity_type_id =  @entity_type::BIGINT 
        AND global_documents.entity_id = @entity_id::BIGINT 
        AND global_documents.documents_category_id = $1
        AND global_documents.documents_subcategory_id = $2
        AND status_calculation.status NOT IN (-1,0,6);



-- name: GetEntityIdGlobalDocuments :many
SELECT global_documents.id AS "global_document_id",documents_category.category,documents_category.category_ar,documents_category.id AS "category_id",documents_subcategory.sub_category,documents_subcategory.sub_category_ar,documents_subcategory.id AS "sub_category_id",global_documents.entity_id AS "entity_id" , global_documents.entity_type_id AS "entity_type_id" ,global_documents.created_at,global_documents.updated_at,global_documents.file_url
FROM 
	global_documents
INNER JOIN 
	documents_category ON documents_category.id = global_documents.documents_category_id 
INNER JOIN 
	documents_subcategory ON documents_subcategory.id = global_documents.documents_subcategory_id
WHERE 
	entity_id= @entity_id::BIGINT AND entity_type_id= @entity_type::BIGINT AND
	COALESCE((SELECT CASE  global_documents.entity_type_id::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = global_documents.entity_id::BIGINT)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = global_documents.entity_id::BIGINT)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = global_documents.entity_id::BIGINT)
              -- WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = global_documents.entity_id::BIGINT)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = global_documents.entity_id::BIGINT)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = global_documents.entity_id::BIGINT)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = global_documents.entity_id::BIGINT)
               --WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = global_documents.entity_id::BIGINT)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = global_documents.entity_id::BIGINT)
               --WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = global_documents.entity_id::BIGINT)
               ELSE 0::BIGINT
           END),6::BIGINT) NOT IN(0,6)
ORDER BY 
	global_documents.updated_at DESC
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');



-- name: GetNumberOfEntityIdGlobalDocuments :one
SELECT COUNT(*) 
FROM 
	global_documents 
WHERE 
	entity_id= @entity_id::BIGINT AND entity_type_id= @entity_type::BIGINT;




-- name: DeleteEntityGlobalDocumentByURL :one 
UPDATE global_documents 
SET 
	file_url = array_remove(file_url, @file_url::VARCHAR),
	updated_at=$1 
WHERE 
	global_documents.id= @document_id AND @file_url::VARCHAR = ANY(file_url) AND 
	COALESCE((SELECT CASE  global_documents.entity_type_id::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = global_documents.entity_id::BIGINT)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = global_documents.entity_id::BIGINT)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = global_documents.entity_id::BIGINT)
              -- WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = global_documents.entity_id::BIGINT)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = global_documents.entity_id::BIGINT)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = global_documents.entity_id::BIGINT)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = global_documents.entity_id::BIGINT)
              -- WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = global_documents.entity_id::BIGINT)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = global_documents.entity_id::BIGINT)
              -- WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = global_documents.entity_id::BIGINT)
               ELSE 0::BIGINT
           END),6::BIGINT) NOT IN (0,6)
RETURNING *;


-- name: DeleteEntityGlobalDocument :exec 
DELETE FROM global_documents WHERE id=$1;


-- name: DeleteEntityGlobalDocumentByDocumentId :one 
DELETE FROM global_documents WHERE global_documents.id =$1 AND 
COALESCE((SELECT CASE  global_documents.entity_type_id::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = global_documents.entity_id::BIGINT)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = global_documents.entity_id::BIGINT)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = global_documents.entity_id::BIGINT)
              -- WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = global_documents.entity_id::BIGINT)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = global_documents.entity_id::BIGINT)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = global_documents.entity_id::BIGINT)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = global_documents.entity_id::BIGINT)
              -- WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = global_documents.entity_id::BIGINT)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = global_documents.entity_id::BIGINT)
              -- WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = global_documents.entity_id::BIGINT)
               ELSE 0::BIGINT
           END),6::BIGINT) NOT IN (0,6)
RETURNING global_documents.file_url;


-- name: GetAllEntityTypes :many 
SELECT * FROM entity_type;



-- name: GetDocumentById :one
SELECT * FROM global_documents
Where global_documents.id = $1;


-- name: GetAllParentDocCategory :many
SELECT
    DISTINCT global_documents.documents_category_id, documents_category.category,documents_category.category_ar,
    global_documents.entity_id AS parent_id, global_documents.entity_type_id as parent_type_id
FROM 
    global_documents
    join documents_category on global_documents.documents_category_id = documents_category.id
WHERE global_documents.entity_type_id = $1 and global_documents.entity_id = $2;

-- name: GetAllParentDocSubCategory :many
SELECT DISTINCT global_documents.documents_subcategory_id AS id, documents_subcategory.sub_category AS title ,documents_subcategory.sub_category_ar AS title_ar
FROM global_documents
JOIN documents_subcategory on global_documents.documents_subcategory_id = documents_subcategory.id
WHERE global_documents.documents_category_id = $1 AND global_documents.entity_id = $2 AND global_documents.entity_type_id = $3;