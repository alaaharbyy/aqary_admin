-- name: CreateDeveloperCompanyBranch :one
INSERT INTO developer_company_branches (
    developer_companies_id,
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
    -- admin of the company
    users_id,
    bank_account_details_id,
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
     $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20,
     $21,$22,$23,$24,$25,$26,$27,$28, $29, $30, $31 ,$32, $33, $34, $35, $36, $37, $38, $39, $40, $41, $42, $43, $44, $45
) RETURNING *;

-- name: GetDeveloperCompanyBranchNames :many
SELECT id,company_name FROM developer_company_branches 
Where developer_companies_id = $3 LIMIT $1 OFFSET $2;


-- name: GetDeveloperCompanyBranch :one
SELECT * FROM developer_company_branches 
WHERE id = $1 LIMIT 1;

-- -- name: GetCountDeveloperCompanyBranchByMainServiceId :one
-- SELECT COUNT(*) FROM developer_company_branches WHERE main_services_id = $1  LIMIT 1;


-- name: GetCountDeveloperCompanyBranch :one
SELECT COUNT(*) FROM developer_company_branches LIMIT 1;

-- -- name: GetDeveloperCompanyBranchByMainServiceId :many
-- SELECT * FROM developer_company_branches 
-- WHERE main_services_id = $3 LIMIT $1 OFFSET $2;

-- name: GetDeveloperCompanyBranchByName :one
SELECT * FROM developer_company_branches 
WHERE company_name = $1 LIMIT 1;


-- name: GetAllDeveloperCompanyBranchByCompanyId :many
SELECT * FROM developer_company_branches
Where developer_companies_id = $1
LIMIT $2
OFFSET $3;

-- name: GetCountAllDeveloperCompanyBranchByCompanyId :one
SELECT COUNT(*) FROM developer_company_branches
Where developer_companies_id = $1;

-- name: GetAllDeveloperCompanyBranch :many
SELECT * FROM developer_company_branches
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateDeveloperCompanyBranch :one
UPDATE developer_company_branches
SET  company_name = $2,
    tag_line = $3,
    commercial_license_no = $4,
    commercial_license_file_url = $5,
    commercial_license_expiry = $6,
    vat_no = $7,
    vat_status = $8,
    vat_file_url = $9,
    facebook_profile_url = $10,
    instagram_profile_url = $11,
    linkedin_profile_url = $12,
    twitter_profile_url = $13,
    users_id = $14, 
    no_of_employees=$15,
    logo_url = $16,
    cover_image_url = $17,
    description = $18,
    is_verified = $19,
    website_url = $20,
    phone_number = $21,
    email = $22,
    whatsapp_number = $23,
    addresses_id = $24,
    developer_companies_id = $25,
    company_rank = $26,
    status = $27,
    country_id = $28,
    company_type = $29,
    is_branch = $30,
    created_at = $31,
    updated_at = $32, 
    ref_no= $33,
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


-- name: DeleteDeveloperCompanyBranch :exec
DELETE FROM developer_company_branches
Where id = $1;

-- -- name: GetDeveloperBranchCompanySubscriptionById :one
-- SELECT developer_subscription_id FROM developer_company_branches 
-- WHERE id = $1;







-- -- name: UpdateDeveloperBranchCompanyMainService :one
-- UPDATE developer_company_branches
-- SET main_services_id = $2
-- Where id = $1
-- RETURNING *;


-- name: UpdateDeveloperCompanyBranchRank :one
UPDATE developer_company_branches 
SET company_rank=$2 
Where id = $1 
RETURNING *;


-- name: UpdateDeveloperCompanyBranchStatus :one
UPDATE developer_company_branches 
SET status=$2 
Where id =$1 
RETURNING *;


-- name: GetCountActiveListingByBranchDeveloperCompanyId :one
SELECT count(projects.id) FROM projects 
WHERE projects.developer_company_branches_id = $1 AND projects.status != 5 AND projects.status != 6;


-- name: GetDeveloperCompanyBranchByCommercialLicNo :one
SELECT * FROM developer_companies 
WHERE commercial_license_no ILIKE $1 LIMIT 1;

-- name: GetDeveloperCompanyBranchForGraph :one 
SELECT id,
	company_name, 
	description, 
	logo_url, 
	cover_image_url, 
	is_verified, 
	commercial_license_no
FROM 
	developer_company_branches 
WHERE 
	id=$1 
LIMIT 1;

