-- name: CreatePropertyMapLocationInBulk :exec
INSERT INTO properties_map_location(property,sub_communities_id)
VALUES(
    unnest(@property::text[]),
    unnest(@sub_communities_id::bigint[])
);

-- name: CreatePropertyMapLocation :one
INSERT INTO properties_map_location(
	property,
	property_ar,
	sub_communities_id,
	lat,
	lng,
	status,
	updated_by,
	updated_at
) VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
RETURNING *;

-- name: GetPropertyLocationByProperty :one
SELECT * FROM properties_map_location 
WHERE property=$1 AND status!=6;

-- name: GetPropertyLocationByID :one
SELECT
 COALESCE(countries.id::bigint,0)::bigint as country_id ,
 COALESCE(countries.country::varchar,'')::varchar as country ,
 COALESCE(countries.country_ar::varchar,'')::varchar as country_ar ,

 COALESCE(states.id::bigint,0)::bigint as states_id ,
 COALESCE(states."state"::VARCHAR,'')::VARCHAR as state,
 COALESCE(states.state_ar::VARCHAR,'')::VARCHAR as state_ar,  

 COALESCE(cities.id::bigint,0)::bigint as cities_id ,
 COALESCE(cities.city::varchar,'')::varchar as city,
 COALESCE(cities.city_ar::varchar,'')::varchar as city_ar,

 COALESCE(communities.id::bigint,0)::bigint as community_id ,
 COALESCE(communities.community::varchar,'')::varchar as community,
 COALESCE(communities.community_ar::varchar,'')::varchar as community_ar, 

 COALESCE(sub_communities.id::bigint,0)::bigint as sub_communities_id ,
 COALESCE(sub_communities.sub_community::varchar,'')::varchar as subcommunity,
 COALESCE(sub_communities.sub_community_ar::varchar,'')::varchar as subcommunity_ar, 

 properties_map_location.* FROM properties_map_location 
left join sub_communities on sub_communities.id=properties_map_location.sub_communities_id
left join communities on communities.id=sub_communities.communities_id
left join cities on cities.id=communities.cities_id
left join states on states.id=cities.states_id
left join countries on countries.id=states.countries_id
WHERE properties_map_location.id=$1;

-- name: GetAllPropertyLocations :many
SELECT 
 COALESCE(countries.id::bigint,0)::bigint as country_id ,
 COALESCE(countries.country::varchar,'')::varchar as country ,
 COALESCE(countries.country_ar::varchar,'')::varchar as country_ar ,

 COALESCE(states.id::bigint,0)::bigint as states_id ,
 COALESCE(states."state"::VARCHAR,'')::VARCHAR as state,
 COALESCE(states.state_ar::VARCHAR,'')::VARCHAR as state_ar,  

 COALESCE(cities.id::bigint,0)::bigint as cities_id ,
 COALESCE(cities.city::varchar,'')::varchar as city,
 COALESCE(cities.city_ar::varchar,'')::varchar as city_ar,

 COALESCE(communities.id::bigint,0)::bigint as community_id ,
 COALESCE(communities.community::varchar,'')::varchar as community,
 COALESCE(communities.community_ar::varchar,'')::varchar as community_ar, 

 COALESCE(sub_communities.id::bigint,0)::bigint as sub_communities_id ,
 COALESCE(sub_communities.sub_community::varchar,'')::varchar as subcommunity,
 COALESCE(sub_communities.sub_community_ar::varchar,'')::varchar as subcommunity_ar, 

 properties_map_location.* FROM properties_map_location 
left join sub_communities on sub_communities.id=properties_map_location.sub_communities_id
left join communities on communities.id=sub_communities.communities_id
left join cities on cities.id=communities.cities_id
left join states on states.id=cities.states_id
left join countries on countries.id=states.countries_id
WHERE properties_map_location.status!=6
ORDER BY properties_map_location.updated_at desc
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetDeletedPropertyLocations :many
SELECT
 COALESCE(countries.id::bigint,0)::bigint as country_id ,
 COALESCE(countries.country::varchar,'')::varchar as country ,
 COALESCE(countries.country_ar::varchar,'')::varchar as country_ar ,

 COALESCE(states.id::bigint,0)::bigint as states_id ,
 COALESCE(states."state"::VARCHAR,'')::VARCHAR as state,
 COALESCE(states.state_ar::VARCHAR,'')::VARCHAR as state_ar,  

 COALESCE(cities.id::bigint,0)::bigint as cities_id ,
 COALESCE(cities.city::varchar,'')::varchar as city,
 COALESCE(cities.city_ar::varchar,'')::varchar as city_ar,

 COALESCE(communities.id::bigint,0)::bigint as community_id ,
 COALESCE(communities.community::varchar,'')::varchar as community,
 COALESCE(communities.community_ar::varchar,'')::varchar as community_ar, 

 COALESCE(sub_communities.sub_community::varchar,'')::varchar as subcommunity,
 COALESCE(sub_communities.sub_community_ar::varchar,'')::varchar as subcommunity_ar, 

 properties_map_location.* FROM properties_map_location 
left join sub_communities on sub_communities.id=properties_map_location.sub_communities_id
left join communities on communities.id=sub_communities.communities_id
left join cities on cities.id=communities.cities_id
left join states on states.id=cities.states_id
left join countries on countries.id=states.countries_id
WHERE properties_map_location.status=6
ORDER BY properties_map_location.deleted_at DESC
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetDeletedPropertyLocationsCount :one
SELECT  count(*) FROM properties_map_location 
WHERE status=6;

-- name: GetPropertyLocationsCount :one
SELECT  count(*) FROM properties_map_location 
WHERE status!=6;

-- name: UpdatePropertyLocation :one
UPDATE properties_map_location
SET 
property=$1,
property_ar=$2,
updated_by=$3,
updated_at=$4,
lat=$5,
lng=$6
WHERE id=$7
RETURNING *;

-- name: UpdatePropertyLocationStatus :one
UPDATE properties_map_location
SET status=$1,
updated_by=$2,
updated_at=$3,
deleted_at=$4
WHERE id=$5
RETURNING *;