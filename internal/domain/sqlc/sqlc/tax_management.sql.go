// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: tax_management.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createTaxMangement = `-- name: CreateTaxMangement :one
INSERT INTO tax_management (
  ref_no,
  company_types_id,
  companies_id,
  countries_id,
  states_id,
  tax_code,
  tax_category_id,
  tax_category_type,
  tax_title,
  tax_percentage,
  is_branch,
  created_by)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) RETURNING id, ref_no, company_types_id, companies_id, countries_id, states_id, tax_code, tax_category_id, tax_category_type, tax_title, tax_percentage, created_at, updated_at, is_branch, created_by
`

type CreateTaxMangementParams struct {
	RefNo           string      `json:"ref_no"`
	CompanyTypesID  int64       `json:"company_types_id"`
	CompaniesID     int64       `json:"companies_id"`
	CountriesID     pgtype.Int8 `json:"countries_id"`
	StatesID        pgtype.Int8 `json:"states_id"`
	TaxCode         string      `json:"tax_code"`
	TaxCategoryID   pgtype.Int8 `json:"tax_category_id"`
	TaxCategoryType int64       `json:"tax_category_type"`
	TaxTitle        string      `json:"tax_title"`
	TaxPercentage   float64     `json:"tax_percentage"`
	IsBranch        pgtype.Bool `json:"is_branch"`
	CreatedBy       int64       `json:"created_by"`
}

func (q *Queries) CreateTaxMangement(ctx context.Context, arg CreateTaxMangementParams) (TaxManagement, error) {
	row := q.db.QueryRow(ctx, createTaxMangement,
		arg.RefNo,
		arg.CompanyTypesID,
		arg.CompaniesID,
		arg.CountriesID,
		arg.StatesID,
		arg.TaxCode,
		arg.TaxCategoryID,
		arg.TaxCategoryType,
		arg.TaxTitle,
		arg.TaxPercentage,
		arg.IsBranch,
		arg.CreatedBy,
	)
	var i TaxManagement
	err := row.Scan(
		&i.ID,
		&i.RefNo,
		&i.CompanyTypesID,
		&i.CompaniesID,
		&i.CountriesID,
		&i.StatesID,
		&i.TaxCode,
		&i.TaxCategoryID,
		&i.TaxCategoryType,
		&i.TaxTitle,
		&i.TaxPercentage,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.IsBranch,
		&i.CreatedBy,
	)
	return i, err
}

const deleteTaxMangement = `-- name: DeleteTaxMangement :exec
DELETE FROM tax_management where id = $1
`

func (q *Queries) DeleteTaxMangement(ctx context.Context, id int64) error {
	_, err := q.db.Exec(ctx, deleteTaxMangement, id)
	return err
}

const getAllTaxMangement = `-- name: GetAllTaxMangement :many
SELECT id, ref_no, company_types_id, companies_id, countries_id, states_id, tax_code, tax_category_id, tax_category_type, tax_title, tax_percentage, created_at, updated_at, is_branch, created_by FROM tax_management
`

func (q *Queries) GetAllTaxMangement(ctx context.Context) ([]TaxManagement, error) {
	rows, err := q.db.Query(ctx, getAllTaxMangement)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []TaxManagement
	for rows.Next() {
		var i TaxManagement
		if err := rows.Scan(
			&i.ID,
			&i.RefNo,
			&i.CompanyTypesID,
			&i.CompaniesID,
			&i.CountriesID,
			&i.StatesID,
			&i.TaxCode,
			&i.TaxCategoryID,
			&i.TaxCategoryType,
			&i.TaxTitle,
			&i.TaxPercentage,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.IsBranch,
			&i.CreatedBy,
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

const getAllTaxMangementByCategoryType = `-- name: GetAllTaxMangementByCategoryType :many
SELECT id, ref_no, company_types_id, companies_id, countries_id, states_id, tax_code, tax_category_id, tax_category_type, tax_title, tax_percentage, created_at, updated_at, is_branch, created_by FROM tax_management WHERE tax_category_type = $1
`

func (q *Queries) GetAllTaxMangementByCategoryType(ctx context.Context, taxCategoryType int64) ([]TaxManagement, error) {
	rows, err := q.db.Query(ctx, getAllTaxMangementByCategoryType, taxCategoryType)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []TaxManagement
	for rows.Next() {
		var i TaxManagement
		if err := rows.Scan(
			&i.ID,
			&i.RefNo,
			&i.CompanyTypesID,
			&i.CompaniesID,
			&i.CountriesID,
			&i.StatesID,
			&i.TaxCode,
			&i.TaxCategoryID,
			&i.TaxCategoryType,
			&i.TaxTitle,
			&i.TaxPercentage,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.IsBranch,
			&i.CreatedBy,
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

const getAllTaxMangementWithPg = `-- name: GetAllTaxMangementWithPg :many
SELECT id, ref_no, company_types_id, companies_id, countries_id, states_id, tax_code, tax_category_id, tax_category_type, tax_title, tax_percentage, created_at, updated_at, is_branch, created_by FROM tax_management LIMIT $1 OFFSET $2
`

type GetAllTaxMangementWithPgParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) GetAllTaxMangementWithPg(ctx context.Context, arg GetAllTaxMangementWithPgParams) ([]TaxManagement, error) {
	rows, err := q.db.Query(ctx, getAllTaxMangementWithPg, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []TaxManagement
	for rows.Next() {
		var i TaxManagement
		if err := rows.Scan(
			&i.ID,
			&i.RefNo,
			&i.CompanyTypesID,
			&i.CompaniesID,
			&i.CountriesID,
			&i.StatesID,
			&i.TaxCode,
			&i.TaxCategoryID,
			&i.TaxCategoryType,
			&i.TaxTitle,
			&i.TaxPercentage,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.IsBranch,
			&i.CreatedBy,
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

const getCountAllTaxMangement = `-- name: GetCountAllTaxMangement :many
SELECT Count(*) FROM tax_management
`

func (q *Queries) GetCountAllTaxMangement(ctx context.Context) ([]int64, error) {
	rows, err := q.db.Query(ctx, getCountAllTaxMangement)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []int64
	for rows.Next() {
		var count int64
		if err := rows.Scan(&count); err != nil {
			return nil, err
		}
		items = append(items, count)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getCountAllTaxMangementByCategoryType = `-- name: GetCountAllTaxMangementByCategoryType :many
SELECT Count(*) FROM tax_management WHERE tax_category_type = $1
`

func (q *Queries) GetCountAllTaxMangementByCategoryType(ctx context.Context, taxCategoryType int64) ([]int64, error) {
	rows, err := q.db.Query(ctx, getCountAllTaxMangementByCategoryType, taxCategoryType)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []int64
	for rows.Next() {
		var count int64
		if err := rows.Scan(&count); err != nil {
			return nil, err
		}
		items = append(items, count)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getTaxMangementById = `-- name: GetTaxMangementById :one
SELECT id, ref_no, company_types_id, companies_id, countries_id, states_id, tax_code, tax_category_id, tax_category_type, tax_title, tax_percentage, created_at, updated_at, is_branch, created_by FROM tax_management WHERE id = $1
`

func (q *Queries) GetTaxMangementById(ctx context.Context, id int64) (TaxManagement, error) {
	row := q.db.QueryRow(ctx, getTaxMangementById, id)
	var i TaxManagement
	err := row.Scan(
		&i.ID,
		&i.RefNo,
		&i.CompanyTypesID,
		&i.CompaniesID,
		&i.CountriesID,
		&i.StatesID,
		&i.TaxCode,
		&i.TaxCategoryID,
		&i.TaxCategoryType,
		&i.TaxTitle,
		&i.TaxPercentage,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.IsBranch,
		&i.CreatedBy,
	)
	return i, err
}

const updateTaxMangement = `-- name: UpdateTaxMangement :one
UPDATE tax_management 
SET
   ref_no = $1, 
   company_types_id = $2,
   companies_id = $3,
   countries_id = $4, 
   states_id = $5,
   tax_code = $6,
   tax_category_id = $7,
   tax_category_type = $8,
   tax_title = $9,
   tax_percentage = $10,
   updated_at = $11,
   is_branch = $12
WHERE id = $13
RETURNING id, ref_no, company_types_id, companies_id, countries_id, states_id, tax_code, tax_category_id, tax_category_type, tax_title, tax_percentage, created_at, updated_at, is_branch, created_by
`

type UpdateTaxMangementParams struct {
	RefNo           string      `json:"ref_no"`
	CompanyTypesID  int64       `json:"company_types_id"`
	CompaniesID     int64       `json:"companies_id"`
	CountriesID     pgtype.Int8 `json:"countries_id"`
	StatesID        pgtype.Int8 `json:"states_id"`
	TaxCode         string      `json:"tax_code"`
	TaxCategoryID   pgtype.Int8 `json:"tax_category_id"`
	TaxCategoryType int64       `json:"tax_category_type"`
	TaxTitle        string      `json:"tax_title"`
	TaxPercentage   float64     `json:"tax_percentage"`
	UpdatedAt       time.Time   `json:"updated_at"`
	IsBranch        pgtype.Bool `json:"is_branch"`
	ID              int64       `json:"id"`
}

func (q *Queries) UpdateTaxMangement(ctx context.Context, arg UpdateTaxMangementParams) (TaxManagement, error) {
	row := q.db.QueryRow(ctx, updateTaxMangement,
		arg.RefNo,
		arg.CompanyTypesID,
		arg.CompaniesID,
		arg.CountriesID,
		arg.StatesID,
		arg.TaxCode,
		arg.TaxCategoryID,
		arg.TaxCategoryType,
		arg.TaxTitle,
		arg.TaxPercentage,
		arg.UpdatedAt,
		arg.IsBranch,
		arg.ID,
	)
	var i TaxManagement
	err := row.Scan(
		&i.ID,
		&i.RefNo,
		&i.CompanyTypesID,
		&i.CompaniesID,
		&i.CountriesID,
		&i.StatesID,
		&i.TaxCode,
		&i.TaxCategoryID,
		&i.TaxCategoryType,
		&i.TaxTitle,
		&i.TaxPercentage,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.IsBranch,
		&i.CreatedBy,
	)
	return i, err
}
