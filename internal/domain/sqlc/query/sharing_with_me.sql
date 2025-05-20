 
 
-- name: GetAllProjectSharingWithMe :many
WITH x AS (
    SELECT
        external_sharing.id as share_id,
        external_sharing.external_company_id as company_ids,
        external_sharing.project_id AS project_id,
        'external' AS source,
        external_sharing.created_at,
        external_sharing.created_by,
        external_sharing.external_is_enabled AS is_enabled,
        external_sharing.id AS external_id
    FROM
        external_sharing
        INNER JOIN users ON users.id = external_sharing.created_by
    WHERE
        external_sharing.is_project = TRUE
        AND external_sharing.phase_id IS NULL
        AND (external_sharing.is_property IS NULL OR external_sharing.is_property IS FALSE)
        AND (external_sharing.is_unit IS NULL OR external_sharing.is_unit IS FALSE)
        AND CASE WHEN @company_id::bigint = 0 THEN TRUE ELSE @company_id::bigint = ANY (external_company_id) END
        AND CASE WHEN @is_branch_id::bigint = 0 THEN TRUE ELSE @is_branch::bool = ANY (external_is_branch) END
        AND CASE WHEN @company_type::bigint = 0 THEN TRUE ELSE @company_type::bigint = ANY(external_company_type) END
--         AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END
    UNION ALL
    SELECT
        internal_sharing.id as share_id,
        internal_sharing.shared_to as company_ids,
        internal_sharing.project_id AS project_id,
        'internal' AS source,
        internal_sharing.created_at,
        internal_sharing.created_by,
        internal_sharing.is_enabled AS is_enabled,
        0 AS external_id
    FROM
        internal_sharing
        INNER JOIN users u ON u.id = internal_sharing.created_by
    WHERE
        internal_sharing.is_project = TRUE
        AND internal_sharing.phase_id IS NULL
        AND (internal_sharing.is_property IS NULL OR internal_sharing.is_property IS FALSE)
        AND (internal_sharing.is_unit IS NULL OR internal_sharing.is_unit IS FALSE)
        AND CASE WHEN @user_id::bigint = 0 THEN TRUE ELSE @user_id::bigint = ANY (shared_to) END
--         AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END
)
SELECT
    x.share_id,
    x.company_ids,
    x.external_id,
    x.project_id,
    x.created_by,
    MAX(CASE WHEN x.source = 'internal' THEN 'internal' ELSE '' END)::varchar AS internal,
    MAX(CASE WHEN x.source = 'external' THEN 'external' ELSE '' END)::varchar AS external,
    CASE WHEN @user_id::bigint = x.created_by THEN TRUE ELSE FALSE END AS unshared_available,
    x.created_at,
    x.is_enabled
FROM
    x
    LEFT JOIN projects p ON x.project_id = p.id
    LEFT JOIN addresses ON p.addresses_id = addresses.id 
    LEFT JOIN countries ON addresses.countries_id = countries.id  
    LEFT JOIN states ON addresses.states_id = states.id   
    LEFT JOIN cities ON addresses.cities_id = cities.id    
    LEFT JOIN companies ON p.developer_companies_id = companies.id    
    LEFT JOIN properties_facts ON p.id = properties_facts.project_id AND properties_facts.is_project_fact = true  
WHERE
 -- Search criteria
    (@search = '%%' OR 
     p.project_name % @search OR 
     p.ref_number % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     companies.company_name % @search  
      OR (CASE 
        WHEN 'ready' ILIKE @search THEN properties_facts.completion_status = 5
        WHEN 'off plan' ILIKE @search  THEN properties_facts.completion_status = 4
        WHEN '^[0-9]+$' ~ @search  THEN properties_facts.completion_percentage::TEXT % @search
        WHEN 'draft' ILIKE @search  THEN p.status = 1
        WHEN 'available' ILIKE @search  THEN p.status = 2
        WHEN 'block' ILIKE @search  THEN p.status = 5
        WHEN 'single' ILIKE @search  THEN p.is_multiphase = false
        WHEN 'multiple' ILIKE @search  THEN p.is_multiphase = true 
        ELSE FALSE
      END)
      )
AND 
    p.status NOT IN (5, 6)
GROUP BY
    x.share_id,
    x.company_ids,
    x.project_id,
    x.created_by,
    x.external_id,
    x.created_at,
    x.is_enabled
ORDER BY
    x.created_at DESC
LIMIT $1 OFFSET $2;
  



 
-- name: CountAllProjectSharingWithMe :one
WITH x AS (
    SELECT
        external_sharing.id as share_id,
        external_sharing.external_company_id as company_ids,
        external_sharing.project_id AS project_id,
        'external' AS source,
        external_sharing.created_at,
        external_sharing.created_by,
        external_sharing.external_is_enabled AS is_enabled,
        external_sharing.id AS external_id
    FROM
        external_sharing
        INNER JOIN users ON users.id = external_sharing.created_by
    WHERE
        external_sharing.is_project = TRUE
        AND external_sharing.phase_id IS NULL
        AND (external_sharing.is_property IS NULL OR external_sharing.is_property IS FALSE)
        AND (external_sharing.is_unit IS NULL OR external_sharing.is_unit IS FALSE)
        AND CASE WHEN @company_id::bigint = 0 THEN TRUE ELSE @company_id::bigint = ANY (external_company_id) END
        AND CASE WHEN @is_branch_id::bigint = 0 THEN TRUE ELSE @is_branch::bool = ANY (external_is_branch) END
        AND CASE WHEN @company_type::bigint = 0 THEN TRUE ELSE @company_type::bigint = ANY(external_company_type) END
--         AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END
    UNION ALL
    SELECT
        internal_sharing.id as share_id,
        internal_sharing.shared_to as company_ids,
        internal_sharing.project_id AS project_id,
        'internal' AS source,
        internal_sharing.created_at,
        internal_sharing.created_by,
        internal_sharing.is_enabled AS is_enabled,
        0 AS external_id
    FROM
        internal_sharing
        INNER JOIN users u ON u.id = internal_sharing.created_by
    WHERE
        internal_sharing.is_project = TRUE
        AND internal_sharing.phase_id IS NULL
        AND (internal_sharing.is_property IS NULL OR internal_sharing.is_property IS FALSE)
        AND (internal_sharing.is_unit IS NULL OR internal_sharing.is_unit IS FALSE)
        AND CASE WHEN @user_id::bigint = 0 THEN TRUE ELSE @user_id::bigint = ANY (shared_to) END
--         AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END
)
SELECT
    COUNT(DISTINCT x.project_id) AS total_count
FROM
    x
    INNER JOIN projects p ON x.project_id = p.id
    INNER JOIN addresses ON p.addresses_id = addresses.id 
    INNER JOIN countries ON addresses.countries_id = countries.id  
    INNER JOIN states ON addresses.states_id = states.id   
    INNER JOIN cities ON addresses.cities_id = cities.id    
    INNER JOIN companies ON p.developer_companies_id = companies.id    
    INNER JOIN properties_facts ON p.id = properties_facts.project_id AND properties_facts.is_project_fact = true  
WHERE
 -- Search criteria
    (@search = '%%' OR 
     p.project_name % @search OR 
     p.ref_number % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     companies.company_name % @search  
      OR (CASE 
        WHEN 'ready' ILIKE @search THEN properties_facts.completion_status = 5
        WHEN 'off plan' ILIKE @search  THEN properties_facts.completion_status = 4
        WHEN '^[0-9]+$' ~ @search  THEN properties_facts.completion_percentage::TEXT % @search
        WHEN 'draft' ILIKE @search  THEN p.status = 1
        WHEN 'available' ILIKE @search  THEN p.status = 2
        WHEN 'block' ILIKE @search  THEN p.status = 5
        WHEN 'single' ILIKE @search  THEN p.is_multiphase = false
        WHEN 'multiple' ILIKE @search  THEN p.is_multiphase = true 
        ELSE FALSE
      END)
      )
AND 
    p.status NOT IN (5, 6);
 


-- ! ******************************************  Share Project Phase   *****************************************************

-- name: GetAllProjectPhaseSharingWithMe :many
WITH x AS (
    SELECT  
        external_sharing.project_id as project_id,
        external_sharing.external_company_id as company_ids,
        'external' AS source,
        external_sharing.created_at,
        external_sharing.created_by,
        external_sharing.id as external_id,
        external_sharing.external_is_enabled AS is_enabled,
        phase_id
    FROM
        external_sharing
    INNER JOIN
        users  ON users.id = external_sharing.created_by
    WHERE
        external_sharing.is_project = true
          AND external_sharing.phase_id IS NOT NULL
          AND (external_sharing.is_property IS NULL OR  external_sharing.is_property IS FALSE)
         AND (external_sharing.is_unit IS NULL OR external_sharing.is_unit IS FALSE) 
         AND CASE WHEN @company_id::bigint = 0 THEN true ELSE @company_id::bigint = ANY(external_company_id) END 
         AND CASE WHEN @is_branch_id::bigint = 0 THEN true ELSE  @is_branch::bool = ANY(external_is_branch)  END
         AND CASE WHEN @company_type::bigint = 0 THEN true ELSE @company_type::bigint = ANY(external_company_type) END
--          AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END     
    UNION ALL
  SELECT
        internal_sharing.project_id as project_id,
        internal_sharing.shared_to as company_ids,
        'internal' AS source,
        internal_sharing.created_at,
        internal_sharing.created_by,
        0 as external_id,
        internal_sharing.is_enabled AS is_enabled,
        phase_id
    FROM
        internal_sharing
    INNER JOIN
        users u ON u.id = internal_sharing.created_by
    Where internal_sharing.is_project = true 
    AND internal_sharing.phase_id IS NOT NULL
    AND (internal_sharing.is_property IS NULL OR  internal_sharing.is_property IS FALSE)
    AND (internal_sharing.is_unit IS NULL OR internal_sharing.is_unit IS FALSE) 
    AND CASE WHEN @user_id::bigint = 0 THEN true ELSE @user_id::bigint = ANY(shared_to) END
--     AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END 
)
SELECT
    x.external_id,
    x.project_id, 
    x.company_ids,
    x.created_by,
    MAX(CASE WHEN source = 'internal' THEN 'internal' ELSE '' END)::varchar AS internal,
    MAX(CASE WHEN source = 'external' THEN 'external' ELSE '' END)::varchar AS external,
    CASE WHEN @user_id::bigint = x.created_by THEN true ELSE false END AS unshared_available,
    x.phase_id,
    x.created_at,
    x.is_enabled
FROM 
    x
  INNER JOIN projects p ON x.project_id = p.id
    -- other joins 
  INNER JOIN phases ON p.id = phases.projects_id
  INNER JOIN phases_facts ON phases.id = phases_facts.phases_id
  INNER JOIN companies ON p.developer_companies_id = companies.id 
WHERE   
     (
     @search = '%%'
      OR phases.ref_no ILIKE @search
      OR p.project_name ILIKE @search
      OR companies.company_name ILIKE @search
      OR phases.phase_name ILIKE @search
       OR (CASE 
        WHEN 'ready' ILIKE @search THEN phases_facts.completion_status = 5
        WHEN 'off plan'ILIKE @search  THEN phases_facts.completion_status = 4
        WHEN '^[0-9]+$' ~ @search  THEN phases_facts.completion_percentage::TEXT % @search
        ELSE FALSE
      END)
     )   
   ---------------------     
   AND  p.status NOT IN (5, 6)
GROUP BY
    x.project_id,
    x.company_ids,
    x.created_by,
    x.external_id,
    x.created_at,
    x.phase_id,
    x.is_enabled
    ORDER BY created_at DESC
    LIMIT $1 OFFSET $2;
 

-- name: CountAllProjectPhaseSharingWithMe :one
WITH x AS (
    SELECT  
        external_sharing.project_id as project_id,
        external_sharing.external_company_id as company_ids,
        'external' AS source,
        external_sharing.created_at,
        external_sharing.created_by,
        external_sharing.id as external_id,
        external_sharing.external_is_enabled AS is_enabled,
        phase_id
    FROM
        external_sharing
    INNER JOIN
        users  ON users.id = external_sharing.created_by
    WHERE
        external_sharing.is_project = true
          AND external_sharing.phase_id IS NOT NULL
          AND (external_sharing.is_property IS NULL OR  external_sharing.is_property IS FALSE)
         AND (external_sharing.is_unit IS NULL OR external_sharing.is_unit IS FALSE) 
         AND CASE WHEN @company_id::bigint = 0 THEN true ELSE @company_id::bigint = ANY(external_company_id) END 
         AND CASE WHEN @is_branch_id::bigint = 0 THEN true ELSE  @is_branch::bool = ANY(external_is_branch)  END
         AND CASE WHEN @company_type::bigint = 0 THEN true ELSE @company_type::bigint = ANY(external_company_type) END
--          AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END     
    UNION ALL
  SELECT
        internal_sharing.project_id as project_id,
        internal_sharing.shared_to as company_ids,
        'internal' AS source,
        internal_sharing.created_at,
        internal_sharing.created_by,
        0 as external_id,
        internal_sharing.is_enabled AS is_enabled,
        phase_id
    FROM
        internal_sharing
    INNER JOIN
        users u ON u.id = internal_sharing.created_by
    Where internal_sharing.is_project = true 
    AND internal_sharing.phase_id IS NOT NULL
    AND (internal_sharing.is_property IS NULL OR  internal_sharing.is_property IS FALSE)
    AND (internal_sharing.is_unit IS NULL OR internal_sharing.is_unit IS FALSE) 
    AND CASE WHEN @user_id::bigint = 0 THEN true ELSE @user_id::bigint = ANY(shared_to) END
--     AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END 
)
SELECT
     COUNT(DISTINCT x.project_id) AS total_count
FROM 
    x
  INNER JOIN projects p ON x.project_id = p.id
    -- other joins 
  INNER JOIN phases ON p.id = phases.projects_id
  INNER JOIN phases_facts ON phases.id = phases_facts.phases_id
  INNER JOIN companies ON p.developer_companies_id = companies.id 
WHERE   
     (
     @search = '%%'
      OR phases.ref_no ILIKE @search
      OR p.project_name ILIKE @search
      OR companies.company_name ILIKE @search
      OR phases.phase_name ILIKE @search
       OR (CASE 
        WHEN 'ready' ILIKE @search THEN phases_facts.completion_status = 5
        WHEN 'off plan'ILIKE @search  THEN phases_facts.completion_status = 4
        WHEN '^[0-9]+$' ~ @search  THEN phases_facts.completion_percentage::TEXT % @search
        ELSE FALSE
      END)
     )   
   ---------------------     
AND  p.status NOT IN (5, 6);
-- ! ******************************************  Share Property   *****************************************************



 
 
-- name: GetAllProjectPropertySharingWithMe :many
WITH x AS (
    SELECT  
        external_sharing.project_id as project_id,
        external_sharing.external_company_id as company_ids,
        'external' AS source,
        external_sharing.created_at,
        external_sharing.created_by,
        external_sharing.id as external_id,
        external_sharing.external_is_enabled AS is_enabled,
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
         AND CASE WHEN @company_id::bigint = 0 THEN TRUE ELSE @company_id::bigint = ANY (external_company_id) END
         AND CASE WHEN @is_branch_id::bigint = 0 THEN TRUE ELSE @is_branch::bool = ANY (external_is_branch) END
         AND CASE WHEN @company_type::bigint = 0 THEN TRUE ELSE @company_type::bigint = ANY(external_company_type) END       
--          AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by END 
    UNION ALL 
           
  SELECT
        internal_sharing.project_id as project_id,
        internal_sharing.shared_to as company_ids,
        'internal' AS source,
        internal_sharing.created_at,
        internal_sharing.created_by,
        0 as external_id,
        internal_sharing.is_enabled AS is_enabled,
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
    AND CASE WHEN @user_id::bigint = 0 THEN TRUE ELSE @user_id::bigint = ANY (shared_to) END

)
SELECT
    x.external_id,
    x.project_id,
    x.company_ids,
    x.created_by,
    MAX(CASE WHEN source = 'internal' THEN 'internal' ELSE '' END)::varchar AS internal,
    MAX(CASE WHEN source = 'external' THEN 'external' ELSE '' END)::varchar AS external,
    CASE WHEN @user_id::bigint = x.created_by THEN true ELSE false END AS unshared_available,
    x.created_at,
    x.property_id,
    x.phase_id,
    x.is_enabled
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
    x.company_ids,
    x.external_id,
    x.created_at,
    x.property_id,
    x.phase_id,
    x.is_enabled
    ORDER BY created_at DESC
LIMIT $1 OFFSET $2;



-- name: CountProjectPropertySharingWithMe :one
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
        AND CASE WHEN @company_id::bigint = 0 THEN TRUE ELSE @company_id::bigint = ANY (external_company_id) END
        AND CASE WHEN @is_branch_id::bigint = 0 THEN TRUE ELSE @is_branch::bool = ANY (external_is_branch) END
        AND CASE WHEN @company_type::bigint = 0 THEN TRUE ELSE @company_type::bigint = ANY(external_company_type) END  
        
--         AND CASE WHEN @user_id::bigint = 0 THEN true ELSE @user_id::bigint = created_by END 
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
        AND CASE WHEN @user_id::bigint = 0 THEN TRUE ELSE @user_id::bigint = ANY (shared_to) END

--         AND CASE WHEN @user_id::bigint = 0 THEN true ELSE @user_id::bigint = created_by END 
)
SELECT
    COUNT(DISTINCT x.property_id) AS total_count
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



-- ! ******************************************  Share Unit  *****************************************************

-- name: GetAllProjectPropertyUnitSharingWithMe :many
WITH x AS (
    SELECT  
        external_sharing.project_id as project_id,
        external_sharing.external_company_id as company_ids,
        'external' AS source,
        external_sharing.created_at,
        external_sharing.created_by,
        external_sharing.id as external_id,
        external_sharing.unit_id,
        unit_category,
        property_id,
        phase_id,
        external_sharing.external_is_enabled AS is_enabled,
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
         AND CASE WHEN @company_id::bigint = 0 THEN TRUE ELSE @company_id::bigint = ANY (external_company_id) END
         AND CASE WHEN @is_branch_id::bigint = 0 THEN TRUE ELSE @is_branch::bool = ANY (external_is_branch) END
         AND CASE WHEN @company_type::bigint = 0 THEN TRUE ELSE @company_type::bigint = ANY(external_company_type) END 
    UNION ALL 
           
  SELECT
          internal_sharing.project_id as project_id,
         internal_sharing.shared_to as company_ids,
         'internal' AS source,
        internal_sharing.created_at,
        internal_sharing.created_by,
        0 as external_id,
        internal_sharing.unit_id,
        unit_category,
        property_id,
        phase_id,
        internal_sharing.is_enabled AS is_enabled,
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
    AND CASE WHEN @user_id::bigint = 0 THEN TRUE ELSE @user_id::bigint = ANY (shared_to) END
--     AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  internal_sharing.created_by  END 
)
SELECT
    x.external_id,
    x.project_id,
    x.company_ids,
    x.created_by,
    MAX(CASE WHEN source = 'internal' THEN 'internal' ELSE '' END)::varchar AS internal,
    MAX(CASE WHEN source = 'external' THEN 'external' ELSE '' END)::varchar AS external,
    CASE WHEN @user_id::bigint = x.created_by THEN true ELSE false END AS unshared_available,
    x.created_at,
    x.unit_id,
    x.unit_category,
    x.property_id,
    x.phase_id,
    x.is_enabled,
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
    x.company_ids,
    x.external_id,
    x.created_at,
    x.unit_id,
    x.unit_category,
    x.property_id,
    x.phase_id,
    x.title,
    x.rent_title,
    x.is_enabled
    ORDER BY x.created_at DESC
LIMIT $1 OFFSET $2;
 


    
-- name: CountAllProjectPropertyUnitSharingWithMe :one
WITH x AS (
    SELECT  
        external_sharing.project_id as project_id,
        external_sharing.external_company_id as company_ids,
        'external' AS source,
        external_sharing.created_at,
        external_sharing.created_by,
        external_sharing.id as external_id,
        external_sharing.unit_id,
        unit_category,
        property_id,
        phase_id,
        external_sharing.external_is_enabled AS is_enabled,
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
         AND CASE WHEN @company_id::bigint = 0 THEN TRUE ELSE @company_id::bigint = ANY (external_company_id) END
         AND CASE WHEN @is_branch_id::bigint = 0 THEN TRUE ELSE @is_branch::bool = ANY (external_is_branch) END
         AND CASE WHEN @company_type::bigint = 0 THEN TRUE ELSE @company_type::bigint = ANY(external_company_type) END 
    UNION ALL 
           
  SELECT
          internal_sharing.project_id as project_id,
         internal_sharing.shared_to as company_ids,
         'internal' AS source,
        internal_sharing.created_at,
        internal_sharing.created_by,
        0 as external_id,
        internal_sharing.unit_id,
        unit_category,
        property_id,
        phase_id,
        internal_sharing.is_enabled AS is_enabled,
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
    AND CASE WHEN @user_id::bigint = 0 THEN TRUE ELSE @user_id::bigint = ANY (shared_to) END 
)
SELECT
     COUNT(DISTINCT x.unit_id) AS total_count
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
 
 



------------------------------------------------------------------------------------------------------------------------------------------------
-- name: GetAllShareRequestByOwnerID :many
SELECT DISTINCT ON (sharing.entity_id,sharing.shared_to)
 share_requests.requester_id, share_requests.owner_id, share_requests.created_at,share_requests.created_by,
 shared_documents.is_allowed, shared_documents.sharing_id, sharing.entity_type_id, sharing.entity_id 
 FROM share_requests
INNER JOIN shared_documents ON shared_documents.id =  share_requests.document_id
INNER JOIN sharing ON sharing.id = shared_documents.sharing_id
WHERE owner_id = @owner_id
ORDER BY sharing.entity_id,sharing.shared_to, created_at DESC
LIMIT $1 OFFSET $2;

-- name: CountAllShareRequestByOwnerID :one
SELECT COUNT(DISTINCT (sharing.entity_id,sharing.shared_to)) as unique_entities_count
FROM share_requests
INNER JOIN shared_documents ON shared_documents.id = share_requests.document_id
INNER JOIN sharing ON sharing.id = shared_documents.sharing_id
WHERE owner_id = @owner_id;