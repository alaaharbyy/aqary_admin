
-- name: GetUnits :one
SELECT * FROM units
WHERE id = $1 LIMIT 1;

-- name: GetUnitDetailsForQualityScore :one
SELECT unit_versions.title, unit_versions.description, unit_versions.unit_id, unit_versions.type, units.addresses_id FROM unit_versions
INNER JOIN units ON units.id = unit_versions.unit_id WHERE units.id = @unit_id AND unit_versions.type = @type;

-- name: MakeUnitVersionVerified :exec
UPDATE
    unit_versions
SET
    is_verified = true, 
    updated_at=$1, 
    updated_by=$2 
WHERE
    id = @unit_version_id :: BIGINT AND status!=6;


-- name: DisableExpiredExclusiveUnitVersions :exec
UPDATE unit_versions
SET "exclusive" = FALSE
WHERE "exclusive" IS TRUE AND end_date < now();


-- name: CheckIfUnitExistByRefNo :one
SELECT EXISTS(
SELECT 1 FROM units
INNER JOIN unit_versions ON unit_versions.unit_id = units.id AND unit_versions.is_main IS TRUE
WHERE unit_versions.ref_no = $1
)::boolean AS is_unit_exist;

-- name: GetUnitTypeByTypeAndUsage :one
SELECT * FROM unit_type 
WHERE LOWER(TRIM("type")) = LOWER(TRIM(@unit_type::text)) AND usage = @usage::bigint;

-- name: GetUnitByRefNo :one
SELECT * FROM units
INNER JOIN unit_versions ON unit_versions.unit_id = units.id AND unit_versions.is_main IS TRUE
WHERE unit_versions.ref_no = $1;

-- name: GetXMLUnitIDsToDeleteByEntity :one
SELECT 
array_agg(units.id)::bigint[] AS unit_ids,
array_agg(unit_versions.id)::bigint[] AS unit_version_ids
FROM units
INNER JOIN unit_versions ON unit_versions.unit_id = units.id
WHERE from_xml IS TRUE
AND units.entity_id = ANY(@entity_ids::bigint[])
AND units.entity_type_id = @entity_type_id::bigint;

-- name: DeleteXMLUnitVersions :exec
DELETE FROM unit_versions
USING units
WHERE units.id = unit_versions.unit_id
  AND units.from_xml IS TRUE
  AND unit_versions.id = ANY(@ids_to_delete::bigint[]);

-- name: DeleteXMLUnits :exec
DELETE FROM units
WHERE id = ANY(@ids_to_delete::bigint[]) AND from_xml IS TRUE;

-- name: GetXMLUnitIDsToDeleteByRefNoAndEntity :one
SELECT 
array_agg(units.id)::bigint[] AS unit_ids,
array_agg(unit_versions.id)::bigint[] AS unit_version_ids
FROM units
INNER JOIN unit_versions ON unit_versions.unit_id = units.id
WHERE from_xml IS TRUE 
AND unit_versions.ref_no != ALL(@ignore_ref_nos::varchar[])
AND units.entity_id = @entity_id::bigint
AND units.entity_type_id = @entity_type_id::bigint;

-- name: GetActiveUnitTypeByTypeAndUsage :one
SELECT * FROM unit_type 
WHERE LOWER(TRIM("type")) = LOWER(TRIM(@unit_type::text)) AND usage = @usage::bigint AND status = 2;