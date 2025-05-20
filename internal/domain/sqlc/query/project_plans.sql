-- name: CreateProjectPlan :one
INSERT INTO project_plans (projects_id, title, plan_url, uploaded_by, updated_by)
VALUES ($1, $2, $3, $4, $5) RETURNING *;
 
-- name: UpdateProjectPlan :one
UPDATE project_plans
SET plan_url= $1 ,updated_by= $2,updated_at=$3
WHERE id = $4 RETURNING *;

-- name: GetSingleProjectPlanByID :one
SELECT project_plans.*,projects.project_name 
FROM project_plans
INNER JOIN projects ON projects.id = project_plans.projects_id
WHERE project_plans.id = $1;
 
-- name: GetPagProjectPlans :many
SELECT *
FROM project_plans
LIMIT $1
OFFSET $2;

-- name: GetProjectPlanByProjID :many
SELECT id, projects_id, title, plan_url, created_at, updated_at, uploaded_by, updated_by FROM project_plans
WHERE projects_id = $1
ORDER BY created_at DESC
LIMIT $2
OFFSET $3;


-- name: GetProjectPlanByProjIDWithoutPagination :many
SELECT id, projects_id, title, plan_url, created_at, updated_at, uploaded_by, updated_by FROM project_plans
WHERE projects_id = $1
AND
CASE
    WHEN @planType::Text = '' THEN true
    WHEN @planType::Text != '' THEN project_plans.title = @planType::Text
END
ORDER BY created_at DESC;
 
-- name: DeleteProjPlan :exec
DELETE FROM project_plans
WHERE id = $1;

-- name: GetProjPlanByTitle :one
SELECT id, projects_id, title, plan_url, created_at, updated_at, uploaded_by, updated_by
FROM project_plans
WHERE title ILIKE $1 AND projects_id = $2;


-- name: GetProjectPlansCount :one
SELECT COUNT(*) FROM project_plans WHERE projects_id=$1;