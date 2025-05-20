-- name: CreateApplicant :one
INSERT INTO applicants(
    full_name,  
    email_address, 
    mobile_number, 
    cv_url, 
    cover_letter, 
    expected_salary, 
    highest_education, 
    years_of_experience, 
    languages, 
    location,
    gender,
    applicant_photo,
    specialization,
	skills,
    field_of_study,
    created_at,
    status
)
VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,$15,$16,$17
    )
RETURNING *;

-- name: CreateApplication :one
INSERT INTO application(
    careers_id, 
    applicant_id, 
    created_at,
    status
)VALUES (
    $1, $2, $3, $4
    )
RETURNING *;

-- name: GetAllApplicants :many
SELECT
    sqlc.embed(applicants)
FROM
  applicants
WHERE
    applicants.status!=6 
order by applicants.id
LIMIT $1
OFFSET $2;

-- name: GetApplication :one
SELECT * FROM application where id=$1;

-- name: UpdateApplicationStaus :one
UPDATE application SET
    status=$1
WHERE id=$2
RETURNING *;

-- name: UpdateApplicantStaus :one
UPDATE applicants SET
    status=$1
WHERE id=$2
RETURNING *;

-- name: GetAllApplications :many
SELECT
    sqlc.embed(applicants),
    sqlc.embed(application),
    sqlc.embed(careers)
FROM
    application
JOIN applicants on applicants.id=application.applicant_id
JOIN  careers on application.careers_id=careers.id
WHERE 
    (case when @career_id::bigint=0 then true else careers.id= @career_id::bigint end)
AND 
    applicants.status!=6 and application.status!=6 and careers.career_status!=6
order by application.id
LIMIT $1
OFFSET $2;


-- name: GetApplicationCount :one
SELECT
   count(application)
FROM
    application
JOIN applicants on applicants.id=application.applicant_id
JOIN  careers on application.careers_id=careers.id
WHERE 
    (case when @career_id::bigint=0 then true else careers.id= @career_id::bigint end)
AND 
    applicants.status!=6 and application.status!=6 and careers.career_status!=6;

-- name: GetApplicantByID :one
SELECT
    app.*,
    array_agg(DISTINCT langs.id)::bigint[] AS langs_ids,
    array_agg(DISTINCT langs."language")::text[] AS langs,
    array_agg(DISTINCT specs.id)::bigint[] AS specs_ids,
    array_agg(DISTINCT specs.title)::text[] AS specs_names,
     array_agg(DISTINCT skill.id)::bigint[] AS skills_ids, 
    array_agg(DISTINCT skill.title)::text[] AS skills
 
FROM applicants AS app
LEFT JOIN LATERAL unnest(app.skills) AS skill_id ON true
LEFT JOIN skills as skill ON skill_id = skill.id
 
JOIN LATERAL unnest(app.languages) AS lang ON true
JOIN all_languages langs ON lang = langs.id
JOIN LATERAL unnest(app.specialization) AS spec ON true
JOIN specialization as specs ON spec = specs.id
WHERE app.id = $1
GROUP BY app.id;
 

