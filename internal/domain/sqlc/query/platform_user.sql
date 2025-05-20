-- name: CreatePlatformUser :one
INSERT INTO
    platform_users (
        company_id,
        username,
        email,
        password,
        country_code,
        phone_number,
        first_name,
        last_name, 
        addresses_id, 
        status, 
        social_login, 
        gender, 
        nationality,
        is_email_verified
    )
VALUES(
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
    )RETURNING *;


-- name: GetPlatformUserByEmail :one
SELECT * FROM platform_users
WHERE email = $1 and status != 5 and status != 6;


-- name: GetPlatformUserByEmailAndCompanyID :one
SELECT * FROM platform_users
WHERE email = $1 and (CASE WHEN sqlc.narg('company_id')::BIGINT IS NULL THEN company_id IS NULL ELSE company_id= sqlc.narg('company_id')::BIGINT END) AND status = @active_user::BIGINT AND is_email_verified= true;



-- name: GetPlatformUserDetailsByUserName :one
SELECT
    pu.id,
    username,
    first_name,
    last_name,
    email,
    gender,
    pu.country_code,
    phone_number,
    countries.id AS "country_id",
    countries.country,
    countries.country_ar,
    countries."flag"
FROM
    platform_users pu
    LEFT JOIN countries ON countries.id = nationality
WHERE
    username = $1
    AND pu.status != @deleted_status::BIGINT;



-- name: ChangeStatusOfPlatformUserByUserName :one
UPDATE
    platform_users
SET
    status = $2
WHERE
    username = $1 AND (CASE WHEN sqlc.narg('company_id')::BIGINT IS NULL THEN company_id IS NULL ELSE company_id= sqlc.narg('company_id')::BIGINT END) AND status= @active_status::BIGINT
RETURNING 1;