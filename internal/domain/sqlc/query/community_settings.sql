-- name: CreateCommunitySettings :one
INSERT INTO
    communities (
        community,
        community_ar,
        cities_id,
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
	cities WHERE id= @city_id::BIGINT and status !=6 RETURNING 1;



-- name: UpdateCommunitySettings :exec
Update
    communities
SET
    community = $2,
    cities_id = $3,
    updated_at = $4,
    updated_by = $5,
    community_ar = $6

WHERE
    communities.id = $1
    AND communities.status != 6
    AND (
        
        $3 = cities_id
        OR EXISTS (SELECT 1 FROM cities WHERE id = $3 AND status != 6)
        
    );
    
    
-- name: GetCommunitySettingsByID :one 
SELECT
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
    communities
    INNER JOIN cities ON cities.id = communities.cities_id
    INNER JOIN states ON states.id = cities.states_id
    INNER JOIN countries ON countries.id = states.countries_id
WHERE
    communities.id = $1
    AND communities.status != 6;
    
-- name: GetAllCommunitiesSettings :many 
SELECT
    communities.id AS "community_id",
    communities.community,
    communities.community_ar,
    cities.city,
    cities.city_ar,
    states."state",
    states.state_ar,
    countries.country,
    countries.country_ar
FROM
    communities
    INNER JOIN cities ON cities.id = communities.cities_id
    INNER JOIN states ON states.id = cities.states_id
    INNER JOIN countries ON countries.id = states.countries_id
WHERE 
    (@status::BIGINT = 6 AND communities.status = 6) 
    OR (@status::BIGINT != 6 AND communities.status IN (1, 2))
ORDER BY
    communities.updated_at DESC
LIMIT sqlc.narg('limit') OFFSET sqlc.narg('offset');


-- name: GetNumberOfCommunitiesSettings :one
SELECT COUNT(*)
FROM
    communities
    INNER JOIN cities ON cities.id = communities.cities_id
    INNER JOIN states ON states.id = cities.states_id
    INNER JOIN countries ON countries.id = states.countries_id
WHERE 
    (@status::BIGINT = 6 AND communities.status = 6) 
    OR (@status::BIGINT != 6 AND communities.status IN (1, 2));

-- name: DeleteRestoreCommunitySettings :exec 
UPDATE communities 
SET 
    status = @status::BIGINT,
    updated_at = $2, 
    updated_by=$3
WHERE 
    id = $1;


	

-- name: GetCommunitySettingsForUpdate :one 
SELECT id,community,community_ar, cities_id 
FROM 
    communities
WHERE 
    id=$1 AND status!=6; 
  