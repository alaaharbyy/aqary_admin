-- name: CreateCompanyUser :one
INSERT INTO company_users (
    users_id,
    company_id,
	company_department,
	company_roles,
	user_rank,
	is_verified,
    created_by,
    created_at,
    updated_at,
	leader_id
)VALUES (
    $1, $2, $3,$4, $5, $6,$7,$8,$9, $10
) RETURNING *;


-- name: GetCompanyUser :one
SELECT * FROM company_users 
WHERE id = $1 LIMIT $1;
 
 
-- name: GetAllCompanyUser :many
SELECT * FROM company_users
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateCompanyUser :one
UPDATE company_users
SET users_id = $2,
    company_id = $3,
	leader_id = $4
    -- company_type = $4,
    -- is_branch = $5,
    -- designation = $6,
    -- created_by = $7,
    -- updated_at = $8
Where id = $1
RETURNING *;


-- name: UpdateCompanyUserByUserID :one
UPDATE company_users
SET  leader_id = $2 
Where users_id = $1
RETURNING *;


-- -- name: UpdateCompanyUserStatus :one
-- UPDATE company_users
-- SET 
--    status = $2
-- Where id = $1
-- RETURNING *;

-- name: DeleteCompanyUser :exec
DELETE FROM company_users
Where id = $1;
 
-- name: GetAllCompanyUsers :many
SELECT
    company_users.company_id,
	company_users.id AS company_user_id,
	profiles.id AS profile_id,
	profiles.first_name,
	profiles.last_name,
	profiles.profile_image_url,
	users.phone_number,
	users.id AS user_id,
	users.email,
	companies.company_name,
	department.department,
	roles."role",
	company_users.is_verified,
	license.license_no,
	companies.company_type,
	users.status
FROM
	company_users
	LEFT JOIN users ON company_users.users_id = users.id
	LEFT JOIN profiles ON profiles.users_id = users.id
	LEFT JOIN companies ON company_users.company_id = companies.id

    LEFT JOIN roles ON users.roles_id = roles.id
	LEFT JOIN department ON roles.department_id = department.id
	LEFT JOIN license ON  users.id = license.entity_id  AND license.license_type_id = 5
	
	------------------------------------------------------------@search---------------------
WHERE
    (@search = '%%'
     OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
     OR companies.company_name ILIKE @search 
      OR users.phone_number ILIKE @search
      OR users.email ILIKE @search
    )
	AND users.status NOT IN (5,6) AND CASE WHEN @company_id::bigint = 0 THEN TRUE ELSE company_users.company_id = @company_id::bigint END
ORDER BY
	company_users.updated_at DESC
LIMIT $1 OFFSET $2;


-- name: GetCountAllCompanyUsers :one
SELECT
	COUNT(*)
FROM
	company_users
	LEFT JOIN users ON company_users.users_id = users.id
	LEFT JOIN profiles ON profiles.users_id = users.id
	LEFT JOIN companies ON company_users.company_id = companies.id

    LEFT JOIN roles ON users.roles_id = roles.id
	LEFT JOIN department ON roles.department_id = department.id
	LEFT JOIN license ON  users.id = license.entity_id  AND license.license_type_id = 5
	
	------------------------------------------------------------@search---------------------
WHERE
    (@search = '%%'
     OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
     OR companies.company_name ILIKE @search 
      OR users.phone_number ILIKE @search
      OR users.email ILIKE @search
    )
AND users.status NOT IN (5,6) AND CASE WHEN @company_id::bigint = 0 THEN TRUE ELSE company_users.company_id = @company_id::bigint END;


-- name: GetCompanyUserById :one
SELECT company_users.*, users.*, profiles.*, companies.*  FROM
	company_users
	LEFT JOIN users ON company_users.users_id = users.id
	LEFT JOIN profiles ON profiles.users_id = users.id
	LEFT JOIN companies ON company_users.company_id = companies.id
WHERE
	company_users.id = @company_id;


-- name: GetCompanyUserByCompanyUserId :one
SELECT 
   *
 FROM
	company_users 
WHERE
	company_users.id = @company_user_id;


-- name: GetCountCompanyUsersByStatuses :one
SELECT COUNT(company_users.id) FROM company_users LEFT JOIN users ON company_users.users_id = users.id WHERE users.status = ANY($1::bigint[]);



-- name: GetAllCompanyUsersByStatus :many
SELECT
	company_users.*,
	profiles.first_name,
	profiles.last_name,
	users.phone_number,
	users.email,
	profiles.profile_image_url,
	users.user_types_id,
	companies.company_name
	FROM
	company_users
	LEFT JOIN users ON company_users.users_id = users.id
	LEFT JOIN profiles ON profiles.users_id = users.id 
	LEFT JOIN companies ON companies.id = company_users.company_id
	---------------------------------------------------------------------------------
WHERE
    (@search = '%%'
      OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
    --   OR companies.company_type ILIKE @search
    --   OR company_users.designation ILIKE @search
      OR users.phone_number ILIKE @search
      OR users.email ILIKE @search
    )
	AND users.status = $3
	AND (case when @company_id::bigint = 0 then true else  companies.id= @company_id::bigint end)
ORDER BY
	company_users.updated_at DESC
LIMIT $1 OFFSET $2;
 

-- name: CountAllCompanyUsersByStatus :one
SELECT
	COUNT(company_users.id)
	FROM
	company_users
	LEFT JOIN users ON company_users.users_id = users.id
	LEFT JOIN profiles ON profiles.users_id = users.id 
	LEFT JOIN companies ON companies.id = company_users.company_id 
WHERE
    (@search = '%%'
     OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
    --  OR companies.company_type ILIKE @search
    --   OR company_users.designation ILIKE @search
      OR users.phone_number ILIKE @search
      OR users.email ILIKE @search
    )
	AND (case when @company_id::bigint = 0 then true else  companies.id= @company_id::bigint end)
AND users.status = $1;




-- name: GetCompanyUserByCompanyId :many
SELECT * FROM company_users 
WHERE company_id = $1;

-- name: GetCompanyUserByUserId :one
SELECT * FROM company_users 
WHERE 
 CASE WHEN  @company_id=0 THEN true ELSE company_id = @company_id END
 AND users_id = @user_id;
-- SELECT * FROM company_users 
-- WHERE users_id = $1;

-- -- name: GetCompanyByCompanyUser :one
-- SELECT 
--     COALESCE(
--         bc.id, 
--         bcb.id, 
--         dc.id, 
--         dcb.id, 
--         sc.id, 
--         dc.id
--     ) AS company_id,
--     COALESCE(
--         bc.is_branch, 
--         bcb.is_branch, 
--         dc.is_branch, 
--         dcb.is_branch, 
--         sc.is_branch, 
--         dc.is_branch
--     ) AS is_branch,
--     COALESCE(
--         bc.company_type, 
--         bcb.company_type, 
--         dc.company_type, 
--         dcb.company_type, 
--         sc.company_type, 
--         dc.company_type
--     ) AS company_type,
--     COALESCE(
--         bc.company_name, 
--         bcb.company_name, 
--         dc.company_name, 
--         dcb.company_name, 
--         sc.company_name, 
--         dc.company_name,
--         'no company'
--     ) AS company_name,
--     cu.designation
-- FROM company_users AS cu
-- LEFT JOIN broker_companies bc ON cu.company_id = bc.id AND cu.is_branch = false AND cu.company_type = 1
-- LEFT JOIN broker_companies_branches bcb ON cu.company_id = bcb.id AND cu.is_branch = true AND cu.company_type = 1
-- LEFT JOIN developer_companies dc ON cu.company_id = dc.id AND cu.is_branch = false AND cu.company_type = 2
-- LEFT JOIN developer_company_branches dcb ON cu.company_id = dcb.id AND cu.is_branch = true AND cu.company_type = 2
-- LEFT JOIN services_companies sc ON cu.company_id = sc.id AND cu.is_branch = false AND cu.company_type = 3
-- LEFT JOIN product_companies pc ON cu.company_id = pc.id AND cu.is_branch = false AND cu.company_type = 4
-- WHERE cu.users_id = $1
-- limit 1;




-- name: GetUserFromCompany :one
SELECT
	CASE WHEN company_users.company_type = 1
		AND company_users.is_branch = FALSE THEN
		broker_companies.company_name
	WHEN company_users.company_type = 1
		AND company_users.is_branch = TRUE THEN
		broker_companies_branches.company_name
	WHEN company_users.company_type = 2
		AND company_users.is_branch = FALSE THEN
		developer_companies.company_name
	WHEN company_users.company_type = 2
		AND company_users.is_branch = TRUE THEN
		developer_company_branches.company_name
	WHEN company_users.company_type = 3
		AND company_users.is_branch = FALSE THEN
		services_companies.company_name
	WHEN company_users.company_type = 3
		AND company_users.is_branch = TRUE THEN
		service_company_branches.company_name
	ELSE
		NULL
	END AS company_name,
	profiles.id AS profile_id,
	profiles.first_name,
	profiles.last_name,
	users.phone_number,
	-- profiles.all_languages_id,
	profiles.addresses_id,
	-- profiles.company_number,
	profiles.whatsapp_number,
	profiles.gender,
	profiles.profile_image_url,
	-- profiles.tawasal,
	-- profiles.botim,
	users.user_types_id,
	users.email
	-- users.permissions_id,
	-- users.sub_section_permission
FROM
	company_users
	LEFT JOIN users ON company_users.users_id = users.id
	LEFT JOIN profiles ON profiles.users_id = users.id
	LEFT JOIN broker_companies ON broker_companies.id = company_users.company_id
		AND company_users.is_branch = FALSE
	LEFT JOIN broker_companies_branches ON broker_companies_branches.id = company_users.company_id
		AND company_users.is_branch = TRUE
	LEFT JOIN developer_companies ON developer_companies.id = company_users.company_id
		AND company_users.is_branch = FALSE
	LEFT JOIN developer_company_branches ON developer_company_branches.id = company_users.company_id
		AND company_users.is_branch = TRUE
	LEFT JOIN services_companies ON services_companies.id = company_users.company_id
		AND company_users.is_branch = FALSE
	LEFT JOIN service_company_branches ON service_company_branches.id = company_users.company_id
		AND company_users.is_branch = TRUE
WHERE
	company_users.id = $1;

-- name: GetASingleUserFromCompanies :one
SELECT
    CASE
        WHEN broker_companies.id IS NOT NULL THEN broker_companies.id
        WHEN broker_companies_branches.id IS NOT NULL THEN broker_companies_branches.id
        WHEN developer_companies.id IS NOT NULL THEN developer_companies.id
        WHEN developer_company_branches.id IS NOT NULL THEN developer_company_branches.id
        WHEN services_companies.id IS NOT NULL THEN services_companies.id
        WHEN service_company_branches.id IS NOT NULL THEN service_company_branches.id
    END AS company_id,
    CASE
        WHEN broker_companies.users_id IS NOT NULL THEN broker_companies.users_id
        WHEN broker_companies_branches.users_id IS NOT NULL THEN broker_companies_branches.users_id
        WHEN developer_companies.users_id IS NOT NULL THEN developer_companies.users_id
        WHEN developer_company_branches.users_id IS NOT NULL THEN developer_company_branches.users_id
        WHEN services_companies.users_id IS NOT NULL THEN services_companies.users_id
        WHEN service_company_branches.users_id IS NOT NULL THEN service_company_branches.users_id
    END AS users_id,
    CASE
        WHEN broker_companies.id IS NOT NULL THEN 1
        WHEN broker_companies_branches.id IS NOT NULL THEN 1
        WHEN developer_companies.id IS NOT NULL THEN 2
        WHEN developer_company_branches.id IS NOT NULL THEN 2
        WHEN services_companies.id IS NOT NULL THEN 3
        WHEN service_company_branches.id IS NOT NULL THEN 3
    END AS company_type,
    CASE
        WHEN broker_companies.id IS NOT NULL THEN false
        WHEN broker_companies_branches.id IS NOT NULL THEN true
        WHEN developer_companies.id IS NOT NULL THEN false
        WHEN developer_company_branches.id IS NOT NULL THEN true
        WHEN services_companies.id IS NOT NULL THEN false
        WHEN service_company_branches.id IS NOT NULL THEN true
    END AS is_branch
FROM
    broker_companies
    FULL OUTER JOIN broker_companies_branches ON true
    FULL OUTER JOIN developer_companies ON true
    FULL OUTER JOIN developer_company_branches ON true
    FULL OUTER JOIN services_companies ON true
    FULL OUTER JOIN service_company_branches ON true
WHERE
    (
        CASE
            WHEN broker_companies.id IS NOT NULL THEN broker_companies.id
            WHEN broker_companies_branches.id IS NOT NULL THEN broker_companies_branches.id
            WHEN developer_companies.id IS NOT NULL THEN developer_companies.id
            WHEN developer_company_branches.id IS NOT NULL THEN developer_company_branches.id
            WHEN services_companies.id IS NOT NULL THEN services_companies.id
            WHEN service_company_branches.id IS NOT NULL THEN service_company_branches.id
        END = @company_type::bigint
    )
    AND (
        CASE
            WHEN broker_companies.id IS NOT NULL THEN 1
            WHEN broker_companies_branches.id IS NOT NULL THEN 1
            WHEN developer_companies.id IS NOT NULL THEN 2
            WHEN developer_company_branches.id IS NOT NULL THEN 2
            WHEN services_companies.id IS NOT NULL THEN 3
            WHEN service_company_branches.id IS NOT NULL THEN 3
        END = @company_id::bigint
    )
    AND (
        CASE
            WHEN broker_companies.id IS NOT NULL THEN false
            WHEN broker_companies_branches.id IS NOT NULL THEN true
            WHEN developer_companies.id IS NOT NULL THEN false
            WHEN developer_company_branches.id IS NOT NULL THEN true
            WHEN services_companies.id IS NOT NULL THEN false
            WHEN service_company_branches.id IS NOT NULL THEN true
        END = @is_branch::BOOLEAN
    );



---------------------
-- With x AS(
-- 	SELECT broker_companies.id AS company_id, users_id, 1 AS company_type, false AS is_branch  FROM broker_companies
-- 	UNION ALL
-- 	SELECT broker_companies_branches.id AS company_id, users_id, 1 AS company_type, true AS is_branch FROM broker_companies_branches
-- 	UNION
-- 	SELECT developer_companies.id AS company_id, users_id, 2 AS company_type, false AS is_branch FROM developer_companies 
-- 	UNION ALL 
-- 	SELECT developer_company_branches.id AS company_id, users_id, 2 AS company_type, true AS is_branch FROM developer_company_branches
-- 	UNION ALL 
-- 	SELECT services_companies.id AS company_id, users_id, 3 AS company_type, false AS is_branch FROM services_companies
-- 	UNION ALL
-- 	SELECT service_company_branches.id AS company_id, users_id, 3 AS company_type, true AS is_branch FROM service_company_branches
-- ) 
-- SELECT users_id, company_id FROM x WHERE company_id = 1 and company_type = @company_type and is_branch = @is_branch;






-- SELECT users_id, bc.id AS company_id, bc.users_id, 1 AS company_type, false AS is_branch
-- FROM broker_companies bc
-- WHERE bc.company_type = @company_type AND bc.id =  @id AND bc.is_branch = @is_branch

-- UNION ALL

-- SELECT  users_id, bcb.id AS company_id, bcb.users_id, 1 AS company_type, true AS is_branch
-- FROM broker_companies_branches bcb
-- WHERE bcb.company_type = @company_type AND bcb.id =  @id AND bcb.is_branch =  @is_branch

-- UNION ALL

-- SELECT  users_id, dc.id AS company_id, dc.users_id, 2 AS company_type, false AS is_branch
-- FROM developer_companies dc
-- WHERE dc.company_type = @company_type AND dc.id =  @id AND dc.is_branch =   @is_branch

-- UNION ALL

-- SELECT   users_id, dcb.id AS company_id, dcb.users_id, 2 AS company_type, true AS is_branch
-- FROM developer_company_branches dcb
-- WHERE dcb.company_type = @company_type AND dcb.id =  @id AND dcb.is_branch =  @is_branch

-- UNION ALL

-- SELECT   users_id, sc.id AS company_id, sc.users_id, 3 AS company_type, false AS is_branch
-- FROM services_companies sc
-- WHERE sc.company_type = @company_type AND sc.id =  @id AND sc.is_branch =   @is_branch

-- UNION ALL

-- SELECT   users_id, scb.id AS company_id, scb.users_id, 3 AS company_type, true AS is_branch
-- FROM service_company_branches scb
-- WHERE scb.company_type = @company_type AND scb.id =  @id AND scb.is_branch =  @is_branch;





-- SELECT company_id, users_id, company_type, is_branch, is_verified
-- FROM (
--     SELECT broker_companies.id AS company_id, broker_companies.users_id, 1 AS company_type, false AS is_branch, is_verified
--     FROM broker_companies
--     WHERE broker_companies.users_id = $1
--     UNION ALL
--     SELECT broker_companies_branches.id AS company_id, broker_companies_branches.users_id, 1 AS company_type, true AS is_branch, is_verified
--     FROM broker_companies_branches
--     WHERE broker_companies_branches.users_id = $1
--     UNION
--     SELECT developer_companies.id AS company_id, developer_companies.users_id, 2 AS company_type, false AS is_branch, is_verified
--     FROM developer_companies
--     WHERE developer_companies.users_id = $1
--     UNION ALL
--     SELECT developer_company_branches.id AS company_id, developer_company_branches.users_id, 2 AS company_type, true AS is_branch, is_verified
--     FROM developer_company_branches
--     WHERE developer_company_branches.users_id = $1
--     UNION ALL
--     SELECT services_companies.id AS company_id, services_companies.users_id, 3 AS company_type, false AS is_branch, is_verified
--     FROM services_companies
--     WHERE services_companies.users_id = $1
--     UNION ALL
--     SELECT service_company_branches.id AS company_id, service_company_branches.users_id, 3 AS company_type, true AS is_branch, is_verified
--     FROM service_company_branches
--     WHERE service_company_branches.users_id = $1
-- ) AS subquery;


-- name: GetCompanyUserCountByUserAndCompanyId :one
SELECT COUNT(company_users.id)
FROM company_users
WHERE company_users.user_id = @id::bigint
AND company_users.company_id = @companyID::bigint
GROUP BY company_users.id
ORDER BY company_users.id;





-- name: GetCompany :one
SELECT * FROM companies
WHERE id = $1 LIMIT 1;




 
-- name: GetACompanyByUserID :one
SELECT companies.id AS company_id, companies.users_id, 1 AS company_type, false AS is_branch, is_verified, company_name FROM companies where users_id = $1;



-- name: VerifyUser :one
Update users
SET is_verified = $2
WHERE id = $1
RETURNING *;

-- -- name: VerifyingCompanyUser :one
-- Update users
-- SET is_verified = true,
-- status = 8
-- WHERE id = $1
-- RETURNING *;

-- name: GetUserAssociatedCompanies :many
SELECT id,company_name 
FROM companies
WHERE users_id = $1
ORDER BY id ASC;


-- name: VerifyCompanyUserByUserId :exec
Update company_users
SET is_verified = $2
WHERE users_id = $1;



-- name: UpdateAgentActiveListing :one 
UPDATE 
	company_users
SET 
	active_listings=$2
WHERE 
	id=$1 RETURNING 1; 



-- name: GetCompanyUserIDFromUserID :one
SELECT id
FROM 
	company_users 
WHERE 	
	users_id=$1; 