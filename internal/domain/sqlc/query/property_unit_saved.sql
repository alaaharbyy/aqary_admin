-- name: CreatePropertyUnitSaved :one
INSERT INTO property_unit_saved (
    property_unit_id,
    which_property_unit,
    which_propertyhub_key,
    is_branch,
    is_saved,
    collection_name_id,
    users_id,
    created_at,
    updated_at
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7, $8, $9
) RETURNING *;

-- name: GetPropertyUnitSaved :one
SELECT * FROM property_unit_saved 
WHERE id = $1 LIMIT 1;

-- name: GetPropertyUnitSavedByPropertyIdAndIdAndWhichProperty :one
SELECT * FROM property_unit_saved 
WHERE property_unit_id = $1 And which_property_unit = $2 AND is_branch = $3 AND users_id = $4;


-- name: GetAllPropertyUnitSavedByPropertyIdAndIdAndWhichProperty :many
SELECT id FROM property_unit_saved 
WHERE property_unit_id = $1 And which_property_unit = $2 AND is_branch = $3 AND users_id = $4 AND is_saved=TRUE;


-- name: GetPropertyUnitSavedByPropertyIdAndIdAndWhichPropertyAndCollectionId :one
SELECT * FROM property_unit_saved 
WHERE  property_unit_id = $1 And which_property_unit = $2 AND
is_branch = $3 AND users_id = $4 AND collection_name_id = $5  LIMIT 1;


-- name: GetAllPropertyUnitSaved :many
SELECT * FROM property_unit_saved
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdatePropertyUnitSaved :one
UPDATE property_unit_saved
SET property_unit_id = $2,
    which_property_unit = $3,
    which_propertyhub_key = $4,
    is_branch = $5,
    is_saved = $6,
    collection_name_id = $7,
    users_id = $8,
    created_at = $9,
    updated_at = $10
Where id = $1
RETURNING *;


-- name: DeletePropertyUnitSaved :exec
DELETE FROM property_unit_saved
Where id = $1;

 

