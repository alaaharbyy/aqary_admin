-- name: CreateProjectCompletionHistory :one
INSERT INTO  project_completion_history (
    projects_id,
    phases_id,
    completion_percentage,
    completion_percentage_date,
    created_at,
    updated_at
) VALUES(
    $1, $2 ,$3, $4, $5, $6
) RETURNING *;