-- name: CreatePropertyHubActivity :one
INSERT INTO property_hub_activities (
    company_types_id,
    companies_id,
    is_branch,
    is_property,
    is_property_branch,
    unit_category,
    property_unit_id,
    module_name,
    activity_type,
    file_category,
    file_url,
    portal_url,
    activity,
    user_id,
    activity_date  
)VALUES (
    $1 , $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15
) RETURNING *;
 
 
-- name: GetPropertyHubActivity :one
SELECT * FROM  property_hub_activities
WHERE id=$1 LIMIT $1;
 
 
-- name: DeletePropertyHubActivity :exec
DELETE FROM property_hub_activities
WHERE id=$1;
 
 
-- name: UpdatePropertyHubActivity :one
UPDATE property_hub_activities
SET    
        module_name=$2,
        activity_type=$3,
        portal_url=$4,
        -- before=$5,
        activity=$5,
        activity_date=$6
Where id = $1
RETURNING *;
 
-- name: GetAllPropertyHubActivity :many
SELECT * FROM property_hub_activities
ORDER BY id
LIMIT $1 OFFSET $2;

-- name: UpdatePropertyHubActivities :one
UPDATE property_hub_activities
SET  company_types_id = $2,  
companies_id = $3, 
is_branch = $4,  
is_property = $5, 
is_property_branch = $6, 
unit_category = $7, 
property_unit_id = $8,  
module_name = $9, 
activity_type = $10, 
file_category = $11,  
file_url = $12,  
portal_url = $13,  
activity = $14, 
user_id = $15,  
activity_date = $16 
Where id = $1
RETURNING *;

-- name: GetPropertyHubActivities :one
SELECT * FROM property_hub_activities
WHERE property_hub_activities.property_unit_id = $1 AND property_hub_activities.is_property = $2 AND property_hub_activities.is_branch = $3;

-- name: DeletePropertyHubActivities :exec
DELETE FROM property_hub_activities
Where id = $1;

-- name: GetCountPropertyActivitiesByType :one
SELECT
count(*)
FROM
property_hub_activities
WHERE
activity_type = $1;

-- name: GetAllPropertyHubActivitiesTransactions :many
WITH X AS (
SELECT prop_hub_act.id,fp.property_name, prop_hub_act.activity_date , prop_hub_act.module_name , users.username AS user_name FROM property_hub_activities AS prop_hub_act INNER JOIN freelancers_properties AS fp ON prop_hub_act.property_unit_id= fp.id AND prop_hub_act.unit_category = 'Property Hub Freelancer' AND prop_hub_act.is_property_branch = FALSE
INNER JOIN users ON prop_hub_act.user_id = users.id WHERE prop_hub_act.activity_type = $1
UNION ALL
SELECT prop_hub_act.id,op.property_name, prop_hub_act.activity_date , prop_hub_act.module_name , users.username AS user_name FROM property_hub_activities AS prop_hub_act INNER JOIN owner_properties AS op ON prop_hub_act.property_unit_id= op.id AND prop_hub_act.unit_category = 'Property Hub Owner' AND prop_hub_act.is_property_branch = FALSE
INNER JOIN users ON prop_hub_act.user_id = users.id WHERE prop_hub_act.activity_type = $1
UNION ALL
SELECT  prop_hub_act.id,bca.property_name, prop_hub_act.activity_date , prop_hub_act.module_name , users.username AS user_name FROM property_hub_activities AS prop_hub_act INNER JOIN broker_company_agent_properties AS bca ON prop_hub_act.property_unit_id= bca.id AND prop_hub_act.unit_category = 'Property Hub Broker' AND prop_hub_act.is_property_branch = FALSE
INNER JOIN users ON prop_hub_act.user_id = users.id WHERE prop_hub_act.activity_type = $1
UNION ALL
SELECT prop_hub_act.id,bcap.property_name, prop_hub_act.activity_date , prop_hub_act.module_name , users.username AS user_name FROM property_hub_activities AS prop_hub_act INNER JOIN broker_company_agent_properties_branch AS bcap ON prop_hub_act.property_unit_id= bcap.id AND prop_hub_act.unit_category = 'Property Hub Broker' AND prop_hub_act.is_property_branch = TRUE
INNER JOIN users ON prop_hub_act.user_id = users.id WHERE prop_hub_act.activity_type = $1
)
SELECT * FROM X
ORDER BY id
LIMIT $2
OFFSET $3;


-- name: GetAllPropertyHubActivitiesFileView :many
WITH X AS (
SELECT prop_hub_act.id,fp.property_name, prop_hub_act.activity_date , prop_hub_act.file_category , users.username AS user_name FROM property_hub_activities AS prop_hub_act INNER JOIN freelancers_properties AS fp ON prop_hub_act.property_unit_id= fp.id AND prop_hub_act.unit_category = 'Property Hub Freelancer' AND prop_hub_act.is_property_branch = FALSE
INNER JOIN users ON prop_hub_act.user_id = users.id WHERE prop_hub_act.activity_type = $1
UNION ALL
SELECT prop_hub_act.id,op.property_name, prop_hub_act.activity_date , prop_hub_act.file_category , users.username AS user_name FROM property_hub_activities AS prop_hub_act INNER JOIN owner_properties AS op ON prop_hub_act.property_unit_id= op.id AND prop_hub_act.unit_category = 'Property Hub Owner' AND prop_hub_act.is_property_branch = FALSE
INNER JOIN users ON prop_hub_act.user_id = users.id WHERE prop_hub_act.activity_type = $1
UNION ALL
SELECT  prop_hub_act.id,bca.property_name, prop_hub_act.activity_date , prop_hub_act.file_category , users.username AS user_name FROM property_hub_activities AS prop_hub_act INNER JOIN broker_company_agent_properties AS bca ON prop_hub_act.property_unit_id= bca.id AND prop_hub_act.unit_category = 'Property Hub Broker' AND prop_hub_act.is_property_branch = FALSE
INNER JOIN users ON prop_hub_act.user_id = users.id WHERE prop_hub_act.activity_type = $1
UNION ALL
SELECT prop_hub_act.id,bcap.property_name, prop_hub_act.activity_date , prop_hub_act.file_category , users.username AS user_name FROM property_hub_activities AS prop_hub_act INNER JOIN broker_company_agent_properties_branch AS bcap ON prop_hub_act.property_unit_id= bcap.id AND prop_hub_act.unit_category = 'Property Hub Broker' AND prop_hub_act.is_property_branch = TRUE
INNER JOIN users ON prop_hub_act.user_id = users.id WHERE prop_hub_act.activity_type = $1
)
SELECT * FROM X
ORDER BY id
LIMIT $2
OFFSET $3;

-- name: GetActivityViewForPropertyHubActivitiesTransactions :many
WITH X AS (
SELECT prop_hub_act.id, fp.property_name, prop_hub_act.activity_date, act_chan.field_name, act_chan.before, act_chan.after FROM activity_changes AS act_chan
INNER JOIN property_hub_activities AS prop_hub_act
ON act_chan.activities_id = prop_hub_act.id
INNER JOIN freelancers_properties AS fp ON prop_hub_act.property_unit_id= fp.id AND prop_hub_act.unit_category = 'Property Hub Freelancer'
AND act_chan.section_id=2 AND act_chan.activities_id = $1
UNION ALL
SELECT prop_hub_act.id, op.property_name, prop_hub_act.activity_date, act_chan.field_name, act_chan.before, act_chan.after  FROM activity_changes AS act_chan
INNER JOIN property_hub_activities AS prop_hub_act
ON act_chan.activities_id = prop_hub_act.id
INNER JOIN owner_properties AS op ON prop_hub_act.property_unit_id= op.id AND prop_hub_act.unit_category = 'Property Hub Owner'
AND act_chan.section_id=2 AND act_chan.activities_id = $1
UNION ALL
SELECT prop_hub_act.id, bca.property_name, prop_hub_act.activity_date, act_chan.field_name, act_chan.before, act_chan.after FROM activity_changes AS act_chan
INNER JOIN property_hub_activities AS prop_hub_act
ON act_chan.activities_id = prop_hub_act.id
INNER JOIN broker_company_agent_properties AS bca ON prop_hub_act.property_unit_id= bca.id AND prop_hub_act.unit_category = 'Property Hub Broker'
AND prop_hub_act.is_branch = FALSE
AND act_chan.section_id=2 AND act_chan.activities_id = $1
UNION ALL
SELECT prop_hub_act.id, bcap.property_name, prop_hub_act.activity_date, act_chan.field_name, act_chan.before, act_chan.after FROM activity_changes AS act_chan
INNER JOIN property_hub_activities AS prop_hub_act
ON act_chan.activities_id = prop_hub_act.id
INNER JOIN broker_company_agent_properties_branch AS bcap ON prop_hub_act.property_unit_id= bcap.id AND prop_hub_act.unit_category = 'Property Hub Broker' AND
prop_hub_act.is_branch = TRUE
AND act_chan.section_id=2 AND act_chan.activities_id = $1)
SELECT * FROM X
ORDER BY id
LIMIT $2
OFFSET $3;

-- name: GetActivityViewForPropertyHubActivitiesFileView :many
WITH X AS (
SELECT act_ch.id,act_ch.activity_date,fp.property_name,act_ch.field_name  AS File_viewed,dc.category, users.username,act_ch.before AS activity FROM activity_changes AS act_ch
INNER JOIN property_hub_activities AS prop_hub_act ON act_ch.activities_id=prop_hub_act.id AND prop_hub_act.file_category=$1 AND prop_hub_act.activity_type=2 AND prop_hub_act.id=$2
INNER JOIN freelancers_properties AS fp ON fp.id=prop_hub_act.property_unit_id
INNER JOIN users ON prop_hub_act.user_id=users.id
INNER JOIN freelancers_properties_documents AS fpd ON fpd.freelancers_properties_id = fp.id
INNER JOIN documents_category AS dc ON dc.id = fpd.documents_category_id
WHERE act_ch.section_id=2
UNION ALL
SELECT act_ch.id,act_ch.activity_date,op.property_name,act_ch.field_name AS File_viewed, dc.category, users.username,act_ch.before AS activity FROM activity_changes AS act_ch
INNER JOIN property_hub_activities AS prop_hub_act ON act_ch.activities_id=prop_hub_act.id
AND prop_hub_act.file_category=$1 AND prop_hub_act.activity_type=2 AND prop_hub_act.id=$2
INNER JOIN owner_properties AS op ON op.id=prop_hub_act.property_unit_id
INNER JOIN users ON prop_hub_act.user_id=users.id
INNER JOIN owner_properties_documents AS opd ON opd.owner_properties_id = op.id
INNER JOIN documents_category AS dc ON dc.id = opd.documents_category_id
WHERE act_ch.section_id=2
UNION ALL
SELECT act_ch.id,act_ch.activity_date,bca.property_name,act_ch.field_name AS File_viewed, dc.category, users.username,act_ch.before AS activity FROM activity_changes AS act_ch
INNER JOIN property_hub_activities AS prop_hub_act ON act_ch.activities_id=prop_hub_act.id AND prop_hub_act.file_category=$1 AND prop_hub_act.activity_type=2 AND prop_hub_act.id=$2
INNER JOIN broker_company_agent_properties AS bca ON bca.id=prop_hub_act.property_unit_id
INNER JOIN users ON prop_hub_act.user_id=users.id
INNER JOIN broker_company_agent_properties_documents AS bcd ON bcd.broker_company_agent_properties_id = bca.id
INNER JOIN documents_category AS dc ON dc.id = bcd.documents_category_id
WHERE act_ch.section_id=2
UNION ALL
SELECT act_ch.id,act_ch.activity_date,bcap.property_name,act_ch.field_name AS File_viewed, dc.category, users.username,act_ch.before AS activity FROM activity_changes AS act_ch
INNER JOIN property_hub_activities AS prop_hub_act ON act_ch.activities_id=prop_hub_act.id AND prop_hub_act.file_category=$1 AND prop_hub_act.activity_type=2 AND prop_hub_act.id=$2
INNER JOIN broker_company_agent_properties_branch AS bcap ON bcap.id=prop_hub_act.property_unit_id
INNER JOIN users ON prop_hub_act.user_id=users.id
INNER JOIN broker_company_agent_properties_documents_branch AS bcd ON bcd.broker_company_agent_properties_branch_id = bcap.id
INNER JOIN documents_category AS dc ON dc.id = bcd.documents_category_id
WHERE act_ch.section_id=2)
SELECT * FROM X
ORDER BY id
LIMIT $2
OFFSET $3;

-- name: GetPropertyHubActivityByPropertyId :one
SELECT * FROM property_hub_activities WHERE property_unit_id = $1 AND module_name = $2;