// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: contacts_company_details.sql

package sqlc

import (
	"context"

	"github.com/jackc/pgx/v5/pgtype"
)

const createContactsCompanyDetails = `-- name: CreateContactsCompanyDetails :one
INSERT INTO contacts_company_details (
    contacts_id,
    companies_id,
    company_category,
    is_branch,
    no_of_employees,
    industry_id,
    no_local_business,
    retail_category_id,
    no_remote_business,
    nationality,
    license,
    issued_date,
    expiry_date,
    external_id
) VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10,
    $11,
    $12,
    $13,
    $14
) RETURNING id, contacts_id, companies_id, company_category, is_branch, no_of_employees, industry_id, no_local_business, retail_category_id, no_remote_business, nationality, license, issued_date, expiry_date, external_id
`

type CreateContactsCompanyDetailsParams struct {
	ContactsID       int64              `json:"contacts_id"`
	CompaniesID      int64              `json:"companies_id"`
	CompanyCategory  int64              `json:"company_category"`
	IsBranch         pgtype.Bool        `json:"is_branch"`
	NoOfEmployees    pgtype.Int8        `json:"no_of_employees"`
	IndustryID       pgtype.Int8        `json:"industry_id"`
	NoLocalBusiness  pgtype.Int8        `json:"no_local_business"`
	RetailCategoryID pgtype.Int8        `json:"retail_category_id"`
	NoRemoteBusiness pgtype.Int8        `json:"no_remote_business"`
	Nationality      pgtype.Int8        `json:"nationality"`
	License          pgtype.Text        `json:"license"`
	IssuedDate       pgtype.Timestamptz `json:"issued_date"`
	ExpiryDate       pgtype.Timestamptz `json:"expiry_date"`
	ExternalID       pgtype.Text        `json:"external_id"`
}

func (q *Queries) CreateContactsCompanyDetails(ctx context.Context, arg CreateContactsCompanyDetailsParams) (ContactsCompanyDetail, error) {
	row := q.db.QueryRow(ctx, createContactsCompanyDetails,
		arg.ContactsID,
		arg.CompaniesID,
		arg.CompanyCategory,
		arg.IsBranch,
		arg.NoOfEmployees,
		arg.IndustryID,
		arg.NoLocalBusiness,
		arg.RetailCategoryID,
		arg.NoRemoteBusiness,
		arg.Nationality,
		arg.License,
		arg.IssuedDate,
		arg.ExpiryDate,
		arg.ExternalID,
	)
	var i ContactsCompanyDetail
	err := row.Scan(
		&i.ID,
		&i.ContactsID,
		&i.CompaniesID,
		&i.CompanyCategory,
		&i.IsBranch,
		&i.NoOfEmployees,
		&i.IndustryID,
		&i.NoLocalBusiness,
		&i.RetailCategoryID,
		&i.NoRemoteBusiness,
		&i.Nationality,
		&i.License,
		&i.IssuedDate,
		&i.ExpiryDate,
		&i.ExternalID,
	)
	return i, err
}

const getSingleContactCompanyDetails = `-- name: GetSingleContactCompanyDetails :one
select id, contacts_id, companies_id, company_category, is_branch, no_of_employees, industry_id, no_local_business, retail_category_id, no_remote_business, nationality, license, issued_date, expiry_date, external_id from contacts_company_details where contacts_id = $1 LIMIT 1
`

func (q *Queries) GetSingleContactCompanyDetails(ctx context.Context, contactsID int64) (ContactsCompanyDetail, error) {
	row := q.db.QueryRow(ctx, getSingleContactCompanyDetails, contactsID)
	var i ContactsCompanyDetail
	err := row.Scan(
		&i.ID,
		&i.ContactsID,
		&i.CompaniesID,
		&i.CompanyCategory,
		&i.IsBranch,
		&i.NoOfEmployees,
		&i.IndustryID,
		&i.NoLocalBusiness,
		&i.RetailCategoryID,
		&i.NoRemoteBusiness,
		&i.Nationality,
		&i.License,
		&i.IssuedDate,
		&i.ExpiryDate,
		&i.ExternalID,
	)
	return i, err
}

const insertContactsCompanyDetails = `-- name: InsertContactsCompanyDetails :one
INSERT INTO contacts_company_details (
    contacts_id,
    -- company_id,
    -- which_company,
    no_of_employees,
    industry_id,
    -- which_property,
    no_local_business,
    retail_category_id,
    no_remote_business,
    nationality,
    license,
    issued_date,
    expiry_date,
    external_id
)
VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11
    --  $12
    -- $13
    -- $14
)
RETURNING id, contacts_id, companies_id, company_category, is_branch, no_of_employees, industry_id, no_local_business, retail_category_id, no_remote_business, nationality, license, issued_date, expiry_date, external_id
`

type InsertContactsCompanyDetailsParams struct {
	ContactsID       int64              `json:"contacts_id"`
	NoOfEmployees    pgtype.Int8        `json:"no_of_employees"`
	IndustryID       pgtype.Int8        `json:"industry_id"`
	NoLocalBusiness  pgtype.Int8        `json:"no_local_business"`
	RetailCategoryID pgtype.Int8        `json:"retail_category_id"`
	NoRemoteBusiness pgtype.Int8        `json:"no_remote_business"`
	Nationality      pgtype.Int8        `json:"nationality"`
	License          pgtype.Text        `json:"license"`
	IssuedDate       pgtype.Timestamptz `json:"issued_date"`
	ExpiryDate       pgtype.Timestamptz `json:"expiry_date"`
	ExternalID       pgtype.Text        `json:"external_id"`
}

func (q *Queries) InsertContactsCompanyDetails(ctx context.Context, arg InsertContactsCompanyDetailsParams) (ContactsCompanyDetail, error) {
	row := q.db.QueryRow(ctx, insertContactsCompanyDetails,
		arg.ContactsID,
		arg.NoOfEmployees,
		arg.IndustryID,
		arg.NoLocalBusiness,
		arg.RetailCategoryID,
		arg.NoRemoteBusiness,
		arg.Nationality,
		arg.License,
		arg.IssuedDate,
		arg.ExpiryDate,
		arg.ExternalID,
	)
	var i ContactsCompanyDetail
	err := row.Scan(
		&i.ID,
		&i.ContactsID,
		&i.CompaniesID,
		&i.CompanyCategory,
		&i.IsBranch,
		&i.NoOfEmployees,
		&i.IndustryID,
		&i.NoLocalBusiness,
		&i.RetailCategoryID,
		&i.NoRemoteBusiness,
		&i.Nationality,
		&i.License,
		&i.IssuedDate,
		&i.ExpiryDate,
		&i.ExternalID,
	)
	return i, err
}

const updateContactsCompanyDetails = `-- name: UpdateContactsCompanyDetails :one
UPDATE contacts_company_details
SET
    companies_id = $2,
    company_category = $3,
    is_branch = $4,
    no_of_employees = $5,
    industry_id = $6,
    no_local_business = $7,
    retail_category_id = $8,
    no_remote_business = $9,
    nationality = $10,
    license = $11,
    issued_date = $12,
    expiry_date = $13,
    external_id = $14
WHERE
    contacts_id = $1
RETURNING id, contacts_id, companies_id, company_category, is_branch, no_of_employees, industry_id, no_local_business, retail_category_id, no_remote_business, nationality, license, issued_date, expiry_date, external_id
`

type UpdateContactsCompanyDetailsParams struct {
	ContactsID       int64              `json:"contacts_id"`
	CompaniesID      int64              `json:"companies_id"`
	CompanyCategory  int64              `json:"company_category"`
	IsBranch         pgtype.Bool        `json:"is_branch"`
	NoOfEmployees    pgtype.Int8        `json:"no_of_employees"`
	IndustryID       pgtype.Int8        `json:"industry_id"`
	NoLocalBusiness  pgtype.Int8        `json:"no_local_business"`
	RetailCategoryID pgtype.Int8        `json:"retail_category_id"`
	NoRemoteBusiness pgtype.Int8        `json:"no_remote_business"`
	Nationality      pgtype.Int8        `json:"nationality"`
	License          pgtype.Text        `json:"license"`
	IssuedDate       pgtype.Timestamptz `json:"issued_date"`
	ExpiryDate       pgtype.Timestamptz `json:"expiry_date"`
	ExternalID       pgtype.Text        `json:"external_id"`
}

func (q *Queries) UpdateContactsCompanyDetails(ctx context.Context, arg UpdateContactsCompanyDetailsParams) (ContactsCompanyDetail, error) {
	row := q.db.QueryRow(ctx, updateContactsCompanyDetails,
		arg.ContactsID,
		arg.CompaniesID,
		arg.CompanyCategory,
		arg.IsBranch,
		arg.NoOfEmployees,
		arg.IndustryID,
		arg.NoLocalBusiness,
		arg.RetailCategoryID,
		arg.NoRemoteBusiness,
		arg.Nationality,
		arg.License,
		arg.IssuedDate,
		arg.ExpiryDate,
		arg.ExternalID,
	)
	var i ContactsCompanyDetail
	err := row.Scan(
		&i.ID,
		&i.ContactsID,
		&i.CompaniesID,
		&i.CompanyCategory,
		&i.IsBranch,
		&i.NoOfEmployees,
		&i.IndustryID,
		&i.NoLocalBusiness,
		&i.RetailCategoryID,
		&i.NoRemoteBusiness,
		&i.Nationality,
		&i.License,
		&i.IssuedDate,
		&i.ExpiryDate,
		&i.ExternalID,
	)
	return i, err
}
