// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: exhibition_client.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createExhibitionClient = `-- name: CreateExhibitionClient :one
INSERT INTO exhibition_clients (
    exhibitions_id,
    ref_no,
    client_name,
    website,
    logo_url,
    added_by,
    created_at, 
   client_email
) VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7, 
    $8
)RETURNING id, exhibitions_id, ref_no, client_name, client_email, website, logo_url, created_at, added_by
`

type CreateExhibitionClientParams struct {
	ExhibitionsID int64       `json:"exhibitions_id"`
	RefNo         string      `json:"ref_no"`
	ClientName    string      `json:"client_name"`
	Website       pgtype.Text `json:"website"`
	LogoUrl       pgtype.Text `json:"logo_url"`
	AddedBy       int64       `json:"added_by"`
	CreatedAt     time.Time   `json:"created_at"`
	ClientEmail   string      `json:"client_email"`
}

func (q *Queries) CreateExhibitionClient(ctx context.Context, arg CreateExhibitionClientParams) (ExhibitionClient, error) {
	row := q.db.QueryRow(ctx, createExhibitionClient,
		arg.ExhibitionsID,
		arg.RefNo,
		arg.ClientName,
		arg.Website,
		arg.LogoUrl,
		arg.AddedBy,
		arg.CreatedAt,
		arg.ClientEmail,
	)
	var i ExhibitionClient
	err := row.Scan(
		&i.ID,
		&i.ExhibitionsID,
		&i.RefNo,
		&i.ClientName,
		&i.ClientEmail,
		&i.Website,
		&i.LogoUrl,
		&i.CreatedAt,
		&i.AddedBy,
	)
	return i, err
}

const deleteExhibitionClientByID = `-- name: DeleteExhibitionClientByID :exec
DELETE FROM exhibition_clients
WHERE id = $1
`

func (q *Queries) DeleteExhibitionClientByID(ctx context.Context, id int64) error {
	_, err := q.db.Exec(ctx, deleteExhibitionClientByID, id)
	return err
}

const getAllExhibitionClients = `-- name: GetAllExhibitionClients :many
SELECT exhibition_clients.id, exhibition_clients.exhibitions_id, exhibition_clients.ref_no, exhibition_clients.client_name, exhibition_clients.client_email, exhibition_clients.website, exhibition_clients.logo_url, exhibition_clients.created_at, exhibition_clients.added_by,exhibitions.title AS "exhibition name"
FROM exhibition_clients
INNER JOIN exhibitions 
ON exhibitions.id = exhibition_clients.exhibitions_id AND exhibitions.event_status !=5
ORDER BY exhibition_clients.id DESC
LIMIT $1
OFFSET $2
`

type GetAllExhibitionClientsParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

type GetAllExhibitionClientsRow struct {
	ID             int64       `json:"id"`
	ExhibitionsID  int64       `json:"exhibitions_id"`
	RefNo          string      `json:"ref_no"`
	ClientName     string      `json:"client_name"`
	ClientEmail    string      `json:"client_email"`
	Website        pgtype.Text `json:"website"`
	LogoUrl        pgtype.Text `json:"logo_url"`
	CreatedAt      time.Time   `json:"created_at"`
	AddedBy        int64       `json:"added_by"`
	ExhibitionName string      `json:"exhibition name"`
}

func (q *Queries) GetAllExhibitionClients(ctx context.Context, arg GetAllExhibitionClientsParams) ([]GetAllExhibitionClientsRow, error) {
	rows, err := q.db.Query(ctx, getAllExhibitionClients, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAllExhibitionClientsRow
	for rows.Next() {
		var i GetAllExhibitionClientsRow
		if err := rows.Scan(
			&i.ID,
			&i.ExhibitionsID,
			&i.RefNo,
			&i.ClientName,
			&i.ClientEmail,
			&i.Website,
			&i.LogoUrl,
			&i.CreatedAt,
			&i.AddedBy,
			&i.ExhibitionName,
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

const getExhibitionClientByID = `-- name: GetExhibitionClientByID :one
SELECT exhibition_clients.id, exhibition_clients.exhibitions_id, exhibition_clients.ref_no, exhibition_clients.client_name, exhibition_clients.client_email, exhibition_clients.website, exhibition_clients.logo_url, exhibition_clients.created_at, exhibition_clients.added_by
FROM exhibition_clients
INNER JOIN exhibitions 
ON exhibitions.id = exhibition_clients.exhibitions_id AND exhibitions.event_status !=5 
WHERE exhibition_clients.id = $1
`

func (q *Queries) GetExhibitionClientByID(ctx context.Context, id int64) (ExhibitionClient, error) {
	row := q.db.QueryRow(ctx, getExhibitionClientByID, id)
	var i ExhibitionClient
	err := row.Scan(
		&i.ID,
		&i.ExhibitionsID,
		&i.RefNo,
		&i.ClientName,
		&i.ClientEmail,
		&i.Website,
		&i.LogoUrl,
		&i.CreatedAt,
		&i.AddedBy,
	)
	return i, err
}

const getNumberOfExhibitionClients = `-- name: GetNumberOfExhibitionClients :one
SELECT COUNT(exhibition_clients.id) 
FROM exhibition_clients
INNER JOIN exhibitions 
ON exhibitions.id = exhibition_clients.exhibitions_id AND exhibitions.event_status !=5
`

func (q *Queries) GetNumberOfExhibitionClients(ctx context.Context) (int64, error) {
	row := q.db.QueryRow(ctx, getNumberOfExhibitionClients)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const updateExhibitionClientByID = `-- name: UpdateExhibitionClientByID :one
UPDATE exhibition_clients
SET 
    exhibitions_id = $2,
    ref_no = $3,
    client_name = $4,
    website = $5,
    logo_url = $6, 
    client_email=$7
WHERE
    id = $1
RETURNING id, exhibitions_id, ref_no, client_name, client_email, website, logo_url, created_at, added_by
`

type UpdateExhibitionClientByIDParams struct {
	ID            int64       `json:"id"`
	ExhibitionsID int64       `json:"exhibitions_id"`
	RefNo         string      `json:"ref_no"`
	ClientName    string      `json:"client_name"`
	Website       pgtype.Text `json:"website"`
	LogoUrl       pgtype.Text `json:"logo_url"`
	ClientEmail   string      `json:"client_email"`
}

func (q *Queries) UpdateExhibitionClientByID(ctx context.Context, arg UpdateExhibitionClientByIDParams) (ExhibitionClient, error) {
	row := q.db.QueryRow(ctx, updateExhibitionClientByID,
		arg.ID,
		arg.ExhibitionsID,
		arg.RefNo,
		arg.ClientName,
		arg.Website,
		arg.LogoUrl,
		arg.ClientEmail,
	)
	var i ExhibitionClient
	err := row.Scan(
		&i.ID,
		&i.ExhibitionsID,
		&i.RefNo,
		&i.ClientName,
		&i.ClientEmail,
		&i.Website,
		&i.LogoUrl,
		&i.CreatedAt,
		&i.AddedBy,
	)
	return i, err
}
