-- name: CreateTaxMangement :one
INSERT INTO tax_management (
  ref_no,
  company_types_id,
  companies_id,
  countries_id,
  states_id,
  tax_code,
  tax_category_id,
  tax_category_type,
  tax_title,
  tax_percentage,
  is_branch,
  created_by)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) RETURNING *;
 
-- name: GetAllTaxMangement :many
SELECT * FROM tax_management;
 
-- name: GetTaxMangementById :one
SELECT * FROM tax_management WHERE id = $1;
 
-- name: GetAllTaxMangementWithPg :many
SELECT * FROM tax_management LIMIT $1 OFFSET $2;
 
-- name: GetAllTaxMangementByCategoryType :many
SELECT * FROM tax_management WHERE tax_category_type = $1;
 
 
-- name: UpdateTaxMangement :one
UPDATE tax_management 
SET
   ref_no = $1, 
   company_types_id = $2,
   companies_id = $3,
   countries_id = $4, 
   states_id = $5,
   tax_code = $6,
   tax_category_id = $7,
   tax_category_type = $8,
   tax_title = $9,
   tax_percentage = $10,
   updated_at = $11,
   is_branch = $12
WHERE id = $13
RETURNING *;
 
-- name: DeleteTaxMangement :exec
DELETE FROM tax_management where id = $1;

-- name: GetCountAllTaxMangementByCategoryType :many
SELECT Count(*) FROM tax_management WHERE tax_category_type = $1;
 
-- name: GetCountAllTaxMangement :many
SELECT Count(*) FROM tax_management;