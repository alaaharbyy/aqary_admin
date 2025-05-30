// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: financial_providers.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createFinancialProviders = `-- name: CreateFinancialProviders :one
INSERT INTO financial_providers (
    ref_no,
    provider_type,
    provider_name,
    logo_url,
    created_at,
    updated_at
)VALUES(
    $1, $2, $3, $4, $5, $6
) RETURNING id, ref_no, provider_type, provider_name, logo_url, created_at, updated_at
`

type CreateFinancialProvidersParams struct {
	RefNo        string    `json:"ref_no"`
	ProviderType int64     `json:"provider_type"`
	ProviderName string    `json:"provider_name"`
	LogoUrl      string    `json:"logo_url"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

func (q *Queries) CreateFinancialProviders(ctx context.Context, arg CreateFinancialProvidersParams) (FinancialProvider, error) {
	row := q.db.QueryRow(ctx, createFinancialProviders,
		arg.RefNo,
		arg.ProviderType,
		arg.ProviderName,
		arg.LogoUrl,
		arg.CreatedAt,
		arg.UpdatedAt,
	)
	var i FinancialProvider
	err := row.Scan(
		&i.ID,
		&i.RefNo,
		&i.ProviderType,
		&i.ProviderName,
		&i.LogoUrl,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const createProjectFinancialProviders = `-- name: CreateProjectFinancialProviders :one
INSERT INTO project_financial_provider (
    projects_id,
    phases_id,
    financial_providers_id
)VALUES(
    $1, $2, $3
) RETURNING id, projects_id, phases_id, financial_providers_id
`

type CreateProjectFinancialProvidersParams struct {
	ProjectsID           int64       `json:"projects_id"`
	PhasesID             pgtype.Int8 `json:"phases_id"`
	FinancialProvidersID []int64     `json:"financial_providers_id"`
}

func (q *Queries) CreateProjectFinancialProviders(ctx context.Context, arg CreateProjectFinancialProvidersParams) (ProjectFinancialProvider, error) {
	row := q.db.QueryRow(ctx, createProjectFinancialProviders, arg.ProjectsID, arg.PhasesID, arg.FinancialProvidersID)
	var i ProjectFinancialProvider
	err := row.Scan(
		&i.ID,
		&i.ProjectsID,
		&i.PhasesID,
		&i.FinancialProvidersID,
	)
	return i, err
}

const deleteFinancialProvider = `-- name: DeleteFinancialProvider :one
WITH checkIfFound AS (
    -- Check if the row exists in the financial_providers table
    SELECT id 
    FROM financial_providers 
    WHERE id = $1::bigint
), checkIfInUse AS (
    -- Check if the row exists in the sub_test project_financial_provider (indicating it’s in use)
    SELECT 1
    FROM project_financial_provider 
    WHERE $1::bigint = ANY(financial_providers_id)
), performDelete AS (
    -- Perform the delete operation only if the row exists in financial_providers and is not in project_financial_provider
    DELETE FROM financial_providers
    WHERE id = $1::bigint
    AND EXISTS (SELECT 1 FROM checkIfFound)
    AND NOT EXISTS (SELECT 1 FROM checkIfInUse)
    RETURNING id
)SELECT
    CASE
        WHEN EXISTS (SELECT 1 FROM checkIfInUse) THEN 'IN-USE'::varchar
        WHEN EXISTS (SELECT 1 FROM performDelete) THEN 'DELETED'::varchar
        ELSE 'NOT-FOUND'::varchar
    END AS result
`

func (q *Queries) DeleteFinancialProvider(ctx context.Context, id int64) (string, error) {
	row := q.db.QueryRow(ctx, deleteFinancialProvider, id)
	var result string
	err := row.Scan(&result)
	return result, err
}

const deleteProjectAndPhaseFinancialProvider = `-- name: DeleteProjectAndPhaseFinancialProvider :execrows
WITH to_process AS (
  SELECT 
    id, 
    CASE
    	WHEN (array_remove(financial_providers_id, $1::bigint) = '{}') THEN 'DELETE'
      	WHEN financial_providers_id @> ARRAY[$1::bigint] THEN 'UPDATE'
      	ELSE 'IGNORE'
    END AS operation
  FROM project_financial_provider
  WHERE CASE WHEN $2::bigint = 0 THEN (projects_id = $3::bigint AND phases_id IS NULL) ELSE  phases_id = $2::bigint END
),
deleted AS (
  DELETE FROM project_financial_provider
  USING to_process
  WHERE project_financial_provider.id = to_process.id
    AND to_process.operation = 'DELETE'
  RETURNING 
    project_financial_provider.id,
    'DELETED'::text AS operation
),
updated AS (
  UPDATE project_financial_provider 
  SET
    financial_providers_id = CASE
    	WHEN array_remove(financial_providers_id, $1::bigint) = '{}' THEN NULL
    		ELSE array_remove(financial_providers_id, $1::bigint)
        END
  FROM to_process
  WHERE project_financial_provider.id = to_process.id
    AND to_process.operation = 'UPDATE'
  RETURNING 
    project_financial_provider.id,
    'UPDATED'::text AS operation
)
SELECT id FROM deleted
UNION ALL
SELECT id FROM updated
`

type DeleteProjectAndPhaseFinancialProviderParams struct {
	ID        int64 `json:"id"`
	PhasesID  int64 `json:"phases_id"`
	ProjectID int64 `json:"project_id"`
}

func (q *Queries) DeleteProjectAndPhaseFinancialProvider(ctx context.Context, arg DeleteProjectAndPhaseFinancialProviderParams) (int64, error) {
	result, err := q.db.Exec(ctx, deleteProjectAndPhaseFinancialProvider, arg.ID, arg.PhasesID, arg.ProjectID)
	if err != nil {
		return 0, err
	}
	return result.RowsAffected(), nil
}

const getAllFinancialProviders = `-- name: GetAllFinancialProviders :many
SELECT id, ref_no, provider_type, provider_name, logo_url, created_at, updated_at FROM financial_providers
OFFSET $1 LIMIT $2
`

type GetAllFinancialProvidersParams struct {
	Offset int32 `json:"offset"`
	Limit  int32 `json:"limit"`
}

func (q *Queries) GetAllFinancialProviders(ctx context.Context, arg GetAllFinancialProvidersParams) ([]FinancialProvider, error) {
	rows, err := q.db.Query(ctx, getAllFinancialProviders, arg.Offset, arg.Limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []FinancialProvider
	for rows.Next() {
		var i FinancialProvider
		if err := rows.Scan(
			&i.ID,
			&i.RefNo,
			&i.ProviderType,
			&i.ProviderName,
			&i.LogoUrl,
			&i.CreatedAt,
			&i.UpdatedAt,
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

const getAllFinancialProvidersByIds = `-- name: GetAllFinancialProvidersByIds :many
	SELECT 
		id,
		provider_type,
		provider_name,
    logo_url
	FROM financial_providers
	WHERE id = ANY($3::bigint[]) 
 LIMIT $1 OFFSET $2
`

type GetAllFinancialProvidersByIdsParams struct {
	Limit  int32   `json:"limit"`
	Offset int32   `json:"offset"`
	Ids    []int64 `json:"ids"`
}

type GetAllFinancialProvidersByIdsRow struct {
	ID           int64  `json:"id"`
	ProviderType int64  `json:"provider_type"`
	ProviderName string `json:"provider_name"`
	LogoUrl      string `json:"logo_url"`
}

func (q *Queries) GetAllFinancialProvidersByIds(ctx context.Context, arg GetAllFinancialProvidersByIdsParams) ([]GetAllFinancialProvidersByIdsRow, error) {
	rows, err := q.db.Query(ctx, getAllFinancialProvidersByIds, arg.Limit, arg.Offset, arg.Ids)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAllFinancialProvidersByIdsRow
	for rows.Next() {
		var i GetAllFinancialProvidersByIdsRow
		if err := rows.Scan(
			&i.ID,
			&i.ProviderType,
			&i.ProviderName,
			&i.LogoUrl,
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

const getAllPhaseFinancialProviders = `-- name: GetAllPhaseFinancialProviders :one
SELECT id, projects_id, phases_id, financial_providers_id FROM project_financial_provider
WHERE phases_id = $1
`

func (q *Queries) GetAllPhaseFinancialProviders(ctx context.Context, phasesID pgtype.Int8) (ProjectFinancialProvider, error) {
	row := q.db.QueryRow(ctx, getAllPhaseFinancialProviders, phasesID)
	var i ProjectFinancialProvider
	err := row.Scan(
		&i.ID,
		&i.ProjectsID,
		&i.PhasesID,
		&i.FinancialProvidersID,
	)
	return i, err
}

const getAllProjectFinancialProviders = `-- name: GetAllProjectFinancialProviders :many
SELECT id, projects_id, phases_id, financial_providers_id FROM project_financial_provider
WHERE projects_id = $1
`

func (q *Queries) GetAllProjectFinancialProviders(ctx context.Context, projectsID int64) ([]ProjectFinancialProvider, error) {
	rows, err := q.db.Query(ctx, getAllProjectFinancialProviders, projectsID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []ProjectFinancialProvider
	for rows.Next() {
		var i ProjectFinancialProvider
		if err := rows.Scan(
			&i.ID,
			&i.ProjectsID,
			&i.PhasesID,
			&i.FinancialProvidersID,
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

const getCountAllFinancialProviders = `-- name: GetCountAllFinancialProviders :one
SELECT COUNT(id) FROM financial_providers
`

func (q *Queries) GetCountAllFinancialProviders(ctx context.Context) (int64, error) {
	row := q.db.QueryRow(ctx, getCountAllFinancialProviders)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const getCountAllFinancialProvidersByIds = `-- name: GetCountAllFinancialProvidersByIds :one
	SELECT 
		COUNT(id) 
	FROM financial_providers
	WHERE id = ANY($1::bigint[])
`

func (q *Queries) GetCountAllFinancialProvidersByIds(ctx context.Context, ids []int64) (int64, error) {
	row := q.db.QueryRow(ctx, getCountAllFinancialProvidersByIds, ids)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const getFinancialProviders = `-- name: GetFinancialProviders :one
SELECT id, ref_no, provider_type, provider_name, logo_url, created_at, updated_at FROM financial_providers
WHERE id = $1
`

func (q *Queries) GetFinancialProviders(ctx context.Context, id int64) (FinancialProvider, error) {
	row := q.db.QueryRow(ctx, getFinancialProviders, id)
	var i FinancialProvider
	err := row.Scan(
		&i.ID,
		&i.RefNo,
		&i.ProviderType,
		&i.ProviderName,
		&i.LogoUrl,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const getFinancialProvidersByType = `-- name: GetFinancialProvidersByType :many
SELECT id, ref_no, provider_type, provider_name, logo_url, created_at, updated_at FROM financial_providers
WHERE provider_type = $1
`

func (q *Queries) GetFinancialProvidersByType(ctx context.Context, providerType int64) ([]FinancialProvider, error) {
	rows, err := q.db.Query(ctx, getFinancialProvidersByType, providerType)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []FinancialProvider
	for rows.Next() {
		var i FinancialProvider
		if err := rows.Scan(
			&i.ID,
			&i.RefNo,
			&i.ProviderType,
			&i.ProviderName,
			&i.LogoUrl,
			&i.CreatedAt,
			&i.UpdatedAt,
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

const getProjectAndPhaseFinancialProviders = `-- name: GetProjectAndPhaseFinancialProviders :one
SELECT id, projects_id, phases_id, financial_providers_id FROM project_financial_provider
WHERE CASE WHEN $1::bigint = 0 THEN projects_id = $2 AND phases_id IS NULL ELSE phases_id = $1::bigint END
`

type GetProjectAndPhaseFinancialProvidersParams struct {
	PhasesID   int64 `json:"phases_id"`
	ProjectsID int64 `json:"projects_id"`
}

func (q *Queries) GetProjectAndPhaseFinancialProviders(ctx context.Context, arg GetProjectAndPhaseFinancialProvidersParams) (ProjectFinancialProvider, error) {
	row := q.db.QueryRow(ctx, getProjectAndPhaseFinancialProviders, arg.PhasesID, arg.ProjectsID)
	var i ProjectFinancialProvider
	err := row.Scan(
		&i.ID,
		&i.ProjectsID,
		&i.PhasesID,
		&i.FinancialProvidersID,
	)
	return i, err
}

const updateProjectAndPhaseFinancialProviders = `-- name: UpdateProjectAndPhaseFinancialProviders :one
UPDATE project_financial_provider
SET financial_providers_id = $2
WHERE id = $1
RETURNING id, projects_id, phases_id, financial_providers_id
`

type UpdateProjectAndPhaseFinancialProvidersParams struct {
	ID                   int64   `json:"id"`
	FinancialProvidersID []int64 `json:"financial_providers_id"`
}

func (q *Queries) UpdateProjectAndPhaseFinancialProviders(ctx context.Context, arg UpdateProjectAndPhaseFinancialProvidersParams) (ProjectFinancialProvider, error) {
	row := q.db.QueryRow(ctx, updateProjectAndPhaseFinancialProviders, arg.ID, arg.FinancialProvidersID)
	var i ProjectFinancialProvider
	err := row.Scan(
		&i.ID,
		&i.ProjectsID,
		&i.PhasesID,
		&i.FinancialProvidersID,
	)
	return i, err
}
