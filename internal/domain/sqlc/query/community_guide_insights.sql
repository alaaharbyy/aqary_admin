-- name: CreateCommunityGuidelineInsight :one
INSERT INTO community_guidelines_insight (
  insight_name,
  insight_name_ar,
  icon,
  description_text,
  status,
  created_at,
  update_at

) VALUES (
  $1, $2, $3, $4, $5, $6, $7
)
RETURNING *;


-- name: GetCommunityGuideLineInsights :many
SELECT 
 *
FROM community_guidelines_insight 
WHERE  community_guidelines_insight.status not in (5,6)
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');


-- name: GetCommunityGuideLineInsightsCount :one
SELECT 
 count(community_guidelines_insight)
FROM community_guidelines_insight  
WHERE  community_guidelines_insight.status not in (5,6);

-- name: GetDeletedCommunityGuideLineInsights :many
SELECT 
 *
FROM community_guidelines_insight  
WHERE community_guidelines_insight.status=6
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetDeletedCommunityGuideLineInsightsCount :one
SELECT 
 count(community_guidelines_insight) 
FROM community_guidelines_insight 
WHERE community_guidelines_insight.status=6;




-- name: GetCommunityGuideLineInsight :one
SELECT 
sqlc.embed(community_guidelines_insight)
FROM community_guidelines_insight
WHERE id=$1;

-- name: UpdateCommunityGuidelineInsight :one
UPDATE community_guidelines_insight
SET 
  insight_name=$1,
  insight_name_ar=$2,
  icon=$3,
  description_text=$4,
  update_at=$5
WHERE id=$6
RETURNING *;

-- name: UpdateCommunityGuideLineInsightStatus :one
UPDATE community_guidelines_insight
SET 
    status=$1,
    update_at=$2,
    deleted_at=$3
WHERE id=$4
RETURNING *;