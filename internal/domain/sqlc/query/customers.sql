-- name: GetActiveCustomerByEmail :one
SELECT * FROM platform_users
WHERE email = $1 and status = @active_status::BIGINT
AND (CASE WHEN @company_id::bigint = 0 THEN company_id IS NULL ELSE company_id = @company_id::bigint END) AND is_email_verified = true;

-- name: GetCustomerByPhoneVerified :one
SELECT * FROM platform_users
WHERE phone_number = $1 AND country_code = $2 AND is_phone_verified = true AND status = @active_status::BIGINT
AND (CASE WHEN @company_id::bigint = 0 THEN company_id IS NULL ELSE company_id = @company_id::bigint END);

-- name: GetCustomerByUsername :one
SELECT * FROM platform_users
WHERE username = $1 and status = @active_status::BIGINT AND (CASE WHEN @company_id::bigint = 0 THEN company_id IS NULL ELSE company_id = @company_id::bigint END) AND is_email_verified = true;