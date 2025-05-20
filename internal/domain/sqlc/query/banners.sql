-- name: CreateBanner :one
INSERT INTO "banners" (
    "company_id",
    "banner_name",
    "target_url",
    "plan_package_id",
    "duration",
    "banner_direction",
    "banner_position",
    "media_type",
    "file_url",
    "description",
    "created_by",
    "updated_by",
    "created_at",
    "updated_at",
    "status",
    "banner_order_id",
    "banner_cost_id",
    "no_of_impressions"
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8,
    $9, $10, $11, $12, $13, $14, $15, $16, $17,$18
)
RETURNING *;



-- name: GetBanner :one
SELECT * FROM "banners"
WHERE "id" = $1;

-- name: GetBannerOrderByCompanyIDAndPlanID :one
SELECT *
FROM banner_order
WHERE company_id = $1
  AND jsonb_path_exists(
    plan_packages,
    '$[*] ? (@.plan_package_id == $target_id && @.plan_package_cost_id == $target_id2 )',
    jsonb_build_object('target_id', $2::bigint, 'target_id2', $3::bigint)
  )  AND id = $4;


-- name: ListBannersCount :one
SELECT count(*) FROM "banners" where status=ANY(@statuses::BIGINT[]);

-- name: GetBannersDetails :one
SELECT * FROM "banners" as b
INNER JOIN "banner_order" as bo ON bo.id = b.banner_order_id
INNER JOIN "banner_plan_package" bp ON bp.id = b.plan_package_id
WHERE b.id = $1;

-- name: ListBanners :many
SELECT banners.*, companies.company_name, bp.plan_type
FROM banners
LEFT JOIN companies on companies.id = banners.company_id
INNER JOIN banner_plan_package bp ON bp.id = banners.plan_package_id
WHERE banners.status = ANY(@statuses::BIGINT[])
ORDER BY "created_at" DESC
LIMIT $1 OFFSET $2;

-- name: UpdateBanner :exec
UPDATE "banners"
SET
    "company_id" = $2,
    "banner_name" = $3,
    "target_url" = $4,
    "plan_package_id" = $5,
    "duration" = $6,
    "banner_direction" = $7,
    "banner_position" = $8,
    "media_type" = $9,
    "file_url" = $10,
    "description" = $11,
    "created_by" = $12,
    "updated_by" = $13,
    "created_at" = $14,
    "updated_at" = $15,
    "status" = $16
WHERE "id" = $1;

-- name: UpdateBannerStatus :exec
UPDATE "banners"
SET
    "updated_by" = $2,
    "updated_at" = $3,
    "status" = $4
WHERE "id" = $1;



-- name: DeleteBanner :exec
DELETE FROM "banners"
WHERE "id" = $1;



-- name: GetBannerOrderPlanPackages :many
SELECT banner_order.id,plan_packages
FROM	
	banner_order 
INNER JOIN companies ON companies.id=banner_order.company_id 
INNER JOIN addresses ON addresses.id=companies.addresses_id
WHERE 
	banner_order.company_id= @company_id::BIGINT AND banner_order.status= @status::BIGINT AND banner_order.country_id=addresses.countries_id;




-- name: VerifyBanner :one
UPDATE banners
SET 
  banner_name= COALESCE(sqlc.narg('banner_name'),banner_name), 
  target_url= COALESCE(sqlc.narg('target_url'),target_url), 
  banner_direction= COALESCE(sqlc.narg('banner_direction'),banner_direction), 
  banner_position = COALESCE(sqlc.narg('banner_position'),banner_position), 
  media_type= COALESCE(sqlc.narg('media_type'),media_type), 
  file_url = COALESCE(sqlc.narg('file_url'),file_url), 
  description= COALESCE(sqlc.narg('description'),description),
	status= @status::BIGINT 
WHERE 
	id=$1
RETURNING banner_order_id,plan_package_id,banner_cost_id;

-- name: GetPlanPackages :many
SELECT id,plan_package_name
FROM
	banner_plan_package 
WHERE 
	id=ANY(@plan_package_ids::BIGINT[]);



-- name: GetPlanPackagePlanType :one 
SELECT plan_type FROM banner_plan_package WHERE id=$1; 

-- name: UpdateBannerPlanPackages :exec 
UPDATE 
  banner_order
SET 
  plan_packages=$2 
WHERE 
  id=$1; 


-- name: GetApprovedBannerIDs :many
SELECT id FROM banners WHERE status=3;



-- name: UpdateBannerNumberOfImpressions :one
UPDATE 
	banners 
SET 
	no_of_impressions= no_of_impressions - $2
WHERE 
	id=$1
RETURNING 1; 



-- name: GetBannerOrderPlanPackagesByID :one 
SELECT plan_packages 
FROM 
  banner_order 
WHERE 
    id=$1; 