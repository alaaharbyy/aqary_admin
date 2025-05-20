-- name: CreateProjectRequests :one
INSERT INTO project_requests (
    request_type,
    profiles_id,
    projects_id,
    created_at,
    updated_at,
    status,
    ref_no,
    users_id
)VALUES (
    $1, $2, $3, $4, $5, $6, $7 , $8
) RETURNING *;

-- name: GetProjectRequests :one
SELECT * FROM project_requests
WHERE id = $1 LIMIT $1;

-- name: GetAllProjectRequests :many
SELECT * FROM project_requests
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateProjectRequests :one
UPDATE project_requests
SET     request_type = $2,
    profiles_id = $3,
    projects_id = $4,
    created_at = $5,
    updated_at = $6,
     status = $7,
    ref_no = $8,
    users_id = $9
Where id = $1
RETURNING *;

-- name: DeleteProjectRequests :exec
DELETE FROM project_requests
Where id = $1;