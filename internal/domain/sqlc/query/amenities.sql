
-- name: DeleteFacilityAmenityEntityRecord :exec
DELETE FROM facilities_amenities_entity
WHERE id=$1;

-- name: GetAllFacilitiesAndAmenities :many
SELECT facilities_amenities_entity.id as record_id,facilities_amenities.* FROM facilities_amenities_entity
LEFT JOIN facilities_amenities ON facilities_amenities_entity.facility_amenity_id = facilities_amenities.id
WHERE entity_type_id = @entity_type_id -- for units
AND entity_id = @entity_id;  -- unit id
  



-- name: CreateFacilityAmenityForEntity :one
INSERT INTO facilities_amenities_entity (
 entity_type_id,
 entity_id,
 facility_amenity_id
) VALUES (
  $1, $2, $3
)RETURNING *;

-- -- name: CreateFacilitiesAmenitiesEntity :one
INSERT INTO facilities_amenities_entity(
entity_id,
entity_type_id,
facility_amenity_id
)VALUES (
   $1 ,$2, $3
) RETURNING *;


-- name: GetFaclitiesAmenitiesForEntityIDAndType :many
select facilities_amenities.*,categories.category from facilities_amenities_entity
inner join facilities_amenities on facilities_amenities_entity.facility_amenity_id = facilities_amenities.id
inner join categories on facilities_amenities.categories = categories.id
 where entity_type_id=$1 and entity_id=$2;

-- name: GetFacilitiesAmenities :many
SELECT * FROM facilities_amenities where id=ANY($1::BIGINT[]);
-- name: GetSingleFacilityAmenity :one
SELECT * FROM facilities_amenities where id=$1;
-- name: CheckIfAllFacilitiesAmenitiesAreCorrect :many
SELECT 1::BIGINT
FROM facilities_amenities fa 
WHERE fa.id= ANY(@facilities_amenities_list::BIGINT[]);


-- name: GetFacilitiesAmenitiesByType :many
SELECT * FROM facilities_amenities where id=ANY($1::BIGINT[]) and type=$2;
-- -- name: CreateAmenities :one
-- INSERT INTO amenities (
--     icon_url,
--     title,
--     created_at,
--     updated_at,
--     category_id
-- )VALUES (
--    $1 ,$2, $3, $4, $5
-- ) RETURNING *;

-- -- name: GetAmenities :one
-- SELECT * FROM amenities 
-- WHERE id = $1 LIMIT $1;


-- -- name: GetAmenitiesWithoutPagination :one
-- SELECT * FROM amenities ORDER BY id;

-- -- name: UpdateAmenities :one
-- UPDATE amenities
-- SET    icon_url = $2,
--     title = $3,
--     created_at = $4,
--     updated_at = $5,
--     category_id = $6
-- Where id = $1
-- RETURNING *;


-- -- name: DeleteAmenities :exec
-- DELETE FROM amenities
-- Where id = $1;

-- -- name: GetAllAmenitiesOrderByCat :many
-- SELECT amenities.*,facilities_amenities_categories.category FROM amenities LEFT JOIN facilities_amenities_categories ON facilities_amenities_categories.id = amenities.category_id
-- ORDER BY category_id LIMIT $1 OFFSET $2;

-- -- name: GetAllAmenitiesOrderByCatWithoutPagination :many
-- SELECT amenities.*,facilities_amenities_categories.category FROM amenities LEFT JOIN facilities_amenities_categories ON facilities_amenities_categories.id = amenities.category_id
-- ORDER BY category_id;

-- name: GetAllAmenitiesById :many
SELECT facilities_amenities.title,facilities_amenities.icon_url, facilities_amenities.categories, categories.category, facilities_amenities.type FROM facilities_amenities  
INNER JOIN categories ON categories.id = facilities_amenities.categories
INNER JOIN facilities_amenities_entity ON facilities_amenities_entity.facility_amenity_id = facilities_amenities.id
WHERE facilities_amenities_entity.entity_id = $1 AND facilities_amenities_entity.entity_type_id = $2 AND facilities_amenities.type = 2;


-- -- name: GetAllAmenitiesWithoutPagenation :many
-- SELECT * FROM amenities
-- ORDER BY id;


-- -- name: GetAmenityByTitleAndCategory :one
-- SELECT * FROM amenities WHERE LOWER(title) = LOWER($1) AND category_id = $2;

-- -- name: GetCountAllAmenities :one
-- SELECT COUNT(*) FROM amenities;

-- -- name: GetAllAmenitiesByCategoryIdWithoutPagenation :many
-- SELECT * FROM amenities
-- WHERE category_id = $1;

-- -- name: DeleteAmenitiesByCategoryId :exec
-- DELETE FROM amenities WHERE category_id = $1;




-- -- name: GetAllAmenitiesByProjectID :many
-- SELECT amenities.*,facilities_amenities_categories.category 
-- FROM amenities
-- LEFT JOIN facilities_amenities_categories ON facilities_amenities_categories.id = amenities.category_id
-- WHERE
--     amenities.id IN
--     (
--         SELECT
--             UNNEST(amenities_id)
--         FROM
--             projects
--         WHERE
--            projects.id = $1
--     );

-- -- name: GetAllAmenitiesByPhaseID :many
-- SELECT amenities.*,facilities_amenities_categories.category 
-- FROM amenities
-- LEFT JOIN facilities_amenities_categories ON facilities_amenities_categories.id = amenities.category_id
-- WHERE
--     amenities.id IN
--     (
--         SELECT
--             UNNEST(amenities)
--         FROM
--             phases
--         WHERE
--             phases.id = $1
--     );

-- -- name: GetAllAmenitiesForProjectProperty :many
 
-- SELECT amenities.*,facilities_amenities_categories.category 
-- FROM amenities
-- LEFT JOIN facilities_amenities_categories ON facilities_amenities_categories.id = amenities.category_id
-- WHERE
--     amenities.id IN
--     (
--         SELECT
--             UNNEST(amenities_id)
--         FROM
--             project_properties
--         WHERE
--             project_properties.id = $1
--     );



-- -- name: GetAllFacilitiesAmenitiesByCategoryWithoutPagination :many
-- SELECT facilities_amenities.*,categories.category FROM facilities_amenities LEFT JOIN categories ON facilities_amenities.categories = categories.id
-- WHERE facilities_amenities."type"=$1
-- ORDER BY facilities_amenities.categories;

-- name: GetAllFacilitiesAmenitiesByCategoryWithoutPagination :many
SELECT 
    ca.category,
    jsonb_agg(
        jsonb_build_object(
            'id', fa.id,
            'title', 
            CASE WHEN @lang::varchar = 'ar' THEN COALESCE(fa.title_ar,fa.title)
            ELSE COALESCE(fa.title, '') END,
            'icon_url', fa.icon_url,
            'type', fa.type::bigint,
            'created_at', fa.created_at
        )
        ORDER BY fa.created_at
    ) AS fac_ame
FROM categories ca
LEFT JOIN facilities_amenities fa ON ca.id = fa.categories
WHERE fa."type" = $1
GROUP BY ca.category
ORDER BY ca.category;


-- name: GetAllFacilitiesAmenitiesWithoutPagination :many
select 
  id,
  icon_url,
  CASE WHEN @lang::varchar = 'ar' THEN COALESCE(fa.title_ar::varchar,fa.title::varchar)::varchar
  ELSE COALESCE(fa.title::varchar, '')::varchar END as title,
  type,
  created_at,
  updated_at,
  categories,
  updated_by
from facilities_amenities fa 
where fa.type = $1;

-- name: GetAllFacilityAmenityIdsByTitle :many
SELECT id
FROM facilities_amenities 
WHERE TRIM(LOWER(title)) IN (
    SELECT TRIM(LOWER(unnest(@title::varchar[])))
) AND type = $1;


 
-- name: CreateBulkFacilityAmenityForEntity :exec
INSERT INTO facilities_amenities_entity (
 entity_type_id,
 entity_id,
 facility_amenity_id
) VALUES (
  $1, $2, unnest(@facility_amenity_ids::bigint[])
) ON CONFLICT (entity_type_id,entity_id,facility_amenity_id) DO NOTHING;


-- name: DeleteFacilityAmenityForEntity :exec
DELETE FROM facilities_amenities_entity
WHERE entity_type_id = $1
  AND entity_id = $2
  AND facility_amenity_id NOT IN (
    SELECT facility_amenity_id
    FROM unnest(@ignore_facility_amenity_ids::bigint[]) AS facility_amenity_id
  );

-- name: GetAllFacilityAmenityForEntity :many
SELECT facility_amenity_id FROM facilities_amenities_entity
WHERE entity_type_id = $1 AND entity_id = $2;

-- name: DeleteXMLFacilityAmenityForEntity :exec
DELETE FROM facilities_amenities_entity
WHERE entity_type_id = $1
  AND entity_id = ANY(@entity_ids::bigint[]);


-- name: CreateFacilityAmenity :one
INSERT INTO facilities_amenities(
  icon_url,
  title,
  title_ar,
  "type",
  created_at,
  updated_at,
  categories,
  updated_by
)VALUES($1,$2,$3,$4,$5,$6,$7,$8)
RETURNING *;

-- name: GetAllFacilityAmenity :many
SELECT facilities_amenities.id,facilities_amenities.title,facilities_amenities.title_ar,facilities_amenities."type",icon_url,categories.id AS category_id,categories.category, COUNT(facilities_amenities.id) OVER() AS total_count
FROM facilities_amenities
INNER JOIN categories ON categories.id = facilities_amenities.categories
WHERE facilities_amenities."type" = $1
ORDER BY id DESC
LIMIT sqlc.narg('limit') OFFSET sqlc.narg('offset');

-- name: GetFacilityAmenity :one
SELECT * FROM facilities_amenities
WHERE id = $1;

-- name: UpdateFacilityAmenity :one
UPDATE facilities_amenities
  SET icon_url = $2,
  title = $3,
  title_ar = $8,
  "type" = $4,
  updated_at = $5,
  categories = $6,
  updated_by = $7
  WHERE id = $1
RETURNING *;

-- name: DeleteFacilityAmenity :exec
DELETE FROM facilities_amenities
WHERE id = $1;

-- name: CheckIfFacilityAmenityIsInUse :one
SELECT EXISTS(SELECT 1 FROM facilities_amenities_entity WHERE facility_amenity_id = $1)::boolean;