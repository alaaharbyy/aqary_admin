-- name: CreatePropertyType :one
INSERT INTO property_types (
    type,
    code,
    is_residential,
    is_commercial,
    created_at,
    updated_at,
    property_type_facts_id,
    category,
    status,
    unit_types,
    icon
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11
) RETURNING *;

-- name: GetPropertyType :one
SELECT * FROM property_types 
WHERE id = $1 LIMIT $1;


-- name: GetPropertyTypeByCategory :many
SELECT * FROM property_types 
WHERE category = $1;


-- name: GetAllPropertyTypeByType :one
SELECT * FROM property_types
Where type = $1
LIMIT $2
OFFSET $3;


-- name: GetAllPropertyTypeByCode :one
SELECT * FROM property_types
Where code = $1
LIMIT $2
OFFSET $3;


-- name: GetAllPropertyByResidential :many
SELECT * FROM property_types
Where is_residential = true
LIMIT $1
OFFSET $2;


-- name: GetAllPropertyTypeByCommercial :many
SELECT * FROM property_types
Where is_commercial = true
LIMIT $1
OFFSET $2;

-- name: GetAllPropertyType :many
SELECT * FROM property_types
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdatePropertyType :one
UPDATE property_types
SET  type = $2,
    code = $3,
    is_residential = $4,
    is_commercial = $5,
    created_at = $6,
    updated_at = $7,
    property_type_facts_id = $8,
    category = $9,
    status  = $10,
    unit_types  = $11,
    icon  = $12
Where id = $1
RETURNING *;


-- name: DeletePropertyType :exec
DELETE FROM property_types
Where id = $1;


-- name: GetAllPropertyTypesByids :many
SELECT  * FROM property_types
WHERE id = ANY($1::bigint[]);
 


-- name: GetAllPropertyTypesByPropertyId :many
SELECT * FROM property_types
WHERE id = ANY(SELECT unnest(project_properties.property_types_id) FROM project_properties WHERE project_properties.id=$1);

 
-- name: GetPropertyTypesIdCatCode :many
SELECT property_types.id,LOWER(code) AS code,LOWER(category) AS category FROM property_types WHERE LOWER(category) = 'sale' OR LOWER(category) = 'rent' OR LOWER(category) = 'property hub' ORDER BY category;


-- -- name: GetAllUnitTypesByPropertyType :many
-- SELECT property_types.*
-- FROM property_types
-- WHERE property_types.id = ANY (SELECT unnest(unit_types) FROM property_types WHERE property_types.id = $1);



-- name: GetAllUnitTypesByProjectPropertyAndCategory :many
WITH x AS(
    SELECT property_types.* FROM property_types
 LEFT JOIN project_properties ON property_types.id=ANY(project_properties.property_types_id)WHERE project_properties.id=$1)
 SELECT * FROM property_types WHERE property_types.type IN (SELECT x.type FROM x)AND property_types.category=LOWER($2) ORDER BY id;


-- name: GetAllUnitTypesByProjectPropertyAndProjectCategory :many
WITH x AS(
    SELECT property_types.* FROM property_types
 LEFT JOIN project_properties ON property_types.id=ANY(project_properties.property_types_id)WHERE project_properties.id=$1)
 SELECT * FROM property_types WHERE property_types.type IN (SELECT x.type FROM x)AND property_types.category ILIKE 'Project%' ORDER BY id;

--  SELECT property_types.id,property_types."type", COUNT(*) AS count
--  FROM property_types
--  JOIN unnest($1::bigint[]) AS ids(id) ON property_types.id = ids.id
--  GROUP BY property_types."type";

-- name: GetAllPropertypesByPropertyTypesIds :many
SELECT global_property_type.id, global_property_type."type",global_property_type.icon, COUNT(*) AS count
FROM global_property_type
JOIN unnest($1::bigint[]) AS ids(id) ON global_property_type.id = ids.id
GROUP BY global_property_type.id, global_property_type."type";



-- name: GetAllUniqueProperyTypes :many
SELECT DISTINCT on (type) id, type, code, is_commercial, icon FROM property_types
where property_types.category = $1;
