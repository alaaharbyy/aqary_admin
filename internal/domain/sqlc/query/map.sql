























-- name: GetLatLngValuesForProjectProperty :many
select * from project_properties
LEFT JOIN addresses ON project_properties.addresses_id = addresses.id 
LEFT JOIN cities ON addresses.cities_id = cities.id
LEFT JOIN communities ON addresses.communities_id = communities.id
LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
LEFT JOIN locations on addresses.locations_id = locations.id 
--left join property_types on project_properties.property_types_id = property_types.id
where project_properties.status != 5 and project_properties.status != 6;


-- name: GetLatLngValuesForLuxuryProjectProperty :many
select * from project_properties
LEFT JOIN addresses ON project_properties.addresses_id = addresses.id 
LEFT JOIN cities ON addresses.cities_id = cities.id
LEFT JOIN communities ON addresses.communities_id = communities.id
LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
LEFT JOIN locations on addresses.locations_id = locations.id 
left join properties_facts on project_properties.id = properties_facts.properties_id and properties_facts.property = 1
--left join property_types on project_properties.property_types_id = property_types.id
where project_properties.status != 5 and project_properties.status != 6 and (properties_facts.life_style = 3 or properties_facts.life_style = 4);