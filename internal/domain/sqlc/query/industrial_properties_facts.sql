-- name: CreateIndustrialPropertyFacts :one
INSERT INTO industrial_properties_facts (
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
     price,
     rent_type,
     no_of_payment,
     no_of_retail,
     no_of_pool,
     elevator,
     starting_price,
     life_style,
     properties_id,
     property,
     is_branch,
     created_at,
     updated_at,
     available_units,
     commercial_tax,
     municipality_tax,
     workshop, 
     warehouse,
     office
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20,$21,$22,$23,$24,$25,$26,$27,$28, $29, $30, $31, $32, $33, $34, $35, $36, $37
) RETURNING *;

 
-- name: GetIndustrialPropertyFacts :one
SELECT * FROM industrial_properties_facts 
WHERE id = $1 LIMIT $1;

-- name: GetAllIndustrialPropertyFacts :many
SELECT * FROM industrial_properties_facts
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateIndustrialPropertyFacts :one
UPDATE industrial_properties_facts
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
     properties_id = $28,
     property = $29,
     is_branch = $30,
     created_at = $31,
     updated_at = $32,
     available_units = $33,
     commercial_tax = $34,
     municipality_tax = $35,
     workshop = $36, 
     warehouse =  $37,
     office = $38
Where id = $1
RETURNING *;


-- name: DeleteIndustrialPropertyFacts :exec
DELETE FROM industrial_properties_facts
Where id = $1;

-- name: GetIndustrialPropertyFactsByProperties :one
SELECT * FROM industrial_properties_facts
WHERE industrial_properties_facts.properties_id = $1 AND industrial_properties_facts.property = $2 AND industrial_properties_facts.is_branch = $3;


-- name: GetIndustrialPropertyFactsByIndustryProperties :one
SELECT * FROM industrial_properties_facts 
WHERE industrial_properties_facts.properties_id = $1 AND industrial_properties_facts.property = $2 AND industrial_properties_facts.is_branch = $3;
