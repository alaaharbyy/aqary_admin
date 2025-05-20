-- name: GetAllActiveCompanyCategoryAndActivitiesByType :many
SELECT 
    company_category.id,
	CASE WHEN @lang::varchar = 'ar' THEN COALESCE(company_category.category_name_ar,company_category.category_name)
    ELSE COALESCE(company_category.category_name, '') END::varchar AS company_category,

    JSON_AGG(
		JSON_BUILD_OBJECT(
			'id', company_activities.id, 
			'label',CASE WHEN @lang::varchar = 'ar' THEN COALESCE(company_activities.activity_name_ar,company_activities.activity_name)
    		ELSE COALESCE(company_activities.activity_name, '') END::varchar
			 
	)) AS activities 
FROM 
    company_category
INNER JOIN 
    company_activities ON company_activities.company_category_id = company_category.id 
INNER JOIN company_types ON company_types.id = company_category.company_type
WHERE company_activities.status = 2 AND company_category.status = 2 AND company_category.company_type = $1
GROUP BY 
    company_category.id
	order by company_category.id desc;

-- name: GetSingleCompanyCategoryAndActivities :one
SELECT 
    company_category.id,
    company_category.category_name,
    company_category.category_name_ar,
	company_category.company_type,
	company_types.title,
    company_types.title_ar,
    company_activities.icon_url, 
	company_activities.tags,
    JSON_BUILD_OBJECT(
	'id', company_activities.id, 
	'label',CASE WHEN @lang::varchar = 'ar' THEN COALESCE(company_activities.activity_name_ar,company_activities.activity_name)
    	ELSE COALESCE(company_activities.activity_name, '') END::varchar
	
	) AS activities,
	COUNT(*) OVER() AS total_count  
FROM 
    company_category
LEFT JOIN 
    company_activities ON company_activities.company_category_id = company_category.id 
LEFT JOIN company_types ON company_types.id = company_category.company_type
WHERE company_activities.id = $1 AND company_activities.status!=6 AND company_category.status!=6
GROUP BY 
    company_category.id,company_activities.id, company_category.company_type, company_types.title,company_types.title_ar, company_activities.icon_url, company_activities.tags;

-- name: CreateCompanyActivities :one
INSERT INTO company_activities(
	company_category_id,
	activity_name,
	icon_url,
	tags,
	created_by,
	created_at,
	updated_at,
	updated_by,
    status,
	activity_name_ar, 
	description, 
	description_ar
)VALUES($1, $2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)
RETURNING *;
 
-- name: UpdateCompanyActivity :one
UPDATE company_activities
SET 
	company_category_id=$1,
	icon_url=$2,
	tags=$3,
	updated_at=$4,
	updated_by=$5,
	activity_name=$6,
    status=$8,
	activity_name_ar=$9, 
	description=$10, 
	description_ar=$11
WHERE id=$7
RETURNING *;
 
-- name: GetCompaniesCountByCategory :one 
SELECT COUNT(c.*) FROM companies as c
JOIN company_activities ca on ca.id=any(c.company_activities_id) 
JOIN company_category cc ON ca.company_category_id = cc.id
WHERE cc.id=$1 AND c.status!=6;

-- name: GetSingleCompanyActivity :one
SELECT * FROM company_activities
WHERE id=$1;

-- name: GetCompanyCategoryAndAcitivites :many
SELECT company_activities.*,company_category.category_name, company_category.category_name_ar,company_activities.id AS activity_id FROM companies 
CROSS JOIN UNNEST(companies.company_activities_id) AS group_id(id)
JOIN company_activities ON company_activities.id = group_id.id 
INNER JOIN company_category ON company_category.id = company_activities.company_category_id
WHERE companies.id = $1;



-- name: CompanyCategoryExistsInActivity :one 
SELECT count(*) FROM company_activities WHERE company_category_id=$1; 

-- name: GetAllCompanyActivities :many
SELECT company_activities.*,
company_category.category_name,
company_category.category_name_ar,
company_types.id AS company_type_id, company_types.title AS company_type_title, company_types.title_ar AS company_type_title_ar, COUNT(*) OVER() AS total_count
FROM company_activities
INNER JOIN company_category ON company_category.id = company_activities.company_category_id
INNER JOIN company_types ON company_types.id = company_category.company_type
WHERE CASE WHEN @status::bigint = 0 THEN company_activities.status != 6 AND company_category.status != 6 ELSE company_activities.status = @status::bigint END
ORDER BY company_activities.id desc
LIMIT sqlc.narg('limit')  
OFFSET sqlc.narg('offset');




-- name: UpdateCompanyActivityStatus :one
UPDATE company_activities
SET 
	status=$2, 
	updated_at=$3, 
	updated_by=$4
WHERE 
	id=$1 RETURNING 1;
