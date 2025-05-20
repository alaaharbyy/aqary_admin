-- name: CreatePlanInstallment :one
INSERT INTO plan_installments (payment_plans, percentage, date, milestone)
VALUES ($1, $2, $3, $4)
RETURNING *;
    
-- name: GetPlanInstallments :many    
SELECT * FROM plan_installments;

-- name: GetPlanInstallmentByID :one    
SELECT * FROM plan_installments
WHERE id = $1;

-- name: GetPlanInstallmentByPaymentPlanID :many    
SELECT * FROM plan_installments
WHERE payment_plans = $1;

-- name: GetAllPlanInstallmentIDsByPaymentPlansID :one
SELECT ARRAY(
    SELECT id FROM plan_installments
    WHERE payment_plans = $1
)::bigint[] AS ids;


-- name: UpdatePlanInstallmentByID :one   
UPDATE plan_installments
SET payment_plans= $1,
    percentage = $2, 
    milestone = $3,
    date = $4
WHERE id = $5
RETURNING *;

-- name: DeletePlanInstallmentByID :exec
DELETE FROM plan_installments
WHERE id = $1;

-- name: DeleteAllPlanInstallmentsByIDs :exec
DELETE FROM plan_installments
WHERE id = ANY($1::bigint[]);


-- name: CreatePaymentPlan :one
INSERT INTO payment_plans (reference_no, payment_plan_title, no_of_installments, is_enabled)
VALUES ($1, $2, $3, $4)
RETURNING *;
    
-- name: GetPaymentPlan :many    
SELECT * FROM payment_plans;

-- name: GetPaymentPlanByID :one    
SELECT * FROM payment_plans
WHERE id = $1;

-- name: UpdatePaymentPlanByID :one   
UPDATE payment_plans
SET payment_plan_title= $1,
    no_of_installments = $2
WHERE id = $3
RETURNING *;

-- name: DeletePaymentPlanByID :exec
DELETE FROM payment_plans
WHERE id = $1;

-- name: CreatePaymentPlanPackages :one
INSERT INTO payment_plans_packages (no_of_plans, entity_type_id, entity_id, payment_plans_id, created_at, updated_at)
VALUES ($1, $2, $3, $4, NOW(), NOW()) RETURNING *;

-- name: GetAllPaymentPlanPackages :many
SELECT * FROM payment_plans_packages;

-- name: GetPaymentPlanPackagesByID :one
SELECT * FROM payment_plans_packages
WHERE id = $1;

-- name: GetPaymentPlanPackagesByEntityID :one
SELECT * FROM payment_plans_packages
WHERE entity_id = $1  AND entity_type_id= $2;

-- name: GetCountPaymentPlanPackagesByEntityID :one
SELECT count(*) FROM payment_plans_packages
WHERE entity_id = $1 AND entity_type_id= $2;


-- name: GetPaymentPlanPackagesByEntityType :one
SELECT * FROM payment_plans_packages
WHERE entity_type_id = $1;

-- name: GetCountPaymentPlanPackagesByEntityType :one
SELECT count(*) FROM payment_plans_packages
WHERE entity_type_id = $1;

-- name: UpdatePaymentPlanPackagesByID :one
UPDATE payment_plans_packages
SET no_of_plans= $1,
    entity_type_id = $2,
    entity_id = $3,
    payment_plans_id = $4,
    updated_at = $5
WHERE id = $6
RETURNING *;

-- name: DeletePaymentPlanPackagesByID :exec
DELETE FROM payment_plans_packages
WHERE id = $1; 

-- name: GetPaymentPlanInstallmentByPropertyVersionsID :many
SELECT pi.*,pp.is_enabled, pp.payment_plan_title
FROM payment_plans_packages p
INNER JOIN payment_plans pp ON pp.id = ANY (p.payment_plans_id)
INNER JOIN plan_installments pi ON pi.payment_plans = pp.id
WHERE p.entity_type_id = $2 and entity_id=$1;


-- name: GetPaymentPlanInstallmentByID :many
SELECT DISTINCT pi.*, pp.is_enabled, pp.payment_plan_title
FROM payment_plans_packages p
INNER JOIN payment_plans pp ON pp.id = ANY (p.payment_plans_id)
LEFT JOIN plan_installments pi ON pi.payment_plans = pp.id
WHERE pp.id = $1;

-- name: GetCountPaymentPlanInstallmentByPropertyVersionsID :one
SELECT count(pi.*)
FROM payment_plans_packages p
INNER JOIN payment_plans pp ON pp.id = ANY (p.payment_plans_id)
LEFT JOIN plan_installments pi ON pi.payment_plans = pp.id
WHERE p.entity_type_id = 3 and entity_id=$1;

-- name: UpdateEnablePaymentPlanPackagesByID :one
UPDATE payment_plans
SET is_enabled = $1
WHERE id = $2
RETURNING *;

-- name: GetAllGlobalPropertyByEntity :one
select * from property where entity_id = $1 and entity_type_id = $2; 


-- name: GetAllGlobalPropertyById :one
select * from property where id = $1;