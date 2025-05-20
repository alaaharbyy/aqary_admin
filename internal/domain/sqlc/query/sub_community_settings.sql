-- name: CreateSubCommunitySettings :one
INSERT INTO
    sub_communities (
        sub_community,
        communities_id,
        sub_community_ar,
        created_at,
        updated_at,
        status,
        updated_by
    )
SELECT
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7
FROM 
	communities WHERE id= $2::BIGINT and status !=6 RETURNING 1;
	
	
-- name: UpdateSubCommunitySettings :one
Update
    sub_communities
SET
    sub_community = $2,
    sub_community_ar= $6,
    communities_id = $3,
    updated_at = $4,
    updated_by = $5
WHERE
    sub_communities.id = $1
    AND sub_communities.status != 6
    AND (
        
        $3 = communities_id
        OR EXISTS (SELECT 1 FROM communities WHERE id = $3 AND status != 6)
        
    )RETURNING id;
    
    
-- name: GetSubCommunitySettingsByID :one 
SELECT
	sub_communities.id AS "sub_community_id",
	sub_communities.sub_community,
	sub_communities.sub_community_ar,
    communities.id AS "community_id",
    communities.community,
    communities.community_ar,
    cities.id AS "city_id",
    cities.city,
    cities.city_ar,
    states.id AS "state_id",
    states."state",
    states.state_ar,
    countries.id AS "country_id",
    countries.country,
    countries.country_ar
FROM
    sub_communities
    INNER JOIN communities ON communities.id=sub_communities.communities_id
    INNER JOIN cities ON cities.id = communities.cities_id
    INNER JOIN states ON states.id = cities.states_id
    INNER JOIN countries ON countries.id = states.countries_id
WHERE
    sub_communities.id = $1
    AND sub_communities.status != 6;
    
    
-- name: GetAllSubCommunitiesSettings :many 
SELECT
    sub_communities.id AS "sub_community_id",
    sub_communities.sub_community,
    sub_communities.sub_community_ar,
    communities.community,
    communities.community_ar,
    cities.city,
    cities.city_ar,
    states."state",
    states.state_ar,
    countries.country,
    countries.country_ar
FROM
    sub_communities
    INNER JOIN communities ON communities.id=sub_communities.communities_id
    INNER JOIN cities ON cities.id = communities.cities_id
    INNER JOIN states ON states.id = cities.states_id
    INNER JOIN countries ON countries.id = states.countries_id
WHERE 
    (@status::BIGINT = 6 AND sub_communities.status = 6) 
    OR (@status::BIGINT != 6 AND sub_communities.status IN (1, 2))
ORDER BY
    sub_communities.updated_at DESC
LIMIT sqlc.narg('limit') OFFSET sqlc.narg('offset');


-- name: GetNumberOfSubCommunitiesSettings :one
SELECT COUNT(*)
FROM
    sub_communities
    INNER JOIN communities ON communities.id=sub_communities.communities_id
    INNER JOIN cities ON cities.id = communities.cities_id
    INNER JOIN states ON states.id = cities.states_id
    INNER JOIN countries ON countries.id = states.countries_id
WHERE 
    (@status::BIGINT = 6 AND sub_communities.status = 6) 
    OR (@status::BIGINT != 6 AND sub_communities.status IN (1, 2));
    
    
    
-- name: DeleteRestoreSubCommunitySettings :one 
UPDATE sub_communities 
SET 
    status = @status::BIGINT,
    updated_at = $2, 
    updated_by=$3
WHERE 
    id = $1 RETURNING id;
    
    
-- name: GetSubCommunitySettingsForUpdate :one 
SELECT id,sub_community,communities_id 
FROM 
    sub_communities
WHERE 
    id=$1 AND status!=6; 