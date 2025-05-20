-- name: CreateCommunityGuideSubinsight :one
INSERT INTO community_guidelines_subinsight (
    insight_id,
    subinsight_name,
    subinsight_name_ar,
    icon,
    description_text,
    status,
    created_at,
    update_at

) VALUES (
  $1, $2, $3, $4, $5, $6, $7, $8
)
RETURNING *;


-- name: GetCommunityGuideSubinsights :many
SELECT 
 sqlc.embed(community_guidelines_subinsight)
FROM community_guidelines_subinsight 
JOIN community_guidelines_insight ON community_guidelines_insight.id=community_guidelines_subinsight.insight_id
WHERE community_guidelines_insight.id= any(@insight_ids::bigint[])  and community_guidelines_insight.status not in (5,6) 
and community_guidelines_subinsight.status not in (5,6)
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');


-- name: GetCommunityGuideSubinsightsCount :one
SELECT 
 count(community_guidelines_subinsight)
FROM community_guidelines_subinsight 
JOIN community_guidelines_insight ON community_guidelines_insight.id=community_guidelines_subinsight.insight_id
WHERE community_guidelines_insight.id= any(@insight_ids::bigint[])   and community_guidelines_insight.status not in (5,6) 
and community_guidelines_subinsight.status not in (5,6);

-- name: GetDeletedCommunityGuideSubinsights :many
SELECT 
 sqlc.embed(community_guidelines_subinsight)
FROM community_guidelines_subinsight  
JOIN community_guidelines_insight ON community_guidelines_insight.id=community_guidelines_subinsight.insight_id
WHERE community_guidelines_insight.id= any(@insight_ids::bigint[]) 
AND community_guidelines_subinsight.status=6
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetDeletedCommunityGuideSubinsightsCount :one
SELECT 
 count(community_guidelines_subinsight) 
FROM community_guidelines_subinsight  
JOIN community_guidelines_insight ON community_guidelines_insight.id=community_guidelines_subinsight.insight_id
WHERE community_guidelines_insight.id= any(@insight_ids::bigint[]) 
AND community_guidelines_subinsight.status=6;




-- name: GetCommunityGuideSubinsight :one
SELECT 
 sqlc.embed(community_guidelines_subinsight)
FROM community_guidelines_subinsight
WHERE id=$1;

-- name: UpdateCommunityGuideSubinsight :one
UPDATE community_guidelines_subinsight
SET 
  subinsight_name=$1,
  subinsight_name_ar=$2,
  icon=$3,
  description_text=$4,
  update_at=$5
WHERE id=$6
RETURNING *;

-- name: UpdateCommunityGuideSubinsightStatus :one
UPDATE community_guidelines_subinsight
SET 
    status=$1,
    update_at=$2,
    deleted_at=$3
WHERE id=$4
RETURNING *;