-- name: CreateUnits :one
INSERT INTO units(
	unit_no,
	unitno_is_public,
	notes,
	notes_arabic,
	notes_public,
	is_verified,
    unit_title,
    description, 
    unit_title_arabic,
    description_arabic,
    created_at,
	updated_at,
	addresses_id,
    unit_type_id, 
    created_by,
    updated_by,
	type_name_id,
 	owner_users_id,
	from_xml,
    company_id,
    status,
    facts,
	entity_type_id,
	entity_id,
	is_project_unit
) VALUES(
	$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25
) RETURNING *;


-- name: UpdateUnit :one
UPDATE units
SET unit_no = $2,
	unitno_is_public = $3,
	notes = $4,
	notes_arabic = $5,
	notes_public = $6,
	is_verified = $7,
    unit_title =  $8,
    description = $9, 
    unit_title_arabic = $10,
    description_arabic = $11,
	updated_at =  now(),
	addresses_id =  $12,
    unit_type_id = $13,
    updated_by =  $14,
	type_name_id = $15,
 	owner_users_id  =$16,
	from_xml = $17,
    company_id = $18,
    status = $19,
    facts = $20,
	entity_type_id = $21,
	entity_id = $22,
	is_project_unit = $23
Where id = $1
RETURNING *;


-- name: CreateUnitVersion :one
INSERT INTO unit_versions (
 title,
 title_arabic, 
 description,  
 description_arabic , 
 unit_id,  
 ref_no, 
 status, 
 type, 
 unit_rank,  
 created_at, 
 updated_at, 
 created_by, 
 updated_by, 
 facts, 
 listed_by, 
 is_verified,
 is_main,
exclusive,
start_date,
end_date,
refreshed_at
)VALUES (
	 $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,$17,$18,$19,$20,$21
) RETURNING *;


-- name: UpdateUnitVersion :one
UPDATE  unit_versions
SET  title = $2,
 title_arabic = $3, 
 description = $4,  
 description_arabic = $5,   
 status = $6, 
 type = $7, 
 unit_rank = $8,   
 updated_at = $9, 
 updated_by = $10, 
 facts = $11, 
 listed_by = $12,
is_verified = $13
Where id =  $1
RETURNING *;


-- name: UpdateUnitVersionStatus :one
UPDATE  unit_versions
SET   
   status = $2,
   facts = $3
  --  updated_at=now() 
Where id =  $1
RETURNING *;

-- name: UpdateUnitVersionRank :one
UPDATE  unit_versions
SET   
   unit_rank = $2
--    updated_at=now()
Where id =  $1
RETURNING *;


-- name: UpdateUnitVersionType :one
UPDATE  unit_versions
SET   
   type = $2,
   facts = $3,
   updated_at=now()
Where id =  $1
RETURNING *;


-- name: GetUnitByID :one
SELECT * FROM units 
WHERE id =  $1;

-- name: GetUnitVersionById :one
SELECT * FROM unit_versions 
WHERE id =  $1;

-- name: GetUnitVersionByUnitId :one
SELECT * FROM unit_versions 
WHERE unit_id =  $1;

-- name: GetAllUnitVersions :many
SELECT * FROM unit_versions uv
inner join units u on uv.unit_id = u.id
WHERE uv.status!=6 and u.status!=6;


-- name: GetUnitVersionByUnitVersionID :one
SELECT * FROM unit_versions 
INNER JOIN units ON units.id = unit_versions.unit_id
WHERE unit_id =  $1;
 


-- name: GetAllUnitVersion :many
SELECT unit_versions.*, units.*,projects.project_name,phases.phase_name,property.property_name,property.id as prop_id,addresses.full_address,unit_type.type as unit_type,unit_type.type_ar as unit_type_ar, unit_type.facts as unit_type_fact,
refresh_schedules.next_run_at AS next_run_at

FROM unit_versions
 LEFT JOIN refresh_schedules ON refresh_schedules.entity_type_id= @unit_version_entity_type::BIGINT AND refresh_schedules.entity_id= unit_versions.id AND refresh_schedules.status not in (5,6)
 INNER JOIN units ON unit_versions.unit_id = units.id
 INNER JOIN addresses ON units.addresses_id = addresses.id
 LEFT JOIN companies ON units.company_id = companies.id
 LEFT JOIN company_users ON company_users.users_id = unit_versions.listed_by
 LEFT JOIN countries ON addresses.countries_id = countries.id
 LEFT JOIN states ON addresses.states_id = states.id
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id =  communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id =  sub_communities.id 
 LEFT JOIN property ON units.entity_id = property.id AND units.entity_type_id = 3 --  for units
 LEFT JOIN unit_type ON units.unit_type_id = unit_type.id
 LEFT JOIN phases ON property.entity_type_id = 2 AND phases.id = property.entity_id -- attach phase
 LEFT JOIN projects ON (property.entity_type_id = 1 AND projects.id = property.entity_id) OR (phases.projects_id = projects.id) -- attach project
WHERE 
     (
        @company_id::BIGINT = 0 
        OR units.company_id =  @company_id::BIGINT
        OR company_users.company_id =  @company_id::BIGINT
    )
    AND 
    (
         @agent_id::BIGINT = 0 
        OR unit_versions.listed_by =  @agent_id::BIGINT
    )
	AND  units.is_project_unit =  @is_project::boolean 
    AND CASE WHEN @property_id::bigint = 0 THEN true ELSE units.entity_id = @property_id::bigint END    
    AND CASE WHEN @country_id::bigint = 0 THEN true WHEN @is_local::bool = true THEN addresses.countries_id = @country_id::bigint ELSE addresses.countries_id != @country_id::bigint END
    AND (CASE WHEN @life_style::bigint= 0 THEN true ELSE (unit_versions.facts->'life_style')::bigint = @life_style END)
    AND (
      @search = '%%'
      OR  unit_versions.ref_no ILIKE @search
      OR  countries.country  ILIKE @search  
      OR  states."state" ILIKE @search
      OR  cities.city ILIKE @search
      OR  communities.community ILIKE @search
      OR  sub_communities.sub_community ILIKE @search
         ------
       OR units.facts->>'built_up_area'::TEXT ILIKE @search     
       OR units.facts->>'plot_area'::TEXT ILIKE @search
       -- for ownership and status 
      OR ( CASE 
          WHEN  'Freehold' ILIKE @search THEN  (unit_versions.facts->>'ownership')::bigint = 1
          WHEN  'GCC Citizen'  ILIKE @search THEN (unit_versions.facts->>'ownership')::bigint = 2
          WHEN  'Leasehold' ILIKE @search THEN (unit_versions.facts->>'ownership')::bigint = 3
          WHEN  'Local Citizen' ILIKE @search THEN (unit_versions.facts->>'ownership')::bigint = 4
          WHEN  'USUFRUCT' ILIKE @search THEN (unit_versions.facts->>'ownership')::bigint = 5
          WHEN  'Other' ILIKE @search THEN (unit_versions.facts->>'ownership')::bigint = 6
          WHEN  'draft' ILIKE @search THEN unit_versions.status = 1
          WHEN  'available' ILIKE @search THEN unit_versions.status = 2
          WHEN  'rented' ILIKE @search THEN unit_versions.status = 4
          WHEN  'blocked' ILIKE @search THEN unit_versions.status = 5
        ELSE FALSE
      END)
       OR (units.facts->>'parking')::TEXT ILIKE @search
       OR (unit_versions.facts->>'price')::TEXT  ILIKE @search
       OR (unit_versions.facts->>'service_charge')::TEXT  ILIKE @search
--        OR unit_type."type" ILIKE  @search
      OR property.property_name ILIKE @search --  how can fetch this .....             
   )
 --  older version --------
  AND (case when @unit_type::bigint=0 then true else unit_versions."type" = @unit_type::BIGINT end)
AND CASE WHEN @status::bigint = 0 THEN (unit_versions.status != ALL(ARRAY[5,6])) ELSE (unit_versions.status =  @status) END
ORDER BY unit_versions.updated_at DESC
LIMIT $2 OFFSET $1;

-- SELECT unit_versions.*, units.* FROM unit_versions
-- INNER JOIN units ON unit_versions.unit_id = units.id
-- INNER JOIN addresses ON units.addresses_id = addresses.id
-- LEFT JOIN companies ON units.company_id = companies.id
-- WHERE unit_versions."type" = @type AND units.is_project_unit = @is_project_unit 
--   AND CASE WHEN @is_company_user != true THEN true ELSE companies.id = @company_id::bigint   END
--   AND CASE WHEN @country_id::bigint = 0 THEN true ELSE addresses.countries_id = @country_id::bigint END
--   AND CASE WHEN @states_id::bigint = 0 Then true ELSE addresses.states_id = @states_id::bigint END
--   AND CASE WHEN @cities_id::bigint = 0 Then true ELSE addresses.cities_id = @cities_id::bigint END
--   AND CASE WHEN @communities_id::bigint = 0 THEN true ELSE addresses.communities_id = @community_id::bigint END
--   AND CASE WHEN @sub_communities_id::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_community_id::bigint END
-- --   AND (unit_versions.status NOT IN (@status::bigint[]))
-- --  AND   (unit_versions.status != ALL(@status::bigint[]))
--  AND CASE WHEN @status::bigint = 0 THEN (unit_versions.status != ALL(ARRAY[5,6])) ELSE (unit_versions.status =  @status) END
-- LIMIT $1 OFFSET $2;



-- name: GetCountAllUnitVersion :one
SELECT COUNT(unit_versions.id) FROM unit_versions
 INNER JOIN units ON unit_versions.unit_id = units.id
 INNER JOIN addresses ON units.addresses_id = addresses.id
 LEFT JOIN companies ON units.company_id = companies.id
 LEFT JOIN company_users ON company_users.users_id = unit_versions.listed_by
 LEFT JOIN countries ON addresses.countries_id = countries.id
 LEFT JOIN states ON addresses.states_id = states.id
 LEFT JOIN cities ON addresses.cities_id = cities.id
 LEFT JOIN communities ON addresses.communities_id =  communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id =  sub_communities.id 
 LEFT JOIN property ON units.entity_id = property.id AND units.entity_type_id = 3 --  for units
 LEFT JOIN unit_type ON units.unit_type_id = unit_type.id
 LEFT JOIN phases ON property.entity_type_id = 2 AND phases.id = property.entity_id -- attach phase
 LEFT JOIN projects ON (property.entity_type_id = 1 AND projects.id = property.entity_id) OR (phases.projects_id = projects.id) -- attach project
WHERE 
     (
        @company_id::BIGINT = 0 
        OR units.company_id =  @company_id::BIGINT
        OR company_users.company_id =  @company_id::BIGINT
    )
    AND 
    (
         @agent_id::BIGINT = 0 
        OR unit_versions.listed_by =  @agent_id::BIGINT
    )
	AND  units.is_project_unit =  @is_project::boolean 
    AND CASE WHEN @property_id::bigint = 0 THEN true ELSE units.entity_id = @property_id::bigint END    
    AND CASE WHEN @country_id::bigint = 0 THEN true WHEN @is_local::bool = true THEN addresses.countries_id = @country_id::bigint ELSE addresses.countries_id != @country_id::bigint END
    AND (CASE WHEN @life_style::bigint= 0 THEN true ELSE (unit_versions.facts->'life_style')::bigint = @life_style END)
    AND (
      @search = '%%'
      OR  unit_versions.ref_no ILIKE @search
      OR  countries.country  ILIKE @search  
      OR  states."state" ILIKE @search
      OR  cities.city ILIKE @search
      OR  communities.community ILIKE @search
      OR  sub_communities.sub_community ILIKE @search
         ------
       OR units.facts->>'built_up_area'::TEXT ILIKE @search     
       OR units.facts->>'plot_area'::TEXT ILIKE @search
       -- for ownership and status 
      OR ( CASE 
          WHEN  'Freehold' ILIKE @search THEN  (unit_versions.facts->>'ownership')::bigint = 1
          WHEN  'GCC Citizen'  ILIKE @search THEN (unit_versions.facts->>'ownership')::bigint = 2
          WHEN  'Leasehold' ILIKE @search THEN (unit_versions.facts->>'ownership')::bigint = 3
          WHEN  'Local Citizen' ILIKE @search THEN (unit_versions.facts->>'ownership')::bigint = 4
          WHEN  'USUFRUCT' ILIKE @search THEN (unit_versions.facts->>'ownership')::bigint = 5
          WHEN  'Other' ILIKE @search THEN (unit_versions.facts->>'ownership')::bigint = 6
          WHEN  'draft' ILIKE @search THEN unit_versions.status = 1
          WHEN  'available' ILIKE @search THEN unit_versions.status = 2
          WHEN  'rented' ILIKE @search THEN unit_versions.status = 4
          WHEN  'blocked' ILIKE @search THEN unit_versions.status = 5
        ELSE FALSE
      END)
       OR (units.facts->>'parking')::TEXT ILIKE @search
       OR (unit_versions.facts->>'price')::TEXT  ILIKE @search
       OR (unit_versions.facts->>'service_charge')::TEXT  ILIKE @search
--        OR unit_type."type" ILIKE  @search
      OR property.property_name ILIKE @search --  how can fetch this .....             
   )
 --  older version --------
  AND (case when @unit_type::bigint=0 then true else unit_versions."type" = @unit_type::BIGINT end)
AND CASE WHEN @status::bigint = 0 THEN (unit_versions.status != ALL(ARRAY[5,6])) ELSE (unit_versions.status =  @status) END;

-- SELECT COUNT(*) FROM unit_versions
-- INNER JOIN units ON unit_versions.unit_id = units.id
-- INNER JOIN addresses ON units.addresses_id = addresses.id
-- LEFT JOIN companies ON units.company_id = companies.id
-- WHERE unit_versions."type" = @type AND units.is_project_unit = @is_project_unit 
--   AND CASE WHEN @is_company_user != true THEN true ELSE companies.id = @company_id::bigint   END
--   AND CASE WHEN @country_id::bigint = 0 THEN true ELSE addresses.countries_id = @country_id::bigint END
--   AND CASE WHEN @states_id::bigint = 0 Then true ELSE addresses.states_id = @states_id::bigint END
--   AND CASE WHEN @cities_id::bigint = 0 Then true ELSE addresses.cities_id = @cities_id::bigint END
--   AND CASE WHEN @communities_id::bigint = 0 THEN true ELSE addresses.communities_id = @community_id::bigint END
--   AND CASE WHEN @sub_communities_id::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_community_id::bigint END
-- AND CASE WHEN @status::bigint = 0 THEN (unit_versions.status != ALL(ARRAY[5,6])) ELSE (unit_versions.status =  @status) END;


-- name: GetAUnitWithVersion :one
SELECT * from unit_versions
INNER JOIN units ON unit_versions.unit_id =  units.id
WHERE units.id = @unit_id AND unit_versions.id = @unit_version_id;

-- name: GetAUnitWithID :one
SELECT * from units
WHERE units.id = @unit_id AND units.status = @status;

-- name: GetFirstUnitVersionWithUnitID :one
SELECT * from unit_versions uv
WHERE uv.unit_id = @unit_id 
ORDER BY uv.created_at ASC
LIMIT 1;

-- name: GetLocationByAddressID :one
SELECT * from addresses a inner join locations l on a.locations_id = l.id
WHERE a.id = @address_id;




-- name: GetAllDeletedUnits :many
select uv.ref_no,pr.project_name,pr1.project_name,ph.phase_name,u.unit_title,l.lat,l.lng from unit_versions uv
left join units u on u.id=uv.unit_id
left join property p on p.id =u.entity_id and u.entity_type_id =3 
left join phases ph on ph.id = p.entity_id and p.entity_type_id=2
left join projects pr1 on pr1.id=ph.projects_id
left join projects pr on pr.id = p.entity_id and p.entity_type_id =1
left join addresses a on a.id = u.addresses_id
left join locations l on l.id = a.locations_id
where uv.status=6 ;



-- name: GetLocationByAddressId :one
SELECT CONCAT_WS(', ', 
    countries.country, 
--     states.state, 
    cities.city, 
    communities.community, 
    sub_communities.sub_community
) AS combined_address
FROM addresses
LEFT JOIN countries ON addresses.countries_id = countries.id
LEFT JOIN states ON addresses.states_id = states.id
LEFT JOIN cities ON addresses.cities_id = cities.id
LEFT JOIN communities ON addresses.communities_id = communities.id
LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
WHERE addresses.id = $1 LIMIT 1;

 

-- -- name: GetUnitVerifyAndStatusAndRank :one
-- WITH x AS(
--     SELECT status,unit_id,'sale' AS category
--     FROM sale_unit
--     UNION ALL
--     SELECT status,unit_id,'rent' AS category
--     FROM rent_unit
-- )SELECT x.*,units.is_verified,units.property_unit_rank FROM x
-- INNER JOIN units ON units.id = x.unit_id WHERE units.id = @unit_id AND x.category = LOWER(@category);



-- -- name: CheckExistanceOfUnitByUnitId :one
-- SELECT 
-- CASE WHEN sale_unit.unit_id = units.id THEN TRUE ELSE FALSE END AS is_sale,
-- CASE WHEN rent_unit.unit_id = units.id THEN TRUE ELSE FALSE END AS is_rent,
-- sale_unit.status AS sale_unit_status, rent_unit.status AS rent_unit_status,
-- units.properties_id,units.property
-- FROM units
-- LEFT JOIN sale_unit ON sale_unit.unit_id = units.id AND sale_unit.status != 5 AND sale_unit.status != 6
-- LEFT JOIN rent_unit ON rent_unit.unit_id = units.id AND rent_unit.status != 5 AND rent_unit.status != 6
-- WHERE units.id = @unit_id;


-- -- name: GetRentUnitByUnitID :one
-- SELECT rent_unit.id AS rent_unit_id, rent_unit.title, rent_unit.title_arabic, rent_unit.description, rent_unit.description_arabic, rent_unit.unit_id,
-- 	rent_unit.unit_facts_id, rent_unit.created_at, rent_unit.updated_at, 'rent' AS category, rent_unit.status,
-- 	units.id AS units_id, units.unit_no,units.unitno_is_public, units.notes, units.notes_arabic, units.notes_public,
-- 	units.is_verified, units.amenities_id, units.property_unit_rank, units.properties_id, units.property,
-- 	units.created_at, units.updated_at, units.ref_no, units.addresses_id, units.countries_id, units.property_types_id,
-- 	units.created_by, units.property_name, units.section, units.type_name_id, units.owner_users_id, units.from_xml
-- FROM units
-- INNER JOIN rent_unit ON rent_unit.unit_id = units.id
-- WHERE units.id = $1;



-- -- name: GetSaleUnitByUnitID :one
-- SELECT sale_unit.id AS sale_unit_id, sale_unit.title, sale_unit.title_arabic, sale_unit.description, sale_unit.description_arabic, sale_unit.unit_id,
-- 	sale_unit.unit_facts_id, sale_unit.created_at, sale_unit.updated_at, sale_unit.contract_start_datetime, 
-- 	sale_unit.contract_end_datetime, sale_unit.contract_amount,sale_unit.contract_currency,'sale' AS category,sale_unit.status, 
-- 	units.id AS units_id, units.unit_no,units.unitno_is_public, units.notes, units.notes_arabic, units.notes_public,
-- 	units.is_verified, units.amenities_id, units.property_unit_rank, units.properties_id, units.property,
-- 	units.created_at, units.updated_at, units.ref_no, units.addresses_id, units.countries_id, units.property_types_id,
-- 	units.created_by, units.property_name, units.section, units.type_name_id, units.owner_users_id, units.from_xml
-- FROM units
-- INNER JOIN sale_unit ON sale_unit.unit_id = units.id
-- WHERE units.id = $1;


-- -- name: UpdateSaleUnitRankByUnitID :one
-- UPDATE units 
-- SET property_unit_rank = $2,
-- 	updated_at = $3 
-- FROM sale_unit
-- WHERE sale_unit.unit_id = units.id AND sale_unit.unit_id = $1
-- RETURNING *;

-- -- name: UpdateRentUnitRankByUnitID :one
-- UPDATE units 
-- SET property_unit_rank = $2,
-- 	updated_at = $3 
-- FROM rent_unit
-- WHERE rent_unit.unit_id = units.id AND rent_unit.unit_id = $1
-- RETURNING *;



-- -- name: UpdateUnits :one
-- UPDATE units
-- SET	unit_no = $2,
-- 	unitno_is_public = $3,
-- 	notes = $4,
-- 	notes_arabic = $5,
-- 	notes_public = $6,
-- 	is_verified = $7,
-- 	amenities_id = $8,
-- 	property_unit_rank = $9,
-- 	properties_id = $10,
-- 	property = $11,
-- 	created_at = $12,
-- 	updated_at = $13,
-- 	ref_no = $14,
-- 	addresses_id = $15,
-- 	countries_id = $16,
-- 	property_types_id = $17,
-- 	created_by = $18,
-- 	property_name = $19,
-- 	section = $20,
-- 	type_name_id = $21,
-- 	owner_users_id = $22,
-- 	from_xml = $23
-- WHERE id = $1 RETURNING *;


-- name: GetAllConsumeFactsCountByProjectPropertyId :one
SELECT
    COALESCE(SUM((units.facts->> 'plot_area')::numeric), 0)::bigint AS plot_area_consume,
    COALESCE(SUM((units.facts->> 'built_up_area')::numeric), 0)::bigint AS built_up_area_consume,
    COALESCE(COUNT(units.id), 0)::bigint AS no_of_units_consume
FROM units
WHERE 
    units.status NOT IN (5,6)
    AND units.entity_id = @unit_id 
    AND units.entity_type_id = @entity_type_id;
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






-- -- name: GetAllProjectUnitsByStatus :many
-- SELECT
--     x.*,
--     units.ref_no,
--     units.property_name,
--     units.addresses_id,
--     units.properties_id,
--     units.property_types_id,
--     projects.project_name,
--     property_types."type" AS unit_type,
--     phases.phase_name,
--     countries.country,
--     states."state",
--     cities.city,
--     communities.community,
--     sub_communities.sub_community
-- FROM (
--     SELECT
--         sale_unit.unit_id,
--         'sale'::varchar AS category,
--         sale_unit.title,
--         sale_unit.status
--     FROM
--         sale_unit
--     WHERE
--         sale_unit.status = $3
--     UNION ALL
--     SELECT
--         rent_unit.unit_id,
--         'rent'::varchar AS category,
--         rent_unit.title,
--         rent_unit.status
--     FROM
--         rent_unit
--     WHERE
--         rent_unit.status = $3
-- ) AS x
-- INNER JOIN units ON units.id = x.unit_id
-- INNER JOIN property_types ON property_types.id = units.property_types_id
-- INNER JOIN project_properties ON project_properties.id = units.properties_id
--     AND units.property = 1
-- LEFT JOIN phases ON phases.id = project_properties.phases_id
-- LEFT JOIN projects ON projects.id = project_properties.projects_id
--     AND project_properties.phases_id IS NULL
-- LEFT JOIN addresses ON addresses.id = units.addresses_id
-- LEFT JOIN countries ON countries.id = addresses.countries_id
-- LEFT JOIN states ON states.id = addresses.states_id
-- LEFT JOIN cities ON cities.id = addresses.cities_id
-- LEFT JOIN communities ON communities.id = addresses.communities_id
-- LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
-- LEFT JOIN unit_facts ON units.id = unit_facts.unit_id
-- WHERE (
--     @search = '%%'
--     OR units.ref_no ILIKE @search
--     OR countries.country ILIKE @search
--     OR states."state" ILIKE @search
--     OR cities.city ILIKE @search
--     OR communities.community ILIKE @search
--     OR sub_communities.sub_community ILIKE @search
--     OR units.property_name ILIKE @search
--     OR unit_facts.built_up_area::TEXT ILIKE @search
--     OR unit_facts.plot_area::TEXT ILIKE @search
--     OR (CASE
--         WHEN 'Freehold' ILIKE @search THEN unit_facts.ownership = 1
--         WHEN 'GCC Citizen' ILIKE @search THEN unit_facts.ownership = 2
--         WHEN 'Leasehold' ILIKE @search THEN unit_facts.ownership = 3
--         WHEN 'Local Citizen' ILIKE @search THEN unit_facts.ownership = 4
--         WHEN 'USUFRUCT' ILIKE @search THEN unit_facts.ownership = 5
--         WHEN 'Other' ILIKE @search THEN unit_facts.ownership = 6
--         WHEN 'draft' ILIKE @search THEN x.status = 1
--         WHEN 'available' ILIKE @search THEN x.status = 2
--         WHEN 'rented' ILIKE @search THEN x.status = 4
--         WHEN 'blocked' ILIKE @search THEN x.status = 5
--         ELSE FALSE
--     END)
--     OR unit_facts.category ILIKE @search
--     OR unit_facts.parking::TEXT ILIKE @search
--     OR unit_facts.price::TEXT ILIKE @search
--     OR unit_facts.service_charge::TEXT ILIKE @search
--     OR property_types."type" ILIKE @search
-- )
-- ORDER BY units.created_at DESC
-- LIMIT $1 OFFSET $2;


-- name: GetGlobalPropertyByID :one
SELECT * FROM property
Where id = $1;


-- name: GetGlobalPropertyTypeByID :one
SELECT * FROM global_property_type 
Where id = $1;



-- name: GetUnitTypeVariation :one
SELECT * FROM unit_type_variation
WHERE id = $1;


-- name: GetUnitsByPropertyIDs :many
with Properties as(
	SELECT DISTINCT
	 property_versions.property_id as property_id
	FROM 
	property_versions
	WHERE property_versions.id =ANY( @property_version_ids:: BIGINT[]) AND property_versions.status!=6
)  
SELECT
    unit_versions.id, 
    units.entity_id AS property_id 
FROM
    units
JOIN Properties ON units.entity_id=Properties.property_id
JOIN unit_versions ON unit_versions.unit_id=units.id
WHERE
    units.entity_type_id = @property_entity :: BIGINT
    AND units.status != 6 AND unit_versions.status!=6 
    AND (SELECT property.status FROM property WHERE property.id=units.entity_id )!=6;

-- name: GetActiveGlobalPropertyTypeByType :one
SELECT * FROM global_property_type 
Where TRIM(LOWER(type)) = TRIM(LOWER(@type::varchar)) AND is_project IS false AND status = 2 AND usage = $1;

-- name: CheckIfUnitNoExist :one
SELECT EXISTS(
    SELECT 1 FROM units
    WHERE CASE WHEN @unit_id::bigint = 0 THEN unit_no = $1 AND entity_id = $2 AND entity_type_id = $3 -- for create new unit case
    ELSE id != @unit_id::bigint AND unit_no = $1 AND entity_id = $2 AND entity_type_id = $3 END -- for update unit case
)::boolean;



-- name: GetAllUnitVersionsIdS :many 
SELECT id FROM unit_versions; 


-- name: UpdateUnitVersionCounterView :exec
UPDATE unit_versions
SET 
    views_count=views_count+$2 
WHERE
    id=$1;



-- name: UpdateUnitVersionsStatusForAgent :exec
UPDATE 
	unit_versions
SET 
	status= @status::BIGINT
WHERE 
	listed_by= @agent_id::BIGINT;