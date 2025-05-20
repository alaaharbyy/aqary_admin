-- name: CreateProjectFileViewHistory :one
INSERT INTO project_fileview_history(
    title,
    activity,
    file_url,
    created_by,
    activity_date
) VALUES(
    $1, $2, $3, $4, $5
) RETURNING *;

-- name: GetAllProjectFileViewHistory :many
SELECT COUNT(project_fileview_history.id) OVER() AS total_count, project_fileview_history.*,(profiles.first_name ||' '|| profiles.last_name)::VARCHAR AS user FROM project_fileview_history
INNER JOIN users ON users.id = project_fileview_history.created_by
INNER JOIN profiles ON profiles.users_id = users.id
LIMIT $1 OFFSET $2;