-- //-- name: CreateRentFact :one
-- INSERT INTO rent_facts (
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
--     rent_type,
--     no_of_payments,
--     property_types_id
-- )VALUES (
--     $1 ,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14
-- ) RETURNING *;

-- -- name: GetRentFact :one
-- SELECT * FROM rent_facts 
-- WHERE id = $1 LIMIT $1;
  
-- -- -- name: GetRentFactByRentPropertyUnitId :one
-- -- SELECT * FROM rent_facts 
-- -- WHERE rent_property_units_id = $2 LIMIT $1;



-- -- name: GetAllRentFact :many
-- SELECT * FROM rent_facts
-- ORDER BY id
-- LIMIT $1
-- OFFSET $2;




-- -- name: UpdateRentFact :one
-- UPDATE rent_facts
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
--     rent_type = $13,
--     no_of_payments = $14,
--     property_types_id = $15
-- Where id = $1
-- RETURNING *;


-- -- name: DeleteRentFact :exec
-- DELETE FROM rent_facts
-- Where id = $1;

