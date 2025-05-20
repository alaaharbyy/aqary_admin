-- name: CheckIfXMLCompanyProfileProjectExist :one
SELECT EXISTS(
    SELECT id FROM company_profiles_projects
    WHERE ref_number = $1
)::boolean;

-- name: CreateCompanyProfilesProjects :one
INSERT INTO company_profiles_projects(
    ref_number,
	project_no ,
    project_name ,
    company_profiles_id,
    is_verified,
	is_multiphase ,
    license_no,
    addresses_id,
	bank_name,    
    escrow_number,
	registration_date,
	status,
	description,
    description_arabic,
    properties_ref_nos,
    facts,
    created_at,
    updated_at,
    promotions
)VALUES(
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
    $11, $12, $13, $14, $15, $16, $17, $18, $19
)RETURNING *;

-- name: GetXMLActiveCompanyProfileByLicenseNo :one
SELECT company_profiles.id,company_profiles.company_name,license.license_no FROM company_profiles
INNER JOIN license ON license.entity_id = company_profiles.id AND license.entity_type_id = 18 -- company profile entity type
WHERE license_no = @license_no AND company_profiles.status = 2; -- approve companies profiles

-- name: CreateXMLPlans :exec
INSERT INTO plans(
	entity_type_id, entity_id, title, file_urls, created_at, updated_at, uploaded_by, updated_by
)VALUES (
	$1, $2, $3, $4, $5, $6, $7, $8
);

-- name: CreateCompanyProfiles :one
INSERT INTO company_profiles (
    ref_no,
    company_type,
    company_name,
    company_name_ar,
    company_category_id,
    company_activities_id, 
    website_url,
    company_email,
    phone_number,
    logo_url,
    cover_image_url, 
    internal_cover_image,
    description,
    description_ar,
    status,
    addresses_id,
    created_by,
    created_at, 
    updated_at,
    updated_by, 
    sort_order
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
    $11, $12, $13, $14, $15, $16, $17, $18,$19,$20, $21
) RETURNING *;


-- name: GetCountAllCompanyProfilesByStatus :one
SELECT count(*) FROM company_profiles cp
INNER JOIN addresses a on a.id = cp.addresses_id 
where cp.status = ANY($1::int[]);

-- name: GetAllCompanyProfilesByStatus :many
SELECT * FROM company_profiles cp
INNER JOIN addresses a on a.id = cp.addresses_id 
WHERE cp.status = ANY($1::int[])
ORDER BY cp.created_at DESC
LIMIT $2
OFFSET $3;

-- name: GetAllCompanyProfilesByStatusLocal :many
SELECT * FROM company_profiles cp
INNER JOIN addresses a on a.id = cp.addresses_id 
where cp.status = $1 and a.countries_id = 1
LIMIT $2
OFFSET $3;


-- name: GetAllCompanyProfilesByStatusInternational :many
SELECT * FROM company_profiles cp
INNER JOIN addresses a on a.id = cp.addresses_id 
where cp.status = $1 and a.countries_id != 1
LIMIT $2
OFFSET $3;

-- name: GetAllCompanyProfiles :many
SELECT * FROM company_profiles;

-- name: GetCompanyProfileByID :one
SELECT * FROM company_profiles WHERE id = $1;

-- name: UpdateCompanyProfileStatus :one
UPDATE company_profiles 
SET 
    status = $2,
    updated_at = now(),
    updated_by = $3
WHERE id = $1
RETURNING *;


-- name: GetPropertiesByRefNo :many
select * from property_versions pv
inner join property p  on p.id =pv.property_id
where pv.ref_no = $1
and (pv.status != 6 or pv.status !=5)
and (p.status != 6 or p.status !=5);

-- name: GetPropertiesByRefNos :many
SELECT * 
FROM property_versions pv
INNER JOIN property p ON p.id = pv.property_id
WHERE pv.ref_no = ANY($1::text[])
AND pv.status NOT IN (5, 6) 
AND p.status NOT IN (5, 6);



-- name: GetGlobalPropertiesByID :one
SELECT *
FROM global_property_type
WHERE id = $1;


-- name: UpdateCompanyProfile :one
UPDATE company_profiles 
SET 
    company_name = $1,
    website_url = $2,
    company_email = $3,
    phone_number = $4,
    company_category_id = $5,
    company_activities_id = $6,
    logo_url = $7,
    cover_image_url = $8, 
    description = $9,
    description_ar = $10,
    updated_at = now(),
    updated_by = $11,
    addresses_id = $12,
    company_type = $13, 
    sort_order=$15,
    internal_cover_image=$16,
    company_name_ar = $17
WHERE id = $14
RETURNING *;

-- name: GetCompanyActivitiesByCompanyCategory :many
SELECT * FROM company_activities where company_category_id = $1;

-- name: DeleteCompanyProfileByID :exec
DELETE FROM company_profiles WHERE id = $1;


-- name: GetCompanyProfileProjectNotEqualToCountryId :many
SELECT DISTINCT 
    company_profiles_projects.*, addresses.full_address, company_profiles.company_name
FROM company_profiles_projects
INNER JOIN addresses ON company_profiles_projects.addresses_id = addresses.id 
INNER JOIN countries ON addresses.countries_id = countries.id  
INNER JOIN states ON addresses.states_id = states.id   
INNER JOIN cities ON addresses.cities_id = cities.id
LEFT JOIN communities ON addresses.communities_id = communities.id 
LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
INNER JOIN company_profiles ON company_profiles_projects.company_profiles_id = company_profiles.id    
--INNER JOIN properties_facts ON projects.id = properties_facts.project_id AND properties_facts.is_project_fact = true   
WHERE
	(CASE WHEN @company_id::bigint=0 then true else company_profiles.id= @company_id::bigint END)
	AND 
    -- Search criteria
    (@search = '%%' OR 
     company_profiles_projects.project_name % @search OR 
     company_profiles_projects.ref_number % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     communities.community % @search OR 
     sub_communities.sub_community % @search OR
     (company_profiles_projects.facts->>'starting_price')::TEXT % @search OR
     company_profiles.company_name % @search  
       OR (CASE 
        WHEN 'ready' ILIKE @search THEN (company_profiles_projects.facts->>'completion_status')::BIGINT  = 5
        WHEN 'off plan'ILIKE @search  THEN (company_profiles_projects.facts->>'completion_status')::BIGINT= 4
        WHEN '^[0-9]+$' ~ @search  THEN (company_profiles_projects.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft'ILIKE @search  THEN company_profiles_projects.status = 1
        WHEN 'available'ILIKE @search  THEN company_profiles_projects.status = 2
        WHEN 'block'ILIKE @search  THEN company_profiles_projects.status = 5
        WHEN 'single'ILIKE @search  THEN company_profiles_projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN company_profiles_projects.is_multiphase = true 
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
    -- AND (@country_id::bigint = 0 OR addresses.countries_id != @country_id::bigint)
--     -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
--     AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
--     AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
--     AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint)

    -- Status filter
    AND company_profiles_projects.status NOT IN (5,6)  
ORDER BY company_profiles_projects.created_at DESC
LIMIT $1 OFFSET $2;

-- name: GetCompanyProfileProject :one
SELECT * FROM company_profiles_projects 
WHERE id = $1 LIMIT 1;

-- name: GetCountCompanyProfileProjectByCounrty :one
SELECT COUNT(*)
FROM company_profiles_projects
INNER JOIN addresses ON company_profiles_projects.addresses_id = addresses.id 
INNER JOIN countries ON addresses.countries_id = countries.id  
INNER JOIN states ON addresses.states_id = states.id   
INNER JOIN cities ON addresses.cities_id = cities.id    
LEFT JOIN communities ON addresses.communities_id = communities.id 
LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
INNER JOIN company_profiles ON company_profiles_projects.company_profiles_id = company_profiles.id    
WHERE
	(CASE WHEN @company_id::bigint= 0 then true else company_profiles.id= @company_id::bigint END)
	AND 
    -- Search criteria
    (@search = '%%' OR 
     company_profiles_projects.project_name % @search OR 
     company_profiles_projects.ref_number % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
      communities.community % @search OR 
     sub_communities.sub_community % @search OR
      (company_profiles_projects.facts->>'starting_price')::TEXT % @search OR
     company_profiles.company_name % @search  
      OR (CASE 
        WHEN 'ready' ILIKE @search THEN (company_profiles_projects.facts->>'completion_status')::BIGINT = 5
        WHEN 'off plan'ILIKE @search  THEN (company_profiles_projects.facts->>'completion_status')::BIGINT = 4
        WHEN '^[0-9]+$' ~ @search  THEN (company_profiles_projects.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft'ILIKE @search  THEN company_profiles_projects.status = 1
        WHEN 'available'ILIKE @search  THEN company_profiles_projects.status = 2
        WHEN 'block'ILIKE @search  THEN company_profiles_projects.status = 5
        WHEN 'single'ILIKE @search  THEN company_profiles_projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN company_profiles_projects.is_multiphase = true 
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
    -- AND (@country_id::bigint = 0 OR addresses.countries_id = @country_id::bigint)
    -- -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
    -- AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
    -- AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
    -- AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint)
    -- Status filter
AND company_profiles_projects.status NOT IN (5,6);

-- name: GetCountCompanyProfileProjectByCountryNotEqual :one
SELECT COUNT(company_profiles_projects.*)
FROM company_profiles_projects
INNER JOIN addresses ON company_profiles_projects.addresses_id = addresses.id 
INNER JOIN countries ON addresses.countries_id = countries.id  
INNER JOIN states ON addresses.states_id = states.id   
INNER JOIN cities ON addresses.cities_id = cities.id
LEFT JOIN communities ON addresses.communities_id = communities.id 
LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
INNER JOIN company_profiles ON company_profiles_projects.company_profiles_id = company_profiles.id      
-- INNER JOIN properties_facts ON projects.id = properties_facts.project_id AND properties_facts.is_project_fact = true   
WHERE
	(CASE WHEN @company_id::bigint= 0 then true else company_profiles.id= @company_id::bigint END)
	AND 
    -- Search criteria
    (@search = '%%' OR 
     company_profiles_projects.project_name % @search OR 
     company_profiles_projects.ref_number % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     communities.community % @search OR 
     sub_communities.sub_community % @search OR
     (company_profiles_projects.facts->>'starting_price')::TEXT % @search OR
     company_profiles.company_name % @search  
       OR (CASE 
        WHEN 'ready' ILIKE @search THEN (company_profiles_projects.facts->>'completion_status')::BIGINT  = 5
        WHEN 'off plan'ILIKE @search  THEN (company_profiles_projects.facts->>'completion_status')::BIGINT= 4
        WHEN '^[0-9]+$' ~ @search  THEN (company_profiles_projects.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft'ILIKE @search  THEN company_profiles_projects.status = 1
        WHEN 'available'ILIKE @search  THEN company_profiles_projects.status = 2
        WHEN 'block'ILIKE @search  THEN company_profiles_projects.status = 5
        WHEN 'single'ILIKE @search  THEN company_profiles_projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN company_profiles_projects.is_multiphase = true 
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
    -- AND (@country_id::bigint = 0 OR addresses.countries_id != @country_id::bigint)
    -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
    -- AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
    -- AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
    -- AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint)
    -- Status filter
    AND company_profiles_projects.status NOT IN (5,6);


-- name: GetLocalCompanyProfileProjects :many
SELECT DISTINCT company_profiles_projects.*, addresses.full_address,company_profiles.company_name
FROM company_profiles_projects
INNER JOIN addresses ON company_profiles_projects.addresses_id = addresses.id 
INNER JOIN countries ON addresses.countries_id = countries.id  
INNER JOIN states ON addresses.states_id = states.id   
INNER JOIN cities ON addresses.cities_id = cities.id
LEFT JOIN communities ON addresses.communities_id = communities.id 
LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
INNER JOIN company_profiles ON company_profiles_projects.company_profiles_id = company_profiles.id    
WHERE
	(CASE WHEN @company_id::bigint= 0 then true else company_profiles.id= @company_id::bigint END)
	AND 
    -- Search criteria
    (@search = '%%' OR 
     company_profiles_projects.project_name % @search OR 
     company_profiles_projects.ref_number % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     communities.community % @search OR 
     sub_communities.sub_community % @search OR
     (company_profiles_projects.facts->>'starting_price')::TEXT % @search OR
     company_profiles.company_name % @search 
      OR (CASE 
        WHEN 'ready' ILIKE @search THEN (company_profiles_projects.facts->>'completion_status')::BIGINT = 5
        WHEN 'off plan'ILIKE @search  THEN (company_profiles_projects.facts->>'completion_status')::BIGINT = 4
        WHEN '^[0-9]+$' ~ @search  THEN (company_profiles_projects.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft' ILIKE @search  THEN company_profiles_projects.status = 1
        WHEN 'available'ILIKE @search  THEN company_profiles_projects.status = 2
        WHEN 'block'ILIKE @search  THEN company_profiles_projects.status = 5
        WHEN 'single'ILIKE @search  THEN company_profiles_projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN company_profiles_projects.is_multiphase = true 
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
    -- AND (@country_id::bigint = 0 OR addresses.countries_id = @country_id::bigint)
    -- -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
    -- AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
    -- AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
    -- AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint)
    
    -- Status filter
    AND company_profiles_projects.status NOT IN (5,6)  
ORDER BY company_profiles_projects.created_at DESC
LIMIT $1 OFFSET $2;

-- name: GetAllCompanyProfilePhasesByProject :many
SELECT
	company_profiles_phases.*
FROM
	company_profiles_phases
    LEFT JOIN company_profiles_projects ON company_profiles_projects.id = company_profiles_phases.company_profiles_projects_id
	LEFT JOIN addresses ON addresses.id = company_profiles_phases.addresses_id
    LEFT JOIN countries ON countries.id = addresses.countries_id
    LEFT JOIN states ON states.id = addresses.states_id
    LEFT JOIN cities ON cities.id = addresses.cities_id
    LEFT JOIN communities ON communities.id = addresses.communities_id
    LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
WHERE
    -- Search criteria
    (@search = '%%' OR 
     company_profiles_projects.project_name % @search OR 
      company_profiles_phases.phase_name % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     communities.community % @search OR 
     sub_communities.sub_community % @search  
       OR (CASE 
         WHEN 'ready' ILIKE @search THEN (company_profiles_phases.facts->>'completion_status')::BIGINT = 5
        WHEN 'off plan'ILIKE @search  THEN (company_profiles_phases.facts->>'completion_status')::BIGINT = 4
        WHEN '^[0-9]+$' ~ @search  THEN (company_profiles_phases.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft'ILIKE @search  THEN company_profiles_projects.status = 1
        WHEN 'available'ILIKE @search  THEN company_profiles_projects.status = 2
        WHEN 'block'ILIKE @search  THEN company_profiles_projects.status = 5
        WHEN 'single'ILIKE @search  THEN company_profiles_projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN company_profiles_projects.is_multiphase = true 
        ELSE FALSE
      END)
      )
     -- Company and branch permissions
     AND (
        @is_company_user::BOOLEAN != true
        OR (
            (@company_branch != false OR company_profiles_projects.developer_companies_id = @company_id::bigint)
            AND (@company_branch != true OR company_profiles_projects.developer_company_branches_id = @company_id::bigint)
        )
    )
    -- Location filters
    AND (@country_id::bigint = 0 OR addresses.countries_id = @country_id::bigint)
    -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
    -- AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
    -- AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
    -- AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint)
	AND company_profiles_projects.id = $3 AND (company_profiles_phases.status != 5 AND company_profiles_phases.status != 6)
ORDER BY
	company_profiles_phases.created_at DESC
LIMIT $1 OFFSET $2;

-- name: GetAllCompanyProfilePhasesByStatus :many
SELECT company_profiles_phases.*,company_profiles_projects.project_name, addresses.full_address,coalesce(company_profiles.company_name, '')::VARCHAR as "company_name"
FROM company_profiles_phases
    LEFT JOIN company_profiles_projects ON company_profiles_projects.id = company_profiles_phases.company_profiles_projects_id
    INNER JOIN company_profiles ON company_profiles_projects.company_profiles_id = company_profiles.id
	LEFT JOIN addresses ON addresses.id = company_profiles_phases.addresses_id
    LEFT JOIN countries ON countries.id = addresses.countries_id
    LEFT JOIN states ON states.id = addresses.states_id
    LEFT JOIN cities ON cities.id = addresses.cities_id
    LEFT JOIN communities ON communities.id = addresses.communities_id
    LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
WHERE 
    -- Search criteria
    (@search = '%%' OR 
     company_profiles_projects.project_name % @search OR 
      company_profiles_phases.phase_name % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     communities.community % @search OR 
     sub_communities.sub_community % @search  
       OR (CASE 
        WHEN 'ready' ILIKE @search THEN (company_profiles_phases.facts->>'completion_status')::BIGINT = 5
        WHEN 'off plan'ILIKE @search  THEN (company_profiles_phases.facts->>'completion_status')::BIGINT = 4
        WHEN '^[0-9]+$' ~ @search  THEN (company_profiles_phases.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft'ILIKE @search  THEN company_profiles_projects.status = 1
        WHEN 'available'ILIKE @search  THEN company_profiles_projects.status = 2
        WHEN 'block'ILIKE @search  THEN company_profiles_projects.status = 5
        WHEN 'single'ILIKE @search  THEN company_profiles_projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN company_profiles_projects.is_multiphase = true 
        ELSE FALSE
      END)
      )
     -- Company and branch permissions
    --  AND (
    --     @is_company_user != true
    --     OR (
    --         (@company_branch != false OR company_profiles_projects.developer_companies_id = @company_id::bigint)
    --         AND (@company_branch != true OR company_profiles_projects.developer_company_branches_id = @company_id::bigint)
    --     )
    -- )

    -- Location filters
    AND (@country_id::bigint = 0 OR addresses.countries_id = @country_id::bigint)
    -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
    AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
    AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
    AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint)
    
-- AND company_profiles_phases.status = $3 //TODO: status
ORDER BY company_profiles_phases.created_at DESC 
LIMIT $1 OFFSET $2;

-- name: GetCompanyProfilePhase :one
SELECT * FROM company_profiles_phases 
WHERE id = $1 LIMIT $1;

-- name: GetCountAllCompanyProfilePhasesByProject :one
SELECT
	COUNT(company_profiles_phases.id)
FROM
	company_profiles_phases
   LEFT JOIN company_profiles_projects ON company_profiles_projects.id = company_profiles_phases.company_profiles_projects_id
	--INNER JOIN phases_facts ON phases.id = phases_facts.phases_id
	LEFT JOIN addresses ON addresses.id = company_profiles_phases.addresses_id
    LEFT JOIN countries ON countries.id = addresses.countries_id
    LEFT JOIN states ON states.id = addresses.states_id
    LEFT JOIN cities ON cities.id = addresses.cities_id
    LEFT JOIN communities ON communities.id = addresses.communities_id
    LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
WHERE
    -- Search criteria
    (@search = '%%' OR 
     company_profiles_projects.project_name % @search OR 
      company_profiles_phases.phase_name % @search OR
     countries.country % @search OR 
     states."state" % @search OR 
     cities.city % @search OR 
     communities.community % @search OR 
     sub_communities.sub_community % @search  
       OR (CASE 
        WHEN 'ready' ILIKE @search THEN (company_profiles_phases.facts->>'completion_status')::BIGINT = 5
        WHEN 'off plan'ILIKE @search  THEN (company_profiles_phases.facts->>'completion_status')::BIGINT = 4
        WHEN '^[0-9]+$' ~ @search  THEN (company_profiles_phases.facts->>'completion_percentage')::TEXT % @search
        WHEN 'draft'ILIKE @search  THEN company_profiles_projects.status = 1
        WHEN 'available'ILIKE @search  THEN company_profiles_projects.status = 2
        WHEN 'block'ILIKE @search  THEN company_profiles_projects.status = 5
        WHEN 'single'ILIKE @search  THEN company_profiles_projects.is_multiphase = false
        WHEN 'multiple'ILIKE @search  THEN company_profiles_projects.is_multiphase = true 
        ELSE FALSE
      END)
      )
     -- Company and branch permissions
     AND (
        @is_company_user::BOOLEAN != true
        OR (
            (@company_branch != false OR company_profiles_projects.developer_companies_id = @company_id::bigint)
            AND (@company_branch != true OR company_profiles_projects.developer_company_branches_id = @company_id::bigint)
        )
    )
    -- Location filters
    AND (@country_id::bigint = 0 OR addresses.countries_id = @country_id::bigint)
    -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
  --  AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
  --  AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
   -- AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint)
 AND company_profiles_projects.id = $1 AND (company_profiles_phases.status != 5 AND company_profiles_phases.status != 6);


-- name: CreateCompanyProfilePhase :one
INSERT INTO company_profiles_phases(
    ref_number,
    company_profiles_projects_id,
    phase_name,
    registration_date,
    bank_name,
    escrow_number,
    facts,
    properties_ref_nos,
    promotions,
    status
)VALUES(
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10
)RETURNING *;


-- name: CheckIfXMLCompanyProfilePhaseExist :one
SELECT EXISTS(
    SELECT id FROM company_profiles_phases
    WHERE ref_number = $1
)::boolean;

-- name: GetCompanyProfileProjectByRefNo :one
SELECT * FROM company_profiles_projects 
WHERE ref_number = $1;


-- name: UpdateCompanyProfilesProjects :one
UPDATE company_profiles_projects
    SET ref_number = $2,
	project_no = $3,
    project_name = $4,
    company_profiles_id = $5,
    is_verified = $6,
	is_multiphase = $7,
    license_no = $8,
    addresses_id = $9,
	bank_name = $10,    
    escrow_number = $11,
	registration_date = $12,
	status = $13,
	description = $14,
    description_arabic = $15,
    properties_ref_nos = $16,
    facts = $17,
    created_at = $18,
    updated_at = $19,
    promotions = $20
WHERE id = $1
RETURNING *;

-- name: DeleteXMLPlansByEntity :exec
DELETE FROM plans
WHERE entity_type_id = $1 AND entity_id = ANY(@entity_ids::bigint[]);

-- name: UpdateCompanyProfilePhase :one
UPDATE company_profiles_phases
    SET ref_number = $2,
    company_profiles_projects_id = $3,
    phase_name = $4,
    registration_date = $5,
    bank_name = $6,
    escrow_number = $7,
    facts = $8,
    properties_ref_nos = $9,
    promotions = $10,
    status = $11
WHERE id = $1 
RETURNING *;

-- name: GetCompanyProfilePhaseByRefNo :one
SELECT * FROM company_profiles_phases 
WHERE ref_number = $1 LIMIT 1;


-- name: GetAllCompanyProfileProjectIdToDelete :many
SELECT 
    company_profiles_projects.id AS project_id,
    company_profiles_projects.is_multiphase,
    locations.id AS location_id,
    addresses.id AS addresses_id,
    ARRAY_AGG(DISTINCT company_profiles_phases.id) FILTER (WHERE company_profiles_phases.id IS NOT NULL)::BIGINT[] AS phase_ids,
    ARRAY_AGG(DISTINCT company_profiles_phases.ref_number) FILTER (WHERE company_profiles_phases.id IS NOT NULL)::VARCHAR[] AS phase_refnos
FROM company_profiles_projects
LEFT JOIN addresses ON company_profiles_projects.addresses_id = addresses.id
LEFT JOIN locations ON locations.id = addresses.locations_id
LEFT JOIN company_profiles_phases ON company_profiles_phases.company_profiles_projects_id = company_profiles_projects.id
WHERE company_profiles_projects.ref_number != ALL(@ignore_project_ref_nos::varchar[])
GROUP BY company_profiles_projects.id, locations.id, addresses.id;

-- name: DeleteXMLBulkCompanyProfilePhases :exec
DELETE FROM company_profiles_phases
WHERE id = ANY(@ids::bigint[]);

-- name: GetAllCompanyProfilePhaseRefNosToDelete :many
SELECT id, ref_number
FROM company_profiles_phases
WHERE ref_number != ALL(@ignore_phase_refnos::varchar[]);

-- name: DeleteCompanyProfileProject :exec
DELETE FROM company_profiles_projects WHERE id = $1;