-- -- name: CreateEmployer :one
-- INSERT INTO employers (
--    ref_no,
--    company_type,
--    company_id,
--    is_branch,
--    company_name,
--    industry_id,
--    company_size,
--    license_number,
--    website,
--    email_address,
--    mobile_number,
--    is_verified,
--    countries_id,
--    states_id,
--    cities_id,
--    community_id,
--    subcommunity_id,
--    users_id,
--     created_at
-- ) VALUES (
--    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18,$19
-- ) RETURNING *;
 
-- -- name: UpdateEmployer :one
-- UPDATE employers
-- SET
--    company_type = $1,
--    company_id = $2,
--    is_branch = $3,
--    company_name = $4,
--    industry_id = $5,
--    company_size = $6,
--    license_number = $7,
--    website = $8,
--    email_address = $9,
--    mobile_number = $10,
--    is_verified = $11,
--    countries_id = $12,
--    states_id = $13,
--    cities_id = $14,
--    community_id = $15,
--    subcommunity_id = $16,
--    created_at = $17,
--    users_id = $18
--     -- status=$19
-- WHERE
--    id = $19
-- RETURNING *;

-- -- name: GetEmployerByUserId :one
-- SELECT * FROM employers WHERE users_id = $1 Limit 1;
 
-- -- name: GetEmployerById :one
-- SELECT * FROM employers WHERE id = $1 LIMIT 1;
 
-- -- name: GetAllEmployers :many
-- SELECT * FROM employers;

-- -- -- name: UpdateEmployerStatus :one
-- -- UPDATE employers
-- -- SET
-- --     status=$1
-- -- WHERE
-- --    id = $2
-- -- RETURNING *;

-- -- name: GetCareersForCompany :many
-- SELECT
-- sqlc.embed(c)
-- FROM employers e 
-- JOIN careers c ON c.employers_id=e.id
-- WHERE e.company_id=$1 AND e.company_type=$2 AND e.company_name=$3  AND is_branch=$4 AND c.career_status!=6
-- LIMIT $6 OFFSET $5;



-- -- name: GetCountCareersForCompany :one
-- SELECT
-- count(*)
-- FROM employers e 
-- JOIN careers c ON c.employers_id=e.id
-- WHERE e.company_id=$1 AND e.company_type=$2 AND e.company_name=$3  AND is_branch=$4 AND c.career_status!=6;

