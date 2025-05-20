-- name: CreateCountryGuide :one
INSERT INTO
    country_guide (
        country_id,
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
	countries WHERE id= $1::BIGINT and status !=6 RETURNING 1;
 
-- name: ExitingCountryGuide :one
SELECT EXISTS (
    SELECT 1
    FROM country_guide
    WHERE country_id = $1 and status!= @deleted_status::bigint
) AS exists;

-- name: ExitingCountryGuideByStatus :one
SELECT EXISTS (
    SELECT 1
    FROM country_guide
    WHERE country_id = $1 and status= @status::bigint
) AS exists;

 
-- name: GetCountryGuides :many
SELECT 
	country_guide.id,
    countries.id as country_id,
	countries.country,
	country_guide.cover_image,
	country_guide.description,
    country_guide.deleted_at
FROM country_guide
JOIN countries ON countries.id= country_guide.country_id
WHERE country_guide.status= @status::BIGINT
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');
 
-- name: GetCountryGuidesCount :one
SELECT 
	count(country_guide.id)
FROM country_guide
JOIN countries ON countries.id= country_guide.country_id
WHERE country_guide.status= @status::BIGINT;
 
-- name: GetCountryGuide :one
SELECT 
	countries.country,
	sqlc.embed(country_guide)
FROM country_guide 
JOIN countries ON countries.id= country_guide.country_id
WHERE country_guide.id=$1;
 

-- name: UpdateCountryGuide :one
UPDATE
    country_guide
SET
    cover_image = COALESCE(sqlc.narg('cover_image'), cover_image),
    description = sqlc.narg('description'),
    updated_at = $2
WHERE
    country_guide.id = $1
    AND country_guide.status = @active_status::BIGINT
RETURNING id;

-- name: UpdateCountryGuideStatus :exec
UPDATE
    country_guide
SET
    updated_at = $2,
    status = $3,
    deleted_at = $4
WHERE   
    id = $1;