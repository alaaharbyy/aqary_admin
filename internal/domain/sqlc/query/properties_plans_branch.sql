-- name: CreatePropertyBranchPlan :one
INSERT INTO properties_plans_branch (
    img_url,
    title,
    properties_id,
    property,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3, $4, $5, $6
) RETURNING *;

-- name: GetPropertyBranchPlan :one
SELECT * FROM properties_plans_branch 
WHERE id = $1 LIMIT $1;


-- name: GetAllPropertyBranchPlanWithoutPagination :many
SELECT * FROM properties_plans_branch
ORDER BY id;
 
-- name: GetAllPropertyBranchPlan :many
SELECT * FROM properties_plans_branch
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdatePropertyBranchPlan :one
UPDATE properties_plans_branch
SET  img_url = $2,
    title = $3,
    properties_id = $4,
    property = $5,
    created_at = $6,
    updated_at = $7
Where id = $1
RETURNING *;


-- name: DeletePropertyBranchPlan :exec
DELETE FROM properties_plans_branch
Where id = $1;


-- name: GetAllPropertyBranchPlanById :many
SELECT id, img_url, title, properties_id, property, created_at, updated_at 
 FROM properties_plans_branch 
WHERE properties_id = $1 AND property = $2;



-- name: GetPropertiesBranchPlanByTitle :one
SELECT * FROM properties_plans_branch 
WHERE title = $1 AND properties_id = $2 AND property = $3;


-- name: GetPropertyPlanBranchByTitle :one
SELECT * FROM properties_plans_branch 
WHERE title=$1 AND properties_id=$2 AND property=$3;