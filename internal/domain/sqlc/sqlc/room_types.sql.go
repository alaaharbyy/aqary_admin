// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: room_types.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createRoomType = `-- name: CreateRoomType :one
INSERT INTO room_types (company_types_id, is_branch, companies_id, title, title_ar, smart_room, is_luxury, views, facilities,created_at,status) 
VALUES ( $1, $2, $3, $4, $5, $6, $7, $8, $9,$10,$11) RETURNING id, company_types_id, is_branch, companies_id, title, title_ar, smart_room, is_luxury, views, facilities, created_at, status
`

type CreateRoomTypeParams struct {
	CompanyTypesID pgtype.Int8 `json:"company_types_id"`
	IsBranch       pgtype.Bool `json:"is_branch"`
	CompaniesID    pgtype.Int8 `json:"companies_id"`
	Title          string      `json:"title"`
	TitleAr        pgtype.Text `json:"title_ar"`
	SmartRoom      pgtype.Bool `json:"smart_room"`
	IsLuxury       pgtype.Bool `json:"is_luxury"`
	Views          []int64     `json:"views"`
	Facilities     []int64     `json:"facilities"`
	CreatedAt      time.Time   `json:"created_at"`
	Status         int64       `json:"status"`
}

func (q *Queries) CreateRoomType(ctx context.Context, arg CreateRoomTypeParams) (RoomType, error) {
	row := q.db.QueryRow(ctx, createRoomType,
		arg.CompanyTypesID,
		arg.IsBranch,
		arg.CompaniesID,
		arg.Title,
		arg.TitleAr,
		arg.SmartRoom,
		arg.IsLuxury,
		arg.Views,
		arg.Facilities,
		arg.CreatedAt,
		arg.Status,
	)
	var i RoomType
	err := row.Scan(
		&i.ID,
		&i.CompanyTypesID,
		&i.IsBranch,
		&i.CompaniesID,
		&i.Title,
		&i.TitleAr,
		&i.SmartRoom,
		&i.IsLuxury,
		&i.Views,
		&i.Facilities,
		&i.CreatedAt,
		&i.Status,
	)
	return i, err
}

const getAllRoomType = `-- name: GetAllRoomType :many
SELECT  id, company_types_id, is_branch, companies_id, title, title_ar, smart_room, is_luxury, views, facilities, created_at, status FROM room_types
`

func (q *Queries) GetAllRoomType(ctx context.Context) ([]RoomType, error) {
	rows, err := q.db.Query(ctx, getAllRoomType)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []RoomType
	for rows.Next() {
		var i RoomType
		if err := rows.Scan(
			&i.ID,
			&i.CompanyTypesID,
			&i.IsBranch,
			&i.CompaniesID,
			&i.Title,
			&i.TitleAr,
			&i.SmartRoom,
			&i.IsLuxury,
			&i.Views,
			&i.Facilities,
			&i.CreatedAt,
			&i.Status,
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

const getAllRoomTypes = `-- name: GetAllRoomTypes :many
SELECT
  id, company_types_id, is_branch, companies_id, title, title_ar, smart_room, is_luxury, views, facilities, created_at, status
FROM
    room_types
ORDER BY
    id
LIMIT $1
OFFSET $2
`

type GetAllRoomTypesParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) GetAllRoomTypes(ctx context.Context, arg GetAllRoomTypesParams) ([]RoomType, error) {
	rows, err := q.db.Query(ctx, getAllRoomTypes, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []RoomType
	for rows.Next() {
		var i RoomType
		if err := rows.Scan(
			&i.ID,
			&i.CompanyTypesID,
			&i.IsBranch,
			&i.CompaniesID,
			&i.Title,
			&i.TitleAr,
			&i.SmartRoom,
			&i.IsLuxury,
			&i.Views,
			&i.Facilities,
			&i.CreatedAt,
			&i.Status,
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

const getRoomTypeByID = `-- name: GetRoomTypeByID :one
SELECT id, company_types_id, is_branch, companies_id, title, title_ar, smart_room, is_luxury, views, facilities, created_at, status FROM room_types WHERE id=$1
`

func (q *Queries) GetRoomTypeByID(ctx context.Context, id int64) (RoomType, error) {
	row := q.db.QueryRow(ctx, getRoomTypeByID, id)
	var i RoomType
	err := row.Scan(
		&i.ID,
		&i.CompanyTypesID,
		&i.IsBranch,
		&i.CompaniesID,
		&i.Title,
		&i.TitleAr,
		&i.SmartRoom,
		&i.IsLuxury,
		&i.Views,
		&i.Facilities,
		&i.CreatedAt,
		&i.Status,
	)
	return i, err
}

const updateRoomType = `-- name: UpdateRoomType :one
UPDATE room_types 
SET 
    company_types_id = $2,
    is_branch = $3,
    companies_id = $4,
    title = $5,
    title_ar =$6,
    smart_room = $7,
    is_luxury = $8,
    views = $9,
    facilities = $10,
    created_at = $11,
    status = $12
WHERE id = $1
RETURNING id, company_types_id, is_branch, companies_id, title, title_ar, smart_room, is_luxury, views, facilities, created_at, status
`

type UpdateRoomTypeParams struct {
	ID             int64       `json:"id"`
	CompanyTypesID pgtype.Int8 `json:"company_types_id"`
	IsBranch       pgtype.Bool `json:"is_branch"`
	CompaniesID    pgtype.Int8 `json:"companies_id"`
	Title          string      `json:"title"`
	TitleAr        pgtype.Text `json:"title_ar"`
	SmartRoom      pgtype.Bool `json:"smart_room"`
	IsLuxury       pgtype.Bool `json:"is_luxury"`
	Views          []int64     `json:"views"`
	Facilities     []int64     `json:"facilities"`
	CreatedAt      time.Time   `json:"created_at"`
	Status         int64       `json:"status"`
}

func (q *Queries) UpdateRoomType(ctx context.Context, arg UpdateRoomTypeParams) (RoomType, error) {
	row := q.db.QueryRow(ctx, updateRoomType,
		arg.ID,
		arg.CompanyTypesID,
		arg.IsBranch,
		arg.CompaniesID,
		arg.Title,
		arg.TitleAr,
		arg.SmartRoom,
		arg.IsLuxury,
		arg.Views,
		arg.Facilities,
		arg.CreatedAt,
		arg.Status,
	)
	var i RoomType
	err := row.Scan(
		&i.ID,
		&i.CompanyTypesID,
		&i.IsBranch,
		&i.CompaniesID,
		&i.Title,
		&i.TitleAr,
		&i.SmartRoom,
		&i.IsLuxury,
		&i.Views,
		&i.Facilities,
		&i.CreatedAt,
		&i.Status,
	)
	return i, err
}

const updateRoomTypeStatus = `-- name: UpdateRoomTypeStatus :one
UPDATE room_types 
SET 
    status = $2
WHERE id = $1
RETURNING id, company_types_id, is_branch, companies_id, title, title_ar, smart_room, is_luxury, views, facilities, created_at, status
`

type UpdateRoomTypeStatusParams struct {
	ID     int64 `json:"id"`
	Status int64 `json:"status"`
}

func (q *Queries) UpdateRoomTypeStatus(ctx context.Context, arg UpdateRoomTypeStatusParams) (RoomType, error) {
	row := q.db.QueryRow(ctx, updateRoomTypeStatus, arg.ID, arg.Status)
	var i RoomType
	err := row.Scan(
		&i.ID,
		&i.CompanyTypesID,
		&i.IsBranch,
		&i.CompaniesID,
		&i.Title,
		&i.TitleAr,
		&i.SmartRoom,
		&i.IsLuxury,
		&i.Views,
		&i.Facilities,
		&i.CreatedAt,
		&i.Status,
	)
	return i, err
}
