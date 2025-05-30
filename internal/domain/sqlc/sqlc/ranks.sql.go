// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: ranks.sql

package sqlc

import (
	"context"
	"time"
)

const createRanks = `-- name: CreateRanks :one
INSERT INTO ranks (
    rank,
    price,
    status,
    created_at,
    updated_at   
)VALUES (
    $1, $2, $3 ,$4, $5
) RETURNING id, rank, price, status, created_at, updated_at
`

type CreateRanksParams struct {
	Rank      string    `json:"rank"`
	Price     int64     `json:"price"`
	Status    int64     `json:"status"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

func (q *Queries) CreateRanks(ctx context.Context, arg CreateRanksParams) (Rank, error) {
	row := q.db.QueryRow(ctx, createRanks,
		arg.Rank,
		arg.Price,
		arg.Status,
		arg.CreatedAt,
		arg.UpdatedAt,
	)
	var i Rank
	err := row.Scan(
		&i.ID,
		&i.Rank,
		&i.Price,
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const deleteRanks = `-- name: DeleteRanks :exec
DELETE FROM ranks
Where id = $1
`

func (q *Queries) DeleteRanks(ctx context.Context, id int64) error {
	_, err := q.db.Exec(ctx, deleteRanks, id)
	return err
}

const getAllRanks = `-- name: GetAllRanks :many
SELECT id, rank, price, status, created_at, updated_at FROM ranks
ORDER BY id
LIMIT $1
OFFSET $2
`

type GetAllRanksParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) GetAllRanks(ctx context.Context, arg GetAllRanksParams) ([]Rank, error) {
	rows, err := q.db.Query(ctx, getAllRanks, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []Rank
	for rows.Next() {
		var i Rank
		if err := rows.Scan(
			&i.ID,
			&i.Rank,
			&i.Price,
			&i.Status,
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

const getRanks = `-- name: GetRanks :one
SELECT id, rank, price, status, created_at, updated_at FROM ranks 
WHERE id = $1 LIMIT $1
`

func (q *Queries) GetRanks(ctx context.Context, limit int32) (Rank, error) {
	row := q.db.QueryRow(ctx, getRanks, limit)
	var i Rank
	err := row.Scan(
		&i.ID,
		&i.Rank,
		&i.Price,
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const getRanksByRank = `-- name: GetRanksByRank :one
SELECT id, rank, price, status, created_at, updated_at FROM ranks 
WHERE rank = $1 LIMIT 1
`

func (q *Queries) GetRanksByRank(ctx context.Context, rank string) (Rank, error) {
	row := q.db.QueryRow(ctx, getRanksByRank, rank)
	var i Rank
	err := row.Scan(
		&i.ID,
		&i.Rank,
		&i.Price,
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const updateRanks = `-- name: UpdateRanks :one
UPDATE ranks
SET   rank = $2,
    price = $3,
    status = $4,
    created_at = $5,
    updated_at = $6 
Where id = $1
RETURNING id, rank, price, status, created_at, updated_at
`

type UpdateRanksParams struct {
	ID        int64     `json:"id"`
	Rank      string    `json:"rank"`
	Price     int64     `json:"price"`
	Status    int64     `json:"status"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

func (q *Queries) UpdateRanks(ctx context.Context, arg UpdateRanksParams) (Rank, error) {
	row := q.db.QueryRow(ctx, updateRanks,
		arg.ID,
		arg.Rank,
		arg.Price,
		arg.Status,
		arg.CreatedAt,
		arg.UpdatedAt,
	)
	var i Rank
	err := row.Scan(
		&i.ID,
		&i.Rank,
		&i.Price,
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}
