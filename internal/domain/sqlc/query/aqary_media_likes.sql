-- name: CreateAqaryMediaRections :one
INSERT INTO aqary_media_likes(
    property_unit_id,
    which_property_unit,
    which_propertyhub_key,
    is_branch,
    is_liked,
    like_reaction_id,
    users_id
) VALUES (
    $1, $2, $3, $4, $5, $6, $7
) RETURNING *;