 
-- name: CreateBenefit :one
INSERT INTO benefits (
    career,
    title,
    title_ar,
    icon_url,
    created_at,
    status,
    updated_at
 ) VALUES (
    $1, $2, $3, $4, $5, $6, $7
) RETURNING *;

-- name: UpdateBenefitById :one
UPDATE benefits SET
    title = $1,
    title_ar = $2,
    icon_url = $3,
    updated_at = $4
WHERE id = $5
RETURNING *;

-- name: GetBenefitById :one
SELECT * FROM benefits WHERE id = $1;
 
-- name: GetAllBenefitsByCareer :many
SELECT * FROM benefits WHERE career= $1 and status!=6;
 
-- name: GetAllBenefits :many
SELECT sqlc.embed(benefits) FROM benefits where status!=6 and status!=5 
ORDER BY updated_at DESC 
LIMIT $1 OFFSET $2;

-- name: UpdateBenefitStatus :one
UPDATE benefits SET
     status = $1
WHERE id = $2
RETURNING *;

-- name: GetBenefitsCount :one
select count(*) from benefits where status != 5 AND status!=6;