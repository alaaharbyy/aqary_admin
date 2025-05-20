

-- -- name: GetPaymentPlansForUnit :many
-- WITH PlanOptions AS
--   (SELECT ppp.option_no,
--           array_agg(ppp.id
--                     ORDER BY ppp.id) AS plan_ids
--    FROM unit_payment_plans upp
--    JOIN payment_plans_packages ppp ON ppp.id=upp.payment_plans_id
--    WHERE upp.unit_id=$1
--    GROUP BY ppp.option_no)
-- SELECT po.option_no,
--        json_agg(json_build_object('id', p.id, 'milestone', p.milestone, 'percentage', p.percentage)) AS plan_details
-- FROM PlanOptions po
-- JOIN payment_plans_packages p ON p.id = ANY(po.plan_ids)
-- GROUP BY po.option_no
-- ORDER BY po.option_no;

