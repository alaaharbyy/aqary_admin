-- name: CreateServiceBranchCompany :one
INSERT INTO service_company_branches (
    services_companies_id,
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
    bank_account_details_id,
    company_rank,
    status,
    country_id,
    company_type,
    is_branch,
    created_at,
    updated_at,
    ref_no,
    -- when the commercial license registered for the first time
    commercial_license_registration_date,
    commercial_license_issue_date,
    extra_license_names,
    extra_license_files,
    extra_license_nos,
    extra_license_issue_date,
    extra_license_expiry_date,
    youtube_profile_url,
    created_by,
    -- only for dubai
    license_dcci_no,
    -- only for dubai
    register_no,
    other_social_media
)VALUES (
     $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, 
     $20,$21,$22,$23,$24,$25,$26,$27,$28, $29, $30, $31, $32, $33, $34,  $35, $36, $37, $38, $39, $40, $41, $42, $43, $44, $45
) RETURNING *;


-- name: GetServiceCompanyBranch :one
SELECT * FROM service_company_branches 
WHERE id = $1 LIMIT 1;

-- name: GetCountServiceCompanyBranch :one
SELECT COUNT(*) FROM service_company_branches LIMIT 1;

-- -- name: GetCountServiceCompanyBranchByMainService :one
-- SELECT COUNT(*) FROM service_company_branches WHERE main_services_id = $1 LIMIT 1;

-- -- name: GetAllServiceCompanyBranchBYMainServiceId :many
-- SELECT * FROM service_company_branches 
-- WHERE main_services_id = $3 LIMIT $1 OFFSET $2;

-- name: GetServiceCompanyBranchByName :one
SELECT * FROM service_company_branches 
WHERE company_name = $1 LIMIT 1;


-- name: GetAllServiceCompanyBranchByCompanyId :many
SELECT * FROM service_company_branches
Where services_companies_id = $1
LIMIT $2
OFFSET $3;

-- name: GetCountAllServiceCompanyBranchByCompanyId :one
SELECT COUNT(*) FROM service_company_branches
Where services_companies_id = $1;

-- name: GetAllServiceCompanyBranch :many
SELECT * FROM service_company_branches
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateServiceCompanyBranch :one
UPDATE service_company_branches
SET 
    company_name = $2,
    description = $3,
    logo_url = $4,
    addresses_id = $5,
    email = $6,
    phone_number = $7,
    whatsapp_number = $8,
    commercial_license_no = $9,
    commercial_license_file_url = $10,
    commercial_license_expiry = $11,
    is_verified = $12,
    website_url = $13,
    cover_image_url = $14,
    tag_line = $15,
    vat_no = $16,
    vat_status = $17,
    vat_file_url = $18,
    facebook_profile_url = $19,
    instagram_profile_url = $20,
    twitter_profile_url = $21,
    no_of_employees = $22,
    users_id = $23,
    linkedin_profile_url = $24,
    services_companies_id = $25,
    company_rank = $26,
    status = $27,
    country_id = $28,
    company_type = $29,
    is_branch = $30,
    created_at = $31,
    updated_at = $32,
    ref_no = $33,
    commercial_license_registration_date = $34,
    commercial_license_issue_date = $35,
    extra_license_nos = $36,
    extra_license_files = $37,
    extra_license_names = $38,
    extra_license_issue_date = $39,
    extra_license_expiry_date = $40,
    license_dcci_no = $41,
    register_no = $42,
    other_social_media = $43,
    youtube_profile_url = $44,
    created_by = $45,
    bank_account_details_id = $46
Where id = $1
RETURNING *;


-- name: DeleteServiceCompanyBranch :exec
DELETE FROM service_company_branches
Where id = $1; 

-- -- name: GetServiceBranchCompanySubscriptionById :one
-- SELECT services_subscription_id FROM service_company_branches 
-- WHERE id = $1;





-- -- name: UpdateServiceBranchCompanyMainService :one
-- UPDATE service_company_branches
-- SET main_services_id = $2
-- Where id = $1
-- RETURNING *;

-- name: UpdateServiceCompanyBranchRank :one
UPDATE service_company_branches 
SET company_rank=$2 
Where id =$1 
RETURNING *;

-- name: UpdateServiceCompanyBranchStatus :one
UPDATE service_company_branches 
SET status=$2 
Where id =$1 
RETURNING *;

-- name: GetServiceCompanyBranchByCommercialLicNo :one
SELECT * FROM service_company_branches 
WHERE commercial_license_no ILIKE $1 LIMIT 1;

-- name: GetServiceCompanyBranchForGraph :one 
SELECT id,
	company_name, 
	description, 
	logo_url, 
	cover_image_url, 
	is_verified, 
	commercial_license_no
FROM 
	service_company_branches 
WHERE 
	id=$1 
LIMIT 1;

