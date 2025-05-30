-- -- name: CreateCandidate :one
-- INSERT INTO candidates (ref_no, careers_id, applicants_id, application_date, application_status)
-- VALUES ($1, $2, $3, $4, $5)
-- RETURNING *;

-- -- name: UpdateCandidate :one
-- UPDATE candidates
-- SET ref_no = $1, careers_id = $2, applicants_id = $3, application_date = $4, application_status = $5
-- WHERE id = $6
-- RETURNING *;
 
-- -- name: GetCandidateByID :one
-- SELECT * FROM candidates WHERE id = $1;

-- -- name: GetInForCareerIdAndApplicant :one
-- SELECT
--     c.id AS candidate_id,
--     c.ref_no AS candidate_ref_no,
--     c.careers_id,
--     c.applicants_id,
--     c.application_date,
--     c.application_status,
--     a.id AS applicant_id,
--     a.firstname AS applicant_firstname,
--     a.lastname AS applicant_lastname,
--     a.email_address AS applicant_email,
--     a.mobile_number AS applicant_mobile,
--     a.cv_url AS applicant_cv_url,
--     a.cover_letter AS applicant_cover_letter,
--     a.applicant_info AS applicant_additional_info,
--     a.users_id AS applicant_user_id,
--     a.is_verified AS applicant_is_verified,
--     a.expected_salary AS applicant_expected_salary,
--     a.highest_education AS applicant_education_level,
--     a.years_of_experience AS applicant_years_of_experience,
--     a.languages AS applicant_languages,
--     a.applicant_photo AS applicant_photo_url,
--     a.specialization  AS applicant_specialization,
--     a.field_of_study AS applicant_field_of_study,
--     a.skills
-- FROM
--     candidates c
-- JOIN
--     applicants a ON c.applicants_id = a.id
-- WHERE
--     a.id = $1 and careers_id=$2;

-- -- name: GetCandidateAndApplicantInfo :many
-- SELECT
--     c.id AS candidate_id,
--     c.ref_no AS candidate_ref_no,
--     c.careers_id,
--     c.applicants_id,
--     c.application_date,
--     c.application_status,
--     a.firstname AS applicant_firstname,
--     a.lastname AS applicant_lastname,
--     a.email_address AS applicant_email,
--     a.mobile_number AS applicant_mobile,
--     a.cv_url AS applicant_cv_url,
--     a.cover_letter AS applicant_cover_letter,
--     a.applicant_info AS applicant_additional_info,
--     a.users_id AS applicant_user_id,
--     a.is_verified AS applicant_is_verified,
--     a.expected_salary AS applicant_expected_salary,
--     a.highest_education AS applicant_education_level,
--     a.years_of_experience AS applicant_years_of_experience,
--     a.languages AS applicant_languages,
--     a.applicant_photo AS applicant_photo_url
-- FROM
--     candidates c
-- JOIN
--     applicants a ON c.applicants_id = a.id
-- WHERE
--     a.id = $1;

-- -- name: UpdateCandidateStatusById :one
-- UPDATE
--     candidates
-- SET
--     application_status = $1
-- WHERE
--     id = $2
-- RETURNing *;

-- -- name: UpdateCandidateStatusByCareerAndApplicant :one
-- UPDATE
--     candidates
-- SET
--     application_status = $1
-- WHERE
--     careers_id = $2 and applicants_id=$3
-- RETURNing *;

-- -- name: GetApplicantsForCareerId :many
-- SELECT
--     c.id AS candidate_id,
--     c.ref_no AS candidate_ref_no,
--     c.careers_id,
--     c.applicants_id,
--     c.application_date,
--     c.application_status,
--     a.firstname AS applicant_firstname,
--     a.lastname AS applicant_lastname,
--     a.email_address AS applicant_email,
--     a.mobile_number AS applicant_mobile,
--     a.cv_url AS applicant_cv_url,
--     a.cover_letter AS applicant_cover_letter,
--     a.applicant_info AS applicant_additional_info,
--     a.users_id AS applicant_user_id,
--     a.is_verified AS applicant_is_verified,
--     a.expected_salary AS applicant_expected_salary,
--     a.highest_education AS applicant_education_level,
--     a.years_of_experience AS applicant_years_of_experience,
--     a.languages AS applicant_languages,
--     a.applicant_photo AS applicant_photo_url,
--     a.specialization AS applicant_specialization,
--     a.field_of_study AS applicant_field_of_study,
--     a.skills
-- FROM
--     candidates c
-- JOIN
--     applicants a ON c.applicants_id = a.id
-- WHERE
--     c.careers_id =$1 AND 
--     c.application_status!=6
-- ORDER BY candidate_id DESC
-- LIMIT $1
-- OFFSET $2;

-- -- name: GetCountApplicantsForCareerId :one
-- SELECT
--     COUNT(c.id)
-- FROM
--     candidates c
-- JOIN
--     applicants a ON c.applicants_id = a.id
-- JOIN
-- careers car on c.careers_id = car.id
-- WHERE
--     c.careers_id = $1 and c.application_status!=6 and (car.career_status!=6 and car.career_status!=5);

-- -- name: GetCandidateByCareerAndApp :one
-- SELECT * FROM candidates WHERE applicants_id=$1 AND careers_id=$2 AND application_status!=6;

-- -- name: GetEmbeddedApplicantsAndCandidatesForCareerId :many
-- SELECT 
--     sqlc.embed(c) AS candidate,
--     sqlc.embed(a) AS applicant
-- FROM 
--     candidates c
-- JOIN 
--     applicants a ON c.applicants_id = a.id
-- WHERE 
--     c.careers_id = $3 AND c.application_status != 6
-- ORDER BY 
--     c.id DESC
-- LIMIT 
--     $1
-- OFFSET 
--     $2;



