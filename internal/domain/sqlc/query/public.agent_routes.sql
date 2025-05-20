

-- name: GetAllAgentPerformance :many
SELECT 
    assigned_to, 
    reason, 
    COUNT(*) AS reason_count
FROM 
    public.agent_routes
GROUP BY 
    assigned_to, 
    reason
ORDER BY 
    assigned_to, 
    reason_count DESC;



-- name: GetSingleAgentPerformance :many
SELECT 
    assigned_to, 
    reason, 
    COUNT(*) AS reason_count
FROM 
    public.agent_routes WHERE assigned_to = $1
GROUP BY 
    assigned_to, 
    reason
ORDER BY 
    assigned_to, 
    reason_count DESC;

