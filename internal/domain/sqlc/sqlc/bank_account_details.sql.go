// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: bank_account_details.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createBankAccountDetails = `-- name: CreateBankAccountDetails :one
INSERT INTO bank_account_details(
    account_name,
    account_number,
    iban,
    countries_id,
    currency_id,
    bank_name,
    bank_branch,
    swift_code,
    created_at,
    entity_type_id,
    entity_id
) VALUES(
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11
)RETURNING id, account_name, account_number, iban, countries_id, currency_id, bank_name, bank_branch, swift_code, created_at, updated_at, entity_type_id, entity_id, updated_by
`

type CreateBankAccountDetailsParams struct {
	AccountName   string    `json:"account_name"`
	AccountNumber string    `json:"account_number"`
	Iban          string    `json:"iban"`
	CountriesID   int64     `json:"countries_id"`
	CurrencyID    int64     `json:"currency_id"`
	BankName      string    `json:"bank_name"`
	BankBranch    string    `json:"bank_branch"`
	SwiftCode     string    `json:"swift_code"`
	CreatedAt     time.Time `json:"created_at"`
	EntityTypeID  int64     `json:"entity_type_id"`
	EntityID      int64     `json:"entity_id"`
}

func (q *Queries) CreateBankAccountDetails(ctx context.Context, arg CreateBankAccountDetailsParams) (BankAccountDetail, error) {
	row := q.db.QueryRow(ctx, createBankAccountDetails,
		arg.AccountName,
		arg.AccountNumber,
		arg.Iban,
		arg.CountriesID,
		arg.CurrencyID,
		arg.BankName,
		arg.BankBranch,
		arg.SwiftCode,
		arg.CreatedAt,
		arg.EntityTypeID,
		arg.EntityID,
	)
	var i BankAccountDetail
	err := row.Scan(
		&i.ID,
		&i.AccountName,
		&i.AccountNumber,
		&i.Iban,
		&i.CountriesID,
		&i.CurrencyID,
		&i.BankName,
		&i.BankBranch,
		&i.SwiftCode,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.EntityTypeID,
		&i.EntityID,
		&i.UpdatedBy,
	)
	return i, err
}

const deleteBankAccountDetails = `-- name: DeleteBankAccountDetails :exec
DELETE FROM bank_account_details
WHERE id = $1
`

func (q *Queries) DeleteBankAccountDetails(ctx context.Context, id int64) error {
	_, err := q.db.Exec(ctx, deleteBankAccountDetails, id)
	return err
}

const getCompanyBankAccountDetails = `-- name: GetCompanyBankAccountDetails :one
SELECT id, account_name, account_number, iban, countries_id, currency_id, bank_name, bank_branch, swift_code, created_at, updated_at, entity_type_id, entity_id, updated_by FROM bank_account_details
WHERE entity_type_id = 6 AND entity_id = $1
`

func (q *Queries) GetCompanyBankAccountDetails(ctx context.Context, companyID int64) (BankAccountDetail, error) {
	row := q.db.QueryRow(ctx, getCompanyBankAccountDetails, companyID)
	var i BankAccountDetail
	err := row.Scan(
		&i.ID,
		&i.AccountName,
		&i.AccountNumber,
		&i.Iban,
		&i.CountriesID,
		&i.CurrencyID,
		&i.BankName,
		&i.BankBranch,
		&i.SwiftCode,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.EntityTypeID,
		&i.EntityID,
		&i.UpdatedBy,
	)
	return i, err
}

const getUserBankAccountDetails = `-- name: GetUserBankAccountDetails :one
SELECT id, account_name, account_number, iban, countries_id, currency_id, bank_name, bank_branch, swift_code, created_at, updated_at, entity_type_id, entity_id, updated_by FROM bank_account_details
WHERE entity_type_id = 9 AND entity_id = $1
`

func (q *Queries) GetUserBankAccountDetails(ctx context.Context, userID int64) (BankAccountDetail, error) {
	row := q.db.QueryRow(ctx, getUserBankAccountDetails, userID)
	var i BankAccountDetail
	err := row.Scan(
		&i.ID,
		&i.AccountName,
		&i.AccountNumber,
		&i.Iban,
		&i.CountriesID,
		&i.CurrencyID,
		&i.BankName,
		&i.BankBranch,
		&i.SwiftCode,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.EntityTypeID,
		&i.EntityID,
		&i.UpdatedBy,
	)
	return i, err
}

const updateBankAccountDetails = `-- name: UpdateBankAccountDetails :one
UPDATE bank_account_details
SET account_name = $2,
    account_number = $3,
    iban = $4,
    countries_id = $5,
    currency_id = $6,
    bank_name = $7,
    bank_branch = $8,
    swift_code = $9,
    updated_at = $10,
    updated_by = $11
WHERE id = $1 
RETURNING id, account_name, account_number, iban, countries_id, currency_id, bank_name, bank_branch, swift_code, created_at, updated_at, entity_type_id, entity_id, updated_by
`

type UpdateBankAccountDetailsParams struct {
	ID            int64       `json:"id"`
	AccountName   string      `json:"account_name"`
	AccountNumber string      `json:"account_number"`
	Iban          string      `json:"iban"`
	CountriesID   int64       `json:"countries_id"`
	CurrencyID    int64       `json:"currency_id"`
	BankName      string      `json:"bank_name"`
	BankBranch    string      `json:"bank_branch"`
	SwiftCode     string      `json:"swift_code"`
	UpdatedAt     time.Time   `json:"updated_at"`
	UpdatedBy     pgtype.Int8 `json:"updated_by"`
}

func (q *Queries) UpdateBankAccountDetails(ctx context.Context, arg UpdateBankAccountDetailsParams) (BankAccountDetail, error) {
	row := q.db.QueryRow(ctx, updateBankAccountDetails,
		arg.ID,
		arg.AccountName,
		arg.AccountNumber,
		arg.Iban,
		arg.CountriesID,
		arg.CurrencyID,
		arg.BankName,
		arg.BankBranch,
		arg.SwiftCode,
		arg.UpdatedAt,
		arg.UpdatedBy,
	)
	var i BankAccountDetail
	err := row.Scan(
		&i.ID,
		&i.AccountName,
		&i.AccountNumber,
		&i.Iban,
		&i.CountriesID,
		&i.CurrencyID,
		&i.BankName,
		&i.BankBranch,
		&i.SwiftCode,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.EntityTypeID,
		&i.EntityID,
		&i.UpdatedBy,
	)
	return i, err
}

const updateBankAccountDetailsByEntityID = `-- name: UpdateBankAccountDetailsByEntityID :one
UPDATE bank_account_details
SET account_name = $2,
    account_number = $3,
    iban = $4,
    countries_id = $5,
    currency_id = $6,
    bank_name = $7,
    bank_branch = $8,
    swift_code = $9,
    updated_at = $10,
    updated_by = $11
WHERE  entity_type_id = 9 AND  entity_id = $1 
RETURNING id, account_name, account_number, iban, countries_id, currency_id, bank_name, bank_branch, swift_code, created_at, updated_at, entity_type_id, entity_id, updated_by
`

type UpdateBankAccountDetailsByEntityIDParams struct {
	EntityID      int64       `json:"entity_id"`
	AccountName   string      `json:"account_name"`
	AccountNumber string      `json:"account_number"`
	Iban          string      `json:"iban"`
	CountriesID   int64       `json:"countries_id"`
	CurrencyID    int64       `json:"currency_id"`
	BankName      string      `json:"bank_name"`
	BankBranch    string      `json:"bank_branch"`
	SwiftCode     string      `json:"swift_code"`
	UpdatedAt     time.Time   `json:"updated_at"`
	UpdatedBy     pgtype.Int8 `json:"updated_by"`
}

func (q *Queries) UpdateBankAccountDetailsByEntityID(ctx context.Context, arg UpdateBankAccountDetailsByEntityIDParams) (BankAccountDetail, error) {
	row := q.db.QueryRow(ctx, updateBankAccountDetailsByEntityID,
		arg.EntityID,
		arg.AccountName,
		arg.AccountNumber,
		arg.Iban,
		arg.CountriesID,
		arg.CurrencyID,
		arg.BankName,
		arg.BankBranch,
		arg.SwiftCode,
		arg.UpdatedAt,
		arg.UpdatedBy,
	)
	var i BankAccountDetail
	err := row.Scan(
		&i.ID,
		&i.AccountName,
		&i.AccountNumber,
		&i.Iban,
		&i.CountriesID,
		&i.CurrencyID,
		&i.BankName,
		&i.BankBranch,
		&i.SwiftCode,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.EntityTypeID,
		&i.EntityID,
		&i.UpdatedBy,
	)
	return i, err
}
