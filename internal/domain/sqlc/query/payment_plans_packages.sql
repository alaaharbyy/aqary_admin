-- name: GetPaymentPlanPackages :many
WITH paymentPlanIds as(
	SELECT 
	pkg.id as pkgId, pkg.no_of_plans as no_of_plans, UNNEST(pkg.payment_plans_id)  as paymentplan_id
	FROM payment_plans_packages pkg
	WHERE pkg.entity_id= @entity_id::bigint AND pkg.entity_type_id= @entity_type::bigint AND pkg.is_enabled=TRUE
)
SELECT 
plids.pkgId as payment_plans_packages_id,
plids.no_of_plans as no_of_plans,
sqlc.embed(pl),
sqlc.embed(pstl)
 
FROM payment_plans pl
JOIN paymentPlanIds plids ON pl.id=plids.paymentplan_id
JOIN plan_installments pstl ON pstl.payment_plans=pl.id;


-- -- name: DeletePaymentPlansPackage :exec
-- DELETE FROM payment_plans_packages
-- Where id = $1;

-- -- -- name: DeletePaymentPlansOption :exec
-- -- DELETE FROM payment_plans_packages
-- -- Where property = $1 AND properties_id = $2 AND option_no = $3;


-- -- -- name: GetPaymentPlanPackageDateByPropertyAndPropertyId :many
-- -- SELECT date FROM payment_plans_packages
-- -- WHERE payment_plans_packages.property = $1 AND payment_plans_packages.properties_id = $2 AND option_no = $3 ORDER BY id;


 



-- -- -- name: GetCustomValidateOption :many
-- -- (SELECT *
-- --  FROM public.payment_plans_packages
-- --  WHERE payment_plans_packages.properties_id = $1 AND payment_plans_packages.property = $2 AND payment_plans_packages.option_no = $3
-- --  ORDER BY id DESC
-- --  LIMIT 1)
-- -- UNION ALL
-- -- (SELECT *
-- --  FROM public.payment_plans_packages
-- --  WHERE payment_plans_packages.properties_id = $1 AND payment_plans_packages.property = $2 AND payment_plans_packages.option_no = $4
-- --  ORDER BY id
-- --  )
-- --  UNION ALL
-- -- (SELECT *
-- --  FROM public.payment_plans_packages
-- --  WHERE payment_plans_packages.properties_id = $1 AND payment_plans_packages.property = $2 AND payment_plans_packages.option_no = $5
-- --  ORDER BY id
-- --  LIMIT 1);

-- -- name: UpdateOptionStatus :many
-- UPDATE payment_plans_packages SET status = $7
-- WHERE property = $1 AND properties_id = $2 and option_no = $3 AND from_which_section = $4 AND is_branch = $5 AND is_property = $6 AND status != 6 RETURNING *;

-- -- name: UpdateOptionStatusDelete :many
-- UPDATE payment_plans_packages SET status = $7
-- WHERE property = $1 AND properties_id = $2 and option_no = $3 AND from_which_section = $4 AND is_branch = $5 AND is_property = $6 RETURNING *;


-- -- name: CreatePaymentPlansPackage :one
-- INSERT INTO payment_plans_packages (
--     properties_id,
--     property,
--     option_no,
--     percentage,
--     date,
--     milestone,
--     status,
--     created_at,
--     updated_at,
--     is_property,
--     is_branch,
--     from_which_section
-- ) VALUES (
--     $1,
--     $2,
--     $3,
--     $4,
--     $5,
--     $6,
--     $7,
--     $8,
--     $9,
--     $10,
--     $11,
--     $12
-- ) RETURNING *;

-- -- name: GetPaymentPlansPackage :one
-- SELECT * FROM payment_plans_packages
-- WHERE id = $1 AND status != 6 LIMIT 1;

-- -- name: GetAllPaymentPlansPackage :many
-- SELECT * FROM payment_plans_packages WHERE status != 6
-- ORDER BY id
-- LIMIT $1
-- OFFSET $2;

-- -- name: UpdatePaymentPlansPackage :one
-- UPDATE payment_plans_packages
-- SET
--     properties_id = $2,
--     property = $3,
--     option_no = $4,
--     percentage = $5,
--     date = $6,
--     milestone = $7,
--     updated_at = $8,
--     is_property = $9,
--     is_branch = $10,
--     from_which_section = $11
-- WHERE
--     id = $1
--     AND status != 6
-- RETURNING *;

-- -- name: GetPaymentPlanPackageByPropertyAndPropertyId :many
-- SELECT id, properties_id, property, option_no, percentage, date, milestone, status, created_at, updated_at FROM payment_plans_packages
-- WHERE property = $1 AND properties_id = $2 AND from_which_section = $3 AND is_branch = $4 AND is_property = $5 AND status != 6 ORDER BY (option_no, id);

-- -- name: GetPaymentPlanPackageByPropertyAndPropertyIdForUnits :many
-- SELECT ppp.id, ppp.properties_id, ppp.property, ppp.option_no, ppp.percentage, ppp.date, ppp.milestone, ppp.status, ppp.created_at, ppp.updated_at, upp.payment_plans_id, upp.unit_id, upp.is_enabled, upp.updated_at FROM payment_plans_packages ppp JOIN unit_payment_plans upp on upp.payment_plans_id = ppp.id AND upp.unit_id = $6
-- WHERE ppp.property = $1 AND ppp.properties_id = $2 AND ppp.from_which_section = $3 AND ppp.is_branch = $4 AND ppp.is_property = $5 AND ppp.status != 6 AND ppp.status != 5 ORDER BY (ppp.option_no, ppp.id);

-- -- -- name: GetPaymentPlanPackageDateByPropertyAndPropertyId :many
-- -- SELECT date FROM payment_plans_packages
-- -- WHERE payment_plans_packages.property = $1 AND payment_plans_packages.properties_id = $2 AND option_no = $3 AND status NOT IN (5, 6) ORDER BY id;

 
-- -- -- name: GetCustomValidateOption :many
-- -- (SELECT *
-- --  FROM public.payment_plans_packages
-- --  WHERE payment_plans_packages.properties_id = $1 AND payment_plans_packages.property = $2 AND payment_plans_packages.option_no = $3 AND status NOT IN (5, 6)
-- --  ORDER BY id DESC
-- --  LIMIT 1)
-- -- UNION ALL
-- -- (SELECT *
-- --  FROM public.payment_plans_packages
-- --  WHERE payment_plans_packages.properties_id = $1 AND payment_plans_packages.property = $2 AND payment_plans_packages.option_no = $4 AND status NOT IN (5, 6)
-- --  ORDER BY id
-- --  )
-- --  UNION ALL
-- -- (SELECT *
-- --  FROM public.payment_plans_packages
-- --  WHERE payment_plans_packages.properties_id = $1 AND payment_plans_packages.property = $2 AND payment_plans_packages.option_no = $5 AND status NOT IN (5, 6)
-- --  ORDER BY id
-- --  LIMIT 1);

-- -- name: UpdateInstallmentStatus :one
-- UPDATE payment_plans_packages SET status = $1
-- WHERE id = $2 RETURNING *;


-- -- name: GetPaymentPlansPackageWithStatus :one
-- SELECT * FROM payment_plans_packages
-- WHERE id = $1  LIMIT 1;

-- -- name: GetPaymentPlanPackageDateByPropertyAndPropertyId :many
-- SELECT date FROM payment_plans_packages
-- WHERE payment_plans_packages.property = $1 AND payment_plans_packages.properties_id = $2 AND option_no = $3 AND status != 6 ORDER BY id;


-- -- name: GetPaymentPlanPackageByPropertyAndPropertyIdAndOptionNo :many
-- SELECT id, properties_id, property, option_no, percentage, date, milestone, status, created_at, updated_at FROM payment_plans_packages
-- WHERE property = $1 AND properties_id = $2 AND from_which_section = $3 AND is_branch = $4 AND is_property = $5 AND option_no = $6 AND status != 6 ORDER BY (option_no, id);

-- -- name: GetCustomValidateOption :many
-- (SELECT *
--  FROM public.payment_plans_packages
--  WHERE payment_plans_packages.properties_id = $1 AND payment_plans_packages.property = $2 AND payment_plans_packages.option_no = $3 AND status != 6
--  ORDER BY id DESC
--  LIMIT 1)
-- UNION ALL
-- (SELECT *
--  FROM public.payment_plans_packages
--  WHERE payment_plans_packages.properties_id = $1 AND payment_plans_packages.property = $2 AND payment_plans_packages.option_no = $4 AND status != 6
--  ORDER BY id
--  )
--  UNION ALL
-- (SELECT *
--  FROM public.payment_plans_packages
--  WHERE payment_plans_packages.properties_id = $1 AND payment_plans_packages.property = $2 AND payment_plans_packages.option_no = $5 AND status != 6
--  ORDER BY id
--  LIMIT 1);


-- -- name: GetLastInstallmentDateAndOption :one
-- select id, option_no, date from payment_plans_packages where properties_id = $1 and property = $2 AND from_which_section = $3 AND is_branch = $4 AND is_property = $5 AND status != 6 order by id desc limit 1;

-- -- name: GetSingleProjectPropertyOrUnitDetails :one
-- with x as (
--     -- units
-- 	SELECT u.id, u.ref_no, u.updated_at as "last_updated", u.property_name, u.type_name_id, '' as "unit_type", 'project' as "from" , false as "is_property", u.unit_no, 0 as "plot_area",  0 as "built_up_area", x.status, 'sale' as "category", u.properties_id, u.property, u.addresses_id, CASE WHEN u.owner_users_id is NULL THEN 0 ELSE u.owner_users_id END as "users_id", FALSE AS "is_branch", 0 as "price", '' as "community", 0 as "min_area", 0 as "max_area", pp.ref_no as "parent_property"  FROM sale_unit x INNER JOIN units u ON u.id = x.unit_id JOIN project_properties pp on u.properties_id = pp.id and u.property = 1
-- WHERE u.property = 1 AND x.status != 5 AND x.status != 6 AND u.ref_no = $1
-- 	UNION
-- 	SELECT u.id, u.ref_no, u.updated_at as "last_updated", u.property_name, u.type_name_id, '' as "unit_type", 'project' as "from", false as "is_property", u.unit_no, 0 as "plot_area",  0 as "built_up_area", x.status, 'sale' as "category", u.properties_id, u.property, u.addresses_id, CASE WHEN u.owner_users_id is NULL THEN 0 ELSE u.owner_users_id END as "users_id", FALSE AS "is_branch", 0 as "price", '' as "community", 0 as "min_area", 0 as "max_area", pp.ref_no as "parent_property"   FROM rent_unit x INNER JOIN units u ON u.id = x.unit_id JOIN project_properties pp on u.properties_id = pp.id and u.property = 1
-- WHERE u.property = 1 AND x.status != 5 AND x.status != 6 AND u.ref_no = $1
-- UNION
-- SELECT fp.id, fp.ref_no, fp.updated_at as "last_updated", fp.property_name, 0 as "type_name_id", '' as "unit_type", 'project' AS "from", true as "is_property", ' - ' as "unit_no", pf.plot_area, pf.built_up_area, fp.status, '' as category,  fp.id as "properties_id", 1 as property,
-- fp.addresses_id, fp.users_id, FALSE AS "is_branch", pf.price, c.community, pf.min_area, pf.max_area, fp.ref_no as "parent_property" FROM project_properties fp
-- LEFT JOIN properties_facts pf ON pf.properties_id = fp.id JOIN addresses a ON fp.addresses_id = a.id JOIN communities c ON a.communities_id = c.id WHERE fp.ref_no = $1
-- ) Select * FROM x  WHERE status != 6 LIMIT 1;

-- -- name: CreateUnitPaymentPlan :one
-- INSERT INTO unit_payment_plans (unit_id, payment_plans_id, is_enabled, created_at, updated_at)
-- VALUES ($1, $2, $3, $4, $5)
-- RETURNING *;

-- -- name: UpdateUnitPaymentPlanStatusIsEnabled :one
-- update unit_payment_plans set is_enabled = $4, updated_at = $5 where payment_plans_id in (select id from payment_plans_packages where property = $1 and properties_id = $2 and status != 5 and status != 6 and option_no = $3) and unit_payment_plans.unit_id = $6 RETURNING *;

-- -- name: UpdateUnitPaymentPlanStatus :one
-- UPDATE unit_payment_plans
-- SET is_enabled = $1, updated_at = $2
-- WHERE unit_id = $3 AND payment_plans_id = $4 RETURNING *;

-- -- name: GetAllPaymentPlanStatusByUnitId :many
-- SELECT 
--     id,
--     unit_id,
--     payment_plans_id,
--     is_enabled,
--     created_at,
--     updated_at
-- FROM 
--     unit_payment_plans upp
-- WHERE 
--     unit_id = $1;


-- -- name: GetPropertyChildUnitsIDs :many
-- with x as (
--     -- units
-- 	SELECT u.id FROM sale_unit x INNER JOIN units u ON u.id = x.unit_id JOIN project_properties pp on u.properties_id = pp.id and u.property = 1
-- WHERE u.property = 1 AND x.status != 5 AND x.status != 6 AND pp.ref_no = $1
-- 	UNION
-- 	SELECT u.id FROM rent_unit x INNER JOIN units u ON u.id = x.unit_id JOIN project_properties pp on u.properties_id = pp.id and u.property = 1
-- WHERE u.property = 1 AND x.status != 5 AND x.status != 6 AND pp.ref_no = $1
-- ) Select * FROM x;

-- -- name: GetPaymentPlanPackageIdsByPropertyAndPropertyId :many
-- SELECT id FROM payment_plans_packages
-- WHERE property = $1 AND properties_id = $2 AND from_which_section = $3 AND is_branch = $4 AND is_property = $5 AND status != 6 ORDER BY (option_no, id);