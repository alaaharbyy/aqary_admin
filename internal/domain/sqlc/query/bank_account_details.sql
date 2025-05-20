-- name: CreateBankAccountDetails :one
INSERT INTO bank_account_details(
    account_name,
    account_number,
    iban,
    countries_id,
    currency_id,
    bank_name,
    bank_branch,
    swift_code,
    created_at,
    entity_type_id,
    entity_id
) VALUES(
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11
)RETURNING *;

-- name: GetCompanyBankAccountDetails :one
SELECT * FROM bank_account_details
WHERE entity_type_id = 6 AND entity_id = @company_id;


-- name: GetUserBankAccountDetails :one
SELECT * FROM bank_account_details
WHERE entity_type_id = 9 AND entity_id = @user_id;

 

-- name: UpdateBankAccountDetails :one
UPDATE bank_account_details
SET account_name = $2,
    account_number = $3,
    iban = $4,
    countries_id = $5,
    currency_id = $6,
    bank_name = $7,
    bank_branch = $8,
    swift_code = $9,
    updated_at = $10,
    updated_by = $11
WHERE id = $1 
RETURNING *;


-- name: UpdateBankAccountDetailsByEntityID :one
UPDATE bank_account_details
SET account_name = $2,
    account_number = $3,
    iban = $4,
    countries_id = $5,
    currency_id = $6,
    bank_name = $7,
    bank_branch = $8,
    swift_code = $9,
    updated_at = $10,
    updated_by = $11
WHERE  entity_type_id = 9 AND  entity_id = $1 
RETURNING *;

-- name: DeleteBankAccountDetails :exec
DELETE FROM bank_account_details
WHERE id = $1;