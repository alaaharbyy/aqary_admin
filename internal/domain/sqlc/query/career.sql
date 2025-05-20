-- name: CreateNewCareer :one
INSERT INTO careers (
ref_no,
job_title,
job_title_ar,
employment_types,
employment_mode,
job_style,
job_categories,
career_level,
addresses_id,
is_urgent,
job_description,
job_image,
number_of_positions,
years_of_experience,
gender,
nationality_id,
min_salary,
max_salary,
languages,
uploaded_by,
date_expired,
career_status,
education_level,
specialization,
skills,
global_tagging_id,
created_at,
updated_at,
field_of_study,
status,
rank
) VALUES (
$1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
$11, $12, $13, $14, $15, $16, $17, $18, $19, $20,
$21, $22, $23, $24,$25,$26,$27,$28,$29,$30,$31
) RETURNING *;

-- name: InsertJobCategory :one
INSERT INTO job_categories (
    parent_category_id,
    category_name,
    description,
    category_image,
    created_at,
    status,
    updated_at
 ) VALUES (
    $1, $2, $3, $4, $5, $6, $7
) RETURNING *;


-- name: GetCareers :many
SELECT
    sqlc.embed(cr),
    sqlc.embed(companies)
FROM
    careers cr
JOIN addresses a ON cr.addresses_id=a.id
JOIN company_users u ON cr.uploaded_by=u.users_id
JOIN companies ON u.company_id= companies.id
WHERE
	 (CASE WHEN @company_id::BIGINT=0 THEN TRUE ELSE u.company_id= @company_id::BIGINT end)
AND
    (ARRAY_LENGTH(@career_rank::bigint [],1) IS NULL OR cr."rank" = ANY (@career_rank::bigint []))
AND
    (CASE WHEN  @country_id::bigint=0 THEN TRUE ELSE a.countries_id = @country_id::bigint end) 
AND   
    (CASE WHEN @city_id::bigint=0 THEN TRUE ELSE a.cities_id= @city_id::bigint END)
AND
     (CASE WHEN @communities_id::bigint=0 THEN TRUE ELSE a.communities_id= @communities_id::bigint END)
AND
     (CASE WHEN @sub_communities_id::bigint=0 THEN TRUE ELSE a.sub_communities_id= @sub_communities_id::bigint END)
AND  
	 cr.status= @status::bigint
AND 
    (ARRAY_LENGTH(@career_status::bigint [],1) IS NULL OR cr.career_status = ANY (@career_status::bigint []))
ORDER BY
	CASE
        WHEN @sort_by::bigint = 1 THEN cr.updated_at END DESC,
    CASE
        WHEN @sort_by::bigint = 2 THEN cr.max_salary::FLOAT END DESC,
    CASE
        WHEN @sort_by::bigint = 3 THEN cr.max_salary::FLOAT END ASC,
     CASE
        WHEN @sort_by::bigint = 4 THEN cr."rank"::BIGINT END DESC
OFFSET $1
LIMIT $2;

-- name: GetCareersTotalCount :one
SELECT
    count(cr.id)
FROM
    careers cr
JOIN addresses a ON cr.addresses_id=a.id
JOIN company_users u ON cr.uploaded_by=u.users_id
WHERE
	 (CASE WHEN @company_id::BIGINT=0 THEN TRUE ELSE u.company_id= @company_id::BIGINT end)
AND
    (ARRAY_LENGTH(@career_rank::bigint [],1) IS NULL OR cr."rank" = ANY (@career_rank::bigint []))
AND
    (CASE WHEN  @country_id::bigint=0 THEN TRUE ELSE a.countries_id = @country_id::bigint end) 
AND   
    (CASE WHEN @city_id::bigint=0 THEN TRUE ELSE a.cities_id= @city_id::bigint END)
AND
    (CASE WHEN @communities_id::bigint=0 THEN TRUE ELSE a.communities_id= @communities_id::bigint END)
AND
    (CASE WHEN @sub_communities_id::bigint=0 THEN TRUE ELSE a.sub_communities_id= @sub_communities_id::bigint END)
AND  
	cr.status= @status::bigint
AND 
    (ARRAY_LENGTH(@career_status::bigint [],1) IS NULL OR cr.career_status = ANY(@career_status::bigint []));

-- name: UpdateCareerByID :one
UPDATE careers SET
ref_no = $1,
job_title = $2,
job_title_ar = $3,
employment_types = $4,
employment_mode = $5,
job_style = $6,
job_categories=$7,
career_level=$8,
addresses_id=$9,
is_urgent=$10,
skills=$11,
is_urgent = $12,
job_description = $13,
number_of_positions = $14,
years_of_experience = $15,
gender = $16,
nationality_id = $17,
min_salary = $18,
max_salary = $19,
languages = $20,
date_expired = $21,
career_status = $22, 
education_level = $23,
specialization=$24,
skills = $25,
global_tagging_id = $26,
field_of_study = $27,
status=$28,
job_image=$30,
updated_at=$31,
rank=$32
WHERE id = $29
RETURNING *;
 
 
-- name: GetCareerByID :one
SELECT
    sqlc.embed(cr),
    sqlc.embed(companies)
FROM
    careers cr
JOIN company_users u ON cr.uploaded_by=u.users_id
JOIN companies ON u.company_id= companies.id
WHERE
    cr.id = $1;
 
 
-- name: GetCareersByUserId :many
SELECT 
*
FROM careers
WHERE uploaded_by = $1;


-- name: GetPaginatedActiveCareers :many
WITH 
-- employerIds AS(
-- 	SELECT 
-- 	e.company_id as company,
-- 	e.id AS emp_id
-- 	FROM employers e 
-- 	WHERE e.company_id=$4
-- ),
Nationalities AS (
    SELECT id, UNNEST(nationality_id) AS nat_id 
    FROM careers
),
FieldsOfStudy AS (
    SELECT id, UNNEST(field_of_studies) AS fields_id 
    FROM careers
),
-- candidate_count AS (
--     SELECT
--         c.careers_id,
--         COUNT(c.id) AS count
--     FROM
--         candidates c
--     JOIN
--         applicants a ON c.applicants_id = a.id
--     JOIN
--         careers car ON c.careers_id = car.id
--     WHERE
--         c.application_status != 6 AND (car.career_status != 6 AND car.career_status != 5)
--     GROUP BY
--         c.careers_id
-- ),
nationalities_agg AS (
    SELECT 
        c.id AS career_id, 
        json_agg(
            json_build_object(
                'id', n.nat_id,
                'name', co.country
            )
        ) AS nationalities
    FROM careers c
    JOIN Nationalities n ON c.id = n.id
    JOIN countries co ON co.id = n.nat_id
    GROUP BY c.id
),
fields_agg AS (
    SELECT 
        c.id AS career_id, 
        json_agg(
            json_build_object(
                'id', n.fields_id,
                'name', f.title
            )
        ) AS fields
    FROM careers c
    JOIN FieldsOfStudy n ON c.id = n.id
    JOIN field_of_studies f ON f.id = n.fields_id
    GROUP BY c.id
)
SELECT
	-- COALESCE(cc.count, 0) AS candidate_count,
    COALESCE(na.nationalities, '[]'::json) AS nationalities,
    COALESCE(fs.fields, '[]'::json) AS field_of_studies,
    sqlc.embed(cr),
    -- sqlc.embed(e),
    sqlc.embed(co),
    sqlc.embed(ci),
    sqlc.embed(com)
FROM
    careers cr
-- LEFT JOIN
--     candidate_count cc ON cr.id = cc.careers_id
LEFT JOIN
    nationalities_agg na ON cr.id = na.career_id
LEFT JOIN
    fields_agg fs ON cr.id = fs.career_id
-- JOIN
--     employers e ON cr.employers_id = e.id
JOIN
    countries co ON cr.countries_id = co.id
JOIN
    cities ci ON cr.city_id = ci.id
JOIN
    communities com ON cr.community_id = com.id
-- JOIN 
-- 	employerIds empIds ON cr.employers_id=empIds.emp_id
WHERE
     ($3 = '%%' OR 
     cr.job_title % $3 OR
     cr.job_title_ar % $3 OR
     cr.ref_no % $3 OR
     co.country % $3 OR
     ci.city % $3 OR 
     com.community % $3)
     OR 
     (CASE
        WHEN 'draft' ILIKE $3 THEN cr.career_status = 1
        WHEN 'active' ILIKE $3 THEN cr.career_status = 2
        WHEN 'reposted' ILIKE $3 THEN cr.career_status = 7
        WHEN 'closed' ILIKE $3 THEN cr.career_status = 8
        WHEN 'male' ILIKE $3 THEN cr.gender=1
        WHEN 'female' ILIKE $3 THEN cr.gender=2
        WHEN 'urgent' ILIKE $3 THEN cr.is_urgent = true
        ELSE FALSE
      END)
     AND cr.career_status NOT IN (5,6) 
ORDER BY
    cr.updated_at DESC
OFFSET $1
LIMIT $2;

-- name: DeleteCareerByID :exec
UPDATE
    careers
SET
    updated_at=$2,
    career_status = 6
WHERE
    id = $1;

-- name: GetPaginatedJobCategories :many
select a.id,
	(case when a.parent_category_id = 0 then 'Parent Category' else b.category_name end) as parent,
    (case when a.parent_category_id = 0 then true else false end) as is_parent,
	a.category_name,
	a.category_image
	-- a.ref_no
from job_categories as a
left join
(
	select id, category_name,category_image from job_categories
) as b
on a.parent_category_id = b.id
WHERE
   a.status!=6 and a.status!=5
ORDER BY
    a.updated_at DESC
OFFSET $1 LIMIT $2;
 
-- name: GetJobCategoryByID :one
SELECT * FROM job_categories WHERE id = $1;
 
-- name: UpdateJobCategory :one
UPDATE job_categories
SET
    category_name = $1,
    category_image = $2,
   updated_at=$3
WHERE
    id = $4
RETURNING *;
 
 
-- name: DeleteJobCategory :one
UPDATE job_categories
SET
    status = 6
WHERE
    id = $1
RETURNING *;


-- name: UpdateCareersStatus :one
UPDATE careers
SET
    career_status = $1,
   updated_at=$3
WHERE
    id = $2
RETURNING *;

-- name: GetCareerCount :one
SELECT
count(*)
FROM
    careers cr
-- JOIN
--     employers e ON cr.employers_id = e.id
JOIN
    countries co ON cr.countries_id = co.id
JOIN
    cities ci ON cr.city_id = ci.id
JOIN
    communities com ON cr.community_id = com.id
WHERE
   
     ($1 = '%%' OR 
     cr.job_title % $1 OR
     cr.job_title_ar % $1 OR
     cr.ref_no % $1 OR
     co.country % $1 OR
     ci.city % $1 OR 
     com.community % $1)
     OR 
     (CASE
        WHEN 'draft' ILIKE $1 THEN cr.career_status = 1
        WHEN 'active' ILIKE $1 THEN cr.career_status = 2
        WHEN 'reposted' ILIKE $1 THEN cr.career_status = 7
        WHEN 'closed' ILIKE $1 THEN cr.career_status = 8
        WHEN 'male' ILIKE $1 THEN cr.gender=1
        WHEN 'female' ILIKE $1 THEN cr.gender=2
        WHEN 'urgent' ILIKE $1 THEN cr.is_urgent = true
        ELSE FALSE
      END)
     AND cr.career_status NOT IN (5,6) ;
    --  AND cr.employers_id=$1;

-- name: UpdateCareerUrgency :one
UPDATE careers
SET
is_urgent=$1,
updated_at=$3
WHERE id=$2
RETURNING *;


-- name: GetAllCareersForCatg :many
SELECT * FROM careers 
WHERE job_categories=$1 AND career_status!=6
LIMIT $2 OFFSET $3;



