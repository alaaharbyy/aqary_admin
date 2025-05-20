-- name: CreateCity :one
INSERT INTO cities (
    city,
    states_id,
    status,
    updated_by,
    updated_at,
    city_ar,
    cover_image,
    description
)VALUES (
    $1 ,$2,$3,$4,$5,$6,$7,$8
) RETURNING *;


-- name: GetCityByStatesId :many
SELECT * FROM cities
Where states_id = $1 AND status= @active_status::BIGINT ORDER BY id;


-- name: GetCityByName :one
SELECT * FROM cities 
WHERE city = $1  AND status!=6 LIMIT 1;


-- name: GetCity :one
SELECT sqlc.embed(cities),
coalesce(states.state::varchar,'')::varchar as state,
coalesce(states.state_ar::varchar,'')::varchar as state_ar, 

coalesce(countries.country::varchar,'')::varchar as country,
coalesce(countries.country_ar::varchar,'')::varchar as country_ar,

coalesce(countries.id::bigint,0)::bigint as country_id  
FROM cities
left JOIN states on states.id=cities.states_id
left JOIN countries on countries.id=states.countries_id
WHERE cities.id = $1 LIMIT 1;

-- name: GetAllCity :many
SELECT cities.*,  
coalesce(states.state::varchar,'')::varchar as state,
coalesce(states.state_ar::varchar,'')::varchar as state_ar, 

coalesce(countries.country::varchar,'')::varchar as country,
coalesce(countries.country_ar::varchar,'')::varchar as country_ar,
coalesce(countries.id::bigint,0)::bigint as country_id  
FROM cities
left JOIN states on states.id=cities.states_id
left JOIN countries on countries.id=states.countries_id
where cities.status!=6
ORDER BY cities.updated_at desc
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetCitiesCount :one
SELECT count(*) FROM cities
where cities.status!=6;

-- name: GetDeletedCities :many
SELECT cities.*,  
coalesce(states.state::varchar,'')::varchar as state,
coalesce(states.state_ar::varchar,'')::varchar as state_ar, 

coalesce(countries.country::varchar,'')::varchar as country,
coalesce(countries.country_ar::varchar,'')::varchar as country_ar,

coalesce(countries.id::bigint,0)::bigint as country_id  
FROM cities
left JOIN states on states.id=cities.states_id
left JOIN countries on countries.id=states.countries_id
where cities.status=6
ORDER BY cities.deleted_at
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetDeletedCitiesCount :one
SELECT count(*) FROM cities
where cities.status=6;

-- name: UpdateCity :one
UPDATE cities
SET city = $2,
    updated_by=$3,
    updated_at=$4,
    city_ar=$5,
    cover_image=$6,
    description=$7
Where id = $1
RETURNING *;


-- name: UpdateCityStatus :one
UPDATE cities
SET 
status = $2,
deleted_at=$3,
updated_at=$4
Where id = $1
RETURNING *;


-- name: DeleteCity :exec
DELETE FROM cities
Where id = $1;


-- name: GetCitiesByCountryId :many
With x As (
    SELECT cities.* FROM cities
    LEFT JOIN states ON states.id = cities.states_id 
    LEFT JOIN countries ON countries.id = states.countries_id 
    WHERE $1::bigint = countries.id
) SELECT x.id, city FROM x;


-- name: GetAllCititesByIds :many
SELECT * FROM cities WHERE cities.id = ANY($1::bigint[]);


 
-- name: GetAllCitiesByCountry :many
select c.*
from cities c 
join states s on s.id=c.states_id
join countries co on co.id=s.countries_id
where co.id=$1;