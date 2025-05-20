

-- name: CreateRoutingTrigger :one
INSERT INTO routing_triggers (
    title,
    lead_activity,
    next_activity,
    interval,
    interval_type,
    added_by,
    created_at
) VALUES (
    $1, 
    $2, 
    $3, 
    $4, 
    $5, 
    $6, 
    $7  
) RETURNING *;



-- name: GetAllRoutingTriggers :many
SELECT
    id,
    title,
    lead_activity,
    next_activity,
    interval,
    interval_type,
    added_by,
    created_at
FROM
    routing_triggers
ORDER BY
    id
LIMIT $1 OFFSET $2;

-- name: GetCountAllRoutingTriggers :one
SELECT
    count(*)
FROM
    routing_triggers
;
