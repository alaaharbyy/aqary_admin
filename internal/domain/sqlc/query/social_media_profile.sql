-- name: CreateSocialMediaProfile :one
INSERT INTO social_media_profile(
    social_media_name,
    social_media_url,
    entity_type_id,
    entity_id
)VALUES(
    $1, $2, $3, $4
)RETURNING *;


-- name: UpdateSocialMediaProfile :one
Update social_media_profile
SET  social_media_url = $4
WHERE entity_type_id = $3 AND entity_id = $1 AND LOWER(social_media_profile.social_media_name) = LOWER($2)
RETURNING *;

-- name: CreateSocialMediaProfileBulk :exec
INSERT INTO social_media_profile(
    social_media_name,
    social_media_url,
    entity_type_id,
    entity_id
)VALUES(
   unnest(@social_media_name::text[]),
   unnest(@social_media_url::text[]),
   @entity_type_id,
   @entity_id
);

-- name: GetSocialMediaProfilesByEntityAndEntityTypeId :many
SELECT * FROM social_media_profile
WHERE entity_type_id = $2 AND entity_id = $1;

-- name: DeleteSocialMediaProfilesByEntityAndEntityTypeId :exec
DELETE FROM social_media_profile
WHERE id = ANY(@ids::bigint[]);