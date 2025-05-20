
-- name: CreateGlobalPlan :one
INSERT INTO plans(
	entity_type_id, 
	entity_id, 
	title, 
	file_urls, 
	created_at, 
	updated_at, 
	uploaded_by, 
	updated_by
)VALUES (
	$1, 
	$2, 
	$3, 
	$4, 
	$5, 
	$6, 
	$7, 
	$8)RETURNING *; 


-- name: UpdateGlobalPlan :one
UPDATE plans
SET 
	file_urls=$1, 
	updated_at=$2, 
	updated_by=$3
WHERE 
	entity_type_id=$4 AND entity_id=$5 AND title=$6
RETURNING *;



-- name: GetGlobalPlan :one	
WITH status_calculation AS (
    SELECT CASE  @entity_type::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = @entity_id::BIGINT)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = @entity_id::BIGINT)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = @entity_id::BIGINT)
               --WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = @entity_id::BIGINT)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = @entity_id::BIGINT)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = @entity_id::BIGINT)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = @entity_id::BIGINT)
               --WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = @entity_id::BIGINT)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = @entity_id::BIGINT)
               --WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = @entity_id::BIGINT)
               --WHEN 16 THEN (SELECT 1 FROM publish_listing WHERE publish_listing.id = @entity_id::BIGINT)
                WHEN 18 THEN (SELECT 1 FROM company_profiles WHERE company_profiles.id = @entity_id::BIGINT)
               WHEN 19 THEN (SELECT 1 FROM company_profiles_projects WHERE company_profiles_projects.id = @entity_id::BIGINT)
               WHEN 20 THEN (SELECT 1 FROM company_profiles_phases WHERE company_profiles_phases.id = @entity_id::BIGINT)

               ELSE 0::BIGINT
           END AS status
)
SELECT 
    COALESCE(plans.id, 0) AS "plan_id",
    COALESCE(plans.file_urls, ARRAY[]::VARCHAR[]) AS "file_urls",
    COALESCE(plans.entity_id, 0) AS "entity_id",
    COALESCE(status_calculation.status,-1::BIGINT) AS "status"
FROM 
    status_calculation 
LEFT JOIN 
    plans ON 
        plans.entity_type_id =  @entity_type::BIGINT 
        AND plans.entity_id = @entity_id::BIGINT 
        AND plans.title = $1
        AND status_calculation.status NOT IN (-1,0,6);



-- name: GetEntityIdGlobalPlan :many
SELECT plans.id AS "global_plan_id",plans.title,plans.entity_id AS "entity_id" , plans.entity_type_id AS "entity_type_id" ,plans.created_at,plans.updated_at,plans.file_urls,plans.uploaded_by,plans.updated_by
FROM 
	plans
WHERE 
	plans.entity_id= @entity_id::BIGINT AND plans.entity_type_id= @entity_type::BIGINT AND
	COALESCE((SELECT CASE  @entity_type::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = @entity_id::BIGINT)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = @entity_id::BIGINT)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = @entity_id::BIGINT)
               --WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = @entity_id::BIGINT)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = @entity_id::BIGINT)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = @entity_id::BIGINT)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = @entity_id::BIGINT)
               --WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = @entity_id::BIGINT)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = @entity_id::BIGINT)
               --WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = @entity_id::BIGINT)
               --WHEN 16 THEN (SELECT 1 FROM publish_listing WHERE publish_listing.id = @entity_id::BIGINT)
                WHEN 18 THEN (SELECT 1 FROM company_profiles WHERE company_profiles.id = @entity_id::BIGINT)
               WHEN 19 THEN (SELECT 1 FROM company_profiles_projects WHERE company_profiles_projects.id = @entity_id::BIGINT)
               WHEN 20 THEN (SELECT 1 FROM company_profiles_phases WHERE company_profiles_phases.id = @entity_id::BIGINT)
               
               ELSE 0::BIGINT
           END),6::BIGINT) NOT IN(0,6)
ORDER BY 
	plans.updated_at DESC
LIMIT $1 
OFFSET $2;



-- name: GetNumberOfEntityIdGlobalPlan :one
SELECT COUNT(*) 
FROM 
	plans 
WHERE 
	entity_id= @entity_id::BIGINT AND entity_type_id= @entity_type::BIGINT;



-- name: DeleteEntityGlobalPlanByURL :one 
UPDATE plans 
SET 
	file_urls = array_remove(file_urls, @file_url::VARCHAR),
	updated_at=$1 
WHERE 
	plans.id= @plan_id AND @file_url::VARCHAR = ANY(file_urls) AND 
	COALESCE((SELECT CASE  plans.entity_type_id::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = plans.entity_id)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = plans.entity_id)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = plans.entity_id)
               --WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = plans.entity_id)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = plans.entity_id)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = plans.entity_id)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = plans.entity_id)
               --WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = plans.entity_id)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = plans.entity_id)
               --WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = plans.entity_id)
               --WHEN 16 THEN (SELECT 1 FROM publish_listing WHERE publish_listing.id = plans.entity_id::BIGINT)
                WHEN 18 THEN (SELECT 1 FROM company_profiles WHERE company_profiles.id = @entity_id::BIGINT)
               WHEN 19 THEN (SELECT 1 FROM company_profiles_projects WHERE company_profiles_projects.id = @entity_id::BIGINT)
               WHEN 20 THEN (SELECT 1 FROM company_profiles_phases WHERE company_profiles_phases.id = @entity_id::BIGINT)

               ELSE 0::BIGINT
           END),6::BIGINT) NOT IN (0,6)
RETURNING *;




-- name: DeleteEntityGlobalPlan :exec 
DELETE FROM plans WHERE id=$1;


-- name: DeleteEntityGlobalPlanByPlanId :one 
DELETE FROM plans WHERE plans.id =$1 AND 
COALESCE((SELECT CASE  plans.entity_type_id::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = plans.entity_id)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = plans.entity_id)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = plans.entity_id)
               --WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = plans.entity_id)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = plans.entity_id)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = plans.entity_id)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = plans.entity_id)
               --WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = plans.entity_id)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = plans.entity_id)
               --WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = plans.entity_id)
               --WHEN 16 THEN (SELECT 1 FROM publish_listing WHERE publish_listing.id = plans.entity_id::BIGINT)
                WHEN 18 THEN (SELECT 1 FROM company_profiles WHERE company_profiles.id = plans.entity_id)
               WHEN 19 THEN (SELECT 1 FROM company_profiles_projects WHERE company_profiles_projects.id = plans.entity_id)
               WHEN 20 THEN (SELECT 1 FROM company_profiles_phases WHERE company_profiles_phases.id = plans.entity_id)

               ELSE 0::BIGINT
           END),6::BIGINT) NOT IN (0,6)
RETURNING plans.file_urls;


-- name: DeleteXMLGlobalPlan :exec
DELETE FROM plans
WHERE entity_type_id = $1
  AND entity_id = ANY(@entity_ids::bigint[]);