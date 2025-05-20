-- name: InsertContactsCompanyDetails :one
INSERT INTO contacts_company_details (
    contacts_id,
    -- company_id,
    -- which_company,
    no_of_employees,
    industry_id,
    -- which_property,
    no_local_business,
    retail_category_id,
    no_remote_business,
    nationality,
    license,
    issued_date,
    expiry_date,
    external_id
)
VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11
    --  $12
    -- $13
    -- $14
)
RETURNING *;

-- name: CreateContactsCompanyDetails :one
INSERT INTO contacts_company_details (
    contacts_id,
    companies_id,
    company_category,
    is_branch,
    no_of_employees,
    industry_id,
    no_local_business,
    retail_category_id,
    no_remote_business,
    nationality,
    license,
    issued_date,
    expiry_date,
    external_id
) VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10,
    $11,
    $12,
    $13,
    $14
) RETURNING id, contacts_id, companies_id, company_category, is_branch, no_of_employees, industry_id, no_local_business, retail_category_id, no_remote_business, nationality, license, issued_date, expiry_date, external_id;

-- name: UpdateContactsCompanyDetails :one
UPDATE contacts_company_details
SET
    companies_id = $2,
    company_category = $3,
    is_branch = $4,
    no_of_employees = $5,
    industry_id = $6,
    no_local_business = $7,
    retail_category_id = $8,
    no_remote_business = $9,
    nationality = $10,
    license = $11,
    issued_date = $12,
    expiry_date = $13,
    external_id = $14
WHERE
    contacts_id = $1
RETURNING *;


-- name: GetSingleContactCompanyDetails :one
select * from contacts_company_details where contacts_id = $1 LIMIT 1;