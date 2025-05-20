
-- name: CreateCompanyReject :one
INSERT INTO company_rejects (
 reason,
 company_id,
 rejected_by,
 created_at,
 updated_at
)VALUES (
 $1, $2, $3, $4, $5
)RETURNING *;
