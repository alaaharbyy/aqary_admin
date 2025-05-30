// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: banner_plan_package.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createBannerPlanPackage = `-- name: CreateBannerPlanPackage :exec
INSERT INTO
    banner_plan_package (
        package_name,
        plan_type,
        plan_package_name,
        quantity,
        counts_per_banner,
        icon,
        description,
        status,
        created_at,
        updated_at
    )
VALUES(
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10
    )
`

type CreateBannerPlanPackageParams struct {
	PackageName     int64       `json:"package_name"`
	PlanType        int64       `json:"plan_type"`
	PlanPackageName string      `json:"plan_package_name"`
	Quantity        int64       `json:"quantity"`
	CountsPerBanner int64       `json:"counts_per_banner"`
	Icon            string      `json:"icon"`
	Description     pgtype.Text `json:"description"`
	Status          int64       `json:"status"`
	CreatedAt       time.Time   `json:"created_at"`
	UpdatedAt       time.Time   `json:"updated_at"`
}

func (q *Queries) CreateBannerPlanPackage(ctx context.Context, arg CreateBannerPlanPackageParams) error {
	_, err := q.db.Exec(ctx, createBannerPlanPackage,
		arg.PackageName,
		arg.PlanType,
		arg.PlanPackageName,
		arg.Quantity,
		arg.CountsPerBanner,
		arg.Icon,
		arg.Description,
		arg.Status,
		arg.CreatedAt,
		arg.UpdatedAt,
	)
	return err
}

const getAllBannerPlanPackages = `-- name: GetAllBannerPlanPackages :many
SELECT
    id,
    package_name,
    plan_type,
    description,
    plan_package_name,
    quantity,
    counts_per_banner,
    icon,
    updated_at
FROM
    banner_plan_package
WHERE
    status =$1
ORDER BY
    updated_at DESC
LIMIT
    $3 OFFSET $2
`

type GetAllBannerPlanPackagesParams struct {
	Status int64       `json:"status"`
	Offset pgtype.Int4 `json:"offset"`
	Limit  pgtype.Int4 `json:"limit"`
}

type GetAllBannerPlanPackagesRow struct {
	ID              int64       `json:"id"`
	PackageName     int64       `json:"package_name"`
	PlanType        int64       `json:"plan_type"`
	Description     pgtype.Text `json:"description"`
	PlanPackageName string      `json:"plan_package_name"`
	Quantity        int64       `json:"quantity"`
	CountsPerBanner int64       `json:"counts_per_banner"`
	Icon            string      `json:"icon"`
	UpdatedAt       time.Time   `json:"updated_at"`
}

func (q *Queries) GetAllBannerPlanPackages(ctx context.Context, arg GetAllBannerPlanPackagesParams) ([]GetAllBannerPlanPackagesRow, error) {
	rows, err := q.db.Query(ctx, getAllBannerPlanPackages, arg.Status, arg.Offset, arg.Limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAllBannerPlanPackagesRow
	for rows.Next() {
		var i GetAllBannerPlanPackagesRow
		if err := rows.Scan(
			&i.ID,
			&i.PackageName,
			&i.PlanType,
			&i.Description,
			&i.PlanPackageName,
			&i.Quantity,
			&i.CountsPerBanner,
			&i.Icon,
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

const getBannerPlanPackage = `-- name: GetBannerPlanPackage :one
SELECT
    package_name,
    plan_type,
    description,
    plan_package_name,
    quantity,
    counts_per_banner,
    icon
FROM 
	banner_plan_package
WHERE
    id =$1
    AND status =$2
`

type GetBannerPlanPackageParams struct {
	ID     int64 `json:"id"`
	Status int64 `json:"status"`
}

type GetBannerPlanPackageRow struct {
	PackageName     int64       `json:"package_name"`
	PlanType        int64       `json:"plan_type"`
	Description     pgtype.Text `json:"description"`
	PlanPackageName string      `json:"plan_package_name"`
	Quantity        int64       `json:"quantity"`
	CountsPerBanner int64       `json:"counts_per_banner"`
	Icon            string      `json:"icon"`
}

func (q *Queries) GetBannerPlanPackage(ctx context.Context, arg GetBannerPlanPackageParams) (GetBannerPlanPackageRow, error) {
	row := q.db.QueryRow(ctx, getBannerPlanPackage, arg.ID, arg.Status)
	var i GetBannerPlanPackageRow
	err := row.Scan(
		&i.PackageName,
		&i.PlanType,
		&i.Description,
		&i.PlanPackageName,
		&i.Quantity,
		&i.CountsPerBanner,
		&i.Icon,
	)
	return i, err
}

const getBannerPlanPackageByID = `-- name: GetBannerPlanPackageByID :one
SELECT
    id,
    package_name,
    plan_type,
    plan_package_name,
    quantity,
    counts_per_banner,
    icon,
    description,
    status,
    created_at,
    updated_at
FROM
    banner_plan_package
WHERE
    id = $1
`

func (q *Queries) GetBannerPlanPackageByID(ctx context.Context, id int64) (BannerPlanPackage, error) {
	row := q.db.QueryRow(ctx, getBannerPlanPackageByID, id)
	var i BannerPlanPackage
	err := row.Scan(
		&i.ID,
		&i.PackageName,
		&i.PlanType,
		&i.PlanPackageName,
		&i.Quantity,
		&i.CountsPerBanner,
		&i.Icon,
		&i.Description,
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const getNumberOfBannerPlanPackages = `-- name: GetNumberOfBannerPlanPackages :one
SELECT
    COUNT(*)
FROM
    banner_plan_package
WHERE
    status = $1
`

func (q *Queries) GetNumberOfBannerPlanPackages(ctx context.Context, status int64) (int64, error) {
	row := q.db.QueryRow(ctx, getNumberOfBannerPlanPackages, status)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const updateBannerPlanPackage = `-- name: UpdateBannerPlanPackage :one
UPDATE
    banner_plan_package
SET
    package_name = COALESCE($3, package_name),
    plan_type = COALESCE($4, plan_type),
    plan_package_name = COALESCE($5, plan_package_name),
    quantity = COALESCE($6, quantity),
    counts_per_banner = COALESCE($7, counts_per_banner),
    icon = COALESCE($8, icon),
    description = $9,
    updated_at = $2
WHERE
    id = $1
    AND status = $10::BIGINT
RETURNING id
`

type UpdateBannerPlanPackageParams struct {
	ID              int64       `json:"id"`
	UpdatedAt       time.Time   `json:"updated_at"`
	PackageName     pgtype.Int8 `json:"package_name"`
	PlanType        pgtype.Int8 `json:"plan_type"`
	PlanPackageName pgtype.Text `json:"plan_package_name"`
	Quantity        pgtype.Int8 `json:"quantity"`
	CountsPerBanner pgtype.Int8 `json:"counts_per_banner"`
	Icon            pgtype.Text `json:"icon"`
	Description     pgtype.Text `json:"description"`
	ActiveStatus    int64       `json:"active_status"`
}

func (q *Queries) UpdateBannerPlanPackage(ctx context.Context, arg UpdateBannerPlanPackageParams) (int64, error) {
	row := q.db.QueryRow(ctx, updateBannerPlanPackage,
		arg.ID,
		arg.UpdatedAt,
		arg.PackageName,
		arg.PlanType,
		arg.PlanPackageName,
		arg.Quantity,
		arg.CountsPerBanner,
		arg.Icon,
		arg.Description,
		arg.ActiveStatus,
	)
	var id int64
	err := row.Scan(&id)
	return id, err
}

const updateBannerPlanPackageStatus = `-- name: UpdateBannerPlanPackageStatus :one
UPDATE
    banner_plan_package
SET
    status =$2,
    updated_at =$3
WHERE
    id =$1 RETURNING id
`

type UpdateBannerPlanPackageStatusParams struct {
	ID        int64     `json:"id"`
	Status    int64     `json:"status"`
	UpdatedAt time.Time `json:"updated_at"`
}

func (q *Queries) UpdateBannerPlanPackageStatus(ctx context.Context, arg UpdateBannerPlanPackageStatusParams) (int64, error) {
	row := q.db.QueryRow(ctx, updateBannerPlanPackageStatus, arg.ID, arg.Status, arg.UpdatedAt)
	var id int64
	err := row.Scan(&id)
	return id, err
}
