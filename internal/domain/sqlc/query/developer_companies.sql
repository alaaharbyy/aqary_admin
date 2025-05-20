-- name: CreateDeveloperCompany :one
INSERT INTO developer_companies (
    company_name,
    tag_line,
    commercial_license_no,
    commercial_license_file_url,
    commercial_license_expiry,
    vat_no,
    vat_status,
    vat_file_url, 
    facebook_profile_url,
    instagram_profile_url,
    linkedin_profile_url,
    twitter_profile_url,
    users_id,
    no_of_employees,
    logo_url,
    cover_image_url,
    description,
    is_verified, 
    website_url,
    phone_number,
    email,
    whatsapp_number,
    addresses_id,
    company_rank,
    status,
    country_id,
    company_type,
    is_branch,
    created_at,
    updated_at,
    ref_no,
     commercial_license_registration_date,
    commercial_license_issue_date,
    extra_license_files,
    extra_license_nos,
    extra_license_names,
    extra_license_issue_date,
    extra_license_expiry_date,
    license_dcci_no,
    register_no,
    other_social_media,
    youtube_profile_url,
    bank_account_details_id,
    created_by
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20,
    $21,$22,$23,$24,$25,$26,$27,$28, $29,$30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $40, $41, $42, $43, $44
) RETURNING *;


 
-- name: GetDeveloperCompanyNames :many
SELECT id, company_name FROM developer_companies  
LIMIT $1  OFFSET $2;


-- name: GetDeveloperCompany :one
SELECT * FROM developer_companies 
WHERE id = $1 LIMIT 1;


-- name: GetDeveloperBranchCompany :one
SELECT * FROM developer_company_branches 
WHERE id = $1 LIMIT 1;

-- name: GetCountDeveloperCompany :one
SELECT COUNT(*) FROM developer_companies LIMIT 1;

-- -- name: GetCountDeveloperCompanyByMainServiceId :one
-- SELECT COUNT(*) FROM developer_companies
-- WHERE main_services_id = $1
-- LIMIT 1;

-- name: GetCountDeveloperCompanyByCountryId :one
SELECT COUNT(*) FROM developer_companies
WHERE country_id = $1
LIMIT 1;

-- name: GetDevelopersCompanyByRank :many
SELECT * FROM developer_companies 
WHERE company_rank = $3  LIMIT $1 OFFSET $2;

-- name: GetDevelopersCompanyByStatus :many
SELECT * FROM developer_companies 
WHERE status = $3 LIMIT $1 OFFSET $2;

-- -- name: GetDevelopersCompanyByMainServiceId :many
-- SELECT * FROM developer_companies 
-- WHERE main_services_id = $3 LIMIT $1 OFFSET $2;

-- name: GetAllDeveloperCompanyByCountry :many
SELECT * FROM developer_companies 
WHERE country_id = $3    LIMIT $1 OFFSET $2;

-- name: GetAllDeveloperCompanyByCountryNotEqual :many
SELECT * FROM developer_companies 
WHERE country_id != $3     LIMIT $1 OFFSET $2;


-- name: GetDeveloperCompanyByName :one
SELECT * FROM developer_companies 
WHERE company_name ILIKE $1 LIMIT 1;

-- name: GetAllDeveloperCompany :many
SELECT * FROM developer_companies
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateDeveloperCompany :one
UPDATE developer_companies
SET  company_name = $2,
    tag_line =$3,
    commercial_license_no =$4,
    commercial_license_file_url =$5,
    commercial_license_expiry =$6,
    vat_no =$7,
    vat_status =$8,
    vat_file_url =$9,
    facebook_profile_url =$10,
    instagram_profile_url =$11,
    linkedin_profile_url =$12,
    twitter_profile_url =$13,
    users_id =$14,
    no_of_employees =$15,
    logo_url =$16,
    cover_image_url =$17,
    description =$18,
    is_verified =$19,
    website_url =$20,
    phone_number =$21,
    email =$22,
    whatsapp_number =$23,
    addresses_id =$24,
    company_rank = $25,
    status = $26,
    country_id = $27,
    company_type = $28,
    is_branch = $29,
    created_at = $30,
    updated_at = $31,
    ref_no = $32,
     commercial_license_registration_date = $33,
    commercial_license_issue_date = $34,
    extra_license_files = $35,
    extra_license_names = $36,
    extra_license_issue_date = $37,
    extra_license_expiry_date = $38,
    license_dcci_no = $39,
    register_no = $40,
    other_social_media = $41,
    youtube_profile_url = $42,
    extra_license_nos = $43,
    bank_account_details_id = $44,
    created_by = $45
Where id = $1
RETURNING *;


-- name: DeleteDeveloperCompany :exec
DELETE FROM developer_companies
Where id = $1;

-- -- name: GetDeveloperCompanySubscriptionById :one
-- SELECT developer_subscription_id FROM developer_companies 
-- WHERE id = $1;


 


-- name: GetDeveloperCompanyDocs :one
SELECT logo_url, commercial_license_file_url,
  cover_image_url, 
  vat_file_url 
FROM developer_companies Where id = $1 LIMIT 1;


-- -- name: GetDeveloperCompanyBySubscriptionId :one
-- SELECT * FROM developer_companies
-- WHERE developer_subscription_id = $1 LIMIT 1;



-- -- name: UpdateDeveloperCompanyMainService :one
-- UPDATE developer_companies
-- SET main_services_id = $2
-- Where id $1
-- RETURNING *;


-- name: UpdateDeveloperCompanyRank :one
UPDATE developer_companies 
SET company_rank=$2 
Where id =$1 
RETURNING *;


-- name: UpdateDeveloperCompanyStatus :one
UPDATE developer_companies 
SET status=$2 
Where id =$1 
RETURNING *;


-- name: GetDeveloperCompanyByIdAndIsBranch :many
with x as ( 
 SELECT id, company_name, tag_line, 
   commercial_license_no, 
    commercial_license_file_url, commercial_license_expiry, vat_no, vat_status, vat_file_url,
     facebook_profile_url, instagram_profile_url, linkedin_profile_url, 
     twitter_profile_url, users_id, 
     0 AS main_services_id, no_of_employees, logo_url, cover_image_url, description, is_verified, website_url, 
     phone_number, email, whatsapp_number, addresses_id, company_rank, status, country_id, company_type,
      is_branch, created_at, updated_at,0 AS subcompany_type, ref_no FROM developer_companies
       WHERE developer_companies.id = $1 AND developer_companies.is_branch = $2 
       UNION all
 SELECT id, company_name, tag_line, commercial_license_no, commercial_license_file_url, commercial_license_expiry, vat_no, vat_status, vat_file_url, facebook_profile_url, 
 instagram_profile_url, linkedin_profile_url, twitter_profile_url, users_id, main_services_id, no_of_employees, logo_url, cover_image_url,
  description, is_verified, website_url, phone_number, email, whatsapp_number, addresses_id, company_rank,
   status, country_id, company_type, is_branch, created_at, updated_at, subcompany_type, ref_no 
   FROM developer_company_branches WHERE developer_company_branches.id = $1 AND developer_company_branches.is_branch = $2 ) 
   select id, is_branch from x;



-- name: GetCountActiveListingByDeveloperCompanyId :one
SELECT count(projects.id) FROM projects 
WHERE projects.developer_companies_id = $1 AND projects.status != 5 AND projects.status != 6;





-- name: GetDeveloperCompanyByCommercialLicNo :one
SELECT * FROM developer_companies 
WHERE commercial_license_no ILIKE $1 LIMIT 1;

-- name: GetDeveloperCompanyForGraph :one 
SELECT id,
	company_name, 
	description, 
	logo_url, 
	cover_image_url, 
	is_verified, 
	commercial_license_no
FROM 
	developer_companies 
WHERE 
	id=$1 
LIMIT 1;

