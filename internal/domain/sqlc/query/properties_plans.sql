-- name: CreatePropertyPlan :one
INSERT INTO properties_plans (
    img_url,
    title,
    properties_id,
    property,
    created_at,
    updated_at

)VALUES (
    $1, $2, $3, $4, $5, $6
) RETURNING *;

-- name: GetPropertyPlan :one
SELECT * FROM properties_plans 
WHERE id = $1 LIMIT $1;


-- name: GetAllPropertyPlanByPropertyIdWhichProperty :many
SELECT * FROM properties_plans 
WHERE properties_id = $1  AND property = $2;


-- name: GetAllPropertyPlanWithoutPagination :many
SELECT * FROM properties_plans
ORDER BY id;
 
-- name: GetAllPropertyPlan :many
SELECT * FROM properties_plans
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdatePropertyPlan :one
UPDATE properties_plans
SET  img_url = $2,
    title = $3,
    properties_id = $4,
    property = $5,
    created_at = $6,
    updated_at = $7
Where id = $1
RETURNING *;


-- name: DeletePropertyPlan :exec
DELETE FROM properties_plans
Where id = $1;


-- name: GetAllPropertyPlanById :many
SELECT id, img_url, title, properties_id, property, created_at, updated_at 
 FROM properties_plans 
WHERE properties_id = $3 AND property = $4
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;


-- name: GetAllPropertyPlanByIdWithoutPagination :many
SELECT id, img_url, title, properties_id, property, created_at, updated_at 
 FROM properties_plans 
WHERE properties_id = $1 AND property = $2
ORDER BY created_at DESC;

-- name: GetCountAllPropertyPlanById :one
SELECT COUNT(id)
 FROM properties_plans 
WHERE properties_id = $1 AND property = $2;



-- name: GetPropertyPlanByTitle :one
SELECT * FROM properties_plans 
WHERE title = $1 AND properties_id = $2 AND property = $3;

-- name: GetPropertiesPlansByProjectId :many
select  * from properties_plans where properties_plans.projects_id = $1;

-- name: GetPropertyNameByIdAndProperty :one
WITH x AS (
  SELECT property_name FROM project_properties 
  WHERE project_properties.id = $1 AND 1::bigint = @property::bigint
  UNION ALL
  SELECT property_name FROM freelancers_properties 
  WHERE freelancers_properties.id = $1 AND 2::bigint = @property::bigint
  UNION ALL
  SELECT property_name FROM broker_company_agent_properties 
  WHERE broker_company_agent_properties.id = $1 AND 3::bigint = @property::bigint
  UNION ALL
  SELECT property_name FROM owner_properties 
  WHERE owner_properties.id = $1 AND 4::bigint = @property::bigint
)SELECT * FROM x LIMIT 1;