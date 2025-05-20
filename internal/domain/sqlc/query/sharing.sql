 
-- name: UpdateSharingEnables :many
UPDATE sharing 
SET 
    is_enabled = @enable::BOOLEAN
WHERE 
    CASE 
        WHEN @entity_id::BIGINT > 0 THEN 
            sharing.entity_id = @entity_id::BIGINT
        ELSE  (
                entity_type_id = @entity_type_id
                AND shared_to = @user_id
                AND sharing.id = @sharing_id

        )            
    END
RETURNING *;

-- name: CreateInternalSharing :one
INSERT INTO internal_sharing (
     company_types_id,
     companies_id, 
     is_branch, 
     is_project, 
     project_id,   
     is_property, 
     is_property_branch,
     property_id,  
     is_unit, 
     unit_id,
     unit_category,
     price, 
     shared_to, 
     created_at, 
     created_by,
     phase_id,
     is_enabled,
     property_key
 )VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18
 ) RETURNING *;
 

-- name: UpdateInternalShare :one
UPDATE internal_sharing
SET  company_types_id = $2,
     companies_id = $3, 
     is_branch = $4, 
     is_project = $5, 
     project_id = $6,   
     is_property = $7, 
     is_property_branch = $8,
     property_id = $9,  
     is_unit = $10,
     unit_category = $11, 
     price = $12,  
     shared_to = $13, 
     created_at = $14, 
     created_by = $15,
     phase_id = $16,
     is_enabled = $17,
     property_key = $18,
     unit_id =  $19 
Where id = $1
RETURNING *;


-- name: CreateExternalSharing :one
INSERT INTO external_sharing (
 company_types_id,
 companies_id, 
 is_branch,  
 is_project,  
 project_id ,
 is_property, 
 is_property_branch,
 property_id,
 is_unit, 
 unit_id,
 unit_category,
 price, 
 external_company_type,
 external_is_branch,
 external_company_id,
 created_at, 
 created_by,
 phase_id,
 external_is_enabled,
 property_key
 )VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18 , $19, $20
 ) RETURNING *;


-- name: UpdateExternalSharing :one
UPDATE external_sharing
SET company_types_id =$2,
 companies_id =$3, 
 is_branch=$4,  
 is_project=$5,  
 project_id=$6,
 is_property=$7, 
 is_property_branch=$8,
 property_id = $9,
 is_unit = $10, 
 price = $11, 
 external_company_type = $12,
 external_is_branch = $13,
 external_company_id = $14,
 created_at = $15, 
 created_by = $16,
 phase_id = $17,
 external_is_enabled = $18,
 property_key = $19,
 unit_category =  $20,  
 unit_id =  $21
Where id=$1
RETURNING *;


-- name: GetInternalSharingByMe :one
SELECT *,
  CASE
    WHEN @check_for = 'unit' THEN
      CASE
        WHEN  is_unit = @is_unit AND unit_id = @unit_id  AND unit_category = @unit_category  THEN 'Unit query executed'
        ELSE 'No matching condition'
      END
    WHEN @check_for = 'property' THEN
      CASE
        WHEN  is_property = @is_property AND property_key = @property_key AND property_id = @property_id  AND (is_unit IS NULL  OR is_unit IS FALSE)  THEN 'Property query executed'
        ELSE 'No matching condition'
      END
    WHEN @check_for = 'project_with_phase' THEN
      CASE
        WHEN is_project = @is_project AND phase_id = @phase_id AND project_id = @project_id THEN 'Project with phase query executed'
        ELSE 'No matching condition'
      END
    WHEN @check_for = 'project_without_phase' THEN
      CASE
        WHEN is_project = @is_project AND phase_id IS NULL AND project_id = @project_id THEN 'Project without phase query executed'
        ELSE 'No matching condition'
      END
    ELSE 'Invalid check_for parameter'
  END AS query_executed
FROM internal_sharing
WHERE
  CASE
    WHEN @check_for = 'unit' THEN
      CASE
        WHEN  is_unit = @is_unit AND unit_id = @unit_id  AND created_by = @user_id  AND unit_category = @unit_category   THEN TRUE
        ELSE FALSE
      END
    WHEN @check_for = 'property' THEN
      CASE
        WHEN is_property = @is_property AND property_key = @property_key AND property_id = @property_id  AND created_by = @user_id  
         AND (is_unit IS NULL  OR is_unit IS FALSE)  THEN TRUE
        ELSE FALSE
      END
    WHEN @check_for = 'project_with_phase' THEN
      CASE
        WHEN is_project = @is_project AND phase_id = @phase_id AND project_id = @project_id 
             AND (is_property IS NULL OR is_property IS false) 
            AND (is_unit IS NULL OR is_unit IS false)  
         AND created_by = @user_id THEN TRUE
        ELSE FALSE
      END
    WHEN @check_for = 'project_without_phase' THEN
      CASE
        WHEN is_project = @is_project AND phase_id IS NULL AND project_id = @project_id   
        AND (is_property IS NULL OR is_property IS false) 
        AND (is_unit IS NULL OR is_unit IS false)   
        AND created_by = @user_id    THEN TRUE
        ELSE FALSE
      END
    ELSE FALSE
  END;



-- name: GetInternalSharing :one
SELECT *,
  CASE
    WHEN @check_for = 'unit' THEN
      CASE
        WHEN  is_unit = @is_unit AND unit_id = @unit_id   AND unit_category = @unit_category    THEN 'Unit query executed'
        ELSE 'No matching condition'
      END
    WHEN @check_for = 'property' THEN
      CASE
        WHEN  is_property = @is_property AND property_key = @property_key AND  property_id = @property_id  
        AND (is_unit IS NULL  OR is_unit IS FALSE) 
         THEN 'Property query executed'
        ELSE 'No matching condition'
      END
    WHEN @check_for = 'project_with_phase' THEN
      CASE
        WHEN is_project = @is_project AND phase_id = @phase_id AND project_id = @project_id 
        
        THEN 'Project with phase query executed'
        ELSE 'No matching condition'
      END
    WHEN @check_for = 'project_without_phase' THEN
      CASE
        WHEN is_project = @is_project AND phase_id IS NULL AND project_id = @project_id THEN 'Project without phase query executed'
        ELSE 'No matching condition'
      END
    ELSE 'Invalid check_for parameter'
  END AS query_executed
FROM internal_sharing
WHERE
  CASE
    WHEN @check_for = 'unit' THEN
      CASE
        WHEN   is_unit = @is_unit AND unit_id = @unit_id  AND unit_category = @unit_category   THEN TRUE
        ELSE FALSE
      END
    WHEN @check_for = 'property' THEN
      CASE
        WHEN   is_property = @is_property AND property_key = @property_key AND property_id = @property_id 
         AND (is_unit IS NULL  OR is_unit IS FALSE) THEN TRUE
        ELSE FALSE
      END
    WHEN @check_for = 'project_with_phase' THEN
      CASE
        WHEN is_project = @is_project AND phase_id = @phase_id AND project_id = @project_id
             AND (is_property IS NULL OR is_property IS false) 
        AND (is_unit IS NULL OR is_unit IS false)  
                 THEN TRUE
        ELSE FALSE
      END
    WHEN @check_for = 'project_without_phase' THEN
      CASE
        WHEN is_project = @is_project AND phase_id IS NULL AND project_id = @project_id
             AND (is_property IS NULL OR is_property IS false) 
        AND (is_unit IS NULL OR is_unit IS false)          
         THEN TRUE
        ELSE FALSE
      END
    ELSE FALSE
END;


-- name: GetExternalSharingByProjectID :one
SELECT * FROM external_sharing 
WHERE is_project = TRUE AND project_id = $1;

-- name: GetInternalSharingByProjectID :one
SELECT * FROM internal_sharing 
WHERE is_project = TRUE AND project_id = $1;



-- name: GetExternalSharingByMe :one
SELECT *,
  CASE
    WHEN @check_for = 'unit' THEN
      CASE
        WHEN is_unit = @is_unit AND unit_id = @unit_id  AND unit_category =  @unit_category THEN 'Unit query executed'
        ELSE 'No matching condition'
      END
    WHEN @check_for = 'property' THEN
      CASE
        WHEN  is_property = @is_property AND property_key = @property_key AND property_id = @property_id 
         AND (is_unit IS NULL  OR is_unit IS FALSE) THEN 'Property query executed'
        ELSE 'No matching condition'
      END
    WHEN @check_for = 'project_with_phase' THEN
      CASE
        WHEN is_project = @is_project AND phase_id = @phase_id AND project_id = @project_id
         AND (is_property IS NULL OR is_property IS false) 
        AND (is_unit IS NULL OR is_unit IS false)          
         THEN 'Project with phase query executed'
        ELSE 'No matching condition'
      END
    WHEN @check_for = 'project_without_phase' THEN
      CASE
        WHEN is_project = @is_project AND phase_id IS NULL AND project_id = @project_id 
         AND (is_property IS NULL OR is_property IS false) 
        AND (is_unit IS NULL OR is_unit IS false)          
        THEN 'Project without phase query executed'
        ELSE 'No matching condition'
      END
    ELSE 'Invalid check_for parameter'
  END AS query_executed
FROM external_sharing
WHERE
  CASE
    WHEN @check_for = 'unit' THEN
      CASE
        WHEN is_unit = @is_unit AND unit_id = @unit_id  AND created_by = @user_id 
         AND unit_category =  @unit_category  THEN TRUE
        ELSE FALSE
      END
    WHEN @check_for = 'property' THEN
      CASE
        WHEN is_property = @is_property AND property_key = @property_key AND property_id = @property_id 
         AND created_by = @user_id  AND (is_unit IS NULL  OR is_unit IS FALSE) THEN TRUE
        ELSE FALSE
      END
    WHEN @check_for = 'project_with_phase' THEN
      CASE
        WHEN is_project = @is_project AND phase_id = @phase_id AND project_id = @project_id  AND created_by = @user_id
         AND (is_property IS NULL OR is_property IS false) 
        AND (is_unit IS NULL OR is_unit IS false)  
         THEN TRUE
        ELSE FALSE
      END
    WHEN @check_for = 'project_without_phase' THEN
      CASE
        WHEN is_project = @is_project AND phase_id IS NULL AND project_id = @project_id  AND created_by = @user_id
         AND (is_property IS NULL OR is_property IS false) 
        AND (is_unit IS NULL OR is_unit IS false)          
         THEN TRUE
        ELSE FALSE
      END
    ELSE FALSE
  END;


-- name: GetExternalSharing :one
SELECT *,
  CASE
    WHEN @check_for = 'unit' THEN
      CASE
        WHEN   is_unit = @is_unit AND unit_id = @unit_id AND unit_category = @unit_category  THEN 'Unit query executed'
        ELSE 'No matching condition'
      END
    WHEN @check_for = 'property' THEN
      CASE
        WHEN  is_property = @is_property AND property_key = @property_key AND property_id = @property_id  
         AND (is_unit IS NULL  OR is_unit IS FALSE)  THEN 'Property query executed'
        ELSE 'No matching condition'
      END
    WHEN @check_for = 'project_with_phase' THEN
      CASE
        WHEN is_project = @is_project AND phase_id = @phase_id AND project_id = @project_id 
         AND (is_property IS NULL OR is_property IS false) 
        AND (is_unit IS NULL OR is_unit IS false) 
         THEN 'Project with phase query executed'
        ELSE 'No matching condition'
      END
    WHEN @check_for = 'project_without_phase' THEN
      CASE
        WHEN is_project = @is_project AND phase_id IS NULL AND project_id = @project_id
         AND (is_property IS NULL OR is_property IS false) 
        AND (is_unit IS NULL OR is_unit IS false)          
         THEN 'Project without phase query executed'
        ELSE 'No matching condition'
      END
    ELSE 'Invalid check_for parameter'
  END AS query_executed
FROM external_sharing
WHERE
  CASE
    WHEN @check_for = 'unit' THEN
      CASE
        WHEN  is_unit = @is_unit AND unit_id = @unit_id  AND unit_category = @unit_category THEN TRUE
        ELSE FALSE
      END
    WHEN @check_for = 'property' THEN
      CASE
        WHEN   is_property = @is_property AND property_key = @property_key AND property_id = @property_id  AND (is_unit IS NULL  OR is_unit IS FALSE)  THEN TRUE
        ELSE FALSE
      END
    WHEN @check_for = 'project_with_phase' THEN
      CASE
        WHEN is_project = @is_project AND phase_id = @phase_id AND project_id = @project_id THEN TRUE
        ELSE FALSE
      END
    WHEN @check_for = 'project_without_phase' THEN
      CASE
        WHEN is_project = @is_project AND phase_id IS NULL AND project_id = @project_id THEN TRUE
        ELSE FALSE
      END
    ELSE FALSE
  END;

-- SELECT * FROM external_sharing 
-- WHERE 
-- CASE 
-- WHEN is_project = TRUE AND phase_id IS NULL AND project_id = $1
-- THEN TRUE
-- ELSE is_project = TRUE AND phase_id = $2 AND project_id = $1
-- END;




-- name: GetAllInternalSharing :many
SELECT project_id,'internal' AS internal, CASE WHEN @user_id::bigint = created_by THEN true ELSE false END AS unshared_available FROM internal_sharing 
Where is_project = true AND phase_id IS NULL AND CASE WHEN @user_id::bigint = 0 THEN true ELSE @user_id::bigint  =  ANY(shared_to) END
ORDER BY created_at DESC LIMIT $1 OFFSET $2;

-- name: GetCountAllInternalSharing :one
SELECT COUNT(project_id) FROM internal_sharing 
Where is_project = true AND phase_id IS NULL AND CASE WHEN @user_id::bigint = 0 THEN true ELSE @user_id::bigint  =  ANY(shared_to) END;



-- name: GetAll :many
SELECT * FROM project_property_units LIMIT $1 OFFSET $2;




 
-- name: GetAllProjectSharing :many
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
        -- AND CASE WHEN @company_id::bigint = 0 THEN TRUE ELSE @company_id::bigint = ANY (external_company_id) END
        -- AND CASE WHEN @is_branch_id::bigint = 0 THEN TRUE ELSE @is_branch::bool = ANY (external_is_branch) END
        -- AND CASE WHEN @company_type::bigint = 0 THEN TRUE ELSE @company_type::bigint = ANY(external_company_type) END
        AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END
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
        -- AND CASE WHEN @user_id::bigint = 0 THEN TRUE ELSE @user_id::bigint = ANY (shared_to) END
        AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END
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
 




-- name: CountAllProjectSharing :one
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
        AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END
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
        AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END
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
 

--------------------------------------------------

-- name: GetAllProjectPhaseSharing :many
WITH x AS (
    SELECT  
        external_sharing.project_id as project_id,
        'external' AS source,
        external_sharing.created_at,
        external_sharing.created_by,
        external_sharing.id as external_id,
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
--          AND CASE WHEN @company_id::bigint = 0 THEN true ELSE @company_id::bigint = ANY(external_company_id) END 
--          AND CASE WHEN @is_branch_id::bigint = 0 THEN true ELSE  @is_branch::bool = ANY(external_is_branch)  END
--          AND CASE WHEN @company_type::bigint = 0 THEN true ELSE @company_type::bigint = ANY(external_company_type) END
         AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END     
    UNION ALL
        
  SELECT
        internal_sharing.project_id as project_id,
        'internal' AS source,
        internal_sharing.created_at,
        internal_sharing.created_by,
        0 as external_id,
        phase_id
    FROM
        internal_sharing
    INNER JOIN
        users u ON u.id = internal_sharing.created_by
    Where internal_sharing.is_project = true 
    AND internal_sharing.phase_id IS NOT NULL
    AND (internal_sharing.is_property IS NULL OR  internal_sharing.is_property IS FALSE)
    AND (internal_sharing.is_unit IS NULL OR internal_sharing.is_unit IS FALSE) 
    -- AND CASE WHEN @user_id::bigint = 0 THEN true ELSE @user_id::bigint = ANY(shared_to) END
    AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END 
)
SELECT
    x.external_id,
    x.project_id,
    x.created_by,
    MAX(CASE WHEN source = 'internal' THEN 'internal' ELSE '' END)::varchar AS internal,
    MAX(CASE WHEN source = 'external' THEN 'external' ELSE '' END)::varchar AS external,
    CASE WHEN @user_id::bigint = x.created_by THEN true ELSE false END AS unshared_available,
    x.phase_id,
    x.created_at
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
      OR  phases.ref_no ILIKE @search
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
    x.created_by,
    x.external_id,
    x.created_at,
    x.phase_id
    ORDER BY created_at DESC
    LIMIT $1 OFFSET $2;
 

-- name: CountAllProjectPhaseSharing :one
WITH x AS (
    SELECT 
        external_sharing.project_id as project_id,
        'external' AS source,
        external_sharing.created_at,
        external_sharing.created_by,
        external_sharing.id as external_id
    FROM external_sharing
    INNER JOIN users ON users.id = external_sharing.created_by
    WHERE 
        external_sharing.is_project = true
        AND external_sharing.phase_id IS NOT NULL
        AND (external_sharing.is_property IS NULL OR  external_sharing.is_property IS FALSE)
        AND (external_sharing.is_unit IS NULL OR external_sharing.is_unit IS FALSE)  
        -- AND CASE WHEN @company_id::bigint = 0 THEN true ELSE @company_id::bigint = ANY(external_company_id) END
        -- AND CASE WHEN @is_branch_id::bigint = 0 THEN true ELSE @is_branch::bool = ANY(external_is_branch) END
        -- AND CASE WHEN @company_type::bigint = 0 THEN true ELSE @company_type::bigint = ANY(external_company_type) END
        AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END
    UNION ALL
    SELECT
        internal_sharing.project_id as project_id,
        'internal' AS source,
        internal_sharing.created_at,
        internal_sharing.created_by,
        0 as external_id
    FROM internal_sharing
    INNER JOIN users u ON u.id = internal_sharing.created_by
    WHERE 
        internal_sharing.is_project = true
        AND internal_sharing.phase_id IS NOT NULL
        AND (internal_sharing.is_property IS NULL OR  internal_sharing.is_property IS FALSE)
        AND (internal_sharing.is_unit IS NULL OR internal_sharing.is_unit IS FALSE)  
        -- AND CASE WHEN @user_id::bigint = 0 THEN true ELSE @user_id::bigint = ANY(shared_to) END
        AND CASE WHEN @user_id::bigint = 0 THEN true ELSE  @user_id::bigint =  created_by  END
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

 

-- name: CreateShareDoc :one
INSERT INTO shared_doc (
 sharing_id,
 is_internal,
 single_share_docs,
 created_at, 
 updated_at,
 is_project,
 project_id,
 is_property,
 is_property_branch,
 property_id,
 property_key,
 is_unit,
 unit_id,
 unit_category,
 status,
 shared_to,
 is_branch,
 phase_id
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,  $15, $16, $17, $18
 ) RETURNING *;

-- name: UpdateShareDoc :one
UPDATE shared_doc
SET  sharing_id = $2,
  is_internal = $3,
  updated_at = $4,
   is_project = $5,
  project_id = $6,
  is_property = $7,
  is_property_branch = $8,
  property_id = $9,
  property_key = $10,
  is_unit = $11,
  status = $12,
  shared_to = $13,
  is_branch =  $14,
  phase_id =  $15,
  unit_id =  $16,
  unit_category = $17,
  single_share_docs =  $18
 Where id = $1
 Returning *;

-- name: CreateSingleShareDoc :one
 INSERT INTO single_share_doc (
 documents_category_id,
 documents_subcategory_id,
 file_url,
 is_allowed
 ) 
 VALUES ($1, $2, $3, $4)
 RETURNING *;

-- -- name: GetAllSharedDocuments :many
-- SELECT
-- 	shared_doc.*,
-- 	documents_category.category,
-- 	documents_subcategory.sub_category,
-- 	CASE WHEN @check_for = 'unit' THEN
-- 		CASE WHEN is_unit = @is_unit
-- 			AND unit_id = @unit_id  AND unit_category = @unit_category THEN
-- 			'Unit query executed'
-- 		ELSE
-- 			'No matching condition'
-- 		END
-- 	WHEN @check_for = 'property' THEN
-- 		CASE WHEN is_property = @is_property
-- 			AND property_key = @property_key 
--       AND (is_unit IS NULL  OR is_unit IS FALSE) THEN 
-- 			'Property query executed'
-- 		ELSE
-- 			'No matching condition'
-- 		END
-- 	WHEN @check_for = 'project_with_phase' THEN
-- 		CASE WHEN project_id = @project_id
-- 			AND phase_id = @phase_id THEN
-- 			'Project with phase query executed'
-- 		ELSE
-- 			'No matching condition'
-- 		END
-- 	WHEN @check_for = 'project_without_phase' THEN
-- 		CASE WHEN project_id = @project_id
-- 			AND phase_id IS NULL THEN
-- 			'Project without phase query executed'
-- 		ELSE
-- 			'No matching condition'
-- 		END
-- 	ELSE
-- 		'Invalid check_for parameter'
-- 	END AS query_executed
-- FROM
-- 	shared_doc
--   LEFT JOIN single_share_doc ON shared_doc.single_share_docs = ANY(single_share_doc.id)
-- 	LEFT JOIN documents_category ON documents_category.id = single_share_doc.documents_category_id
-- 	LEFT JOIN documents_subcategory ON documents_subcategory.id = single_share_doc.documents_subcategory_id
-- WHERE
-- 	is_internal = @is_internal
-- 	AND is_branch = @is_branch
-- 	AND shared_to = @shared_to
-- 	AND(
-- 		CASE WHEN @check_for = 'unit' THEN
-- 			CASE WHEN is_unit = @is_unit
-- 				AND unit_id = @unit_id AND unit_category  = @unit_category THEN
-- 				TRUE
-- 			ELSE
-- 				FALSE
-- 			END
-- 		WHEN @check_for = 'property' THEN
--  			CASE WHEN is_property = @is_property
--          AND property_id = @property_id 
-- 				AND property_key = @property_key   AND (is_unit IS NULL  OR is_unit IS FALSE) THEN
-- 				TRUE
-- 			ELSE
-- 				FALSE
-- 			END
-- 		WHEN @check_for = 'project_with_phase' THEN
-- 			CASE WHEN project_id = @project_id
-- 				AND phase_id = @phase_id THEN
-- 				TRUE
-- 			ELSE
-- 				FALSE
-- 			END
-- 		WHEN @check_for = 'project_without_phase' THEN
-- 			CASE WHEN project_id = @project_id
-- 				AND phase_id IS NULL THEN
-- 				TRUE
-- 			ELSE
-- 				FALSE
-- 			END
-- 		ELSE
-- 			FALSE
-- 		END
-- );


-- name: GetAllSharedDocuments :many
SELECT
    shared_doc.*,
    documents_category.category,
    documents_category.category_ar,
    documents_subcategory.sub_category,
    documents_subcategory.sub_category_ar,
    single_share_doc.file_url,
    CASE WHEN @check_for = 'unit' THEN
        CASE WHEN shared_doc.is_unit = @is_unit
            AND shared_doc.unit_id = @unit_id AND shared_doc.unit_category = @unit_category THEN
            'Unit query executed'
        ELSE
            'No matching condition'
        END
    WHEN @check_for = 'property' THEN
        CASE WHEN shared_doc.is_property = @is_property
            AND shared_doc.property_key = @property_key 
            AND (shared_doc.is_unit IS NULL OR shared_doc.is_unit IS FALSE) THEN 
            'Property query executed'
        ELSE
            'No matching condition'
        END
    WHEN @check_for = 'project_with_phase' THEN
        CASE WHEN shared_doc.project_id = @project_id
            AND shared_doc.phase_id = @phase_id THEN
            'Project with phase query executed'
        ELSE
            'No matching condition'
        END
    WHEN @check_for = 'project_without_phase' THEN
        CASE WHEN shared_doc.project_id = @project_id
            AND shared_doc.phase_id IS NULL THEN
            'Project without phase query executed'
        ELSE
            'No matching condition'
        END
    ELSE
        'Invalid check_for parameter'
    END AS query_executed
FROM
    shared_doc
LEFT JOIN LATERAL unnest(shared_doc.single_share_docs) AS unnested_id ON TRUE
LEFT JOIN single_share_doc ON single_share_doc.id = unnested_id
LEFT JOIN documents_category ON documents_category.id = single_share_doc.documents_category_id
LEFT JOIN documents_subcategory ON documents_subcategory.id = single_share_doc.documents_subcategory_id
WHERE
    shared_doc.is_internal = @is_internal
    AND shared_doc.is_branch = @is_branch
    AND shared_doc.shared_to = @shared_to
    AND single_share_doc.is_allowed IS TRUE
    AND (
        CASE WHEN @check_for = 'unit' THEN
            CASE WHEN shared_doc.is_unit = @is_unit
                AND shared_doc.unit_id = @unit_id AND shared_doc.unit_category = @unit_category THEN
                TRUE
            ELSE
                FALSE
            END
        WHEN @check_for = 'property' THEN
            CASE WHEN shared_doc.is_property = @is_property
                AND shared_doc.property_id = @property_id 
                AND shared_doc.property_key = @property_key AND (shared_doc.is_unit IS NULL OR shared_doc.is_unit IS FALSE) THEN
                TRUE
            ELSE
                FALSE
            END
        WHEN @check_for = 'project_with_phase' THEN
            CASE WHEN shared_doc.project_id = @project_id
                AND shared_doc.phase_id = @phase_id THEN
                TRUE
            ELSE
                FALSE
            END
        WHEN @check_for = 'project_without_phase' THEN
            CASE WHEN shared_doc.project_id = @project_id
                AND shared_doc.phase_id IS NULL THEN
                TRUE
            ELSE
                FALSE
            END
        ELSE
            FALSE
        END
);


-- name: GetAllSingleShareDoc :many
SELECT single_share_doc.* FROM shared_doc
INNER JOIN single_share_doc ON single_share_doc.id = ANY(shared_doc.single_share_docs)
WHERE shared_doc.id = $1;



-- name: GetAllShareDocuments :many
SELECT 
    jsonb_agg(
      subcategory.*
    ) AS subcategorized_documents
FROM (
    SELECT 
   	documents_category.id AS category_id,
    documents_category.category AS category,
    documents_category.category_ar AS category_ar,
        documents_subcategory.id AS subcategory_id,
        documents_subcategory.sub_category,
        documents_subcategory.sub_category_ar,
        jsonb_agg(
          shared_documents.*
        ) AS documents
    FROM shared_documents
    INNER JOIN sharing ON sharing.id = shared_documents.sharing_id
    INNER JOIN documents_category ON documents_category.id = shared_documents.category_id
    INNER JOIN documents_subcategory ON documents_subcategory.id = shared_documents.subcategory_id
    WHERE shared_documents.sharing_id = $1
    GROUP BY documents_subcategory.id, documents_category.id
) subcategory;


-- name: GetAllSharedWithUsers :many
SELECT * FROM users Where id = ANY(@user_or_companies_id::bigint[]);


-- name: GetAllSharedWithCompany :many
SELECT * FROM companies 
Where id = ANY(@user_or_companies_id::bigint[]);


-- name: UpdateSingleShareDoc :one
-- Update single_share_doc
Update shared_documents
SET is_allowed = $2
WHERE id = $1
RETURNING *;

-- name: GetShareDocById :one
SELECT * FROM shared_doc 
WHERE id =  $1 LIMIT 1;


-- name: GetSingleShareDoc :one
SELECT * FROM single_share_doc
WHERE id =  $1
LIMIT 1;

-- name: GetAddressByUser :one
SELECT addresses.* FROM addresses
LEFT JOIN profiles ON profiles.addresses_id = addresses.id
LEFT JOIN users ON users.id = profiles.users_id
WHERE users.id = $1;
 
-- name: GetCompanyNameByEqualCountry :one
SELECT companies.id, companies.company_name, companies.status, companies.logo_url FROM companies
INNER JOIN addresses ON addresses.id = companies.addresses_id
INNER JOIN  countries ON countries.id = addresses.countries_id
WHERE companies.id = @company_id AND company_type = @company_type 
AND  countries.id != @country_id;
 
-- name: GetCompanyNameByNotEqualCountry :one
SELECT companies.id, companies.company_name, companies.status, companies.logo_url, countries.country as country_name, countries.flag as country_flag  FROM companies
INNER JOIN addresses ON addresses.id = companies.addresses_id
INNER JOIN  countries ON countries.id = addresses.countries_id
WHERE companies.id = @company_id AND company_type = @company_type 
AND (@isInternational = 0 AND countries.id != @country_id) OR (@isInternational = 1 AND countries.id = @country_id);
 

-- name: UpdateInternalIsEnableCheck :one
UPDATE internal_sharing 
SET is_enabled = $2 
WHERE id = $1
RETURNING *;

-- name: UpdateExternalIsEnableCheck :one
UPDATE external_sharing 
SET external_is_enabled = $2 
WHERE id = $1
RETURNING *;

-- name: DeleteInternalSharing :exec
DELETE FROM internal_sharing
WHERE
    CASE
        WHEN @check_for = 'unit' THEN
            CASE
                WHEN is_unit = @is_unit AND unit_id = @unit_id AND created_by = @user_id  AND unit_category = @unit_category  THEN TRUE
                ELSE FALSE
            END
        WHEN @check_for = 'property' THEN
            CASE
                WHEN is_property = @is_property AND property_key = @property_key AND property_id = @property_id AND created_by = @user_id 
                  AND (is_unit IS NULL OR is_unit IS FALSE)
                 THEN TRUE
                ELSE FALSE
            END
        WHEN @check_for = 'project_with_phase' THEN
            CASE
                WHEN is_project = @is_project AND phase_id = @phase_id AND project_id = @project_id AND created_by = @user_id
                AND (is_property IS NULL OR is_property IS FALSE)
                  AND (is_unit IS NULL OR is_unit IS FALSE)
                 THEN TRUE
                ELSE FALSE
            END
        WHEN @check_for = 'project_without_phase' THEN
            CASE
                WHEN is_project = @is_project AND phase_id IS NULL AND project_id = @project_id AND created_by = @user_id 
                  AND (is_property IS NULL OR is_property IS FALSE)
                  AND (is_unit IS NULL OR is_unit IS FALSE)
                   THEN TRUE
                ELSE FALSE
            END
        ELSE FALSE
    END;

 

-- name: DeleteExternalSharing :exec
DELETE FROM external_sharing
WHERE
    CASE
        WHEN @check_for = 'unit' THEN
            CASE
                WHEN is_unit = @is_unit AND unit_id = @unit_id AND created_by = @user_id AND unit_category = @unit_category THEN TRUE
                ELSE FALSE
            END
        WHEN @check_for = 'property' THEN
            CASE
                WHEN is_property = @is_property AND property_key = @property_key AND property_id = @property_id AND created_by = @user_id                 
               
                AND (is_unit IS NULL OR is_unit IS FALSE)
                 THEN TRUE
                ELSE FALSE
            END
        WHEN @check_for = 'project_with_phase' THEN
            CASE
                WHEN is_project = @is_project AND phase_id = @phase_id AND project_id = @project_id AND created_by = @user_id
                  AND (is_property IS NULL OR is_property IS FALSE)
                  AND (is_unit IS NULL OR is_unit IS FALSE)
                 THEN TRUE
                ELSE FALSE
            END
        WHEN @check_for = 'project_without_phase' THEN
            CASE
                WHEN is_project = @is_project AND phase_id IS NULL AND project_id = @project_id AND created_by = @user_id
                  AND (is_property IS NULL OR is_property IS FALSE)
                  AND (is_unit IS NULL OR is_unit IS FALSE)
                 THEN TRUE
                ELSE FALSE
            END
        ELSE FALSE 
  END;
 

-- name: DeleteProjectSharedDoc :exec
DELETE FROM shared_doc
WHERE project_id = $1;


-- name: GetAllSharedPhases :many
WITH x AS (
    SELECT project_id,phase_id, 'external' as source, created_at,created_by FROM external_sharing
    Where is_project = true AND phase_id IS NOT NULL 
    AND CASE WHEN @company_id::bigint = 0 THEN true ELSE @company_id::bigint = ANY(external_company_id) END 
    AND CASE WHEN @is_branch_id::bigint = 0 THEN true ELSE  @is_branch::bool = ANY(external_is_branch)  END
    AND CASE WHEN @company_type::bigint = 0 THEN true ELSE @company_type::bigint = ANY(external_company_type) END  
    UNION ALL
    SELECT project_id,phase_id, 'internal' as source, created_at,created_by FROM internal_sharing
    Where is_project = true AND phase_id IS NOT NULL AND CASE WHEN @user_id::bigint = 0 THEN true ELSE @user_id::bigint = ANY(shared_to) END 
)
SELECT
    project_id,phase_id,
    MAX(CASE WHEN source = 'internal' THEN 'internal' ELSE '' END)::varchar AS internal,
    MAX(CASE WHEN source = 'external' THEN 'external' ELSE '' END)::varchar AS external,
    CASE WHEN @user_id::bigint = created_by THEN true ELSE false END AS unshared_available
FROM x
GROUP BY project_id,phase_id,created_by
LIMIT $1 OFFSET $2;

-- name: CountAllSharedPhases :one
SELECT COUNT(*) FROM(
    SELECT
        project_id,phase_id,
        MAX(CASE WHEN source = 'internal' THEN 'internal' ELSE '' END)::varchar AS internal,
        MAX(CASE WHEN source = 'external' THEN 'external' ELSE '' END)::varchar AS external,
        CASE WHEN @user_id::bigint = created_by THEN true ELSE false END AS unshared_available
        FROM(
            SELECT project_id,phase_id, 'external' as source, created_at,created_by FROM external_sharing
            Where is_project = true AND phase_id IS NOT NULL 
            AND CASE WHEN @company_id::bigint = 0 THEN true ELSE @company_id::bigint = ANY(external_company_id) END 
            AND CASE WHEN @is_branch_id::bigint = 0 THEN true ELSE  @is_branch::bool = ANY(external_is_branch)  END
            AND CASE WHEN @company_type::bigint = 0 THEN true ELSE @company_type::bigint = ANY(external_company_type) END  
            UNION ALL
            SELECT project_id,phase_id, 'internal' as source, created_at,created_by FROM internal_sharing
            Where is_project = true AND phase_id IS NOT NULL AND CASE WHEN @user_id::bigint = 0 THEN true ELSE @user_id::bigint = ANY(shared_to) END 
        ) AS derived_table 
    GROUP BY project_id,phase_id,created_by
) AS count;

-- name: DeleteProjectRelatedData :execrows
WITH deleted_internal_sharing AS (
    DELETE FROM internal_sharing
    WHERE internal_sharing.project_id = $1
    RETURNING *
),
deleted_shared_doc AS (
    DELETE FROM shared_doc
    WHERE shared_doc.project_id = $1
    RETURNING *
),
deleted_external_sharing AS (
    DELETE FROM external_sharing
    WHERE external_sharing.project_id = $1
    RETURNING *
),
deleted_publish_plan AS (
    DELETE FROM publish_plan
    WHERE publish_plan.publish_listing_id IN (
        SELECT publish_listing.id FROM publish_listing WHERE publish_listing.project_id = $1
    )
    RETURNING *
),
deleted_publish_gallery AS (
    DELETE FROM publish_gallery
    WHERE publish_gallery.publish_listing_id IN (
        SELECT publish_listing.id FROM publish_listing WHERE publish_listing.project_id = $1
    )
    RETURNING *
),
deleted_publish_listing AS (
    DELETE FROM publish_listing
    WHERE publish_listing.entity_id = $1 AND publish_listing.entity_type_id= @project_entity_type_id::BIGINT
    RETURNING *
)
SELECT
    (SELECT count(*) FROM deleted_internal_sharing) +
    (SELECT count(*) FROM deleted_shared_doc) +
    (SELECT count(*) FROM deleted_external_sharing) +
    (SELECT count(*) FROM deleted_publish_plan) +
    (SELECT count(*) FROM deleted_publish_gallery) +
    (SELECT count(*) FROM deleted_publish_listing) AS total_deleted;




-- name: DeleteProjectPhaseRelatedData :execrows
WITH deleted_internal_sharing AS (
    DELETE FROM internal_sharing
    WHERE internal_sharing.phase_id = $1
    RETURNING *
),
deleted_shared_doc AS (
    DELETE FROM shared_doc
    WHERE shared_doc.phase_id = $1
    RETURNING *
),
deleted_external_sharing AS (
    DELETE FROM external_sharing
    WHERE external_sharing.phase_id = $1
    RETURNING *
),
deleted_publish_plan AS (
    DELETE FROM publish_plan
    WHERE publish_plan.publish_listing_id IN (
        SELECT publish_listing.id FROM publish_listing WHERE publish_listing.phase_id = $1
    )
    RETURNING *
),
deleted_publish_gallery AS (
    DELETE FROM publish_gallery
    WHERE publish_gallery.publish_listing_id IN (
        SELECT publish_listing.id FROM publish_listing WHERE publish_listing.phase_id = $1
    )
    RETURNING *
),
deleted_publish_listing AS (
    DELETE FROM publish_listing
    WHERE publish_listing.phase_id = $1
    RETURNING *
)
SELECT
    (SELECT count(*) FROM deleted_internal_sharing) +
    (SELECT count(*) FROM deleted_shared_doc) +
    (SELECT count(*) FROM deleted_external_sharing) +
    (SELECT count(*) FROM deleted_publish_plan) +
    (SELECT count(*) FROM deleted_publish_gallery) +
    (SELECT count(*) FROM deleted_publish_listing) AS total_deleted;



 
-- name: DeleteProjectPropertyRelatedData :execrows
WITH deleted_internal_sharing AS (
    DELETE FROM internal_sharing
    WHERE 
         internal_sharing.is_property = TRUE   AND
         internal_sharing.project_id = (SELECT MAX(project_id) FROM internal_sharing WHERE internal_sharing.property_id = $1)
    RETURNING * 
),
deleted_shared_doc AS (
    DELETE FROM shared_doc
    WHERE 
       shared_doc.is_property = TRUE AND 
       shared_doc.project_id  = (SELECT MAX(project_id) FROM shared_doc WHERE shared_doc.property_id = $1) 
  RETURNING *
),
deleted_external_sharing AS (
    DELETE FROM external_sharing
    WHERE 
        external_sharing.is_property = TRUE AND
        external_sharing.project_id = (SELECT MAX(project_id) FROM external_sharing WHERE external_sharing.property_id = $1)
    RETURNING *
),
deleted_publish_plan AS (
    DELETE FROM publish_plan
    WHERE  
    publish_plan.publish_listing_id IN (
        SELECT publish_listing.id FROM publish_listing 
        WHERE 
            publish_listing.is_property = TRUE AND 
            publish_listing.project_id = (SELECT MAX(project_id) FROM publish_listing WHERE  publish_listing.property_id = $1)
    )
    RETURNING *
),
deleted_publish_gallery AS (
    DELETE FROM publish_gallery
    WHERE publish_gallery.publish_listing_id IN (
        SELECT publish_listing.id FROM publish_listing 
        WHERE 
           publish_listing.is_property = TRUE AND
           publish_listing.project_id = (SELECT MAX(project_id) FROM publish_listing WHERE publish_listing.property_id = $1)
    )
    RETURNING *
),
deleted_publish_listing AS (
    DELETE FROM publish_listing
    WHERE 
    publish_listing.is_property = TRUE AND 
    publish_listing.project_id = (SELECT MAX(project_id) FROM publish_listing WHERE publish_listing.property_id = $1)
    RETURNING *
)
SELECT
    (SELECT count(*) FROM deleted_internal_sharing) +
    (SELECT count(*) FROM deleted_shared_doc) +
    (SELECT count(*) FROM deleted_external_sharing) +
    (SELECT count(*) FROM deleted_publish_plan) +
    (SELECT count(*) FROM deleted_publish_gallery) +
    (SELECT count(*) FROM deleted_publish_listing) AS total_deleted;
-- WITH deleted_internal_sharing AS (
--     DELETE FROM internal_sharing
--     WHERE 
--          internal_sharing.is_property = TRUE   AND
--          internal_sharing.project_id = (SELECT project_id FROM internal_sharing WHERE internal_sharing.property_id = $1)
--     RETURNING * 
-- ),
-- deleted_shared_doc AS (
--     DELETE FROM shared_doc
--     WHERE 
--        shared_doc.is_property = TRUE AND 
--        shared_doc.project_id  = (SELECT project_id FROM shared_doc WHERE shared_doc.property_id = $1) 
--   RETURNING *
-- ),
-- deleted_external_sharing AS (
--     DELETE FROM external_sharing
--     WHERE 
--         external_sharing.is_property = TRUE AND
--         external_sharing.project_id = (SELECT project_id FROM external_sharing WHERE external_sharing.property_id = $1)
--     RETURNING *
-- ),
-- deleted_publish_plan AS (
--     DELETE FROM publish_plan
--     WHERE  
--     publish_plan.publish_listing_id IN (
--         SELECT publish_listing.id FROM publish_listing 
--         WHERE 
--             publish_listing.is_property = TRUE AND 
--             publish_listing.project_id = (SELECT project_id FROM publish_listing WHERE  publish_listing.property_id = $1)
--     )
--     RETURNING *
-- ),
-- deleted_publish_gallery AS (
--     DELETE FROM publish_gallery
--     WHERE publish_gallery.publish_listing_id IN (
--         SELECT publish_listing.id FROM publish_listing 
--         WHERE 
--            publish_listing.is_property = TRUE AND
--            publish_listing.project_id = (SELECT project_id FROM publish_listing WHERE publish_listing.property_id = $1)
--     )
--     RETURNING *
-- ),
-- deleted_publish_listing AS (
--     DELETE FROM publish_listing
--     WHERE 
--     publish_listing.is_property = TRUE AND 
--     publish_listing.project_id = (SELECT project_id FROM publish_listing WHERE publish_listing.property_id = $1)
--     RETURNING *
-- )
-- SELECT
--     (SELECT count(*) FROM deleted_internal_sharing) +
--     (SELECT count(*) FROM deleted_shared_doc) +
--     (SELECT count(*) FROM deleted_external_sharing) +
--     (SELECT count(*) FROM deleted_publish_plan) +
--     (SELECT count(*) FROM deleted_publish_gallery) +
--     (SELECT count(*) FROM deleted_publish_listing) AS total_deleted;


-- name: DeleteProjectPropertyUnitRelatedData :execrows
WITH deleted_internal_sharing AS (
    DELETE FROM internal_sharing
    WHERE internal_sharing.unit_id = $1 AND  internal_sharing.is_unit = TRUE AND internal_sharing.unit_category = $2
    RETURNING * 
),
deleted_shared_doc AS (
    DELETE FROM shared_doc
    WHERE shared_doc.unit_id = $1  AND shared_doc.is_unit = TRUE AND shared_doc.unit_category = $2
    RETURNING *
),
deleted_external_sharing AS (
    DELETE FROM external_sharing
    WHERE external_sharing.unit_id = $1 AND  external_sharing.is_unit = TRUE AND external_sharing.unit_category = $2
    RETURNING *
),
deleted_publish_plan AS (
    DELETE FROM publish_plan
    WHERE publish_plan.publish_listing_id IN (
        SELECT publish_listing.id FROM publish_listing WHERE publish_listing.unit_id = $1  AND publish_listing.is_unit = TRUE AND publish_listing.unit_category  = $2
    )
    RETURNING *
),
deleted_publish_gallery AS (
    DELETE FROM publish_gallery
    WHERE publish_gallery.publish_listing_id IN (
        SELECT publish_listing.id FROM publish_listing WHERE publish_listing.unit_id = $1 AND publish_listing.is_unit = TRUE AND publish_listing.unit_category  = $2
    )
    RETURNING *
),
deleted_publish_listing AS (
    DELETE FROM publish_listing
    WHERE publish_listing.unit_id = $1 AND  publish_listing.is_unit = TRUE AND publish_listing.unit_category = $2
    RETURNING *
)
SELECT
    (SELECT count(*) FROM deleted_internal_sharing) +
    (SELECT count(*) FROM deleted_shared_doc) +
    (SELECT count(*) FROM deleted_external_sharing) +
    (SELECT count(*) FROM deleted_publish_plan) +
    (SELECT count(*) FROM deleted_publish_gallery) +
    (SELECT count(*) FROM deleted_publish_listing) AS total_deleted;


-- name: CreateShareRequest :one
INSERT INTO share_requests (
 document_id,
 request_status,
 requester_id,
 owner_id,
 created_by,
 created_at,
 updated_at

 
) VALUES($1, $2, $3, $4, $5, $6, $7) RETURNING *;





-- name: GetOwnerUserFromPhasesByID :one
SELECT  companies.users_id FROM phases
INNER JOIN projects ON phases.projects_id =  projects.id
INNER JOIN companies ON projects.developer_companies_id = companies.id
WHERE phases.id = $1;


-- name: GetOwnerUserFromProjectByID :one
SELECT companies.users_id FROM projects
INNER JOIN companies ON projects.developer_companies_id = companies.id
WHERE projects.id = $1;


-- name: GetOwnerUserFromProjectPropertyByID :one
SELECT companies.users_id from project_properties
INNER JOIN projects ON project_properties.projects_id =  projects.id
INNER JOIN companies ON projects.developer_companies_id = companies.id
WHERE project_properties.id = $1;


-- TODO: need todo it for other properties also

-- name: GetOwnerUserFromUnitByID :one
SELECT units.owner_users_id from units
WHERE id = $1;
 




 --------------------------------------- Start Sharing  -------------------------------------------------------

-- name: CreateSharing :one
INSERT INTO sharing(
  sharing_type,
  entity_type_id,
  entity_id,
  shared_to,
  is_enabled,
  country_id,
  created_at,
  created_by
)VALUES (
   $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;




-- name: GetSharing :one
SELECT * FROM sharing
WHERE sharing_type = @sharing_type AnD entity_type_id = @entity_type_id 
AnD entity_id = @entity_id AnD 
 CASE WHEN @country_id=0 THEN true ELSE country_id = @country_id END
AND shared_to = @shared_to;



--------------------------------------- End Sharing  -------------------------------------------------------


--------------------------------------- New Sharing  Queries -----------------------------------------------

-- name: GetSharingEntityIDsByEntityType :many
SELECT *
FROM sharing s
LEFT JOIN projects p ON (
    s.entity_id = p.id 
    AND s.entity_type_id = @entity_type_id
)
LEFT JOIN companies c ON (
    p.developer_companies_id = c.id 
    AND s.entity_type_id = @entity_type_id
)
LEFT JOIN phases ph ON (
    s.entity_id = ph.id 
    AND s.entity_type_id = @entity_type_id
)

LEFT JOIN property_versions pv ON (
    s.entity_id = pv.id 
    AND s.entity_type_id = @entity_type_id
)
LEFT JOIN property ON pv.property_id = property.id
LEFT JOIN unit_versions uv ON (
    s.entity_id = uv.id 
    AND s.entity_type_id = @entity_type_id
)
WHERE 
((s.entity_type_id = @entity_type_id AND p.id IS NOT NULL)
    OR 
    (s.entity_type_id = @entity_type_id AND ph.id IS NOT NULL)
    OR
    (s.entity_type_id = @entity_type_id AND pv.id IS NOT NULL))
    AND (
        (@search = '%%')
        OR p.project_name ILIKE @search
        OR p.ref_number ILIKE @search
        OR c.company_name ILIKE @search
        OR (p.facts->>'completion_percentage')::TEXT ILIKE @search
        OR ph.phase_name ILIKE @search
        OR property.property_name ILIKE @search
        OR uv.title ILIKE @search
    )
    AND CASE 
        WHEN @created_by::bigint = 0 THEN true 
        ELSE s.created_by = @created_by::bigint 
    END
    AND CASE 
        WHEN @user_id::bigint = 0 THEN true 
        ELSE s.shared_to = @user_id::bigint 
    END
    AND s.entity_type_id = @entity_type_id
LIMIT $1 OFFSET $2;
-- SELECT * FROM sharing
-- WHERE
--  CASE WHEN @created_by::bigint=0 THEN true ELSE sharing.created_by = @created_by::bigint END
--  AND CASE WHEN @user_id::bigint=0 THEN true ELSE sharing.shared_to = @user_id::bigint END
-- AND sharing.entity_type_id = @entity_type_id LIMIT $1 OFFSET $2;


-- name: GetASharing :one
SELECT * FROM sharing 
WHERE sharing.entity_type_id = @entity_type_id AND sharing.entity_id = @entity_id LIMIT 1;


-- name: GetAllSharingByEntityIDAndType :many
SELECT * FROM sharing 
WHERE sharing.entity_type_id = @entity_type_id AND sharing.entity_id = @entity_id;


 
-- name: DeleteASharing :one
WITH sharing_to_delete AS (
    -- First identify the sharing records we want to delete
    SELECT id FROM sharing 
    WHERE sharing.entity_id = $1 AND sharing.entity_type_id = $2
),
documents_to_delete AS (
    -- Find related shared_documents
    SELECT id FROM shared_documents 
    WHERE sharing_id IN (SELECT id FROM sharing_to_delete)
),
-- First delete the share_requests
delete_requests AS (
    DELETE FROM share_requests
    WHERE document_id IN (SELECT id FROM documents_to_delete)
),
-- Then delete the shared_documents
delete_documents AS (
    DELETE FROM shared_documents
    WHERE sharing_id IN (SELECT id FROM sharing_to_delete)
)
-- Finally delete the sharing record
DELETE FROM sharing 
WHERE id IN (SELECT id FROM sharing_to_delete)
RETURNING *;

-- name: CountSharingEntityIDsByEntityType :one
SELECT COUNT(*)
FROM sharing s
LEFT JOIN projects p ON (
    s.entity_id = p.id 
    AND s.entity_type_id = @entity_type_id
)
LEFT JOIN companies c ON (
    p.developer_companies_id = c.id 
    AND s.entity_type_id = @entity_type_id
)
LEFT JOIN phases ph ON (
    s.entity_id = ph.id 
    AND s.entity_type_id = @entity_type_id
)

LEFT JOIN property_versions pv ON (
    s.entity_id = pv.id 
    AND s.entity_type_id = @entity_type_id
)

LEFT JOIN property ON pv.property_id = property.id

LEFT JOIN unit_versions uv ON (
    s.entity_id = uv.id 
    AND s.entity_type_id = @entity_type_id
)
WHERE 
   ((s.entity_type_id = @entity_type_id AND p.id IS NOT NULL)
    OR 
    (s.entity_type_id = @entity_type_id AND ph.id IS NOT NULL)
    OR
    (s.entity_type_id = @entity_type_id AND pv.id IS NOT NULL))
    AND (
        (@search = '%%')
        OR p.project_name ILIKE @search
        OR p.ref_number ILIKE @search
        OR c.company_name ILIKE @search
        OR (p.facts->>'completion_percentage')::TEXT ILIKE @search
        OR ph.phase_name ILIKE @search
        OR property.property_name ILIKE @search
        OR uv.title ILIKE @search
    )
    AND CASE 
        WHEN @created_by::bigint = 0 THEN true 
        ELSE s.created_by = @created_by::bigint 
    END
    AND CASE 
        WHEN @user_id::bigint = 0 THEN true 
        ELSE s.shared_to = @user_id::bigint 
    END
AND s.entity_type_id = @entity_type_id;




-- name: GetSharedProject :many 
WITH project_ids AS (
    SELECT unnest(@project_id::bigint[]) AS id, row_number() OVER () AS rn
),
project_reviews AS (
    SELECT 
        er.entity_id,
        COALESCE(rt.review_term, '') as review_term,
        -- COALESCE(rt.review_term_ar, '') as review_term_ar,
        COALESCE(r.review_value, 0) as review_value
    FROM entity_review er
    LEFT JOIN reviews_table r ON r.entity_review_id = er.id
    LEFT JOIN review_terms rt ON rt.id = r.review_term_id
    WHERE er.entity_type_id = (SELECT id FROM entity_type WHERE name = 'project')
)
SELECT 
    p.id,
    p.ref_number,
    p.project_name,
    p.is_multiphase,
    p.description,
    p.addresses_id,
    c.company_name,
    COALESCE(MAX(CASE WHEN pr.review_term = 'items' THEN pr.review_value END), 0)::FLOAT as project_clean,
    COALESCE(MAX(CASE WHEN pr.review_term = 'location' THEN pr.review_value END), 0)::FLOAT as project_location,
    COALESCE(MAX(CASE WHEN pr.review_term = 'facilities' THEN pr.review_value END), 0)::FLOAT as project_facilities,
    COALESCE(MAX(CASE WHEN pr.review_term = 'securities' THEN pr.review_value END), 0)::FLOAT as project_securities,
    COALESCE((p.facts->>'completion_percentage')::int, 0)::bigint as completion_percentage,
    COALESCE((p.facts->>'completion_status')::int, 0)::bigint as completion_status,
    (SELECT COUNT(*) FROM phases ph WHERE ph.projects_id = p.id) AS no_of_phases
FROM projects p
CROSS JOIN project_ids pi
LEFT JOIN companies c ON p.developer_companies_id = c.id
LEFT JOIN project_reviews pr ON pr.entity_id = p.id
WHERE p.id = pi.id
GROUP BY 
    p.id,
    p.ref_number,
    p.project_name,
    p.is_multiphase,
    p.description,
    p.addresses_id,
    c.company_name,
    pi.rn
ORDER BY pi.rn;

-- name: GetSharedPhases :many
WITH phase_reviews AS (
    SELECT 
        er.entity_id as phase_id,
        COALESCE(rt.review_term, '') as review_term,
        -- COALESCE(rt.review_term_ar, '') as review_term_ar,
        COALESCE(r.review_value, 0) as review_value
    FROM entity_review er
    LEFT JOIN reviews_table r ON r.entity_review_id = er.id
    LEFT JOIN review_terms rt ON rt.id = r.review_term_id
    WHERE er.entity_type_id = (SELECT id FROM entity_type WHERE name = 'phase')
)
SELECT 
    p.id as phase_id,
    p.projects_id,
    p.phase_name,
    COALESCE(MAX(CASE WHEN pr.review_term = 'items' THEN pr.review_value END), 0)::FLOAT as phase_clean,
    COALESCE(MAX(CASE WHEN pr.review_term = 'location' THEN pr.review_value END), 0)::FLOAT as phase_location,
    COALESCE(MAX(CASE WHEN pr.review_term = 'facilities' THEN pr.review_value END), 0)::FLOAT as phase_facilities,
    COALESCE(MAX(CASE WHEN pr.review_term = 'securities' THEN pr.review_value END), 0)::FLOAT as phase_securities,
    COALESCE((p.facts->>'completion_percentage')::int, 0)::bigint as completion_percentage,
    COALESCE((p.facts->>'completion_status')::int, 0)::bigint as completion_status
FROM phases p
LEFT JOIN phase_reviews pr ON pr.phase_id = p.id
WHERE p.id = ANY(@phase_id::bigint[])
GROUP BY 
    p.id,
    p.projects_id,
    p.phase_name
ORDER BY p.projects_id;



-- name: GetSharedProperty :many
SELECT * FROM property_versions
INNER JOIN property ON property_versions.property_id = property.id
-- WHERE property.id = ANY(@property_id::bigint[]);
WHERE property_versions.id = ANY(@property_versions_id::bigint[]);


-- name: GetSharedUnit :many
SELECT * FROM unit_versions 
INNER JOIN  units ON unit_versions.unit_id = units.id
WHERE unit_versions.id = ANY(@units_id::bigint[]);



-- name: GetAllSharedDocumentsByEntityTypeAndEntityID :many
SELECT *  FROM shared_documents
INNER JOIN sharing ON sharing.id = shared_documents.sharing_id
WHERE 
   CASE WHEN @created_by=0 THEN true ELSE sharing.created_by = @created_by END
   AND CASE WHEN @shared_to=0 THEN true ELSE sharing.shared_to = @shared_to END 
AND sharing.entity_type_id = @entity_type_id AND sharing.entity_id = @entity_id; 


-- name: GetShareRequestByRequestorAndDocID :one
SELECT * FROM share_requests
WHERE document_id = @document_id AND requester_id = @requester_id;


-- name: GetAllUserFromSharing :many
SELECT DISTINCT ON  (users.id) sharing.shared_to, sharing.country_id, sharing.is_enabled, sharing.sharing_type,
 profiles.first_name ,profiles.last_name, profiles.profile_image_url
 FROM sharing
INNER JOIN users ON sharing.shared_to = users.id
INNER JOIN profiles ON users.id = profiles.users_id
Where sharing.sharing_type = 1 AND sharing.entity_id = @entity_id;


-- name: GetAllCompanyFromSharing :many
SELECT DISTINCT ON  (companies.id) sharing.shared_to, sharing.country_id, sharing.is_enabled, sharing.sharing_type,
	companies.company_name, companies.logo_url, countries.country, countries."flag"
FROM sharing
INNER JOIN companies ON sharing.shared_to = companies.id
LEFT JOIN countries ON sharing.country_id = countries.id
Where sharing.sharing_type = 2 AND sharing.entity_id = @entity_id;


 

-- name: UpdateAllShareDoc :many
Update shared_documents
SET is_allowed = $1
WHERE id = ANY(@docs_id::bigint[])
RETURNING *;

-- name: GetAllSharedDocsBySharingId :many
SELECT shared_documents.*  FROM shared_documents
INNER JOIN sharing ON sharing.id = shared_documents.sharing_id
WHERE sharing.id = $1;

-- name: CheckIsValidToShare :one
SELECT CASE 
    WHEN @entity_type_id::bigint = 1 THEN EXISTS( 
        SELECT 1
        FROM projects
        WHERE id = @entity_id::bigint AND status NOT IN (5, 6)
        AND (
        	SELECT NOT EXISTS (
                SELECT 1 FROM sharing
                WHERE entity_id = @entity_id::bigint 
                AND entity_type_id = 1
                AND shared_to = @shared_to::bigint
              )
          ) 
    )
    WHEN @entity_type_id::bigint = 2 THEN EXISTS( 
        SELECT 1
        FROM phases
        WHERE id = @entity_id::bigint AND status NOT IN (5, 6)
        AND (
        	SELECT NOT EXISTS (
                SELECT 1 FROM sharing
                WHERE entity_id = @entity_id::bigint 
                AND entity_type_id = 2
                AND shared_to = @shared_to::bigint
              )
          ) 
    )
    WHEN @entity_type_id::bigint = 14 THEN EXISTS(
        SELECT 1
        FROM unit_versions
        INNER JOIN units ON unit_versions.unit_id = units.id
        WHERE unit_versions.id = @entity_id::bigint 
        AND unit_versions.status NOT IN (5, 6)
        AND units.status NOT IN (5, 6)
        AND (
        	SELECT 
              NOT EXISTS ( -- if directly share
                SELECT 1 FROM sharing
                WHERE entity_id = @entity_id::bigint 
                AND entity_type_id = 14
                AND shared_to = @shared_to::bigint
                AND CASE WHEN @exclude_id::bigint = 0::bigint THEN TRUE ELSE id != @exclude_id::bigint END
              ) 
              AND
              NOT EXISTS (
                SELECT 1 FROM sharing_entities
                INNER JOIN sharing ON sharing.id = sharing_entities.sharing_id
                WHERE sharing_entities.entity_id = @entity_id::bigint 
                AND sharing_entities.entity_type = 14
                AND sharing.shared_to = @shared_to::bigint
              ) 
        	)
    )
    WHEN @entity_type_id::bigint = 15 THEN EXISTS(
        SELECT 1
        FROM property_versions
        INNER JOIN property ON property_versions.property_id = property.id
        WHERE property_versions.id = @entity_id::bigint 
        AND property_versions.status NOT IN (5, 6)
        AND property.status NOT IN (5, 6)
        AND (
        	SELECT 
        		  NOT EXISTS ( -- if directly share
                SELECT 1 FROM sharing
                WHERE entity_id = @entity_id::bigint 
                AND entity_type_id = 15
                AND shared_to = @shared_to::bigint 
                AND CASE WHEN @exclude_id::bigint = 0::bigint THEN TRUE ELSE id != @exclude_id::bigint END
              ) 
              AND    			
              NOT EXISTS (
                SELECT 1 FROM sharing_entities
                INNER JOIN sharing ON sharing.id = sharing_entities.sharing_id
                WHERE sharing_entities.entity_id = @entity_id::bigint 
                AND sharing_entities.entity_type = 15
                AND sharing.shared_to = @shared_to::bigint
              )  
        	)
    )
END::boolean AS is_valid_to_share;