-- name: CreateCommunityGuidelines :one
INSERT INTO community_guidelines (
  -- title,
  country_id,
  state_id,
  city_id,
  community_id,
  description,
  cover_image,
  insights,
  sub_insights,
  created_at,
  update_at,
  status,
  about
  
) VALUES (
  $1, $2, $3, $4, $5, $6, $7, $8, $9,$10, $11,$12
)
RETURNING *;


-- -- name: GetCommunityGuidesLines :many
-- SELECT 
--   sqlc.embed(community_guidelines),
--   communities.community,

--   (
--     SELECT jsonb_agg(jsonb_build_object('id', i.id, 'label', i.insight_name))
--     FROM community_guidelines_insight i
--     WHERE i.id = ANY(community_guidelines.insights)
--       AND i.status NOT IN (5, 6)
--   ) AS community_guidelines_insight,

--   (
--     SELECT jsonb_agg(jsonb_build_object('id', s.id, 'label', s.subinsight_name))
--     FROM community_guidelines_subinsight s
--     WHERE s.id = ANY(community_guidelines.sub_insights)
--       AND s.status NOT IN (5, 6)
--   ) AS community_guidelines_subinsight

-- FROM community_guidelines 
-- JOIN communities ON community_guidelines.community_id = communities.id
-- WHERE community_guidelines.status NOT IN (5, 6)
--   AND communities.status NOT IN (5, 6)
-- ORDER BY community_guidelines.update_at DESC
-- LIMIT sqlc.narg('limit')
-- OFFSET sqlc.narg('offset');


-- -- name: GetCommunityGuidesLinesCount :one
-- SELECT 
--   COUNT(DISTINCT community_guidelines.id)
-- FROM community_guidelines 
-- JOIN communities ON community_guidelines.community_id = communities.id
-- WHERE community_guidelines.status NOT IN (5, 6)
--   AND communities.status NOT IN (5, 6)
--   AND EXISTS (
--     SELECT 1
--     FROM community_guidelines_insight i
--     WHERE i.id = ANY(community_guidelines.insights)
--       AND i.status NOT IN (5, 6)
--   )
--   AND EXISTS (
--     SELECT 1
--     FROM community_guidelines_subinsight s
--     WHERE s.id = ANY(community_guidelines.sub_insights)
--       AND s.status NOT IN (5, 6));


-- name: GetCommunityGuidesLines :many
SELECT 
  DISTINCT ON (community_guidelines.id)
  community_guidelines.id, community_guidelines.country_id, community_guidelines.state_id, community_guidelines.city_id, community_guidelines.community_id, community_guidelines.cover_image, community_guidelines.insights, community_guidelines.sub_insights, community_guidelines.status, community_guidelines.about, community_guidelines.created_at, community_guidelines.update_at, community_guidelines.deleted_at,
  communities.community,
  cities.city,
  states.state,
  countries.country,

  COALESCE((
    SELECT jsonb_agg(jsonb_build_object('id', i.id, 'label', i.insight_name))
    FROM community_guidelines_insight i
    WHERE i.id = ANY(community_guidelines.insights)
      AND i.status NOT IN (5, 6)
  ), '[]'::jsonb)::jsonb AS community_guidelines_insight,

  COALESCE((
    SELECT jsonb_agg(jsonb_build_object('id', s.id, 'label', s.subinsight_name))
    FROM community_guidelines_subinsight s
    WHERE s.id = ANY(community_guidelines.sub_insights)
      AND s.status NOT IN (5, 6)
  ), '[]'::jsonb)::jsonb AS community_guidelines_subinsight

FROM community_guidelines 
JOIN communities ON community_guidelines.community_id = communities.id
JOIN cities ON cities.id = community_guidelines.city_id
JOIN states ON states.id = community_guidelines.state_id
JOIN countries ON countries.id = community_guidelines.country_id
WHERE community_guidelines.status NOT IN (5, 6)
  AND communities.status NOT IN (5, 6)
ORDER BY community_guidelines.id desc
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetCommunityGuidesLinesCount :one
SELECT 
  COUNT(DISTINCT community_guidelines.id)
FROM community_guidelines 
JOIN communities ON community_guidelines.community_id = communities.id
JOIN cities ON cities.id = community_guidelines.city_id
JOIN states ON states.id = community_guidelines.state_id
JOIN countries ON countries.id = community_guidelines.country_id
WHERE community_guidelines.status NOT IN (5, 6)
  AND communities.status NOT IN (5, 6);


-- name: GetDeletedCommunityGuidesLines :many
-- with media as (
-- 	SELECT 
-- 		global_media.entity_id as community_guidelines_id,
-- 	jsonb_agg(jsonb_build_object('media_type', global_media.media_type, 'files', global_media.file_urls)) as media
	
-- 	FROM global_media 
-- 	WHERE  global_media.entity_type_id= 21 AND global_media.gallery_type='Main'
-- 	GROUP by global_media.entity_id

-- )
SELECT 
  DISTINCT ON (community_guidelines.id)
  sqlc.embed(community_guidelines),
  communities.community,
  cities.city,
  states.state,
  countries.country
  -- media.media
FROM community_guidelines 
JOIN communities ON community_guidelines.community_id = communities.id
JOIN cities ON cities.id = community_guidelines.city_id
JOIN states ON states.id = community_guidelines.state_id
JOIN countries ON countries.id = community_guidelines.country_id
-- LEFT JOIN media ON media.community_guidelines_id = community_guidelines.id
WHERE community_guidelines.status=6
ORDER BY community_guidelines.id,deleted_at DESC
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetDeletedCommunityGuidesLinesCount :one
SELECT 
 count(community_guidelines) 
FROM community_guidelines 
JOIN communities ON community_guidelines.community_id = communities.id
WHERE community_guidelines.status=6;



-- name: GetCommunityGuideLines :one
SELECT 
  DISTINCT ON (community_guidelines.id)
  sqlc.embed(community_guidelines),
  communities.community,
  cities.city,
  states.state,
  countries.country,
  (
    SELECT jsonb_agg(jsonb_build_object('id', i.id, 'label', i.insight_name))
    FROM community_guidelines_insight i
    WHERE i.id = ANY(community_guidelines.insights)
  ) AS community_guidelines_insight,
  (
    SELECT jsonb_agg(jsonb_build_object('id', s.id, 'label', s.subinsight_name))
    FROM community_guidelines_subinsight s
    WHERE s.id = ANY(community_guidelines.sub_insights)
  ) AS community_guidelines_subinsight

FROM community_guidelines 
JOIN communities ON community_guidelines.community_id = communities.id
JOIN cities ON cities.id = community_guidelines.city_id
JOIN states ON states.id = community_guidelines.state_id
JOIN countries ON countries.id = community_guidelines.country_id
WHERE community_guidelines.id = $1
ORDER BY community_guidelines.id
LIMIT 1;

-- name: UpdateCommunityGuidelines :one
UPDATE community_guidelines
SET 
  description=$2,
  cover_image=$3,
  insights=$4,
  sub_insights=$5,
  update_at=$6,
  about=$7,
  community_id=$8
WHERE id=$1
RETURNING *;

-- name: UpdateCommunityGuidelinesStatus :one
UPDATE community_guidelines
SET 
    status=$1,
    update_at=$2,
    deleted_at=$3
WHERE id=$4
RETURNING *;