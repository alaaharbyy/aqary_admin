-- name: CreateProfile :one
INSERT INTO profiles (
    first_name,
    last_name,
    addresses_id,
    profile_image_url,
    secondary_number,
    whatsapp_number,
    show_whatsapp_number,
    botim_number,
    show_botim_number,
    tawasal_number,
    show_tawasal_number, 
    gender,
    created_at,
    updated_at,
    ref_no,
    cover_image_url,
    passport_no,
    passport_image_url,
    passport_expiry_date,
    about,
    about_arabic,
    users_id
)VALUES (
    $1, $2, $3, $4, $5, $6,$7, $8, $9, $10,  $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22
) RETURNING *;

-- name: GetProfile :one
SELECT * FROM profiles 
WHERE id = $1 LIMIT 1;

-- name: GetAllProfile :many
SELECT * FROM profiles
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateProfile :one
UPDATE profiles
SET  
    first_name = $2,
    last_name = $3,
    addresses_id = $4,
    profile_image_url = $5,
    secondary_number = $6,
    whatsapp_number = $7,
    show_whatsapp_number = $8,
    botim_number = $9,
    show_botim_number = $10,
    tawasal_number = $11,
    show_tawasal_number = $12, 
    gender = $13, 
    updated_at = $14,
    ref_no = $15,
    cover_image_url = $16,
    passport_no = $17,
    passport_image_url = $18,
    passport_expiry_date = $19,
    about = $20,
    about_arabic = $21
    -- users_id = $22
Where id = $1
RETURNING *;




-- name: UpdateProfileForCompanyUser :one
UPDATE profiles
SET  
    first_name = $2,
    last_name = $3,
    addresses_id = $4,
    profile_image_url = $5,
    secondary_number = $6,
    whatsapp_number = $7,
    show_whatsapp_number = $8,
    botim_number = $9,
    show_botim_number = $10,
    tawasal_number = $11,
    show_tawasal_number = $12, 
    gender = $13, 
    updated_at = $14, 
    cover_image_url = $15,
    passport_no = $16,
    passport_image_url = $17,
    passport_expiry_date = $18,
    about = $19,
    about_arabic = $20
Where id = $1
RETURNING *;


-- name: DeleteProfile :exec
DELETE FROM profiles
Where id = $1;

-- name: GetAllProfilesNames :many
SELECT first_name FROM profiles
ORDER BY id;



-- -- name: UpdateProfileByPhoneNumber :one
-- WITH selected_profile AS (
--     SELECT *
--     FROM profiles
--     WHERE profiles.phone_number = $1
--     LIMIT 1
-- )
-- UPDATE profiles
-- SET
--     phone_number = $2
-- FROM selected_profile
-- WHERE profiles.profiles.id = selected_profile.id
-- RETURNING *;



-- -- name: GetUserProfileByMobile :one
-- SELECT
--     p.first_name AS name,
--     p.last_name AS family_name,
--     p.gender,
--     -- p.company_number,
--     u.email
-- FROM
--     users u
-- JOIN
--     profiles p ON u.profiles_id = p.id
-- WHERE
--     p.phone_number = $1
-- LIMIT $2;

-- name: UpdateUserProfileAddress :exec
UPDATE profiles
SET addresses_id = $1
WHERE profiles.id IN (SELECT profiles_id FROM users WHERE users.id = $2);

-- name: GetProfileuserbyUserId :one
SELECT * FROM profiles as p INNER JOIN users as u ON u.profiles_id = p.id where u.id = $1;

-- name: GetProfileByUserId :one
SELECT * FROM profiles 
WHERE users_id = $1 LIMIT 1;

-- name: GetAssociatedCompanies :one
SELECT 
JSON_AGG(
        JSON_BUILD_OBJECT(
            'id', c.id,
            'name', c.company_name,
            'verified', c.is_verified,
            'logo', c.logo_url
        )
    ) AS associated_companies
FROM companies c 
WHERE c.users_id = $1 AND c.id != $2;

-- name: GetUserDetailsByUserName :one
SELECT 
    u.id AS user_id,
    u.active_company AS act_company,
    u.email,
    u.username,
    u.status, 
    u.user_types_id,
    u.is_verified,
    u.show_hide_details,
    u.experience_since,
    u.phone_number,
    u.country_code,
    u.is_email_verified,
    u.is_phone_verified,
    u.roles_id,
    u.experience_since,
    ro.role,
    p.first_name,
    p.last_name,
    concat(p.first_name, ' ', p.last_name)::text AS full_name,
    p.whatsapp_number,
    p.profile_image_url,
    p.secondary_number,
    p.cover_image_url,
    p.about,
    p.gender,
    p.ref_no, 
    ad.full_address,
    countries.default_settings,
    ad.countries_id,
    countries.flag,
    countries.country,
    nationality.id as nationality_id,
    nationality.country as nationality, 
    nationality.country_ar as nationality_ar,
    all_languages.id as language_id,
    all_languages.language,
    coalesce(base_currency.flag::varchar,'')::varchar as base_currency_icon,
    coalesce(base_currency.code::varchar,'')::varchar as base_currency_code,
    coalesce(default_currency.flag::varchar,'')::varchar as default_currency_icon,
    coalesce(default_currency.code::varchar,'')::varchar as default_currency_code,
    JSON_BUILD_OBJECT(
        'id', u.user_types_id,
        'label', ut.user_type,
        'label_ar', ut.user_type_ar
    ) AS user_type,
    JSON_BUILD_OBJECT(
        'id', u.active_company,
        'name', c.company_name,
        'logo', c.logo_url,
        'verified', c.is_verified,
        'cover_image', c.cover_image_url,
        'website_url',c.website_url
    ) AS active_company
    FROM users u
LEFT JOIN profiles p ON p.users_id = u.id
LEFT JOIN profile_nationalities ON profile_nationalities.profiles_id = p.id
LEFT JOIN profile_languages ON profile_languages.profiles_id = p.id
LEFT JOIN countries as nationality ON nationality.id = profile_nationalities.country_id
LEFT JOIN all_languages ON all_languages.id = profile_languages.all_languages_id
LEFT JOIN addresses ad ON p.addresses_id = ad.id
left join countries ON countries.id=ad.countries_id
left join currency as base_currency on base_currency.id= (countries.default_settings->>'base_currency')::bigint
left join currency as default_currency on default_currency.id= (countries.default_settings->>'default_currency')::bigint
LEFT JOIN companies c ON u.active_company = c.id
LEFT JOIN user_types ut ON u.user_types_id = ut.id
LEFT JOIN roles ro ON ro.id = u.roles_id
WHERE u.username = @user_name::text
GROUP BY u.id,language_id, u.experience_since,all_languages.id,nationality_id, p.whatsapp_number,nationality,all_languages.language, nationality_ar,p.id, ad.full_address, ut.user_type,ut.user_type_ar, c.company_name, c.cover_image_url, c.logo_url,c.is_verified,c.website_url, ro.role,countries.id,base_currency.flag,base_currency.code,default_currency.flag,default_currency.code, countries.default_settings,ad.countries_id,countries.flag,countries.country; 


-------------------- permission related queries --------------------

-- name: GetAqaryUserPermissions :one
SELECT 
    array_agg(DISTINCT permission)::bigint[] AS unique_permissions_id
FROM (
    -- Unnest and combine the permissions_id from both tables
    SELECT unnest(permissions_id) AS permission
    FROM user_company_permissions WHERE user_id = @user_id::bigint
    UNION
    SELECT unnest(permissions_id) AS permission
    FROM roles_permissions WHERE roles_id = @roles_id::bigint
) AS combined_permissions;

-- name: GetAqaryUserSubSectionPermissions :one
SELECT 
    array_agg(DISTINCT sub_section)::bigint[] AS unique_sub_section_ids
FROM (
    -- Unnest and combine the sub_section_ids from both tables
    SELECT unnest(sub_sections_id) AS sub_section
    FROM user_company_permissions WHERE user_id = @user_id::bigint
    UNION
    SELECT unnest(sub_section_permission) AS sub_section
    FROM roles_permissions WHERE roles_id = @roles_id::bigint
) AS combined_sub_sections;

-- name: GetAqaryAdminPermissions :one
SELECT permissions_id::bigint[] AS permissions, sub_sections_id::bigint[] AS sub_permissions
FROM user_company_permissions
WHERE user_id = @user_id::bigint;


-- name: GetCompanyAdminPermissions :one
SELECT permissions_id::bigint[] AS permissions, sub_sections_id::bigint[] AS sub_permissions
FROM user_company_permissions
WHERE user_id = @user_id::bigint AND company_id = @company_id::bigint;


-- name: GetRolePermissions :one
SELECT permissions_id::bigint[] AS permissions, sub_section_permission::bigint[] AS sub_permissions
FROM roles_permissions
WHERE roles_id = @role_id::bigint;
