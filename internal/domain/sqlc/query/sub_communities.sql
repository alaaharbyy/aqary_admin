-- name: CreateSubCommunity :one
INSERT INTO sub_communities (
   sub_community,
   communities_id
) VALUES
 ($1, $2)
 RETURNING *;


-- name: GetSubCommunityByCommunityId :many
SELECT * FROM sub_communities
Where communities_id = $1 AND status= @active_status::BIGINT ORDER BY id;


-- name: GetSubCommunity :one
SELECT * FROM sub_communities 
WHERE id = $1 LIMIT $1;

-- name: GetListOfSubCommunity :many
SELECT * FROM sub_communities 
WHERE id = ANY($1::bigint[]) ;


-- name: GetSubCommunityByName :one
SELECT * FROM sub_communities 
WHERE sub_community = $2 LIMIT $1;


-- name: GetAllSubCommunityid :many
SELECT id FROM sub_communities 
WHERE communities_id = $1;


-- name: GetListSubCommunity :many
SELECT * FROM sub_communities
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateSubCommunity :one
UPDATE sub_communities
SET sub_community = $2
Where id = $1
RETURNING *;

-- name: DeleteSubCommunity :exec
DELETE FROM sub_communities
Where id =$1;

-- name: GetAllSubCommunitiesByCommunitiesList :many
select * from sub_communities where communities_id = ANY($1::bigint[]);