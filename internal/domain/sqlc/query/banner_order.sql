-- name: GetBannerPlanPackagesByFilters :many
SELECT
    banner_plan_package.id,
    banner_plan_package.plan_type,
    banner_plan_cost.id AS "banner_plan_cost_id",
    banner_plan_package.plan_package_name,
    banner_plan_cost.price, 
    banner_plan_cost.platform, 
    banner_plan_package.quantity, 
    banner_plan_package.counts_per_banner
FROM
    banner_plan_cost
    INNER JOIN banner_plan_package ON banner_plan_package.id = banner_plan_cost.plan_package_id
    AND banner_plan_cost.status = @active_status::BIGINT
    AND banner_plan_package.status = @active_status::BIGINT
    AND banner_plan_cost.country_id = @country_id::BIGINT
    AND banner_plan_cost.company_type = (SELECT companies.company_type FROM companies WHERE companies.id= @company_id::BIGINT AND companies.status!=6)
    AND (sqlc.narg('platform')::BIGINT IS NULL OR  banner_plan_cost.platform = sqlc.narg('platform')::BIGINT)
    AND (CASE WHEN  ARRAY_LENGTH(@plan_package_ids::BIGINT [],1) IS NULL THEN TRUE ELSE banner_plan_cost.plan_package_id= ANY(@plan_package_ids::BIGINT []) END);


-- name: CreateBannerOrder :one
INSERT INTO
    banner_order (
        ref_no,
        company_id,
        plan_packages,
        total_price,
        start_date,
        end_date,
        created_by,
        created_at,
        updated_at, 
        status, 
        company_type, 
        country_id, 
        note
    )
VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)RETURNING 1; 



-- name: GetBannerOrderByID :one
SELECT
    banner_order.id,
    banner_order.ref_no,
    banner_order.company_id,
    banner_order.country_id,
    banner_order.plan_packages,
    banner_order.total_price,
    banner_order.start_date,
    banner_order.end_date,
    banner_order.created_by,
    banner_order.created_at,
    banner_order.updated_at, 
    banner_order.status,
    banner_order.note,
    companies.company_name, 
    companies.company_type, 
    countries.country
FROM
    banner_order
INNER JOIN companies ON companies.id=banner_order.company_id
INNER JOIN countries ON countries.id=banner_order.country_id
WHERE
    banner_order.id = $1::BIGINT;
    -- AND banner_order.status = @active_status::BIGINT;


-- name: GetAllBannerOrder :many
SELECT
    banner_order.id,
    banner_order.ref_no,
    banner_order.country_id,
    banner_order.company_id,
    banner_order.plan_packages,
    banner_order.total_price,
    banner_order.start_date,
    banner_order.end_date,
    banner_order.created_by,
    banner_order.created_at,
    banner_order.updated_at,
    banner_order.status,
    companies.company_name,
    companies.company_type, 
    countries.country
FROM
    banner_order
    LEFT JOIN companies ON companies.id = banner_order.company_id
    LEFT JOIN countries ON countries.id=banner_order.country_id
WHERE
    banner_order.status = ANY(@active_status::BIGINT[])
ORDER BY banner_order.created_at DESC
LIMIT $1 OFFSET $2;

-- name: GetCompaniesById :one
SELECT * FROM companies
WHERE id = $1;

-- name: GetCountryById :one
SELECT * FROM countries
WHERE id = $1;



-- name: UpdateBannerOrder :one
UPDATE banner_order
SET 
	plan_packages=$2, 
	note=$3,
	total_price=$4,
	start_date=$5, 
	end_date=$6, 
	updated_by=$7, 
	updated_at=$8 
WHERE 
	id=$1
RETURNING id;


-- name: GetCountAllBannerOrder :one
SELECT COUNT(*) AS count
FROM
    banner_order
    INNER JOIN companies ON companies.id = banner_order.company_id
WHERE
    banner_order.status = ANY(@active_status::BIGINT[]);
    
-- name: UpdateBannerOrderPlanPackageBannersQuantity :one
WITH updated AS (
  UPDATE banner_order
  SET plan_packages = (
    SELECT jsonb_agg(
      CASE
        WHEN pkg->>'plan_package_id' = $2::text THEN
          jsonb_set(
            pkg,
            '{number_of_banners}',
            to_jsonb(GREATEST((pkg->>'number_of_banners')::int - 1, 0))
          )
        ELSE pkg
      END
    )
    FROM jsonb_array_elements(plan_packages) AS pkg
  )
  WHERE company_id = $1
    AND jsonb_path_exists(
      plan_packages,
      '$[*] ? (@.plan_package_id == $target_id)',
      jsonb_build_object('target_id', $2::bigint)
    )
    AND jsonb_path_exists(
      plan_packages,
      '$[*] ? (@.plan_package_cost_id == $target_id)',
      jsonb_build_object('target_id', $3::bigint)
    )
  RETURNING plan_packages
)
SELECT (elem->>'original_counts_per_banner')::BIGINT AS pkg
FROM updated,
     jsonb_array_elements(plan_packages) AS elem;


-- name: GetBannerPlanPkgByID :one 
SELECT * from banner_plan_package bp
inner join banner_plan_cost bc on bc.plan_package_id = bp.id
where bp.id = $1;

-- name: GetBannersDetail :one 
SELECT * from banners b
INNER JOIN banner_order bo on bo.id = b.banner_order_id
INNER JOIN banner_plan_package bp ON bp.id = b.plan_package_id
INNER JOIN companies ON companies.id=bo.company_id
where b.id = $1;



-- name: GetBannerOrderDetailsForUpdate :one 
SELECt company_id,company_type,country_id,plan_packages,note,start_date,end_date,total_price
FROM 
	banner_order
WHERE 
	id=$1 AND status= @unpaid_status::BIGINT;


-- name: GetBannersOrderPlanPkgs :many 
SELECT bp.*, bo.id as banner_order_id, bo.plan_packages
FROM banner_order bo
JOIN LATERAL jsonb_array_elements(bo.plan_packages) AS plan_package ON true
JOIN banner_plan_package bp ON bp.id = (plan_package->>'plan_package_id')::INTEGER
JOIN banner_plan_cost bc ON bc.id = (plan_package->>'plan_package_cost_id')::INTEGER
JOIN companies ON companies.id = bo.company_id
WHERE bo.id = $1;

-- name: GetConsumedPlanPkgs :many 
SELECT DISTINCT bp.*, bo.id as banner_order_id, bo.plan_packages from banners b
INNER JOIN banner_order bo on bo.id = b.banner_order_id
INNER JOIN banner_plan_package bp on bp.id = b.plan_package_id
INNER JOIN banner_plan_cost bc ON bc.id = b.banner_cost_id
WHERE bo.id = $1 and b.status = $2;
