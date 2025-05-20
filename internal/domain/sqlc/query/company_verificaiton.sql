

-- name: CreateUserVerification :one
INSERT INTO company_verification(
 entity_type_id,
 entity_id,
 verification_type,
 verification,
 response_date,
 updated_by,
 notes,
--  contract_file,
--  contract_upload_date,
--  uploaded_by,
--  upload_notes,
 created_at
)VALUES(
  $1, $2, $3, $4, $5, $6, $7, $8
)RETURNING *; 


-- name: UpdateUserVerification :one
Update company_verification 
SET 
 entity_type_id = $2,
 entity_id = $3,
 verification_type = $4,
 verification = $5,
 response_date = $6,
 updated_by = $7,
 notes = $8
--  contract_file = $9,
--  contract_upload_date = $9,
--  uploaded_by = $10,
--  upload_notes = $11
Where id = $1
RETURNING *;


-- -- name: GetUserLicenseVerification :one
-- SELECT * FROM company_verification
-- WHERE  company_verification.entity_id = $1 AND company_verification.contract_file = $2; 


-- name: CreateSubscriberVerification :one
INSERT INTO company_verification(
 entity_type_id,
 entity_id,
 verification_type,
 verification,
 response_date,
 updated_by,
 notes,
--  contract_file,
--  contract_upload_date,
--  uploaded_by,
--  upload_notes,
 created_at
--  draft_contract
)VALUES(
  $1, $2, $3, $4, $5, $6, $7, $8 
)RETURNING *;

-- name: GetCompanyVerificationByEntity :one
SELECT * FROM company_verification
WHERE  company_verification.entity_id = $1 AND company_verification.entity_type_id = $2 
AND company_verification.verification =$3;