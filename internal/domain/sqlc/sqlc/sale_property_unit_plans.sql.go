// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: sale_property_unit_plans.sql

package sqlc

import (
	"context"
	"time"
)

const createSalePropertyUnitPlan = `-- name: CreateSalePropertyUnitPlan :one
INSERT INTO sale_property_unit_plans (
    img_url,
    title,
sale_property_units_id,
created_at,
updated_at
)VALUES (
    $1 ,$2, $3, $4, $5
) RETURNING id, img_url, title, sale_property_units_id, created_at, updated_at
`

type CreateSalePropertyUnitPlanParams struct {
	ImgUrl              []string  `json:"img_url"`
	Title               string    `json:"title"`
	SalePropertyUnitsID int64     `json:"sale_property_units_id"`
	CreatedAt           time.Time `json:"created_at"`
	UpdatedAt           time.Time `json:"updated_at"`
}

func (q *Queries) CreateSalePropertyUnitPlan(ctx context.Context, arg CreateSalePropertyUnitPlanParams) (SalePropertyUnitPlan, error) {
	row := q.db.QueryRow(ctx, createSalePropertyUnitPlan,
		arg.ImgUrl,
		arg.Title,
		arg.SalePropertyUnitsID,
		arg.CreatedAt,
		arg.UpdatedAt,
	)
	var i SalePropertyUnitPlan
	err := row.Scan(
		&i.ID,
		&i.ImgUrl,
		&i.Title,
		&i.SalePropertyUnitsID,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const deleteSalePropertyUnitPlan = `-- name: DeleteSalePropertyUnitPlan :exec
DELETE FROM sale_property_unit_plans
Where id = $1
`

func (q *Queries) DeleteSalePropertyUnitPlan(ctx context.Context, id int64) error {
	_, err := q.db.Exec(ctx, deleteSalePropertyUnitPlan, id)
	return err
}

const deleteSalePropertyUnitPlanSingleFile = `-- name: DeleteSalePropertyUnitPlanSingleFile :one
UPDATE sale_property_unit_plans
SET img_url = array_remove(img_url, $2::VARCHAR)
WHERE id = $1
RETURNING id, img_url, title, sale_property_units_id, created_at, updated_at
`

type DeleteSalePropertyUnitPlanSingleFileParams struct {
	ID      int64  `json:"id"`
	Fileurl string `json:"fileurl"`
}

func (q *Queries) DeleteSalePropertyUnitPlanSingleFile(ctx context.Context, arg DeleteSalePropertyUnitPlanSingleFileParams) (SalePropertyUnitPlan, error) {
	row := q.db.QueryRow(ctx, deleteSalePropertyUnitPlanSingleFile, arg.ID, arg.Fileurl)
	var i SalePropertyUnitPlan
	err := row.Scan(
		&i.ID,
		&i.ImgUrl,
		&i.Title,
		&i.SalePropertyUnitsID,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const getAllSalePropertyUnitPlan = `-- name: GetAllSalePropertyUnitPlan :many
SELECT id, img_url, title, sale_property_units_id, created_at, updated_at FROM sale_property_unit_plans
ORDER BY id
LIMIT $1
OFFSET $2
`

type GetAllSalePropertyUnitPlanParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) GetAllSalePropertyUnitPlan(ctx context.Context, arg GetAllSalePropertyUnitPlanParams) ([]SalePropertyUnitPlan, error) {
	rows, err := q.db.Query(ctx, getAllSalePropertyUnitPlan, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []SalePropertyUnitPlan
	for rows.Next() {
		var i SalePropertyUnitPlan
		if err := rows.Scan(
			&i.ID,
			&i.ImgUrl,
			&i.Title,
			&i.SalePropertyUnitsID,
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

const getAllSalePropertyUnitPlanByUnit = `-- name: GetAllSalePropertyUnitPlanByUnit :many
SELECT id, img_url, title, sale_property_units_id, created_at, updated_at FROM sale_property_unit_plans
WHERE sale_property_units_id = $3
ORDER BY created_at DESC
LIMIT $1 OFFSET $2
`

type GetAllSalePropertyUnitPlanByUnitParams struct {
	Limit               int32 `json:"limit"`
	Offset              int32 `json:"offset"`
	SalePropertyUnitsID int64 `json:"sale_property_units_id"`
}

func (q *Queries) GetAllSalePropertyUnitPlanByUnit(ctx context.Context, arg GetAllSalePropertyUnitPlanByUnitParams) ([]SalePropertyUnitPlan, error) {
	rows, err := q.db.Query(ctx, getAllSalePropertyUnitPlanByUnit, arg.Limit, arg.Offset, arg.SalePropertyUnitsID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []SalePropertyUnitPlan
	for rows.Next() {
		var i SalePropertyUnitPlan
		if err := rows.Scan(
			&i.ID,
			&i.ImgUrl,
			&i.Title,
			&i.SalePropertyUnitsID,
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

const getCountAllSalePropertyUnitPlanByUnit = `-- name: GetCountAllSalePropertyUnitPlanByUnit :one
SELECT COUNT(*) FROM sale_property_unit_plans
WHERE sale_property_units_id = $1
`

func (q *Queries) GetCountAllSalePropertyUnitPlanByUnit(ctx context.Context, salePropertyUnitsID int64) (int64, error) {
	row := q.db.QueryRow(ctx, getCountAllSalePropertyUnitPlanByUnit, salePropertyUnitsID)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const getSalePropertyUnitPlan = `-- name: GetSalePropertyUnitPlan :one
SELECT id, img_url, title, sale_property_units_id, created_at, updated_at FROM sale_property_unit_plans 
WHERE id = $1 LIMIT 1
`

func (q *Queries) GetSalePropertyUnitPlan(ctx context.Context, id int64) (SalePropertyUnitPlan, error) {
	row := q.db.QueryRow(ctx, getSalePropertyUnitPlan, id)
	var i SalePropertyUnitPlan
	err := row.Scan(
		&i.ID,
		&i.ImgUrl,
		&i.Title,
		&i.SalePropertyUnitsID,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const getSalePropertyUnitPlanByTitleAndUnitId = `-- name: GetSalePropertyUnitPlanByTitleAndUnitId :one
SELECT id, img_url, title, sale_property_units_id, created_at, updated_at FROM sale_property_unit_plans 
WHERE title ILIKE $1 AND sale_property_units_id = $2
`

type GetSalePropertyUnitPlanByTitleAndUnitIdParams struct {
	Title               string `json:"title"`
	SalePropertyUnitsID int64  `json:"sale_property_units_id"`
}

func (q *Queries) GetSalePropertyUnitPlanByTitleAndUnitId(ctx context.Context, arg GetSalePropertyUnitPlanByTitleAndUnitIdParams) (SalePropertyUnitPlan, error) {
	row := q.db.QueryRow(ctx, getSalePropertyUnitPlanByTitleAndUnitId, arg.Title, arg.SalePropertyUnitsID)
	var i SalePropertyUnitPlan
	err := row.Scan(
		&i.ID,
		&i.ImgUrl,
		&i.Title,
		&i.SalePropertyUnitsID,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const updateSalePropertyUnitPlan = `-- name: UpdateSalePropertyUnitPlan :one
UPDATE sale_property_unit_plans
SET img_url = $2,
title = $3,
sale_property_units_id = $4,
created_at = $5,
updated_at = $6
Where id = $1
RETURNING id, img_url, title, sale_property_units_id, created_at, updated_at
`

type UpdateSalePropertyUnitPlanParams struct {
	ID                  int64     `json:"id"`
	ImgUrl              []string  `json:"img_url"`
	Title               string    `json:"title"`
	SalePropertyUnitsID int64     `json:"sale_property_units_id"`
	CreatedAt           time.Time `json:"created_at"`
	UpdatedAt           time.Time `json:"updated_at"`
}

func (q *Queries) UpdateSalePropertyUnitPlan(ctx context.Context, arg UpdateSalePropertyUnitPlanParams) (SalePropertyUnitPlan, error) {
	row := q.db.QueryRow(ctx, updateSalePropertyUnitPlan,
		arg.ID,
		arg.ImgUrl,
		arg.Title,
		arg.SalePropertyUnitsID,
		arg.CreatedAt,
		arg.UpdatedAt,
	)
	var i SalePropertyUnitPlan
	err := row.Scan(
		&i.ID,
		&i.ImgUrl,
		&i.Title,
		&i.SalePropertyUnitsID,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const updateSalePropertyUnitPlanUrls = `-- name: UpdateSalePropertyUnitPlanUrls :one
UPDATE sale_property_unit_plans
SET img_url = $2,
updated_at = $3
Where id = $1
RETURNING id, img_url, title, sale_property_units_id, created_at, updated_at
`

type UpdateSalePropertyUnitPlanUrlsParams struct {
	ID        int64     `json:"id"`
	ImgUrl    []string  `json:"img_url"`
	UpdatedAt time.Time `json:"updated_at"`
}

func (q *Queries) UpdateSalePropertyUnitPlanUrls(ctx context.Context, arg UpdateSalePropertyUnitPlanUrlsParams) (SalePropertyUnitPlan, error) {
	row := q.db.QueryRow(ctx, updateSalePropertyUnitPlanUrls, arg.ID, arg.ImgUrl, arg.UpdatedAt)
	var i SalePropertyUnitPlan
	err := row.Scan(
		&i.ID,
		&i.ImgUrl,
		&i.Title,
		&i.SalePropertyUnitsID,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}
