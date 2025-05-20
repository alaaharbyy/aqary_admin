-- name: CreateProjectActivitiesHistory :one
INSERT INTO project_activities_history (
    title,
    module_name,
    field_value,
    created_by,
    activity_date
)VALUES (
    $1, $2, $3, $4, $5
)RETURNING *;

-- name: GetAllProjectActivitiesHistory :many
SELECT COUNT(project_activities_history.id) OVER() AS total_count,
project_activities_history.id,
title,
activity_date,
module_name,
(profiles.first_name ||' '|| profiles.last_name)::VARCHAR AS user, 
field_value
FROM project_activities_history
INNER JOIN users ON users.id = project_activities_history.created_by
INNER JOIN profiles ON profiles.users_id = users.id
ORDER BY id DESC
LIMIT $1 OFFSET $2;

-- -- name: GetAllProjectActivities :many
-- WITH X AS(
-- --Agricultural Property
 
-- SELECT 	proj_act.id  , proj_act.unit_category AS category, pro.project_name AS project_title, agr_free_prop.property_name , proj_act.activity , users.username , proj_act.file_url AS file_name,proj_act.portal_url AS portal_name
-- FROM project_activities AS proj_act
-- INNER JOIN agricultural_freelancer_properties AS agr_free_prop
-- ON proj_act.is_property = true AND proj_act.is_property_branch = false AND proj_act.unit_category = 'Agricultural Freelancer' AND proj_act.property_unit_id = agr_free_prop.id
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id = pro.id
-- INNER JOIN users 
-- ON proj_act.user_id =  users.id
-- WHERE proj_act.activity_type=$1
 
-- UNION ALL
 
 
-- SELECT 	proj_act.id  , proj_act.activity_date , proj_act.unit_category AS category, pro.project_name AS project_title, agr_ow_prop.property_name , proj_act.activity , users.username , proj_act.file_url AS file_name,proj_act.portal_url AS portal_name
-- FROM project_activities AS proj_act
-- INNER JOIN agricultural_owner_properties AS agr_ow_prop
-- ON proj_act.is_property = true AND proj_act.is_property_branch = false AND proj_act.unit_category = 'Agricultural Owner' AND proj_act.property_unit_id = agr_ow_prop.id
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id = pro.id
-- INNER JOIN users 
-- ON proj_act.user_id =  users.id 
-- WHERE proj_act.activity_type=$1
 
-- UNION ALL
 
 
-- SELECT 	proj_act.id  , proj_act.activity_date , proj_act.unit_category AS category, pro.project_name AS project_title, agr_bro_agen_prop.property_name , proj_act.activity , users.username , proj_act.file_url AS file_name,proj_act.portal_url AS portal_name
-- FROM project_activities AS proj_act
-- INNER JOIN agricultural_broker_agent_properties AS agr_bro_agen_prop
-- ON proj_act.is_property = true AND proj_act.is_property_branch = false AND proj_act.unit_category = 'Agricultural Broker' AND proj_act.property_unit_id = agr_bro_agen_prop.id
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id = pro.id
-- INNER JOIN users 
-- ON proj_act.user_id =  users.id 
-- WHERE proj_act.activity_type=$1
 
 
 
-- UNION ALL
 
 
-- SELECT 	proj_act.id  , proj_act.activity_date , proj_act.unit_category AS category, pro.project_name AS project_title, agr_bro_agen_prop_b.property_name , proj_act.activity , users.username , proj_act.file_url AS file_name,proj_act.portal_url AS portal_name
-- FROM project_activities AS proj_act
-- INNER JOIN agricultural_broker_agent_properties_branch AS agr_bro_agen_prop_b
-- ON proj_act.is_property = true AND proj_act.is_property_branch = true AND proj_act.unit_category = 'Agricultural Broker' AND proj_act.property_unit_id = agr_bro_agen_prop_b.id
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id = pro.id
-- INNER JOIN users 
-- ON proj_act.user_id =  users.id 
-- WHERE proj_act.activity_type=$1
 
 
-- UNION ALL
 
 
-- -- Industrial Properties
 
 
-- SELECT proj_act.id  , proj_act.activity_date , proj_act.unit_category AS category, pro.project_name AS project_title, ind_free_prop.property_name , proj_act.activity , users.username , proj_act.file_url AS file_name,proj_act.portal_url AS portal_name
-- FROM project_activities AS proj_act
-- INNER JOIN industrial_freelancer_properties AS ind_free_prop
-- ON proj_act.is_property = true AND proj_act.is_property_branch = false AND proj_act.unit_category = 'Industrial Freelancer' AND proj_act.property_unit_id = ind_free_prop.id
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id = pro.id
-- INNER JOIN users 
-- ON proj_act.user_id =  users.id 
-- WHERE proj_act.activity_type=$1
 
 
 
-- UNION ALL
 
 
-- SELECT 	 proj_act.id  , proj_act.activity_date , proj_act.unit_category AS category, pro.project_name AS project_title, ind_ow_prop.property_name , proj_act.activity , users.username , proj_act.file_url AS file_name,proj_act.portal_url AS portal_name
-- FROM project_activities AS proj_act
-- INNER JOIN industrial_owner_properties AS ind_ow_prop
-- ON proj_act.is_property = true AND proj_act.is_property_branch = false AND proj_act.unit_category = 'Industrial Owner' AND proj_act.property_unit_id = ind_ow_prop.id
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id = pro.id
-- INNER JOIN users 
-- ON proj_act.user_id =  users.id 
-- WHERE proj_act.activity_type=$1
 
 
 
-- UNION ALL
 
 
-- SELECT 	 proj_act.id  , proj_act.activity_date , proj_act.unit_category AS category, pro.project_name AS project_title, ind_bro_agen_prop.property_name , proj_act.activity , users.username , proj_act.file_url AS file_name,proj_act.portal_url AS portal_name
-- FROM project_activities AS proj_act
-- INNER JOIN industrial_broker_agent_properties AS ind_bro_agen_prop
-- ON proj_act.is_property = true AND proj_act.is_property_branch = false AND proj_act.unit_category = 'Industrial Broker' AND proj_act.property_unit_id = ind_bro_agen_prop.id
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id = pro.id
-- INNER JOIN users 
-- ON proj_act.user_id =  users.id 
-- WHERE proj_act.activity_type=$1
 
 
 
-- UNION ALL
 
 
-- SELECT proj_act.id  , proj_act.activity_date , proj_act.unit_category AS category, pro.project_name AS project_title, ind_bro_agen_prop_b.property_name , proj_act.activity , users.username , proj_act.file_url AS file_name,proj_act.portal_url AS portal_name
-- FROM project_activities AS proj_act
-- INNER JOIN industrial_broker_agent_properties_branch AS ind_bro_agen_prop_b
-- ON proj_act.is_property = true AND proj_act.is_property_branch = true AND proj_act.unit_category = 'Industrial Broker' AND proj_act.property_unit_id = ind_bro_agen_prop_b.id
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id = pro.id
-- INNER JOIN users 
-- ON proj_act.user_id =  users.id 
-- WHERE proj_act.activity_type=$1
 
 
-- UNION ALL 
-- -- Property Hub  Properties
 
 
-- SELECT proj_act.id  , proj_act.activity_date , proj_act.unit_category AS category, pro.project_name AS project_title, free_prop.property_name , proj_act.activity , users.username , proj_act.file_url AS file_name,proj_act.portal_url AS portal_name
-- FROM project_activities AS proj_act
-- INNER JOIN freelancers_properties AS free_prop
-- ON proj_act.is_property = true AND proj_act.is_property_branch = false AND proj_act.unit_category = 'Property Hub Freelancer' AND proj_act.property_unit_id = free_prop.id
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id = pro.id
-- INNER JOIN users 
-- ON proj_act.user_id =  users.id 
-- WHERE proj_act.activity_type=$1
 
 
 
-- UNION ALL
 
 
-- SELECT 	proj_act.id  , proj_act.activity_date , proj_act.unit_category AS category, pro.project_name AS project_title, ow_prop.property_name , proj_act.activity , users.username , proj_act.file_url AS file_name,proj_act.portal_url AS portal_name
-- FROM project_activities AS proj_act
-- INNER JOIN owner_properties AS ow_prop
-- ON proj_act.is_property = true AND proj_act.is_property_branch = false AND proj_act.unit_category = 'Property Hub Owner' AND proj_act.property_unit_id = ow_prop.id
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id = pro.id
-- INNER JOIN users 
-- ON proj_act.user_id =  users.id 
-- WHERE proj_act.activity_type=$1
 
 
-- UNION ALL
 
 
-- SELECT 	proj_act.id  , proj_act.activity_date , proj_act.unit_category AS category, pro.project_name AS project_title, brok_comp_ag_prop.property_name , proj_act.activity , users.username , proj_act.file_url AS file_name,proj_act.portal_url AS portal_name
-- FROM project_activities AS proj_act
-- INNER JOIN broker_company_agent_properties AS brok_comp_ag_prop
-- ON proj_act.is_property = true AND proj_act.is_property_branch = false AND proj_act.unit_category = 'Property Hub Broker' AND proj_act.property_unit_id = brok_comp_ag_prop.id
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id = pro.id
-- INNER JOIN users 
-- ON proj_act.user_id =  users.id 
-- WHERE proj_act.activity_type=$1
 
 
-- UNION ALL
 
 
-- SELECT 	proj_act.id  , proj_act.activity_date , proj_act.unit_category AS category, pro.project_name AS project_title, brok_comp_ag_prop_b.property_name , proj_act.activity , users.username , proj_act.file_url AS file_name,proj_act.portal_url AS portal_name
-- FROM project_activities AS proj_act
-- INNER JOIN broker_company_agent_properties_branch AS brok_comp_ag_prop_b
-- ON proj_act.is_property = true AND proj_act.is_property_branch = true AND proj_act.unit_category = 'Property Hub Broker' AND proj_act.property_unit_id = brok_comp_ag_prop_b.id
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id = pro.id
-- INNER JOIN users 
-- ON proj_act.user_id =  users.id 
-- WHERE proj_act.activity_type=$1
 
 
-- -- --  Not property
 
 
-- UNION ALL
 
 
-- SELECT 	proj_act.id  , proj_act.activity_date , proj_act.unit_category AS category, pro.project_name AS project_title, ren_prop_uni.property_name , proj_act.activity , users.username , proj_act.file_url AS file_name,proj_act.portal_url AS portal_name
-- FROM project_activities AS proj_act
-- INNER JOIN rent_property_units AS ren_prop_uni
-- ON proj_act.is_property = false AND proj_act.is_property_branch = false AND proj_act.unit_category = 'Rent' AND proj_act.property_unit_id = ren_prop_uni.id
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id = pro.id
-- INNER JOIN users 
-- ON proj_act.user_id =  users.id 
-- WHERE proj_act.activity_type=$1
 
 
-- UNION ALL
 
 
-- SELECT proj_act.id  , proj_act.activity_date , proj_act.unit_category AS category, pro.project_name AS project_title, sal_prop_uni.property_name , proj_act.activity , users.username , proj_act.file_url AS file_name,proj_act.portal_url AS portal_name
-- FROM project_activities AS proj_act
-- INNER JOIN sale_property_units AS sal_prop_uni
-- ON proj_act.is_property = false AND proj_act.is_property_branch = false AND proj_act.unit_category = 'Sale' AND proj_act.property_unit_id = sal_prop_uni.id
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id = pro.id
-- INNER JOIN users 
-- ON proj_act.user_id =  users.id 
-- WHERE proj_act.activity_type=$1
 
 
-- UNION ALL
 
 

 
 
 
-- --  Not property branch
 
-- UNION ALL
 
 
-- SELECT 	proj_act.id  , proj_act.activity_date , proj_act.unit_category AS category, pro.project_name AS project_title, ren_prop_uni_b.property_name , proj_act.activity , users.username , proj_act.file_url AS file_name,proj_act.portal_url AS portal_name
-- FROM project_activities AS proj_act
-- INNER JOIN rent_property_units_branch AS ren_prop_uni_b
-- ON proj_act.is_property = false AND proj_act.is_property_branch = true AND proj_act.unit_category = 'Rent' AND proj_act.property_unit_id = ren_prop_uni_b.id
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id = pro.id
-- INNER JOIN users 
-- ON proj_act.user_id =  users.id 
-- WHERE proj_act.activity_type=$1
 
 
-- UNION ALL
 
 
-- SELECT 	proj_act.id  , proj_act.activity_date , proj_act.unit_category AS category, pro.project_name AS project_title, sal_prop_uni_b.property_name , proj_act.activity , users.username , proj_act.file_url AS file_name,proj_act.portal_url AS portal_name
-- FROM project_activities AS proj_act
-- INNER JOIN sale_property_units_branch AS sal_prop_uni_b
-- ON proj_act.is_property = false AND proj_act.is_property_branch = true AND proj_act.unit_category = 'Sale' AND proj_act.property_unit_id = sal_prop_uni_b.id
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id = pro.id
-- INNER JOIN users 
-- ON proj_act.user_id =  users.id 
-- WHERE proj_act.activity_type=$1
 
 
-- UNION ALL
 
 


-- -- name: GetProjectActivityByProjectId :one
-- SELECT id FROM project_activities 
-- WHERE project_id=$1  AND activity_type=1 AND module_name=$2;

-- -- name: GetSingleProjectActivityIdByProjectPropertyIDForDocument :one
-- SELECT proj_act.id
-- FROM project_activities AS proj_act 
-- INNER JOIN project_properties_documents AS proj_prop_doc
-- ON proj_act.property_unit_id=proj_prop_doc.project_properties_id AND proj_act.unit_category='' AND proj_act.activity_type=2 AND proj_act.file_category=3
-- WHERE proj_act.property_unit_id=$1;
 
-- -- name: GetSingleProjectActivityIdByProjectPropertyIDForMedia :one
-- SELECT proj_act.id
-- FROM project_activities AS proj_act 
-- INNER JOIN project_property_media AS proj_prop_med
-- ON proj_act.property_unit_id=proj_prop_med.project_properties_id AND proj_act.unit_category='' AND proj_act.activity_type=2 AND proj_act.file_category=1
-- WHERE proj_act.property_unit_id=$1;

-- -- name: GetAllProjectActivitiesTransactions :many
-- SELECT proj_act.id,pro.project_name,proj_act.activity_date,proj_act.module_name,users.username
-- FROM project_activities AS proj_act
-- INNER JOIN projects AS pro 
-- ON proj_act.project_id=pro.id
-- INNER JOIN users 
-- ON proj_act.user_id=users.id
-- WHERE proj_act.activity_type=1
-- ORDER BY proj_act.id 
-- LIMIT $1
-- OFFSET $2;

-- -- name: GetAllProjectActivitiesFileView :many
-- SELECT proj_act.id,proj_prop.property_name,proj_act.activity_date,proj_act.file_category,users.username
-- FROM project_activities AS proj_act
-- INNER JOIN project_properties AS proj_prop 
-- ON proj_act.property_unit_id=proj_prop.id 
-- INNER JOIN users 
-- ON proj_act.user_id=users.id
-- WHERE proj_act.activity_type=2
-- ORDER BY proj_act.activity_date DESC
-- LIMIT $1
-- OFFSET $2;

-- -- name: GetNumberOfProjectActivities :one
-- SELECT count(id) 
-- FROM project_activities AS proj_act 
-- WHERE proj_act.activity_type=$1;

-- -- name: GetSingleProjectActivityIdByProjectPropertyIDForPlan :one
-- SELECT proj_act.id
-- FROM project_activities AS proj_act 
-- INNER JOIN properties_plans AS prop_pla
-- ON proj_act.property_unit_id=prop_pla.properties_id AND proj_act.unit_category='' AND proj_act.activity_type=2 AND proj_act.file_category=2
-- WHERE proj_act.property_unit_id=$1;

-- -- name: GetSingleProjectActivityIdByUnitPropertyIDForDocumentSale :one
-- SELECT proj_act.id
-- FROM project_activities AS proj_act 
-- INNER JOIN  sale_property_units_documents AS sal_prop_uni_doc
-- ON proj_act.property_unit_id = sal_prop_uni_doc.sale_property_units_id AND proj_act.property_unit_id=$1
-- AND proj_act.activity_type=1 
-- AND proj_act.file_category=0 
-- AND proj_act.module_name='Add sale unit';

-- -- name: GetSingleProjectActivityIdByUnitPropertyIDForDocumentRent :one
-- SELECT proj_act.id
-- FROM project_activities AS proj_act 
-- INNER JOIN  rent_property_units_documents AS ren_prop_uni_doc
-- ON proj_act.property_unit_id = ren_prop_uni_doc.rent_property_units_id AND proj_act.property_unit_id=$1
-- AND proj_act.activity_type=1 
-- AND proj_act.file_category=0 
-- AND proj_act.module_name='Add rent unit';

-- -- name: GetSingleProjectActivityIdByUnitPropertyIDForDocumentExchange :one
-- SELECT proj_act.id
-- FROM project_activities AS proj_act 
-- INNER JOIN  exchange_property_units_documents AS exc_prop_uni_doc
-- ON proj_act.property_unit_id = exc_prop_uni_doc.exchange_property_units_id AND proj_act.property_unit_id=$1
-- AND proj_act.activity_type=1 
-- AND proj_act.file_category=0 
-- AND proj_act.module_name='Add exchange unit';

-- -- name: GetProjectActivityIDByUnitIDAndModuleName :one
-- SELECT proj_act.id
-- FROM project_activities AS proj_act 
-- WHERE proj_act.property_unit_id=$1 AND proj_act.module_name=$2;
 
 
-- -- name: GetSingleProjectActivityIdByUnitPropertyIDForMediaSale :one
-- SELECT proj_act.id
-- FROM project_activities AS proj_act 
-- INNER JOIN  sale_property_media AS sal_prop_uni_med
-- ON  proj_act.property_unit_id=$1 
-- AND proj_act.property_unit_id = sal_prop_uni_med.sale_property_units_id 
-- AND proj_act.activity_type=1 
-- AND proj_act.file_category=0 
-- AND proj_act.module_name='Add sale unit';
 
 
-- -- name: GetSingleProjectActivityIdByUnitPropertyIDForMediaRent :one
-- SELECT proj_act.id
-- FROM project_activities AS proj_act 
-- INNER JOIN rent_property_media AS ren_prop_uni_med
-- ON  proj_act.property_unit_id=$1
-- AND proj_act.property_unit_id = ren_prop_uni_med.rent_property_units_id 
-- AND proj_act.activity_type=1 
-- AND proj_act.file_category=0 
-- AND proj_act.module_name='Add rent unit';
 
 

 
 
-- -- name: GetSingleProjectActivityIdByUnitPropertyIDForPlanSale :one
-- SELECT proj_act.id
-- FROM project_activities AS proj_act 
-- INNER JOIN  sale_property_unit_plans AS sal_prop_uni_pla
-- ON  proj_act.property_unit_id=$1
-- AND proj_act.property_unit_id = sal_prop_uni_pla.sale_property_units_id 
-- AND proj_act.activity_type=1 
-- AND proj_act.file_category=0 
-- AND proj_act.module_name='Add sale unit';
 
-- -- name: GetSingleProjectActivityIdByUnitPropertyIDForPlanRent :one
-- SELECT proj_act.id
-- FROM project_activities AS proj_act 
-- INNER JOIN rent_property_unit_plans AS ren_prop_uni_pla
-- ON  proj_act.property_unit_id=$1
-- AND proj_act.property_unit_id = ren_prop_uni_pla.rent_property_units_id 
-- AND proj_act.activity_type=1 
-- AND proj_act.file_category=0 
-- AND proj_act.module_name='Add rent unit';
 



-- -- name: GetSingleProjectActivityIdByUnitProjectPropertyIdAndModuleName :one
-- SELECT proj_act.id
-- FROM project_activities AS proj_act 
-- WHERE proj_act.property_unit_id=$1 AND proj_Act.module_name=$2 AND proj_act.activity_type=1;

-- -- name: GetProjectActivity :one
-- SELECT id FROM project_activities 
-- WHERE project_id=$1 AND activity_type=$2 AND module_name=$3 AND file_url=$4;



-- -- name: CreateActivities :one
-- INSERT INTO activities (
--     module_name,
--     previous,
--     current,
--     activity, 
--     created_by,
--     activity_date
-- )VALUES (
--     $1, $2, $3, $4, $5, $6
-- ) RETURNING *;

 
-- -- name: GetActivities :one
-- SELECT * FROM activities 
-- WHERE id = $1 LIMIT $1;

-- -- name: GetAllActivities :many
-- SELECT * FROM activities
-- ORDER BY id
-- LIMIT $1
-- OFFSET $2;

-- -- name: UpdateActivities :one
-- UPDATE activities
-- SET unit_id = $2,
--     previous_activity_id = $3,
--     activity = $4,
--     identifier = $5,
--     is_branch = $6,
--     type_of_activity = $7,
--     users_id = $8,
--     created_at = $9,
--     updated_at = $10
-- Where id = $1
-- RETURNING *;


-- -- name: DeleteActivities :exec
-- DELETE FROM activities
-- Where id = $1;

-- -- name: GetRecentActivityId :one
-- SELECT MAX(id)::bigint AS recentId FROM activities
-- WHERE unit_id = $1 AND identifier = $2 AND is_branch = $3 AND type_of_activity = $4;
