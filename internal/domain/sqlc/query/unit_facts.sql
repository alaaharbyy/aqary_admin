-- name: CreateUnitFact :one
INSERT INTO unit_facts (
bedroom,
bathroom,
plot_area,
built_up_area, 
view, 
furnished, 
ownership,  
completion_status, 
start_date, 
completion_date,  
handover_date,  
no_of_floor,  
no_of_units, 
min_area,  
max_area,  
service_charge,  
parking,  
ask_price,  
price , 
rent_type,  
no_of_payment,  
no_of_retail, 
no_of_pool, 
elevator, 
starting_price ,
life_style,  
unit_id,
category,  
is_branch ,
created_at,  
updated_at,
commercial_tax,
municipality_tax,
sc_currency_id,
unit_of_measure
)VALUES (
     $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20,$21,$22,$23,$24,$25,$26,$27,$28, $29, $30, $31, $32, $33, $34, $35
) RETURNING *;

-- name: GetUnitFact :one
SELECT * FROM unit_facts 
WHERE id = $1;


-- name: GetAllUnitFact :many
SELECT * FROM unit_facts
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateUnitFact :one
UPDATE unit_facts
SET  bedroom = $2,  
bathroom = $3, 
plot_area = $4,  
built_up_area = $5, 
view = $6, 
furnished = $7, 
ownership = $8,  
completion_status = $9, 
start_date = $10, 
completion_date = $11,  
handover_date = $12,  
no_of_floor = $13,  
no_of_units = $14, 
min_area = $15,  
max_area = $16,  
service_charge = $17,  
parking = $18,  
ask_price = $19,  
price = $20, 
rent_type = $21,  
no_of_payment = $22,  
no_of_retail = $23, 
no_of_pool = $24, 
elevator = $25, 
starting_price = $26,
life_style = $27,  
unit_id = $28,  
category = $29,
is_branch = $30,
created_at = $31,  
updated_at = $32,
commercial_tax = $33,
municipality_tax = $34,
sc_currency_id = $35,
unit_of_measure = $36
Where id = $1
RETURNING *;

-- name: DeleteUnitFact :exec
DELETE FROM unit_facts
Where id = $1;

-- name: GetUnitFactsByUnit :one
SELECT * FROM unit_facts
WHERE unit_facts.unit_id = $1 AND unit_facts.category = $2 AND unit_facts.is_branch = $3;

-- -- name: GetAllConsumeFactsCountByProjectPropertyId :one
-- WITH x AS(
-- SELECT id,unit_id,'sale' AS category
-- FROM sale_unit
-- WHERE status != 6
-- UNION ALL
-- SELECT id,unit_id,'rent' AS category
-- FROM rent_unit
-- WHERE status != 6
-- ) SELECT
-- COALESCE(SUM(unit_facts.plot_area), 0)::bigint AS plot_area_consume,
-- COALESCE(SUM(unit_facts.built_up_area), 0)::bigint AS built_up_area_consume,
-- COALESCE(COUNT(x.id), 0)::bigint AS no_of_units_consume
-- FROM x 
-- INNER JOIN unit_facts ON unit_facts.unit_id = x.unit_id AND unit_facts.category = x.category
-- INNER JOIN units ON units.id = x.unit_id
-- WHERE units.properties_id = $1 AND units.property = 1;
-- WITH x AS(
-- SELECT id,'sale' AS category
-- FROM sale_property_units
-- WHERE status != 5 AND status != 6 AND sale_property_units.properties_id = $1 AND property = 1
-- UNION ALL
-- SELECT id,'rent' AS category
-- FROM rent_property_units
-- WHERE status != 5 AND status != 6 AND rent_property_units.properties_id = $1 AND property = 1
-- ) SELECT 
-- COALESCE(SUM(unit_facts.plot_area), 0)::bigint AS plot_area_consume,
-- COALESCE(SUM(unit_facts.built_up_area), 0)::bigint AS built_up_area_consume,
-- COALESCE(COUNT(unit_facts.unit_id), 0)::bigint AS no_of_units_consume
-- FROM x INNER JOIN unit_facts ON unit_facts.unit_id = x.id AND unit_facts.category = x.category;
-- SELECT 
-- COALESCE(SUM(plot_area), 0)::bigint AS plot_area_consume,
-- COALESCE(SUM(built_up_area), 0)::bigint AS built_up_area_consume,
-- COALESCE(COUNT(unit_id), 0)::bigint AS no_of_units_consume
-- FROM unit_facts
-- LEFT JOIN sale_property_units AS s ON s.id = unit_facts.unit_id AND s.property = 1 AND s.status != 5 AND s.status != 6
-- LEFT JOIN rent_property_units AS r ON r.id = unit_facts.unit_id AND r.property = 1 AND r.status != 5 AND r.status != 6
-- WHERE s.properties_id = $1 OR r.properties_id = $1;