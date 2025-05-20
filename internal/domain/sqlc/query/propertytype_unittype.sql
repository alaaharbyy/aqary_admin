-- name: CreatePropertyTypeUnitType :many
INSERT INTO property_type_unit_type (unit_type_id, property_type_id)
SELECT unnest(@unit_type_ids::bigint[]), @property_type_id::bigint 
RETURNING *;

-- name: GetAllPropertyTypeUnitType :many
SELECT 
	property_type_id,global_property_type."type" AS property_type,  (global_property_type.is_project)::BOOLEAN AS is_project,  -- Explicit boolean cast
	JSON_AGG(JSON_BUILD_OBJECT('id', unit_type_id, 'label', unit_type."type", 'label_ar', unit_type.type_ar)) AS unit_types,
	COUNT(*) OVER() AS total_count
FROM property_type_unit_type
INNER JOIN global_property_type ON global_property_type.id = property_type_id
INNER JOIN unit_type ON unit_type.id = unit_type_id
GROUP BY property_type_unit_type.property_type_id,global_property_type.id
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetAllUnitTypesByPropertyType :many
SELECT property_type_unit_type.id,property_type_unit_type.property_type_id,global_property_type."type" AS property_type,
property_type_unit_type.unit_type_id,unit_type."type" AS unit_type
FROM property_type_unit_type
INNER JOIN global_property_type ON global_property_type.id = property_type_id
INNER JOIN unit_type ON unit_type.id = unit_type_id
WHERE property_type_id = $1;

-- name: DeleteUnitTypesByPropertyTypeUnitTypeId :exec
DELETE FROM property_type_unit_type
WHERE id = ANY(@ids::bigint[]);

-- name: DeleteUnitTypesByPropertyTypeId :exec
DELETE FROM property_type_unit_type 
WHERE property_type_id = $1;