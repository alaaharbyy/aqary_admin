-- name: CreateBrokerCompanyAgentPropertyBranch :one
INSERT INTO  broker_company_agent_properties_branch (
  property_title,
  property_title_arabic,
  description,
  description_arabic,
  is_verified,
  property_rank,
  addresses_id,
  locations_id, 
  property_types_id,
  profiles_id,
  status,
  created_at,
  updated_at,
  facilities_id,
  amenities_id,
  broker_companies_branches_id,
  broker_company_branches_agents,
  is_show_owner_info,
  property,
  -- facts_values,
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
  -- ask_price,
  unit_types,
  users_id, 
  from_xml,
  property_name,
   list_of_date,
  list_of_notes,
  list_of_agent,
  owner_users_id
)VALUES (
    $1 ,$2,$3, $4,$5,$6,$7,$8,$9,$10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25,  $26, $27, $28, $29, $30, $31, $32, $33,  $34, $35, $36, $37
) RETURNING *;

-- name: GetBrokerCompanyAgentPropertyBranch :one
SELECT * FROM  broker_company_agent_properties_branch 
WHERE id = $1 LIMIT $1;

-- name: GetBrokerCompanyAgentPropertyBranchByName :one
SELECT * FROM  broker_company_agent_properties_branch 
WHERE property_title = $2 LIMIT $1;


-- name: GetAllBrokerCompanyAgentPropertyBranch :many
SELECT * FROM  broker_company_agent_properties_branch
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateBrokerCompanyAgentPropertyBranch :one
UPDATE  broker_company_agent_properties_branch
SET    property_title = $2,
  property_title_arabic = $3,
  description = $4,
  description_arabic = $5,
  is_verified = $6,
  property_rank = $7,
  addresses_id = $8,
  locations_id = $9, 
  property_types_id = $10,
  profiles_id = $11,
  status = $12,
  created_at = $13,
  updated_at = $14,
  facilities_id = $15,
  amenities_id = $16,
  broker_companies_branches_id = $17,
  broker_company_branches_agents = $18,
  is_show_owner_info = $19,
  property = $20,
  -- facts_values = $21,
  countries_id = $21,
  ref_no  = $22,
  developer_company_name= $23,
  sub_developer_company_name= $24,
  is_branch = $25,
    category = $26,
  investment = $27,
  contract_start_datetime = $28,
  contract_end_datetime = $29,
  amount = $30,
  -- ask_price = $31,
  unit_types = $31,
  users_id = $32,
  from_xml = $33,
  property_name = $34,
          list_of_date = $35,
  list_of_notes = $36,
  list_of_agent = $37,
  owner_users_id = $38
Where id = $1
RETURNING *;

-- name: DeleteBrokerCompanyAgentPropertyBranch :exec
DELETE FROM  broker_company_agent_properties_branch
Where id = $1;

-- name: UpdateBrokerCompanyAgentPropertyBranchStatusById :one
UPDATE  broker_company_agent_properties_branch 
SET status = $2 
WHERE id = $1
RETURNING *;

-- name: UpdateBrokerCompanyAgentPropertyBranchRankById :one
UPDATE  broker_company_agent_properties_branch 
SET property_rank = $2 
WHERE id = $1
RETURNING *;


-- name: UpdateBrokerCompanyAgentPropertyBranchVerificationById :one
UPDATE  broker_company_agent_properties_branch 
SET is_verified = $2 
WHERE id = $1
RETURNING *;


-- name: GetFacilitiesIdByBrokerCompanyAgentPropertyBranchId :one
SELECT broker_company_agent_properties_branch.facilities_id FROM broker_company_agent_properties_branch WHERE id = $1;


-- name: GetAmenitiesIdByBrokerCompanyAgentPropertyBranchId :one
SELECT broker_company_agent_properties_branch.amenities_id FROM broker_company_agent_properties_branch WHERE id = $1;



-- name: GetBrokerBranchAgentPropertiesByBrokerAgentId :many 
 select id, property_title, property from broker_company_agent_properties_branch bcapb where bcapb.broker_company_branches_agents = $1;


-- name: GetBrokerbranchAgentPropertiesByBrokerBranchCompaniesId :many
select id, property_title, property, is_branch
from broker_company_agent_properties_branch bcapb where bcapb.broker_companies_branches_id = $1 and bcapb.category = 'rent' and bcapb.from_xml = false;


-- name: GetBrokerCompanyAgentPropertyBranchWithValidation :one
SELECT
    id,
    property_title,
    property_title_arabic,
    description,
    description_arabic,
    is_verified,
    property_rank,
    addresses_id,
    locations_id,
    property_types_id,
    profiles_id,
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
    list_of_date,
    list_of_notes,
    list_of_agent,
    owner_users_id
from
    broker_company_agent_properties_branch fp
WHERE
    CASE
        WHEN $1 :: bigint = 0 THEN true
        WHEN $1 :: bigint = 1 THEN fp.addresses_id IN (
            SELECT
                id
            FROM
                addresses
            WHERE
                addresses.cities_id = $2
        )
        WHEN $1 :: bigint = 2 THEN fp.addresses_id IN (
            SELECT
                id
            FROM
                addresses
            WHERE
                addresses.cities_id = $2
                AND communities_id = ANY($3 :: bigint [])
        )
        WHEN $1 :: bigint = 3 THEN fp.addresses_id IN (
            SELECT
                id
            FROM
                addresses
            WHERE
                addresses.cities_id = $2
                AND communities_id = ANY($3 :: bigint [])
                AND sub_communities_id = ANY($4 :: bigint [])
        )
        WHEN $1 :: bigint = 4 THEN fp.addresses_id IN (
            SELECT
                id
            FROM
                addresses
            WHERE
                addresses.cities_id = $2
                AND communities_id = ANY($3 :: bigint [])
                AND sub_communities_id = ANY($4 :: bigint [])
                AND addresses.locations_id = $5
        )
    END
    AND (
        status != 5
        AND status != 6
    )
    AND fp.id = $6
LIMIT
    1;

-- name: GetBrokerCompanyAgentPropertiesBranchByRefrenceNumber :one
SELECT * FROM broker_company_agent_properties_branch WHERE ref_no = $1 LIMIT 1;