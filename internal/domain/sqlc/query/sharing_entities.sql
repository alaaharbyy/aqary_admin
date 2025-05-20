-- name: CreateSharingEntity :exec
INSERT INTO sharing_entities(
    sharing_id,
    entity_type,
    entity_id,
    property_id,
    phase_id,
    status,
    created_at,
    updated_at,
    updated_by,
    exclusive_start_date,
    exclusive_expire_date,
    is_exclusive
)VALUES(
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12
);

-- name: GetSharingEntityById :one
SELECT * FROM sharing_entities
WHERE id = $1;


-- name: PublishUnit :one
INSERT INTO unit_versions (title,title_arabic, description,  description_arabic, 
 unit_id,  ref_no, status, type, unit_rank,  created_at,  created_by,updated_by, 
  facts, listed_by, exclusive, start_date, end_date, refreshed_at)
SELECT 
    $1 AS title,
    $2 AS title_arabic, 
    $3 AS description, 
    $4 AS description_arabic,
    unit_versions.unit_id,
    $5 AS ref_no,
    $6 AS status,
    unit_versions.type,
    unit_versions.unit_rank,
    $7 AS created_at,
    $8 AS created_by,
    $8 AS updated_by,
    unit_versions.facts,
    $9 AS listed_by,
    CASE WHEN sharing_entities.is_exclusive IS TRUE AND sharing_entities.exclusive_expire_date > now() THEN TRUE ELSE FALSE END,
    CASE WHEN sharing_entities.is_exclusive IS TRUE AND sharing_entities.exclusive_expire_date > now() THEN sharing_entities.exclusive_start_date ELSE NULL END,
    CASE WHEN sharing_entities.is_exclusive IS TRUE AND sharing_entities.exclusive_expire_date > now() THEN sharing_entities.exclusive_expire_date ELSE NULL END,
    $10 AS refreshed_at
FROM unit_versions
INNER JOIN units ON units.id = unit_versions.unit_id
INNER JOIN sharing_entities ON sharing_entities.entity_id = unit_versions.id
WHERE sharing_entities.id = @sharing_id::bigint
RETURNING *;

-- name: UpdateSharingEntitiesStatus :one
UPDATE sharing_entities
SET status = $1,
updated_at = $2,
updated_by = $3
WHERE id = $4
RETURNING *;

-- name: UpdateUnitVersionGalleryAndPlanStatus :exec
UPDATE unit_versions
SET has_gallery = $1,
has_plans = $2
WHERE id = $3;


-- name: PublishProperty :one
INSERT INTO property_versions(title, title_arabic, description, description_arabic, 
property_id, facts, created_at, updated_at, updated_by, status, agent_id, ref_no, category,
exclusive, start_date, end_date, refreshed_at
)SELECT  
    $1 AS title, 
    $2 AS title_arabic,
    $3 AS description,
    $4 AS description_arabic, 
    property_versions.property_id,
    property_versions.facts,
    $5 AS created_at, 
    $6 AS updated_at,
    $7 AS updated_by,
    $8 AS status,
    $9 AS agent_id, 
    $10 AS ref_no, 
    property_versions.category,
    CASE WHEN sharing_entities.is_exclusive IS TRUE AND sharing_entities.exclusive_expire_date > now() THEN TRUE ELSE FALSE END,
    CASE WHEN sharing_entities.is_exclusive IS TRUE AND sharing_entities.exclusive_expire_date > now() THEN sharing_entities.exclusive_start_date ELSE NULL END,
    CASE WHEN sharing_entities.is_exclusive IS TRUE AND sharing_entities.exclusive_expire_date > now() THEN sharing_entities.exclusive_expire_date ELSE NULL END,
    $11 AS refreshed_at
FROM property_versions
INNER JOIN property ON property.id = property_versions.property_id
INNER JOIN sharing_entities ON sharing_entities.entity_id = property_versions.id
WHERE sharing_entities.id = @sharing_id::bigint
RETURNING *;

-- name: UpdatePropertyVersionGalleryAndPlanStatus :exec
UPDATE property_versions
SET has_gallery = $1,
has_plans = $2
WHERE id = $3;