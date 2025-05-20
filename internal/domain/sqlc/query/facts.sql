-- name: GetAllFactsDetails :many 
SELECT * FROM facts;

 
-- name: CheckIfPropertyTypeExists :one
SELECT 
    EXISTS (
        SELECT 1
        FROM global_property_type
        WHERE 
            (
             property_type_facts->'project' @> jsonb_build_array(jsonb_build_object('id', $1::bigint)) OR
             property_type_facts->'rent' @> jsonb_build_array(jsonb_build_object('id', $1::bigint)) OR
             property_type_facts->'sale' @> jsonb_build_array(jsonb_build_object('id', $1::bigint))
            )
        LIMIT 1
    ) AS is_present;


-- name: CheckIfUnitTypeExists :one
SELECT 
    EXISTS (
        SELECT 1
        FROM unit_type
        WHERE 
            (
             facts->'rent' @> jsonb_build_array(jsonb_build_object('id', $1::bigint)) OR
             facts->'sale' @> jsonb_build_array(jsonb_build_object('id', $1::bigint))
            )
        LIMIT 1
    ) AS is_present;
 

-- name: GetAllFacts :many 
SELECT 
    facts.*,
    COUNT(*) OVER() AS total_count 
FROM facts
ORDER BY id DESC  -- Change 'id' to your preferred column
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: CreateFacts :one
INSERT INTO facts (
    title,
    icon_url,
    title_ar
)VALUES (
    $1 ,$2, $3
) RETURNING *;

-- name: GetFacts :one
SELECT * FROM facts 
WHERE id = $1 LIMIT 1;

-- name: UpdateFacts :one
UPDATE facts
SET 
    title = $2,
    icon_url = $3,
    title_ar = $4
WHERE id = $1
RETURNING *;

-- name: DeleteFactByID :exec
DELETE FROM facts
WHERE id = $1;
