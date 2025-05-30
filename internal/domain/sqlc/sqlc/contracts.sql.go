// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: contracts.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createContracts = `-- name: CreateContracts :one
INSERT INTO contracts(
    company_type,
    company_id,
    is_branch,
    file_url,
    created_at,
    updated_at,
    status
)VALUES(
    $1, $2, $3, $4, $5, $6, $7
)RETURNING id, company_type, company_id, is_branch, file_url, created_at, updated_at, status
`

type CreateContractsParams struct {
	CompanyType int64       `json:"company_type"`
	CompanyID   int64       `json:"company_id"`
	IsBranch    pgtype.Bool `json:"is_branch"`
	FileUrl     string      `json:"file_url"`
	CreatedAt   time.Time   `json:"created_at"`
	UpdatedAt   time.Time   `json:"updated_at"`
	Status      int64       `json:"status"`
}

func (q *Queries) CreateContracts(ctx context.Context, arg CreateContractsParams) (Contract, error) {
	row := q.db.QueryRow(ctx, createContracts,
		arg.CompanyType,
		arg.CompanyID,
		arg.IsBranch,
		arg.FileUrl,
		arg.CreatedAt,
		arg.UpdatedAt,
		arg.Status,
	)
	var i Contract
	err := row.Scan(
		&i.ID,
		&i.CompanyType,
		&i.CompanyID,
		&i.IsBranch,
		&i.FileUrl,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.Status,
	)
	return i, err
}

const getAllContracts = `-- name: GetAllContracts :many
SELECT COUNT(contracts.*) OVER() AS total_count, 
contracts.id, contracts.company_type, contracts.company_id, contracts.is_branch, contracts.file_url, contracts.created_at, contracts.updated_at, contracts.status,
COALESCE(
    CASE 
        WHEN contracts.company_type = 1 AND contracts.is_branch = FALSE THEN broker_companies.company_name
        WHEN contracts.company_type = 1 AND contracts.is_branch = TRUE THEN broker_companies_branches.company_name
        WHEN contracts.company_type = 2 AND contracts.is_branch = FALSE THEN developer_companies.company_name
        WHEN contracts.company_type = 2 AND contracts.is_branch = TRUE THEN developer_company_branches.company_name
        WHEN contracts.company_type = 3 AND contracts.is_branch = FALSE THEN services_companies.company_name
        WHEN contracts.company_type = 3 AND contracts.is_branch = TRUE THEN service_company_branches.company_name
    END, '')::VARCHAR AS company_name
FROM contracts 
LEFT JOIN broker_companies ON broker_companies.id = contracts.company_id AND contracts.company_type = 1 AND contracts.is_branch = FALSE
LEFT JOIN broker_companies_branches ON broker_companies_branches.id = contracts.company_id AND contracts.company_type = 1 AND contracts.is_branch = TRUE
LEFT JOIN developer_companies ON developer_companies.id = contracts.company_id AND contracts.company_type = 2 AND contracts.is_branch = FALSE
LEFT JOIN developer_company_branches ON developer_company_branches.id = contracts.company_id AND contracts.company_type = 2 AND contracts.is_branch = TRUE
LEFT JOIN services_companies ON services_companies.id = contracts.company_id AND contracts.company_type = 3 AND contracts.is_branch = FALSE
LEFT JOIN service_company_branches ON service_company_branches.id = contracts.company_id AND contracts.company_type = 3 AND contracts.is_branch = TRUE
WHERE contracts.status NOT IN (5, 6)
ORDER BY created_at DESC
LIMIT $1 OFFSET $2
`

type GetAllContractsParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

type GetAllContractsRow struct {
	TotalCount  int64       `json:"total_count"`
	ID          int64       `json:"id"`
	CompanyType int64       `json:"company_type"`
	CompanyID   int64       `json:"company_id"`
	IsBranch    pgtype.Bool `json:"is_branch"`
	FileUrl     string      `json:"file_url"`
	CreatedAt   time.Time   `json:"created_at"`
	UpdatedAt   time.Time   `json:"updated_at"`
	Status      int64       `json:"status"`
	CompanyName string      `json:"company_name"`
}

func (q *Queries) GetAllContracts(ctx context.Context, arg GetAllContractsParams) ([]GetAllContractsRow, error) {
	rows, err := q.db.Query(ctx, getAllContracts, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAllContractsRow
	for rows.Next() {
		var i GetAllContractsRow
		if err := rows.Scan(
			&i.TotalCount,
			&i.ID,
			&i.CompanyType,
			&i.CompanyID,
			&i.IsBranch,
			&i.FileUrl,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.Status,
			&i.CompanyName,
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

const getContractsByCompany = `-- name: GetContractsByCompany :one
SELECT id, company_type, company_id, is_branch, file_url, created_at, updated_at, status FROM contracts WHERE company_type = $1 AND company_id = $2 AND is_branch = $3
`

type GetContractsByCompanyParams struct {
	CompanyType int64       `json:"company_type"`
	CompanyID   int64       `json:"company_id"`
	IsBranch    pgtype.Bool `json:"is_branch"`
}

func (q *Queries) GetContractsByCompany(ctx context.Context, arg GetContractsByCompanyParams) (Contract, error) {
	row := q.db.QueryRow(ctx, getContractsByCompany, arg.CompanyType, arg.CompanyID, arg.IsBranch)
	var i Contract
	err := row.Scan(
		&i.ID,
		&i.CompanyType,
		&i.CompanyID,
		&i.IsBranch,
		&i.FileUrl,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.Status,
	)
	return i, err
}
