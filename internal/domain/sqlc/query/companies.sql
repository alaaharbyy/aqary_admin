-- name: CreateCompanies :one
INSERT INTO companies (
    ref_no,
    company_name,
    tag_line,
    description,
    logo_url,
    email,
    phone_number,
    whatsapp_number,
    is_verified,
    website_url,
    cover_image_url,
    no_of_employees,
    company_rank,
    status,
    company_type,
    addresses_id,
    users_id,
    created_by,
    created_at,
    updated_at,
    description_ar,
    updated_by,
    company_activities_id,
    company_parent_id,
    location_url,
    vat_no,
    vat_status,
    vat_file_url
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7, $8, $9, $10, 
    $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, 
    $21, $22, $23, $24, $25, $26, $27, $28
) RETURNING *;

-- name: CreateLicense :one
INSERT INTO license(
    license_file_url,
    license_no,
    license_issue_date,
    license_registration_date,
    license_expiry_date,
    license_type_id,
    state_id,
    entity_type_id,
    entity_id,
    metadata
)VALUES(
    $1 ,$2, $3, $4, $5, $6, $7, $8, $9, $10
)RETURNING *;

-- -- name: CheckCompanyByName :one
-- SELECT companies.id FROM companies 
-- WHERE company_name ILIKE $1;

-- -- name: CreateCompaniesService :one
-- INSERT INTO companies_services (
--      companies_id,
--      services_id,
--      created_at,
--      updated_at 
-- )VALUES (
--     $1, $2, $3, $4
-- ) RETURNING *;

-- -- name: CheckParentCompanyExists :one
-- SELECT id FROM companies
-- WHERE id = $1;

-- name: GetCompanies :one
SELECT * FROM companies
WHERE id = $1;

-- -- name: GetCompaniesLicenses :one
-- SELECT * FROM companies_licenses WHERE id = $1 LIMIT 1;

-- name: UpdateCompanies :one
UPDATE companies
SET company_name = $2,
    tag_line = $3,
    description = $4,
    logo_url = $5,
    email = $6,
    phone_number = $7,
    whatsapp_number = $8,
    website_url = $9,
    cover_image_url = $10,
    no_of_employees = $11,
    updated_at = $12,
    description_ar = $13,
    company_activities_id = $14,
    updated_by = $15,
    location_url = $16,
    vat_no = $17,
    vat_status = $18,
    vat_file_url = $19
WHERE id = $1
RETURNING *;

-- -- name: DeleteAllCompanyServicesByCompanyId :exec
-- DELETE FROM companies_services 
-- WHERE companies_id = $1;

-- -- name: GetLocalCompanies :many
-- SELECT  
-- 	c.id, c.created_at, c.company_name, c.logo_url, c.email,c.phone_number, c.status, c.company_rank,  c.addresses_id, c.created_by,c.users_id,c.company_type,
-- 	cl.commercial_license_no, cl.orn_license_no, cl.orn_license_file_url, cl.orn_registration_date, cl.orn_license_expiry
-- FROM companies as c
--  INNER JOIN addresses ON c.addresses_id = addresses.id
--  INNER JOIN countries ON addresses.countries_id = countries.id
--  INNER JOIN states ON addresses.states_id = states.id
--  INNER JOIN cities ON addresses.cities_id = cities.id 

--  INNER JOIN users ON c.created_by = users.id 
--  INNER JOIN users as admin ON c.users_id = admin.id
--  INNER JOIN profiles ON admin.profiles_id = profiles.id
--  LEFT  JOIN roles ON users.roles_id =  roles.id AND users.roles_id IS NOT NULL
--  INNER JOIN companies_licenses cl ON cl.company_id = c.id
-- --  LEFT  JOIN branch_companies ON branch_companies.companies_id = c.id
-- WHERE
--     (
--        @search = '%%'
--        OR c.company_name ILIKE @search
--        OR (CASE 
--         WHEN 'standard' ILIKE @search THEN c.company_rank = 1
--         WHEN 'featured' ILIKE @search THEN c.company_rank = 2 
--         WHEN 'premium'  ILIKE @search THEN c.company_rank = 3
--         WHEN 'top deal' ILIKE @search THEN c.company_rank = 4
--         ELSE FALSE
--       END)
--       OR cl.commercial_license_no ILIKE @search
--       OR countries.country ILIKE @search
--       OR states.state ILIKE @search
--       OR cities.city ILIKE @search      
--       OR roles."role" ILIKE @search
--       OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
--       OR c.email ILIKE @search
--       OR c.phone_number ILIKE @search
--     )
--     AND
--   	CASE WHEN @is_company_user != true THEN true ELSE c.id = @company_id::bigint AND c.company_type =   @company_type::bigint END
--    AND CASE WHEN @country_id::bigint = 0 THEN true ELSE addresses.countries_id = @country_id::bigint END
--    AND CASE WHEN @city_id::bigint = 0 Then true ELSE addresses.cities_id = @city_id::bigint END
--    AND CASE WHEN @community_id::bigint = 0 THEN true ELSE addresses.communities_id = @community_id::bigint END
--    AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_community_id::bigint END
--    AND (c.status !=5 AND c.status != 6)
--    AND companies.company_parent_id IS NULL
-- ORDER BY created_at DESC  LIMIT $1 OFFSET $2;

-- -- name: GetCountLocalCompanies :one
-- SELECT  COUNT(c.*)
-- FROM companies as c
--  INNER JOIN addresses ON c.addresses_id = addresses.id
--  INNER JOIN countries ON addresses.countries_id = countries.id
--  INNER JOIN states ON addresses.states_id = states.id
--  INNER JOIN cities ON addresses.cities_id = cities.id 
--  INNER JOIN users ON c.created_by = users.id 
--  INNER JOIN users as admin ON c.users_id = admin.id
--  INNER JOIN profiles ON admin.profiles_id = profiles.id
--  LEFT JOIN roles ON users.roles_id =  roles.id AND users.roles_id IS NOT NULL
--  INNER JOIN companies_licenses cl ON cl.company_id = c.id
-- WHERE
--     (
--        @search = '%%'
--        OR c.company_name ILIKE @search
--        OR (CASE 
--         WHEN 'standard' ILIKE @search THEN c.company_rank = 1
--         WHEN 'featured' ILIKE @search THEN c.company_rank = 2 
--         WHEN 'premium'  ILIKE @search THEN c.company_rank = 3
--         WHEN 'top deal' ILIKE @search THEN c.company_rank = 4
--         ELSE FALSE
--       END)
--       OR cl.commercial_license_no ILIKE @search
--       OR countries.country ILIKE @search
--       OR states.state ILIKE @search
--       OR cities.city ILIKE @search      
--       OR roles."role" ILIKE @search
--       OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
--       OR c.email ILIKE @search
--       OR c.phone_number ILIKE @search
--     )
--     AND
--  	CASE WHEN @is_company_user != true THEN true ELSE c.id = @company_id::bigint AND c.company_type =   @company_type::bigint END
--    AND CASE WHEN @country_id::bigint = 0 THEN true ELSE addresses.countries_id = @country_id::bigint END
--    AND CASE WHEN @city_id::bigint = 0 Then true ELSE addresses.cities_id = @city_id::bigint END
--    AND CASE WHEN @community_id::bigint = 0 THEN true ELSE addresses.communities_id = @community_id::bigint END
--    AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_community_id::bigint  END
--  	AND (c.status !=5 AND c.status != 6)
-- AND companies.company_parent_id IS NULL;

-- -- name: GetInternationalCompanies :many
-- SELECT  
-- 	c.id, c.created_at, c.company_name, c.logo_url, c.email,c.phone_number, c.status, c.company_rank,  c.addresses_id, c.created_by,c.users_id,c.company_type,
-- 	cl.commercial_license_no, cl.orn_license_no, cl.orn_license_file_url, cl.orn_registration_date, cl.orn_license_expiry
-- FROM companies as c
--  INNER JOIN addresses ON c.addresses_id = addresses.id
--  INNER JOIN countries ON addresses.countries_id = countries.id
--  INNER JOIN states ON addresses.states_id = states.id
--  INNER JOIN cities ON addresses.cities_id = cities.id 
--  INNER JOIN users ON c.created_by = users.id 
--  INNER JOIN users as admin ON c.users_id = admin.id
--  INNER JOIN profiles ON admin.profiles_id = profiles.id
--  LEFT JOIN roles ON users.roles_id =  roles.id AND users.roles_id IS NOT NULL
--  INNER JOIN companies_licenses cl ON cl.company_id = c.id
-- WHERE
--     (
--        @search = '%%'
--        OR c.company_name ILIKE @search
--        OR (CASE 
--         WHEN 'standard' ILIKE @search THEN c.company_rank = 1
--         WHEN 'featured' ILIKE @search THEN c.company_rank = 2 
--         WHEN 'premium'  ILIKE @search THEN c.company_rank = 3
--         WHEN 'top deal' ILIKE @search THEN c.company_rank = 4
--         ELSE FALSE
--       END)
--       OR cl.commercial_license_no ILIKE @search
--       OR countries.country ILIKE @search
--       OR states.state ILIKE @search
--       OR cities.city ILIKE @search      
--       OR roles."role" ILIKE @search
--       OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
--       OR c.email ILIKE @search
--       OR c.phone_number ILIKE @search
--     )
--     AND
--  	CASE WHEN @is_company_user != true THEN true ELSE c.id = @company_id::bigint AND c.company_type =   @company_type::bigint END
--    AND CASE WHEN @country_id::bigint = 0 THEN true ELSE addresses.countries_id != @country_id::bigint END
--    AND CASE WHEN @city_id::bigint = 0 Then true ELSE addresses.cities_id = @city_id::bigint END
--    AND CASE WHEN @community_id::bigint = 0 THEN true ELSE addresses.communities_id = @community_id::bigint END
--    AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_community_id::bigint  END
--  	AND (c.status !=5 AND c.status != 6)
--      AND companies.company_parent_id IS NULL
-- ORDER BY created_at DESC  LIMIT $1 OFFSET $2;


-- -- name: GetCountInternationalCompanies :one
-- SELECT  COUNT(c.*)
-- FROM companies as c
--  INNER JOIN addresses ON c.addresses_id = addresses.id
--  INNER JOIN countries ON addresses.countries_id = countries.id
--  INNER JOIN states ON addresses.states_id = states.id
--  INNER JOIN cities ON addresses.cities_id = cities.id 
--  INNER JOIN users ON c.created_by = users.id 
--  INNER JOIN users as admin ON c.users_id = admin.id
--  INNER JOIN profiles ON admin.profiles_id = profiles.id
--  LEFT JOIN roles ON users.roles_id =  roles.id AND users.roles_id IS NOT NULL
--  INNER JOIN companies_licenses cl ON cl.company_id = c.id
-- WHERE
--     (
--        @search = '%%'
--        OR c.company_name ILIKE @search
--        OR (CASE 
--         WHEN 'standard' ILIKE @search THEN c.company_rank = 1
--         WHEN 'featured' ILIKE @search THEN c.company_rank = 2 
--         WHEN 'premium'  ILIKE @search THEN c.company_rank = 3
--         WHEN 'top deal' ILIKE @search THEN c.company_rank = 4
--         ELSE FALSE
--       END)
--       OR cl.commercial_license_no ILIKE @search
--       OR countries.country ILIKE @search
--       OR states.state ILIKE @search
--       OR cities.city ILIKE @search      
--       OR roles."role" ILIKE @search
--       OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
--       OR c.email ILIKE @search
--       OR c.phone_number ILIKE @search

--     )
--     AND
--  	CASE WHEN @is_company_user != true THEN true ELSE c.id = @company_id::bigint AND c.company_type =   @company_type::bigint END
--    AND CASE WHEN @country_id::bigint = 0 THEN true ELSE addresses.countries_id != @country_id::bigint END
--    AND CASE WHEN @city_id::bigint = 0 Then true ELSE addresses.cities_id = @city_id::bigint END
--    AND CASE WHEN @community_id::bigint = 0 THEN true ELSE addresses.communities_id = @community_id::bigint END
--    AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_community_id::bigint  END
--  	AND (c.status !=5 AND c.status != 6)
-- AND companies.company_parent_id IS NULL;


-- name: UpdateCompaniesStatus :one
UPDATE companies 
SET status = $2
WHERE id = $1 
RETURNING *;

-- name: UpdateCompaniesRank :one
UPDATE companies 
SET company_rank = $2 
Where id = $1 
RETURNING *;

-- name: VerifyCompanies :one
UPDATE companies 
SET status = 8,
is_verified = true
Where id =$1 
RETURNING *;

-- name: RejectCompanies :one
Update companies 
SET status  = $2
Where id = $1
RETURNING *;

-- name: GetCompaniesByStatus :many
SELECT 
 c.id, c.company_name, c.company_type, c.logo_url, c.email, c.phone_number, c.status, c.company_rank, c.addresses_id, c.users_id,
 cl.license_no,
 CASE WHEN company_parent_id IS NULL THEN FALSE::boolean ELSE TRUE::boolean END AS is_branch
FROM companies c
 INNER JOIN license cl ON cl.entity_id = c.id AND entity_type_id = @entity_type_id::bigint AND license_type_id = @license_type_id::bigint
 ------ 
 INNER JOIN addresses ON c.addresses_id = addresses.id
 INNER JOIN countries ON addresses.countries_id = countries.id
 INNER JOIN states ON addresses.states_id = states.id
 INNER JOIN cities ON addresses.cities_id = cities.id 
 INNER JOIN users ON c.created_by = users.id 
 INNER JOIN users as admin ON c.users_id = admin.id
 INNER JOIN profiles ON admin.profiles_id = profiles.id
 LEFT JOIN roles ON users.roles_id =  roles.id AND users.roles_id IS NOT NULL
WHERE 
    (
       @search = '%%'
       OR c.company_name ILIKE @search
       OR (CASE 
        WHEN 'standard' ILIKE @search THEN c.company_rank = 1
        WHEN 'featured' ILIKE @search THEN c.company_rank = 2 
        WHEN 'premium'  ILIKE @search THEN c.company_rank = 3
        WHEN 'top deal' ILIKE @search THEN c.company_rank = 4
        ELSE FALSE
      END)
      OR cl.license_no ILIKE @search
      OR countries.country ILIKE @search
      OR states.state ILIKE @search
      OR cities.city ILIKE @search      
      OR roles."role" ILIKE @search
      OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
      OR c.email ILIKE @search
      OR c.phone_number ILIKE @search
    )
    AND
 	CASE WHEN @is_company_user != true THEN true ELSE c.id = @company_id::bigint AND c.company_type =   @company_type::bigint END
   AND CASE WHEN @country_id::bigint = 0 THEN true ELSE addresses.countries_id = @country_id::bigint END
   AND CASE WHEN @city_id::bigint = 0 Then true ELSE addresses.cities_id = @city_id::bigint END
   AND CASE WHEN @community_id::bigint = 0 THEN true ELSE addresses.communities_id = @community_id::bigint END
   AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_community_id::bigint  END
   AND  c.status = @status
ORDER BY id  LIMIT $1 OFFSET $2;
-- SELECT 
-- companies.id, company_name, company_type, logo_url, email, phone_number, status, company_rank, addresses_id, users_id ,
-- companies_licenses.commercial_license_no,
-- CASE WHEN branch_companies.id != 0 THEN TRUE::boolean ELSE FALSE::boolean END AS is_branch
-- FROM companies
-- INNER JOIN companies_licenses ON companies_licenses.id = companies.companies_licenses_id
-- LEFT JOIN branch_companies ON branch_companies.companies_id = companies.id
-- WHERE  companies.status = $3 
-- ORDER BY id  LIMIT $1 OFFSET $2;

-- name: GetCountCompaniesByStatus :one
SELECT  COUNT(c.id)
FROM companies c
 INNER JOIN license cl ON cl.entity_id = c.id AND entity_type_id = @entity_type_id::bigint AND license_type_id = @license_type_id::bigint
 ------ 
 INNER JOIN addresses ON c.addresses_id = addresses.id
 INNER JOIN countries ON addresses.countries_id = countries.id
 INNER JOIN states ON addresses.states_id = states.id
 INNER JOIN cities ON addresses.cities_id = cities.id 
 INNER JOIN users ON c.created_by = users.id 
 INNER JOIN users as admin ON c.users_id = admin.id
 INNER JOIN profiles ON admin.profiles_id = profiles.id
 LEFT JOIN roles ON users.roles_id =  roles.id AND users.roles_id IS NOT NULL
WHERE 
    (
       @search = '%%'
       OR c.company_name ILIKE @search
       OR (CASE 
        WHEN 'standard' ILIKE @search THEN c.company_rank = 1
        WHEN 'featured' ILIKE @search THEN c.company_rank = 2 
        WHEN 'premium'  ILIKE @search THEN c.company_rank = 3
        WHEN 'top deal' ILIKE @search THEN c.company_rank = 4
        ELSE FALSE
      END)
      OR cl.license_no ILIKE @search
      OR countries.country ILIKE @search
      OR states.state ILIKE @search
      OR cities.city ILIKE @search      
      OR roles."role" ILIKE @search
      OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
      OR c.email ILIKE @search
      OR c.phone_number ILIKE @search
    )
    AND
 	CASE WHEN @is_company_user != true THEN true ELSE c.id = @company_id::bigint AND c.company_type =   @company_type::bigint END
   AND CASE WHEN @country_id::bigint = 0 THEN true ELSE addresses.countries_id = @country_id::bigint END
   AND CASE WHEN @city_id::bigint = 0 Then true ELSE addresses.cities_id = @city_id::bigint END
   AND CASE WHEN @community_id::bigint = 0 THEN true ELSE addresses.communities_id = @community_id::bigint END
   AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_community_id::bigint  END
AND  c.status = @status;
-- SELECT 
--     COUNT(id)
-- FROM companies
-- WHERE status = $1;

 

-- -- name: GetCompaniesByRank :many
-- SELECT c.id, c.company_name, c.company_type, c.logo_url, c.email, c.phone_number, c.status, c.company_rank,  c.addresses_id,  c.users_id, cl.commercial_license_no,
-- CASE WHEN company_parent_id IS NULL THEN FALSE::boolean ELSE TRUE::boolean END AS is_branch
-- FROM companies c
-- INNER JOIN companies_licenses cl ON c.id = cl.company_id
--  INNER JOIN addresses ON c.addresses_id = addresses.id
--  INNER JOIN countries ON addresses.countries_id = countries.id
--  INNER JOIN states ON addresses.states_id = states.id
--  INNER JOIN cities ON addresses.cities_id = cities.id 

--  INNER JOIN users ON c.created_by = users.id 
--  INNER JOIN users as admin ON c.users_id = admin.id
--  INNER JOIN profiles ON admin.profiles_id = profiles.id
--  LEFT  JOIN roles ON users.roles_id =  roles.id AND users.roles_id IS NOT NULL
-- WHERE 
--   (
--        @search = '%%'
--        OR c.company_name ILIKE @search
--        OR (CASE 
--         WHEN 'standard' ILIKE @search THEN c.company_rank = 1
--         WHEN 'featured' ILIKE @search THEN c.company_rank = 2 
--         WHEN 'premium'  ILIKE @search THEN c.company_rank = 3
--         WHEN 'top deal' ILIKE @search THEN c.company_rank = 4
--         ELSE FALSE
--       END)
--       OR cl.commercial_license_no ILIKE @search
--       OR countries.country ILIKE @search
--       OR states.state ILIKE @search
--       OR cities.city ILIKE @search      
--       OR roles."role" ILIKE @search
--       OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
--       OR c.email ILIKE @search
--       OR c.phone_number ILIKE @search
--     )
--     AND
--  	CASE WHEN @is_company_user != true THEN true ELSE c.id = @company_id::bigint AND c.company_type =   @company_type::bigint END
--    AND CASE WHEN @country_id::bigint = 0 THEN true ELSE addresses.countries_id = @country_id::bigint END
--    AND CASE WHEN @city_id::bigint = 0 Then true ELSE addresses.cities_id = @city_id::bigint END
--    AND CASE WHEN @community_id::bigint = 0 THEN true ELSE addresses.communities_id = @community_id::bigint END
--    AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_community_id::bigint  END
--    AND c.status NOT IN (5,6) 
-- AND c.company_rank = $3
-- ORDER BY c.updated_at  DESC LIMIT $1 OFFSET $2;





-- SELECT companies.id, company_name, company_type, logo_url, email, phone_number, status, company_rank,  addresses_id,  users_id ,
-- companies_licenses.commercial_license_no,
-- CASE WHEN branch_companies.id != 0 THEN TRUE::boolean ELSE FALSE::boolean END AS is_branch
-- FROM companies
-- INNER JOIN companies_licenses ON companies_licenses.id = companies.companies_licenses_id
-- LEFT JOIN branch_companies ON branch_companies.companies_id = companies.id
-- WHERE  companies.company_rank = $3 
-- ORDER BY id  LIMIT $1 OFFSET $2;

-- -- name: GetCountCompaniesByRank :one
-- SELECT COUNT(c.id)
-- FROM companies c
-- INNER JOIN companies_licenses cl ON c.id = cl.company_id
--  INNER JOIN addresses ON c.addresses_id = addresses.id
--  INNER JOIN countries ON addresses.countries_id = countries.id
--  INNER JOIN states ON addresses.states_id = states.id
--  INNER JOIN cities ON addresses.cities_id = cities.id 

--  INNER JOIN users ON c.created_by = users.id 
--  INNER JOIN users as admin ON c.users_id = admin.id
--  INNER JOIN profiles ON admin.profiles_id = profiles.id
--  LEFT  JOIN roles ON users.roles_id =  roles.id AND users.roles_id IS NOT NULL
-- WHERE 
--   (
--        @search = '%%'
--        OR c.company_name ILIKE @search
--        OR (CASE 
--         WHEN 'standard' ILIKE @search THEN c.company_rank = 1
--         WHEN 'featured' ILIKE @search THEN c.company_rank = 2 
--         WHEN 'premium'  ILIKE @search THEN c.company_rank = 3
--         WHEN 'top deal' ILIKE @search THEN c.company_rank = 4
--         ELSE FALSE
--       END)
--       OR cl.commercial_license_no ILIKE @search
--       OR countries.country ILIKE @search
--       OR states.state ILIKE @search
--       OR cities.city ILIKE @search      
--       OR roles."role" ILIKE @search
--       OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
--       OR c.email ILIKE @search
--       OR c.phone_number ILIKE @search
--     )
--     AND
--  	CASE WHEN @is_company_user != true THEN true ELSE c.id = @company_id::bigint AND c.company_type =   @company_type::bigint END
--    AND CASE WHEN @country_id::bigint = 0 THEN true ELSE addresses.countries_id = @country_id::bigint END
--    AND CASE WHEN @city_id::bigint = 0 Then true ELSE addresses.cities_id = @city_id::bigint END
--    AND CASE WHEN @community_id::bigint = 0 THEN true ELSE addresses.communities_id = @community_id::bigint END
--    AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_community_id::bigint  END
--    AND c.status NOT IN (5,6) 
-- AND c.company_rank = $1;
-- -- SELECT 
-- --     COUNT(id)
-- -- FROM companies
-- -- WHERE company_rank = $1;

-- name: GetAllCompanyNames :many
SELECT companies.id, company_name, company_type, 
CASE WHEN company_parent_id IS NULL THEN FALSE::boolean ELSE TRUE::boolean END AS is_branch 
FROM companies;

-- name: GetAllCompaniesNameByCompanyType :many
SELECT companies.id, company_name, company_type, 
CASE WHEN company_parent_id IS NULL THEN FALSE::boolean ELSE TRUE::boolean END AS is_branch 
FROM companies
WHERE company_type = $1;

-- name: GetCompanyDocs :many
-- SELECT 
--     logo_url,
--     cover_image_url,
--     commercial_license_no,
--     commercial_license_file_url,
--     commercial_license_issue_date,
--     commercial_license_expiry,
--     commercial_license_registration_date,
--     rera_no,
--     rera_file_url,
--     rera_issue_date,
--     rera_expiry,
--     rera_registration_date,
--     vat_no,
--     vat_status,
--     vat_file_url,
--     orn_license_no,
--     orn_license_file_url,
--     orn_registration_date,
--     orn_license_expiry,
--     trakhees_permit_no,
--     license_dcci_no,
--     register_no,
--     extra_license,
--     company_id
-- FROM companies_licenses
-- INNER JOIN companies ON companies.id = companies_licenses.company_id 
-- WHERE companies.id = $1 LIMIT 1;
SELECT 
     license.*,logo_url,cover_image_url,vat_no,vat_status,vat_file_url, 
    COALESCE(
         NULLIF(JSON_AGG(ROW_TO_JSON(state_license_fields))::text, '[null]'), NULL
    )::jsonb AS state_license_fields
FROM license 
INNER JOIN companies ON companies.id = entity_id AND entity_type_id = 6
LEFT JOIN 
    state_license_fields 
    ON state_license_fields.license_id = license.id
WHERE companies.id = @company_id::bigint
GROUP BY 
    license.id,logo_url,cover_image_url,vat_no,vat_status,vat_file_url;

-- name: UpdateCompaniesLogoAndCoverImage :one
UPDATE companies
SET logo_url = $2,
    cover_image_url = $3,
    updated_at = $4
WHERE id = $1
RETURNING *;

-- name: GetAllCompanyNamesByBranchAndType :many
SELECT companies.id, company_name
FROM companies
WHERE 
CASE 
	WHEN @is_branch::boolean = TRUE THEN companies.company_type = @company_type AND company_parent_id IS NOT NULL
	ELSE companies.company_type = @company_type AND company_parent_id IS NULL
END AND status != 5 AND status != 6; 

-- name: GetBranchCompanyNamesByParentCompany :many
SELECT companies.id, company_name
FROM companies
WHERE company_parent_id = $1;

-- name: GetAllBrokerCompanyNamesByStateOrCity :many
SELECT companies.id,company_name,
    CASE WHEN company_parent_id IS NULL THEN FALSE::boolean ELSE TRUE::boolean END AS is_branch
FROM companies
INNER JOIN addresses ON companies.addresses_id = addresses.id
INNER JOIN company_types ON company_types.id = companies.company_type
WHERE 
CASE WHEN @is_state::boolean = FALSE THEN addresses.cities_id = @id::bigint ELSE addresses.states_id = @id::bigint END 
AND company_types.id = 1;


-- name: CreateCompaniesLeadership :one
INSERT INTO companies_leadership (
    name,
    position,
    description,
    description_ar,
    image_url,
    companies_id,
    created_by,
    created_at
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- name: GetAllCompaniesLeadersByCompany :many
SELECT *, COUNT(id) OVER() AS total_count FROM companies_leadership WHERE companies_id = $3 ORDER BY id  LIMIT $1  OFFSET $2;

-- name: GetCompaniesLeadership :one
SELECT * FROM companies_leadership 
WHERE id = $1 LIMIT 1;

-- name: UpdateCompaniesLeadership :one
UPDATE companies_leadership
SET    name = $2,
    position = $3,
    description = $4,
    description_ar = $5,
    image_url = $6,
    updated_at = $7
Where id = $1
RETURNING *;

-- name: DeleteCompaniesLeadership :exec
DELETE FROM companies_leadership
Where id = $1;

-- name: GetSingleCompanyByUserId :one
select * from companies where users_id = $1;

-- name: GetCompanyById :one
SELECT companies.*, COALESCE(parent.company_name, '') AS company_parent_name  FROM companies
LEFT JOIN companies parent ON parent.id = companies.company_parent_id
WHERE companies.id = $1;

-- name: CreateStateLicenseFields :one
INSERT INTO state_license_fields(
    field_name,
    field_value,
    license_id
)VALUES(
    $1 ,$2, $3
)RETURNING *;


-- name: GetLicensesByEntityAndEntityTypeID :many 
SELECT 
    license.*, 
    JSON_AGG(ROW_TO_JSON(state_license_fields)) AS state_license_fields
FROM 
    license
LEFT JOIN 
    state_license_fields 
    ON state_license_fields.license_id = license.id
WHERE 
    license.entity_type_id = $1 
    AND license.entity_id = $2
GROUP BY 
    license.id;

-- name: GetLicensesByID :one 
SELECT 
    license.* 
FROM 
    license 
WHERE 
    id = $1;
    
-- name: UpdateLicense :one
UPDATE license
SET license_file_url = $2,
    license_no = $3,
    license_issue_date = $4,
    license_registration_date = $5,
    license_expiry_date = $6,
    state_id = $7,
    metadata = $8
WHERE id = $1
RETURNING *;


-- name: UpdateLicenseByEntityID :one
UPDATE license
SET license_file_url = $2,
    license_no = $3,
    license_issue_date = $4,
    license_registration_date = $5,
    license_expiry_date = $6,
    state_id = $7
WHERE  entity_type_id = 9 AND  entity_id = $1
RETURNING *;



-- name: DeleteAllLicensesByIds :exec
DELETE FROM license WHERE id = ANY(@ids::bigint[]);

-- name: UpdateStateLicenseFieldsByLicense :one
UPDATE state_license_fields
SET field_value = $3
WHERE license_id = $1 AND field_name = $2
RETURNING *;

-- name: DeleteStateLicenseFieldsByNames :exec
DELETE FROM state_license_fields
WHERE field_name = ANY(@field_names::varchar[]) AND license_id = @license_id::bigint;

-- name: UpdateLicenseStateByEntityAndEntityTypeId :exec
UPDATE license SET state_id = $1
WHERE entity_type_id = $2 AND entity_id = $3;

-- name: GetAllCompanies :many
SELECT  
	c.id, c.created_at, c.company_name, c.logo_url, c.email,c.phone_number, c.status, c.company_rank,  c.addresses_id, c.created_by,c.users_id,c.company_type,c.created_at,
	cl.license_no,CONCAT(profiles.first_name,' ',profiles.last_name)::varchar AS admin_name, addresses.full_address ,roles.role AS added_by_role
    -- , cl.orn_license_no, cl.orn_license_file_url, cl.orn_registration_date, cl.orn_license_expiry
FROM companies as c
 INNER JOIN addresses ON c.addresses_id = addresses.id
 INNER JOIN countries ON addresses.countries_id = countries.id
 INNER JOIN states ON addresses.states_id = states.id
 INNER JOIN cities ON addresses.cities_id = cities.id 
  LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id

 INNER JOIN users ON c.created_by = users.id 
 INNER JOIN users as admin ON c.users_id = admin.id
 INNER JOIN profiles ON admin.id = profiles.users_id
 LEFT  JOIN roles ON users.roles_id =  roles.id AND users.roles_id IS NOT NULL
 INNER JOIN license cl ON cl.entity_id = c.id AND entity_type_id = @entity_type_id::bigint AND license_type_id = @license_type_id::bigint
--  INNER JOIN companies_licenses cl ON cl.company_id = c.id
--  LEFT  JOIN branch_companies ON branch_companies.companies_id = c.id
WHERE
    (
       @search = '%%'
       OR c.company_name ILIKE @search
       OR (CASE 
        WHEN 'standard' ILIKE @search THEN c.company_rank = 1
        WHEN 'featured' ILIKE @search THEN c.company_rank = 2 
        WHEN 'premium'  ILIKE @search THEN c.company_rank = 3
        WHEN 'top deal' ILIKE @search THEN c.company_rank = 4
        ELSE FALSE
      END)
      OR cl.license_no ILIKE @search
      OR countries.country ILIKE @search
      OR states.state ILIKE @search
      OR cities.city ILIKE @search    
      OR communities.community ILIKE @search 
      OR sub_communities.sub_community ILIKE @search    
      OR roles."role" ILIKE @search
      OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
      OR c.email ILIKE @search
      OR c.phone_number ILIKE @search
    )
    AND
  	CASE WHEN @is_company_user != true THEN true ELSE c.id = @company_id::bigint AND c.company_type =   @company_type::bigint END
   AND 
    -- CASE WHEN @country_id::bigint = 0 THEN true WHEN @is_international::boolean = true THEN addresses.countries_id != @country_id::bigint ELSE addresses.countries_id = @country_id::bigint END
   CASE 
   WHEN @country_id::bigint = 0 THEN true
        WHEN 'international' = @localize::varchar THEN addresses.countries_id != @country_id::bigint 
  		WHEN 'local' = @localize::varchar THEN addresses.countries_id = @country_id::bigint END
--    ELSE ''= @localize::varchar AND addresses.countries_id = @country_id::bigint END
   AND CASE WHEN @city_id::bigint = 0 Then true ELSE addresses.cities_id = @city_id::bigint END
   AND CASE WHEN @community_id::bigint = 0 THEN true ELSE addresses.communities_id = @community_id::bigint END
   AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_community_id::bigint END
   AND CASE WHEN @status::bigint = 0 THEN (c.status != 5 AND c.status != 6) ELSE c.status = @status::bigint END
--    AND CASE WHEN @status::bigint = 0 THEN c.company_parent_id IS NULL ELSE true END
ORDER BY created_at DESC  LIMIT $1 OFFSET $2;

-- name: GetCountAllCompanies :one
SELECT COUNT(c.*)
FROM companies as c
 INNER JOIN addresses ON c.addresses_id = addresses.id
 INNER JOIN countries ON addresses.countries_id = countries.id
 INNER JOIN states ON addresses.states_id = states.id
 INNER JOIN cities ON addresses.cities_id = cities.id 
    LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id

 INNER JOIN users ON c.created_by = users.id 
 INNER JOIN users as admin ON c.users_id = admin.id
 INNER JOIN profiles ON admin.id = profiles.users_id
 LEFT  JOIN roles ON users.roles_id =  roles.id AND users.roles_id IS NOT NULL
 INNER JOIN license cl ON cl.entity_id = c.id AND entity_type_id = @entity_type_id::bigint AND license_type_id = @license_type_id::bigint
--  INNER JOIN companies_licenses cl ON cl.company_id = c.id
--  LEFT  JOIN branch_companies ON branch_companies.companies_id = c.id
WHERE
    (
       @search = '%%'
       OR c.company_name ILIKE @search
       OR (CASE 
        WHEN 'standard' ILIKE @search THEN c.company_rank = 1
        WHEN 'featured' ILIKE @search THEN c.company_rank = 2 
        WHEN 'premium'  ILIKE @search THEN c.company_rank = 3
        WHEN 'top deal' ILIKE @search THEN c.company_rank = 4
        ELSE FALSE
      END)
      OR cl.license_no ILIKE @search
      OR countries.country ILIKE @search
      OR states.state ILIKE @search
      OR cities.city ILIKE @search  
      OR communities.community ILIKE @search 
      OR sub_communities.sub_community ILIKE @search       
      OR roles."role" ILIKE @search
      OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
      OR c.email ILIKE @search
      OR c.phone_number ILIKE @search
    )
    AND
  	CASE WHEN @is_company_user != true THEN true ELSE c.id = @company_id::bigint AND c.company_type =   @company_type::bigint END
    AND 
-- CASE WHEN @country_id::bigint = 0 THEN true WHEN @is_international::boolean = true THEN addresses.countries_id != @country_id::bigint ELSE addresses.countries_id = @country_id::bigint END
    CASE 
   		WHEN @country_id::bigint = 0 THEN true 
   		WHEN 'international' = @localize::varchar THEN addresses.countries_id != @country_id::bigint 
  		WHEN 'local' = @localize::varchar THEN addresses.countries_id = @country_id::bigint END
--    ELSE '' = @localize::varchar AND addresses.countries_id = @country_id::bigint END
   AND CASE WHEN @city_id::bigint = 0 Then true ELSE addresses.cities_id = @city_id::bigint END
   AND CASE WHEN @community_id::bigint = 0 THEN true ELSE addresses.communities_id = @community_id::bigint END
   AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_community_id::bigint END
   AND CASE WHEN @status::bigint = 0 THEN (c.status != 5 AND c.status != 6) ELSE c.status = @status::bigint END;
--    AND CASE WHEN @status::bigint = 0 THEN c.company_parent_id IS NULL ELSE true END;




 
-- name: GetCompaniesCountByActivity :one                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
SELECT COUNT(*) FROM companies 
WHERE $1::BIGINT=any(company_activities_id);
 



-- name: GetBrnLicenseByUserID :one
SELECT * FROM license 
WHERE license.license_type_id = 5 AND license.entity_type_id = 9 AND license.entity_id = @user_id;


-- name: GetNocLicenseByUserID :one
SELECT * FROM license 
WHERE license.license_type_id = 6 AND license.entity_type_id = 9 AND license.entity_id = @user_id;

-- name: GetAllSocialByUser :many
SELECT * FROM social_media_profile
WHERE social_media_profile.entity_type_id = 9 AND social_media_profile.entity_id = @user_id;



-- name: GetSubCompaniesByParent :many
SELECT  
	c.id, c.created_at, c.company_name, c.logo_url, c.email,c.phone_number, c.status, c.company_rank,  c.addresses_id, c.created_by,c.users_id,c.company_type,c.created_at,
	cl.license_no,CONCAT(profiles.first_name,' ',profiles.last_name)::varchar AS admin_name,addresses.full_address ,roles.role AS added_by_role
    -- , cl.orn_license_no, cl.orn_license_file_url, cl.orn_registration_date, cl.orn_license_expiry
FROM companies as c
 INNER JOIN addresses ON c.addresses_id = addresses.id
 INNER JOIN countries ON addresses.countries_id = countries.id
 INNER JOIN states ON addresses.states_id = states.id
 INNER JOIN cities ON addresses.cities_id = cities.id 
  LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id

 INNER JOIN users ON c.created_by = users.id 
 INNER JOIN users as admin ON c.users_id = admin.id
 INNER JOIN profiles ON admin.id = profiles.users_id
 LEFT  JOIN roles ON users.roles_id =  roles.id AND users.roles_id IS NOT NULL
 INNER JOIN license cl ON cl.entity_id = c.id AND entity_type_id = @entity_type_id::bigint AND license_type_id = @license_type_id::bigint
WHERE
    (
       @search = '%%'
       OR c.company_name ILIKE @search
       OR (CASE 
        WHEN 'standard' ILIKE @search THEN c.company_rank = 1
        WHEN 'featured' ILIKE @search THEN c.company_rank = 2 
        WHEN 'premium'  ILIKE @search THEN c.company_rank = 3
        WHEN 'top deal' ILIKE @search THEN c.company_rank = 4
        ELSE FALSE
      END)
      OR cl.license_no ILIKE @search
      OR countries.country ILIKE @search
      OR states.state ILIKE @search
      OR cities.city ILIKE @search    
      OR communities.community ILIKE @search 
      OR sub_communities.sub_community ILIKE @search    
      OR roles."role" ILIKE @search
      OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
      OR c.email ILIKE @search
      OR c.phone_number ILIKE @search
    )
    AND
  	CASE WHEN @is_company_user != true THEN true ELSE c.id = @company_id::bigint AND c.company_type =   @company_type::bigint END
   AND CASE WHEN @country_id::bigint = 0 THEN true  ELSE addresses.countries_id = @country_id::bigint END
   AND CASE WHEN @city_id::bigint = 0 Then true ELSE addresses.cities_id = @city_id::bigint END
   AND CASE WHEN @community_id::bigint = 0 THEN true ELSE addresses.communities_id = @community_id::bigint END
   AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_community_id::bigint END
   AND (c.status !=5 AND c.status != 6)  
   AND c.company_parent_id = @parent_company_id::bigint
ORDER BY created_at DESC  LIMIT $1 OFFSET $2;

-- name: GetCountSubCompaniesByParent :one
SELECT  
	COUNT(c.id)
FROM companies as c
 INNER JOIN addresses ON c.addresses_id = addresses.id
 INNER JOIN countries ON addresses.countries_id = countries.id
 INNER JOIN states ON addresses.states_id = states.id
 INNER JOIN cities ON addresses.cities_id = cities.id 
  LEFT JOIN communities ON addresses.communities_id = communities.id
 LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id

 INNER JOIN users ON c.created_by = users.id 
 INNER JOIN users as admin ON c.users_id = admin.id
 INNER JOIN profiles ON admin.id = profiles.users_id
 LEFT  JOIN roles ON users.roles_id =  roles.id AND users.roles_id IS NOT NULL
 INNER JOIN license cl ON cl.entity_id = c.id AND entity_type_id = @entity_type_id::bigint AND license_type_id = @license_type_id::bigint
WHERE
    (
       @search = '%%'
       OR c.company_name ILIKE @search
       OR (CASE 
        WHEN 'standard' ILIKE @search THEN c.company_rank = 1
        WHEN 'featured' ILIKE @search THEN c.company_rank = 2 
        WHEN 'premium'  ILIKE @search THEN c.company_rank = 3
        WHEN 'top deal' ILIKE @search THEN c.company_rank = 4
        ELSE FALSE
      END)
      OR cl.license_no ILIKE @search
      OR countries.country ILIKE @search
      OR states.state ILIKE @search
      OR cities.city ILIKE @search    
      OR communities.community ILIKE @search 
      OR sub_communities.sub_community ILIKE @search    
      OR roles."role" ILIKE @search
      OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
      OR c.email ILIKE @search
      OR c.phone_number ILIKE @search
    )
    AND
  	CASE WHEN @is_company_user != true THEN true ELSE c.id = @company_id::bigint AND c.company_type =   @company_type::bigint END
   AND CASE WHEN @country_id::bigint = 0 THEN true  ELSE addresses.countries_id = @country_id::bigint END
   AND CASE WHEN @city_id::bigint = 0 Then true ELSE addresses.cities_id = @city_id::bigint END
   AND CASE WHEN @community_id::bigint = 0 THEN true ELSE addresses.communities_id = @community_id::bigint END
   AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE addresses.sub_communities_id = @sub_community_id::bigint END
   AND (c.status !=5 AND c.status != 6)  
   AND c.company_parent_id = @parent_company_id::bigint;


-- -- name: GetAllUsersFromCompanyIds :many
-- SELECT companies.users_id From companies
-- WHERE id = ANY(@companies_id::bigint[]);

-- name: GetAUsersFromCompanyId :one
SELECT companies.users_id From companies
WHERE id = $1;


-- name: GetUserLicenseByID :one 
SELECT 
    license.* 
FROM 
    license 
WHERE 
    id = $1 AND entity_type_id = 9;