-- name: CreateIndustrialBrokerAgentPropertyBranchDoc :one
INSERT INTO industrial_broker_agent_properties_branch_document (
    documents_categories_id,
    documents_subcategory_id,
    file_url,
    created_at,
    updated_at,
    industrial_broker_agent_properties_branch_id,
    status,
    is_branch
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7 , $8
) RETURNING *;

 
-- name: GetIndustrialBrokerAgentPropertyBranchDoc :one
SELECT * FROM industrial_broker_agent_properties_branch_document 
WHERE id = $1 LIMIT $1;

-- name: GetAllIndustrialBrokerAgentPropertyBranchDoc :many
SELECT * FROM industrial_broker_agent_properties_branch_document
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateIndustrialBrokerAgentPropertyBranchDoc :one
UPDATE industrial_broker_agent_properties_branch_document
SET documents_categories_id = $2,
    documents_subcategory_id = $3,
    file_url = $4,
    created_at = $5,
    updated_at = $6,
    industrial_broker_agent_properties_branch_id = $7,
    status = $8,
    is_branch = $9
Where id = $1
RETURNING *;


-- name: DeleteIndustrialBrokerAgentPropertyBranchDoc :exec
DELETE FROM industrial_broker_agent_properties_branch_document
Where id = $1;


-- name: GetIndustrialBranchBrokerAgentPropertyDocByBrokerAgentPropertyIdAndDocCatIdAndSubDocCatId :one
SELECT *
 FROM industrial_broker_agent_properties_branch_document
WHERE industrial_broker_agent_properties_branch_id=$1 AND documents_categories_id=$2 AND documents_subcategory_id=$3;

-- name: GetIndustrialBrokerAgentPropertyBranchDocById :one
SELECT
industrial_broker_agent_properties_branch_document.id,
industrial_broker_agent_properties_branch_document.documents_categories_id,
industrial_broker_agent_properties_branch_document.documents_subcategory_id,
industrial_broker_agent_properties_branch_document.file_url,
industrial_broker_agent_properties_branch_document.created_at,
industrial_broker_agent_properties_branch_document.updated_at,
industrial_broker_agent_properties_branch_document.industrial_broker_agent_properties_branch_id,
industrial_broker_agent_properties_branch_document.status,
industrial_broker_agent_properties_branch_document.is_branch,
documents_category.category,
documents_subcategory.sub_category
FROM
industrial_broker_agent_properties_branch_document
LEFT JOIN documents_category ON documents_category.id = industrial_broker_agent_properties_branch_document.documents_categories_id
LEFT JOIN documents_subcategory ON documents_subcategory.id = industrial_broker_agent_properties_branch_document.documents_subcategory_id
WHERE
industrial_broker_agent_properties_branch_document.id = $1;

-- name: GetCountIndustrialBrokerAgentPropertyBranchDocByPropertyId :one
SELECT count(*) FROM industrial_broker_agent_properties_branch_document
WHERE industrial_broker_agent_properties_branch_id = $1;

-- name: GetAllIndustrialBrokerAgentPropertyBranchDocByPropertyId :many

SELECT
industrial_broker_agent_properties_branch_document.id,
industrial_broker_agent_properties_branch_document.documents_categories_id,
industrial_broker_agent_properties_branch_document.documents_subcategory_id,
industrial_broker_agent_properties_branch_document.file_url,
industrial_broker_agent_properties_branch_document.created_at,
industrial_broker_agent_properties_branch_document.updated_at,
industrial_broker_agent_properties_branch_document.industrial_broker_agent_properties_branch_id,
industrial_broker_agent_properties_branch_document.status,
industrial_broker_agent_properties_branch_document.is_branch,
documents_category.category,
documents_subcategory.sub_category
FROM
industrial_broker_agent_properties_branch_document
LEFT JOIN documents_category ON documents_category.id = industrial_broker_agent_properties_branch_document.documents_categories_id
LEFT JOIN documents_subcategory ON documents_subcategory.id = industrial_broker_agent_properties_branch_document.documents_subcategory_id
WHERE
industrial_broker_agent_properties_branch_id = $3
ORDER BY
industrial_broker_agent_properties_branch_document.id
LIMIT $1 OFFSET $2;