
 
-- name: GetAllProjectPropertySharing :many
WITH x AS (
    SELECT  
        external_sharing.project_id as project_id,
        'external' AS source,
        external_sharing.created_at,
        external_sharing.created_by,
        external_sharing.id as external_id,
        property_id,
        phase_id
    FROM
        external_sharing
    INNER JOIN
        users  ON users.id = external_sharing.created_by
    WHERE
         external_sharing.is_project = true 
         AND external_sharing.property_key IS NOT NULL
         AND external_sharing.property_id IS NOT NULL
         AND external_sharing.is_property = true
         AND (external_sharing.is_unit IS false OR external_sharing.is_unit IS NULL)
         ---
         AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by END 
    UNION ALL 
           
  SELECT
         internal_sharing.project_id as project_id,
        'internal' AS source,
        internal_sharing.created_at,
        internal_sharing.created_by,
        0 as external_id,
        property_id,
        phase_id
    FROM
        internal_sharing
    INNER JOIN
        users u ON u.id = internal_sharing.created_by
    Where internal_sharing.is_project = true 
    AND internal_sharing.is_property = true AND internal_sharing.property_key  IS NOT NULL
    AND internal_sharing.property_id  IS NOT NULL
    AND (internal_sharing.is_unit IS false OR internal_sharing.is_unit IS NULL)
    ---
    AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END 
)
SELECT
    x.external_id,
    x.project_id,
    x.created_by,
    MAX(CASE WHEN source = 'internal' THEN 'internal' ELSE '' END)::varchar AS internal,
    MAX(CASE WHEN source = 'external' THEN 'external' ELSE '' END)::varchar AS external,
    CASE WHEN @user_id::bigint = x.created_by THEN true ELSE false END AS unshared_available,
    x.created_at,
    x.property_id,
    x.phase_id
FROM
    x
    LEFT JOIN projects ON project_id = projects.id
	LEFT JOIN phases ON x.phase_id = phases.id
    LEFT JOIN project_properties ON x.property_id =  project_properties.id
     
WHERE 
   ( @search = '%%'
      OR  projects.project_name ILIKE @search
      OR project_properties.ref_no ILIKE @search
      OR project_properties.property_name ILIKE @search
      OR phases.phase_name ILIKE @search
     ) 
GROUP BY
    project_id,
    x.created_by,
    x.external_id,
    x.created_at,
    x.property_id,
    x.phase_id
    ORDER BY created_at DESC
    LIMIT $1 OFFSET $2;



-- name: CountProjectPropertySharing :one
WITH x AS (
    SELECT  
        external_sharing.project_id as project_id,
        'external' AS source,
        external_sharing.created_at,
        external_sharing.created_by,
        external_sharing.id as external_id,
        property_id,
        phase_id
    FROM
        external_sharing
    INNER JOIN
        users ON users.id = external_sharing.created_by
    WHERE
        external_sharing.is_project = true 
        AND external_sharing.property_key IS NOT NULL
        AND external_sharing.property_id IS NOT NULL
        AND external_sharing.is_property = true
        AND (external_sharing.is_unit IS false OR external_sharing.is_unit IS NULL)
        AND CASE WHEN @user_id::bigint = 0 THEN true ELSE @user_id::bigint = created_by END 
    UNION ALL 
           
    SELECT
        internal_sharing.project_id as project_id,
        'internal' AS source,
        internal_sharing.created_at,
        internal_sharing.created_by,
        0 as external_id,
        property_id,
        phase_id
    FROM
        internal_sharing
    INNER JOIN
        users u ON u.id = internal_sharing.created_by
    WHERE
        internal_sharing.is_project = true 
        AND internal_sharing.is_property = true
        AND internal_sharing.property_key IS NOT NULL
        AND internal_sharing.property_id IS NOT NULL
        AND (internal_sharing.is_unit IS false OR internal_sharing.is_unit IS NULL)
        AND CASE WHEN @user_id::bigint = 0 THEN true ELSE @user_id::bigint = created_by END 
)
SELECT
    COUNT(DISTINCT x.property_id) AS total_count
-- FROM
--     x
--     INNER JOIN project_properties pp ON x.property_id = pp.id;
FROM
    x
    LEFT JOIN projects ON project_id = projects.id
	LEFT JOIN phases ON x.phase_id = phases.id
    LEFT JOIN project_properties ON x.property_id =  project_properties.id    
WHERE 
   ( @search = '%%'
      OR  projects.project_name ILIKE @search
      OR project_properties.ref_no ILIKE @search
      OR project_properties.property_name ILIKE @search
      OR phases.phase_name ILIKE @search
     ); 


-- name: GetAllProjectPropertyUnitSharing :many
WITH x AS (
    SELECT  
        external_sharing.project_id as project_id,
        'external' AS source,
        external_sharing.created_at,
        external_sharing.created_by,
        external_sharing.id as external_id,
        external_sharing.unit_id,
        unit_category,
        property_id,
        phase_id,
        sale_unit.title,
        rent_unit.title as rent_title       
    FROM
        external_sharing
    INNER JOIN
        users ON users.id = external_sharing.created_by
    LEFT JOIN units ON external_sharing.unit_id = units.id AND (unit_category ILIKE '%sale%' OR unit_category ILIKE '%rent%')
    LEFT JOIN sale_unit ON units.id = sale_unit.unit_id AND unit_category ILIKE '%sale%' 
    LEFT JOIN rent_unit ON units.id = rent_unit.unit_id AND unit_category ILIKE '%rent%' 
    WHERE
         external_sharing.is_project = true
         AND external_sharing.unit_id IS NOT NULL
         AND external_sharing.is_unit = true
         -- 
      AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint = external_sharing.created_by  END 
    UNION ALL 
           
  SELECT
          internal_sharing.project_id as project_id,
        'internal' AS source,
        internal_sharing.created_at,
        internal_sharing.created_by,
        0 as external_id,
        internal_sharing.unit_id,
        unit_category,
        property_id,
        phase_id,
        sale_unit.title,
        rent_unit.title as rent_title 
    FROM
        internal_sharing
    INNER JOIN
        users u ON u.id = internal_sharing.created_by
     LEFT JOIN units ON internal_sharing.unit_id = units.id AND (unit_category ILIKE '%sale%' OR unit_category ILIKE '%rent%' )
     LEFT JOIN sale_unit ON units.id = sale_unit.unit_id   AND unit_category ILIKE '%sale%'
     LEFT JOIN rent_unit ON units.id = rent_unit.unit_id AND unit_category ILIKE '%rent%'
    Where internal_sharing.is_project = true 
    AND internal_sharing.is_unit = true  
    AND internal_sharing.unit_id IS NOT NULL
    ---
    AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  internal_sharing.created_by  END 
)
SELECT
    x.external_id,
    x.project_id,
    x.created_by,
    MAX(CASE WHEN source = 'internal' THEN 'internal' ELSE '' END)::varchar AS internal,
    MAX(CASE WHEN source = 'external' THEN 'external' ELSE '' END)::varchar AS external,
    CASE WHEN @user_id::bigint = x.created_by THEN true ELSE false END AS unshared_available,
    x.created_at,
    x.unit_id,
    x.unit_category,
    x.property_id,
    x.phase_id,
    MAX(x.title) as title,
    MAX(x.rent_title)as rent_title
FROM
    x
    LEFT JOIN projects ON x.project_id = projects.id
    LEFT JOIN units ON x.unit_id = units.id
    LEFT JOIN project_properties ON x.property_id =  project_properties.id
    LEFT JOIN phases ON x.phase_id = phases.id
WHERE 
   (@search = '%%'
     OR  units.ref_no ILIKE @search
     OR  projects.project_name ILIKE @search
     OR  project_properties.property_name ILIKE @search
     OR  phases.phase_name ILIKE @search
     OR  x.unit_category ILIKE @search
     OR  x.title ILIKE @search
     OR  x.rent_title ILIKE @search
   ) 
GROUP BY
    x.project_id,
    x.created_by,
    x.external_id,
    x.created_at,
    x.unit_id,
    x.unit_category,
    x.property_id,
    x.phase_id,
    x.title,
    x.rent_title
    ORDER BY x.created_at DESC
LIMIT $1 OFFSET $2;
 


    
-- name: CountAllProjectPropertyUnitSharing :one
WITH x AS (
    SELECT  
        external_sharing.project_id as project_id,
        'external' AS source,
        external_sharing.created_at,
        external_sharing.created_by,
        external_sharing.id as external_id,
        external_sharing.unit_id,
        unit_category,
        property_id,
        phase_id,
        sale_unit.title,
        rent_unit.title as rent_title       
    FROM
        external_sharing
    INNER JOIN
        users ON users.id = external_sharing.created_by
    LEFT JOIN units ON external_sharing.unit_id = units.id AND (unit_category ILIKE '%sale%' OR unit_category ILIKE '%rent%')
    LEFT JOIN sale_unit ON units.id = sale_unit.unit_id AND unit_category ILIKE '%sale%' 
    LEFT JOIN rent_unit ON units.id = rent_unit.unit_id AND unit_category ILIKE '%rent%' 
    WHERE
         external_sharing.is_project = true
         AND external_sharing.unit_id IS NOT NULL
         AND external_sharing.is_unit = true
         -- 
      AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint = external_sharing.created_by  END 
    UNION ALL 
           
  SELECT
          internal_sharing.project_id as project_id,
        'internal' AS source,
        internal_sharing.created_at,
        internal_sharing.created_by,
        0 as external_id,
        internal_sharing.unit_id,
        unit_category,
        property_id,
        phase_id,
        sale_unit.title,
        rent_unit.title as rent_title 
    FROM
        internal_sharing
    INNER JOIN
        users u ON u.id = internal_sharing.created_by
     LEFT JOIN units ON internal_sharing.unit_id = units.id AND (unit_category ILIKE '%sale%' OR unit_category ILIKE '%rent%' )
     LEFT JOIN sale_unit ON units.id = sale_unit.unit_id   AND unit_category ILIKE '%sale%'
     LEFT JOIN rent_unit ON units.id = rent_unit.unit_id AND unit_category ILIKE '%rent%'
    Where internal_sharing.is_project = true 
    AND internal_sharing.is_unit = true  
    AND internal_sharing.unit_id IS NOT NULL
    ---
    AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  internal_sharing.created_by  END 
)
SELECT
  COUNT(DISTINCT x.unit_id) AS total_count
    -- x.external_id,
    -- x.project_id,
    -- x.created_by,
    -- MAX(CASE WHEN source = 'internal' THEN 'internal' ELSE '' END)::varchar AS internal,
    -- MAX(CASE WHEN source = 'external' THEN 'external' ELSE '' END)::varchar AS external,
    -- CASE WHEN @user_id::bigint = x.created_by THEN true ELSE false END AS unshared_available,
    -- x.created_at,
    -- x.unit_id,
    -- x.unit_category,
    -- x.property_id,
    -- x.phase_id,
    -- MAX(x.title) as title,
    -- MAX(x.rent_title)as rent_title
FROM
    x
    LEFT JOIN projects ON x.project_id = projects.id
    LEFT JOIN units ON x.unit_id = units.id
    LEFT JOIN project_properties ON x.property_id =  project_properties.id
    LEFT JOIN phases ON x.phase_id = phases.id
WHERE 
   (@search = '%%'
     OR  units.ref_no ILIKE @search
     OR  projects.project_name ILIKE @search
     OR  project_properties.property_name ILIKE @search
     OR  phases.phase_name ILIKE @search
     OR  x.unit_category ILIKE @search
     OR  x.title ILIKE @search
     OR  x.rent_title ILIKE @search
   );
-- WITH x AS (
--     SELECT  
--         external_sharing.project_id as project_id,
--         'external' AS source,
--         external_sharing.created_at,
--         external_sharing.created_by,
--         external_sharing.id as external_id,
--         unit_id
--     FROM
--         external_sharing
--     INNER JOIN
--         users ON users.id = external_sharing.created_by
--     WHERE
--          external_sharing.is_project = true
--          AND external_sharing.unit_id IS NOT NULL
--          AND external_sharing.is_unit = true
--          AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END 
--     UNION ALL 
           
--   SELECT
--         internal_sharing.project_id as project_id,
--         'internal' AS source,
--         internal_sharing.created_at,
--         internal_sharing.created_by,
--         0 as external_id,
--         unit_id
--     FROM
--         internal_sharing
--     INNER JOIN
--         users u ON u.id = internal_sharing.created_by
--     Where internal_sharing.is_project = true 
--     AND internal_sharing.is_unit = true  
--     AND internal_sharing.unit_id  IS NOT NULL
--     AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END 
-- )
-- SELECT
--     COUNT(DISTINCT x.unit_id) AS total_count
-- FROM
--     x
--     INNER JOIN units u ON x.unit_id = u.id;
 

