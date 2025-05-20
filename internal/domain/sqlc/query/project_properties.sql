-- name: CreateProjectProperties :one
INSERT INTO project_properties (
  property_name,
  property_name_arabic,
  description,
  description_arabic,
  status,
  is_verified,
  property_rank,
  amenities_id,
  addresses_id,
  phases_id,
  property_types_id,
  created_at,
  updated_at,
  projects_id,
  is_show_owner_info,
  property,
  live_status,
  countries_id,
  developer_companies_id,
  ref_no,
  users_id,
  owner_users_id,
  is_multiphase,
  property_title,
  notes,
  notes_arabic,
  is_notes_public
)VALUES (
    $1 ,$2, $3, $4,$5,$6,$7,$8,$9,$10, $11, $12, $13, $14,  $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27
) RETURNING *;


-- name: GetProjectProperties :one
SELECT *  FROM property
WHERE id = $1 LIMIT 1;

-- name: GetProperty :one 
SELECT 
   property.*,
    CASE 
        WHEN property.entity_type_id = 1 THEN property.entity_id::bigint  -- Direct project
        WHEN property.entity_type_id = 2 THEN phases.projects_id ::bigint  -- Project via phases
    END AS project_id
FROM property
-- Only join phases if entity_type_id = 2
LEFT JOIN phases ON phases.id = property.entity_id AND property.entity_type_id = 2
WHERE property.id = $1
LIMIT 1;
 

-- name: GetProjectPropertiesByProjectId :one
SELECT * FROM project_properties 
WHERE projects_id = $1 LIMIT 1;

-- name: GetAllProjectProperties :many
SELECT * FROM project_properties
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateProjectProperties :one
UPDATE project_properties
SET   property_name = $2,
  property_name_arabic = $3,
  description = $4,
  description_arabic = $5,
  status = $6,
  is_verified = $7,
  property_rank = $8,
  amenities_id = $9,
  addresses_id = $10,
  phases_id = $11,
  property_types_id = $12,
  created_at = $13,
  updated_at = $14,
  projects_id = $15,
  is_show_owner_info = $16,
  property = $17,
  live_status = $18,
   countries_id = $19,
  developer_companies_id = $20,
  ref_no = $21,
  users_id = $22,
  owner_users_id = $23,
  is_multiphase = $24,
    property_title = $25,
  notes = $26,
  notes_arabic = $27,
  is_notes_public = $28
Where id = $1
RETURNING *;


-- name: DeleteProjectProperties :exec
DELETE FROM project_properties
Where id = $1;


-- name: GetAllProjectPropertiesByProjectId :many
SELECT 
 *
  FROM project_properties 
LEFT JOIN projects ON projects.id = project_properties.projects_id
LEFT JOIN companies ON companies.id = projects.developer_companies_id
LEFT JOIN addresses ON addresses.id = project_properties.addresses_id
LEFT JOIN countries ON countries.id = addresses.countries_id
LEFT JOIN states ON states.id = addresses.states_id
LEFT JOIN cities ON cities.id = addresses.cities_id
LEFT JOIN communities ON communities.id = addresses.communities_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
LEFT JOIN properties_facts ON project_properties.id = properties_facts.properties_id
LEFT JOIN property_types ON properties_facts.id = ANY(property_types.property_type_facts_id)
LEFT JOIN phases ON project_properties.phases_id = phases.id
WHERE 
   ( 
      @search = '%%' OR
      project_properties.property_name ILIKE @search   
      OR     project_properties.ref_no ILIKE @search
      OR  projects.project_name % @search 
      OR phase_name ILIKE @search 
      OR property_types.type ILIKE @search 
   )
AND CASE 
  WHEN
  project_properties.projects_id = @project_id AND project_properties.phases_id IS NULL
  AND project_properties.status!= 5 
  AND project_properties.status != 6 THEN TRUE
  ELSE
  project_properties.projects_id = @project_id AND project_properties.phases_id = @phase_id
  AND 
  project_properties.status!= 5 
  AND project_properties.status != 6 
  END
 
GROUP BY 
 project_properties.created_at,
 project_properties.id,
 projects.id,
 companies.id,
 addresses.id,
 countries.id,
 states.id,
 cities.id,
 communities.id,
 sub_communities.id,
 properties_facts.id,
 property_types.id,
 phases.id
ORDER BY project_properties.created_at DESC 
LIMIT $1 OFFSET $2; 


-- name: GetCountProjectPropertiesByProjectId :one
SELECT 
 COUNT(*)
  FROM project_properties 
LEFT JOIN projects ON projects.id = project_properties.projects_id
LEFT JOIN companies ON companies.id = projects.developer_companies_id
LEFT JOIN addresses ON addresses.id = project_properties.addresses_id
LEFT JOIN countries ON countries.id = addresses.countries_id
LEFT JOIN states ON states.id = addresses.states_id
LEFT JOIN cities ON cities.id = addresses.cities_id
LEFT JOIN communities ON communities.id = addresses.communities_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
LEFT JOIN properties_facts ON project_properties.id = properties_facts.properties_id
LEFT JOIN property_types ON properties_facts.id = ANY(property_types.property_type_facts_id)
LEFT JOIN phases ON project_properties.phases_id = phases.id
WHERE 
   ( 
      @search = '%%' OR
      project_properties.property_name ILIKE @search   
      OR     project_properties.ref_no ILIKE @search
      OR  projects.project_name % @search 
      OR phase_name ILIKE @search 
      OR property_types.type ILIKE @search 
   )
AND CASE 
  WHEN
  project_properties.projects_id = @project_id AND project_properties.phases_id IS NULL
  AND project_properties.status!= 5 
  AND project_properties.status != 6 THEN TRUE
  ELSE
  project_properties.projects_id = @project_id AND project_properties.phases_id = @phase_id
  AND 
  project_properties.status!= 5 
  AND project_properties.status != 6 
  END; 

-- name: UpdateProjectPropertyLiveStatus :one
UPDATE project_properties
SET live_status = $2
WHERE projects_id = $1
RETURNING *;


-- name: UpdateProjectPropertyStatusById :one
UPDATE project_properties 
SET status = $2 
where id = $1
RETURNING *;

-- name: UpdateProjectPropertyByProjectId :one
UPDATE project_properties 
SET status = $2 
where projects_id = $1
RETURNING *;

-- name: UpdateProjectPropertyRankById :one
UPDATE project_properties 
SET property_rank = $2 
where id = $1
RETURNING *;

-- name: UpdateProjectPropertyVerificationById :one
UPDATE project_properties 
SET is_verified = $2 
where id = $1
RETURNING *;

-- name: GetCountProjectPropertyDocumentByProjectPropertyId :one
SELECT count(*) FROM project_properties_documents
WHERE project_properties_id = $1 LIMIT 1;

-- -- name: GetFacilitiesIdByProjectPropertyId :one
-- WITH x AS (
--   SELECT projects.facilities_id AS facilities FROM projects
--   LEFT JOIN project_properties ON project_properties.projects_id = projects.id AND project_properties.is_multiphase = FALSE
--   WHERE project_properties.id = $1
-- UNION ALL
--   SELECT phases.facilities AS facilities FROM phases
--   LEFT JOIN project_properties ON project_properties.phases_id = phases.id AND project_properties.is_multiphase = TRUE
--   WHERE project_properties.id = $1
-- )SELECT * FROM x;

-- name: GetAmenitiesIdByProjectPropertyId :one
SELECT project_properties.amenities_id FROM project_properties WHERE id = $1;


-- name: GetProjectPropertiesByDeveloperCompaniesId :many
select id, property_name, property from project_properties pp where pp.developer_companies_id  = $1;


-- name: GetProjectPropertyByProjectIDAndPropertyId :one
SELECT * FROM project_properties
Where  project_properties.projects_id = $1 AND id = $2 LIMIT 1;


-- name: GetProjectPropertiesByPhaseId :one
select project_properties.* from project_properties 
inner join properties_facts on project_properties.id = properties_facts.properties_id and properties_facts.property = 1 
where project_properties.phases_id = $1 and project_properties.projects_id = $2
order by properties_facts.starting_price asc 
limit 1;


-- name: GetCountCommunityProjectProperty :one

With x As(

 SELECT project_properties.id FROM project_properties 

 INNER JOIN addresses ON project_properties.addresses_id = addresses.id 

 INNER JOIN cities ON addresses.cities_id = cities.id

 INNER JOIN communities ON addresses.communities_id = communities.id

 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id

 -- INNER JOIN property_types ON project_properties.property_types_id = property_types.id

 INNER JOIN properties_facts ON project_properties.id = properties_facts.properties_id and properties_facts.property = 2

 WHERE 

         addresses.communities_id = $1 AND

         ($2::bigint[] is NULL OR project_properties.property_rank = ANY($2::bigint[]))  

         AND ($3::bool is NULL OR is_verified = $3::bool)

         AND (

             project_properties.property_title ILIKE '%' || $4 || '%'  OR 

             project_properties.property_title_arabic ILIKE '%' || $4 || '%'  OR   

--             property_types.type  ILIKE '%' || $4 || '%'  OR

             cities.city ILIKE '%' || $4 || '%' OR

             communities.community ILIKE '%' || $4 || '%' OR

             sub_communities.sub_community ILIKE '%' || $4 || '%'

            ) AND project_properties.status != 5 AND project_properties.status != 6

) SELECT COUNT(id) FROM x;





-- name: GetCountStateProjectProperty :one
With x As(
 SELECT project_properties.id FROM project_properties 
 INNER JOIN addresses ON project_properties.addresses_id = addresses.id 
 INNER JOIN cities ON addresses.cities_id = cities.id
 INNER JOIN communities ON addresses.communities_id = communities.id
 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
-- INNER JOIN property_types ON project_properties.property_types_id = property_types.id
 INNER JOIN properties_facts ON project_properties.id = properties_facts.properties_id and properties_facts.property = 2
 WHERE 
         addresses.cities_id = $1 AND
         ($2::bigint[] is NULL OR project_properties.property_rank = ANY($2::bigint[]))  
         AND ($3::bool is NULL OR is_verified = $3::bool)
         AND (
             project_properties.property_name ILIKE '%' || $4 || '%'  OR 
             project_properties.property_name_arabic ILIKE '%' || $4 || '%'  OR   

--             property_types.type  ILIKE '%' || $4 || '%'  OR

             cities.city ILIKE '%' || $4 || '%' OR

             communities.community ILIKE '%' || $4 || '%' OR

             sub_communities.sub_community ILIKE '%' || $4 || '%'

             ) AND project_properties.status != 5 AND project_properties.status != 6

) SELECT COUNT(id) FROM x;




-- name: GetCountSubCommunityProjectProperty :one

With x As(

 SELECT project_properties.id FROM project_properties 

 INNER JOIN addresses ON project_properties.addresses_id = addresses.id 

 INNER JOIN cities ON addresses.cities_id = cities.id

 INNER JOIN communities ON addresses.communities_id = communities.id

 INNER JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id

-- INNER JOIN property_types ON project_properties.property_types_id = property_types.id

 INNER JOIN properties_facts ON project_properties.id = properties_facts.properties_id and properties_facts.property = 2

 WHERE 

         addresses.sub_communities_id = $1 AND

         ($2::bigint[] is NULL OR project_properties.property_rank = ANY($2::bigint[]))  

         AND ($3::bool is NULL OR is_verified = $3::bool)

         AND (

             project_properties.property_title ILIKE '%' || $4 || '%'  OR 

             project_properties.property_title_arabic ILIKE '%' || $4 || '%'  OR   

--             property_types.type  ILIKE '%' || $4 || '%'  OR

             cities.city ILIKE '%' || $4 || '%' OR

             communities.community ILIKE '%' || $4 || '%' OR

             sub_communities.sub_community ILIKE '%' || $4 || '%'

            ) AND project_properties.status != 5 AND project_properties.status != 6

) SELECT COUNT(id) FROM x;

-- name: UpdateAddressInProjectProperty :execrows
WITH 
adres AS(UPDATE addresses 
SET countries_id = $1,
	states_id = $2,
	cities_id = $3,
	communities_id = $4
WHERE id IN (
SELECT addresses_id FROM project_properties
WHERE
CASE
WHEN project_properties.phases_id IS NULL AND project_properties.projects_id = $5
THEN TRUE
ELSE project_properties.phases_id = $6 AND project_properties.projects_id = $5
END) RETURNING *),
pp AS(UPDATE project_properties SET countries_id = $1 
WHERE
CASE
WHEN project_properties.phases_id IS NULL AND project_properties.projects_id = $5
THEN TRUE
ELSE project_properties.phases_id = $6 AND project_properties.projects_id = $5
END RETURNING *)
SELECT id, 'address_id' AS source FROM adres
UNION ALL
SELECT id,'project_property_id' AS source FROM pp;

-- name: GetSingleProjectPropertyReference :one
SELECT fp.id, fp.ref_no, fp.property_name, fp.property_types_id as "property_types_id", pt.type as "property_type", fp.status,  pf.properties_id, pf.property, pf.is_branch 
FROM project_properties fp
JOIN property_types pt ON pt.id = ANY(fp.property_types_id)
LEFT JOIN properties_facts pf ON pf.properties_id = fp.id WHERE fp.id = $1 AND fp.property = 1 LIMIT 1;

-- name: UpdatePropertiesAddressesBelongToProjectID :exec
UPDATE addresses
SET 
    countries_id = $1,
    states_id = $2,
    cities_id = $3,
    communities_id = $4,
    sub_communities_id = $5
FROM (
    SELECT property.addresses_id
    FROM property
    WHERE entity_id = @project_id::BIGINT AND entity_type_id= @project_entity_type::BIGINT AND is_project_property = TRUE

    UNION ALL

    SELECT property.addresses_id
    FROM phases
    INNER JOIN property ON property.entity_type_id = @phase_entity_type::BIGINT 
                        AND property.entity_id = phases.id
    WHERE phases.projects_id = @project_id::BIGINT
) AS subquery
WHERE addresses.id = subquery.addresses_id;
-- name: GetProjectPropertiesByNameAndProjectPhase :one
SELECT * FROM project_properties 
WHERE
CASE
WHEN property_name ILIKE $1 AND projects_id = $2 AND phases_id IS NULL THEN TRUE
ELSE property_name ILIKE $1 AND projects_id = $2 AND phases_id = $3 END AND (status != 5 AND status != 6);

-- name: GetAllProjectPropertiesByStatus :many
SELECT *
FROM project_properties
LEFT JOIN projects ON projects.id = project_properties.projects_id
LEFT JOIN companies ON companies.id = projects.developer_companies_id
LEFT JOIN addresses ON addresses.id = project_properties.addresses_id
LEFT JOIN countries ON countries.id = addresses.countries_id
LEFT JOIN states ON states.id = addresses.states_id
LEFT JOIN cities ON cities.id = addresses.cities_id
LEFT JOIN communities ON communities.id = addresses.communities_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
LEFT JOIN properties_facts ON project_properties.id = properties_facts.properties_id
LEFT JOIN property_types ON properties_facts.id = ANY(property_types.property_type_facts_id)
LEFT JOIN phases ON project_properties.phases_id = phases.id
WHERE 
( 
      @search = '%%' OR
      project_properties.property_name ILIKE @search   
      OR     project_properties.ref_no ILIKE @search
      OR  projects.project_name % @search 
      OR phase_name ILIKE @search 
      OR property_types.type ILIKE @search 
   )
AND
project_properties.status = @status
ORDER BY project_properties.id 
LIMIT $1 OFFSET $2;

-- name: GetCountAllProjectPropertiesByStatus :one
SELECT COUNT(*)
FROM project_properties
LEFT JOIN projects ON projects.id = project_properties.projects_id
LEFT JOIN companies ON companies.id = projects.developer_companies_id
LEFT JOIN addresses ON addresses.id = project_properties.addresses_id
LEFT JOIN countries ON countries.id = addresses.countries_id
LEFT JOIN states ON states.id = addresses.states_id
LEFT JOIN cities ON cities.id = addresses.cities_id
LEFT JOIN communities ON communities.id = addresses.communities_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
LEFT JOIN properties_facts ON project_properties.id = properties_facts.properties_id
LEFT JOIN property_types ON properties_facts.id = ANY(property_types.property_type_facts_id)
LEFT JOIN phases ON project_properties.phases_id = phases.id
WHERE 
( 
      @search = '%%' OR
      project_properties.property_name ILIKE @search   
      OR     project_properties.ref_no ILIKE @search
      OR  projects.project_name % @search 
      OR phase_name ILIKE @search 
      OR property_types.type ILIKE @search 
   )
AND
project_properties.status = @status;



-- name: GetSimilarPropertiesForProjectProperties :many
SELECT 
	sqlc.embed(p),
	sqlc.embed(c),
	sqlc.embed(co),
	sqlc.embed(s),
	sqlc.embed(com),
	sqlc.embed(scom),
	COALESCE(images.id, 0) AS images_media_id,
    COALESCE(images.file_urls, ARRAY[]::text[]) AS images,
    COALESCE(img360.id, 0) AS img360_media_id,
    COALESCE(img360.file_urls, ARRAY[]::text[]) AS img360,
    COALESCE(video.id, 0) AS video_media_id,
    COALESCE(video.file_urls, ARRAY[]::text[]) AS video,
    COALESCE(panorama.id, 0) AS panorama_media_id,
    COALESCE(panorama.file_urls, ARRAY[]::text[]) AS panorama
FROM project_properties p
JOIN addresses a ON a.id=p.addresses_id
JOIN cities c ON a.cities_id = c.id
JOIN countries co ON a.countries_id = co.id
JOIN states s ON s.id = a.states_id
LEFT JOIN communities com ON com.id = a.communities_id
LEFT JOIN sub_communities scom ON scom.id = a.sub_communities_id
LEFT JOIN project_media images ON images.projects_id=p.id AND images.media_type = 1 AND images.gallery_type = 'Main'
LEFT JOIN project_media img360 ON img360.projects_id=p.id AND img360.media_type = 2 AND img360.gallery_type = 'Main'
LEFT JOIN project_media video ON video.projects_id=p.id AND video.media_type = 3 AND video.gallery_type = 'Main'
LEFT JOIN project_media panorama ON panorama.projects_id=p.id AND panorama.media_type = 4 AND panorama.gallery_type = 'Main'
WHERE p.id != $2
 
AND EXISTS (
 
    SELECT 1
 
    FROM unnest(p.property_types_id) AS pt_id
 
    WHERE pt_id = ANY ($1::bigint[]) AND p.status != 6
 
) LIMIT $3 OFFSET $4;



-- name: GetCountSimilarPropertiesForProjectProperties :one
SELECT COUNT(*) 

FROM project_properties 

WHERE id != $2

AND EXISTS (

    SELECT 1 

    FROM unnest(property_types_id) AS pt_id 

    WHERE pt_id = ANY ($1::bigint[]) AND status != 6

);



-- name: CheckIfUnitBelongToProject :one
SELECT pp.projects_id,
       pp.id AS property_id,
       u.id AS units_id
FROM project_properties pp
JOIN units u ON u.properties_id=pp.id
WHERE pp.projects_id=$1
  AND u.id=$2
  AND pp.status!=6;




-- name: GetGlobalPropertyCompletionStatus :one
SELECT 
    COALESCE((property.facts->> 'completion_status')::BIGINT, 0)
FROM property
WHERE property.id = $1;
 