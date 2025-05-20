-- name: CreateRealEstateAgents :one
INSERT INTO real_estate_agents (entity_type_id, entity_id, agent_id, note, assignment_date)
VALUES ($1, $2, $3, $4, $5) RETURNING *;

-- name: GetAllRealEstateAgents :many
SELECT * FROM real_estate_agents;

-- name: GetRealEstateAgentById :one
SELECT * FROM real_estate_agents where id=$1;

-- name: GetRealEstateAgentByEntityType :one
SELECT * FROM real_estate_agents where entity_type_id = $1;

-- name: GetRealEstateAgentByEntityTypeEntityId :many
SELECT * FROM real_estate_agents where entity_type_id = $1
and entity_id = $2;


-- name: UpdateRealEstateAgent :one
UPDATE real_estate_agents
SET note = $1, 
agent_id = $2,
assignment_date = $3,
updated_at =$4,
entity_type_id = $5,
entity_id = $6
WHERE id = $7
RETURNING *;

-- name: DeleteRealEstateAgent :exec
DELETE FROM real_estate_agents
Where id = $1;