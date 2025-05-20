-- -- name: CreateFacilities :one
-- INSERT INTO facilities (
--     icon_url,
--     title,
--     created_at,
--     updated_at,
--     category_id
-- )VALUES (
--     $1 ,$2, $3, $4, $5
-- ) RETURNING *;

-- -- name: GetFacilities :one
-- SELECT * FROM facilities 
-- WHERE id = $1 LIMIT 1;

-- -- name: GetFacilitiesByCategory :many
-- SELECT * FROM facilities 
-- WHERE category_id = $3 LIMIT $1 OFFSET $2;


-- -- name: GetAllFacilitiesByCategory :many
-- SELECT facilities.*,facilities_amenities_categories.category FROM facilities LEFT JOIN facilities_amenities_categories ON facilities.category_id = facilities_amenities_categories.id
-- ORDER BY category_id
-- LIMIT $1
-- OFFSET $2;

-- -- name: GetAllFacilitiesByCategoryWithoutPagination :many
-- SELECT facilities.*,facilities_amenities_categories.category FROM facilities LEFT JOIN facilities_amenities_categories ON facilities.category_id = facilities_amenities_categories.id
-- ORDER BY category_id;

-- -- name: UpdateFacilities :one
-- UPDATE facilities
-- SET   icon_url = $2,
--     title = $3,
--     created_at = $4,
--     updated_at = $5,
--     category_id = $6
-- Where id = $1
-- RETURNING *;


-- -- name: DeleteFacilities :exec
-- DELETE FROM facilities
-- Where id = $1;

-- -- name: GetAllFacilitiesByIds :many
-- SELECT facilities.*,facilities_amenities_categories.category, facilities_amenities_categories.status From facilities LEFT JOIN facilities_amenities_categories ON facilities.category_id = facilities_amenities_categories.id
-- WHERE facilities.id = ANY($1::bigint[]);

-- name: GetAllFacilitiesById :many
SELECT facilities_amenities.title,facilities_amenities.title_ar,facilities_amenities.icon_url, facilities_amenities.categories, categories.category FROM facilities_amenities  
INNER JOIN categories ON categories.id = facilities_amenities.categories
INNER JOIN facilities_amenities_entity ON facilities_amenities_entity.facility_amenity_id = facilities_amenities.id
WHERE facilities_amenities_entity.entity_id = $1 AND facilities_amenities_entity.entity_type_id = $2 AND facilities_amenities.type = 1;


-- -- name: GetAllFacilitiesWithoutPagenation :many
-- SELECT * FROM facilities
-- ORDER BY id;

-- -- name: GetFacilityByTitleAndCategory :one
-- SELECT * FROM facilities WHERE LOWER(title) = LOWER($1) AND category_id = $2;


-- -- name: GetCountAllFacilities :one
-- SELECT COUNT(*) FROM facilities;


-- -- name: GetAllFacilitiesByCategoryIdWithoutPagenation :many
-- SELECT * FROM facilities
-- WHERE category_id = $1;

-- -- name: DeleteFacilitiesByCategoryId :exec
-- DELETE FROM facilities WHERE category_id = $1;




-- -- name: GetAllFacilitiesId :many
-- SELECT id From facilities;

-- -- name: GetAllFacilitiesByPhaseID :many
-- SELECT facilities.*,facilities_amenities_categories.category 
-- FROM facilities
-- LEFT JOIN facilities_amenities_categories ON facilities_amenities_categories.id = facilities.category_id
-- WHERE
--     facilities.id IN
--     (
--         SELECT
--             UNNEST(facilities)
--         FROM
--             phases
--         WHERE
--             phases.id = $1
--     );

-- -- name: GetAllFacilitiesByProjectID :many
-- SELECT facilities.*,facilities_amenities_categories.category 
-- FROM facilities
-- LEFT JOIN facilities_amenities_categories ON facilities_amenities_categories.id = facilities.category_id
-- WHERE
--     facilities.id IN
--     (
--         SELECT
--             UNNEST(facilities_id)
--         FROM
--             projects
--         WHERE
--            projects.id = $1
--     );