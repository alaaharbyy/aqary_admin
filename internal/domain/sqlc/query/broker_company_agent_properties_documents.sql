
-- name: CreateBrokerCompanyAgentPropertyDocument :one
INSERT INTO broker_company_agent_properties_documents (
    documents_category_id,
    documents_subcategory_id,
    file_url,
    created_at,
    updated_at,
    broker_company_agent_properties_id,
    status
)VALUES (
    $1, $2, $3, $4, $5, $6, $7
) RETURNING *;

-- name: GetBrokerCompanyAgentPropertyDocument :one
SELECT * FROM broker_company_agent_properties_documents 
WHERE id = $1 LIMIT $1;


-- name: GetAllBrokerCompanyAgentPropertyDocument :many
SELECT * FROM broker_company_agent_properties_documents
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateBrokerCompanyAgentPropertyDocument :one
UPDATE broker_company_agent_properties_documents
SET  documents_category_id = $2,
    documents_subcategory_id = $3,
    file_url = $4,
    created_at = $5,
    updated_at = $6,
    broker_company_agent_properties_id = $7,
    status = $8
Where id = $1
RETURNING *;


-- name: DeleteBrokerCompanyAgentPropertyDocument :exec
DELETE FROM broker_company_agent_properties_documents
Where id = $1;


-- name: GetBrokerCompanyAgentPropertyDocumentsByBrokerCompanyAgentPropertyIdAndDocCatIdAndSubDocCatId :one
SELECT  * FROM broker_company_agent_properties_documents 
WHERE broker_company_agent_properties_id = $1 
AND
 documents_category_id = $2
AND 
documents_subcategory_id = $3;

-- name: GetAllBrokerAgentPropertyDocByPropertyId :many
SELECT broker_company_agent_properties_documents.*,documents_category.category,documents_subcategory.sub_category FROM broker_company_agent_properties_documents LEFT JOIN documents_category ON documents_category.id=broker_company_agent_properties_documents.documents_category_id LEFT JOIN documents_subcategory ON documents_subcategory.id=broker_company_agent_properties_documents.documents_subcategory_id WHERE broker_company_agent_properties_id=$3 ORDER BY broker_company_agent_properties_documents.id OFFSET $2 LIMIT $1;


-- name: GetCountBrokerAgentPropertyDocByPropertyId :one
SELECT count(*) FROM broker_company_agent_properties_documents 
WHERE broker_company_agent_properties_id = $1;


-- name: GetBrokerCompanyAgentPropertyDocById :one
SELECT broker_company_agent_properties_documents.*,documents_category.category,documents_subcategory.sub_category 
FROM broker_company_agent_properties_documents 
LEFT JOIN documents_category ON documents_category.id = broker_company_agent_properties_documents.documents_category_id 
LEFT JOIN documents_subcategory ON documents_subcategory.id = broker_company_agent_properties_documents.documents_subcategory_id 
WHERE broker_company_agent_properties_documents.id = $1;
