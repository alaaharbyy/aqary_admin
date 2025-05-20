-- name: CreateFreelancersBankAccountDetail :one
INSERT INTO freelancers_bank_account_details (
    account_name,
    account_number,
    iban,
    countries_id,
    currency_id,
    bank_name,
    branch,
    swift_code,
    freelancers_id,
    created_at,
    updated_at
)VALUES (
    $1 ,$2, $3, $4, $5,$6,$7,$8, $9, $10, $11
) RETURNING *;


-- name: GetFreelancersBankAccountDetails :one
SELECT * FROM freelancers_bank_account_details 
WHERE id = $1 LIMIT $1;

 
-- name: GetAllFreelancersBankAccountDetail :many
SELECT * FROM freelancers_bank_account_details
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateFreelancersBankAccountDetail :one
UPDATE freelancers_bank_account_details
SET  account_name = $2,
    account_number = $3,
    iban = $4,
    countries_id = $5,
    currency_id = $6,
    bank_name = $7,
    branch = $8,
    swift_code = $9,
    freelancers_id = $10,
    updated_at = $11
Where id = $1
RETURNING *;


-- name: DeleteFreelancersBankAccountDetail :exec
DELETE FROM freelancers_bank_account_details
Where id = $1;

