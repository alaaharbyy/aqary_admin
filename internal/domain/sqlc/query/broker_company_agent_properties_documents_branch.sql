
-- name: CreateBrokerCompanyAgentPropertyBranchDocument :one
INSERT INTO broker_company_agent_properties_documents_branch (
    documents_category_id,
    documents_subcategory_id,
    file_url,
    created_at,
    updated_at,
    broker_company_agent_properties_branch_id,
    status
)VALUES (
    $1, $2, $3, $4, $5, $6, $7
) RETURNING *;

-- name: GetBrokerCompanyAgentPropertyBranchDocument :one
SELECT * FROM broker_company_agent_properties_documents_branch 
WHERE id = $1 LIMIT $1;


-- name: GetAllBrokerCompanyAgentPropertyBranchDocument :many
SELECT * FROM broker_company_agent_properties_documents_branch
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateBrokerCompanyAgentPropertyBranchDocument :one
UPDATE broker_company_agent_properties_documents_branch
SET  documents_category_id = $2,
    documents_subcategory_id = $3,
    file_url = $4,
    created_at = $5,
    updated_at = $6,
    broker_company_agent_properties_branch_id = $7,
    status = $8
Where id = $1
RETURNING *;


-- name: DeleteBrokerCompanyAgentPropertyBranchDocument :exec
DELETE FROM broker_company_agent_properties_documents_branch
Where id = $1;


-- name: GetBranchBrokerCompanyAgentPropertyDocumentsByBrokerCompanyAgentPropertyIdAndDocCatIdAndSubDocCatId :one
SELECT id,documents_category_id,documents_subcategory_id,file_url,created_at,updated_at,broker_company_agent_properties_branch_id,status,is_branch
 FROM broker_company_agent_properties_documents_branch 
WHERE broker_company_agent_properties_branch_id=$1 AND documents_category_id=$2 AND documents_subcategory_id=$3;


-- /-- name: GetBrokerCompanyAgentPropertyBranchDocumentsByBrokerCompanyAgentPropertyIdAndDocCatIdAndSubDocCatId :one
-- SELECT  * FROM broker_company_agent_properties_documents_branch 
-- WHERE broker_company_agent_properties_id = $1 
-- AND
--  documents_category_id = $2
-- AND 
-- documents_subcategory_id = $3;

-- -- name: GetAllBrokerAgentPropertyDocByPropertyId :many
-- SELECT broker_company_agent_properties_documents_branch.*, documents_category.category,documents_subcategory.sub_category
-- FROM broker_company_agent_properties_documents_branch LEFT JOIN documents_category ON documents_category.id = broker_company_agent_properties_documents_branch.documents_category_id 
-- LEFT JOIN documents_subcategory ON documents_subcategory.id = broker_company_agent_properties_documents_branch.documents_subcategory_id 
-- WHERE broker_company_agent_properties_id = $3 OFFSET $2 LIMIT $1;


-- -- name: GetCountBrokerAgentPropertyDocByPropertyId :one
-- SELECT count(*) FROM broker_company_agent_properties_documents_branch 
-- WHERE broker_company_agent_properties_id = $1;


-- -- name: GetBrokerCompanyAgentPropertyDocById :one
-- SELECT broker_company_agent_properties_documents_branch.*,documents_category.category,documents_subcategory.sub_category 
-- FROM broker_company_agent_properties_documents_branch 
-- LEFT JOIN documents_category ON documents_category.id = broker_company_agent_properties_documents_branch.documents_category_id 
-- LEFT JOIN documents_subcategory ON documents_subcategory.id = broker_company_agent_properties_documents_branch.documents_subcategory_id 
-- WHERE broker_company_agent_properties_documents_branch.id = $1;



-- name: GetBranchBrokerCompanyAgentPropertyDocById :one

SELECT
broker_company_agent_properties_documents_branch.id,
broker_company_agent_properties_documents_branch.documents_category_id,
broker_company_agent_properties_documents_branch.documents_subcategory_id,broker_company_agent_properties_documents_branch.file_url,
broker_company_agent_properties_documents_branch.created_at,broker_company_agent_properties_documents_branch.updated_at,broker_company_agent_properties_documents_branch.broker_company_agent_properties_branch_id,broker_company_agent_properties_documents_branch.status,
broker_company_agent_properties_documents_branch.is_branch,documents_category.category,
documents_subcategory.sub_category 
FROM broker_company_agent_properties_documents_branch LEFT JOIN documents_category ON documents_category.id=broker_company_agent_properties_documents_branch.documents_category_id
 LEFT JOIN documents_subcategory ON documents_subcategory.id=broker_company_agent_properties_documents_branch.documents_subcategory_id 
WHERE broker_company_agent_properties_documents_branch.id=$1;



-- name: GetAllBranchBrokerAgentPropertyDocByPropertyId :many
SELECT broker_company_agent_properties_documents_branch.id,broker_company_agent_properties_documents_branch.documents_category_id,broker_company_agent_properties_documents_branch.documents_subcategory_id,broker_company_agent_properties_documents_branch.file_url,broker_company_agent_properties_documents_branch.created_at,broker_company_agent_properties_documents_branch.updated_at,broker_company_agent_properties_documents_branch.broker_company_agent_properties_branch_id,broker_company_agent_properties_documents_branch.status,broker_company_agent_properties_documents_branch.is_branch,documents_category.category,documents_subcategory.sub_category FROM broker_company_agent_properties_documents_branch LEFT JOIN documents_category ON documents_category.id=broker_company_agent_properties_documents_branch.documents_category_id LEFT JOIN documents_subcategory ON documents_subcategory.id=broker_company_agent_properties_documents_branch.documents_subcategory_id WHERE broker_company_agent_properties_branch_id=$3 ORDER BY broker_company_agent_properties_documents_branch.id LIMIT $1 OFFSET $2;
 


-- name: GetCountBranchBrokerAgentPropertyDocByPropertyId :one
SELECT count(*)FROM broker_company_agent_properties_documents_branch 
WHERE broker_company_agent_properties_branch_id=$1;