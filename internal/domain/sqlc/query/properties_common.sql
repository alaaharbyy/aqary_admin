-- name: GetPropertyInfo :one
with x as (
SELECT id, status,  property_name, category,'agricultural' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM agricultural_freelancer_properties where agricultural_freelancer_properties.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'agricultural' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM agricultural_broker_agent_properties where agricultural_broker_agent_properties.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'agricultural' AS section, true as is_branch , property, addresses_id, users_id, unit_types FROM agricultural_broker_agent_properties_branch where agricultural_broker_agent_properties_branch.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'agricultural' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM agricultural_owner_properties where agricultural_owner_properties.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'industrial' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM industrial_freelancer_properties where industrial_freelancer_properties.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'industrial' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM industrial_broker_agent_properties where industrial_broker_agent_properties.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'industrial' AS section, true as is_branch , property, addresses_id, users_id, unit_types FROM industrial_broker_agent_properties_branch where industrial_broker_agent_properties_branch.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'industrial' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM industrial_owner_properties where industrial_owner_properties.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'property_hub' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM freelancers_properties where freelancers_properties.ref_no ILIKE $1  
UNION ALL
SELECT id, status,  property_name, category,'property_hub' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM broker_company_agent_properties where broker_company_agent_properties.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'property_hub' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM broker_company_agent_properties_branch where broker_company_agent_properties_branch.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'property_hub' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM owner_properties where owner_properties.ref_no ILIKE $1 ) select * from x limit 1;

-- name: GetPropertiesInfoFromRefNo :many
with x as (
SELECT id, status,  property_name, category,'agricultural' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM agricultural_freelancer_properties where agricultural_freelancer_properties.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'agricultural' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM agricultural_broker_agent_properties where agricultural_broker_agent_properties.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'agricultural' AS section, true as is_branch , property, addresses_id, users_id, unit_types FROM agricultural_broker_agent_properties_branch where agricultural_broker_agent_properties_branch.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'agricultural' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM agricultural_owner_properties where agricultural_owner_properties.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'industrial' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM industrial_freelancer_properties where industrial_freelancer_properties.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'industrial' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM industrial_broker_agent_properties where industrial_broker_agent_properties.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'industrial' AS section, true as is_branch , property, addresses_id, users_id, unit_types FROM industrial_broker_agent_properties_branch where industrial_broker_agent_properties_branch.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'industrial' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM industrial_owner_properties where industrial_owner_properties.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'property_hub' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM freelancers_properties where freelancers_properties.ref_no ILIKE $1  
UNION ALL
SELECT id, status,  property_name, category,'property_hub' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM broker_company_agent_properties where broker_company_agent_properties.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'property_hub' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM broker_company_agent_properties_branch where broker_company_agent_properties_branch.ref_no ILIKE $1
UNION ALL
SELECT id, status,  property_name, category,'property_hub' AS section, false as is_branch , property, addresses_id, users_id, unit_types FROM owner_properties where owner_properties.ref_no ILIKE $1 ) select * from x;

-- name: GetAllPropertiesReferences :many
with x as (
--PROPERTIES
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM freelancers_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM broker_company_agent_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM broker_company_agent_properties_branch fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM owner_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
-- AGRICULTURAL
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM agricultural_freelancer_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM agricultural_broker_agent_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM agricultural_broker_agent_properties_branch fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM agricultural_owner_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
-- INDUSTRIAL
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM industrial_freelancer_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM industrial_broker_agent_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM industrial_broker_agent_properties_branch fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM industrial_owner_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
) Select * from x ORDER BY id;

-- name: GetSinglePropertyRefNo :one
with x as (
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type" FROM project_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id WHERE fp.id = $1 AND fp.property = $2 AND false = $3 AND 'prop' = $4
UNION
--PROPERTY HUB
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type" FROM freelancers_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id WHERE fp.id = $1 AND fp.property = $2 AND false = $3 AND 'prop' = $4
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type" FROM broker_company_agent_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id WHERE fp.id = $1 AND fp.property = $2 AND false = $3 AND 'prop' = $4
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type" FROM broker_company_agent_properties_branch fp
JOIN property_types pt ON fp.property_types_id = pt.id WHERE fp.id = $1 AND fp.property = $2 AND true = $3 AND 'prop' = $4
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type" FROM owner_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id WHERE fp.id = $1 AND fp.property = $2 AND false = $3 AND 'prop' = $4
UNION
-- AGRICULTURAL
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type" FROM agricultural_freelancer_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id WHERE fp.id = $1 AND fp.property = $2 AND false = $3 AND 'agr' = $4
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type" FROM agricultural_broker_agent_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id WHERE fp.id = $1 AND fp.property = $2 AND false = $3 AND 'agr' = $4
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type" FROM agricultural_broker_agent_properties_branch fp
JOIN property_types pt ON fp.property_types_id = pt.id WHERE fp.id = $1 AND fp.property = $2 AND true = $3 AND 'agr' = $4
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type" FROM agricultural_owner_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id WHERE fp.id = $1 AND fp.property = $2 AND false = $3 AND 'agr' = $4
UNION
-- INDUSTRIAL
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type" FROM industrial_freelancer_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id WHERE fp.id = $1 AND fp.property = $2 AND false = $3 AND 'ind' = $4
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type" FROM industrial_broker_agent_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id WHERE fp.id = $1 AND fp.property = $2 AND false = $3 AND 'ind' = $4
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type" FROM industrial_broker_agent_properties_branch fp
JOIN property_types pt ON fp.property_types_id = pt.id WHERE fp.id = $1 AND fp.property = $2 AND true = $3 AND 'ind' = $4
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type" FROM industrial_owner_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id WHERE fp.id = $1 AND fp.property = $2 AND false = $3 AND 'ind' = $4
) Select * from x LIMIT 1;

-- name: GetCountAllPropertiesReferences :one
with x as (
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM freelancers_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM broker_company_agent_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM broker_company_agent_properties_branch fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM owner_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM agricultural_freelancer_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM agricultural_broker_agent_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM agricultural_broker_agent_properties_branch fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM agricultural_owner_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM industrial_freelancer_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM industrial_broker_agent_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM industrial_broker_agent_properties_branch fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
UNION
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status, fp.category,  pf.properties_id, pf.property,
pf.is_branch FROM industrial_owner_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id 
) Select count(*) from x;