-- name: CreateAddress :one
INSERT INTO addresses (
    countries_id,
    states_id,  
    cities_id,
    communities_id,
    sub_communities_id,
    locations_id
)VALUES (
    $1, $2, $3, $4, $5, $6
) RETURNING *;

-- name: GetAddressByCountryId :one
SELECT * FROM addresses 
WHERE countries_id = $2 LIMIT $1;

 
-- name: GetAddress :one
SELECT * FROM addresses 
WHERE id = $1 LIMIT $1;

-- name: GetAllAddress :many
SELECT * FROM addresses
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateAddress :one
UPDATE addresses
SET  countries_id=$2,
    states_id=$3,  
    cities_id=$4,
    communities_id=$5,
    sub_communities_id=$6,
    locations_id = $7 
Where id = $1
RETURNING *;

-- name: UpdateAddressBy :one
UPDATE addresses
SET  countries_id=$2,
    states_id=$3,  
    cities_id=$4,
    communities_id=$5,
    sub_communities_id=$6,
    locations_id = $7 
Where id = $1
RETURNING *;

-- name: UpdateSubCommunityInAddress :one
UPDATE addresses
SET sub_communities_id=$2, locations_id = $3
Where id = $1
RETURNING *;

-- name: GetCompleteAddress :one
SELECT addresses.*, countries.country,states."state",cities.city,communities.community,sub_communities.sub_community,locations.lat,locations.lng
FROM addresses
LEFT JOIN countries ON countries.id = addresses.countries_id
LEFT JOIN states ON states.id = addresses.states_id
LEFT JOIN cities ON cities.id = addresses.cities_id
LEFT JOIN communities ON communities.id = addresses.communities_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
LEFT JOIN locations ON locations.id = addresses.locations_id
WHERE addresses.id = $1;


-- name: DeleteAddress :exec
DELETE FROM addresses
Where id = $1;

-- name: GetAddressAllDetailsByID :one
SELECT 
ad.id,
ad.countries_id,
ad.states_id,
ad.cities_id,
ad.communities_id,
ad.sub_communities_id,
ad.locations_id,
ad.created_at,
ad.updated_at,
 
 
ad_country.id as ad_country_id,
ad_country.country as ad_country_country,
ad_country.flag as ad_country_flag,
ad_country.created_at as ad_country_created_at,
ad_country.updated_at as ad_country_updated_at,
ad_country.alpha2_code as ad_country_alpha2_code,
ad_country.alpha3_code as ad_country_alpha3_code,
ad_country.country_code as ad_country_country_code,
ad_country.lat as ad_country_country_lat,
ad_country.lng as ad_country_country_lng,
 
ad_states.id as ad_states_id,
ad_states.state as ad_states_state,
ad_states.countries_id as ad_states_countries_id,
ad_states.created_at as ad_states_created_at,
ad_states.updated_at as ad_states_updated_at,
ad_states.lat as ad_states_lat,
ad_states.lng as ad_states_lng,
 
ad_cities.id as ad_cities_id,
ad_cities.city as ad_cities_city,
ad_cities.states_id as ad_cities_states_id,
ad_cities.created_at as ad_cities_created_at,
ad_cities.updated_at as ad_cities_updated_at,
ad_cities.lat as ad_cities_lat,
ad_cities.lng as ad_cities_lng,
 
 
ad_communities.id as ad_communities_id,
ad_communities.community as ad_communities_community,
ad_communities.cities_id as ad_communities_cities_id,
ad_communities.created_at as ad_communities_created_at,
ad_communities.updated_at as ad_communities_updated_at,
ad_communities.lat as ad_communities_lat,
ad_communities.lng as ad_communities_lng,
 
 
ad_sub_communities.id as ad_sub_communities_id,
ad_sub_communities.sub_community as ad_sub_communities_sub_community,
ad_sub_communities.communities_id as ad_sub_communities_communities_id,
ad_sub_communities.created_at as ad_sub_communities_created_at,
ad_sub_communities.updated_at as ad_sub_communities_updated_at,
ad_sub_communities.lat as ad_sub_communities_lat,
ad_sub_communities.lng as ad_sub_communities_lng
 
 
FROM addresses ad
left join countries as ad_country ON ad.countries_id = ad_country.id
left join states as ad_states ON ad.states_id = ad_states.id
left join cities as ad_cities ON ad.cities_id = ad_cities.id
left join communities as ad_communities ON ad.communities_id = ad_communities.id
left join sub_communities as ad_sub_communities ON ad.sub_communities_id = ad_sub_communities.id
WHERE ad.id = $1 LIMIT 1;


-- name: GetAllPropertyLocationsBySubCommunity :many
SELECT id,property AS "label" FROM properties_map_location 
WHERE sub_communities_id=$1;

-- name: DeleteXMLAddresses :exec
DELETE FROM addresses
WHERE id = ANY(@ids_to_delete::bigint[]);

-- name: UpdateXMLAddress :exec
UPDATE addresses
SET  countries_id=$2,  
states_id = $3,
    cities_id=$4,
    communities_id=$5,
    sub_communities_id=$6,
    locations_id = $7
Where id = $1;