-- name: CreateBrokerCompanyAgentProperty :one
INSERT INTO broker_company_agent_properties (
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
  facilities_id,
  amenities_id,
  status,
  created_at,
  updated_at,
  broker_companies_id,
  broker_company_agents,
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
    $1 ,$2,$3, $4,$5,$6,$7,$8,$9,$10, $11, $12, $13, $14,  $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, $35, $36, $37
) RETURNING *;

-- name: GetBrokerCompanyAgentProperty :one
SELECT * FROM broker_company_agent_properties 
WHERE id = $1;

-- name: GetBrokerCompanyAgentPropertyByName :one
SELECT * FROM broker_company_agent_properties 
WHERE property_title = $1;


-- name: GetAllBrokerCompanyAgentProperty :many
SELECT * FROM broker_company_agent_properties
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateBrokerCompanyAgentProperty :one
UPDATE broker_company_agent_properties
SET   property_title = $2,
  property_title_arabic = $3,
  description = $4,
  description_arabic = $5,
  is_verified = $6,
  property_rank = $7,
  addresses_id = $8,
  locations_id = $9, 
  property_types_id = $10,
  profiles_id = $11,
  facilities_id = $12,
  amenities_id = $13,
  status = $14,
   created_at = $15,
  updated_at = $16,
  broker_companies_id = $17,
  broker_company_agents = $18,
  is_show_owner_info = $19,
  property = $20,
  -- facts_values = $21,
  countries_id = $21,
  ref_no = $22,
  developer_company_name = $23,
  sub_developer_company_name = $24,
  is_branch = $25,
  category = $26,
  investment = $27,
  contract_start_datetime = $28,
  contract_end_datetime = $29,
  amount = $30,
  -- ask_price = $32,
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


-- name: DeleteBrokerCompanyAgentProperty :exec
DELETE FROM broker_company_agent_properties
Where id = $1;



-- name: UpdateBrokerCompanyAgentPropertyStatusById :one
UPDATE broker_company_agent_properties 
SET status = $2 
WHERE id = $1
RETURNING *;

-- name: UpdateBrokerCompanyAgentPropertyRankById :one
UPDATE broker_company_agent_properties 
SET property_rank = $2 
WHERE id = $1
RETURNING *;


-- name: UpdateBrokerCompanyAgentPropertyVerificationById :one
UPDATE broker_company_agent_properties 
SET is_verified = $2 
WHERE id = $1
RETURNING *;




-- name: GetFacilitiesIdByBrokerCompanyAgentPropertyId :one
SELECT broker_company_agent_properties.facilities_id FROM broker_company_agent_properties WHERE id = $1;


-- name: GetAmenitiesIdByBrokerCompanyAgentPropertyId :one
SELECT broker_company_agent_properties.amenities_id FROM broker_company_agent_properties WHERE id = $1;


-- name: GetBrokerAgentPropertiesByBrokerCompaniesId :many
 select id, property_title, property , is_branch
from broker_company_agent_properties bcap  where bcap.broker_companies_id = $1 and bcap.category = 'rent' and bcap.from_xml = false;

-- name: GetBrokerAgentPropertiesByBrokerAgentId :many
WITH x AS (
  SELECT
    broker_company_agent_properties.id,

    broker_company_agent_properties.property_title,

    broker_company_agent_properties.is_branch,

    broker_company_agent_properties.property

  FROM

    broker_company_agent_properties

  LEFT JOIN

    broker_company_agents

  ON

    broker_company_agents.id = broker_company_agent_properties.broker_company_agents

  where

    broker_company_agent_properties.category = 'rent' and

    broker_company_agents.users_id = $1 

    AND broker_company_agent_properties.from_xml = false

  UNION ALL

  SELECT

    broker_company_agent_properties_branch.id,

    broker_company_agent_properties_branch.property_title,

    broker_company_agent_properties_branch.is_branch,

    broker_company_agent_properties_branch.property

  FROM

    broker_company_agent_properties_branch

  LEFT JOIN

    broker_company_branches_agents

  ON

    broker_company_branches_agents.id = broker_company_agent_properties_branch.broker_company_branches_agents

  where

    broker_company_agent_properties_branch.category = 'rent' and

    broker_company_branches_agents.users_id = $1

    AND broker_company_agent_properties_branch.from_xml = false

)

SELECT

  id,

  property_title,

  is_branch,

  property

FROM x;

-- name: GetBrokerCompanyAgentPropertyWithValidation :one
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
    broker_companies_id,
    broker_company_agents,
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
    broker_company_agent_properties fp
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

-- name: GetBrokerCompanyAgentPropertiesByRefrenceNumber :one
SELECT * FROM broker_company_agent_properties WHERE ref_no = $1 LIMIT 1;