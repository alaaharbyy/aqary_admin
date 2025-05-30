// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: applicants.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createApplicant = `-- name: CreateApplicant :one
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
RETURNING id, full_name, email_address, mobile_number, cv_url, cover_letter, expected_salary, highest_education, years_of_experience, languages, location, gender, applicant_photo, specialization, skills, field_of_study, created_at, status
`

type CreateApplicantParams struct {
	FullName          string        `json:"full_name"`
	EmailAddress      string        `json:"email_address"`
	MobileNumber      string        `json:"mobile_number"`
	CvUrl             string        `json:"cv_url"`
	CoverLetter       pgtype.Text   `json:"cover_letter"`
	ExpectedSalary    pgtype.Float8 `json:"expected_salary"`
	HighestEducation  pgtype.Int8   `json:"highest_education"`
	YearsOfExperience int64         `json:"years_of_experience"`
	Languages         []int64       `json:"languages"`
	Location          string        `json:"location"`
	Gender            int64         `json:"gender"`
	ApplicantPhoto    pgtype.Text   `json:"applicant_photo"`
	Specialization    []int64       `json:"specialization"`
	Skills            []int64       `json:"skills"`
	FieldOfStudy      int64         `json:"field_of_study"`
	CreatedAt         time.Time     `json:"created_at"`
	Status            int64         `json:"status"`
}

func (q *Queries) CreateApplicant(ctx context.Context, arg CreateApplicantParams) (Applicant, error) {
	row := q.db.QueryRow(ctx, createApplicant,
		arg.FullName,
		arg.EmailAddress,
		arg.MobileNumber,
		arg.CvUrl,
		arg.CoverLetter,
		arg.ExpectedSalary,
		arg.HighestEducation,
		arg.YearsOfExperience,
		arg.Languages,
		arg.Location,
		arg.Gender,
		arg.ApplicantPhoto,
		arg.Specialization,
		arg.Skills,
		arg.FieldOfStudy,
		arg.CreatedAt,
		arg.Status,
	)
	var i Applicant
	err := row.Scan(
		&i.ID,
		&i.FullName,
		&i.EmailAddress,
		&i.MobileNumber,
		&i.CvUrl,
		&i.CoverLetter,
		&i.ExpectedSalary,
		&i.HighestEducation,
		&i.YearsOfExperience,
		&i.Languages,
		&i.Location,
		&i.Gender,
		&i.ApplicantPhoto,
		&i.Specialization,
		&i.Skills,
		&i.FieldOfStudy,
		&i.CreatedAt,
		&i.Status,
	)
	return i, err
}

const createApplication = `-- name: CreateApplication :one
INSERT INTO application(
    careers_id, 
    applicant_id, 
    created_at,
    status
)VALUES (
    $1, $2, $3, $4
    )
RETURNING id, careers_id, applicant_id, status, created_at
`

type CreateApplicationParams struct {
	CareersID   int64     `json:"careers_id"`
	ApplicantID int64     `json:"applicant_id"`
	CreatedAt   time.Time `json:"created_at"`
	Status      int32     `json:"status"`
}

func (q *Queries) CreateApplication(ctx context.Context, arg CreateApplicationParams) (Application, error) {
	row := q.db.QueryRow(ctx, createApplication,
		arg.CareersID,
		arg.ApplicantID,
		arg.CreatedAt,
		arg.Status,
	)
	var i Application
	err := row.Scan(
		&i.ID,
		&i.CareersID,
		&i.ApplicantID,
		&i.Status,
		&i.CreatedAt,
	)
	return i, err
}

const getAllApplicants = `-- name: GetAllApplicants :many
SELECT
    applicants.id, applicants.full_name, applicants.email_address, applicants.mobile_number, applicants.cv_url, applicants.cover_letter, applicants.expected_salary, applicants.highest_education, applicants.years_of_experience, applicants.languages, applicants.location, applicants.gender, applicants.applicant_photo, applicants.specialization, applicants.skills, applicants.field_of_study, applicants.created_at, applicants.status
FROM
  applicants
WHERE
    applicants.status!=6 
order by applicants.id
LIMIT $1
OFFSET $2
`

type GetAllApplicantsParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

type GetAllApplicantsRow struct {
	Applicant Applicant `json:"applicant"`
}

func (q *Queries) GetAllApplicants(ctx context.Context, arg GetAllApplicantsParams) ([]GetAllApplicantsRow, error) {
	rows, err := q.db.Query(ctx, getAllApplicants, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAllApplicantsRow
	for rows.Next() {
		var i GetAllApplicantsRow
		if err := rows.Scan(
			&i.Applicant.ID,
			&i.Applicant.FullName,
			&i.Applicant.EmailAddress,
			&i.Applicant.MobileNumber,
			&i.Applicant.CvUrl,
			&i.Applicant.CoverLetter,
			&i.Applicant.ExpectedSalary,
			&i.Applicant.HighestEducation,
			&i.Applicant.YearsOfExperience,
			&i.Applicant.Languages,
			&i.Applicant.Location,
			&i.Applicant.Gender,
			&i.Applicant.ApplicantPhoto,
			&i.Applicant.Specialization,
			&i.Applicant.Skills,
			&i.Applicant.FieldOfStudy,
			&i.Applicant.CreatedAt,
			&i.Applicant.Status,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getAllApplications = `-- name: GetAllApplications :many
SELECT
    applicants.id, applicants.full_name, applicants.email_address, applicants.mobile_number, applicants.cv_url, applicants.cover_letter, applicants.expected_salary, applicants.highest_education, applicants.years_of_experience, applicants.languages, applicants.location, applicants.gender, applicants.applicant_photo, applicants.specialization, applicants.skills, applicants.field_of_study, applicants.created_at, applicants.status,
    application.id, application.careers_id, application.applicant_id, application.status, application.created_at,
    careers.id, careers.ref_no, careers.job_title, careers.job_title_ar, careers.employment_types, careers.employment_mode, careers.job_style, careers.job_categories, careers.career_level, careers.addresses_id, careers.is_urgent, careers.job_description, careers.job_image, careers.number_of_positions, careers.years_of_experience, careers.gender, careers.nationality_id, careers.min_salary, careers.max_salary, careers.languages, careers.uploaded_by, careers.date_expired, careers.career_status, careers.education_level, careers.specialization, careers.skills, careers.global_tagging_id, careers.created_at, careers.updated_at, careers.field_of_study, careers.status, careers.rank
FROM
    application
JOIN applicants on applicants.id=application.applicant_id
JOIN  careers on application.careers_id=careers.id
WHERE 
    (case when $3::bigint=0 then true else careers.id= $3::bigint end)
AND 
    applicants.status!=6 and application.status!=6 and careers.career_status!=6
order by application.id
LIMIT $1
OFFSET $2
`

type GetAllApplicationsParams struct {
	Limit    int32 `json:"limit"`
	Offset   int32 `json:"offset"`
	CareerID int64 `json:"career_id"`
}

type GetAllApplicationsRow struct {
	Applicant   Applicant   `json:"applicant"`
	Application Application `json:"application"`
	Career      Career      `json:"career"`
}

func (q *Queries) GetAllApplications(ctx context.Context, arg GetAllApplicationsParams) ([]GetAllApplicationsRow, error) {
	rows, err := q.db.Query(ctx, getAllApplications, arg.Limit, arg.Offset, arg.CareerID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAllApplicationsRow
	for rows.Next() {
		var i GetAllApplicationsRow
		if err := rows.Scan(
			&i.Applicant.ID,
			&i.Applicant.FullName,
			&i.Applicant.EmailAddress,
			&i.Applicant.MobileNumber,
			&i.Applicant.CvUrl,
			&i.Applicant.CoverLetter,
			&i.Applicant.ExpectedSalary,
			&i.Applicant.HighestEducation,
			&i.Applicant.YearsOfExperience,
			&i.Applicant.Languages,
			&i.Applicant.Location,
			&i.Applicant.Gender,
			&i.Applicant.ApplicantPhoto,
			&i.Applicant.Specialization,
			&i.Applicant.Skills,
			&i.Applicant.FieldOfStudy,
			&i.Applicant.CreatedAt,
			&i.Applicant.Status,
			&i.Application.ID,
			&i.Application.CareersID,
			&i.Application.ApplicantID,
			&i.Application.Status,
			&i.Application.CreatedAt,
			&i.Career.ID,
			&i.Career.RefNo,
			&i.Career.JobTitle,
			&i.Career.JobTitleAr,
			&i.Career.EmploymentTypes,
			&i.Career.EmploymentMode,
			&i.Career.JobStyle,
			&i.Career.JobCategories,
			&i.Career.CareerLevel,
			&i.Career.AddressesID,
			&i.Career.IsUrgent,
			&i.Career.JobDescription,
			&i.Career.JobImage,
			&i.Career.NumberOfPositions,
			&i.Career.YearsOfExperience,
			&i.Career.Gender,
			&i.Career.NationalityID,
			&i.Career.MinSalary,
			&i.Career.MaxSalary,
			&i.Career.Languages,
			&i.Career.UploadedBy,
			&i.Career.DateExpired,
			&i.Career.CareerStatus,
			&i.Career.EducationLevel,
			&i.Career.Specialization,
			&i.Career.Skills,
			&i.Career.GlobalTaggingID,
			&i.Career.CreatedAt,
			&i.Career.UpdatedAt,
			&i.Career.FieldOfStudy,
			&i.Career.Status,
			&i.Career.Rank,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getApplicantByID = `-- name: GetApplicantByID :one
SELECT
    app.id, app.full_name, app.email_address, app.mobile_number, app.cv_url, app.cover_letter, app.expected_salary, app.highest_education, app.years_of_experience, app.languages, app.location, app.gender, app.applicant_photo, app.specialization, app.skills, app.field_of_study, app.created_at, app.status,
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
GROUP BY app.id
`

type GetApplicantByIDRow struct {
	ID                int64         `json:"id"`
	FullName          string        `json:"full_name"`
	EmailAddress      string        `json:"email_address"`
	MobileNumber      string        `json:"mobile_number"`
	CvUrl             string        `json:"cv_url"`
	CoverLetter       pgtype.Text   `json:"cover_letter"`
	ExpectedSalary    pgtype.Float8 `json:"expected_salary"`
	HighestEducation  pgtype.Int8   `json:"highest_education"`
	YearsOfExperience int64         `json:"years_of_experience"`
	Languages         []int64       `json:"languages"`
	Location          string        `json:"location"`
	Gender            int64         `json:"gender"`
	ApplicantPhoto    pgtype.Text   `json:"applicant_photo"`
	Specialization    []int64       `json:"specialization"`
	Skills            []int64       `json:"skills"`
	FieldOfStudy      int64         `json:"field_of_study"`
	CreatedAt         time.Time     `json:"created_at"`
	Status            int64         `json:"status"`
	LangsIds          []int64       `json:"langs_ids"`
	Langs             []string      `json:"langs"`
	SpecsIds          []int64       `json:"specs_ids"`
	SpecsNames        []string      `json:"specs_names"`
	SkillsIds         []int64       `json:"skills_ids"`
	Skills_2          []string      `json:"skills_2"`
}

func (q *Queries) GetApplicantByID(ctx context.Context, id int64) (GetApplicantByIDRow, error) {
	row := q.db.QueryRow(ctx, getApplicantByID, id)
	var i GetApplicantByIDRow
	err := row.Scan(
		&i.ID,
		&i.FullName,
		&i.EmailAddress,
		&i.MobileNumber,
		&i.CvUrl,
		&i.CoverLetter,
		&i.ExpectedSalary,
		&i.HighestEducation,
		&i.YearsOfExperience,
		&i.Languages,
		&i.Location,
		&i.Gender,
		&i.ApplicantPhoto,
		&i.Specialization,
		&i.Skills,
		&i.FieldOfStudy,
		&i.CreatedAt,
		&i.Status,
		&i.LangsIds,
		&i.Langs,
		&i.SpecsIds,
		&i.SpecsNames,
		&i.SkillsIds,
		&i.Skills_2,
	)
	return i, err
}

const getApplication = `-- name: GetApplication :one
SELECT id, careers_id, applicant_id, status, created_at FROM application where id=$1
`

func (q *Queries) GetApplication(ctx context.Context, id int64) (Application, error) {
	row := q.db.QueryRow(ctx, getApplication, id)
	var i Application
	err := row.Scan(
		&i.ID,
		&i.CareersID,
		&i.ApplicantID,
		&i.Status,
		&i.CreatedAt,
	)
	return i, err
}

const getApplicationCount = `-- name: GetApplicationCount :one
SELECT
   count(application)
FROM
    application
JOIN applicants on applicants.id=application.applicant_id
JOIN  careers on application.careers_id=careers.id
WHERE 
    (case when $1::bigint=0 then true else careers.id= $1::bigint end)
AND 
    applicants.status!=6 and application.status!=6 and careers.career_status!=6
`

func (q *Queries) GetApplicationCount(ctx context.Context, careerID int64) (int64, error) {
	row := q.db.QueryRow(ctx, getApplicationCount, careerID)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const updateApplicantStaus = `-- name: UpdateApplicantStaus :one
UPDATE applicants SET
    status=$1
WHERE id=$2
RETURNING id, full_name, email_address, mobile_number, cv_url, cover_letter, expected_salary, highest_education, years_of_experience, languages, location, gender, applicant_photo, specialization, skills, field_of_study, created_at, status
`

type UpdateApplicantStausParams struct {
	Status int64 `json:"status"`
	ID     int64 `json:"id"`
}

func (q *Queries) UpdateApplicantStaus(ctx context.Context, arg UpdateApplicantStausParams) (Applicant, error) {
	row := q.db.QueryRow(ctx, updateApplicantStaus, arg.Status, arg.ID)
	var i Applicant
	err := row.Scan(
		&i.ID,
		&i.FullName,
		&i.EmailAddress,
		&i.MobileNumber,
		&i.CvUrl,
		&i.CoverLetter,
		&i.ExpectedSalary,
		&i.HighestEducation,
		&i.YearsOfExperience,
		&i.Languages,
		&i.Location,
		&i.Gender,
		&i.ApplicantPhoto,
		&i.Specialization,
		&i.Skills,
		&i.FieldOfStudy,
		&i.CreatedAt,
		&i.Status,
	)
	return i, err
}

const updateApplicationStaus = `-- name: UpdateApplicationStaus :one
UPDATE application SET
    status=$1
WHERE id=$2
RETURNING id, careers_id, applicant_id, status, created_at
`

type UpdateApplicationStausParams struct {
	Status int32 `json:"status"`
	ID     int64 `json:"id"`
}

func (q *Queries) UpdateApplicationStaus(ctx context.Context, arg UpdateApplicationStausParams) (Application, error) {
	row := q.db.QueryRow(ctx, updateApplicationStaus, arg.Status, arg.ID)
	var i Application
	err := row.Scan(
		&i.ID,
		&i.CareersID,
		&i.ApplicantID,
		&i.Status,
		&i.CreatedAt,
	)
	return i, err
}
