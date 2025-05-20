-- name: CreatePropertyUnitLike :one
INSERT INTO property_unit_likes (
    property_unit_id,
    which_property_unit,
    which_propertyhub_key,
    is_branch,
    is_liked,
    like_reaction_id,
    users_id,
    created_at,
    updated_at
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7, $8, $9
) RETURNING *;

-- name: GetPropertyUnitLike :one
SELECT * FROM property_unit_likes 
WHERE id = $1 LIMIT 1;

-- name: GetPropertyUnitLikeByPropertyIdAndIdAndWhichProperty :one
SELECT * FROM property_unit_likes 
WHERE  property_unit_id = $1 And which_property_unit = $2 AND is_branch = $3 AND users_id = $4  LIMIT 1;

-- name: GetAllPropertyUnitLike :many
SELECT * FROM property_unit_likes
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdatePropertyUnitLike :one
UPDATE property_unit_likes
SET  
    property_unit_id = $2,
    which_property_unit = $3,
    which_propertyhub_key =  $4,
    is_branch = $5,
    is_liked=$6,
    like_reaction_id = $7,
    users_id = $8,
    updated_at = $9
Where id = $1
RETURNING *;


-- name: DeletePropertyUnitLike :exec
DELETE FROM property_unit_likes
Where id = $1;

 

 
