

-- name: CreateAgentRoute :one
INSERT INTO agent_routes (
    leads_id,
    assigned_to,
    routed_to,
    reason,
    routed_date
) VALUES (
    $1, 
    $2, 
    $3, 
    $4, 
    $5  
) RETURNING *;

-- name: UpdateAgentRoute :one
UPDATE agent_routes
SET
    reason = $2
WHERE
    id = $1
    RETURNING *;


-- name: GetAllAgentRoutes :many
SELECT
    ar.id,
    ar.leads_id,
    l.ref_no,
    ar.assigned_to,
    au.username as "assigned_to_username",
    1 as "activity",
    ar.routed_to,
    ru.username as "routed_to_username",
    ar.reason,
    ar.routed_date
FROM
    agent_routes ar join leads l on ar.leads_id = l.id join users au on ar.assigned_to = au.id join users ru on ar.routed_to = ru.id
ORDER BY
    ar.id LIMIT $1 OFFSET $2;



-- name: GetCountAllAgentRoutes :one
SELECT
count(ar.*)
FROM
    agent_routes ar join leads l on ar.leads_id = l.id join users au on ar.assigned_to = au.id join users ru on ar.routed_to = ru.id
;



-- name: GetSingleAgentRoute :one
select * from agent_routes where leads_id = $1 and assigned_to = $2 and reason Ilike $3 LIMIT 1;



-- name: GetSingleAgentRouteCheck :one
select * from agent_routes where leads_id = $1 ORDER BY routed_date desc LIMIT 1;


-- name: GetFilterAgentPerformance :many
    SELECT 
        ar.assigned_to, 
        ar.reason, 
        COUNT(*) AS reason_count,
        ROW_NUMBER() OVER (PARTITION BY ar.assigned_to ORDER BY COUNT(*) DESC) AS reason_rank
    FROM 
        public.agent_routes ar
        WHERE ar.assigned_to in (select assigned_to from agent_routes order by routed_date desc limit $1 offset $2) or sqlc.arg(disable_pagination)::BOOLEAN
    GROUP BY 
        ar.assigned_to, 
        ar.reason
    ORDER BY 
    assigned_to; 

-- name: GetAllAssignedAgents :one
select COUNT(DISTINCT(assigned_to)) from agent_routes;