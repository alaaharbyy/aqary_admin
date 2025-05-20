

 
-- name: CreatePublish :one
INSERT INTO publish_listing (
  entity_type_id,
  entity_id,
  share_id,
  is_internal,
  title,
  description,
  created_at,
  updated_at,
  created_by,
  webportal_id,
  is_enabled
 )VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11
 ) RETURNING *;


-- name: GetPublishByID :one
SELECT * FROM publish_listing Where id = $1 LIMIT 1;


-- name: GetPublishByEntity :one
SELECT * FROM publish_listing Where id = $1 LIMIT 1;



-- name: DeletePublishByID :exec
DELETE FROM publish_listing 
WHERE id = $1;
 

---- name: GetPublishByMe :one
-- SELECT *,
--   CASE
--     WHEN @check_for = 'unit' THEN
--       CASE
--         WHEN is_unit = @is_unit AND unit_id = @unit_id  AND unit_category =  @unit_category  AND webportal_id = @webportal_id
--         THEN 'Unit query executed'
--         ELSE 'No matching condition'
--       END
--     WHEN @check_for = 'property' THEN
--       CASE
--         WHEN  is_property = @is_property AND property_key = @property_key AND property_id = @property_id AND webportal_id = @webportal_id
--          AND (is_unit IS NULL  OR is_unit IS FALSE) THEN 'Property query executed'
--         ELSE 'No matching condition'
--       END
--     WHEN @check_for = 'project_with_phase' THEN
--       CASE
--         WHEN is_project = @is_project AND phase_id = @phase_id AND project_id = @project_id AND webportal_id = @webportal_id
--          AND (is_property IS NULL OR is_property IS false) 
--         AND (is_unit IS NULL OR is_unit IS false)          
--          THEN 'Project with phase query executed'
--         ELSE 'No matching condition'
--       END
--     WHEN @check_for = 'project_without_phase' THEN
--       CASE
--         WHEN is_project = @is_project AND phase_id IS NULL AND project_id = @project_id  AND webportal_id = @webportal_id
--         AND (is_property IS NULL OR is_property IS false) 
--         AND (is_unit IS NULL OR is_unit IS false)          
--         THEN 'Project without phase query executed'
--         ELSE 'No matching condition'
--       END
--     ELSE 'Invalid check_for parameter'
--   END AS query_executed
-- FROM publish_listing
-- WHERE
 
--   CASE
--     WHEN @check_for = 'unit' THEN
--       CASE
--         WHEN is_unit = @is_unit AND unit_id = @unit_id  AND created_by = @user_id AND webportal_id = @webportal_id 
--          AND unit_category =  @unit_category  THEN TRUE
--         ELSE FALSE
--       END
--     WHEN @check_for = 'property' THEN
--       CASE
--         WHEN is_property = @is_property AND property_key = @property_key AND property_id = @property_id  AND webportal_id = @webportal_id
--          AND created_by = @user_id  AND (is_unit IS NULL  OR is_unit IS FALSE) THEN TRUE
--         ELSE FALSE
--       END
--     WHEN @check_for = 'project_with_phase' THEN
--       CASE
--         WHEN is_project = @is_project AND phase_id = @phase_id AND project_id = @project_id  AND created_by = @user_id AND webportal_id = @webportal_id
--          AND (is_property IS NULL OR is_property IS false) 
--         AND (is_unit IS NULL OR is_unit IS false)  
--          THEN TRUE
--         ELSE FALSE
--       END
--     WHEN @check_for = 'project_without_phase' THEN
--       CASE
--         WHEN is_project = @is_project AND phase_id IS NULL AND project_id = @project_id  AND created_by = @user_id AND webportal_id = @webportal_id
--          AND (is_property IS NULL OR is_property IS false) 
--         AND (is_unit IS NULL OR is_unit IS false)          
--          THEN TRUE
--         ELSE FALSE
--       END
--     ELSE FALSE
-- END;


-- name: GetPublishByMe :one
SELECT *
FROM
    publish_listing pl
WHERE
    pl.entity_type_id = @entity_type_id :: BIGINT
    AND pl.entity_id = @entity_id :: BIGINT
    AND pl.created_by = @user_id :: BIGINT
    AND pl.webportal_id = @webportal_id :: BIGINT;
    

-- SELECT *,
--   CASE
--     WHEN @check_for = 'unit' THEN
--       CASE
--         WHEN is_unit = @is_unit AND property_unit_id = @property_unit_id  AND unit_category =  @unit_category 
--         THEN 'Unit query executed'
--         ELSE 'No matching condition'
--       END
--     WHEN @check_for = 'property' THEN
--       CASE
--         WHEN  is_property = @is_property AND property_key = @property_key AND property_unit_id = @property_unit_id 
--          AND (is_unit IS NULL  OR is_unit IS FALSE) THEN 'Property query executed'
--         ELSE 'No matching condition'
--       END
--     WHEN @check_for = 'project_with_phase' THEN
--       CASE
--         WHEN is_project = @is_project AND phase_id = @phase_id AND project_id = @project_id
--          AND (is_property IS NULL OR is_property IS false) 
--         AND (is_unit IS NULL OR is_unit IS false)          
--          THEN 'Project with phase query executed'
--         ELSE 'No matching condition'
--       END
--     WHEN @check_for = 'project_without_phase' THEN
--       CASE
--         WHEN is_project = @is_project AND phase_id IS NULL AND project_id = @project_id 
--         AND (is_property IS NULL OR is_property IS false) 
--         AND (is_unit IS NULL OR is_unit IS false)          
--         THEN 'Project without phase query executed'
--         ELSE 'No matching condition'
--       END
--     ELSE 'Invalid check_for parameter'
--   END AS query_executed
-- FROM publish_listing
-- WHERE
 
--   CASE
--     WHEN @check_for = 'unit' THEN
--       CASE
--         WHEN is_unit = @is_unit AND property_unit_id = @property_unit_id  AND created_by = @user_id 
--          AND unit_category =  @unit_category  THEN TRUE
--         ELSE FALSE
--       END
--     WHEN @check_for = 'property' THEN
--       CASE
--         WHEN is_property = @is_property AND property_key = @property_key AND property_unit_id = @property_unit_id 
--          AND created_by = @user_id  AND (is_unit IS NULL  OR is_unit IS FALSE) THEN TRUE
--         ELSE FALSE
--       END
--     WHEN @check_for = 'project_with_phase' THEN
--       CASE
--         WHEN is_project = @is_project AND phase_id = @phase_id AND project_id = @project_id  AND created_by = @user_id
--          AND (is_property IS NULL OR is_property IS false) 
--         AND (is_unit IS NULL OR is_unit IS false)  
--          THEN TRUE
--         ELSE FALSE
--       END
--     WHEN @check_for = 'project_without_phase' THEN
--       CASE
--         WHEN is_project = @is_project AND phase_id IS NULL AND project_id = @project_id  AND created_by = @user_id
--          AND (is_property IS NULL OR is_property IS false) 
--         AND (is_unit IS NULL OR is_unit IS false)          
--          THEN TRUE
--         ELSE FALSE
--       END
--     ELSE FALSE
-- END;



-- name: IsSharePublishedWithProject :one
SELECT id FROM publish_listing 
WHERE share_id = @share_id AND project_id IS NOT NULL AND phase_id IS NULL 
      AND (is_property IS NULL OR is_property IS FALSE) AND (is_unit IS NULL OR is_unit IS FALSE) AND created_by = @user_id;



-- name: IsSharePublishedWithProjectPhase :one
SELECT id FROM publish_listing 
WHERE share_id = @share_id AND project_id IS NOT NULL AND phase_id IS NOT NULL 
      AND (is_property IS NULL OR is_property IS FALSE) AND (is_unit IS NULL OR is_unit IS FALSE) AND created_by = @user_id;


-- name: IsSharePublishedWithProperty :one
SELECT id FROM publish_listing 
WHERE share_id = @share_id  AND is_property IS NOT NULL   
      AND (is_unit IS NULL OR is_unit IS FALSE) AND created_by = @user_id;


-- name: IsSharePublishedWithUnit :one
SELECT id FROM publish_listing 
WHERE share_id = @share_id  AND is_unit IS NOT NULL AND created_by = @user_id;



-- name: CreatePublishGallery :one
INSERT INTO publish_gallery (
 publish_listing_id,
 image_url,  
 image360_url,  
 video_url,  
 panaroma_url, 
 main_media_section,
 created_at
) VALUES (
  $1, $2, $3, $4, $5, $6, $7
) RETURNING *;

-- name: GetPublishMediaByPublishListingIdAndMediaSection :one
SELECT * FROM publish_gallery
WHERE publish_listing_id = $1 AND main_media_section = $2;



-- name: CreatePublishPlan :one
INSERT INTO publish_plan (
 publish_listing_id,
 title,
 plan_url,
 created_at
) VALUES (
  $1, $2, $3, $4
) RETURNING *;




-- name: GetPublishGalleryByID :one
SELECT * FROM publish_gallery WHERE id = $1 LIMIT 1;


-- name: DeletePublishGalleryByID :exec
DELETE FROM publish_gallery WHERE id = $1;



-- name: UpdatePublishMedia :one
UPDATE publish_gallery
SET    image_url = $2,
     image360_url = $3,
     video_url = $4,
     panaroma_url = $5,
     main_media_section = $6,
    updated_at = $7
Where id = $1
RETURNING *;



--! -------------------------  FROM HERE PROJECT PUBLISH QUERIES --------------------------------------------- !--
 
-- -- name: GetProjectPublishByMe :many
-- SELECT DISTINCT ON (publish_listing.project_id) 
-- publish_listing.project_id,  *
-- FROM publish_listing
--  --  all inner joins
--     LEFT JOIN projects p ON publish_listing.project_id = p.id
--     LEFT JOIN addresses ON p.addresses_id = addresses.id 
--     LEFT JOIN countries ON addresses.countries_id = countries.id  
--     LEFT JOIN states ON addresses.states_id = states.id   
--     LEFT JOIN cities ON addresses.cities_id = cities.id    
--     LEFT JOIN companies ON p.developer_companies_id = companies.id    
--     LEFT JOIN properties_facts ON p.id = properties_facts.project_id AND properties_facts.is_project_fact = true 
    
-- WHERE 
--   -- Search criteria
--     (@search = '%%' OR 
--      p.project_name % @search OR 
--      p.ref_number % @search OR
--      countries.country % @search OR 
--      states."state" % @search OR 
--      cities.city % @search OR 
--      companies.company_name % @search  
--       OR (CASE 
--         WHEN 'ready' ILIKE @search THEN properties_facts.completion_status = 5
--         WHEN 'off plan' ILIKE @search  THEN properties_facts.completion_status = 4
--         WHEN '^[0-9]+$' ~ @search  THEN properties_facts.completion_percentage::TEXT % @search
--         WHEN 'draft' ILIKE @search  THEN p.status = 1
--         WHEN 'available' ILIKE @search  THEN p.status = 2
--         WHEN 'block' ILIKE @search  THEN p.status = 5
--         WHEN 'single' ILIKE @search  THEN p.is_multiphase = false
--         WHEN 'multiple' ILIKE @search  THEN p.is_multiphase = true 
--         ELSE FALSE
--       END )
--       ) AND
--      is_project IS TRUE AND phase_id IS NULL 
--      AND (is_property IS NULL OR is_property IS FALSE)
--      AND (is_unit IS NULL OR is_unit IS FALSE) AND publish_listing.created_by =  @user_id 
-- ORDER BY publish_listing.project_id, publish_listing.updated_at DESC  LIMIT $1 OFFSET $2;
 

-- -- name: CountProjectPublishByMe :one
-- SELECT COUNT(DISTINCT publish_listing.project_id)
-- FROM publish_listing
--  --  all inner joins
--     LEFT JOIN projects p ON publish_listing.project_id = p.id
--     LEFT JOIN addresses ON p.addresses_id = addresses.id 
--     LEFT JOIN countries ON addresses.countries_id = countries.id  
--     LEFT JOIN states ON addresses.states_id = states.id   
--     LEFT JOIN cities ON addresses.cities_id = cities.id    
--     LEFT JOIN companies ON p.developer_companies_id = companies.id    
--     LEFT JOIN properties_facts ON p.id = properties_facts.project_id AND properties_facts.is_project_fact = true     
-- WHERE 
--   -- Search criteria
--     (@search = '%%' OR 
--      p.project_name % @search OR 
--      p.ref_number % @search OR
--      countries.country % @search OR 
--      states."state" % @search OR 
--      cities.city % @search OR 
--      companies.company_name % @search  
--       OR (CASE 
--         WHEN 'ready' ILIKE @search THEN properties_facts.completion_status = 5
--         WHEN 'off plan' ILIKE @search  THEN properties_facts.completion_status = 4
--         WHEN '^[0-9]+$' ~ @search  THEN properties_facts.completion_percentage::TEXT % @search
--         WHEN 'draft' ILIKE @search  THEN p.status = 1
--         WHEN 'available' ILIKE @search  THEN p.status = 2
--         WHEN 'block' ILIKE @search  THEN p.status = 5
--         WHEN 'single' ILIKE @search  THEN p.is_multiphase = false
--         WHEN 'multiple' ILIKE @search  THEN p.is_multiphase = true 
--         ELSE FALSE
--       END )
--       ) AND
--      is_project IS TRUE AND phase_id IS NULL 
--      AND (is_property IS NULL OR is_property IS FALSE)
--      AND (is_unit IS NULL OR is_unit IS FALSE) AND publish_listing.created_by =  @user_id;


-- -- name: GetAProjectPublishByMe :one
-- SELECT DISTINCT ON (publish_listing.project_id) publish_listing.project_id,  *
-- FROM publish_listing
--  --  all inner joins
--     LEFT JOIN projects p ON publish_listing.project_id = p.id 
-- WHERE 
--      publish_listing.project_id =  @project_id
--      AND is_project IS TRUE AND phase_id IS NULL 
--      AND (is_property IS NULL OR is_property IS FALSE)
--      AND (is_unit IS NULL OR is_unit IS FALSE) AND publish_listing.created_by =  @user_id;

-- --! ------------  FROM HERE PROJECT PHASES PUBLISH  QUERIES --------------------------------------------- !--
-- -- name: GetProjectPhasesPublishByMe :many
-- SELECT DISTINCT ON (publish_listing.phase_id) publish_listing.phase_id, *
-- FROM publish_listing
--   LEFT JOIN projects p ON publish_listing.project_id = p.id
--   LEFT JOIN phases ON p.id = phases.projects_id
--   LEFT JOIN phases_facts ON phases.id = phases_facts.phases_id
--   LEFT JOIN companies ON p.developer_companies_id = companies.id 
-- WHERE

--  (@search = '%%'
--      OR phases.ref_no ILIKE @search
--       OR p.project_name ILIKE @search
--       OR companies.company_name ILIKE @search
--       OR phases.phase_name ILIKE @search
--        OR (CASE 
--         WHEN 'ready' ILIKE @search THEN phases_facts.completion_status = 5
--         WHEN 'off plan'ILIKE @search  THEN phases_facts.completion_status = 4
--         WHEN '^[0-9]+$' ~ @search  THEN phases_facts.completion_percentage::TEXT % @search
--         ELSE FALSE
--       END)
--      ) AND
--    is_project IS TRUE AND phase_id IS NOT NULL 
--      AND (is_property IS NULL OR is_property IS FALSE)
--      AND (is_unit IS NULL OR is_unit IS FALSE) AND publish_listing.created_by =  @user_id
-- ORDER BY publish_listing.phase_id,  publish_listing.updated_at DESC  LIMIT $1 OFFSET $2;
 

-- -- name: CountProjectPhasesPublishByMe :one
-- SELECT COUNT(DISTINCT publish_listing.phase_id)
-- FROM publish_listing
--   LEFT JOIN projects p ON publish_listing.project_id = p.id
--   LEFT JOIN phases ON p.id = phases.projects_id
--   LEFT JOIN phases_facts ON phases.id = phases_facts.phases_id
--   LEFT JOIN companies ON p.developer_companies_id = companies.id 
-- WHERE
--  (@search = '%%'
--      OR phases.ref_no ILIKE @search
--       OR p.project_name ILIKE @search
--       OR companies.company_name ILIKE @search
--       OR phases.phase_name ILIKE @search
--        OR (CASE 
--         WHEN 'ready' ILIKE @search THEN phases_facts.completion_status = 5
--         WHEN 'off plan'ILIKE @search  THEN phases_facts.completion_status = 4
--         WHEN '^[0-9]+$' ~ @search  THEN phases_facts.completion_percentage::TEXT % @search
--         ELSE FALSE
--       END)
--      ) AND
--    is_project IS TRUE AND phase_id IS NOT NULL 
--      AND (is_property IS NULL OR is_property IS FALSE)
-- AND (is_unit IS NULL OR is_unit IS FALSE) AND publish_listing.created_by =  @user_id;



-- -- name: GetAProjectPhasesPublishByMe :one
-- SELECT DISTINCT ON (publish_listing.phase_id) publish_listing.phase_id, *
-- FROM publish_listing
--   LEFT JOIN projects p ON publish_listing.project_id = p.id
--   LEFT JOIN phases ON p.id = phases.projects_id
-- WHERE
--    publish_listing.phase_id = @phase_id 
--   AND  is_project IS TRUE AND phase_id IS NOT NULL 
--      AND (is_property IS NULL OR is_property IS FALSE)
-- AND (is_unit IS NULL OR is_unit IS FALSE) AND publish_listing.created_by =  @user_id;
 
-- --! ------------  FROM HERE PROJECT PROPERTY PUBLISH  QUERIES --------------------------------------------- !--
-- -- name: GetProjectPropertyPublishByMe :many
-- SELECT DISTINCT ON (publish_listing.property_id) publish_listing.property_id, *
-- FROM publish_listing
--     LEFT JOIN projects ON publish_listing.project_id = projects.id
-- 	LEFT JOIN phases ON publish_listing.phase_id = phases.id
--     LEFT JOIN project_properties ON publish_listing.property_id =  project_properties.id
-- WHERE 
--      ( @search = '%%'
--       OR projects.project_name ILIKE @search
--       OR project_properties.ref_no ILIKE @search
--       OR project_properties.property_name ILIKE @search
--       OR phases.phase_name ILIKE @search
--      ) AND
--      is_property IS TRUE AND property_id IS NOT NULL AND property_key IS NOT NULL
--      AND (is_unit IS NULL OR is_unit IS FALSE) AND publish_listing.created_by =  @user_id
-- ORDER BY publish_listing.property_id, publish_listing.updated_at DESC  LIMIT $1 OFFSET $2;


-- -- name: CountProjectPropertyPublishByMe :one
-- SELECT COUNT(DISTINCT publish_listing.property_id)
-- FROM publish_listing
--     LEFT JOIN projects ON publish_listing.project_id = projects.id
-- 	LEFT JOIN phases ON publish_listing.phase_id = phases.id
--     LEFT JOIN project_properties ON publish_listing.property_id =  project_properties.id
-- WHERE 
    
--      ( @search = '%%'
--       OR projects.project_name ILIKE @search
--       OR project_properties.ref_no ILIKE @search
--       OR project_properties.property_name ILIKE @search
--       OR phases.phase_name ILIKE @search
--      ) AND
--   is_property IS TRUE AND property_id IS NOT NULL AND property_key IS NOT NULL
-- AND (is_unit IS NULL OR is_unit IS FALSE) AND publish_listing.created_by =  @user_id;



-- -- name: GetAProjectPropertyPublishByMe :one
-- SELECT DISTINCT ON (publish_listing.property_id) publish_listing.property_id, *
-- FROM publish_listing
--      LEFT JOIN project_properties ON publish_listing.property_id =  project_properties.id
-- WHERE 
--        publish_listing.property_id =  @project_property_id
--        AND
--      is_property IS TRUE AND property_id IS NOT NULL AND property_key IS NOT NULL
-- AND (is_unit IS NULL OR is_unit IS FALSE) AND publish_listing.created_by =  @user_id;


-- --! ------------  FROM HERE PROJECT PROPERTY UNIT PUBLISH  QUERIES --------------------------------------------- !--
-- -- name: GetProjectPropertyUnitPublishByMe :many
-- SELECT DISTINCT ON (publish_listing.unit_id) publish_listing.unit_id, *
-- FROM publish_listing
--   LEFT JOIN projects ON publish_listing.project_id = projects.id
--   LEFT JOIN project_properties ON publish_listing.property_id =  project_properties.id
--   LEFT JOIN phases ON publish_listing.phase_id = phases.id
--   LEFT JOIN units ON publish_listing.unit_id = units.id AND (unit_category ILIKE '%sale%' OR unit_category ILIKE '%rent%')
--   LEFT JOIN sale_unit ON units.id = sale_unit.unit_id AND unit_category ILIKE '%sale%' 
--   LEFT JOIN rent_unit ON units.id = rent_unit.unit_id AND unit_category ILIKE '%rent%'
-- WHERE 
--   (@search = '%%'
--      OR  units.ref_no ILIKE @search
--      OR  projects.project_name ILIKE @search
--      OR  project_properties.property_name ILIKE @search
--      OR  phases.phase_name ILIKE @search
--      OR  publish_listing.unit_category ILIKE @search
--      OR  sale_unit.title ILIKE @search
--      OR  rent_unit.title ILIKE @search
--    ) AND
--    publish_listing.is_unit IS TRUE 
--     AND publish_listing.unit_id IS NOT NULL    
--     AND publish_listing.created_by =  @user_id
-- ORDER BY publish_listing.unit_id, publish_listing.updated_at DESC LIMIT $1 OFFSET $2;

-- -- name: CountProjectPropertyUnitPublishByMe :one
-- SELECT COUNT(DISTINCT publish_listing.unit_id)
-- FROM publish_listing
--   LEFT JOIN projects ON publish_listing.project_id = projects.id
--   LEFT JOIN project_properties ON publish_listing.property_id =  project_properties.id
--   LEFT JOIN phases ON publish_listing.phase_id = phases.id
--   LEFT JOIN units ON publish_listing.unit_id = units.id AND (unit_category ILIKE '%sale%' OR unit_category ILIKE '%rent%')
--   LEFT JOIN sale_unit ON units.id = sale_unit.unit_id AND unit_category ILIKE '%sale%' 
--   LEFT JOIN rent_unit ON units.id = rent_unit.unit_id AND unit_category ILIKE '%rent%'
-- WHERE 
--   (@search = '%%'
--      OR  units.ref_no ILIKE @search
--      OR  projects.project_name ILIKE @search
--      OR  project_properties.property_name ILIKE @search
--      OR  phases.phase_name ILIKE @search
--      OR  publish_listing.unit_category ILIKE @search
--      OR  sale_unit.title ILIKE @search
--      OR  rent_unit.title ILIKE @search
--    ) AND
--    publish_listing.is_unit IS TRUE 
--     AND publish_listing.unit_id IS NOT NULL    
-- AND publish_listing.created_by =  @user_id;





-- -- name: GetAProjectPropertyUnitPublishByMe :one
-- SELECT DISTINCT ON (publish_listing.unit_id) publish_listing.unit_id, *
-- FROM publish_listing
--   LEFT JOIN units ON publish_listing.unit_id = units.id AND (unit_category ILIKE '%sale%' OR unit_category ILIKE '%rent%')
--   LEFT JOIN sale_unit ON units.id = sale_unit.unit_id AND unit_category ILIKE '%sale%' 
--   LEFT JOIN rent_unit ON units.id = rent_unit.unit_id AND unit_category ILIKE '%rent%'
-- WHERE 
--    publish_listing.unit_id = @unit_id   
--    AND
--    publish_listing.is_unit IS TRUE 
--     AND publish_listing.unit_id IS NOT NULL    
-- AND publish_listing.created_by =  @user_id;

-- --  ! --------------------------------------------------------------------------------------------------
-- -- name: GetPublishedPortals :many
-- SELECT
-- 	w.*,
-- 	pl.id as publish_id,
-- 	CASE WHEN pl.webportal_id IS NULL THEN
-- 		FALSE
-- 	ELSE
-- 		pl.is_enabled::bool
-- 	END AS is_enabled,
-- 	CASE WHEN @check_for = 'unit' THEN
-- 		CASE WHEN pl.is_unit = @is_unit
-- 			AND pl.unit_id = @unit_id
-- 			AND pl.unit_category = @unit_category THEN
-- 			'Unit query executed'
-- 		ELSE
-- 			'No matching condition'
-- 		END
-- 	WHEN @check_for = 'property' THEN
-- 		CASE WHEN pl.is_property = @is_property
-- 			AND pl.property_key = @property_key
-- 			AND pl.property_id = @property_id
-- 			AND(pl.is_unit IS NULL
-- 				OR pl.is_unit IS FALSE) THEN
-- 			'Property query executed'
-- 		ELSE
-- 			'No matching condition'
-- 		END
-- 	WHEN @check_for = 'project_with_phase' THEN
-- 		CASE WHEN pl.is_project = @is_project
-- 			AND pl.phase_id = @phase_id
-- 			AND pl.project_id = @project_id
-- 			AND(pl.is_property IS NULL
-- 				OR pl.is_property IS FALSE)
-- 			AND(pl.is_unit IS NULL
-- 				OR pl.is_unit IS FALSE) THEN
-- 			'Project with phase query executed'
-- 		ELSE
-- 			'No matching condition'
-- 		END
-- 	WHEN @check_for = 'project_without_phase' THEN
-- 		CASE WHEN pl.is_project = @is_project
-- 			AND pl.phase_id IS NULL
-- 			AND pl.project_id = @project_id
-- 			AND(pl.is_property IS NULL
-- 				OR pl.is_property IS FALSE)
-- 			AND(pl.is_unit IS NULL
-- 				OR pl.is_unit IS FALSE) THEN
-- 			'Project without phase query executed'
-- 		ELSE
-- 			'No matching condition'
-- 		END
-- 	ELSE
-- 		'Invalid check_for parameter'
-- 	END AS query_executed
-- FROM
-- 	webportals w
-- 	INNER JOIN publish_listing pl ON w.id = pl.webportal_id
-- 		AND((@check_for = 'unit'
-- 			AND pl.is_unit = @is_unit
-- 			AND pl.unit_id = @unit_id
-- 			AND pl.unit_category = @unit_category)
-- 		OR(@check_for = 'property'
-- 			AND pl.is_property = @is_property
-- 			AND pl.property_key = @property_key
-- 			AND pl.property_id = @property_id
-- 			AND(pl.is_unit IS NULL
-- 				OR pl.is_unit IS FALSE))
-- 		OR(@check_for = 'project_with_phase'
-- 			AND pl.is_project = @is_project
-- 			AND pl.phase_id = @phase_id
-- 			AND pl.project_id = @project_id
-- 			AND(pl.is_property IS NULL
-- 				OR pl.is_property IS FALSE)
-- 			AND(pl.is_unit IS NULL
-- 				OR pl.is_unit IS FALSE))
-- 		OR(@check_for = 'project_without_phase'
-- 			AND pl.is_project = @is_project
-- 			AND pl.phase_id IS NULL
-- 			AND pl.project_id = @project_id
-- 			AND(pl.is_property IS NULL
-- 				OR pl.is_property IS FALSE)
-- 			AND(pl.is_unit IS NULL
-- 				OR pl.is_unit IS FALSE)))
-- WHERE
-- 	w.created_by = @user_id;




-- name: UpdatePublishListingForEnables :many
Update publish_listing
SET  is_enabled = @is_enabled
Where id = ANY($1::bigint[])
RETURNING *;


-- name: GetPublishPlanByPublishID :many
SELECT * FROM publish_plan
WHERE publish_listing_id = $1;

-- name: GetPublishGalleryByPublishID :many
SELECT * FROM publish_gallery
WHERE publish_listing_id = $1;








-- name: GetProjectsPublishedListing :many
with phaseCount as (
	SELECT projects.id as project_id , COALESCE(count(phases.id),0) as phases_count from projects
	LEFT JOIN phases on phases.projects_id=projects.id AND projects.is_multiphase=TRUE
	group by projects.id
)
SELECT 
	sqlc.embed(projects),
  pl.id::bigint as publish_id,
  pc.phases_count::bigint,
	comp.company_name
FROM publish_listing  AS pl
JOIN projects ON 
pl.entity_type_id= @entity_type_id::BIGINT AND 
projects.id = pl.entity_id::BIGINT
left JOIN companies comp ON comp.id= projects.developer_companies_id 
JOIN phaseCount pc ON pc.project_id= projects.id
WHERE
	projects.status!=6
AND
	(@search = '%%'
      OR comp.company_name ILIKE @search
      OR projects.project_name ILIKE @search
     )
AND 
	pl.created_by= @published_by::BIGINT
LIMIT $1
OFFSET $2;
 
 
-- name: GetProjectsPublishedCount :one
SELECT 
	COUNT(pl)
FROM publish_listing  AS pl
JOIN projects ON 
pl.entity_type_id= @entity_type_id::BIGINT AND 
projects.id = pl.entity_id::BIGINT
WHERE
	projects.status!=6
AND 
	pl.created_by= @published_by::BIGINT;



-- name: GetProjectPropertiesPublishedListing :many
SELECT 
	pl.id as publish_id,
	property_versions.id as property_id,
	property_versions.title as property_title,
	projects.id as phase_id, 
	projects.ref_number as project_ref_no,
	projects.project_name as project_name,
  coalesce(phases.id,0) as phase_id,
	coalesce(phases.phase_name,'Single Phase') as phase_name

FROM publish_listing  AS pl
JOIN property_versions ON pl.entity_type_id::BIGINT= @propertyv_entity_type AND property_versions.id = pl.entity_id::BIGINT
JOIN property ON property.id = property_versions.property_id
left JOIN phases ON property.entity_id=phases.id AND property.entity_type_id= @phases_entity_type  
JOIN projects ON (property.entity_id=projects.id AND property.entity_type_id= @project_entity_type AND projects.is_multiphase=FALSE) OR (projects.id=phases.projects_id and projects.is_multiphase=true)
WHERE
	property_versions.status!=6 AND property.status!=6 AND projects.status!=6 AND phases.status!=6
AND 
	pl.created_by= @published_by::BIGINT
AND
	(@search = '%%'
      OR property.property_name ILIKE @search
      OR phases.phase_name ILIKE @search
      OR projects.project_name ILIKE @search
     )
LIMIT $1
OFFSET $2;


-- name: GetProjectPropertiesPublishedCount :one
SELECT 
	count(pl)
FROM publish_listing  AS pl
JOIN property_versions ON pl.entity_type_id::BIGINT= @propertyv_entity_type AND property_versions.id = pl.entity_id::BIGINT
JOIN property ON property.id = property_versions.property_id
left JOIN phases ON property.entity_id=phases.id AND property.entity_type_id= @phases_entity_type  
JOIN projects ON (property.entity_id=projects.id AND property.entity_type_id= @project_entity_type AND projects.is_multiphase=FALSE) OR (projects.id=phases.projects_id and projects.is_multiphase=true)
WHERE
	property_versions.status!=6 AND property.status!=6 AND projects.status!=6 AND phases.status!=6
AND 
	pl.created_by= @published_by::BIGINT;

-- name: GetProjectPhasesPublishedListing :many
SELECT 
  phases.id as phase_id,
	phases.phase_name,
	phases.ref_no,
	pl.id as publish_listing_id,
	projects.project_name,
	comp.company_name
FROM publish_listing AS pl 
JOIN 
phases ON 
pl.entity_type_id= @entity_type_id::BIGINT AND 
phases.id = pl.entity_id::BIGINT
JOIN projects ON phases.projects_id = projects.id
LEFT JOIN companies comp ON comp.id=projects.developer_companies_id 
WHERE
	phases.status!=6
AND 
	(@search = '%%'
      OR phases.ref_no ILIKE @search
      OR phases.phase_name ILIKE @search
      OR projects.project_name ILIKE @search
      OR comp.company_name ILIKE @search
     )
AND 
	pl.created_by= @published_by::BIGINT
LIMIT $1
OFFSET $2;
 
-- name: GetProjectPhasesPublishedCount :one
SELECT 
	COUNT(pl)
FROM publish_listing AS pl
JOIN 
phases ON 
pl.entity_type_id= @entity_type_id::BIGINT AND 
phases.id = pl.entity_id::BIGINT
WHERE
	phases.status!=6
AND 
	pl.created_by= @published_by::BIGINT;
 
-- name: GetProjectUnitsPublishedListing :many
SELECT 
	pl.id as publish_id,
	uv.id as unit_id,
	uv.title as unit_title,
	uv.type as category,
  projects.id as project_id,
  property.id as property_id,
	property.property_name as property_name,
	projects.ref_number as project_ref_no,
	projects.project_name as project_name,
  coalesce(phases.id,0) as phase_id,
	COALESCE(phases.phase_name,'Single Phase') as phase_name
	
FROM publish_listing  AS pl
JOIN unit_versions as uv ON pl.entity_type_id::BIGINT= @unitv_entity_type_id AND uv.id = pl.entity_id::BIGINT 
JOIN units ON units.id=uv.unit_id AND units.is_project_unit=TRUE 
JOIN property ON property.id = units.entity_id::BIGINT 
left JOIN phases ON property.entity_id=phases.id AND property.entity_type_id= @property_entity_type_id  
JOIN projects ON (property.entity_id=projects.id AND property.entity_type_id= @project_entity_type_id AND projects.is_multiphase=FALSE) OR (projects.id=phases.projects_id and projects.is_multiphase=true)
WHERE
	property.status!=6 AND projects.status!=6 AND units.status!=6 
AND 
	pl.created_by= @published_by::BIGINT
AND
	(@search = '%%'
	  OR units.unit_title ILIKE @search
      OR property.property_name ILIKE @search
      OR phases.phase_name ILIKE @search
      OR projects.project_name ILIKE @search
     )
LIMIT $1
OFFSET $2;

 
-- name: GetProjectUnitsPublishedCount :one
SELECT 
	count(pl)
FROM publish_listing  AS pl
JOIN unit_versions as uv ON pl.entity_type_id::BIGINT= @unitv_entity_type_id AND uv.id = pl.entity_id::BIGINT 
JOIN units ON units.id=uv.unit_id AND units.is_project_unit=TRUE 
JOIN property ON property.id = units.entity_id::BIGINT 
left JOIN phases ON property.entity_id=phases.id AND property.entity_type_id= @property_entity_type_id  
JOIN projects ON (property.entity_id=projects.id AND property.entity_type_id= @project_entity_type_id AND projects.is_multiphase=FALSE) OR (projects.id=phases.projects_id and projects.is_multiphase=true)
WHERE
	property.status!=6 AND projects.status!=6 AND units.status!=6 
AND 
	pl.created_by= @published_by::BIGINT;

-- name: GetStatusOfEntity :one
SELECT COALESCE(CASE @entity_type::BIGINT 
		       WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = @entity_id::BIGINT)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = @entity_id::BIGINT)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = @entity_id::BIGINT)
               WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = @entity_id::BIGINT)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = @entity_id::BIGINT)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = @entity_id::BIGINT)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = @entity_id::BIGINT)
               WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = @entity_id::BIGINT)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = @entity_id::BIGINT)
               WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = @entity_id::BIGINT)
               WHEN 11 THEN (SELECT 1 FROM services WHERE services.id = @entity_id::BIGINT)
               WHEN 14 THEN (SELECT unit_versions.status::BIGINT FROM unit_versions WHERE unit_versions.id= @entity_id::BIGINT)
               WHEN 15 THEN (SELECT property_versions.status::BIGINT FROM property_versions WHERE property_versions.id = @entity_id::BIGINT)
               WHEN 16 THEN (SELECT 1 FROM publish_listing WHERE publish_listing.id = @entity_id::BIGINT)
               ELSE 0::BIGINT
           END,6::BIGINT)::BIGINT;