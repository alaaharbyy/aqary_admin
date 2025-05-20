-- name: CreateListingProblemsReport :one
INSERT INTO listing_problems_report (
    unit_id,
    unit_reference_table,
    reason,
    message,
    company_id,
    company_type,
    profiles_id,
    created_at,
    updated_at,
    ref_no,
    users_id
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11
) RETURNING *;

-- name: GetListingProblemsReport :one
SELECT * FROM listing_problems_report
WHERE id = $1 LIMIT $1;

-- name: GetAllListingProblemsReport :many
SELECT * FROM listing_problems_report
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateListingProblemsReport :one
UPDATE listing_problems_report
SET   unit_id = $2,
    unit_reference_table = $3,
    reason = $4,
    message = $5,
    company_id = $6,
    company_type = $7,
    profiles_id = $8,
    created_at = $9,
    updated_at = $10,
    ref_no = $11,
    users_id = $12
Where id = $1
RETURNING *;

-- name: DeleteListingProblemsReport :exec
DELETE FROM listing_problems_report
Where id = $1;