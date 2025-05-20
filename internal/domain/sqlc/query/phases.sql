-- name: CreatePhases :one
INSERT INTO phases (
    phase_name,
    created_at,
    updated_at,
    status,
    live_status,
    ref_no,
    projects_id,
    addresses_id,
    rating,
    description,
    description_ar,
    polygon_coords,
    facts,
    bank_name,
    registration_date,
    escrow_number
)VALUES (
    $1 , $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13,$14, $15, $16
) RETURNING *;

-- name: GetPhases :one
SELECT * FROM phases 
WHERE id = $1 LIMIT $1;

-- name: GetPhaseExceptDeletedAndBlocked :one
SELECT * FROM phases 
WHERE id = $1 AND (status != 5 AND status != 6) LIMIT 1;

-- name: GetAllPhases :many
SELECT * FROM phases
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdatePhases :one
UPDATE phases
SET phase_name = $2,
    created_at = $3,
    updated_at = $4,
    status = $5,
    live_status = $6,
    ref_no = $7,
    projects_id = $8,
    addresses_id = $9,
    
    rating = $10,
    facts=$11,
    description = $12,
    description_ar = $13,
    polygon_coords = $14,
    bank_name=$15,
    registration_date=$16,
    escrow_number=$17
Where id = $1
RETURNING *;


-- name: DeletePhases :exec
DELETE FROM phases
Where id = $1;

-- name: GetAllPhasesByProject :many
SELECT
	phases.*
FROM
	phases
    LEFT JOIN projects ON projects.id = phases.projects_id
	LEFT JOIN addresses ON addresses.id = phases.addresses_id
    LEFT JOIN countries ON countries.id = addresses.countries_id
    LEFT JOIN states ON states.id = addresses.states_id
    LEFT JOIN cities ON cities.id = addresses.cities_id
    LEFT JOIN communities ON communities.id = addresses.communities_id
    LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
WHERE
    -- Search criteria
    (@search = '%%' OR 
     projects.project_name % @search OR 
      phases.phase_name % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     communities.community % @search OR 
     sub_communities.sub_community % @search  
       OR (CASE 
         WHEN 'ready' ILIKE @search THEN (phases.facts->>'completion_status')::BIGINT = 5
        WHEN 'off plan'ILIKE @search  THEN (phases.facts->>'completion_status')::BIGINT = 4
        WHEN '^[0-9]+$' ~ @search  THEN (phases.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft'ILIKE @search  THEN projects.status = 1
        WHEN 'available'ILIKE @search  THEN projects.status = 2
        WHEN 'block'ILIKE @search  THEN projects.status = 5
        WHEN 'single'ILIKE @search  THEN projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN projects.is_multiphase = true 
        ELSE FALSE
      END)
      )
     -- Company and branch permissions
     AND (
        @is_company_user::BOOLEAN != true
        OR (
            (@company_branch != false OR projects.developer_companies_id = @company_id::bigint)
            AND (@company_branch != true OR projects.developer_company_branches_id = @company_id::bigint)
        )
    )
    -- Location filters
    AND (@country_id::bigint = 0 OR addresses.countries_id = @country_id::bigint)
    -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
    -- AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
    -- AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
    -- AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint)
	AND projects.id = $3 AND (phases.status != 5 AND phases.status != 6)
ORDER BY
	phases.created_at DESC
LIMIT $1 OFFSET $2;




-- name: GetCountAllPhasesByProject :one
SELECT
	COUNT(phases.id)
FROM
	phases
   LEFT JOIN projects ON projects.id = phases.projects_id
	--INNER JOIN phases_facts ON phases.id = phases_facts.phases_id
	LEFT JOIN addresses ON addresses.id = phases.addresses_id
    LEFT JOIN countries ON countries.id = addresses.countries_id
    LEFT JOIN states ON states.id = addresses.states_id
    LEFT JOIN cities ON cities.id = addresses.cities_id
    LEFT JOIN communities ON communities.id = addresses.communities_id
    LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
WHERE
    -- Search criteria
    (@search = '%%' OR 
     projects.project_name % @search OR 
      phases.phase_name % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     communities.community % @search OR 
     sub_communities.sub_community % @search  
       OR (CASE 
        WHEN 'ready' ILIKE @search THEN (phases.facts->>'completion_status')::BIGINT = 5
        WHEN 'off plan'ILIKE @search  THEN (phases.facts->>'completion_status')::BIGINT = 4
        WHEN '^[0-9]+$' ~ @search  THEN (phases.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft'ILIKE @search  THEN projects.status = 1
        WHEN 'available'ILIKE @search  THEN projects.status = 2
        WHEN 'block'ILIKE @search  THEN projects.status = 5
        WHEN 'single'ILIKE @search  THEN projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN projects.is_multiphase = true 
        ELSE FALSE
      END)
      )
     -- Company and branch permissions
     AND (
        @is_company_user::BOOLEAN != true
        OR (
            (@company_branch != false OR projects.developer_companies_id = @company_id::bigint)
            AND (@company_branch != true OR projects.developer_company_branches_id = @company_id::bigint)
        )
    )
    -- Location filters
    AND (@country_id::bigint = 0 OR addresses.countries_id = @country_id::bigint)
    -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
  --  AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
  --  AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
   -- AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint)


 AND projects.id = $1 AND (phases.status != 5 AND phases.status != 6);


-- name: GetPhaseByNameAndProjectId :one
SELECT * FROM phases WHERE phase_name ILIKE $1 AND projects_id = $2;

-- name: UpdatePhaseByStatus :one
UPDATE phases SET status = $2 WHERE id = $1 RETURNING *;


-- name: GetPhaseByProjectIdAndPhase :one
SELECT * FROM phases
WHERE phases.id = $1 AND phases.projects_id = $2;

-- name: GetAllPhasesByStatus :many
SELECT phases.*,projects.project_name, addresses.full_address,coalesce(companies.company_name, '')::VARCHAR as "company_name"
FROM phases
    LEFT JOIN projects ON projects.id = phases.projects_id
    LEFT JOIN companies ON companies.id=projects.developer_companies_id
	LEFT JOIN addresses ON addresses.id = phases.addresses_id
    LEFT JOIN countries ON countries.id = addresses.countries_id
    LEFT JOIN states ON states.id = addresses.states_id
    LEFT JOIN cities ON cities.id = addresses.cities_id
    LEFT JOIN communities ON communities.id = addresses.communities_id
    LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
WHERE 
    -- Search criteria
    (@search = '%%' OR 
     projects.project_name % @search OR 
      phases.phase_name % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     communities.community % @search OR 
     sub_communities.sub_community % @search  
       OR (CASE 
        WHEN 'ready' ILIKE @search THEN (phases.facts->>'completion_status')::BIGINT = 5
        WHEN 'off plan'ILIKE @search  THEN (phases.facts->>'completion_status')::BIGINT = 4
        WHEN '^[0-9]+$' ~ @search  THEN (phases.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft'ILIKE @search  THEN projects.status = 1
        WHEN 'available'ILIKE @search  THEN projects.status = 2
        WHEN 'block'ILIKE @search  THEN projects.status = 5
        WHEN 'single'ILIKE @search  THEN projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN projects.is_multiphase = true 
        ELSE FALSE
      END)
      )
     -- Company and branch permissions
     AND (
        @is_company_user != true
        OR (
            (@company_branch != false OR projects.developer_companies_id = @company_id::bigint)
            AND (@company_branch != true OR projects.developer_company_branches_id = @company_id::bigint)
        )
    )

    -- Location filters
    AND (@country_id::bigint = 0 OR addresses.countries_id = @country_id::bigint)
    -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
    AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
    AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
    AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint)
    
AND phases.status = $3
ORDER BY phases.created_at DESC 
LIMIT $1 OFFSET $2;

 

-- name: GetCountAllPhasesByStatus :one
SELECT 
	COUNT(phases.id)
FROM phases
    LEFT JOIN projects ON projects.id = phases.projects_id
	LEFT JOIN addresses ON addresses.id = phases.addresses_id
    LEFT JOIN countries ON countries.id = addresses.countries_id
    LEFT JOIN states ON states.id = addresses.states_id
    LEFT JOIN cities ON cities.id = addresses.cities_id
    LEFT JOIN communities ON communities.id = addresses.communities_id
    LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id 
WHERE 
 -- Search criteria
    (@search = '%%' OR 
     projects.project_name % @search OR 
      phases.phase_name % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     communities.community % @search OR 
     sub_communities.sub_community % @search  
       OR (CASE 
        WHEN 'ready' ILIKE @search THEN (phases.facts->>'completion_status')::BIGINT = 5
        WHEN 'off plan'ILIKE @search  THEN (phases.facts->>'completion_status')::BIGINT = 4
        WHEN '^[0-9]+$' ~ @search  THEN (phases.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft'ILIKE @search  THEN projects.status = 1
        WHEN 'available'ILIKE @search  THEN projects.status = 2
        WHEN 'block'ILIKE @search  THEN projects.status = 5
        WHEN 'single'ILIKE @search  THEN projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN projects.is_multiphase = true 
        ELSE FALSE
      END)
      )
     -- Company and branch permissions
     AND (
        @is_company_user != true
        OR (
            (@company_branch != false OR projects.developer_companies_id = @company_id::bigint)
            AND (@company_branch != true OR projects.developer_company_branches_id = @company_id::bigint)
        )
    )
    -- Location filters
    AND (@country_id::bigint = 0 OR addresses.countries_id = @country_id::bigint)
    -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
    AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
    AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
    AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint)
 AND phases.status = $1;




-- name: GetAllSharedPhasesByIds :many
SELECT phases.id,phases.ref_no,phases.phase_name,
projects.project_name,
developer_companies.company_name
FROM phases
LEFT JOIN projects ON projects.id = phases.projects_id
LEFT JOIN developer_companies ON developer_companies.id = projects.developer_companies_id
WHERE phases.id = ($1::bigint[]);

-- name: GetPhaseName :one
SELECT phase_name FROM phases 
WHERE id = $1;


-- name: GetPhasesByProjectID :many
SELECT
    phases.id
FROM
    phases
    INNER JOIN projects ON projects.id = @project_id :: BIGINT
    AND projects.status != 6
WHERE
     phases.projects_id = @project_id :: BIGINT
    AND phases.status != 6;