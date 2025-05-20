-- name: CreateBrokerBranchCompany :one
INSERT INTO broker_companies_branches (
    broker_companies_id,
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
    -- admin of the company
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
    -- when the rera registered for the first time
    rera_registration_date,
    rera_issue_date,
    -- when the commercial license registered for the first time
    commercial_license_registration_date,
    commercial_license_issue_date,
    extra_license_names,
    extra_license_files,
    extra_license_nos,
    extra_license_issue_date,
    extra_license_expiry_date,
    youtube_profile_url,
    orn_license_no,
    orn_license_file_url,
    orn_registration_date,
    orn_license_expiry,
    created_by,
    -- only for dubai
    trakhees_permit_no,
    -- only for dubai
    license_dcci_no,
    -- only for dubai
    register_no,
    other_social_media
    
)VALUES (
     $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20,
     $21,$22,$23,$24,$25,$26,$27,$28, $29, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, 
     $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $50, $51, $52, $53, $54, $55
) RETURNING *;


-- name: GetBrokerCompanyBranch :one
SELECT * FROM broker_companies_branches 
WHERE id = $1 LIMIT 1;

-- name: GetCountBrokerCompanyBranch :one
SELECT COUNT(*) FROM broker_companies_branches  LIMIT 1;

-- -- name: GetCountBrokerCompanyBranchByMainServiceId :one
-- SELECT COUNT(*) FROM broker_companies_branches WHERE main_services_id = $1  LIMIT 1;


-- -- name: GetBrokerCompanyBranchByMainServiceId :many
-- SELECT * FROM broker_companies_branches 
-- WHERE main_services_id = $3 LIMIT $1 OFFSET $2;

-- name: GetBrokerCompanyBranchByName :one
SELECT * FROM broker_companies_branches 
WHERE company_name ILIKE $1 LIMIT 1;


-- name: GetAllBrokerCompanyBranchByCompanyId :many
SELECT * FROM broker_companies_branches
Where broker_companies_id = $1
LIMIT $2
OFFSET $3;

-- name: GetCountAllBrokerCompanyBranchByCompanyId :one
SELECT COUNT(*) FROM broker_companies_branches
Where broker_companies_id = $1;

-- name: GetAllBrokerCompanyBranch :many
SELECT * FROM broker_companies_branches
ORDER BY id
LIMIT $1
OFFSET $2;


-- name: UpdateBrokerCompanyBranch :one
UPDATE broker_companies_branches
SET   company_name = $2,
    description = $3,
    logo_url = $4,
    addresses_id = $5,
    email = $6,
    phone_number = $7,
    whatsapp_number = $8,
    commercial_license_no = $9,
    commercial_license_file_url = $10,
    commercial_license_expiry = $11,
    rera_no = $12,
    rera_file_url = $13,
    rera_expiry = $14,
    is_verified = $15,
    website_url = $16,
    cover_image_url = $17,
    tag_line = $18,
    vat_no = $19,
    vat_status = $20,
    vat_file_url = $21,
    facebook_profile_url = $22,
    instagram_profile_url = $23,
    twitter_profile_url = $24,
    no_of_employees = $25,
    users_id = $26,
    linkedin_profile_url = $27, 
    company_rank = $28,
    status = $29,
    broker_companies_id = $30,
    country_id = $31,
    company_type = $32,
    is_branch = $33,
    created_at = $34,
    updated_at = $35, 
    ref_no = $36,
    rera_registration_date = $37,
    rera_issue_date = $38,
    commercial_license_registration_date= $39,
    commercial_license_issue_date= $40,
    trakhees_permit_no = $41,
     extra_license_nos = $42,
    extra_license_files = $43,
    extra_license_names = $44,
    extra_license_issue_date = $45,
    extra_license_expiry_date = $46,
    license_dcci_no = $47,
    register_no = $48,
    other_social_media = $49,
    youtube_profile_url = $50,
    orn_license_no = $51,
    orn_license_file_url = $52,
    orn_registration_date = $53,
    orn_license_expiry = $54,
    created_by = $55,
    bank_account_details_id = $56
Where id = $1
RETURNING *;


-- name: DeleteBrokerCompanyBranch :exec
DELETE FROM broker_companies_branches
Where id = $1; 


-- -- name: GetBrokerBranchCompanySubscriptionById :one
-- SELECT broker_subscription_id FROM broker_companies_branches 
-- WHERE id = $1;



-- -- name: UpdateBrokerBranchCompanyMainService :one
-- UPDATE broker_companies_branches
-- SET main_services_id = $2
-- Where id = $1
-- RETURNING *;




 

-- name: UpdateBrokerBranchCompanyMainService :one
-- UPDATE broker_companies_branches
-- SET main_services_id = $2
-- Where id = $1
-- RETURNING *;


-- name: UpdateBrokerCompanyBranchRank :one
UPDATE broker_companies_branches 
SET company_rank=$2 
Where id =$1 
RETURNING *;

-- name: UpdateBrokerCompanyBranchStatus :one
UPDATE broker_companies_branches 
SET status=$2 
Where id =$1 
RETURNING *;

-- name: GetBrokerCompanyBranchAddressId :one
SELECT addresses_id FROM broker_companies_branches WHERE id = $1 LIMIT 1;


-- name: GetBrokerCompanyBranchByReraNo :one
SELECT * FROM broker_companies_branches 
WHERE rera_no ILIKE $1 LIMIT 1;

-- name: GetBrokerCompanyBranchByCommercialLicNo :one
SELECT * FROM broker_companies_branches 
WHERE commercial_license_no ILIKE $1 LIMIT 1;