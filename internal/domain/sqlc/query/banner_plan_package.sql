-- name: CreateBannerPlanPackage :exec
INSERT INTO
    banner_plan_package (
        package_name,
        plan_type,
        plan_package_name,
        quantity,
        counts_per_banner,
        icon,
        description,
        status,
        created_at,
        updated_at
    )
VALUES(
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10
    );
    
    
-- name: UpdateBannerPlanPackage :one
UPDATE
    banner_plan_package
SET
    package_name = COALESCE(sqlc.narg('package_name'), package_name),
    plan_type = COALESCE(sqlc.narg('plan_type'), plan_type),
    plan_package_name = COALESCE(sqlc.narg('plan_package_name'), plan_package_name),
    quantity = COALESCE(sqlc.narg('quantity'), quantity),
    counts_per_banner = COALESCE(sqlc.narg('counts_per_banner'), counts_per_banner),
    icon = COALESCE(sqlc.narg('icon'), icon),
    description = sqlc.narg('description'),
    updated_at = $2
WHERE
    id = $1
    AND status = @active_status::BIGINT
RETURNING id;


-- name: GetBannerPlanPackage :one 
SELECT
    package_name,
    plan_type,
    description,
    plan_package_name,
    quantity,
    counts_per_banner,
    icon
FROM 
	banner_plan_package
WHERE
    id =$1
    AND status =$2;
	
	
-- name: GetAllBannerPlanPackages :many
SELECT
    id,
    package_name,
    plan_type,
    description,
    plan_package_name,
    quantity,
    counts_per_banner,
    icon,
    updated_at
FROM
    banner_plan_package
WHERE
    status =$1
ORDER BY
    updated_at DESC
LIMIT
    sqlc.narg('limit') OFFSET sqlc.narg('offset');

	
	
-- name: GetNumberOfBannerPlanPackages :one 
SELECT
    COUNT(*)
FROM
    banner_plan_package
WHERE
    status = $1;
	
	
-- name: UpdateBannerPlanPackageStatus :one 
UPDATE
    banner_plan_package
SET
    status =$2,
    updated_at =$3
WHERE
    id =$1 RETURNING id;


-- name: GetBannerPlanPackageByID :one
SELECT
    id,
    package_name,
    plan_type,
    plan_package_name,
    quantity,
    counts_per_banner,
    icon,
    description,
    status,
    created_at,
    updated_at
FROM
    banner_plan_package
WHERE
    id = $1;
	
	
	
	