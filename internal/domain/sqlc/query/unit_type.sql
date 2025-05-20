-- name: AddUnitType :exec
INSERT INTO unit_type (
 type,
 type_ar,
 code,
 facts,
 usage,
 created_at,
 updated_at,
 status,
 icon,
  listing_facts
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10
);


-- name: UpdateUnitTypeSettings :exec
UPDATE unit_type
SET 
    type = $1, 
    code =  $2,
    facts = $3,
    usage = $4,
    updated_at = $5,
    icon = $6,
    type_ar=$7,
    listing_facts=$8
WHERE 
    id = @unit_type_id::BIGINT AND status!=6;



-- name: GetUnitTypeSettings :one 
SELECT * FROM unit_type WHERE id=$1 AND status!=6; 


-- name: GetUnitsTypeSittings :many
SELECT
    id,
    type,
    type_ar,
    code,
    usage,
    icon,
    status, 
    updated_at
FROM
    unit_type
WHERE   CASE
        WHEN @status::BIGINT = 6 THEN status = 6
        ELSE status != 6
    END
ORDER BY updated_at DESC
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetUnitsTypeSettingsCount :one
SELECT
    COUNT(id)
FROM
    unit_type
WHERE CASE
        WHEN @status::BIGINT = 6 THEN status = 6
        ELSE status != 6
    END;

-- name: ChangeStatusForUnitType :exec
UPDATE unit_type
SET
    status= $2, 
    updated_at=$3
WHERE id=$1;




  
-- name: UnitTypeExistsInTables :one
SELECT 
    CAST(
        (
            (SELECT COUNT(*) FROM property WHERE @unit_type_id::BIGINT[] && property.unit_type_id) + 
            (SELECT COUNT(*) FROM property_type_unit_type WHERE property_type_unit_type.unit_type_id = ANY(@unit_type_id::BIGINT[])) + 
            (SELECT COUNT(*) FROM units WHERE units.unit_type_id = ANY(@unit_type_id::BIGINT[]))
        ) AS BIGINT
    ) AS total_count;





-- name: CheckUnitTypeIfExists :many
SELECT id from unit_type 
WHERE status != 6 AND id = ANY(@unit_type_ids::bigint[]);

-- name: GetAllActiveUnitTypes :many
SELECT * FROM unit_type WHERE status = 2;