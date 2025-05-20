-- name: CreatePhasesFacts :one
INSERT INTO phases_facts (
    plot_area, 
    phases_id, 
    completion_status, 
    built_up_area, 
    furnished, 
    no_of_properties, 
    lifestyle, 
    ownership,
    start_date, 
    completion_date, 
    handover_date, 
    service_charge, 
    no_of_parkings, 
    no_of_retails, 
    no_of_pools,
    no_of_elevators,
    created_at,
    update_at,
    completion_percentage,
    completion_percentage_date,
    sc_currency_id,
    unit_of_measure,
    starting_price
    )
VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23
) RETURNING *;

-- name: GetPhasesFactsByPhaseId :one
SELECT * FROM phases_facts WHERE phases_id = $1;

-- name: UpdatePhasesFacts :one
UPDATE phases_facts SET 
    plot_area = $2, 
    phases_id = $3, 
    completion_status = $4, 
    built_up_area = $5, 
    furnished = $6, 
    no_of_properties = $7, 
    lifestyle = $8, 
    ownership = $9,
    start_date = $10, 
    completion_date = $11, 
    handover_date = $12, 
    service_charge = $13, 
    no_of_parkings = $14, 
    no_of_retails = $15, 
    no_of_pools = $16,
    no_of_elevators = $17,
    created_at = $18,
    update_at = $19,
    completion_percentage = $20,
    completion_percentage_date = $21,
    sc_currency_id = $22,
    unit_of_measure = $23,
    starting_price = $24
WHERE id = $1 RETURNING *;     

-- name: GetAllConsumeFactsCountByPhaseId :one
SELECT COALESCE(SUM(plot_area),0)::bigint AS plot_area_consume,COALESCE(SUM(built_up_area),0)::bigint AS built_up_area_consume,COUNT(project_properties.id) AS properties_consume
FROM properties_facts
LEFT JOIN project_properties ON project_properties.id = properties_facts.properties_id AND properties_facts.property = 1
WHERE project_properties.projects_id = $1 AND project_properties.phases_id = $2 AND (project_properties.status != 5 AND project_properties.status != 6);

-- name: DeletePhaseFactById :exec
DELETE from phases_facts where id = $1;

