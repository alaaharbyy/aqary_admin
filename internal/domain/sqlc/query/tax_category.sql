-- name: CreateTaxCategory :one
INSERT INTO tax_category (
  tax_code,
  tax_title,
  tax_description)
VALUES ($1, $2, $3) RETURNING *;
 
-- name: GetAllTaxCategory :many
SELECT * FROM tax_category;
 
-- name: GetTaxCategoryById :one
SELECT * FROM tax_category WHERE id = $1;
 
-- name: GetAllTaxCategoryWithPg :many
SELECT * FROM tax_category LIMIT $1 OFFSET $2;
 
-- name: GetAllTaxCategoryByTaxCode :many
SELECT * FROM tax_category WHERE tax_code = $1;
 
 
-- name: UpdateTaxCategory :one
UPDATE tax_category 
SET
   tax_code = $1, 
   tax_title = $2,
   tax_description = $3
WHERE id = $4
RETURNING *;
 
-- name: DeleteTaxCategory :exec
DELETE FROM tax_category where id = $1;