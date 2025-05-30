// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: country_guide.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createCountryGuide = `-- name: CreateCountryGuide :one
INSERT INTO
    country_guide (
        country_id,
        cover_image,
        description,
        status
    )
SELECT
    $1,
    $2,
    $3,
    $4
FROM 
	countries WHERE id= $1::BIGINT and status !=6 RETURNING 1
`

type CreateCountryGuideParams struct {
	CountryID   int64       `json:"country_id"`
	CoverImage  string      `json:"cover_image"`
	Description pgtype.Text `json:"description"`
	Status      int64       `json:"status"`
}

func (q *Queries) CreateCountryGuide(ctx context.Context, arg CreateCountryGuideParams) (pgtype.Int8, error) {
	row := q.db.QueryRow(ctx, createCountryGuide,
		arg.CountryID,
		arg.CoverImage,
		arg.Description,
		arg.Status,
	)
	var column_1 pgtype.Int8
	err := row.Scan(&column_1)
	return column_1, err
}

const exitingCountryGuide = `-- name: ExitingCountryGuide :one
SELECT EXISTS (
    SELECT 1
    FROM country_guide
    WHERE country_id = $1 and status!= $2::bigint
) AS exists
`

type ExitingCountryGuideParams struct {
	CountryID     int64 `json:"country_id"`
	DeletedStatus int64 `json:"deleted_status"`
}

func (q *Queries) ExitingCountryGuide(ctx context.Context, arg ExitingCountryGuideParams) (pgtype.Bool, error) {
	row := q.db.QueryRow(ctx, exitingCountryGuide, arg.CountryID, arg.DeletedStatus)
	var exists pgtype.Bool
	err := row.Scan(&exists)
	return exists, err
}

const exitingCountryGuideByStatus = `-- name: ExitingCountryGuideByStatus :one
SELECT EXISTS (
    SELECT 1
    FROM country_guide
    WHERE country_id = $1 and status= $2::bigint
) AS exists
`

type ExitingCountryGuideByStatusParams struct {
	CountryID int64 `json:"country_id"`
	Status    int64 `json:"status"`
}

func (q *Queries) ExitingCountryGuideByStatus(ctx context.Context, arg ExitingCountryGuideByStatusParams) (pgtype.Bool, error) {
	row := q.db.QueryRow(ctx, exitingCountryGuideByStatus, arg.CountryID, arg.Status)
	var exists pgtype.Bool
	err := row.Scan(&exists)
	return exists, err
}

const getCountryGuide = `-- name: GetCountryGuide :one
SELECT 
	countries.country,
	country_guide.id, country_guide.country_id, country_guide.cover_image, country_guide.description, country_guide.status, country_guide.created_at, country_guide.updated_at, country_guide.deleted_at
FROM country_guide 
JOIN countries ON countries.id= country_guide.country_id
WHERE country_guide.id=$1
`

type GetCountryGuideRow struct {
	Country      string       `json:"country"`
	CountryGuide CountryGuide `json:"country_guide"`
}

func (q *Queries) GetCountryGuide(ctx context.Context, id int64) (GetCountryGuideRow, error) {
	row := q.db.QueryRow(ctx, getCountryGuide, id)
	var i GetCountryGuideRow
	err := row.Scan(
		&i.Country,
		&i.CountryGuide.ID,
		&i.CountryGuide.CountryID,
		&i.CountryGuide.CoverImage,
		&i.CountryGuide.Description,
		&i.CountryGuide.Status,
		&i.CountryGuide.CreatedAt,
		&i.CountryGuide.UpdatedAt,
		&i.CountryGuide.DeletedAt,
	)
	return i, err
}

const getCountryGuides = `-- name: GetCountryGuides :many
SELECT 
	country_guide.id,
    countries.id as country_id,
	countries.country,
	country_guide.cover_image,
	country_guide.description,
    country_guide.deleted_at
FROM country_guide
JOIN countries ON countries.id= country_guide.country_id
WHERE country_guide.status= $1::BIGINT
LIMIT $3
OFFSET $2
`

type GetCountryGuidesParams struct {
	Status int64       `json:"status"`
	Offset pgtype.Int4 `json:"offset"`
	Limit  pgtype.Int4 `json:"limit"`
}

type GetCountryGuidesRow struct {
	ID          int64              `json:"id"`
	CountryID   int64              `json:"country_id"`
	Country     string             `json:"country"`
	CoverImage  string             `json:"cover_image"`
	Description pgtype.Text        `json:"description"`
	DeletedAt   pgtype.Timestamptz `json:"deleted_at"`
}

func (q *Queries) GetCountryGuides(ctx context.Context, arg GetCountryGuidesParams) ([]GetCountryGuidesRow, error) {
	rows, err := q.db.Query(ctx, getCountryGuides, arg.Status, arg.Offset, arg.Limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetCountryGuidesRow
	for rows.Next() {
		var i GetCountryGuidesRow
		if err := rows.Scan(
			&i.ID,
			&i.CountryID,
			&i.Country,
			&i.CoverImage,
			&i.Description,
			&i.DeletedAt,
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

const getCountryGuidesCount = `-- name: GetCountryGuidesCount :one
SELECT 
	count(country_guide.id)
FROM country_guide
JOIN countries ON countries.id= country_guide.country_id
WHERE country_guide.status= $1::BIGINT
`

func (q *Queries) GetCountryGuidesCount(ctx context.Context, status int64) (int64, error) {
	row := q.db.QueryRow(ctx, getCountryGuidesCount, status)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const updateCountryGuide = `-- name: UpdateCountryGuide :one
UPDATE
    country_guide
SET
    cover_image = COALESCE($3, cover_image),
    description = $4,
    updated_at = $2
WHERE
    country_guide.id = $1
    AND country_guide.status = $5::BIGINT
RETURNING id
`

type UpdateCountryGuideParams struct {
	ID           int64       `json:"id"`
	UpdatedAt    time.Time   `json:"updated_at"`
	CoverImage   pgtype.Text `json:"cover_image"`
	Description  pgtype.Text `json:"description"`
	ActiveStatus int64       `json:"active_status"`
}

func (q *Queries) UpdateCountryGuide(ctx context.Context, arg UpdateCountryGuideParams) (int64, error) {
	row := q.db.QueryRow(ctx, updateCountryGuide,
		arg.ID,
		arg.UpdatedAt,
		arg.CoverImage,
		arg.Description,
		arg.ActiveStatus,
	)
	var id int64
	err := row.Scan(&id)
	return id, err
}

const updateCountryGuideStatus = `-- name: UpdateCountryGuideStatus :exec
UPDATE
    country_guide
SET
    updated_at = $2,
    status = $3,
    deleted_at = $4
WHERE   
    id = $1
`

type UpdateCountryGuideStatusParams struct {
	ID        int64              `json:"id"`
	UpdatedAt time.Time          `json:"updated_at"`
	Status    int64              `json:"status"`
	DeletedAt pgtype.Timestamptz `json:"deleted_at"`
}

func (q *Queries) UpdateCountryGuideStatus(ctx context.Context, arg UpdateCountryGuideStatusParams) error {
	_, err := q.db.Exec(ctx, updateCountryGuideStatus,
		arg.ID,
		arg.UpdatedAt,
		arg.Status,
		arg.DeletedAt,
	)
	return err
}
