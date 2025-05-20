-- name: CheckExistingEntity :one
SELECT id, status 
FROM projects 
WHERE id = @entity_id::BIGINT AND @entity_type::BIGINT = @project_entity_type::BIGINT

UNION ALL

SELECT id, status 
FROM phases 
WHERE id = @entity_id::BIGINT AND @entity_type::BIGINT = @phase_entity_type::BIGINT

UNION ALL

SELECT id, status 
FROM property 
WHERE id = @entity_id::BIGINT AND @entity_type::BIGINT = @property_entity_type::BIGINT

UNION ALL

SELECT id, status 
FROM units 
WHERE id = @entity_id::BIGINT AND @entity_type::BIGINT = @unit_entity_type::BIGINT

UNION ALL

SELECT id, status 
FROM company_profiles_projects 
WHERE id = @entity_id::BIGINT AND @entity_type::BIGINT = @company_profiles_project_entity::BIGINT

UNION ALL

SELECT id, status 
FROM company_profiles_phases 
WHERE id = @entity_id::BIGINT AND @entity_type::BIGINT =  @company_profiles_phase_entity::BIGINT;


-- name: UpdateProjectsStatus :exec
UPDATE projects 
SET 
    status=$1,
    updated_at=$2,
    deleted_at=$3
WHERE id=ANY(@project_ids::BIGINT[]);
