-- name: CreateLeadProperties :one
INSERT INTO leads_properties (
    leads_id,
    properies_type_id,
    property_id,
    unit_category,
    unit_id,
    is_branch,
    date_added,
    is_property
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- name: GetAllLeadPropertiesByLeadId :many
SELECT *
FROM leads_properties
WHERE leads_id = $1
ORDER BY id
OFFSET $2
LIMIT $3;

-- name: UpdateSingleLeadPropertiesLeadID :one
UPDATE leads_properties SET leads_id = $1 WHERE id = $2 RETURNING *;
 
-- name: UpdateMultipleLeadPropertiesLeadID :one
UPDATE leads_properties SET leads_id = $1 WHERE id = ANY($2::bigint[]) RETURNING *;

-- name: UpdateLeadProperties :one
UPDATE
    leads_properties
SET
    properies_type_id = $1,
    property_id = $2,
    unit_category = $3,
    unit_id = $4,
    is_branch = $5,
    date_added = $6,
    is_property = $7
WHERE
    id = $8 RETURNING *;

-- name: GetCountAllLeadsPropertiesByLeadId :one
SELECT COUNT(*) FROM leads_properties WHERE leads_id = $1;



-- name: DeleteLeadPropertyByLeadId :exec
DELETE FROM leads_properties where id = $1;

-- name: GetSingleLeadProperty :one
select * from leads_properties where id = $1;




-- name: GetPropertyTypesByCategoryForLeads :many
SELECT 
pt.id, 
pt.type as label, 
CASE 
    WHEN ARRAY[1]::bigint[] <@ ARRAY_AGG(lt.fact_id) THEN TRUE 
    ELSE FALSE 
END AS bed,
CASE 
    WHEN ARRAY[2]::bigint[] <@ ARRAY_AGG(lt.fact_id) THEN TRUE 
    ELSE FALSE 
END AS bath
FROM 
property_types pt
LEFT JOIN LATERAL (
    SELECT *
    FROM UNNEST(pt.property_type_facts_id) AS lt(fact_id)
    LIMIT 2
) lt ON TRUE
WHERE 
pt.category % $1
GROUP BY 
pt.id, 
pt.type
ORDER BY 
pt.id;

-- name: GetPropertyTypesByIdListForLeads :many
SELECT 
pt.id, 
pt.type as label, 
CASE 
    WHEN ARRAY[1]::bigint[] <@ ARRAY_AGG(lt.fact_id) THEN TRUE 
    ELSE FALSE 
END AS bed,
CASE 
    WHEN ARRAY[2]::bigint[] <@ ARRAY_AGG(lt.fact_id) THEN TRUE 
    ELSE FALSE 
END AS bath
FROM 
property_types pt
LEFT JOIN LATERAL (
    SELECT *
    FROM UNNEST(pt.property_type_facts_id) AS lt(fact_id)
    LIMIT 2
) lt ON TRUE
WHERE 
pt.id = ANY($1::bigint[])
GROUP BY 
pt.id, 
pt.type
ORDER BY 
pt.id;

-- name: CheckLeadProperty :one
select * from leads_properties where properies_type_id = $1 and property_id = $2 and unit_category = $3 and is_branch = $4 and is_property = $5 and leads_id = $6 limit 1;