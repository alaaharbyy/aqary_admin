-- name: GetAllCompanyNameWithBranches :many
SELECT
    "company_name",
    "id",
    'services_companies' AS label,
    3 AS category,
    false AS is_branch
FROM
    "public"."services_companies"
UNION
SELECT
    "company_name",
    "id",
    'service_company_branches' AS label,
    3 AS category,
    true AS is_branch
FROM
    "public"."service_company_branches"
UNION
SELECT
    "company_name",
    "id",
    'broker_companies_branches' AS label,
    1 AS category,
    true AS is_branch
FROM
    "public"."broker_companies_branches"
UNION
SELECT
    "company_name",
    "id",
    'broker_companies' AS label,
    1 AS category,
    false AS is_branch
FROM
    "public"."broker_companies"
UNION
SELECT
    "company_name",
    "id",
    'developer_company_branches' AS label,
    2 AS category,
    true AS is_branch
FROM
    "public"."developer_company_branches"
UNION
SELECT
    "company_name",
    "id",
    'developer_companies' AS label,
    2 AS category,
    false AS is_branch
FROM
    "public"."developer_companies";


-- name: GetSingleCompanyName :one
SELECT
    company_name
FROM
    services_companies
WHERE
    services_companies.id = $1
    AND services_companies.company_type = $2
    AND services_companies.is_branch = $3
UNION
SELECT
    company_name
FROM
    service_company_branches
WHERE
   service_company_branches.id = $1
    AND service_company_branches.company_type = $2
    AND service_company_branches.is_branch = $3
UNION
SELECT
    company_name
FROM
    broker_companies_branches
WHERE
   broker_companies_branches.id = $1
    AND broker_companies_branches.company_type = $2
    AND broker_companies_branches.is_branch = $3
UNION
SELECT
    company_name
FROM
    broker_companies
WHERE
    broker_companies.id = $1
    AND broker_companies.company_type = $2
    AND broker_companies.is_branch = $3
UNION
SELECT
    company_name
FROM
    developer_company_branches
WHERE
    developer_company_branches.id = $1
    AND developer_company_branches.company_type = $2
    AND developer_company_branches.is_branch = $3
UNION
SELECT
    company_name
FROM
    developer_companies
WHERE
    developer_companies.id = $1
    AND developer_companies.company_type = $2
    AND developer_companies.is_branch = $3
LIMIT 1;

-- -- name: GetAllCompanyNamesWithSearch :many
-- SELECT * FROM companies
-- WHERE 
--     (@search::TEXT ='')
--      OR companies.company_name % @search::TEXT
-- 	AND companies.company_type  = 1
-- ORDER BY companies.created_at DESC 
-- LIMIT 10;

-- name: GetCompanyNameByCompanyId :one
WITH x AS (
SELECT
    "company_name",
    "id",
    'services_companies' AS label,
    3 AS category,
    false AS is_branch 
FROM
    "public"."services_companies" WHERE services_companies.id = $1 AND 3 = $2 And false = $3
UNION
SELECT
    "company_name",
    "id",
    'service_company_branches' AS label,
    3 AS category,
    true AS is_branch
FROM
    "public"."service_company_branches" WHERE service_company_branches.id = $1 AND 3 = $2 And true = $3
UNION
SELECT
    "company_name",
    "id",
    'broker_companies_branches' AS label,
    1 AS category,
    true AS is_branch
FROM
    "public"."broker_companies_branches" WHERE broker_companies_branches.id = $1 AND 1 = $2 And true = $3
UNION
SELECT
    "company_name",
    "id",
    'broker_companies' AS label,
    1 AS category,
    false AS is_branch
FROM
    "public"."broker_companies" WHERE broker_companies.id = $1 AND 1 = $2 And false = $3
UNION
SELECT
    "company_name",
    "id",
    'developer_company_branches' AS label,
    2 AS category,
    true AS is_branch
FROM
    "public"."developer_company_branches" WHERE developer_company_branches.id = $1 AND 2 = $2 And true = $3
UNION
SELECT
    "company_name",
    "id",
    'developer_companies' AS label,
    2 AS category,
    false AS is_branch
FROM
    "public"."developer_companies" WHERE developer_companies.id = $1 AND 2 = $2 And false = $3
    ) SELECT * FROM x LIMIT 1;


-- name: GetAllCompanyUsersByCompanyIdWithSearch :many
SELECT 
    company_users.users_id,
    profiles.first_name,
    profiles.last_name
FROM company_users
INNER JOIN users ON users.id = company_users.users_id
INNER JOIN profiles ON profiles.users_id = users.id
WHERE 
    company_users.company_id = $1
    AND (
        @search::TEXT = '%%'
        OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE  @search::TEXT
    ) LIMIT 20;


-- name: GetAllCompanyNamesWithSearch :many
SELECT * FROM companies
WHERE 
    (@search::TEXT =''
     OR companies.company_name % @search::TEXT)
	 AND companies.company_type  = 1 
LIMIT 10;

-- name: GetAllUsersByCompanyType :many
select users_id from developer_companies where @company_type = 2 and @is_branch = false
UNION ALL 
select users_id from developer_company_branches where @company_type = 2 and @is_branch = true
UNION ALL
select users_id from services_companies where @company_type = 3 and @is_branch = false
UNION ALL 
select users_id from service_company_branches where @company_type = 3 and @is_branch = true
UNION ALL
select users_id from broker_companies where @company_type = 1 and @is_branch = false
UNION ALL 
select users_id from broker_companies_branches where @company_type = 1 and @is_branch = true;

-- name: GetCountForAdminCompaniesAndUserCompanies :one
WITH user_companies AS (
    SELECT 
        count(*) AS user_company_count
    FROM company_users AS cu
    LEFT JOIN broker_companies bc ON cu.company_id = bc.id AND cu.is_branch = false AND cu.company_type = 1
    LEFT JOIN broker_companies_branches bcb ON cu.company_id = bcb.id AND cu.is_branch = true AND cu.company_type = 1
    LEFT JOIN developer_companies dc ON cu.company_id = dc.id AND cu.is_branch = false AND cu.company_type = 2
    LEFT JOIN developer_company_branches dcb ON cu.company_id = dcb.id AND cu.is_branch = true AND cu.company_type = 2
    LEFT JOIN services_companies sc ON cu.company_id = sc.id AND cu.is_branch = false AND cu.company_type = 3
    LEFT JOIN service_company_branches scb ON cu.company_id = scb.id AND cu.is_branch = true AND cu.company_type = 3
    LEFT JOIN product_companies pc ON cu.company_id = pc.id AND cu.is_branch = false AND cu.company_type = 4
    WHERE cu.users_id = $1
),
admin_companies AS (
    SELECT 
        count(*) AS admin_company_count
    FROM (
        SELECT bc.id
        FROM broker_companies bc
        WHERE bc.users_id = $1
        UNION ALL
        SELECT bcb.id
        FROM broker_companies_branches bcb
        WHERE bcb.users_id = $1
        UNION ALL
        SELECT dc.id
        FROM developer_companies dc
        WHERE dc.users_id = $1
        UNION ALL
        SELECT dcb.id
        FROM developer_company_branches dcb
        WHERE dcb.users_id = $1
        UNION ALL
        SELECT sc.id
        FROM services_companies sc
        WHERE sc.users_id = $1
        UNION ALL
        SELECT scb.id
        FROM service_company_branches scb
        WHERE scb.users_id = $1
        UNION ALL
        SELECT pc.id
        FROM product_companies pc
        WHERE pc.users_id = $1
        UNION ALL
        SELECT pcb.id
        FROM product_companies_branches pcb
        WHERE pcb.users_id = $1
    ) AS all_admin_companies
)
SELECT 
    uc.user_company_count, 
    ac.admin_company_count
FROM 
    user_companies uc,
    admin_companies ac;

-- name: GetCompaniesForAdmin :many 
SELECT 
    'broker_companies' AS table_name,
    bc.id,
    bc.company_type,
    bc.is_branch,
    bc.company_name,
    bc.is_verified,
    bc.no_of_employees,
    bc.email,
    bc.website_url,
    bc.phone_number,
    bc.commercial_license_no
 
FROM 
    broker_companies bc
WHERE 
    bc.users_id = $1
UNION 
SELECT 
    'broker_companies_branches' AS table_name,
    bcb.id,
    bcb.company_type,
    bcb.is_branch,
    bcb.company_name,
    bcb.is_verified,
    bcb.no_of_employees,
    bcb.email,
    bcb.website_url,
    bcb.phone_number,
    bcb.commercial_license_no
FROM 
    broker_companies_branches bcb
JOIN 
    addresses a ON bcb.addresses_id = a.id
JOIN
    locations l ON a.locations_id = l.id
WHERE 
    bcb.users_id = $1
UNION 
SELECT 
    'developer_companies' AS table_name,
    dc.id,
    dc.company_type,
    dc.is_branch,
    dc.company_name,
    dc.is_verified,
    dc.no_of_employees,
    dc.email,
    dc.website_url,
    dc.phone_number,
    dc.commercial_license_no
FROM 
    developer_companies dc
WHERE 
    dc.users_id =$1
UNION 
SELECT 
    'developer_company_branches' AS table_name,
    dcb.id,
    dcb.company_type,
    dcb.is_branch,
    dcb.company_name,
    dcb.is_verified,
    dcb.no_of_employees,
    dcb.email,   
    dcb.website_url,
    dcb.phone_number,
    dcb.commercial_license_no
FROM 
    developer_company_branches dcb
WHERE 
    dcb.users_id = $1
UNION 
SELECT 
    'services_companies' AS table_name,
    sc.id,
    sc.company_type,
    sc.is_branch,
    sc.company_name,
    sc.is_verified,
    sc.no_of_employees,
    sc.email,
    sc.website_url,
    sc.phone_number,
    sc.commercial_license_no
 
FROM 
    services_companies sc
WHERE 
    sc.users_id =$1
UNION 
SELECT 
    'service_company_branches' AS table_name,
    scb.id,
    scb.company_type,
    scb.is_branch,
    scb.company_name,
    scb.is_verified,
    scb.no_of_employees,
    scb.email,
    scb.website_url,
    scb.phone_number,
    scb.commercial_license_no
FROM 
    service_company_branches scb
WHERE 
    scb.users_id =$1
UNION 
SELECT 
    'product_company' AS table_name,
    pc.id,
    pc.company_type,
    pc.is_branch,
    pc.company_name,
    pc.is_verified,
    pc.no_of_employees,
    pc.email,
    pc.website_url,
    pc.phone_number,
    pc.commercial_license_no
FROM 
    product_companies pc
WHERE 
    pc.users_id =$1
UNION 
SELECT 
    'product_company_branch' AS table_name,
    pcb.id,
    pcb.company_type,
    pcb.is_branch,
    pcb.company_name,
    pcb.is_verified,
    pcb.no_of_employees,
    pcb.email,
    pcb.website_url,
    pcb.phone_number,
    pcb.commercial_license_no
FROM 
    product_companies_branches pcb
WHERE 
    pcb.users_id = $1;