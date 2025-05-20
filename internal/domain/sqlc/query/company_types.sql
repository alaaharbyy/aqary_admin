-- name: CreateCompanyType :one
INSERT INTO company_types (
    title,
    title_ar
)VALUES (
    $1,$2
) RETURNING *;

-- name: GetCompanyType :one
SELECT * FROM company_types 
WHERE id = $1 LIMIT 1;

-- name: GetCompanyTypeByTitle :one
SELECT * FROM company_types 
WHERE title = $1 LIMIT 1;
 
-- name: GetAllCompanyType :many
SELECT 
    COUNT(*) OVER() AS total_count,
    company_types.*
FROM company_types
ORDER BY company_types.updated_at DESC 
LIMIT COALESCE(NULLIF($1, 0), NULL) 
OFFSET COALESCE(NULLIF($2, 0), 0);


-- name: UpdateCompanyType :one
UPDATE company_types
SET 
title = $2,
title_ar=$3,
updated_at=now()
Where id = $1
RETURNING *;

-- name: DeleteCompanyType :exec
DELETE FROM company_types
Where id = $1;

-- name: GetAllCompanyTypeWithoutPagination :many
SELECT 
    id,
    image_url,
    CASE 
        WHEN @lang::varchar = 'ar' THEN COALESCE(title_ar,title)
    ELSE COALESCE(title, '') END::varchar AS title
FROM company_types;

-- name: GetCountCompanyTypes :one
SELECT COUNT(*) FROM company_types;




-- -- name: UpdateTypesRelatedCompanies :one
--  WITH bc AS (
--  UPDATE broker_companies
--  SET main_services_id = null
--  WHERE broker_companies.main_services_id = $1
--  RETURNING *
-- ),
--   dc AS (
-- UPDATE developer_companies
--  SET  main_services_id = null
--  WHERE developer_companies.main_services_id = $1
--  RETURNING *
-- ),
--   sc AS (
-- UPDATE services_companies
--  SET  main_services_id = null
--  WHERE services_companies.main_services_id = $1
--  RETURNING *
-- ),
--   bcb AS (
-- UPDATE broker_companies_branches
--  SET main_services_id = null
--  WHERE broker_companies_branches.main_services_id = $1
--  RETURNING *
-- ),
--   dcb AS (
-- UPDATE developer_company_branches
--  SET  main_services_id = null
--  WHERE developer_company_branches.main_services_id = $1
--  RETURNING *
-- ),
--   scb AS (
-- UPDATE service_company_branches
--  SET   main_services_id = null
--  WHERE  service_company_branches.main_services_id = $1
--  RETURNING *
-- )
-- SELECT id, main_services_id FROM bc
-- UNION ALL
-- SELECT id, main_services_id FROM dc
-- UNION ALL
-- SELECT id, main_services_id FROM sc
-- UNION ALL
-- SELECT id, main_services_id FROM bcb
-- UNION ALL
-- SELECT id, main_services_id FROM dcb
-- UNION ALL
-- SELECT id, main_services_id FROM scb;






-- name: GetACompanyMainInfo :one
SELECT users_id, c.id AS company_id, c.users_id, 1 AS company_type, false AS is_branch
FROM companies c
WHERE  c.id =  @company_id; 