-- name: CreateProject :one
INSERT INTO projects (
    project_name,
    ref_number,
    no_of_views,
    is_verified,
    project_rank,
    addresses_id,
    status,
    developer_companies_id,
    developer_company_branches_id,
    countries_id,
    created_at,
    updated_at,
    is_multiphase,
    live_status,
    project_no,
    license_no,
    users_id,
    description,
    description_arabic,
    rating,
    polygon_coords, 
    facts,
    bank_name,
    registration_date,
    escrow_number
)VALUES (
    $1 ,$2,$3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22,$23, $24, $25
) RETURNING *;

-- name: GetProject :one
SELECT * FROM projects 
WHERE id = $1 LIMIT 1;

-- name: GetAllSharedProjectsByIds :many
WITH project_ids AS (
    SELECT unnest($1::bigint[]) AS id, row_number() OVER () AS rn
)
SELECT p.id, p.ref_number, p.project_name, p.is_multiphase, p.description, p.addresses_id,
       dc.company_name, pr.project_clean, pr.project_location, pr.project_facilities,
       pr.project_securities, pf.completion_percentage, pf.completion_status,p.bank_name, p.registration_date, p.escrow_number,
       (SELECT COUNT(*) FROM phases ph WHERE ph.projects_id = p.id) AS no_of_phases
FROM projects p
CROSS JOIN project_ids pi
LEFT JOIN developer_companies dc ON p.developer_companies_id = dc.id
LEFT JOIN project_reviews pr ON pr.projects_id = p.id
LEFT JOIN properties_facts pf ON pf.project_id = p.id AND pf.is_project_fact = TRUE
WHERE p.id = pi.id
ORDER BY pi.rn;
-- SELECT p.id, p.ref_number, p.project_name, p.is_multiphase, p.description, p.addresses_id,
--        dc.company_name, pr.project_clean, pr.project_location, pr.project_facilities, pr.project_securities,
--        pf.completion_percentage, (SELECT COUNT(*) FROM phases ph WHERE ph.projects_id = p.id) AS no_of_phases
-- FROM projects p
-- CROSS JOIN LATERAL UNNEST($1::bigint[]) AS arr(value)
-- LEFT JOIN developer_companies dc ON p.developer_companies_id = dc.id
-- LEFT JOIN project_reviews pr ON pr.projects_id = p.id
-- LEFT JOIN properties_facts pf ON pf.project_id = p.id AND pf.is_project_fact = TRUE
-- WHERE p.id = arr.value;



-- name: GetAllSharedProjectPropertyByIds :many
WITH project_property_ids AS (
  SELECT unnest($1::bigint[]) AS id,
         row_number() OVER () AS rn
)
SELECT p.id, p.ref_no, p.is_multiphase, p.phases_id, p.projects_id, p.property_name
FROM project_properties p
CROSS JOIN project_property_ids ppi
WHERE p.id = ppi.id
ORDER BY ppi.rn;



-- -- name: GetAllSharedProjectPropertyUnitByPropertyID :many
-- WITH unit_ids AS (
--   SELECT unnest($1::bigint[]) AS id,
--          row_number() OVER () AS rn
-- )
-- SELECT u.id, u.ref_no, u.properties_id
-- FROM units u
-- CROSS JOIN unit_ids ui
-- WHERE u.id = ui.id
-- ORDER BY ui.rn;
-- SELECT 
--     u.id, 
--     u.ref_no,
--     u.properties_id
-- FROM units u
-- WHERE u.id = ANY($1::bigint[]);

-- name: GetProjectExceptDeletedAndBlocked :one
SELECT * FROM projects 
WHERE id = $1 AND (status != 5 AND status != 6) LIMIT 1;


-- name: GetProjectByCountryId :many
SELECT * FROM projects 
WHERE countries_id = $3 AND (status != 5 AND status != 6)  ORDER BY id  LIMIT $1 OFFSET $2;




-- name: GetProjectNotEqualToCountryId :many
SELECT DISTINCT 
    projects.*, addresses.full_address, companies.company_name
FROM projects
INNER JOIN addresses ON projects.addresses_id = addresses.id 
INNER JOIN countries ON addresses.countries_id = countries.id  
INNER JOIN states ON addresses.states_id = states.id   
INNER JOIN cities ON addresses.cities_id = cities.id
LEFT JOIN communities ON addresses.communities_id = communities.id 
LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
INNER JOIN companies ON projects.developer_companies_id = companies.id    
--INNER JOIN properties_facts ON projects.id = properties_facts.project_id AND properties_facts.is_project_fact = true   
WHERE
	(CASE WHEN @company_id::bigint=0 then true else companies.id= @company_id::bigint END)
	AND 
    -- Search criteria
    (@search = '%%' OR 
     projects.project_name % @search OR 
     projects.ref_number % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     communities.community % @search OR 
     sub_communities.sub_community % @search OR
     (projects.facts->>'starting_price')::TEXT % @search OR
     companies.company_name % @search  
       OR (CASE 
        WHEN 'ready' ILIKE @search THEN (projects.facts->>'completion_status')::BIGINT  = 5
        WHEN 'off plan'ILIKE @search  THEN (projects.facts->>'completion_status')::BIGINT= 4
        WHEN '^[0-9]+$' ~ @search  THEN (projects.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft'ILIKE @search  THEN projects.status = 1
        WHEN 'available'ILIKE @search  THEN projects.status = 2
        WHEN 'block'ILIKE @search  THEN projects.status = 5
        WHEN 'single'ILIKE @search  THEN projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN projects.is_multiphase = true 
        ELSE FALSE
      END)
      )
--      -- Company and branch permissions
--      AND (
--         @is_company_user != true
--         OR (
--             (@company_branch != false OR projects.developer_companies_id = @company_id::bigint)
--             AND (@company_branch != true OR projects.developer_company_branches_id = @company_id::bigint)
--         )
--     )

    -- Location filters
    AND (@country_id::bigint = 0 OR addresses.countries_id != @country_id::bigint)
--     -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
--     AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
--     AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
--     AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint)

    -- Status filter
    AND projects.status NOT IN (5,6)  
ORDER BY projects.created_at DESC
LIMIT $1 OFFSET $2;


-- name: GetProjectByStatusId :many
SELECT projects.*, addresses.full_address,companies.company_name
FROM projects
INNER JOIN addresses ON projects.addresses_id = addresses.id 
LEFT JOIN countries ON addresses.countries_id = countries.id  
LEFT JOIN states ON addresses.states_id = states.id   
LEFT JOIN cities ON addresses.cities_id = cities.id
LEFT JOIN communities ON addresses.communities_id = communities.id 
LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
LEFT JOIN companies ON projects.developer_companies_id = companies.id    
-- LEFT JOIN properties_facts ON projects.id = properties_facts.project_id AND properties_facts.is_project_fact = true     
WHERE
	(CASE WHEN @company_id::bigint=0 then true else companies.id= @company_id::bigint END)
	AND 
 -- Search criteria
    (@search = '%%' OR 
     projects.project_name % @search OR 
     projects.ref_number % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     communities.community % @search OR 
     sub_communities.sub_community % @search OR
     (projects.facts->>'starting_price')::TEXT % @search OR
     companies.company_name % @search 
      OR (CASE 
        WHEN 'ready' ILIKE @search THEN (projects.facts->>'completion_status')::BIGINT  = 5
        WHEN 'off plan'ILIKE @search  THEN (projects.facts->>'completion_status')::BIGINT= 4
        WHEN '^[0-9]+$' ~ @search  THEN (projects.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft' ILIKE @search  THEN projects.status = 1
        WHEN 'available'ILIKE @search  THEN projects.status = 2
        WHEN 'block'ILIKE @search  THEN projects.status = 5
        WHEN 'single'ILIKE @search  THEN projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN projects.is_multiphase = true 
        ELSE FALSE
       END)
      )
    -- AND
    -- CASE 
    --     WHEN @is_company_user != true THEN true
    --     WHEN 
    --         CASE 
    --             WHEN @company_branch != false THEN true
    --             ELSE projects.developer_companies_id = @company_id::bigint
    --         END
    --     THEN 
    --         CASE 
    --             WHEN @company_branch != true THEN true
    --             ELSE projects.developer_company_branches_id = @company_id::bigint
    --         END
    --     ELSE false
    -- END
    -- AND CASE WHEN @country_id::bigint = 0 THEN true ELSE addresses.countries_id = @country_id::bigint END
    -- AND CASE WHEN @city_id::bigint = 0 THEN true ELSE addresses.cities_id = @city_id::bigint END
    -- AND CASE WHEN @community_id::bigint = 0 THEN true ELSE addresses.communities_id = @community_id::bigint END
    -- AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_community_id::bigint END
    AND projects.status = @status
ORDER BY projects.updated_at DESC LIMIT $1 OFFSET $2;

-- name: GetProjectByName :one
SELECT * FROM projects 
WHERE project_name = $2 LIMIT $1;


-- name: GetAllProject :many
SELECT * FROM projects
ORDER BY id
LIMIT $1
OFFSET $2;


-- name: GetAllProjectByCompanyIdCount :one
SELECT COUNT(*) from projects
WHERE developer_companies_id = $1 AND (status != 5 AND status != 6)
LIMIT 1;

-- name: GetCountProjects :one
SELECT COUNT(*) from projects;

-- name: GetCountProjectByCounrty :one
SELECT COUNT(*)
FROM projects
INNER JOIN addresses ON projects.addresses_id = addresses.id 
INNER JOIN countries ON addresses.countries_id = countries.id  
INNER JOIN states ON addresses.states_id = states.id   
INNER JOIN cities ON addresses.cities_id = cities.id    
LEFT JOIN communities ON addresses.communities_id = communities.id 
LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
INNER JOIN companies ON projects.developer_companies_id = companies.id    
WHERE
	(CASE WHEN @company_id::bigint= 0 then true else companies.id= @company_id::bigint END)
	AND 
    -- Search criteria
    (@search = '%%' OR 
     projects.project_name % @search OR 
     projects.ref_number % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
      communities.community % @search OR 
     sub_communities.sub_community % @search OR
      (projects.facts->>'starting_price')::TEXT % @search OR
     companies.company_name % @search  
      OR (CASE 
        WHEN 'ready' ILIKE @search THEN (projects.facts->>'completion_status')::BIGINT = 5
        WHEN 'off plan'ILIKE @search  THEN (projects.facts->>'completion_status')::BIGINT = 4
        WHEN '^[0-9]+$' ~ @search  THEN (projects.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft'ILIKE @search  THEN projects.status = 1
        WHEN 'available'ILIKE @search  THEN projects.status = 2
        WHEN 'block'ILIKE @search  THEN projects.status = 5
        WHEN 'single'ILIKE @search  THEN projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN projects.is_multiphase = true 
        ELSE FALSE
      END)
      )
    --  -- Company and branch permissions
    --  AND (
    --     @is_company_user != true
    --     OR (
    --         (@company_branch != false OR projects.developer_companies_id = @company_id::bigint)
    --         AND (@company_branch != true OR projects.developer_company_branches_id = @company_id::bigint)
    --     )
    -- )
    -- Location filters
    AND (@country_id::bigint = 0 OR addresses.countries_id = @country_id::bigint)
    -- -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
    -- AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
    -- AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
    -- AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint)
    -- Status filter
AND projects.status NOT IN (5,6);
 

-- name: GetCountProjectByCountryNotEqual :one
SELECT COUNT(projects.*)
FROM projects
INNER JOIN addresses ON projects.addresses_id = addresses.id 
INNER JOIN countries ON addresses.countries_id = countries.id  
INNER JOIN states ON addresses.states_id = states.id   
INNER JOIN cities ON addresses.cities_id = cities.id
LEFT JOIN communities ON addresses.communities_id = communities.id 
LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
INNER JOIN companies ON projects.developer_companies_id = companies.id    
-- INNER JOIN properties_facts ON projects.id = properties_facts.project_id AND properties_facts.is_project_fact = true   
WHERE
	(CASE WHEN @company_id::bigint= 0 then true else companies.id= @company_id::bigint END)
	AND 
    -- Search criteria
    (@search = '%%' OR 
     projects.project_name % @search OR 
     projects.ref_number % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     communities.community % @search OR 
     sub_communities.sub_community % @search OR
     (projects.facts->>'starting_price')::TEXT % @search OR
     companies.company_name % @search  
       OR (CASE 
        WHEN 'ready' ILIKE @search THEN (projects.facts->>'completion_status')::BIGINT  = 5
        WHEN 'off plan'ILIKE @search  THEN (projects.facts->>'completion_status')::BIGINT= 4
        WHEN '^[0-9]+$' ~ @search  THEN (projects.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft'ILIKE @search  THEN projects.status = 1
        WHEN 'available'ILIKE @search  THEN projects.status = 2
        WHEN 'block'ILIKE @search  THEN projects.status = 5
        WHEN 'single'ILIKE @search  THEN projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN projects.is_multiphase = true 
        ELSE FALSE
      END)
      )
    --  -- Company and branch permissions
    --  AND (
    --     @is_company_user != true
    --     OR (
    --         (@company_branch != false OR projects.developer_companies_id = @company_id::bigint)
    --         AND (@company_branch != true OR projects.developer_company_branches_id = @company_id::bigint)
    --     )
    -- )
    -- Location filters
    AND (@country_id::bigint = 0 OR addresses.countries_id != @country_id::bigint)
    -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
    -- AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
    -- AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
    -- AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint)
    -- Status filter
    AND projects.status NOT IN (5,6);


-- name: GetCountProjectByStatus :one
SELECT COUNT(projects.id)
FROM projects
INNER JOIN addresses ON projects.addresses_id = addresses.id 
LEFT JOIN countries ON addresses.countries_id = countries.id  
LEFT JOIN states ON addresses.states_id = states.id   
LEFT JOIN cities ON addresses.cities_id = cities.id  
LEFT JOIN communities ON addresses.communities_id = communities.id 
LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id  
LEFT JOIN companies ON projects.developer_companies_id = companies.id    
-- LEFT JOIN properties_facts ON projects.id = properties_facts.project_id AND properties_facts.is_project_fact = true 
WHERE
	(CASE WHEN @company_id::bigint=0 then true else companies.id= @company_id::bigint END)
	AND  
-- Search criteria
    (@search = '%%' OR 
     projects.project_name % @search OR 
     projects.ref_number % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     communities.community % @search OR 
     sub_communities.sub_community % @search OR
     (projects.facts->>'starting_price')::TEXT % @search OR
     companies.company_name % @search  
       OR (CASE 
        WHEN 'ready' ILIKE @search THEN (projects.facts->>'completion_status')::BIGINT  = 5
        WHEN 'off plan'ILIKE @search  THEN (projects.facts->>'completion_status')::BIGINT= 4
        WHEN '^[0-9]+$' ~ @search  THEN (projects.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft'ILIKE @search  THEN projects.status = 1
        WHEN 'available'ILIKE @search  THEN projects.status = 2
        WHEN 'block'ILIKE @search  THEN projects.status = 5
        WHEN 'single'ILIKE @search  THEN projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN projects.is_multiphase = true 
        ELSE FALSE
      END)
      )
     -- Company and branch permissions
    -- AND CASE 
    --     WHEN @is_company_user != true THEN true
    --     WHEN 
    --         CASE 
    --             WHEN @company_branch != false THEN true
    --             ELSE projects.developer_companies_id = @company_id::bigint
    --         END
    --     THEN 
    --         CASE 
    --             WHEN @company_branch != true THEN true
    --             ELSE projects.developer_company_branches_id = @company_id::bigint
    --         END
    --     ELSE false
    -- END
    -- AND CASE WHEN @country_id::bigint = 0 THEN true ELSE addresses.countries_id = @country_id::bigint END
    -- AND CASE WHEN @city_id::bigint = 0 THEN true ELSE addresses.cities_id = @city_id::bigint END
    -- AND CASE WHEN @community_id::bigint = 0 THEN true ELSE addresses.communities_id = @community_id::bigint END
    -- AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_community_id::bigint END
AND projects.status  = @status;

 

-- name: GetAllProjectByCompanyId :many
SELECT * FROM projects
Where developer_companies_id = $1 AND (status != 5 AND status != 6)
ORDER BY id
LIMIT $2
OFFSET $3;

-- name: UpdateProject :one
UPDATE projects
SET  project_name = $2,
    ref_number = $3,
    no_of_views = $4,
    is_verified = $5,
    project_rank = $6,
    addresses_id = $7,
    status = $8,
    developer_companies_id = $9,
    developer_company_branches_id = $10,
    countries_id = $11,
    created_at = $12,
    updated_at = $13,
    is_multiphase = $14,
    live_status = $15,
    project_no = $16,
    license_no = $17,
    users_id = $18,
    description = $19,
    description_arabic = $20,
    polygon_coords = $21, 
    facts=$22,
    bank_name=$23,
    registration_date=$24,
    escrow_number=$25
Where id = $1
RETURNING *;


-- name: UpdateProjectTriggerStatus :many
UPDATE trigger_status
SET is_active = true
WHERE table_name IN ('projects', 'addresses', 'properties_facts')
RETURNING *;



-- -- name: DeleteProject :exec
-- DELETE FROM projects
-- Where id = $1;

-- name: UpdateProjectRankInProject :one
UPDATE projects SET project_rank = $2 WHERE id = $1 RETURNING *;

-- name: UpdateProjectVerification :one 
UPDATE projects SET is_verified = $2 WHERE id = $1 RETURNING *;


-- name: GetAllProjectsByRank :many
SELECT * FROM projects 
Where project_rank = $3 ORDER BY id LIMIT $1 OFFSET $2;

-- name: GetCountAllProjectsByRank :one
SELECT COUNT(*) FROM projects 
Where project_rank = $1;

-- name: UpdateProjectLiveStatus :one 
UPDATE projects 
SET live_status = $2 
WHERE projects.id = $1 
RETURNING *;
 

-- name: GetAllProjectsByRanksAndIsVerified :many
SELECT id,project_name,ref_number,no_of_views,is_verified,project_rank,addresses_id,status,developer_companies_id,developer_company_branches_id,countries_id,created_at,updated_at,is_multiphase,live_status,project_no,license_no, bank_name, registration_date, escrow_number
FROM projects WHERE is_verified=$3 AND project_rank  = ANY($4::bigint[])  AND status!=5 AND status!=6 ORDER BY is_verified DESC,CASE project_rank WHEN 4 THEN 1 WHEN 3 THEN 2 WHEN 2 THEN 3 WHEN 1 THEN 4 ELSE 5 END LIMIT $1 OFFSET $2;


-- name: GetAllProjectsForMobile :many
SELECT id,project_name,ref_number,no_of_views,is_verified,project_rank,addresses_id,status,developer_companies_id,developer_company_branches_id,countries_id,created_at,updated_at,is_multiphase,live_status,project_no,license_no,bank_name, registration_date, escrow_number
FROM projects where status!=5 and status!=6 ORDER BY is_verified desc,CASE project_rank WHEN 4 THEN 1 WHEN 3 THEN 2 WHEN 2 THEN 3 WHEN 1 THEN 4 ELSE 5 END limit $1 offset $2;



-- name: GetCountAllProjectsForMobile :one
SELECT COUNT(*) FROM projects where status != 5 and status != 6;

-- name: GetCountAllProjectsByRanksAndIsVerified :one
SELECT COUNT(*) FROM projects where project_rank = ANY($1::bigint[]) and status != 5 and status != 6 AND is_verified = $2;


-- name: GetAllProjectsForMobileIsVerified :many
SELECT id,project_name,ref_number,no_of_views,is_verified,project_rank,addresses_id,status,developer_companies_id,developer_company_branches_id,countries_id,created_at,updated_at,is_multiphase,live_status,project_no,license_no,bank_name, registration_date, escrow_number FROM projects where status!=5 and is_verified=$3 and status!=6 ORDER BY is_verified desc,CASE project_rank WHEN 4 THEN 1 WHEN 3 THEN 2 WHEN 2 THEN 3 WHEN 1 THEN 4 ELSE 5 END limit $1 offset $2;


-- name: GetCountAllProjectsForMobileIsVerified :one
SELECT COUNT(*) FROM projects where status!=5 and is_verified=$1 and status!=6;


-- name: GetAllProjec :many
select id from projects;


-- name: UpdateProjectByStatus :one
UPDATE projects SET status = $2,
updated_at = $3, deleted_at = $4
WHERE id = $1 RETURNING *;

 
 
  

-- name: GetLocalProjects :many
SELECT DISTINCT projects.*, addresses.full_address,companies.company_name
FROM projects
INNER JOIN addresses ON projects.addresses_id = addresses.id 
INNER JOIN countries ON addresses.countries_id = countries.id  
INNER JOIN states ON addresses.states_id = states.id   
INNER JOIN cities ON addresses.cities_id = cities.id
LEFT JOIN communities ON addresses.communities_id = communities.id 
LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
INNER JOIN companies ON projects.developer_companies_id = companies.id    
WHERE
	(CASE WHEN @company_id::bigint= 0 then true else companies.id= @company_id::bigint END)
	AND 
    -- Search criteria
    (@search = '%%' OR 
     projects.project_name % @search OR 
     projects.ref_number % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     communities.community % @search OR 
     sub_communities.sub_community % @search OR
     (projects.facts->>'starting_price')::TEXT % @search OR
     companies.company_name % @search 
      OR (CASE 
        WHEN 'ready' ILIKE @search THEN (projects.facts->>'completion_status')::BIGINT = 5
        WHEN 'off plan'ILIKE @search  THEN (projects.facts->>'completion_status')::BIGINT = 4
        WHEN '^[0-9]+$' ~ @search  THEN (projects.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft' ILIKE @search  THEN projects.status = 1
        WHEN 'available'ILIKE @search  THEN projects.status = 2
        WHEN 'block'ILIKE @search  THEN projects.status = 5
        WHEN 'single'ILIKE @search  THEN projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN projects.is_multiphase = true 
        ELSE FALSE
       END)
      )
    -- --  Company and branch permissions
    --  AND (
    --     @is_company_user != true
    --     OR (
    --         (@company_branch != false OR projects.developer_companies_id = @company_id::bigint)
    --         AND (@company_branch != true OR projects.developer_company_branches_id = @company_id::bigint)
    --     )
    -- )
    -- Location filters
    AND (@country_id::bigint = 0 OR addresses.countries_id = @country_id::bigint)
    -- -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
    -- AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
    -- AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
    -- AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint)
    
    -- Status filter
    AND projects.status NOT IN (5,6)  
ORDER BY projects.created_at DESC
LIMIT $1 OFFSET $2;

 


-- name: GetUserAccessForProject :many
SELECT *
FROM projects p
WHERE
    CASE
        WHEN $3::bigint = 0 THEN true
        WHEN $3::bigint = 1 THEN p.addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $4)
        WHEN $3::bigint = 2 THEN p.addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $4 AND communities_id = ANY($5::bigint[]))
        WHEN $3::bigint = 3 THEN p.addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $4 AND communities_id = ANY($5::bigint[]) AND sub_communities_id = ANY($6::bigint[]))
        WHEN $3::bigint = 4 THEN p.addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $4 AND communities_id = ANY($5::bigint[]) AND sub_communities_id = ANY($6::bigint[]) AND addresses.locations_id = $7)
    END AND
    (status != 5 AND status != 6)
    AND p.id = $8
ORDER BY id LIMIT $1 OFFSET $2;

-- name: GetPromotionsByProjectFilter :many
SELECT pp.*
FROM project_promotions pp
INNER JOIN projects p ON p.id = pp.projects_id 
INNER JOIN addresses a ON a.id = p.addresses_id
WHERE
     a.countries_id = @country_id::bigint
    AND CASE WHEN @city_id::bigint = 0 Then true ELSE a.cities_id = @city_id::bigint END
    AND CASE WHEN @community_id::bigint = 0 THEN true ELSE a.communities_id = @community_id::bigint END
    AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE a.sub_communities_id = @sub_community_id::bigint END
    AND pp.status !=5 AND pp.status != 6
ORDER BY pp.created_at DESC LIMIT $1 OFFSET $2;

-- name: GetCountPromotionsByProjectFilter :one
SELECT COUNT(pp.*)
FROM project_promotions pp
INNER JOIN projects p ON p.id = pp.projects_id 
INNER JOIN addresses a ON a.id = p.addresses_id
WHERE
    a.countries_id = @country_id::bigint
    AND CASE WHEN @city_id::bigint = 0 Then true ELSE a.cities_id = @city_id::bigint END
    AND CASE WHEN @community_id::bigint = 0 THEN true ELSE a.communities_id = @community_id::bigint END
    AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE a.sub_communities_id = @sub_community_id::bigint END
    AND pp.status !=5 AND pp.status != 
    6;
-- SELECT COUNT(pp.*)
-- FROM projects p
-- JOIN project_promotions pp ON p.id = pp.projects_id
-- WHERE
--     CASE
--         WHEN $1::bigint = 0 THEN true
--         WHEN $1::bigint = 1 THEN p.addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2)
--         WHEN $1::bigint = 2 THEN p.addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2 AND communities_id = ANY($3::bigint[]))
--         WHEN $1::bigint = 3 THEN p.addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2 AND communities_id = ANY($3::bigint[]) AND sub_communities_id = ANY($4::bigint[]))
--         WHEN $1::bigint = 4 THEN p.addresses_id IN (SELECT id FROM addresses WHERE addresses.cities_id = $2 AND communities_id = ANY($3::bigint[]) AND sub_communities_id = ANY($4::bigint[]) AND addresses.locations_id = $5)
--     END
--     AND pp.projects_id = p.id;

-- name: GetProjectIdByProjectNo :one
SELECT id FROM projects WHERE project_no = $1 LIMIT 1;

-- name: GetProjectIdByLicenseNo :one
SELECT id FROM projects WHERE license_no = $1 LIMIT 1;

-- name: GetProjectByRefrenceNumber :one
SELECT * FROM projects WHERE ref_number = $1 LIMIT 1;

-- name: GetAllProjectRefrenceNumber :many
SELECT ref_number FROM projects LIMIT $1 OFFSET $2;

-- name: GetAllProjectsRefNo :many
SELECT id,ref_number FROM projects  LIMIT $1 OFFSET $2;

-- name: GetCountAllPropertyPosts :one
SELECT count(*) FROM aqary_property_posts;

-- name: GetProjectsRefNoBySearch :many
SELECT id,ref_number FROM projects WHERE ref_number ILIKE $1;

-- name: GetAllProjectNames :many
SELECT id,project_name FROM projects WHERE is_multiphase = $1 ORDER BY id;


-- name: GetExternalShareByID :one
SELECT * FROM external_sharing WHERE id = @id;

-- name: GetExternalShareByUserIDAndID :one
SELECT * FROM external_sharing WHERE created_by = @users_id and id = @id;



-- name: GetProjectStatusAndVerificationAndRank :one 
SELECT 
status,is_verified,project_rank, project_name
FROM projects 
WHERE id = $1;




-- name: GetProjectsForCities :many
WITH FeaturedCities AS (
    SELECT c.id, c.city
    FROM projects p
    JOIN addresses a ON a.id = p.addresses_id
    JOIN cities c ON a.cities_id = c.id
    GROUP BY c.id, c.city
),
RankedProjects AS (
    SELECT 
        p.*,
        a.cities_id,
        ROW_NUMBER() OVER (PARTITION BY a.cities_id ORDER BY p.created_at DESC) as rn
    FROM projects p
    JOIN addresses a ON a.id = p.addresses_id
    WHERE p.status!=6
)
SELECT 
    fc.id AS city_id, 
    fc.city, 
    json_agg(
        json_build_object(
            'project_id', rp.id,
            'project_name', rp.project_name,
            'ref_number', rp.ref_number,
            'no_of_views', rp.no_of_views,
            'is_verified', rp.is_verified,
            'project_rank', rp.project_rank,
            'addresses_id', rp.addresses_id,
            'status', rp.status,
            'developer_companies_id', rp.developer_companies_id,
            'developer_company_branches_id', rp.developer_company_branches_id,
            'countries_id', rp.countries_id,
            'created_at', rp.created_at,
            'updated_at', rp.updated_at,
            'is_multiphase', rp.is_multiphase,
            'live_status', rp.live_status,
            'project_no', rp.project_no,
            'license_no', rp.license_no,
            'users_id', rp.users_id,
            'facilities_id', rp.facilities_id,
            'amenities_id', rp.amenities_id,
            'description', rp.description,
            'description_arabic', rp.description_arabic,
            'rating', rp.rating
        )
    ) AS project
FROM 
    FeaturedCities fc
JOIN RankedProjects rp ON rp.cities_id = fc.id
WHERE rp.rn <= 6 
GROUP BY 
    fc.id, fc.city
ORDER BY 
    fc.city;

-- name: GetProjectsCountPerFeaturedCity :many
SELECT c.id, c.city, COUNT(p.id) AS project_count
FROM projects p
JOIN addresses a ON a.id = p.addresses_id
JOIN cities c ON a.cities_id = c.id
WHERE p.status!=6
GROUP BY c.id, c.city;

-- name: GetProjectsListForCity :many
WITH PhasesCount AS (
    SELECT
        p.id AS project_id,
        COUNT(ph.*) AS phases_count
    FROM
        projects p
    JOIN phases ph ON ph.projects_id = p.id
    WHERE
        p.is_multiphase = TRUE AND ph.status!=6
    GROUP BY
        p.id
),
PropertiesCount AS (
    SELECT
        p.id AS project_id,
        COUNT(prop.*) AS properties_count
    FROM
        projects p
    JOIN project_properties prop ON prop.projects_id = p.id 
    WHERE  prop.status!=6
    GROUP BY
        p.id
)
SELECT
	sqlc.embed(p),
	sqlc.embed(pf),
	sqlc.embed(c),
	sqlc.embed(co),
	sqlc.embed(s),
	sqlc.embed(com),
	sqlc.embed(scom),
    COALESCE(pm.id, 0) AS media_id,
    COALESCE(pm.file_urls, ARRAY[]::text[]) AS images,
    COALESCE(pc.phases_count, 0) AS phases_count,
    COALESCE(prc.properties_count, 0) AS properties_count
FROM
    projects p
JOIN addresses a ON a.id = p.addresses_id
JOIN cities c ON a.cities_id = c.id
JOIN countries co ON a.countries_id = co.id
JOIN states s ON s.id = a.states_id
JOIN properties_facts pf ON pf.project_id = p.id AND pf.is_project_fact = TRUE
LEFT JOIN communities com ON com.id = a.communities_id
LEFT JOIN sub_communities scom ON scom.id = a.sub_communities_id
LEFT JOIN project_media pm ON pm.projects_id = p.id AND pm.media_type = 1 AND pm.gallery_type = 'Main'
LEFT JOIN PhasesCount pc ON pc.project_id = p.id
LEFT JOIN PropertiesCount prc ON prc.project_id = p.id
WHERE
    c.id = $1 AND p.status != 6
LIMIT $2 OFFSET $3;
 
-- name: GetCountOfProjectsListForCity :one
SELECT count(*)
FROM projects p
JOIN addresses a ON a.id = p.addresses_id
JOIN cities c ON a.cities_id = c.id
WHERE a.cities_id=$1 AND p.status!=6;

-- name: GetProjectName :one
SELECT project_name FROM projects
WHERE id = $1;

-- name: GetAllProjectDetailsWithAdvancedFilter :many
select p.id, p.project_name, pm.id as "image_id", pm.file_urls, pf.starting_price, p.is_verified, p.project_rank, p.rating, p.ref_number, pf.completion_percentage, c.id as "city_id", c.city, com.id as "community_id", com.community, scom.id as "subcommunity_id", scom.sub_community, p.created_at, pf.built_up_area from projects p join properties_facts pf on pf.project_id = p.id and pf.is_project_fact is true
left join addresses a on p.addresses_id = a.id
LEFT JOIN states s on a.states_id = s.id
left join cities c on a.cities_id = c.id
left join communities com on a.communities_id = com.id
left join sub_communities scom on a.sub_communities_id = scom.id
left join project_media pm on p.id = pm.projects_id and pm.gallery_type = 'Main' and pm.media_type = 1
where (pf.starting_price >= @min_price or @disable_min_price) AND (pf.starting_price <= @max_price or @disable_max_price) and (p.is_verified = @is_verified or @disable_is_verified::BOOLEAN) and 
(CASE WHEN ARRAY_LENGTH(@completion_status::BIGINT[], 1) IS NULL THEN TRUE ELSE pf.completion_status = ANY(@completion_status::BIGINT[]) END) AND
(CASE WHEN ARRAY_LENGTH(@project_ranks::BIGINT[], 1) IS NULL THEN TRUE ELSE p.project_rank = ANY(@project_ranks::bigint[]) END) AND p.status!= 6 AND 
s.id = @state_id::bigint AND
(CASE WHEN ARRAY_LENGTH(@keywords::VARCHAR[], 1) IS NULL THEN TRUE ELSE p.ref_number  ILIKE ANY(@keywords::VARCHAR[]) OR p.project_name ILIKE ANY(@keywords::VARCHAR[]) OR p.description ILIKE ANY(@keywords::VARCHAR[]) OR  p.description_arabic ILIKE ANY(@keywords::VARCHAR[]) END) AND
(CASE WHEN ARRAY_LENGTH(@amenities::bigint[], 1) IS NULL THEN TRUE ELSE p.amenities_id && @amenities::bigint[] END) AND
(CASE WHEN ARRAY_LENGTH(@facilities::bigint[], 1) IS NULL THEN TRUE ELSE p.facilities_id && @facilities::bigint[] END) AND
(CASE WHEN COALESCE(@dates::BIGINT,1) =1 THEN true WHEN @dates::BIGINT= 2 THEN p.created_at >= DATE_TRUNC('day', CURRENT_DATE) WHEN @dates::BIGINT = 3 THEN p.created_at >= DATE_TRUNC('week', CURRENT_DATE - INTERVAL '1 week')
	  AND p.created_at < DATE_TRUNC('week', CURRENT_DATE) WHEN @dates::BIGINT = 4 THEN p.created_at >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
	  AND p.created_at < DATE_TRUNC('month', CURRENT_DATE) END) AND 
(CASE WHEN ARRAY_LENGTH(@cities_id::bigint[], 1) IS NULL THEN TRUE ELSE c.id = ANY(@cities_id::bigint[]) END)  AND 
(CASE WHEN ARRAY_LENGTH(@communities_id::bigint[], 1) IS NULL THEN TRUE ELSE com.id = ANY(@communities_id::bigint[])END) AND 
(CASE WHEN ARRAY_LENGTH(@subcommunities_id::bigint[], 1) IS NULL THEN TRUE ELSE scom.id = ANY(@subcommunities_id::bigint[]) END) AND 
(((select count(*) from sale_unit su
left join unit_facts uf on su.unit_facts_id = uf.id
left join units u on su.unit_id = u.id
where 
(CASE WHEN ARRAY_LENGTH(@bedroom::varchar[], 1) IS NULL THEN TRUE ELSE uf.bedroom = ANY(@bedroom::varchar[]) END) AND
(CASE WHEN ARRAY_LENGTH(@bathroom::bigint[], 1) IS NULL THEN TRUE ELSE uf.bathroom = ANY(@bathroom::bigint[]) END) AND
(CASE WHEN @min_plot_area::FLOAT =-1 AND @max_plot_area::FLOAT =-1 THEN true ELSE  uf.plot_area BETWEEN @min_plot_area ::FLOAT AND @max_plot_area::FLOAT END) AND
(CASE WHEN @min_built_up_area::FLOAT =-1 AND  @max_built_up_area::FLOAT =-1 THEN true ELSE uf.built_up_area BETWEEN @min_built_up_area::FLOAT AND @max_built_up_area::FLOAT END) AND
(CASE WHEN ARRAY_LENGTH(@no_of_payment::BIGINT[], 1) IS NULL THEN TRUE ELSE uf.no_of_payment = ANY(@no_of_payment::BIGINT[]) END) AND
(CASE WHEN ARRAY_LENGTH(@ownership::BIGINT[], 1) IS NULL THEN TRUE ELSE uf.ownership = ANY(@ownership::BIGINT[]) END) AND
(CASE WHEN @min_service_charge::BIGINT = -1 AND @max_service_charge::BIGINT =-1 THEN true ELSE uf.service_charge BETWEEN @min_service_charge::BIGINT AND @max_service_charge::BIGINT END) AND
(CASE WHEN ARRAY_LENGTH(@furnished::bigint[], 1) IS NULL THEN TRUE ELSE uf.furnished = ANY(@furnished::bigint[]) END) AND
(CASE WHEN ARRAY_LENGTH(@parking::bigint[], 1) IS NULL THEN TRUE ELSE uf.parking = ANY(@parking::bigint[]) END) AND
(CASE WHEN ARRAY_LENGTH(@view::bigint[], 1) IS NULL THEN TRUE ELSE uf.view && @view::bigint[] END) AND
(CASE WHEN ARRAY_LENGTH(@amenities::bigint[], 1) IS NULL THEN TRUE ELSE u.amenities_id && @amenities::bigint[] END) AND
(CASE WHEN ARRAY_LENGTH(@type_names::bigint[], 1) IS NULL THEN TRUE ELSE u.property_types_id = ANY(@type_names::bigint[]) END) AND 
u.property = 1 AND su.status != 6 AND
u.properties_id IN (select pp.id from project_properties pp where pp.projects_id = p.id)

)
+
(select count(*) from sale_unit su
left join unit_facts uf on su.unit_facts_id = uf.id
left join units u on su.unit_id = u.id
where 
(CASE WHEN ARRAY_LENGTH(@bedroom::varchar[], 1) IS NULL THEN TRUE ELSE uf.bedroom = ANY(@bedroom::varchar[]) END) AND
(CASE WHEN ARRAY_LENGTH(@bathroom::bigint[], 1) IS NULL THEN TRUE ELSE uf.bathroom = ANY(@bathroom::bigint[]) END) AND
(CASE WHEN @min_plot_area::FLOAT =-1 AND @max_plot_area::FLOAT =-1 THEN true ELSE  uf.plot_area BETWEEN @min_plot_area ::FLOAT AND @max_plot_area::FLOAT END) AND
(CASE WHEN @min_built_up_area::FLOAT =-1 AND  @max_built_up_area::FLOAT =-1 THEN true ELSE uf.built_up_area BETWEEN @min_built_up_area::FLOAT AND @max_built_up_area::FLOAT END) AND
(CASE WHEN ARRAY_LENGTH(@no_of_payment::BIGINT[], 1) IS NULL THEN TRUE ELSE uf.no_of_payment = ANY(@no_of_payment::BIGINT[]) END) AND
(CASE WHEN ARRAY_LENGTH(@ownership::BIGINT[], 1) IS NULL THEN TRUE ELSE uf.ownership = ANY(@ownership::BIGINT[]) END) AND
(CASE WHEN @min_service_charge::BIGINT = -1 AND @max_service_charge::BIGINT =-1 THEN true ELSE uf.service_charge BETWEEN @min_service_charge::BIGINT AND @max_service_charge::BIGINT END) AND
(CASE WHEN ARRAY_LENGTH(@furnished::bigint[], 1) IS NULL THEN TRUE ELSE uf.furnished = ANY(@furnished::bigint[]) END) AND
(CASE WHEN ARRAY_LENGTH(@parking::bigint[], 1) IS NULL THEN TRUE ELSE uf.parking = ANY(@parking::bigint[]) END) AND
(CASE WHEN ARRAY_LENGTH(@view::bigint[], 1) IS NULL THEN TRUE ELSE uf.view && @view::bigint[] END) AND
(CASE WHEN ARRAY_LENGTH(@amenities::bigint[], 1) IS NULL THEN TRUE ELSE u.amenities_id && @amenities::bigint[] END) AND
(CASE WHEN ARRAY_LENGTH(@type_names::bigint[], 1) IS NULL THEN TRUE ELSE u.property_types_id = ANY(@type_names::bigint[]) END) AND 
u.property = 1 AND su.status != 6 AND
u.properties_id IN (select pp.id from project_properties pp where pp.projects_id = p.id)
)
) > 0) 
ORDER BY 
    CASE 
        WHEN @sort::bigint = 1 THEN p.project_rank END ASC,
    CASE
        WHEN @sort::bigint = 2 THEN p.created_at END DESC,
    CASE 
        WHEN @sort::bigint = 3 THEN pf.starting_price END DESC,
    CASE
        WHEN @sort::bigint = 4 THEN pf.starting_price END ASC LIMIT $1 OFFSET $2;



-- name: GetCountAllProjectDetailsWithAdvancedFilter :one
select count (p.*) from projects p join properties_facts pf on pf.project_id = p.id and pf.is_project_fact is true
left join addresses a on p.addresses_id = a.id
LEFT JOIN states s on a.states_id = s.id
left join cities c on a.cities_id = c.id
left join communities com on a.communities_id = com.id
left join sub_communities scom on a.sub_communities_id = scom.id
where (pf.starting_price >= @min_price or @disable_min_price) AND (pf.starting_price <= @max_price or @disable_max_price)  and (p.is_verified = @is_verified or @disable_is_verified::BOOLEAN) and
(CASE WHEN ARRAY_LENGTH(@completion_status::BIGINT[], 1) IS NULL THEN TRUE ELSE pf.completion_status = ANY(@completion_status::BIGINT[]) END) AND
(CASE WHEN ARRAY_LENGTH(@project_ranks::BIGINT[], 1) IS NULL THEN TRUE ELSE p.project_rank = ANY(@project_ranks::bigint[]) END) AND p.status!= 6 AND 
s.id = @state_id::bigint AND
(CASE WHEN ARRAY_LENGTH(@keywords::VARCHAR[], 1) IS NULL THEN TRUE ELSE p.ref_number  ILIKE ANY(@keywords::VARCHAR[]) OR p.project_name ILIKE ANY(@keywords::VARCHAR[]) OR p.description ILIKE ANY(@keywords::VARCHAR[]) OR  p.description_arabic ILIKE ANY(@keywords::VARCHAR[]) END) AND
(CASE WHEN ARRAY_LENGTH(@amenities::bigint[], 1) IS NULL THEN TRUE ELSE p.amenities_id && @amenities::bigint[] END) AND
(CASE WHEN ARRAY_LENGTH(@facilities::bigint[], 1) IS NULL THEN TRUE ELSE p.facilities_id && @facilities::bigint[] END) AND
(CASE WHEN COALESCE(@dates::BIGINT,1) =1 THEN true WHEN @dates::BIGINT= 2 THEN p.created_at >= DATE_TRUNC('day', CURRENT_DATE) WHEN @dates::BIGINT = 3 THEN p.created_at >= DATE_TRUNC('week', CURRENT_DATE - INTERVAL '1 week')
	  AND p.created_at < DATE_TRUNC('week', CURRENT_DATE) WHEN @dates::BIGINT = 4 THEN p.created_at >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
	  AND p.created_at < DATE_TRUNC('month', CURRENT_DATE) END) AND 
(CASE WHEN ARRAY_LENGTH(@cities_id::bigint[], 1) IS NULL THEN TRUE ELSE c.id = ANY(@cities_id::bigint[]) END)  AND 
(CASE WHEN ARRAY_LENGTH(@communities_id::bigint[], 1) IS NULL THEN TRUE ELSE com.id = ANY(@communities_id::bigint[])END) AND 
(CASE WHEN ARRAY_LENGTH(@subcommunities_id::bigint[], 1) IS NULL THEN TRUE ELSE scom.id = ANY(@subcommunities_id::bigint[]) END) AND 
(((select count(*) from sale_unit su
left join unit_facts uf on su.unit_facts_id = uf.id
left join units u on su.unit_id = u.id
where 
(CASE WHEN ARRAY_LENGTH(@bedroom::varchar[], 1) IS NULL THEN TRUE ELSE uf.bedroom = ANY(@bedroom::varchar[]) END) AND
(CASE WHEN ARRAY_LENGTH(@bathroom::bigint[], 1) IS NULL THEN TRUE ELSE uf.bathroom = ANY(@bathroom::bigint[]) END) AND
(CASE WHEN @min_plot_area::FLOAT =-1 AND @max_plot_area::FLOAT =-1 THEN true ELSE  uf.plot_area BETWEEN @min_plot_area ::FLOAT AND @max_plot_area::FLOAT END) AND
(CASE WHEN @min_built_up_area::FLOAT =-1 AND  @max_built_up_area::FLOAT =-1 THEN true ELSE uf.built_up_area BETWEEN @min_built_up_area::FLOAT AND @max_built_up_area::FLOAT END) AND
(CASE WHEN ARRAY_LENGTH(@no_of_payment::BIGINT[], 1) IS NULL THEN TRUE ELSE uf.no_of_payment = ANY(@no_of_payment::BIGINT[]) END) AND
(CASE WHEN ARRAY_LENGTH(@ownership::BIGINT[], 1) IS NULL THEN TRUE ELSE uf.ownership = ANY(@ownership::BIGINT[]) END) AND
(CASE WHEN @min_service_charge::BIGINT = -1 AND @max_service_charge::BIGINT =-1 THEN true ELSE uf.service_charge BETWEEN @min_service_charge::BIGINT AND @max_service_charge::BIGINT END) AND
(CASE WHEN ARRAY_LENGTH(@furnished::bigint[], 1) IS NULL THEN TRUE ELSE uf.furnished = ANY(@furnished::bigint[]) END) AND
(CASE WHEN ARRAY_LENGTH(@parking::bigint[], 1) IS NULL THEN TRUE ELSE uf.parking = ANY(@parking::bigint[]) END) AND
(CASE WHEN ARRAY_LENGTH(@view::bigint[], 1) IS NULL THEN TRUE ELSE uf.view && @view::bigint[] END) AND
(CASE WHEN ARRAY_LENGTH(@amenities::bigint[], 1) IS NULL THEN TRUE ELSE u.amenities_id && @amenities::bigint[] END) AND
(CASE WHEN ARRAY_LENGTH(@type_names::bigint[], 1) IS NULL THEN TRUE ELSE u.property_types_id = ANY(@type_names::bigint[]) END) AND 
u.property = 1 AND su.status != 6 AND
u.properties_id IN (select pp.id from project_properties pp where pp.projects_id = p.id)

)
+
(select count(*) from sale_unit su
left join unit_facts uf on su.unit_facts_id = uf.id
left join units u on su.unit_id = u.id
where 
(CASE WHEN ARRAY_LENGTH(@bedroom::varchar[], 1) IS NULL THEN TRUE ELSE uf.bedroom = ANY(@bedroom::varchar[]) END) AND
(CASE WHEN ARRAY_LENGTH(@bathroom::bigint[], 1) IS NULL THEN TRUE ELSE uf.bathroom = ANY(@bathroom::bigint[]) END) AND
(CASE WHEN @min_plot_area::FLOAT =-1 AND @max_plot_area::FLOAT =-1 THEN true ELSE  uf.plot_area BETWEEN @min_plot_area ::FLOAT AND @max_plot_area::FLOAT END) AND
(CASE WHEN @min_built_up_area::FLOAT =-1 AND  @max_built_up_area::FLOAT =-1 THEN true ELSE uf.built_up_area BETWEEN @min_built_up_area::FLOAT AND @max_built_up_area::FLOAT END) AND
(CASE WHEN ARRAY_LENGTH(@no_of_payment::BIGINT[], 1) IS NULL THEN TRUE ELSE uf.no_of_payment = ANY(@no_of_payment::BIGINT[]) END) AND
(CASE WHEN ARRAY_LENGTH(@ownership::BIGINT[], 1) IS NULL THEN TRUE ELSE uf.ownership = ANY(@ownership::BIGINT[]) END) AND
(CASE WHEN @min_service_charge::BIGINT = -1 AND @max_service_charge::BIGINT =-1 THEN true ELSE uf.service_charge BETWEEN @min_service_charge::BIGINT AND @max_service_charge::BIGINT END) AND
(CASE WHEN ARRAY_LENGTH(@furnished::bigint[], 1) IS NULL THEN TRUE ELSE uf.furnished = ANY(@furnished::bigint[]) END) AND
(CASE WHEN ARRAY_LENGTH(@parking::bigint[], 1) IS NULL THEN TRUE ELSE uf.parking = ANY(@parking::bigint[]) END) AND
(CASE WHEN ARRAY_LENGTH(@view::bigint[], 1) IS NULL THEN TRUE ELSE uf.view && @view::bigint[] END) AND
(CASE WHEN ARRAY_LENGTH(@amenities::bigint[], 1) IS NULL THEN TRUE ELSE u.amenities_id && @amenities::bigint[] END) AND
(CASE WHEN ARRAY_LENGTH(@type_names::bigint[], 1) IS NULL THEN TRUE ELSE u.property_types_id = ANY(@type_names::bigint[]) END) AND 
u.property = 1 AND su.status != 6 AND
u.properties_id IN (select pp.id from project_properties pp where pp.projects_id = p.id)
)
) > 0) ;



-- -- name: GetAmenitiesForProjectByCatg :many
-- SELECT
-- 		a.*,
-- 		fmc.category
-- FROM
--         projects p        
-- JOIN LATERAL unnest(p.amenities_id) AS amenity_id ON true
-- JOIN amenities a ON a.id = amenity_id
-- JOIN facilities_amenities_categories fmc ON a.category_id=fmc.id
-- WHERE p.id=$1 AND a.category_id=$2;



-- name: IsMultiPhaseProject :one
SELECT is_multiphase FROM projects 
WHERE id = $1 AND status!=6;



