-- name: GetCountAllProjectUnitsByStatus :one
SELECT COUNT(*)
FROM (
    SELECT
        sale_unit.unit_id,
        'sale'::varchar AS category,
        sale_unit.title,
        sale_unit.status
    FROM
        sale_unit
    WHERE
        sale_unit.status = $1
    UNION ALL
    SELECT
        rent_unit.unit_id,
        'rent'::varchar AS category,
        rent_unit.title,
        rent_unit.status
    FROM
        rent_unit
    WHERE
        rent_unit.status = $1
) AS x
INNER JOIN units ON units.id = x.unit_id
INNER JOIN property_types ON property_types.id = units.property_types_id
INNER JOIN project_properties ON project_properties.id = units.properties_id
    AND units.property = 1
LEFT JOIN phases ON phases.id = project_properties.phases_id
LEFT JOIN projects ON projects.id = project_properties.projects_id
    AND project_properties.phases_id IS NULL
LEFT JOIN addresses ON addresses.id = units.addresses_id
LEFT JOIN countries ON countries.id = addresses.countries_id
LEFT JOIN states ON states.id = addresses.states_id
LEFT JOIN cities ON cities.id = addresses.cities_id
LEFT JOIN communities ON communities.id = addresses.communities_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
LEFT JOIN unit_facts ON units.id = unit_facts.unit_id
WHERE (
    @search = '%%'
    OR units.ref_no ILIKE @search
    OR countries.country ILIKE @search
    OR states."state" ILIKE @search
    OR cities.city ILIKE @search
    OR communities.community ILIKE @search
    OR sub_communities.sub_community ILIKE @search
    OR units.property_name ILIKE @search
    OR unit_facts.built_up_area::TEXT ILIKE @search
    OR unit_facts.plot_area::TEXT ILIKE @search
    OR (CASE
        WHEN 'Freehold' ILIKE @search THEN unit_facts.ownership = 1
        WHEN 'GCC Citizen' ILIKE @search THEN unit_facts.ownership = 2
        WHEN 'Leasehold' ILIKE @search THEN unit_facts.ownership = 3
        WHEN 'Local Citizen' ILIKE @search THEN unit_facts.ownership = 4
        WHEN 'USUFRUCT' ILIKE @search THEN unit_facts.ownership = 5
        WHEN 'Other' ILIKE @search THEN unit_facts.ownership = 6
        WHEN 'draft' ILIKE @search THEN x.status = 1
        WHEN 'available' ILIKE @search THEN x.status = 2
        WHEN 'rented' ILIKE @search THEN x.status = 4
        WHEN 'blocked' ILIKE @search THEN x.status = 5
        ELSE FALSE
    END)
    OR unit_facts.category ILIKE @search
    OR unit_facts.parking::TEXT ILIKE @search
    OR unit_facts.price::TEXT ILIKE @search
    OR unit_facts.service_charge::TEXT ILIKE @search
    OR property_types."type" ILIKE @search
);