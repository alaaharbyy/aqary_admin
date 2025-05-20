-- name: CreateUnitType :one
INSERT INTO unit_type_detail (
 description,
 image_url,
 min_area,
 max_area,
 min_price,
 max_price,
 parking,
 balcony,
 properties_id,
 property,
 property_types_id,
 title,
 bedrooms,
 description_ar,
 status,
 ref_no
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16
) RETURNING *;

-- name: GetUnitType :one
SELECT unit_type_detail.*, property_types.type AS property_type FROM unit_type_detail 
INNER JOIN property_types ON property_types.id = unit_type_detail.property_types_id
WHERE unit_type_detail.id = $1 LIMIT 1;

-- name: GetAllUnitType :many
SELECT * FROM unit_type_detail
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateUnitType :one
UPDATE unit_type_detail
SET   
  description = $2,
 image_url = $3,
 min_area = $4,
 max_area = $5,
 min_price = $6,
 max_price = $7,
  parking = $8,
 balcony = $9,
 properties_id  = $10,
 property = $11,
 property_types_id = $12,
 title = $13,
 bedrooms = $14,
 description_ar = $15,
  status = $16,
  ref_no = $17
Where id = $1
RETURNING *;


-- name: DeleteUnitType :exec
DELETE FROM unit_type_detail
Where id = $1;

-- name: GetAllUnitTypeByPropertyId :many
SELECT * FROM unit_type_detail 
WHERE property = $1 AND properties_id = $2;


-- name: GetAllUnitTypeByPropertyIdByUnitTypeAndBedroom :many
SELECT * FROM unit_type_detail 
WHERE property = $1 AND properties_id = $2 AND id = $3 AND bedrooms = $4;


-- name: GetAllUnitTypeByPropertyIdAndBedroom :many
SELECT * FROM unit_type_detail 
INNER JOIN property_types On unit_type_detail.property_types_id = property_types.id
WHERE property = $1 AND properties_id = $2 AND property_types.id = $3 AND CASE WHEN bedrooms IS NULL THEN TRUE ELSE bedrooms ILIKE $4 END;


-- name: GetAllUnitTypeByPropertyIdAndBedroomForAgriculture :many
SELECT * FROM agricultural_unit_types
INNER JOIN property_types On agricultural_unit_types.property_types_id = property_types.id
WHERE property = $1 AND properties_id = $2 AND  bedrooms ILIKE  $3 AND property_types.id = $4;


-- name: GetAllUnitTypeBranchByPropertyIdAndBedroomForAgriculture :many
SELECT * FROM agricultural_unit_types_branch 
INNER JOIN property_types On agricultural_unit_types_branch.property_types_id = property_types.id
WHERE property = $1 AND properties_id = $2 AND  bedrooms ILIKE  $3 AND property_types.id = $4;



-- name: GetAllUnitTypeByPropertyIdAndBedroomAndUnitId :many
SELECT * FROM unit_type_detail
WHERE property = $1 AND properties_id = $2 AND  bedrooms  ILIKE  $3 AND unit_type_detail.id = $4;


-- name: GetAllUnitTypeByPropertyIdWithPagination :many
SELECT * FROM unit_type_detail 
INNER JOIN property_types ON unit_type_detail.property_types_id = property_types.id
WHERE 
   ( @search = '%%'
    OR unit_type_detail.title % @search
     OR property_types."type" ILIKE @search
     OR unit_type_detail.bedrooms::TEXT ILIKE @search
     OR unit_type_detail.max_area::TEXT ILIKE @search
     OR unit_type_detail.min_area::TEXT ILIKE @search
     OR unit_type_detail.min_price::TEXT ILIKE @search
     OR unit_type_detail.max_price::TEXT ILIKE @search)
     
  AND property = $3 AND properties_id = $4 AND (unit_type_detail.status != 5 AND unit_type_detail.status != 6) 
ORDER BY unit_type_detail.created_at DESC 
LIMIT $1 OFFSET $2;
-- SELECT * FROM unit_type_detail 
-- WHERE property = $3 AND properties_id = $4 AND (status != 5 AND status != 6) 
-- ORDER BY created_at DESC 
-- LIMIT $1 OFFSET $2;


-- name: GetCountUnitTypeByPropertyId :one
SELECT COUNT(*) FROM unit_type_detail 
INNER JOIN property_types ON unit_type_detail.property_types_id = property_types.id
WHERE 
   ( @search = '%%'
    OR unit_type_detail.title % @search
     OR property_types."type" ILIKE @search
     OR unit_type_detail.bedrooms::TEXT ILIKE @search
     OR unit_type_detail.max_area::TEXT ILIKE @search
     OR unit_type_detail.min_area::TEXT ILIKE @search
     OR unit_type_detail.min_price::TEXT ILIKE @search
     OR unit_type_detail.max_price::TEXT ILIKE @search)
  AND property = $1 AND properties_id = $2 AND (unit_type_detail.status != 5 AND unit_type_detail.status != 6);
-- SELECT COUNT(*) FROM unit_type_detail 
-- WHERE property = $1 AND properties_id = $2;


-- name: GetUnitTypesByPropertiesIdAndProperty :many
SELECT property_types.id AS property_type_id, 
property_types."type" AS property_type,is_residential,
is_commercial,property_types.property_type_facts_id 
FROM unit_type_detail 
LEFT JOIN property_types ON unit_type_detail.property_types_id = property_types.id 
WHERE properties_id =$1 AND property = $2;


-- name: GetUnitTypesNamesByPropertiesIdAndPropertyType :many
SELECT
	unit_type_detail.id,
	title,
	bedrooms
FROM
	unit_type_detail
	LEFT JOIN property_types ON property_types.id = unit_type_detail.property_types_id
WHERE
	properties_id = $1
	AND property = $2
	AND property_types_id = $3;


-- name: UpdateUnitTypeByStatus :one
UPDATE unit_type_detail SET status = $2 WHERE id = $1 RETURNING *;

-- name: GetAllProjectPropertyUnitTypesByStatus :many
SELECT
	unit_type_detail.id,
	unit_type_detail.ref_no,
	unit_type_detail.title AS unit_type_name,
   addresses.full_address,
	property_types."type" AS type_name,
	project_properties.property_name,
	countries.country,
	states."state",
	cities.city,
	communities.community,
	sub_communities.sub_community
FROM unit_type_detail
INNER JOIN property_types ON property_types.id = unit_type_detail.property_types_id
INNER JOIN project_properties ON project_properties.id = unit_type_detail.properties_id
LEFT JOIN addresses ON addresses.id = project_properties.addresses_id
LEFT JOIN countries ON countries.id = addresses.countries_id
LEFT JOIN states ON states.id = addresses.states_id
LEFT JOIN cities ON cities.id = addresses.cities_id
LEFT JOIN communities ON communities.id = addresses.communities_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
WHERE 

 (
      @search = '%%'
      OR unit_type_detail.ref_no ILIKE @search
      OR unit_type_detail.title ILIKE @search
      OR property_types."type" ILIKE @search
      OR  project_properties.property_name ILIKE @search             
   )
  AND unit_type_detail.status = $3 AND unit_type_detail.property = 1
ORDER BY unit_type_detail.id 
LIMIT $1 OFFSET $2;

-- name: GetCountAllProjectPropertyUnitTypesByStatus :one
SELECT
	COUNT(*)
FROM unit_type_detail
INNER JOIN property_types ON property_types.id = unit_type_detail.property_types_id
INNER JOIN project_properties ON project_properties.id = unit_type_detail.properties_id
LEFT JOIN addresses ON addresses.id = project_properties.addresses_id
LEFT JOIN countries ON countries.id = addresses.countries_id
LEFT JOIN states ON states.id = addresses.states_id
LEFT JOIN cities ON cities.id = addresses.cities_id
LEFT JOIN communities ON communities.id = addresses.communities_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
WHERE 
 (
      @search = '%%'
      OR unit_type_detail.ref_no ILIKE @search      
      OR unit_type_detail.title ILIKE @search
      OR property_types."type" ILIKE @search
      OR  project_properties.property_name ILIKE @search            
   )
  AND unit_type_detail.status = $1 AND unit_type_detail.property = 1;