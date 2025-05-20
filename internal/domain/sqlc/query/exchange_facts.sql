--// -- name: CreateExchangeFact :one
-- INSERT INTO exchange_facts (
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
--     $1 ,$2,$3, $4, $5,$6,$7,$8,$9,$10,$11,$12
-- ) RETURNING *;

-- -- name: GetExchangeFact :one
-- SELECT * FROM exchange_facts 
-- WHERE id = $1 LIMIT $1;

 

-- -- name: GetAllExchangeFact :many
-- SELECT * FROM exchange_facts
-- ORDER BY id
-- LIMIT $1
-- OFFSET $2;

-- -- name: UpdateExchangeFact :one
-- UPDATE exchange_facts
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


-- -- name: DeleteExchangeFact :exec
-- DELETE FROM exchange_facts
-- Where id = $1;

