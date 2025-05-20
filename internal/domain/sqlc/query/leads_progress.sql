-- name: CreateLeadProgress :one
INSERT INTO leads_progress(
leads_id,
progress_date,
progress_status,
lead_status
) VALUES (
$1,
$2,
$3,
$4
) RETURNING *;

-- name: UpdateLeadProgressByLeadsId :one
UPDATE leads_progress
SET
    progress_date = $2,
    progress_status = $3,
    lead_status = $4
WHERE
    leads_id = $1
RETURNING *;

-- name: GetLeadProgressByLeadsID :one
SELECT *
FROM leads_progress
WHERE leads_id = $1
LIMIT 1;

-- name: UpdateLeadStatus :one
UPDATE leads_progress SET lead_status = $2 WHERE leads_id = $1 RETURNING *;



-- name: UpdateLeadProgressStatus :one
UPDATE leads_progress SET progress_status = $2 WHERE leads_id = $1 RETURNING *;



-- name: UpdateLeadProgressStatusAndStatus :one
UPDATE leads_progress SET progress_status = $2, lead_status = $3 WHERE leads_id = $1 RETURNING *;

