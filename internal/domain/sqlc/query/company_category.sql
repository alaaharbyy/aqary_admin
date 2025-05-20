-- name: CreateCompanyCategory :one
INSERT INTO company_category(
	category_name,
	created_by,
	created_at,
	updated_at,
	updated_by,
    status,
	company_type,
	category_name_ar
)VALUES($1, $2,$3,$4,$5,$6,$7,$8)
RETURNING *;
 
 
-- name: UpdateCompanyCategory :one
UPDATE company_category
SET 
	category_name=$1,
	updated_at=$2,
	updated_by=$3,
    status=$4,
	company_type=$5,
	category_name_ar=$7
WHERE id=$6
RETURNING *;

-- name: GetSingleCompanyCategory :one
SELECT * FROM company_category
WHERE id=$1;

-- name: GetAllCompanyCategories :many
SELECT * FROM company_category 
WHERE CASE WHEN @status::bigint = 0 THEN status != 6 ELSE status = @status::BIGINT END
ORDER BY id desc
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetAllCompanyCategoriesCount :one
SELECT COUNT(*) FROM company_category 
WHERE CASE WHEN @status::bigint = 0 THEN status != 6 ELSE status = @status::BIGINT END;

-- name: ChangeStatusOfCompanyCategory :one
UPDATE company_category
SET 
	updated_at=$2,
	updated_by=$3,
    status=$4
WHERE id=$1
RETURNING *;

-- name: GetActiveCompanyCategoryByTypeId :many
SELECT id, category_name FROM company_category
WHERE company_type=$1 AND status = 2
ORDER BY id desc;