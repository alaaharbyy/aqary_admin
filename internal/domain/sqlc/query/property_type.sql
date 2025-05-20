-- name: AddPropertyType :exec
INSERT INTO global_property_type (
 type,
 code,
 property_type_facts,
 listing_facts,
 usage,
 created_at,
 updated_at,
 status,
 icon, 
 is_project,
 type_ar
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8,$9,$10, $11
);





-- name: UpdatePropertyTypeSettings :exec
UPDATE global_property_type
SET 
    type = $1, 
    code =  $2,
    property_type_facts = $3,
    usage = $4,
    updated_at = $5,
    icon = $6, 
    is_project=$7,
    type_ar = $8,
    listing_facts = $9
WHERE 
    id = @property_type_id::BIGINT AND status!=6;



-- name: GetPropertyTypeSettings :one 
SELECT * FROM global_property_type WHERE id=$1 AND status!=6; 





-- name: GetPropertiesTypeSittings :many
SELECT
    id,
    type,
    code,
    usage,
    icon,
    status, 
    updated_at, 
    is_project,
    type_ar
FROM
    global_property_type
WHERE status= @status::BIGINT
ORDER BY updated_at DESC
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetPropertiesTypeSettingsCount :one
SELECT
   COUNT(id)
FROM
    global_property_type
WHERE status= @status::BIGINT;

-- name: ChangeStatusForPropertyType :exec
UPDATE global_property_type
SET
    status= $2, 
    updated_at=$3
WHERE id=$1;


-- name: PropertyTypeExistsInTables :one
SELECT 
    CAST(
        (
            (SELECT COUNT(*) FROM property WHERE property.property_type_id = @property_type_id::BIGINT) + 
            (SELECT COUNT(*) FROM property_type_unit_type WHERE property_type_unit_type.property_type_id = @property_type_id::BIGINT) 
        ) AS BIGINT
    ) AS total_count;

-- name: GetAllActivePropertyTypes :many
SELECT * FROM global_property_type WHERE status = 2;