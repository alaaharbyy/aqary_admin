-- name: CreateIndustrialBrokerAgentPropertyDoc :one
INSERT INTO industrial_broker_agent_properties_documents (
    documents_category_id,
    documents_subcategory_id,
    file_url,
    created_at,
    updated_at,
    industrial_broker_agent_properties_id,
    status,
    is_branch
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7 , $8
) RETURNING *;

 
-- name: GetIndustrialBrokerAgentPropertyDoc :one
SELECT * FROM industrial_broker_agent_properties_documents 
WHERE id = $1 LIMIT $1;

-- name: GetAllIndustrialBrokerAgentPropertyDoc :many
SELECT * FROM industrial_broker_agent_properties_documents
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateIndustrialBrokerAgentPropertyDoc :one
UPDATE industrial_broker_agent_properties_documents
SET documents_category_id = $2,
    documents_subcategory_id = $3,
    file_url = $4,
    created_at = $5,
    updated_at = $6,
    industrial_broker_agent_properties_id = $7,
    status = $8,
    is_branch = $9
Where id = $1
RETURNING *;


-- name: DeleteIndustrialBrokerAgentPropertyDoc :exec
DELETE FROM industrial_broker_agent_properties_documents
Where id = $1;


-- name: GetIndustrialBrokerAgentPropertyDocByBrokerAgentPropertyIdAndDocCatIdAndSubDocCatId :one
SELECT  * FROM industrial_broker_agent_properties_documents
WHERE industrial_broker_agent_properties_id = $1
AND
 documents_category_id = $2
AND
documents_subcategory_id = $3;


-- name: GetIndustrialBrokerAgentPropertyDocById :one

SELECT
industrial_broker_agent_properties_documents.*,
documents_category.category,
documents_subcategory.sub_category
FROM
industrial_broker_agent_properties_documents
LEFT JOIN documents_category ON documents_category.id = industrial_broker_agent_properties_documents.documents_category_id
LEFT JOIN documents_subcategory ON documents_subcategory.id = industrial_broker_agent_properties_documents.documents_subcategory_id
WHERE
industrial_broker_agent_properties_documents.id = $1;


-- name: GetCountIndustrialBrokerAgentPropertyDocByPropertyId :one
SELECT count(*) FROM industrial_broker_agent_properties_documents
WHERE industrial_broker_agent_properties_id = $1;

-- name: GetAllIndustrialBrokerAgentPropertyDocByPropertyId :many
SELECT
industrial_broker_agent_properties_documents.*,
documents_category.category,
documents_subcategory.sub_category
FROM
industrial_broker_agent_properties_documents
LEFT JOIN documents_category ON documents_category.id = industrial_broker_agent_properties_documents.documents_category_id
LEFT JOIN documents_subcategory ON documents_subcategory.id = industrial_broker_agent_properties_documents.documents_subcategory_id
WHERE
industrial_broker_agent_properties_id = $3
ORDER BY
industrial_broker_agent_properties_documents.id OFFSET $2
LIMIT $1;
