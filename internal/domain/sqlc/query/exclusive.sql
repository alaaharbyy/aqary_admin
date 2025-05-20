-- name: ChangeProjectExclusivity :exec
UPDATE 
	projects 
SET 
	exclusive=$2, 
	start_date=$3, 
	end_date=$4
WHERE 
	id=$1 AND status!=6; 


-- name: ChangeProjectPhasesExclusivity :many 
UPDATE 
	phases
SET 
	exclusive=$1, 
	start_date=$2, 
	end_date=$3
WHERE 
	projects_id= @project_id::BIGINT AND status!=6
RETURNING id;


-- name: ChangeEntitiesPropertiesExclusivity :many 
UPDATE 
	property
SET
	exclusive=$1, 
	start_date=$2, 
	end_date=$3 
WHERE 
	entity_type_id= @entity_type::BIGINT AND entity_id= ANY( @entities_ids::BIGINT[]) AND status!=6 
RETURNING id;


-- name: ChangePropertiesUnitsExclusivity :exec 
UPDATE 
	units
SET 
	exclusive=$1,
	start_date=$2, 
	end_date=$3
WHERE 
	entity_type_id= @property_entity_type::BIGINT AND entity_id= ANY( @entities_ids::BIGINT[]) AND status!=6 
RETURNING id;


-- name: ChangePhaseExclusivity :exec 
UPDATE 
	phases
SET 
	exclusive=$1,
	start_date=$2, 
	end_date=$3
WHERE 
	id=$4 AND status!=6; 



-- name: ChangePropertyExclusivity :exec 
UPDATE 
	property
SET 
	exclusive=$1,
	start_date=$2, 
	end_date=$3
WHERE 
	id=$4 AND status!=6;

-- name: ChangeUnitExclusivity :exec 
UPDATE 
	units
SET 
	exclusive=$1,
	start_date=$2, 
	end_date=$3
WHERE 
	id=$4 AND status!=6;