-- name: CreateActivityChanges :one
INSERT INTO activity_changes (
    section_id,
    activities_id,
    field_name,
    before,
    after
)VALUES (
     $1 , $2, $3, $4, $5
) RETURNING *;

-- -- name: GetActivityChangesByProjectActivityID :many
-- SELECT act_ch.id,pro.project_name,act_ch.field_name,act_ch.before,act_ch.after
-- FROM activity_changes AS act_ch
-- INNER JOIN project_activities AS proj_act
-- ON act_ch.activities_id=proj_act.id
-- INNER JOIN projects AS pro
-- ON proj_act.project_id=pro.id
-- WHERE act_ch.section_id=1 AND act_ch.activities_id=$1
-- ORDER BY id 
-- LIMIT $2
-- OFFSET $3; 

-- -- name: GetAllActivityChangesFileView :many
-- SELECT act_ch.id,act_ch.activity_date,proj_prop.property_name,act_ch.field_name AS File_viewed,users.username,act_ch.before AS activity, doc_cate.category
-- FROM activity_changes AS act_ch 
-- INNER JOIN project_activities AS proj_act  
-- ON act_ch.activities_id=proj_act.id AND proj_act.file_category=$1 AND proj_act.activity_type=2 AND proj_act.id=$2
-- INNER JOIN project_properties AS proj_prop
-- ON proj_prop.id=proj_act.property_unit_id 
-- INNER JOIN users 
-- ON proj_act.user_id=users.id
-- LEFT OUTER  JOIN project_properties_documents AS proj_prop_doc 
-- ON  proj_act.file_category=3 AND proj_prop_doc.project_properties_id=proj_act.property_unit_id
-- LEFT OUTER JOIN  documents_category AS doc_cate
-- ON proj_act.file_category=3 AND  proj_prop_doc.documents_category_id=doc_cate.id
-- WHERE act_ch.section_id=1 
-- ORDER BY act_ch.activity_date DESC
-- LIMIT $3
-- OFFSET $4;

-- -- name: GetAllActivityChangesTransactions :many
-- SELECT act_ch.id,proj.project_name,act_ch.activity_date,act_ch.field_name,act_ch.before,act_ch.after 
-- FROM activity_changes AS act_ch
-- INNER JOIN project_activities AS proj_act 
-- ON act_ch.activities_id=proj_act.id AND proj_act.activity_type=1 
-- INNER JOIN projects AS proj 
-- ON proj_act.project_id=proj.id
-- INNER JOIN users 
-- ON proj_act.user_id=users.id
-- WHERE act_ch.section_id=1 AND act_ch.activities_id=$1
-- ORDER BY act_ch.activity_date DESC
-- LIMIT $2
-- OFFSET $3;

-- name: GetNumberOfActivityChanges :one
SELECT COUNT(act_ch.id)
FROM activity_changes AS act_ch 
WHERE act_ch.section_id=1 AND act_ch.activities_id=$1;

-- name: GetAllCareerActivityChanges :many
SELECT
    *
FROM
   activity_changes
where activities_id = $1
and section_id=$2;


-- name: GetNumberOfCommunityGuidesViewActivitiesTransactionView :one 
SELECT COUNT(*) 
FROM activity_changes ac 
INNER JOIN community_guides_activities cga ON cga.id=ac.activities_id AND cga.module_name=$3 
WHERE ac.activities_id=$1 AND ac.section_id=$2;

-- name: GetCommunityGuidesViewActivitiesTransactionView :many
SELECT ac.id,ac.activity_date,ac.field_name,ac.before,ac.after
FROM 
	activity_changes ac  
INNER JOIN community_guides_activities cga ON cga.id=ac.activities_id AND cga.module_name=$5
WHERE ac.activities_id=$1 AND ac.section_id=$2 
ORDER BY 
	ac.activity_date DESC
LIMIT $3 
OFFSET $4;