-- name: CreateCommunity :one
INSERT INTO communities (
    community,
    cities_id
)VALUES (
    $1, $2
) RETURNING *;


-- name: GetCommunityByCitiesId :many
SELECT   * FROM communities
WHERE cities_id = $1 AND status= @active_status::BIGINT ORDER BY id;


-- name: GetAllCommunityByCitiesId :many
SELECT id FROM communities
WHERE cities_id = $1;

-- name: GetCommunityByStateId :many
SELECT * FROM communities
LEFT JOIN cities ON communities.cities_id = cities.id
LEFT JOIN states ON cities.states_id = states.id
WHERE states_id = $1;

-- name: GetCommunityByCityId :many
SELECT  DISTINCT ON (communities.community) * FROM communities
WHERE communities.cities_id = $1;

-- name: GetCommunity :one
SELECT * FROM communities 
WHERE id = $1 LIMIT $1;

-- name: GetListOfCommunity :many
SELECT * FROM communities 
WHERE id = ANY($1::bigint[]) ;

-- name: GetCommunityByName :one
SELECT * FROM communities 
WHERE community = $2 LIMIT $1;

-- name: GetCommunities :many
SELECT * FROM communities
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateCommunity :one
UPDATE communities
SET community = $2
Where id = $1
RETURNING *;


-- name: DeleteCommunity :exec
DELETE FROM communities
Where id = $1;

-- name: GetAllCommunitiesByCountry :many
select com.*
from communities com
join cities c on c.id=com.cities_id
join states s on s.id=c.states_id
join countries co on co.id=s.countries_id
where co.id=$1;