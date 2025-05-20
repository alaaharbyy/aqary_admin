-- name: CreateBannerPlanCost :one
INSERT INTO banner_plan_cost (
    country_id, 
    company_type,
    plan_package_id, 
    platform, 
    price, 
    status,
    created_at,
    updated_at
)
SELECT 
    $1, $2, $3, $4, $5, $6, $7, $8
FROM banner_plan_package
WHERE banner_plan_package.id = $3 AND banner_plan_package.status !=6
RETURNING id;


-- name: GetBannerPlanCostByPlanPkgID :one
SELECT *
FROM banner_plan_cost
WHERE plan_package_id = $1;

-- name: GetBannerPlanCostByID :one
SELECT *
FROM banner_plan_cost
INNER join countries on countries.id = banner_plan_cost.country_id
inner join banner_plan_package on banner_plan_package.id = banner_plan_cost.plan_package_id
LEFT JOIN company_types on company_types.id = banner_plan_cost.company_type
WHERE banner_plan_cost.id = $1 and banner_plan_cost.status != 6;

-- name: GetAllBannerPlanCostByID :one
SELECT *
FROM banner_plan_cost
INNER join countries on countries.id = banner_plan_cost.country_id
inner join banner_plan_package on banner_plan_package.id = banner_plan_cost.plan_package_id
LEFT JOIN company_types on company_types.id = banner_plan_cost.company_type
WHERE banner_plan_cost.id = $1 ;


-- name: ListBannerPlanCosts :many
SELECT *
FROM banner_plan_cost
INNER join countries on countries.id = banner_plan_cost.country_id
inner join banner_plan_package on banner_plan_package.id = banner_plan_cost.plan_package_id
LEFT JOIN company_types on company_types.id = banner_plan_cost.company_type
where banner_plan_cost.status = $1
ORDER BY banner_plan_cost.updated_at DESC
LIMIT sqlc.narg('limit') 
OFFSET sqlc.narg('offset');

-- name: CountBannerPlanCosts :one
SELECT COUNT(*)
FROM banner_plan_cost
WHERE banner_plan_cost.status !=6;



-- name: UpdateBannerPlanCost :one
UPDATE 
    banner_plan_cost
SET 
    country_id      = COALESCE(sqlc.narg('country_id'), country_id),
    company_type    = COALESCE(sqlc.narg('company_type'), company_type),
    plan_package_id = COALESCE(sqlc.narg('plan_package_id')::BIGINT, plan_package_id),
    platform        = COALESCE(sqlc.narg('platform'), platform),
    price           = COALESCE(sqlc.narg('price'), price),
    updated_at      = $2
WHERE banner_plan_cost.id = $1
  AND status = @active_status::BIGINT
  AND (
 sqlc.narg('plan_package_id')::BIGINT IS NULL 
    OR EXISTS (SELECT 1 FROM banner_plan_package WHERE id = sqlc.narg('plan_package_id')::BIGINT and status != 6)
)
RETURNING banner_plan_cost.id; 

-- name: UpdateBannerPlanCostStatus :one
UPDATE banner_plan_cost
SET 
    status = $2,
    updated_at = $3
WHERE id = $1
RETURNING id;

-- name: DeleteBannerPlanCost :exec
DELETE FROM banner_plan_cost
WHERE id = $1;
