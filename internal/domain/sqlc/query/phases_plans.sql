-- name: CreatePhasesPlans :one
INSERT INTO phases_plans (
    "phases_id",
    "title",
    "plan_url",
    "created_at",
    "updated_at",
    "uploaded_by",
    "updated_by"
    )
VALUES (
    $1, $2, $3, $4, $5, $6, $7
) RETURNING *;

-- name: GetPhasesPlans :one
SELECT phases_plans.*,phases.phase_name 
FROM phases_plans 
INNER JOIN phases ON phases.id = phases_plans.phases_id
WHERE phases_plans.id = $1;

-- name: GetAllPhasesPlans :many
SELECT * FROM phases_plans WHERE phases_id= $3
ORDER BY id
LIMIT $1 OFFSET $2;

-- name: GetCountAllPhasesPlans :one
SELECT COUNT(id) FROM phases_plans WHERE phases_id = $1;


-- name: GetAllPhasesPlansWithoutPagination :many
SELECT * FROM phases_plans WHERE phases_id= $1
ORDER BY id;



-- name: UpdatePhasesPlans :one
UPDATE phases_plans SET
    "phases_id" = $2,
    "title" = $3,
    "plan_url" = $4,
    "created_at" = $5,
    "updated_at" = $6,
    "uploaded_by" = $7,
    "updated_by" = $8
WHERE id = $1 RETURNING *;

-- name: DeletePhasesPlans :exec
DELETE FROM phases_plans
WHERE id = $1;

-- name: GetPhasesPlansByTitle :one
SELECT * FROM phases_plans 
WHERE title ILIKE $1 AND phases_id = $2;


-- name: GetAllPhasesPlansByPhasesId :many
SELECT * FROM phases_plans 
WHERE phases_id = $1;