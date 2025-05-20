-- //-- name: CreateSaleFact :one
-- INSERT INTO sale_facts (
--     bedrooms,
--     bathrooms,
--     plot_area,
--     buildup_area,
--     furnishing,
--     parking,
--     ownership,
--     completion_status,
--     service_charges,
--     no_of_floors,
--     price,
--     property_types_id
-- )VALUES (
--     $1 ,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12
-- ) RETURNING *;

-- -- name: GetSaleFact :one
-- SELECT * FROM sale_facts 
-- WHERE id = $1 LIMIT $1;

-- -- -- name: GetSaleFactBySaleProperyUnitsId :one
-- -- SELECT * FROM sale_facts 
-- -- WHERE sale_property_units_id = $2 LIMIT $1;


-- -- name: GetAllSaleFact :many
-- SELECT * FROM sale_facts
-- ORDER BY id
-- LIMIT $1
-- OFFSET $2;

-- -- name: UpdateSaleFact :one
-- UPDATE sale_facts
-- SET  bedrooms = $2,
--     bathrooms = $3,
--     plot_area = $4,
--     buildup_area = $5,
--     furnishing = $6,
--     parking = $7,
--     ownership = $8,
--     completion_status = $9,
--     service_charges = $10,
--     no_of_floors = $11,
--     price = $12, 
--     property_types_id = $13
-- Where id = $1
-- RETURNING *;


-- -- name: DeleteSaleFact :exec
-- DELETE FROM sale_facts
-- Where id = $1;

