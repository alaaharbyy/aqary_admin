-- name: CreateSubCommunityGuideline :one
INSERT INTO sub_community_guidelines (
  country_id, state_id, city_id, community_id,
  sub_community_id, description, cover_image,
  insights, sub_insights, status, about,
  created_at, update_at, deleted_at
) VALUES (
  $1, $2, $3, $4,
  $5, $6, $7,
  $8, $9, $10, $11,
  $12, $13, $14
)
RETURNING *;

-- name: GetSubCommunityGuidelineBySubID :one
SELECT * FROM sub_community_guidelines
WHERE sub_community_id = $1 LIMIT 1;

-- name: ListSubCommunityGuidelines :many
SELECT * FROM sub_community_guidelines
ORDER BY id
LIMIT $1 OFFSET $2;

-- name: GetSubCommunityGuidesLines :many
SELECT 
  DISTINCT ON (sub_community_guidelines.id)
  sub_community_guidelines.id, sub_community_guidelines.country_id, sub_community_guidelines.state_id, sub_community_guidelines.city_id, sub_community_guidelines.community_id,sub_community_guidelines.sub_community_id, sub_community_guidelines.cover_image, sub_community_guidelines.insights, sub_community_guidelines.sub_insights, sub_community_guidelines.status, sub_community_guidelines.about, sub_community_guidelines.created_at, sub_community_guidelines.update_at, sub_community_guidelines.deleted_at,
  sub_communities.sub_community,
  communities.community,
  cities.city,
  states.state,
  countries.country,
  COALESCE((
    SELECT jsonb_agg(jsonb_build_object('id', i.id, 'label', i.insight_name))
    FROM community_guidelines_insight i
    WHERE i.id = ANY(sub_community_guidelines.insights)
      AND i.status NOT IN (5, 6)
  ), '[]'::jsonb)::jsonb AS community_guidelines_insight,

  COALESCE((
    SELECT jsonb_agg(jsonb_build_object('id', s.id, 'label', s.subinsight_name))
    FROM community_guidelines_subinsight s
    WHERE s.id = ANY(sub_community_guidelines.sub_insights)
      AND s.status NOT IN (5, 6)
  ), '[]'::jsonb)::jsonb AS community_guidelines_subinsight

FROM sub_community_guidelines 
JOIN sub_communities ON sub_community_guidelines.sub_community_id = sub_communities.id
JOIN communities ON sub_community_guidelines.community_id = communities.id
JOIN cities ON cities.id = sub_community_guidelines.city_id
JOIN states ON states.id = sub_community_guidelines.state_id
JOIN countries ON countries.id = sub_community_guidelines.country_id
WHERE sub_community_guidelines.status NOT IN (5, 6)
--   AND communities.status NOT IN (5, 6)
ORDER BY sub_community_guidelines.id desc
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetSubCommunityGuideLines :one
SELECT 
  DISTINCT ON (sub_community_guidelines.id)
  sqlc.embed(sub_community_guidelines),
  sub_communities.sub_community,
  communities.community,
  cities.city,
  states.state,
  countries.country,
  (
    SELECT jsonb_agg(jsonb_build_object('id', i.id, 'label', i.insight_name))
    FROM community_guidelines_insight i
    WHERE i.id = ANY(sub_community_guidelines.insights)
  ) AS community_guidelines_insight,
  (
    SELECT jsonb_agg(jsonb_build_object('id', s.id, 'label', s.subinsight_name))
    FROM community_guidelines_subinsight s
    WHERE s.id = ANY(sub_community_guidelines.sub_insights)
  ) AS community_guidelines_subinsight

FROM sub_community_guidelines 
JOIN sub_communities ON sub_community_guidelines.sub_community_id = sub_communities.id
JOIN communities ON sub_community_guidelines.community_id = communities.id
JOIN cities ON cities.id = sub_community_guidelines.city_id
JOIN states ON states.id = sub_community_guidelines.state_id
JOIN countries ON countries.id = sub_community_guidelines.country_id
WHERE sub_community_guidelines.id = $1
ORDER BY sub_community_guidelines.id
LIMIT 1;

-- name: GetSubCommunityGuidesLinesCount :one
SELECT 
  COUNT(DISTINCT sub_community_guidelines.id)
FROM sub_community_guidelines 
JOIN sub_communities ON sub_community_guidelines.sub_community_id = sub_communities.id
JOIN communities ON sub_community_guidelines.community_id = communities.id
JOIN cities ON cities.id = sub_community_guidelines.city_id
JOIN states ON states.id = sub_community_guidelines.state_id
JOIN countries ON countries.id = sub_community_guidelines.country_id
WHERE sub_community_guidelines.status NOT IN (5, 6)
  AND sub_communities.status NOT IN (5, 6);

-- name: UpdateSubCommunityGuideline :one
UPDATE sub_community_guidelines
SET 
  country_id = $2,
  state_id = $3,
  city_id = $4,
  community_id = $5,
  sub_community_id = $6,
  description = $7,
  cover_image = $8,
  insights = $9,
  sub_insights = $10,
  status = $11,
  about = $12,
  created_at = $13,
  update_at = $14,
  deleted_at = $15
WHERE id = $1
RETURNING *;

-- name: UpdateSubCommunityGuidelinesStatus :one
UPDATE sub_community_guidelines
SET 
    status=$1,
    update_at=$2,
    deleted_at=$3
WHERE id=$4
RETURNING *;


-- name: DeleteSubCommunityGuideline :exec
DELETE FROM sub_community_guidelines
WHERE id = $1;

-- name: GetDeletedSubCommunityGuidesLines :many
SELECT 
  DISTINCT ON (sub_community_guidelines.id)
  sqlc.embed(sub_community_guidelines),
  sub_communities.sub_community,
  communities.community,
  cities.city,
  states.state,
  countries.country
  -- media.media
FROM sub_community_guidelines 
JOIN sub_communities ON sub_community_guidelines.sub_community_id = sub_communities.id
JOIN communities ON sub_community_guidelines.community_id = communities.id
JOIN cities ON cities.id = sub_community_guidelines.city_id
JOIN states ON states.id = sub_community_guidelines.state_id
JOIN countries ON countries.id = sub_community_guidelines.country_id
-- LEFT JOIN media ON media.community_guidelines_id = community_guidelines.id
WHERE sub_community_guidelines.status=6
ORDER BY sub_community_guidelines.id,deleted_at DESC
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');


-- name: GetDeletedSubCommunityGuidesLinesCount :one
SELECT 
 count(sub_community_guidelines) 
FROM sub_community_guidelines 
JOIN sub_communities ON sub_community_guidelines.sub_community_id = sub_communities.id
WHERE sub_community_guidelines.status=6;