-- name: GetSlugByRefNo :one 
SELECT cu.company_id, 
	unit_versions."type" AS category, 
	unit_versions.ref_no, unit_versions.slug, 
	ut."usage",
	'unit' AS table_name 
FROM unit_versions 
JOIN company_users cu ON cu.users_id = unit_versions.listed_by 
JOIN units ON units.id=unit_versions.unit_id
JOIN unit_type ut ON ut.id=units.unit_type_id
WHERE ref_no = @ref_no::varchar AND unit_versions.status = @active_status::BIGINT

UNION ALL

SELECT cu.company_id, 
	property_versions.category AS category, 
	property_versions.ref_no, 
	property_versions.slug, 
	gpt."usage",
	'property' AS table_name 
FROM property_versions 
JOIN company_users cu ON cu.users_id = property_versions.agent_id 
JOIN property on property.id=property_versions.property_id
JOIn global_property_type gpt on gpt.id=property.property_type_id 
WHERE property_versions.ref_no = @ref_no::varchar AND property_versions.status = @active_status::BIGINT;