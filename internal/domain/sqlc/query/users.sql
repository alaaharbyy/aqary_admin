-- name: CreateUser :one
INSERT INTO users (
    email,
    username,
    password,
    status,
    roles_id,
    user_types_id,
    social_login,
    show_hide_details,
    experience_since,
    is_verified,
    created_at,
    updated_at,
    phone_number,
    country_code
)VALUES (
 $1, $2, $3,$4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14
) RETURNING *;

-- name: CreateSignUpUser :one
INSERT INTO users (
    email,
    username,
    password,
    status,
    roles_id,
    user_types_id,
    social_login,
    show_hide_details,
    experience_since,
    is_verified,
    created_at,
    updated_at,
    phone_number,
    is_phone_verified,
    is_email_verified
)VALUES (
 $1, $2, $3,$4, $5, $6, $7, $8, $9, $10, $11, $12, $13,$14,$15
) RETURNING *;


-- name: GetUser :one
SELECT * FROM users
WHERE id = $1 and user_types_id != 6 and status != 5 and status != 6;

-- name: GetListOfUsers :many
SELECT * FROM users
WHERE id = ANY($1::bigint[]) and user_types_id != 6 and status != 5 and status != 6;

-- name: GetUserWithAdmin :one
SELECT * FROM users
WHERE id = $1 and status != 5 and status != 6;

-- name: GetSuperUser :one
SELECT * FROM users
WHERE user_types_id = 6;

-- name: GetOtherUser :one
SELECT * FROM users
WHERE id = $1 AND user_types_id != 5 and user_types_id != 6 and status != 5 and status != 6;


-- name: GetAqaryUser :one
SELECT * FROM users
WHERE id = $1 AND user_types_id = 5 and user_types_id != 6 and status != 5 and status != 6;


-- name: GetUserByName :one
SELECT * FROM users
WHERE username = $1 and status != 5 and status != 6;

-- name: GetUserByEmail :one
SELECT * FROM users
WHERE email = $1 and status != 5 and status != 6;

-- name: GetUserByPhoneVerified :one
SELECT * FROM users
WHERE phone_number = $1 AND country_code = $2 AND is_verified = true and status != 5 and status != 6;

-- name: GetUserByPhoneNumber :one
SELECT * FROM users
WHERE phone_number = $1 AND status != 5 and status != 6;

-- name: GetAllOtherUser :many
SELECT * FROM users
WHERE user_types_id != 5 and user_types_id != 6  and status != 5 and status != 6  
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: GetAllAqaryUser :many
SELECT users.*, users.phone_number, roles.role, department.department, profiles.addresses_id FROM users
INNER JOIN profiles ON users.id = profiles.users_id
INNER JOIN roles ON users.roles_id = roles.id
INNER JOIN department ON roles.department_id = department.id
WHERE 
   (
     @search = '%%'
     OR users.username ILIKE @search
     OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search
     OR users.email ILIKE @search
     OR users.phone_number ILIKE @search
     OR roles.role ILIKE @search
    )
  AND user_types_id != 6  and users.status not in (5,6)
ORDER BY users.updated_at DESC
LIMIT $1
OFFSET $2;

-- name: GetCountAllAqaryUser :one
SELECT COUNT(users.id) FROM users
INNER JOIN profiles ON users.id = profiles.users_id
INNER JOIN roles ON users.roles_id = roles.id
INNER JOIN department ON roles.department_id = department.id
WHERE 
   (
     @search = '%%'
     OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search   
     OR users.username ILIKE @search
     OR users.email ILIKE @search
     OR users.phone_number ILIKE @search
     OR roles.role ILIKE @search
    )
AND user_types_id != 6  and users.status not in (5,6);
-- SELECT COUNT(*) FROM users Where user_types_id = 5 and user_types_id != 6  and status != 5 and status != 6;


 


-- name: GetCountAllOtherUser :one
SELECT COUNT(*) FROM users Where user_types_id != 5 and user_types_id != 6  and status != 5 and status != 6;


-- name: UpdateUser :one
UPDATE users
SET  
    roles_id = $2,  
    show_hide_details = $3,
    experience_since = $4,  
    updated_at = $5,
    phone_number = $6,
    username=$7,
    country_code = $8
Where id = $1
RETURNING *;

-- name: DeleteUser :exec
DELETE FROM users
Where id = $1 and user_types_id != 6;


-- name: GetAllUserNameByUserType :many 
SELECT profiles.id AS profile_id,profiles.first_name,profiles.last_name,users.id AS user_id ,user_types.id AS user_types_id 
FROM user_types 
LEFT JOIN users ON users.user_types_id = user_types.id 
LEFT JOIN profiles ON profiles.users_id = users.id 
WHERE user_types.id = $3 and user_types_id != 6  and status != 5 and status != 6  LIMIT $1 OFFSET $2;


-- name: GetAllUserNameByUserTypeWithoutPagination :many 
SELECT profiles.id AS profile_id,profiles.first_name,profiles.last_name,users.id AS user_id ,user_types.id AS user_types_id 
FROM user_types 
RIGHT JOIN users ON users.user_types_id = user_types.id 
RIGHT JOIN profiles ON profiles.users_id = users.id 
WHERE user_types.id = $1 and user_types_id != 6  and status != 5 and status != 6;


-- name: GetUserIdByProfileId :one
SELECT users_id AS id FROM profiles 
INNER JOIN users ON users.id = profiles.users_id
WHERE profiles.id = $1 and user_types_id != 6 and status != 5 and status != 6;


-- name: GetAllOtherUsersByCountryId :many
WITH x AS (
  SELECT users.*, countries.id as country_id
  FROM users
  LEFT JOIN profiles ON users.id = profiles.users_id
  LEFT JOIN addresses ON profiles.addresses_id = addresses.id
  LEFT JOIN countries ON addresses.countries_id = countries.id
  WHERE countries.id = $3 AND users.user_types_id != 5 and user_types_id != 6   and status != 5 and status != 6
)
SELECT * FROM x LIMIT $1 OFFSET $2;


-- name: GetAllAqaryUsersByCountryId :many
WITH x AS (
  SELECT users.*, countries.id as country_id
  FROM users
  LEFT JOIN profiles ON users.id = profiles.users_id
  LEFT JOIN addresses ON profiles.addresses_id = addresses.id
  LEFT JOIN countries ON addresses.countries_id = countries.id
  WHERE countries.id = $3 AND users.user_types_id = 5 and user_types_id != 6  and status != 5 and status != 6
)
SELECT * FROM x LIMIT $1 OFFSET $2;



-- name: GetCountAllOtherUserByCountry :one
WITH x AS (
  SELECT users.*, countries.id as country_id
  FROM users
  LEFT JOIN profiles ON users.id = profiles.users_id
  LEFT JOIN addresses ON profiles.addresses_id = addresses.id
  LEFT JOIN countries ON addresses.countries_id = countries.id
  WHERE countries.id = $1 AND users.user_types_id != 5 and user_types_id != 6  and status != 5 and status != 6
)
SELECT COUNT(*) FROM x;

 
-- name: GetCountAllAqaryUserByCountry :one
WITH x AS (
  SELECT users.*, countries.id as country_id
  FROM users
  LEFT JOIN profiles ON users.id = profiles.users_id
  LEFT JOIN addresses ON profiles.addresses_id = addresses.id
  LEFT JOIN countries ON addresses.countries_id = countries.id
  WHERE countries.id = $1 AND users.user_types_id = 5 and user_types_id != 6  and status != 5 and status != 6
)
SELECT COUNT(*) FROM x;


-- name: GetAllCompanyPendingUser :many 
SELECT * from users 
where status = 1 AND user_types_id = 1
order by  updated_at desc LIMIT $1 OFFSET $2;

-- name: GetPendingUser :one 
SELECT * from users 
where status = 1 and user_types_id != 5 AND  users.id = $1 and user_types_id != 6;

-- name: GetCountAllPendingUser :one
SELECT COUNT(*) FROM users 
WHERE  status = 1 AND user_types_id = 1;

-- name: UpdateUserPassword :one
Update users
SET password = $2
WHERE id = $1 
-- ! TODO:  uncomment this later.
-- and user_types_id != 6
RETURNING *;

-- name: UpdatePlatformUserPassword :one
Update platform_users
SET password = $2
WHERE id = $1 
RETURNING *;


-- name: GetAllUsersWithUserTypes :many
SELECT users.id AS user_id,users.user_types_id,profiles.id AS profile_id,profiles.first_name,profiles.last_name FROM users 
JOIN profiles ON users.id=profiles.users_id 
WHERE users.user_types_id!=5 and user_types_id != 6  and status != 5 and status != 6;


-- name: UpdateUserStatus :one
Update users
SET status=$2,
updated_at = $3
Where id = $1
RETURNING *;

-- name: UpdateUserStatusWithoutUpdateTime :one
Update users
SET status=$2 
Where id = $1
RETURNING *;


-- name: GetAllAqaryDeletedUser :many
SELECT * from users 
 INNER JOIN profiles ON users.id =  profiles.users_id
 INNER JOIN roles ON users.roles_id = roles.id
 LEFT JOIN department ON roles.department_id = department.id
 WHERE 
      (@search = '%%'
       OR users.username ILIKE @search
       OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search   
       OR users.email ILIKE @search
       OR users.phone_number ILIKE @search
       OR roles.role ILIKE @search
       OR department.department ILIKE @search
      )
AND  users.status = 6
ORDER by users.updated_at DESC  LIMIT $1 OFFSET $2;


-- name: GetAllAqaryDeletedUserWithoutPagination :many
SELECT * from users 
WHERE status = 6;


-- name: GetCountAllAqaryDeletedUser :one
SELECT COUNT(users.id) from users 
 INNER JOIN profiles ON users.id =  profiles.users_id
 INNER JOIN roles ON users.roles_id = roles.id
--  INNER JOIN department ON users.department = department.id
 WHERE 
      (@search = '%%'
       OR users.username ILIKE @search
       OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search   
       OR users.email ILIKE @search
       OR users.phone_number ILIKE @search
       OR roles.role ILIKE @search
      --  OR department.title ILIKE @search
      )
AND  users.status = 6;
-- SELECT COUNT(*) from users 
-- WHERE status = 6;


-- name: GetAdminUserByBrokerCompany :one
SELECT users.* FROM users 
RIGHT JOIN broker_companies ON broker_companies.users_id = users.id
WHERE users.user_types_id = 1 AND broker_companies.id = $1;

-- name: GetAdminUserByBrokerCompanyBranch :one
SELECT users.* FROM users RIGHT JOIN broker_companies_branches ON broker_companies_branches.users_id = users.id 
WHERE users.user_types_id = 1 AND broker_companies_branches.id = $1;


--  //! getting users from company ....

-- name: GetUserIDFromCompanies :one
SELECT  users_id from companies Where id = $1 and company_type = $2  LIMIT 1;

 
-- name: GetUserIDFromBrokerCompany :one
SELECT  users_id from broker_companies Where id = $1;

-- name: GetUserIDFromBrokerCompanyBranch :one
SELECT users_id from broker_companies_branches Where id = $1;

-- name: GetUserIDFromDeveloperCompany :one
SELECT users_id from developer_companies Where id = $1;

-- name: GetUserIDFromDeveloperCompanyBranch :one
SELECT users_id from developer_company_branches Where id = $1;

-- name: GetUserIDFromServiceCompany :one
SELECT users_id from services_companies Where id = $1;

-- name: GetUserIDFromServiceCompanyBranch :one
SELECT users_id from service_company_branches Where id = $1;

-- name: UpdateUserPermission :one
UPDATE user_company_permissions
 SET permissions_id = $2,
    sub_sections_id =  $3
 where user_id =$1
RETURNING *;


-- // use this one to fetch all 
-- name: GetUserRegardlessOfStatus :one
SELECT users.*,profiles.id AS profiles_id FROM users
INNER JOIN profiles ON profiles.users_id = users.id
WHERE users.id = $1;

 
-- name: GetAqaryUsersForContacts :many
SELECT id,username FROM users
WHERE user_types_id IN (1, 2, 7)  and status != 5 and status != 6;


-- name: GetUserIdByMobile :one
SELECT id FROM users WHERE phone_number = $1 LIMIT 1;

-- name: GetUsernamesByUserIdsExcludingStatus6 :many
SELECT
    id AS user_id,
    username
FROM
    users
WHERE
    id IN ($1)
    AND status != 6;

-- name: GetSingleUsernameById :one
SELECT
    id AS user_id,
    username
FROM
    users
WHERE
    id = $1;


-- -- name: FetchSubSectionsForUser :many
-- SELECT ss.*
-- FROM sub_section ss
-- JOIN (
--     SELECT UNNEST(sub_section_permission) as sub_section_permission
--     FROM users
--     WHERE users.id = $2
-- ) u ON ss.id = u.sub_section_permission
-- JOIN permissions p ON ss.permissions_id = p.id
-- WHERE p.title ILIKE $1;


-- -- name: FetchNestedButtonPermissionForUser :many
-- SELECT ss.*
-- FROM sub_section ss
-- JOIN (
--     SELECT UNNEST(sub_section_permission) AS sub_section_permission
--     FROM users
--     WHERE users.id = $2
-- ) u ON ss.id = u.sub_section_permission
-- JOIN (
--     SELECT id FROM sub_section WHERE sub_section.sub_section_name ILIKE $1
-- ) sss ON ss.sub_section_button_id = sss.id
-- WHERE ss.sub_section_button_id IS NOT NULL;


-- name: GetAllNestedSubSectionPermissonByButtonID :many
SELECT * FROM sub_section
Where sub_section_button_id = $1;


-- name: GetAllTernary :many
SELECT * FROM sub_section
Where sub_section_button_id = $1;


-- name: GetAqaryDeletedUser :one
SELECT * FROM users
WHERE id =  $1;

-- name: GetAllUsersForInternalShareByIds :many
SELECT users.*,profiles.first_name,profiles.last_name,profiles.profile_image_url FROM users
INNER JOIN profiles ON users.id = profiles.users_id
WHERE users.id = ANY($1::bigint[])
ORDER BY ARRAY_POSITION($1::bigint[], users.id);

-- name: GetUserInfoById :one
SELECT users.id AS users_id, users.email, users.username, users.password, users.status, users.roles_id, users.user_types_id, users.social_login, users.show_hide_details, users.experience_since, users.is_verified, users.created_at, users.updated_at, users.phone_number, users.is_phone_verified, users.is_email_verified,
profiles.id AS profiles_id, profiles.first_name, profiles.last_name, profiles.addresses_id, profiles.profile_image_url, users.phone_number, profiles.secondary_number, profiles.whatsapp_number, profiles.show_whatsapp_number, profiles.botim_number, profiles.show_botim_number, profiles.tawasal_number, profiles.show_tawasal_number, profiles.gender, profiles.created_at, profiles.updated_at, profiles.ref_no, profiles.cover_image_url, profiles.passport_no, profiles.passport_image_url, profiles.passport_expiry_date, profiles.about, profiles.about_arabic, profiles.users_id FROM users
INNER JOIN profiles ON profiles.users_id = users.id
WHERE users.id = $1;







---------------------------------


-- name: RejectBrokerCompany :one
Update broker_companies 
SET status  = 3
Where id = $1
RETURNING *;


-- name: RejectBrokerBranchCompany :one
Update broker_companies_branches 
SET status = 3
Where id = $1
RETURNING *;


-- name: RejectDeveloperCompany :one
Update developer_companies 
SET status  = 3
Where id = $1
RETURNING *;


-- name: RejectDeveloperBranchCompany :one
Update developer_company_branches 
SET status = 3
Where id = $1
RETURNING *;


-- name: RejectServiceCompany :one
Update services_companies 
SET status  = 3
Where id = $1
RETURNING *;


-- name: RejectServiceBranchCompany :one
Update service_company_branches 
SET status  = 3
Where id = $1
RETURNING *;


 
-- name: VerifyAndAvailableUser :one
UPDATE users
SET status = 8,
is_verified = TRUE
WHERE id = $1
RETURNING *;

-- name: GetUserAddressByUserId :one
SELECT addresses.* FROM addresses
INNER JOIN profiles ON profiles.addresses_id = addresses.id
INNER JOIN users ON users.id = profiles.users_id
WHERE users.id = $1;

-- name: GetActiveUsersByType :many
SELECT users.id, TRIM(CONCAT(profiles.first_name, ' ', profiles.last_name)) AS full_name
FROM users
LEFT JOIN profiles ON users.id = profiles.users_id
LEFT JOIN addresses ON profiles.addresses_id = addresses.id
WHERE users.status NOT IN (5,6)
AND users.user_types_id = @user_type::bigint
AND addresses.countries_id = @country_id::bigint
AND (@search = '%%'
    OR TRIM(CONCAT(profiles.first_name, ' ', profiles.last_name)) ILIKE @search
);

-- name: GetUserByEmailRegardlessSuperAdmin :one
SELECT * FROM users
WHERE email = $1 AND status NOT IN(5,6) AND user_types_id != 6;

-- name: GetUserByEmailRegardless :one
SELECT * FROM platform_users
WHERE email = $1 AND company_id = $2 AND status NOT IN(5,6);

-- name: GetAllTeamLeaders :many
SELECT * FROM company_users
INNER JOIN users ON company_users.users_id = users.id
INNER JOIN profiles ON  users.id = profiles.users_id
INNER JOIN roles ON users.roles_id = roles.id AND roles."role" ILIKE '%team leader%'
WHERE  CASE WHEN @company_id::bigint=0 THEN true ELSE  company_users.company_id = @company_id::bigint END;



-- name: UpdateActiveCompany :one
UPDATE users 
SET active_company = $1
WHERE id = $2
RETURNING *;

-- name: GetOrganization :many
SELECT profiles.id as profile_id, users.id as users_id,company_users.id as company_user_id,profiles.profile_image_url,profiles.first_name,profiles.last_name, users.email,
    CASE 
        WHEN @lang::varchar = 'ar' THEN COALESCE(roles.role_ar,roles."role")
    ELSE COALESCE(roles."role", '') END::varchar AS role
FROM company_users 
JOIN users ON users.id=company_users.users_id
JOIN profiles ON users.id=profiles.users_id
JOIN roles ON roles.id=users.roles_id
WHERE company_id= @company_id::BIGINT;


-- name: GetAllUsers :many
SELECT id FROM users;

-- name: UpdateUserCounterView :exec
UPDATE users
SET 
    profile_views=profile_views+$2 
WHERE
    id=$1;