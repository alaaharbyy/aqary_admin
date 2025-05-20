-- name: CreateLocation :one
INSERT INTO locations (
    lat,lng
)VALUES (
    $1 ,$2
) RETURNING *;

-- name: GetLocation :one
SELECT * FROM locations 
WHERE id = $1 LIMIT $1;

-- name: GetLocationByLatLng :one
SELECT * FROM locations 
WHERE lat = $1 AND lng = $2;

-- name: GetAllLocation :many
SELECT * FROM locations
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateLocation :one
UPDATE locations
SET lat = $2, lng =  $3
 
Where id = $1
RETURNING *;


-- name: DeleteLocation :exec
DELETE FROM locations
Where id = $1;

-- name: GetLocationsStringByText :many
SELECT id, location_string AS address_string,
country_id, state_id, city_id, community_id, sub_community_id, property_map_id, last_attribute, location_without
FROM hierarchical_location_view
WHERE search_vector @@ to_tsquery('simple', @searchText::text)
AND country_id = @countryID
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetLocationsStringCountByText :one
SELECT COUNT(id) AS total
FROM hierarchical_location_view
WHERE search_vector @@ to_tsquery('simple', @searchText::text)
AND country_id = @countryID;


-- name: GetLocationFromViewByID :one
SELECT country_id, state_id, city_id, community_id, sub_community_id FROM hierarchical_location_view
WHERE id = $1;

-- name: DeleteXMLBulkLocation :exec
DELETE FROM locations
Where id = ANY(@ids_to_delete::bigint[]);