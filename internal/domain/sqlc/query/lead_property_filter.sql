-- name: FilterPropertyHubPropertiesForLead :many
SELECT ROW_NUMBER() OVER (ORDER BY fp.ref_no) AS "value", fp.ref_no, fp.property_name as "label" FROM freelancers_properties fp
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id JOIN addresses a ON fp.addresses_id = a.id
WHERE ((pf.life_style = 3 or sqlc.arg(is_life_style)::bool) and (pf.life_style != 3 or NOT sqlc.arg(is_life_style)::bool) and (fp.property_types_id = $5 or sqlc.arg(disable_property_type)::bool) and (pf.bathroom = $1 or sqlc.arg(disable_bath)::bool) 
and pf.bedroom LIKE $2 and pf.min_area >= $3 and pf.max_area <= $4  and pf.price >= sqlc.arg(min_price) and pf.price <= sqlc.arg(max_price) OR sqlc.arg(disable_filter)::bool) and 
(fp.addresses_id IN  (select id from addresses where (addresses.countries_id = $6 or sqlc.arg(disable_country)::bool) and ( addresses.states_id = $7 or sqlc.arg(disable_state)::bool) and 
(addresses.cities_id = $8 or sqlc.arg(disable_city)::bool) and (addresses.communities_id = ANY($9::bigint[]) or sqlc.arg(disable_comm)::bool) and (addresses.sub_communities_id = ANY($10::bigint[]) or sqlc.arg(disable_sub_comm)::bool))) and fp.status != 6
UNION
SELECT ROW_NUMBER() OVER (ORDER BY fp.ref_no) AS "value", fp.ref_no, fp.property_name as "label" FROM broker_company_agent_properties fp
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id JOIN addresses a ON fp.addresses_id = a.id
WHERE ((pf.life_style = 3 or sqlc.arg(is_life_style)::bool) and (pf.life_style != 3 or NOT sqlc.arg(is_life_style)::bool) and (fp.property_types_id = $5 or sqlc.arg(disable_property_type)::bool) and (pf.bathroom = $1 or sqlc.arg(disable_bath)::bool) 
and pf.bedroom LIKE $2 and pf.min_area >= $3 and pf.max_area <= $4  and pf.price >= sqlc.arg(min_price) and pf.price <= sqlc.arg(max_price) OR sqlc.arg(disable_filter)::bool)  and 
(fp.addresses_id IN  (select id from addresses where (addresses.countries_id = $6 or sqlc.arg(disable_country)::bool) and ( addresses.states_id = $7 or sqlc.arg(disable_state)::bool) and 
(addresses.cities_id = $8 or sqlc.arg(disable_city)::bool) and (addresses.communities_id = ANY($9::bigint[]) or sqlc.arg(disable_comm)::bool) and (addresses.sub_communities_id = ANY($10::bigint[]) or sqlc.arg(disable_sub_comm)::bool))) and fp.status != 6 
UNION
SELECT ROW_NUMBER() OVER (ORDER BY fp.ref_no) AS "value", fp.ref_no, fp.property_name as "label" FROM broker_company_agent_properties_branch fp
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id JOIN addresses a ON fp.addresses_id = a.id
WHERE ((pf.life_style = 3 or sqlc.arg(is_life_style)::bool) and (pf.life_style != 3 or NOT sqlc.arg(is_life_style)::bool) and (fp.property_types_id = $5 or sqlc.arg(disable_property_type)::bool) and (pf.bathroom = $1 or sqlc.arg(disable_bath)::bool) 
and pf.bedroom LIKE $2 and pf.min_area >= $3 and pf.max_area <= $4  and pf.price >= sqlc.arg(min_price) and pf.price <= sqlc.arg(max_price) OR sqlc.arg(disable_filter)::bool)  and 
(fp.addresses_id IN  (select id from addresses where (addresses.countries_id = $6 or sqlc.arg(disable_country)::bool) and ( addresses.states_id = $7 or sqlc.arg(disable_state)::bool) and 
(addresses.cities_id = $8 or sqlc.arg(disable_city)::bool) and (addresses.communities_id = ANY($9::bigint[]) or sqlc.arg(disable_comm)::bool) and (addresses.sub_communities_id = ANY($10::bigint[]) or sqlc.arg(disable_sub_comm)::bool))) and fp.status != 6 
UNION
SELECT ROW_NUMBER() OVER (ORDER BY fp.ref_no) AS "value", fp.ref_no, fp.property_name as "label" FROM owner_properties fp
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id JOIN addresses a ON fp.addresses_id = a.id
WHERE ((pf.life_style = 3 or sqlc.arg(is_life_style)::bool) and (pf.life_style != 3 or NOT sqlc.arg(is_life_style)::bool) and (fp.property_types_id = $5 or sqlc.arg(disable_property_type)::bool) and (pf.bathroom = $1 or sqlc.arg(disable_bath)::bool) 
and pf.bedroom LIKE $2 and pf.min_area >= $3 and pf.max_area <= $4  and pf.price >= sqlc.arg(min_price) and pf.price <= sqlc.arg(max_price) OR sqlc.arg(disable_filter)::bool)  and 
(fp.addresses_id IN  (select id from addresses where (addresses.countries_id = $6 or sqlc.arg(disable_country)::bool) and ( addresses.states_id = $7 or sqlc.arg(disable_state)::bool) and 
(addresses.cities_id = $8 or sqlc.arg(disable_city)::bool) and (addresses.communities_id = ANY($9::bigint[]) or sqlc.arg(disable_comm)::bool) and (addresses.sub_communities_id = ANY($10::bigint[]) or sqlc.arg(disable_sub_comm)::bool))) and fp.status != 6;

-- name: FilterAgriculturalPropertiesForLead :many
SELECT ROW_NUMBER() OVER (ORDER BY fp.ref_no) AS "value", fp.ref_no, fp.property_name as "label" FROM agricultural_freelancer_properties fp
LEFT JOIN agricultural_properties_facts pf ON pf.properties_id = fp.id JOIN addresses a ON fp.addresses_id = a.id
WHERE ((pf.life_style = 3 or sqlc.arg(is_life_style)::bool) and (pf.life_style != 3 or NOT sqlc.arg(is_life_style)::bool) and (fp.property_types_id = $5 or sqlc.arg(disable_property_type)::bool) and (pf.bathroom = $1 or sqlc.arg(disable_bath)::bool) 
and pf.bedroom LIKE $2 and pf.min_area >= $3 and pf.max_area <= $4  and pf.price >= sqlc.arg(min_price) and pf.price <= sqlc.arg(max_price) OR sqlc.arg(disable_filter)::bool)  and 
(fp.addresses_id IN  (select id from addresses where (addresses.countries_id = $6 or sqlc.arg(disable_country)::bool) and ( addresses.states_id = $7 or sqlc.arg(disable_state)::bool) and 
(addresses.cities_id = $8 or sqlc.arg(disable_city)::bool) and (addresses.communities_id = ANY($9::bigint[]) or sqlc.arg(disable_comm)::bool) and (addresses.sub_communities_id = ANY($10::bigint[]) or sqlc.arg(disable_sub_comm)::bool))) and fp.status != 6 
UNION
SELECT ROW_NUMBER() OVER (ORDER BY fp.ref_no) AS "value", fp.ref_no, fp.property_name as "label" FROM agricultural_broker_agent_properties fp
LEFT JOIN agricultural_properties_facts pf ON pf.properties_id = fp.id JOIN addresses a ON fp.addresses_id = a.id
WHERE ((pf.life_style = 3 or sqlc.arg(is_life_style)::bool) and (pf.life_style != 3 or NOT sqlc.arg(is_life_style)::bool) and (fp.property_types_id = $5 or sqlc.arg(disable_property_type)::bool) and (pf.bathroom = $1 or sqlc.arg(disable_bath)::bool) 
and pf.bedroom LIKE $2 and pf.min_area >= $3 and pf.max_area <= $4  and pf.price >= sqlc.arg(min_price) and pf.price <= sqlc.arg(max_price) OR sqlc.arg(disable_filter)::bool)  and 
(fp.addresses_id IN  (select id from addresses where (addresses.countries_id = $6 or sqlc.arg(disable_country)::bool) and ( addresses.states_id = $7 or sqlc.arg(disable_state)::bool) and 
(addresses.cities_id = $8 or sqlc.arg(disable_city)::bool) and (addresses.communities_id = ANY($9::bigint[]) or sqlc.arg(disable_comm)::bool) and (addresses.sub_communities_id = ANY($10::bigint[]) or sqlc.arg(disable_sub_comm)::bool))) and fp.status != 6 
UNION
SELECT ROW_NUMBER() OVER (ORDER BY fp.ref_no) AS "value", fp.ref_no, fp.property_name as "label" FROM agricultural_broker_agent_properties_branch fp
LEFT JOIN agricultural_properties_facts pf ON pf.properties_id = fp.id JOIN addresses a ON fp.addresses_id = a.id
WHERE ((pf.life_style = 3 or sqlc.arg(is_life_style)::bool) and (pf.life_style != 3 or NOT sqlc.arg(is_life_style)::bool) and (fp.property_types_id = $5 or sqlc.arg(disable_property_type)::bool) and (pf.bathroom = $1 or sqlc.arg(disable_bath)::bool) 
and pf.bedroom LIKE $2 and pf.min_area >= $3 and pf.max_area <= $4  and pf.price >= sqlc.arg(min_price) and pf.price <= sqlc.arg(max_price) OR sqlc.arg(disable_filter)::bool)  and 
(fp.addresses_id IN  (select id from addresses where (addresses.countries_id = $6 or sqlc.arg(disable_country)::bool) and ( addresses.states_id = $7 or sqlc.arg(disable_state)::bool) and 
(addresses.cities_id = $8 or sqlc.arg(disable_city)::bool) and (addresses.communities_id = ANY($9::bigint[]) or sqlc.arg(disable_comm)::bool) and (addresses.sub_communities_id = ANY($10::bigint[]) or sqlc.arg(disable_sub_comm)::bool))) and fp.status != 6 
UNION
SELECT ROW_NUMBER() OVER (ORDER BY fp.ref_no) AS "value", fp.ref_no, fp.property_name as "label" FROM agricultural_owner_properties fp
LEFT JOIN agricultural_properties_facts pf ON pf.properties_id = fp.id JOIN addresses a ON fp.addresses_id = a.id
WHERE ((pf.life_style = 3 or sqlc.arg(is_life_style)::bool) and (pf.life_style != 3 or NOT sqlc.arg(is_life_style)::bool) and (fp.property_types_id = $5 or sqlc.arg(disable_property_type)::bool) and (pf.bathroom = $1 or sqlc.arg(disable_bath)::bool) 
and pf.bedroom LIKE $2 and pf.min_area >= $3 and pf.max_area <= $4  and pf.price >= sqlc.arg(min_price) and pf.price <= sqlc.arg(max_price) OR sqlc.arg(disable_filter)::bool)  and 
(fp.addresses_id IN  (select id from addresses where (addresses.countries_id = $6 or sqlc.arg(disable_country)::bool) and ( addresses.states_id = $7 or sqlc.arg(disable_state)::bool) and 
(addresses.cities_id = $8 or sqlc.arg(disable_city)::bool) and (addresses.communities_id = ANY($9::bigint[]) or sqlc.arg(disable_comm)::bool) and (addresses.sub_communities_id = ANY($10::bigint[]) or sqlc.arg(disable_sub_comm)::bool))) and fp.status != 6;

-- name: FilterIndustrialPropertiesForLead :many
SELECT ROW_NUMBER() OVER (ORDER BY fp.ref_no) AS "value", fp.ref_no, fp.property_name as "label" FROM industrial_freelancer_properties fp
LEFT JOIN industrial_properties_facts pf ON pf.properties_id = fp.id JOIN addresses a ON fp.addresses_id = a.id
WHERE ((pf.life_style = 3 or sqlc.arg(is_life_style)::bool) and (pf.life_style != 3 or NOT sqlc.arg(is_life_style)::bool) and (fp.property_types_id = $5 or sqlc.arg(disable_property_type)::bool) and (pf.bathroom = $1 or sqlc.arg(disable_bath)::bool) 
and pf.bedroom LIKE $2 and pf.min_area >= $3 and pf.max_area <= $4  and pf.price >= sqlc.arg(min_price) and pf.price <= sqlc.arg(max_price) OR sqlc.arg(disable_filter)::bool)  and 
(fp.addresses_id IN  (select id from addresses where (addresses.countries_id = $6 or sqlc.arg(disable_country)::bool) and ( addresses.states_id = $7 or sqlc.arg(disable_state)::bool) and 
(addresses.cities_id = $8 or sqlc.arg(disable_city)::bool) and (addresses.communities_id = ANY($9::bigint[]) or sqlc.arg(disable_comm)::bool) and (addresses.sub_communities_id = ANY($10::bigint[]) or sqlc.arg(disable_sub_comm)::bool))) and fp.status != 6 
UNION
SELECT ROW_NUMBER() OVER (ORDER BY fp.ref_no) AS "value", fp.ref_no, fp.property_name as "label" FROM industrial_broker_agent_properties fp
LEFT JOIN industrial_properties_facts pf ON pf.properties_id = fp.id JOIN addresses a ON fp.addresses_id = a.id
WHERE ((pf.life_style = 3 or sqlc.arg(is_life_style)::bool) and (pf.life_style != 3 or NOT sqlc.arg(is_life_style)::bool) and (fp.property_types_id = $5 or sqlc.arg(disable_property_type)::bool) and (pf.bathroom = $1 or sqlc.arg(disable_bath)::bool) 
and pf.bedroom LIKE $2 and pf.min_area >= $3 and pf.max_area <= $4  and pf.price >= sqlc.arg(min_price) and pf.price <= sqlc.arg(max_price) OR sqlc.arg(disable_filter)::bool)  and 
(fp.addresses_id IN  (select id from addresses where (addresses.countries_id = $6 or sqlc.arg(disable_country)::bool) and ( addresses.states_id = $7 or sqlc.arg(disable_state)::bool) and 
(addresses.cities_id = $8 or sqlc.arg(disable_city)::bool) and (addresses.communities_id = ANY($9::bigint[]) or sqlc.arg(disable_comm)::bool) and (addresses.sub_communities_id = ANY($10::bigint[]) or sqlc.arg(disable_sub_comm)::bool))) and fp.status != 6 
UNION
SELECT ROW_NUMBER() OVER (ORDER BY fp.ref_no) AS "value", fp.ref_no, fp.property_name as "label" FROM industrial_broker_agent_properties_branch fp
LEFT JOIN industrial_properties_facts pf ON pf.properties_id = fp.id JOIN addresses a ON fp.addresses_id = a.id
WHERE ((pf.life_style = 3 or sqlc.arg(is_life_style)::bool) and (pf.life_style != 3 or NOT sqlc.arg(is_life_style)::bool) and (fp.property_types_id = $5 or sqlc.arg(disable_property_type)::bool) and (pf.bathroom = $1 or sqlc.arg(disable_bath)::bool) 
and pf.bedroom LIKE $2 and pf.min_area >= $3 and pf.max_area <= $4  and pf.price >= sqlc.arg(min_price) and pf.price <= sqlc.arg(max_price) OR sqlc.arg(disable_filter)::bool)  and 
(fp.addresses_id IN  (select id from addresses where (addresses.countries_id = $6 or sqlc.arg(disable_country)::bool) and ( addresses.states_id = $7 or sqlc.arg(disable_state)::bool) and 
(addresses.cities_id = $8 or sqlc.arg(disable_city)::bool) and (addresses.communities_id = ANY($9::bigint[]) or sqlc.arg(disable_comm)::bool) and (addresses.sub_communities_id = ANY($10::bigint[]) or sqlc.arg(disable_sub_comm)::bool))) and fp.status != 6 
UNION
SELECT ROW_NUMBER() OVER (ORDER BY fp.ref_no) AS "value", fp.ref_no, fp.property_name as "label" FROM industrial_owner_properties fp
LEFT JOIN industrial_properties_facts pf ON pf.properties_id = fp.id JOIN addresses a ON fp.addresses_id = a.id
WHERE ((pf.life_style = 3 or sqlc.arg(is_life_style)::bool) and (pf.life_style != 3 or NOT sqlc.arg(is_life_style)::bool) and (fp.property_types_id = $5 or sqlc.arg(disable_property_type)::bool) and (pf.bathroom = $1 or sqlc.arg(disable_bath)::bool) 
and pf.bedroom LIKE $2 and pf.min_area >= $3 and pf.max_area <= $4  and pf.price >= sqlc.arg(min_price) and pf.price <= sqlc.arg(max_price) OR sqlc.arg(disable_filter)::bool)  and 
(fp.addresses_id IN  (select id from addresses where (addresses.countries_id = $6 or sqlc.arg(disable_country)::bool) and ( addresses.states_id = $7 or sqlc.arg(disable_state)::bool) and 
(addresses.cities_id = $8 or sqlc.arg(disable_city)::bool) and (addresses.communities_id = ANY($9::bigint[]) or sqlc.arg(disable_comm)::bool) and (addresses.sub_communities_id = ANY($10::bigint[]) or sqlc.arg(disable_sub_comm)::bool))) and fp.status != 6;

-- name: FilterProjectPropertiesForLead :many
SELECT ROW_NUMBER() OVER (ORDER BY fp.ref_no) AS "value", fp.ref_no, fp.property_name as "label" FROM project_properties fp
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id JOIN addresses a ON fp.addresses_id = a.id
WHERE (fp.property_types_id && $1::bigint[] AND (pf.life_style = 3 or sqlc.arg(is_life_style)::bool or pf.life_style is null) and (pf.life_style != 3 or NOT sqlc.arg(is_life_style)::bool or pf.life_style is null) and (pf.bathroom = $2 or sqlc.arg(disable_bath)::bool) 
and (pf.bedroom LIKE $3 or pf.bedroom = '%') and pf.min_area >= $4 and pf.max_area <= $5  and (pf.price >= sqlc.arg(min_price) or sqlc.arg(disable_price)::bool) and (pf.price <= sqlc.arg(max_price) or sqlc.arg(disable_price)::bool) OR sqlc.arg(disable_filter)::bool) and 
(fp.addresses_id IN  (select id from addresses where (addresses.countries_id = $6 or sqlc.arg(disable_country)::bool) and ( addresses.states_id = $7 or sqlc.arg(disable_state)::bool) and 
(addresses.cities_id = $8 or sqlc.arg(disable_city)::bool) and (addresses.communities_id = ANY($9::bigint[]) or sqlc.arg(disable_comm)::bool) and (addresses.sub_communities_id = ANY($10::bigint[]) or sqlc.arg(disable_sub_comm)::bool))) and fp.status != 6;




