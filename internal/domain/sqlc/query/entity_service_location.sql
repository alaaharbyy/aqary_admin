-- name: CreateEntityServiceLocation :one
INSERT INTO entity_service_locations (
  entity_id,
  entity_type_id,
  country_id,
  state_id,
  city_id,
  community_id,
  sub_community_id
) VALUES (
  $1, $2, $3, $4, $5, $6, $7
)
RETURNING *;

-- name: GetEntityServiceLocation :one
SELECT * FROM entity_service_locations
WHERE id = $1;

-- name: GetCountEntityServiceLocation :one
SELECT count(*) FROM entity_service_locations
WHERE
entity_id = $1 AND entity_type_id = $2;

-- name: ListEntityServiceLocations :many
SELECT * FROM entity_service_locations
WHERE
entity_id = $1 AND entity_type_id = $2
ORDER BY id
LIMIT $3 OFFSET $4;

-- name: UpdateEntityServiceLocation :one
UPDATE entity_service_locations
SET
  entity_id = $2,
  entity_type_id = $3,
  country_id = $4,
  state_id = $5,
  city_id = $6,
  community_id = $7,
  sub_community_id = $8,
  updated_at = now()
WHERE id = $1
RETURNING *;

-- name: DeleteEntityServiceLocation :exec
DELETE FROM entity_service_locations
WHERE id = $1;
