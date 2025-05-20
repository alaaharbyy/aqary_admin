-- name: CreateState :one
INSERT INTO states (
    state,
    state_ar,
    countries_id,
    -- lat,
    -- lng,
    status,
    updated_by,
    created_at,
    updated_at,
    is_capital
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7, $8
) RETURNING *;


-- name: GetStateByCountryId :many
SELECT * FROM states
Where countries_id = $1 AND status= @active_status::BIGINT ORDER BY id;



-- name: GetCityByCountryId :many
SELECT * FROM cities
INNER JOIN states ON cities.id = states.id
Where states.countries_id = $1;

-- name: GetStateNew :one
SELECT * FROM states 
WHERE id = $1 LIMIT 1;

-- name: GetState :one
SELECT * FROM states 
WHERE id = $1 LIMIT $1;

-- name: GetStateByName :one
SELECT * FROM states 
WHERE state = $2 LIMIT $1;

-- name: GetAllStates :many
SELECT 
    states.*,
    countries.country,
    countries.country_ar,
    COUNT(*) OVER() AS total_count
FROM states
LEFT JOIN countries ON countries.id = states.countries_id
WHERE states.status = ANY($1::bigint[])
ORDER BY updated_at DESC
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');



-- name: UpdateState :one
UPDATE states
SET 
    state = $2,
    status = $3,
    -- lat = $4,
    -- lng = $5,
    countries_id = $4,
    updated_at = $5,
    updated_by = $6,
    state_ar = $7,
    is_capital = $8

WHERE id = $1
RETURNING *;



-- name: DeleteState :exec
DELETE FROM states
Where id = $1;

