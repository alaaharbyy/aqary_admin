-- name: CreateBrokerCompany :one
INSERT INTO broker_companies (
    company_name,
    description,
    logo_url,
    addresses_id,
    email,
    phone_number,
    whatsapp_number,
    commercial_license_no,
    commercial_license_file_url,
    commercial_license_expiry,
    rera_no,
    rera_file_url,
    rera_expiry,
    is_verified,
    website_url,
    cover_image_url,
    tag_line,
    vat_no,
    vat_status,
    vat_file_url,
    facebook_profile_url,
    instagram_profile_url,
    twitter_profile_url,
    no_of_employees,
    users_id,
    linkedin_profile_url,
    company_rank,
    status,
    country_id,
    company_type,
    is_branch,
    created_at,
    updated_at,
    ref_no,
    rera_registration_date,
    rera_issue_date,
    commercial_license_registration_date,
    commercial_license_issue_date,
    youtube_profile_url,
    orn_license_no,
    orn_license_file_url,
    orn_registration_date,
    orn_license_expiry,
    bank_account_details_id,
    created_by,
    trakhees_permit_no,
    extra_license_nos,
    extra_license_files,
    extra_license_names,
    extra_license_issue_date,
    extra_license_expiry_date,
    license_dcci_no,
    register_no,
    other_social_media
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, 
    $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, $35, $36, $37, $38, 
    $39, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $50, $51, $52, $53, $54
) RETURNING *;

-- name: GetBrokerCompany :one
SELECT * FROM broker_companies 
WHERE id = $1 LIMIT 1;

-- name: GetCountBrokerCompany :one
SELECT COUNT(*) FROM broker_companies LIMIT 1;

-- -- name: GetCountBrokerCompanyByMainServiceId :one
-- SELECT COUNT(*) FROM broker_companies 
-- WHERE main_services_id = $1;

-- name: GetCountBrokerCompanyByCountryId :one
SELECT COUNT(*) FROM broker_companies 
WHERE country_id = $1
LIMIT 1;

-- name: GetAllBrokerCompanyByCountry :many
SELECT * FROM broker_companies 
WHERE country_id = $3   LIMIT $1 OFFSET $2;

 
-- -- name: GetAllBrokerCompanyByMainServiceId :many
-- SELECT * FROM broker_companies 
-- WHERE main_services_id = $3 LIMIT $1 OFFSET $2;


-- name: GetAllBrokerCompanyByRank :many
SELECT * FROM broker_companies 
WHERE company_rank = $3 LIMIT $1 OFFSET $2;

-- name: GetAllBrokerCompanyByStatus :many
SELECT * FROM broker_companies 
WHERE status = $3 LIMIT $1 OFFSET $2;

-- name: GetAllBrokerCompanyByCountryNotEqual :many
SELECT * FROM broker_companies 
WHERE country_id != $3    LIMIT $1 OFFSET $2;

-- -- name: GetBrokerCompanyByName :one
-- SELECT * FROM broker_companies 
-- WHERE company_name ILIKE $1 LIMIT 1;

-- name: GetAllBrokerCompany :many
SELECT * FROM broker_companies
ORDER BY id
LIMIT $1
OFFSET $2;
 
-- name: UpdateBrokerCompany :one
UPDATE broker_companies
SET   company_name =$2,
    description =$3,
    logo_url =$4,
    addresses_id =$5,
    email =$6,
    phone_number =$7,
    whatsapp_number =$8,
    commercial_license_no =$9,
    commercial_license_file_url =$10,
    commercial_license_expiry =$11,
    rera_no =$12,
    rera_file_url = $13,
    rera_expiry = $14,
    is_verified = $15,
    website_url =$16,
    cover_image_url = $17,
    tag_line =$18,
    vat_no =$19,
    vat_status =$20,
    vat_file_url =$21,
    facebook_profile_url =$22,
    instagram_profile_url =$23,
    twitter_profile_url= $24,
    no_of_employees = $25,
    users_id = $26,
    linkedin_profile_url = $27,
    company_rank = $28,
    status = $29,
    country_id = $30,
    company_type = $31,
    is_branch = $32,
    created_at = $33,
    updated_at = $34,
    ref_no = $35,
    rera_registration_date = $36,
    rera_issue_date = $37,
    commercial_license_registration_date = $38,
    commercial_license_issue_date = $39,
    trakhees_permit_no = $40,
     extra_license_nos = $41,
    extra_license_files = $42,
    extra_license_names = $43,
    extra_license_issue_date = $44,
    extra_license_expiry_date = $45,
    license_dcci_no = $46,
    register_no = $47,
    other_social_media = $48,
    youtube_profile_url = $49,
    orn_license_no = $50,
    orn_license_file_url = $51,
    orn_registration_date = $52,
    orn_license_expiry = $53,
    bank_account_details_id = $54,
    created_by = $55
Where id = $1
RETURNING *;


-- name: DeleteBrokerCompany :exec
DELETE FROM broker_companies
Where id = $1;



-- -- name: GetBrokerCompanySubscriptionById :one
-- SELECT broker_subscription_id FROM broker_companies 
-- WHERE id = $1 LIMIT $1;





-- -- name: GetBrokerCompanyBySubscriptionId :one
-- SELECT * FROM broker_companies 
-- WHERE  broker_subscription_id = $1 LIMIT 1;


-- name: GetBrokerCompanyDocs :one
SELECT logo_url, commercial_license_file_url,
 rera_file_url,
  cover_image_url, 
  vat_file_url 
FROM broker_companies Where id = $1 LIMIT 1;



-- name: GetAllBrokerCompanyNames :many
SELECT company_name, id, company_type, is_branch FROM broker_companies
UNION ALL
SELECT company_name, id, company_type, is_branch FROM  broker_companies_branches;


-- name: GetAllDeveloperCompanyNames :many
SELECT company_name, id, company_type, is_branch FROM developer_companies
UNION ALL
SELECT company_name, id, company_type, is_branch FROM developer_company_branches;


-- name: GetAllServiceCompanyNames :many
SELECT company_name, id, company_type, is_branch FROM services_companies
UNION ALL
SELECT company_name, id, company_type, is_branch FROM service_company_branches;


-- name: GetAllBrokerCompanyNamesByCityId :many
With broker As (
SELECT broker_companies.id, broker_companies.company_name, broker_companies.is_branch FROM broker_companies
  LEFT JOIN addresses ON broker_companies.addresses_id = addresses.id 
  LEFT JOIN cities ON addresses.cities_id = cities.id
 
   WHERE addresses.cities_id = $1
 ) SELECT * from broker 
UNION ALL
SELECT combine_table.* FROM (
SELECT broker_companies_branches.id, broker_companies_branches.company_name, broker_companies_branches.is_branch From broker_companies_branches
   LEFT JOIN addresses ON broker_companies_branches.addresses_id = addresses.id 
  LEFT JOIN cities ON addresses.cities_id = cities.id
   WHERE addresses.cities_id = $1
) as combine_table;


-- name: GetAllBrokerCompanyNamesByStateId :many
With broker As (
SELECT broker_companies.id, broker_companies.company_name, broker_companies.is_branch FROM broker_companies
  LEFT JOIN addresses ON broker_companies.addresses_id = addresses.id 
  LEFT JOIN states ON addresses.states_id =  states.id

   WHERE addresses.states_id = $1
 ) SELECT * from broker 
UNION ALL

SELECT combine_table.* FROM (
SELECT broker_companies_branches.id, broker_companies_branches.company_name, broker_companies_branches.is_branch From broker_companies_branches
   LEFT JOIN addresses ON broker_companies_branches.addresses_id = addresses.id 
   LEFT JOIN states ON addresses.states_id = states.id
   WHERE addresses.states_id = $1
   
) as combine_table;


-- -- name: UpdateBrokerCompanyMainService :one
-- UPDATE broker_companies
-- SET main_services_id = $2
-- Where id = $1
-- RETURNING *;

-- name: UpdateBrokerCompanyRank :one
UPDATE broker_companies 
SET company_rank=$2 
Where id = $1 
RETURNING *;


-- name: UpdateBrokerCompanyStatus :one
UPDATE broker_companies 
SET status=$2
Where id =$1 
RETURNING *;


------------------ verification of all companies ------------------------

-- name: VerifyBrokerCompany :one
UPDATE broker_companies 
SET status = 2,
is_verified = true
Where id =$1 
RETURNING *;


-- name: VerifyDeveloperCompany :one
UPDATE developer_companies
SET status= 2,
is_verified = TRUE 
Where id =$1 
RETURNING *;



-- name: VerifyServiceCompany :one
UPDATE services_companies 
SET status= 2,
is_verified = TRUE 
Where id =$1 
RETURNING *;



-------------------------



-- name: VerifyBrokerBranchCompany :one
UPDATE broker_companies_branches 
SET status= 2,
is_verified = TRUE 
Where id =$1 
RETURNING *;


-- name: VerifyDeveloperBranchCompany :one
UPDATE developer_company_branches
SET status= 2,
is_verified = TRUE 
Where id =$1 
RETURNING *;



-- name: VerifyServiceBranchCompany :one
UPDATE service_company_branches 
SET status = 2,
is_verified = TRUE 
Where id =$1
RETURNING *;

------------------  ------------------------

 
-- -- name: GetBrokerCompanyByIdAndIsBranch :many
-- With x As (
--   SELECT id, company_name, tag_line, commercial_license_no, commercial_license_file_url, 
--   commercial_license_expiry, vat_no, vat_status, vat_file_url , 
--   facebook_profile_url, instagram_profile_url, linkedin_profile_url, twitter_profile_url, users_id, 
--   broker_subscription_id , main_services_id, no_of_employees, 
--   logo_url, cover_image_url, description, is_verified, website_url, phone_number, email, 
--   whatsapp_number, addresses_id, company_rank, status, country_id, company_type, is_branch, 
--   created_at, updated_at, subcompany_type, ref_no 
--   FROM broker_companies WHERE broker_companies.id = $1 AND broker_companies.is_branch = $2 
--   UNION all
--    SELECT id, company_name, tag_line, commercial_license_no, commercial_license_file_url, 
--    commercial_license_expiry, vat_no, vat_status, vat_file_url , 
--    facebook_profile_url, instagram_profile_url, linkedin_profile_url, twitter_profile_url, 
--    users_id, broker_subscription_id , main_services_id, 
--    no_of_employees, logo_url, cover_image_url, description, is_verified, website_url, phone_number, 
--    email, whatsapp_number, addresses_id, company_rank, status, country_id, company_type, is_branch, 
--    created_at, updated_at, subcompany_type, ref_no FROM broker_companies_branches  
--     WHERE broker_companies_branches.id = $1 AND broker_companies_branches.is_branch = $2 ) 
--   select id, is_branch from x;





-- name: GetBrokerCompanyCountryAndStateById :one
SELECT countries.id,countries.country, states.id,states."state" 
FROM broker_companies
LEFT JOIN addresses ON addresses.id = broker_companies.addresses_id
LEFT JOIN countries ON countries.id = addresses.countries_id
LEFT JOIN states ON states.id = addresses.states_id
WHERE broker_companies.id = $1 LIMIT $1;

-- name: GetBrokerCompanyAddressId :one
SELECT addresses_id FROM broker_companies WHERE id = $1 LIMIT 1;



-- name: GetAllBrokerCompaniesByCountryAndState :many
WITH x AS (
    SELECT companies.id, companies.company_name
    FROM companies
    INNER JOIN addresses ON addresses.id = companies.addresses_id
    WHERE addresses.countries_id = @countries_id   
    AND CASE  
        WHEN @state_id::bigint = 0 THEN true
        ELSE addresses.states_id = @state_id::bigint
    END
 )
SELECT MIN(id) AS id, company_name 
FROM x
GROUP BY company_name;

-- -- name: GetBrokerCompanyByReraNo :one
-- SELECT * FROM broker_companies 
-- WHERE rera_no ILIKE $1 LIMIT 1;

-- -- name: GetBrokerCompanyByCommercialLicNo :one
-- SELECT * FROM broker_companies 
-- WHERE commercial_license_no ILIKE $1 LIMIT 1;