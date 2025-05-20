-- name: CreatePropertyFact :one
INSERT INTO properties_facts (
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
 properties_id,  
 property,  
 is_branch ,
 created_at,  
 updated_at,
 available_units,
 is_project_fact,
 project_id,
 completion_percentage,
 completion_percentage_date,
 type_name_id,
 sc_currency_id,
 unit_of_measure
)VALUES (
     $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20,$21,$22,$23,$24,$25,$26,$27,$28, $29, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39
) RETURNING *;

-- name: GetPropertyFact :one
SELECT * FROM properties_facts 
WHERE id = $1;


-- name: GetAllPropertyFact :many
SELECT * FROM properties_facts
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdatePropertyFact :one
UPDATE properties_facts
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
is_project_fact = $34,
project_id = $35,
completion_percentage = $36,
completion_percentage_date = $37,
type_name_id = $38,
sc_currency_id = $39,
unit_of_measure = $40
Where id = $1
RETURNING *;

-- name: UpdateCompletionPercentageAndDateForProperties :exec
UPDATE properties_facts
SET updated_at = $2,
completion_percentage = $3,
completion_percentage_date = $4
Where project_id = $1 AND property = 1 AND is_project_fact = FALSE;

-- name: DeletePropertyFact :exec
DELETE FROM properties_facts
Where id = $1;

-- name: GetPropertyFactsByProperties :one
SELECT * FROM properties_facts 
WHERE properties_facts.properties_id = $1 AND properties_facts.property = $2 AND properties_facts.is_branch = $3;

-- name: GetProjectFacts :one
SELECT * FROM properties_facts WHERE  is_project_fact = TRUE AND project_id = $1;

-- name: GetAllConsumeFactsCountByProjectId :one
SELECT COALESCE(SUM(plot_area),0)::bigint AS plot_area_consume,COALESCE(SUM(built_up_area),0)::bigint AS built_up_area_consume,COUNT(project_properties.id) AS properties_consume
FROM properties_facts
LEFT JOIN project_properties ON project_properties.id = properties_facts.properties_id AND properties_facts.property = 1
WHERE project_properties.projects_id = $1 AND project_properties.phases_id IS NULL AND (project_properties.status != 5 AND project_properties.status != 6);

-- -- name: GetPropertiesWithInvestmentByRentId :one
-- SELECT 
--     pf.type_name_id,
--     pf.price,
--     pf.ask_price,
--     pf.plot_area,
--     pf.service_charge,
--     pf.no_of_units, 
--     pf."view", 
--     pf.furnished, 
--     COALESCE(pp.property, fp.property, bc.property, op.property) as property, 
--     pf.completion_status,
--     COALESCE(p.facilities_id, fp.facilities_id, bc.facilities_id, op.facilities_id) as facilities_id, 
--     pf.built_up_area,
--     u.id as unit_id, 
--     ru.id as rent_unit_id,
--     pt.type as "property_type",
--     uf.price as unit_price,
--     ru.title as "rent_unit_title",
--     u.property_unit_rank, 
--     ru.description as "description",
--     countries.country,
--     cities.city,
--     communities.community,
--     sub_communities.sub_community, 
--     uf.service_charge as unit_service_charge,
--     uf.plot_area as unit_plot_area,
--     uf.no_of_units as unit_no_of_units,
--     uf.built_up_area as unit_built_up_area,
--     uf."view" as unit_view,
--     uf.completion_status as unit_completion_status,
--     u.amenities_id,
--     u.ref_no,
--     u.is_verified,
--     u.property as unit_property,
--     u.properties_id as unit_properties_id,
--     u.is_branch as unit_is_branch,
--     uf.bedroom,
--     uf.bathroom,
--     COALESCE(um.file_urls, ARRAY[]::varchar[]) as "file_urls",
--     COALESCE(cast(cardinality(um.file_urls) as bigint), 0) as "counter",
--     uf.completion_date,
--     uf.handover_date,
--     uf.ownership,
--     uf.parking,
--     uf.start_date,
--     uf.furnished as unit_furnished,
--     uf.no_of_floor,
--     ut.title as unit_title,
--     ut.image_url
-- FROM rent_unit ru
-- INNER JOIN units u ON ru.unit_id = u.id AND ru.status = 2 
-- LEFT JOIN properties_facts pf ON pf.properties_id = u.properties_id AND pf.property = u.property AND pf.is_branch = u.is_branch
-- LEFT JOIN project_properties pp ON pf.properties_id = pp.id AND pf.property = u.property AND pf.is_branch = u.is_branch AND pp.id = u.properties_id
-- LEFT JOIN projects p ON p.id = pp.projects_id
-- LEFT JOIN freelancers_properties fp ON pf.properties_id = fp.id AND pf.property = u.property AND pf.is_branch = u.is_branch AND fp.id = u.properties_id
-- LEFT JOIN broker_company_agent_properties bc ON pf.properties_id = bc.id AND pf.property = u.property AND pf.is_branch = false AND bc.id = u.properties_id
-- LEFT JOIN owner_properties op ON pf.properties_id = op.id AND pf.property = u.property AND pf.is_branch = u.is_branch AND op.id = u.properties_id
-- LEFT JOIN addresses ON u.addresses_id = addresses.id 
-- LEFT JOIN cities ON cities.id = addresses.cities_id 
-- LEFT JOIN countries ON countries.id = addresses.countries_id
-- LEFT JOIN unit_facts uf ON ru.unit_facts_id = uf.id
-- LEFT JOIN property_types pt ON u.property_types_id = pt.id 
-- LEFT JOIN unit_media um ON u.id = um.units_id AND um.gallery_type='Main' AND um.media_type=1
-- LEFT JOIN communities ON communities.id = addresses.communities_id
-- LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
-- LEFT JOIN unit_type_detail ut ON ut.id = u.type_name_id
-- WHERE ru.id = $1;

