// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: developer_company_directors_reviews.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createDeveloperCompanyDirectorReview = `-- name: CreateDeveloperCompanyDirectorReview :one
INSERT INTO developer_company_directors_reviews (
    rating,
    review,
    profiles_id,
    status,
    developer_company_directors_id,
    created_at,
    updated_at,
    users_id
)VALUES (
    $1 ,$2, $3, $4, $5, $6 ,$7, $8
) RETURNING id, rating, review, profiles_id, status, developer_company_directors_id, created_at, updated_at, users_id
`

type CreateDeveloperCompanyDirectorReviewParams struct {
	Rating                      string    `json:"rating"`
	Review                      string    `json:"review"`
	ProfilesID                  int64     `json:"profiles_id"`
	Status                      int64     `json:"status"`
	DeveloperCompanyDirectorsID int64     `json:"developer_company_directors_id"`
	CreatedAt                   time.Time `json:"created_at"`
	UpdatedAt                   time.Time `json:"updated_at"`
	UsersID                     int64     `json:"users_id"`
}

func (q *Queries) CreateDeveloperCompanyDirectorReview(ctx context.Context, arg CreateDeveloperCompanyDirectorReviewParams) (DeveloperCompanyDirectorsReview, error) {
	row := q.db.QueryRow(ctx, createDeveloperCompanyDirectorReview,
		arg.Rating,
		arg.Review,
		arg.ProfilesID,
		arg.Status,
		arg.DeveloperCompanyDirectorsID,
		arg.CreatedAt,
		arg.UpdatedAt,
		arg.UsersID,
	)
	var i DeveloperCompanyDirectorsReview
	err := row.Scan(
		&i.ID,
		&i.Rating,
		&i.Review,
		&i.ProfilesID,
		&i.Status,
		&i.DeveloperCompanyDirectorsID,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.UsersID,
	)
	return i, err
}

const deleteDeveloperCompanyDirectorReview = `-- name: DeleteDeveloperCompanyDirectorReview :exec
DELETE FROM developer_company_directors_reviews
Where id = $1
`

func (q *Queries) DeleteDeveloperCompanyDirectorReview(ctx context.Context, id int64) error {
	_, err := q.db.Exec(ctx, deleteDeveloperCompanyDirectorReview, id)
	return err
}

const getAllDeveloperCompanyDirectorReview = `-- name: GetAllDeveloperCompanyDirectorReview :many
SELECT id, rating, review, profiles_id, status, developer_company_directors_id, created_at, updated_at, users_id FROM developer_company_directors_reviews
ORDER BY id
LIMIT $1
OFFSET $2
`

type GetAllDeveloperCompanyDirectorReviewParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) GetAllDeveloperCompanyDirectorReview(ctx context.Context, arg GetAllDeveloperCompanyDirectorReviewParams) ([]DeveloperCompanyDirectorsReview, error) {
	rows, err := q.db.Query(ctx, getAllDeveloperCompanyDirectorReview, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []DeveloperCompanyDirectorsReview
	for rows.Next() {
		var i DeveloperCompanyDirectorsReview
		if err := rows.Scan(
			&i.ID,
			&i.Rating,
			&i.Review,
			&i.ProfilesID,
			&i.Status,
			&i.DeveloperCompanyDirectorsID,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.UsersID,
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

const getAllDeveloperCompanyDirectorReviewCompanyDirectorsId = `-- name: GetAllDeveloperCompanyDirectorReviewCompanyDirectorsId :many
SELECT id, rating, review, profiles_id, status, developer_company_directors_id, created_at, updated_at, users_id FROM developer_company_directors_reviews
Where developer_company_directors_id = $1
LIMIT $2
OFFSET $3
`

type GetAllDeveloperCompanyDirectorReviewCompanyDirectorsIdParams struct {
	DeveloperCompanyDirectorsID int64 `json:"developer_company_directors_id"`
	Limit                       int32 `json:"limit"`
	Offset                      int32 `json:"offset"`
}

func (q *Queries) GetAllDeveloperCompanyDirectorReviewCompanyDirectorsId(ctx context.Context, arg GetAllDeveloperCompanyDirectorReviewCompanyDirectorsIdParams) ([]DeveloperCompanyDirectorsReview, error) {
	rows, err := q.db.Query(ctx, getAllDeveloperCompanyDirectorReviewCompanyDirectorsId, arg.DeveloperCompanyDirectorsID, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []DeveloperCompanyDirectorsReview
	for rows.Next() {
		var i DeveloperCompanyDirectorsReview
		if err := rows.Scan(
			&i.ID,
			&i.Rating,
			&i.Review,
			&i.ProfilesID,
			&i.Status,
			&i.DeveloperCompanyDirectorsID,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.UsersID,
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

const getAvgDeveloperCompanyDirectorsReviews = `-- name: GetAvgDeveloperCompanyDirectorsReviews :one
SELECT AVG(rating::NUMERIC)::NUMERIC(2,1)  FROM developer_company_directors_reviews WHERE developer_company_directors_id = $1
`

func (q *Queries) GetAvgDeveloperCompanyDirectorsReviews(ctx context.Context, developerCompanyDirectorsID int64) (pgtype.Numeric, error) {
	row := q.db.QueryRow(ctx, getAvgDeveloperCompanyDirectorsReviews, developerCompanyDirectorsID)
	var column_1 pgtype.Numeric
	err := row.Scan(&column_1)
	return column_1, err
}

const getDeveloperCompanyDirectorReview = `-- name: GetDeveloperCompanyDirectorReview :one
SELECT id, rating, review, profiles_id, status, developer_company_directors_id, created_at, updated_at, users_id FROM developer_company_directors_reviews 
WHERE id = $1 LIMIT $1
`

func (q *Queries) GetDeveloperCompanyDirectorReview(ctx context.Context, limit int32) (DeveloperCompanyDirectorsReview, error) {
	row := q.db.QueryRow(ctx, getDeveloperCompanyDirectorReview, limit)
	var i DeveloperCompanyDirectorsReview
	err := row.Scan(
		&i.ID,
		&i.Rating,
		&i.Review,
		&i.ProfilesID,
		&i.Status,
		&i.DeveloperCompanyDirectorsID,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.UsersID,
	)
	return i, err
}

const updateDeveloperCompanyDirectorReview = `-- name: UpdateDeveloperCompanyDirectorReview :one
UPDATE developer_company_directors_reviews
SET  rating = $2,
    review = $3,
    profiles_id = $4,
    status = $5,
    developer_company_directors_id = $6,
    created_at = $7,
    updated_at = $8,
    users_id = $9
Where id = $1
RETURNING id, rating, review, profiles_id, status, developer_company_directors_id, created_at, updated_at, users_id
`

type UpdateDeveloperCompanyDirectorReviewParams struct {
	ID                          int64     `json:"id"`
	Rating                      string    `json:"rating"`
	Review                      string    `json:"review"`
	ProfilesID                  int64     `json:"profiles_id"`
	Status                      int64     `json:"status"`
	DeveloperCompanyDirectorsID int64     `json:"developer_company_directors_id"`
	CreatedAt                   time.Time `json:"created_at"`
	UpdatedAt                   time.Time `json:"updated_at"`
	UsersID                     int64     `json:"users_id"`
}

func (q *Queries) UpdateDeveloperCompanyDirectorReview(ctx context.Context, arg UpdateDeveloperCompanyDirectorReviewParams) (DeveloperCompanyDirectorsReview, error) {
	row := q.db.QueryRow(ctx, updateDeveloperCompanyDirectorReview,
		arg.ID,
		arg.Rating,
		arg.Review,
		arg.ProfilesID,
		arg.Status,
		arg.DeveloperCompanyDirectorsID,
		arg.CreatedAt,
		arg.UpdatedAt,
		arg.UsersID,
	)
	var i DeveloperCompanyDirectorsReview
	err := row.Scan(
		&i.ID,
		&i.Rating,
		&i.Review,
		&i.ProfilesID,
		&i.Status,
		&i.DeveloperCompanyDirectorsID,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.UsersID,
	)
	return i, err
}
