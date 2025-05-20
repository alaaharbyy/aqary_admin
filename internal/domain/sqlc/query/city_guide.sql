-- name: CreateCityGuide :one
INSERT INTO
    city_guide (
         city_id,
        cover_image,
        description,
        status
    )
SELECT
    $1,
    $2,
    $3,
    $4
FROM 
	cities WHERE id= $1::BIGINT and status !=6 RETURNING 1;
 
-- name: GetCityGuides :many
SELECT 
	city_guide.id,
	cities.city,
	cities.id as city_id,
	city_guide.cover_image,
	city_guide.description,
    city_guide.deleted_at,
    cities.states_id , states.state,
    states.countries_id, countries.country
FROM city_guide
JOIN cities ON cities.id = city_guide.city_id
JOIN states ON states.id = cities.states_id
JOIN countries ON countries.id = states.countries_id
WHERE city_guide.status= @status::BIGINT
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');
 
 
-- name: GetCityGuidesCount :one
SELECT 
	count(city_guide.id)
FROM city_guide
JOIN cities ON cities.id= city_guide.city_id
JOIN states ON states.id = cities.states_id
JOIN countries ON countries.id = states.countries_id
WHERE city_guide.status= @status::BIGINT;
 

-- name: GetCityGuide :one
SELECT 
    cities.city,
    cities.states_id , states.state,
    states.countries_id, countries.country,
	sqlc.embed(city_guide)
FROM city_guide 
JOIN cities ON cities.id= city_guide.city_id
JOIN states ON states.id = cities.states_id
JOIN countries ON countries.id = states.countries_id
WHERE city_guide.id=$1;
 

-- name: UpdateCityGuide :one
UPDATE
    city_guide
SET
    cover_image = COALESCE(sqlc.narg('cover_image'), cover_image),
    description = sqlc.narg('description'),
    updated_at = $2
WHERE
    city_guide.id = $1
    AND status = @active_status::BIGINT
   RETURNING id;


-- name: UpdateCityGuideStatus :exec
UPDATE
    city_guide
SET
    updated_at = $2,
    status = $3,
    deleted_at = $4
WHERE   
    id = $1;


-- name: ExitingCityGuide :one
SELECT EXISTS (
    SELECT 1
    FROM city_guide
    WHERE city_id = $1 and status!= @deleted_status::bigint
) AS exists;


-- name: ExitingCityGuideByStatus :one
SELECT EXISTS (
    SELECT 1
    FROM city_guide
    WHERE city_id = $1 and status= @status::bigint
) AS exists;
