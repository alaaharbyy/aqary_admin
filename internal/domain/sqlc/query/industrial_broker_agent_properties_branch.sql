-- name: CreateIndustrialBrokerAgentPropertyBranch :one
INSERT INTO industrial_broker_agent_properties_branch (
    property_title,
    property_title_arabic,
    description,
    description_arabic,
    is_verified,
    property_rank,
    addresses_id,
    locations_id,
    property_types_id,
    status,
    created_at,
    updated_at,
    facilities_id,
    amenities_id,
    broker_companies_branches_id,
    broker_company_branches_agents,
    is_show_owner_info,
    property,
    countries_id,
    ref_no,
    developer_company_name,
    sub_developer_company_name,
    is_branch,
    category,
    investment,
    contract_start_datetime,
    contract_end_datetime,
    amount,
    unit_types,
    users_id,
    property_name,
    from_xml,
    owner_users_id
)VALUES (
     $1 ,$2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33
) RETURNING *;

 
-- name: GetIndustrialBrokerAgentPropertyBranch :one
SELECT * FROM industrial_broker_agent_properties_branch 
WHERE id = $1 LIMIT $1;

-- name: GetAllIndustrialBrokerAgentPropertyBranch :many
SELECT * FROM industrial_broker_agent_properties_branch
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateIndustrialBrokerAgentPropertyBranch :one
UPDATE industrial_broker_agent_properties_branch
SET   property_title = $2,
    property_title_arabic = $3,
    description = $4,
    description_arabic = $5,
    is_verified = $6,
    property_rank = $7,
    addresses_id = $8,
    locations_id = $9,
    property_types_id = $10,
    status = $11,
    created_at = $12,
    updated_at = $13,
    facilities_id = $14,
    amenities_id = $15,
    broker_companies_branches_id = $16,
    broker_company_branches_agents = $17,
    is_show_owner_info = $18,
    property = $19,
    countries_id = $20,
    ref_no = $21,
    developer_company_name = $22,
    sub_developer_company_name = $23,
    is_branch = $24,
    category = $25,
    investment = $26,
    contract_start_datetime = $27,
    contract_end_datetime = $28,
    amount = $29,
    unit_types = $30,
    users_id = $31,
    property_name = $32,
    from_xml = $33,
    owner_users_id = $34
Where id = $1
RETURNING *;


-- name: DeleteIndustrialBrokerAgentPropertyBranch :exec
DELETE FROM industrial_broker_agent_properties_branch
Where id = $1;


-- name: UpdateIndustrialBrokerAgentPropertyBranchVerifyStatus :one
UPDATE industrial_broker_agent_properties_branch SET is_verified = $2 WHERE id = $1 RETURNING *;


-- name: UpdateIndustrialBrokerAgentPropertyBranchStatus :one
 UPDATE industrial_broker_agent_properties_branch SET status = $2 WHERE id = $1 RETURNING *;


-- name: UpdateIndustrialBrokerAgentPropertyBranchRank :one
UPDATE industrial_broker_agent_properties_branch SET property_rank = $2 WHERE id = $1 RETURNING *;