-- name: GetAllPropertyReviews :many
with x as (
-- freelancers_properties
SELECT fp.id,fp.category,pf.is_branch,fp.users_id AS usersid,fp.status,fp.property_name
FROM freelancers_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id
WHERE fp.users_id=$1 AND fp.status!=6
UNION
-- broker_company_agent_properties
SELECT bcap.id,bcap.category,pf.is_branch,bcap.users_id AS usersid,bcap.status,bcap.property_name
FROM broker_company_agent_properties bcap
JOIN property_types pt ON bcap.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = bcap.id
WHERE bcap.users_id=$1 AND bcap.status!=6
UNION
-- broker_company_agent_properties_branch
SELECT bcapb.id,bcapb.category,pf.is_branch,bcapb.users_id AS usersid,bcapb.status,bcapb.property_name
FROM broker_company_agent_properties_branch bcapb
JOIN property_types pt ON bcapb.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = bcapb.id
WHERE bcapb.users_id=$1 AND bcapb.status!=6
UNION
-- owner_properties
SELECT op.id,op.category,pf.is_branch ,op.users_id AS usersid,op.status,op.property_name
FROM owner_properties op
JOIN property_types pt ON op.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = op.id
WHERE op.users_id=$1 AND op.status!=6
UNION
-- agricultural_freelancer_properties
SELECT afp.id,afp.category, pf.is_branch,afp.users_id AS usersid,afp.status,afp.property_name
FROM agricultural_freelancer_properties afp
JOIN property_types pt ON afp.property_types_id = pt.id
LEFT JOIN agricultural_properties_facts pf ON pf.properties_id = afp.id
WHERE afp.users_id=$1 AND afp.status!=6
UNION
-- agricultural_broker_agent_properties
SELECT abap.id,abap.category,pf.is_branch,abap.users_id AS usersid,abap.status,abap.property_name
FROM agricultural_broker_agent_properties abap
JOIN property_types pt ON abap.property_types_id = pt.id
LEFT JOIN agricultural_properties_facts pf ON pf.properties_id = abap.id
WHERE abap.users_id=$1 AND abap.status!=6
UNION
-- agricultural_broker_agent_properties_branch
SELECT abapb.id,abapb.category,pf.is_branch,abapb.users_id AS usersid,abapb.status,abapb.property_name
FROM agricultural_broker_agent_properties_branch abapb
JOIN property_types pt ON abapb.property_types_id = pt.id
LEFT JOIN agricultural_properties_facts pf ON pf.properties_id = abapb.id
WHERE abapb.users_id=$1 AND abapb.status!=6
UNION
-- agricultural_owner_properties
SELECT aop.id,aop.category, pf.is_branch,aop.users_id AS usersid,aop.status,aop.property_name
FROM agricultural_owner_properties aop
JOIN property_types pt ON aop.property_types_id = pt.id
LEFT JOIN agricultural_properties_facts pf ON pf.properties_id = aop.id
WHERE aop.users_id=$1 AND aop.status!=6
UNION
-- industrial_freelancer_properties
SELECT ifp.id,ifp.category,pf.is_branch,ifp.users_id AS usersid,ifp.status,ifp.property_name
FROM industrial_freelancer_properties ifp
JOIN property_types pt ON ifp.property_types_id = pt.id
LEFT JOIN industrial_properties_facts pf ON pf.properties_id = ifp.id
WHERE ifp.users_id=$1 AND ifp.status!=6
UNION
-- industrial_broker_agent_properties
SELECT ibap.id,ibap.category,pf.is_branch,ibap.users_id AS usersid,ibap.status,ibap.property_name
FROM industrial_broker_agent_properties ibap
JOIN property_types pt ON ibap.property_types_id = pt.id
LEFT JOIN industrial_properties_facts pf ON pf.properties_id = ibap.id
WHERE ibap.users_id=$1 AND ibap.status!=6
UNION
-- industrial_broker_agent_properties_branch
SELECT ibapb.id, ibapb.category,pf.is_branch,ibapb.users_id AS usersid,ibapb.status,ibapb.property_name
FROM industrial_broker_agent_properties_branch ibapb
JOIN property_types pt ON ibapb.property_types_id = pt.id
LEFT JOIN industrial_properties_facts pf ON pf.properties_id = ibapb.id
WHERE ibapb.users_id=$1 AND ibapb.status!=6
UNION
-- industrial_owner_properties
SELECT iop.id,iop.category,pf.is_branch,iop.users_id AS usersid,iop.status,iop.property_name
FROM industrial_owner_properties iop
JOIN property_types pt ON iop.property_types_id = pt.id
LEFT JOIN industrial_properties_facts pf ON pf.properties_id = iop.id
WHERE iop.users_id=$1 AND iop.status!=6
)Select pr.*, x.id as property_id, x.property_name,usersid,u.email,u.username from x
join property_reviews pr on pr.property_unit_id=x.id and pr.property_unit_category=x.category and pr.is_branch=x.is_branch
join users u on pr.reviewer=u.id
LIMIT $2
OFFSET $3;

-- name: GetCountAllPropertyReviews :one
with x as (
-- freelancers_properties
SELECT fp.id,fp.category,pf.is_branch,fp.users_id AS usersid,fp.status,fp.property_name
FROM freelancers_properties fp
JOIN property_types pt ON fp.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id
WHERE fp.users_id=$1 AND fp.status!=6
UNION
-- broker_company_agent_properties
SELECT bcap.id,bcap.category,pf.is_branch,bcap.users_id AS usersid,bcap.status,bcap.property_name
FROM broker_company_agent_properties bcap
JOIN property_types pt ON bcap.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = bcap.id
WHERE bcap.users_id=$1 AND bcap.status!=6
UNION
-- broker_company_agent_properties_branch
SELECT bcapb.id,bcapb.category,pf.is_branch,bcapb.users_id AS usersid,bcapb.status,bcapb.property_name
FROM broker_company_agent_properties_branch bcapb
JOIN property_types pt ON bcapb.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = bcapb.id
WHERE bcapb.users_id=$1 AND bcapb.status!=6
UNION
-- owner_properties
SELECT op.id,op.category,pf.is_branch ,op.users_id AS usersid,op.status,op.property_name
FROM owner_properties op
JOIN property_types pt ON op.property_types_id = pt.id
LEFT JOIN properties_facts pf ON pf.properties_id = op.id
WHERE op.users_id=$1 AND op.status!=6
UNION
-- agricultural_freelancer_properties
SELECT afp.id,afp.category, pf.is_branch,afp.users_id AS usersid,afp.status,afp.property_name
FROM agricultural_freelancer_properties afp
JOIN property_types pt ON afp.property_types_id = pt.id
LEFT JOIN agricultural_properties_facts pf ON pf.properties_id = afp.id
WHERE afp.users_id=$1 AND afp.status!=6
UNION
-- agricultural_broker_agent_properties
SELECT abap.id,abap.category,pf.is_branch,abap.users_id AS usersid,abap.status,abap.property_name
FROM agricultural_broker_agent_properties abap
JOIN property_types pt ON abap.property_types_id = pt.id
LEFT JOIN agricultural_properties_facts pf ON pf.properties_id = abap.id
WHERE abap.users_id=$1 AND abap.status!=6
UNION
-- agricultural_broker_agent_properties_branch
SELECT abapb.id,abapb.category,pf.is_branch,abapb.users_id AS usersid,abapb.status,abapb.property_name
FROM agricultural_broker_agent_properties_branch abapb
JOIN property_types pt ON abapb.property_types_id = pt.id
LEFT JOIN agricultural_properties_facts pf ON pf.properties_id = abapb.id
WHERE abapb.users_id=$1 AND abapb.status!=6
UNION
-- agricultural_owner_properties
SELECT aop.id,aop.category, pf.is_branch,aop.users_id AS usersid,aop.status,aop.property_name
FROM agricultural_owner_properties aop
JOIN property_types pt ON aop.property_types_id = pt.id
LEFT JOIN agricultural_properties_facts pf ON pf.properties_id = aop.id
WHERE aop.users_id=$1 AND aop.status!=6
UNION
-- industrial_freelancer_properties
SELECT ifp.id,ifp.category,pf.is_branch,ifp.users_id AS usersid,ifp.status,ifp.property_name
FROM industrial_freelancer_properties ifp
JOIN property_types pt ON ifp.property_types_id = pt.id
LEFT JOIN industrial_properties_facts pf ON pf.properties_id = ifp.id
WHERE ifp.users_id=$1 AND ifp.status!=6
UNION
-- industrial_broker_agent_properties
SELECT ibap.id,ibap.category,pf.is_branch,ibap.users_id AS usersid,ibap.status,ibap.property_name
FROM industrial_broker_agent_properties ibap
JOIN property_types pt ON ibap.property_types_id = pt.id
LEFT JOIN industrial_properties_facts pf ON pf.properties_id = ibap.id
WHERE ibap.users_id=$1 AND ibap.status!=6
UNION
-- industrial_broker_agent_properties_branch
SELECT ibapb.id, ibapb.category,pf.is_branch,ibapb.users_id AS usersid,ibapb.status,ibapb.property_name
FROM industrial_broker_agent_properties_branch ibapb
JOIN property_types pt ON ibapb.property_types_id = pt.id
LEFT JOIN industrial_properties_facts pf ON pf.properties_id = ibapb.id
WHERE ibapb.users_id=$1 AND ibapb.status!=6
UNION
-- industrial_owner_properties
SELECT iop.id,iop.category,pf.is_branch,iop.users_id AS usersid,iop.status,iop.property_name
FROM industrial_owner_properties iop
JOIN property_types pt ON iop.property_types_id = pt.id
LEFT JOIN industrial_properties_facts pf ON pf.properties_id = iop.id
WHERE iop.users_id=$1 AND iop.status!=6
 
)Select count(*) from x
join property_reviews pr on pr.property_unit_id=x.id and pr.property_unit_category=x.category and pr.is_branch=x.is_branch
join users u on pr.reviewer=u.id;