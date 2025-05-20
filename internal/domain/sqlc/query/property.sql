-- name: GetPropertiesByPhasesIDs :many
SELECT
    property_versions.id,
    property.entity_id AS phase_id
FROM
    property
    -- INNER JOIN phases ON phases.id = ANY (@phases_id::BIGINT[])
    -- AND phases.status != 6
JOIN property_versions ON property_versions.property_id=property.id
WHERE
    property.entity_type_id = @phase_entity_type_id :: BIGINT
    AND property.entity_id = ANY (@phases_id::BIGINT[])
    AND property.status != 6
    AND (SELECT phases.status from phases where phases.id=property.entity_id )!=6 AND property_versions.status!=6;


-- name: GetPropertiesByProjectID :many
SELECT 
    property_versions.id
FROM 
    property
JOIN property_versions ON property_versions.property_id=property.id
WHERE 
    property.status!=6 AND property.entity_type_id= @project_entity_type::BIGINT AND property.entity_id= @project_id::BIGINT
    AND property_versions.status!=6; 





-- name: MakePropertyVersionVerified :exec
UPDATE
    property_versions
SET
    is_verified = true, 
    updated_at=$1, 
    updated_by=$2
WHERE
    id = @property_version_id :: BIGINT AND status!=6;    

-- name: DisableExpiredExclusivePropertyVersions :exec
UPDATE property_versions
SET "exclusive" = FALSE
WHERE "exclusive" IS TRUE AND end_date < now();


-- name: GetXMLPropertyIDsToDelete :one
SELECT 
    array_agg(property.id)::bigint[] AS property_ids,
    array_agg(property.addresses_id)::bigint[] AS address_ids,
    array_agg(property_versions.id)::bigint[] AS property_version_ids
FROM property
INNER JOIN property_versions ON property_versions.property_id = property.id
WHERE property.from_xml IS TRUE
  AND property_versions.ref_no = ANY(@ref_no_to_delete::varchar[])
  AND property.company_id = @company_id::bigint;

-- name: DeleteXMLPropertyVersions :exec
DELETE FROM property_versions
USING property
WHERE property.id = property_versions.property_id
  AND property.from_xml IS TRUE
  AND property_versions.id = ANY(@ids_to_delete::bigint[]);

-- name: DeleteXMLProperties :exec
DELETE FROM property
WHERE id = ANY(@ids_to_delete::bigint[])
  AND from_xml IS TRUE;

-- name: GetAllXMLPropertyRefNoByCompany :many
SELECT ref_no FROM property_versions
INNER JOIN property ON property_versions.property_id = property.id
WHERE from_xml IS TRUE AND company_id = $1;


-- name: CreatePropertyHub :one
-- INSERT INTO property (
--     companies_id,
--     property_type_id, 
--     property_title, 
--     property_title_arabic, 
--     is_verified, 
--     property_rank,
--     addresses_id, 
--     status,
--     facilities_id,
--     amenities_id,
--     is_show_owner_info, 
--     ref_no,
--     category,
--     unit_types,
--     property_name, 
--     description,
--     description_arabic,
--     owner_users_id,
--     from_xml, 
--     list_of_agent,
--     list_of_notes,
--     list_of_date
-- ) VALUES (
--     $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,
--     $14,$15,$16,$17,$18,$19,$20,$21,$22
-- )RETURNING *;

-- name: CreatePropertyFacts :one
-- INSERT INTO property_facts (
--     plot_area, 
--     built_up_area, 
--     view, 
--     furnished, 
--     ownership,
--     completion_status, 
--     bedroom,
--     bathroom,
--     start_date,
--     completion_date, 
--     handover_date,
--     no_of_floor,
--     no_of_units,
--     min_area, 
--     max_area,
--     service_charge,
--     parking,
--     ask_price, 
--     price,
--     rent_type,
--     no_of_payment,
--     no_of_retail,
--     no_of_pool,
--     elevator,
--     starting_price,
--     life_style,
--     is_branch,
--     available_units,
--     commercial_tax,
--     municipality_tax,
--     is_project_fact,
--     project_id,
--     completion_percentage,
--     completion_percentage_date,
--     type_name_id,
--     sc_currency_id,
--     unit_of_measure,
--     worksop,
--     warehouse,
--     office,
--     sector_no,
--     plot_no,
--     property_no,
--     no_of_tree,
--     no_of_water_well,
--     investment,
--     contract_start_datetime,
--     contract_end_datetime,
--     contract_amount,
--     contract_currency
-- ) VALUES (
--     $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,
--     $16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,
--     $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42,
--     $43,$44,$45,$46,$47,$48,$49,$50
-- ) RETURNING *;




-- name: UpdatePropertyHub :one
-- UPDATE property
-- SET companies_id = $1,
--     property_type_id= $2,
--     property_title = $3,
--     property_title_arabic = $4,
--     is_verified = $5,
--     property_rank = $6,
--     addresses_id = $7,
--     status = $8,
--     facilities_id = $9,
--     amenities_id = $10,
--     is_show_owner_info = $11,
--     category = $12,
--     unit_types = $13,
--     property_name = $14,
--     description = $15,
--     description_arabic = $16,
--     owner_users_id = $17,
--     from_xml = $18,
--     list_of_agent = $19,
--     list_of_notes = $20,
--     list_of_date = $21,
--     updated_at = $22
-- WHERE id = $23
-- RETURNING *;



-- name: UpdatePropertyFacts :one
-- UPDATE property_facts
-- SET  plot_area= $1,
--     built_up_area = $2,
--     view = $3,
--     furnished = $4,
--     ownership = $5,
--     completion_status = $6,
--     bedroom = $7,
--     bathroom = $8,
--     start_date = $9,
--     completion_date = $10,
--     handover_date = $11,
--     no_of_floor = $12,
--     no_of_units = $13,
--     min_area = $14,
--     max_area = $15,
--     service_charge = $16,
--     parking = $17,
--     ask_price = $18,
--     rent_type = $19,
--     no_of_payment = $20,
--     no_of_retail = $21,
--     no_of_pool = $22,
--     elevator = $23,
--     starting_price = $24,
--     life_style = $25,
--     is_branch = $26,
--     available_units = $27,
--     commercial_tax = $28,
--     municipality_tax = $29,
--     is_project_fact = $30,
--     project_id = $31,
--     completion_percentage = $32,
--     completion_percentage_date = $33,
--     type_name_id = $34,
--     sc_currency_id = $35,
--     unit_of_measure = $36,
--     worksop = $37,
--     warehouse = $38,
--     office = $39,
--     sector_no = $40,
--     plot_no = $41,
--     property_no = $42,
--     no_of_tree = $43,
--     no_of_water_well = $44,
--     investment = $45,
--     contract_start_datetime = $46,
--     contract_end_datetime = $47,
--     contract_amount = $48,
--     contract_currency =$49,
--     created_at = $50,
--     price = $51
-- WHERE id = $52
-- RETURNING *;



-- name: GetPropertyfactsById :one
-- select * from property_facts where id = $1;




-- name: CreateSwapRequirement :one
-- INSERT INTO swap_requirement (
-- addresses_id,
-- property_id,
-- property_type,
-- unit_types,
-- no_of_bathrooms,
-- no_of_bedrooms,
-- min_plot_area,
-- max_plot_area,
-- completion_status,
-- views,
-- amenities,
-- facilities,
-- min_no_of_parkings,
-- max_no_of_parkings,
-- min_built_up_area,
-- max_built_up_area,
-- min_price,
-- max_price,
-- ownership,
-- furnished,
-- mortgage,
-- category,
-- notes,
-- notes_arabic,
-- is_notes_public
-- )VALUES (
--     $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25) RETURNING *;





-- name: GetPropertyHubById :one
-- select * from property where id = $1;




-- name: GetProperties :many
-- Select * from property p LEFT JOIN addresses a on p.addresses_id = a.id
-- WHERE CASE @type::BIGINT
--    WHEN 1 THEN (a.countries_id = 1)
--    WHEN 2 THEN (a.countries_id != 1)
-- END
-- AND p.status !=6
-- LIMIT $1 OFFSET $2;


-- name: GetDeletedProperties :many
-- select * from property p where status =6;

-- name: GetSinglePropertyById :one
-- SELECT
-- property.*,
-- countries.*,
-- states.*,
-- cities.*,
-- communities.*,
-- sub_communities.*,
-- companies.company_name,
-- property_types."type",property_types.property_type_facts_id
-- FROM property
-- INNER JOIN addresses ON addresses.id = property.addresses_id
-- INNER JOIN countries ON countries.id = addresses.countries_id
-- INNER JOIN states ON states.id = addresses.states_id
-- LEFT JOIN cities ON cities.id = addresses.cities_id
-- LEFT JOIN communities ON communities.id = addresses.communities_id
-- LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
-- INNER JOIN companies ON companies.id = property.companies_id
-- INNER JOIN property_types ON property_types.id = property.property_type_id
-- WHERE property.id = $1 LIMIT 1;



-- name: GetPropertiesCount :one
-- Select count(*) from property p LEFT JOIN addresses a on p.addresses_id = a.id
-- WHERE CASE @type::BIGINT
--    WHEN 1 THEN (a.countries_id = 1)
--    WHEN 2 THEN (a.countries_id != 1)
-- END
-- AND status !=6;


-- name: GetHubPropertiesByStatusId :many
-- SELECT property.*, property_types.type AS property_type
-- FROM property
-- LEFT JOIN property_types ON property.property_type_id = property_types.id
-- INNER JOIN addresses ON property.addresses_id = addresses.id 
-- INNER JOIN countries ON addresses.countries_id = countries.id  
-- INNER JOIN states ON addresses.states_id = states.id   
-- INNER JOIN cities ON addresses.cities_id = cities.id
-- INNER JOIN companies ON property.companies_id = companies.id 
-- WHERE
-- -- SEARCH CRITERIA
--     (@search = '%%' OR 
--         property.property_name % @search OR 
--         property.property_title % @search OR 
--         property.ref_no % @search OR
--         countries.country % @search OR 
--         property_types."type" % @search OR 
--         states."state" % @search OR 
--         cities.city % @search OR 
--         companies.company_name % @search 
--     )
--     AND property.status = @status::bigint
-- GROUP BY property.id, property_types.type
-- ORDER BY property.id
-- LIMIT $1 OFFSET $2;


-- name: GetCountHubPropertiesByStatusId :one
-- SELECT COUNT(property.id)
-- FROM property
-- LEFT JOIN property_types ON property.property_type_id = property_types.id
-- INNER JOIN addresses ON property.addresses_id = addresses.id 
-- INNER JOIN countries ON addresses.countries_id = countries.id  
-- INNER JOIN states ON addresses.states_id = states.id   
-- INNER JOIN cities ON addresses.cities_id = cities.id
-- INNER JOIN companies ON property.companies_id = companies.id
-- WHERE 
-- -- SEARCH CRITERIA
--     (@search = '%%' OR 
--         property.property_name % @search OR 
--         property.property_title % @search OR 
--         property.ref_no % @search OR
--         countries.country % @search OR 
--         property_types."type" % @search OR 
--         states."state" % @search OR 
--         cities.city % @search OR 
--         companies.company_name % @search 
--     )
-- AND property.status = @status
-- GROUP BY property.id
-- ORDER BY property.id;



-- -- name: CreateSaleProperty :one

-- INSERT INTO sale_properties(
-- title,
-- title_arabic,
-- description,
-- description_arabic,
-- property_id,
-- property_facts_id,
-- status
-- )VALUES ($1,$2,$3,$4,$5,$6,$7)
-- RETURNING *;



-- -- name: CreateRentProperty :one

-- INSERT INTO rent_properties(
-- title,
-- title_arabic,
-- description,
-- description_arabic,
-- property_id,
-- property_facts_id,
-- status
-- )VALUES ($1,$2,$3,$4,$5,$6,$7)
-- RETURNING *;