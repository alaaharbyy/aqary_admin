
-- name: CreateViews :one
INSERT INTO views (
    title,
    icon,
    created_at,
    updated_at, 
    status,
    title_ar
) VALUES (
    $1, $2, $3, $4,$5,$6
) RETURNING *;

-- name: GetViews :one
SELECT * FROM views 
WHERE id = $1 LIMIT $1;

-- name: GetViewsWithStatus :one
SELECT * FROM views 
WHERE id = $1 AND status!= @deleted_status::BIGINT;

-- name: GetAllViewsCount :one
SELECT COUNT(id) AS total FROM views;



-- name: GetAllViews :many
SELECT * FROM views
ORDER BY id DESC
LIMIT $1
OFFSET $2;


-- name: GetAllViewsByStatus :many
SELECT * FROM views
where status = $1
ORDER BY updated_at DESC
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetAllViewsByStatusCount :one
SELECT COUNT(id) AS total FROM views
where status = $1;

-- name: UpdateViews :one
UPDATE views
SET  
    title = $2,
    icon = $3,
    created_at = $4,
    updated_at = $5,
    title_ar=$6
Where id = $1
RETURNING *;

-- name: DeleteViews :exec
UPDATE views
SET status = $2, 
    updated_at=$3
WHERE id = $1;

-- name: GetCountAllViews :one 
select count(*) FROM views; 

-- name: GetAllViewsById :many
SELECT * FROM views WHERE id = ANY($1::bigint[]);

-- name: GetAllViewsWithoutPagenation :many
SELECT * FROM views
WHERE status = @active_status::BIGINT
ORDER BY id; 

-- name: GetAllViewsForProperty :many
    SELECT sqlc.embed(views)
    FROM property
    JOIN views ON views.id = ANY(ARRAY(SELECT jsonb_array_elements_text(facts->'views')::BIGINT)) WHERE property.id= $1;