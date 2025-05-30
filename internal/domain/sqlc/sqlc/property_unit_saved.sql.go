// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: property_unit_saved.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createPropertyUnitSaved = `-- name: CreatePropertyUnitSaved :one
INSERT INTO property_unit_saved (
    property_unit_id,
    which_property_unit,
    which_propertyhub_key,
    is_branch,
    is_saved,
    collection_name_id,
    users_id,
    created_at,
    updated_at
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7, $8, $9
) RETURNING id, property_unit_id, which_property_unit, which_propertyhub_key, is_branch, is_saved, collection_name_id, users_id, created_at, updated_at
`

type CreatePropertyUnitSavedParams struct {
	PropertyUnitID      int64       `json:"property_unit_id"`
	WhichPropertyUnit   int64       `json:"which_property_unit"`
	WhichPropertyhubKey pgtype.Int8 `json:"which_propertyhub_key"`
	IsBranch            bool        `json:"is_branch"`
	IsSaved             bool        `json:"is_saved"`
	CollectionNameID    int64       `json:"collection_name_id"`
	UsersID             int64       `json:"users_id"`
	CreatedAt           time.Time   `json:"created_at"`
	UpdatedAt           time.Time   `json:"updated_at"`
}

func (q *Queries) CreatePropertyUnitSaved(ctx context.Context, arg CreatePropertyUnitSavedParams) (PropertyUnitSaved, error) {
	row := q.db.QueryRow(ctx, createPropertyUnitSaved,
		arg.PropertyUnitID,
		arg.WhichPropertyUnit,
		arg.WhichPropertyhubKey,
		arg.IsBranch,
		arg.IsSaved,
		arg.CollectionNameID,
		arg.UsersID,
		arg.CreatedAt,
		arg.UpdatedAt,
	)
	var i PropertyUnitSaved
	err := row.Scan(
		&i.ID,
		&i.PropertyUnitID,
		&i.WhichPropertyUnit,
		&i.WhichPropertyhubKey,
		&i.IsBranch,
		&i.IsSaved,
		&i.CollectionNameID,
		&i.UsersID,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const deletePropertyUnitSaved = `-- name: DeletePropertyUnitSaved :exec
DELETE FROM property_unit_saved
Where id = $1
`

func (q *Queries) DeletePropertyUnitSaved(ctx context.Context, id int64) error {
	_, err := q.db.Exec(ctx, deletePropertyUnitSaved, id)
	return err
}

const getAllPropertyUnitSaved = `-- name: GetAllPropertyUnitSaved :many
SELECT id, property_unit_id, which_property_unit, which_propertyhub_key, is_branch, is_saved, collection_name_id, users_id, created_at, updated_at FROM property_unit_saved
ORDER BY id
LIMIT $1
OFFSET $2
`

type GetAllPropertyUnitSavedParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) GetAllPropertyUnitSaved(ctx context.Context, arg GetAllPropertyUnitSavedParams) ([]PropertyUnitSaved, error) {
	rows, err := q.db.Query(ctx, getAllPropertyUnitSaved, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []PropertyUnitSaved
	for rows.Next() {
		var i PropertyUnitSaved
		if err := rows.Scan(
			&i.ID,
			&i.PropertyUnitID,
			&i.WhichPropertyUnit,
			&i.WhichPropertyhubKey,
			&i.IsBranch,
			&i.IsSaved,
			&i.CollectionNameID,
			&i.UsersID,
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

const getAllPropertyUnitSavedByPropertyIdAndIdAndWhichProperty = `-- name: GetAllPropertyUnitSavedByPropertyIdAndIdAndWhichProperty :many
SELECT id FROM property_unit_saved 
WHERE property_unit_id = $1 And which_property_unit = $2 AND is_branch = $3 AND users_id = $4 AND is_saved=TRUE
`

type GetAllPropertyUnitSavedByPropertyIdAndIdAndWhichPropertyParams struct {
	PropertyUnitID    int64 `json:"property_unit_id"`
	WhichPropertyUnit int64 `json:"which_property_unit"`
	IsBranch          bool  `json:"is_branch"`
	UsersID           int64 `json:"users_id"`
}

func (q *Queries) GetAllPropertyUnitSavedByPropertyIdAndIdAndWhichProperty(ctx context.Context, arg GetAllPropertyUnitSavedByPropertyIdAndIdAndWhichPropertyParams) ([]int64, error) {
	rows, err := q.db.Query(ctx, getAllPropertyUnitSavedByPropertyIdAndIdAndWhichProperty,
		arg.PropertyUnitID,
		arg.WhichPropertyUnit,
		arg.IsBranch,
		arg.UsersID,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []int64
	for rows.Next() {
		var id int64
		if err := rows.Scan(&id); err != nil {
			return nil, err
		}
		items = append(items, id)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getPropertyUnitSaved = `-- name: GetPropertyUnitSaved :one
SELECT id, property_unit_id, which_property_unit, which_propertyhub_key, is_branch, is_saved, collection_name_id, users_id, created_at, updated_at FROM property_unit_saved 
WHERE id = $1 LIMIT 1
`

func (q *Queries) GetPropertyUnitSaved(ctx context.Context, id int64) (PropertyUnitSaved, error) {
	row := q.db.QueryRow(ctx, getPropertyUnitSaved, id)
	var i PropertyUnitSaved
	err := row.Scan(
		&i.ID,
		&i.PropertyUnitID,
		&i.WhichPropertyUnit,
		&i.WhichPropertyhubKey,
		&i.IsBranch,
		&i.IsSaved,
		&i.CollectionNameID,
		&i.UsersID,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const getPropertyUnitSavedByPropertyIdAndIdAndWhichProperty = `-- name: GetPropertyUnitSavedByPropertyIdAndIdAndWhichProperty :one
SELECT id, property_unit_id, which_property_unit, which_propertyhub_key, is_branch, is_saved, collection_name_id, users_id, created_at, updated_at FROM property_unit_saved 
WHERE property_unit_id = $1 And which_property_unit = $2 AND is_branch = $3 AND users_id = $4
`

type GetPropertyUnitSavedByPropertyIdAndIdAndWhichPropertyParams struct {
	PropertyUnitID    int64 `json:"property_unit_id"`
	WhichPropertyUnit int64 `json:"which_property_unit"`
	IsBranch          bool  `json:"is_branch"`
	UsersID           int64 `json:"users_id"`
}

func (q *Queries) GetPropertyUnitSavedByPropertyIdAndIdAndWhichProperty(ctx context.Context, arg GetPropertyUnitSavedByPropertyIdAndIdAndWhichPropertyParams) (PropertyUnitSaved, error) {
	row := q.db.QueryRow(ctx, getPropertyUnitSavedByPropertyIdAndIdAndWhichProperty,
		arg.PropertyUnitID,
		arg.WhichPropertyUnit,
		arg.IsBranch,
		arg.UsersID,
	)
	var i PropertyUnitSaved
	err := row.Scan(
		&i.ID,
		&i.PropertyUnitID,
		&i.WhichPropertyUnit,
		&i.WhichPropertyhubKey,
		&i.IsBranch,
		&i.IsSaved,
		&i.CollectionNameID,
		&i.UsersID,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const getPropertyUnitSavedByPropertyIdAndIdAndWhichPropertyAndCollectionId = `-- name: GetPropertyUnitSavedByPropertyIdAndIdAndWhichPropertyAndCollectionId :one
SELECT id, property_unit_id, which_property_unit, which_propertyhub_key, is_branch, is_saved, collection_name_id, users_id, created_at, updated_at FROM property_unit_saved 
WHERE  property_unit_id = $1 And which_property_unit = $2 AND
is_branch = $3 AND users_id = $4 AND collection_name_id = $5  LIMIT 1
`

type GetPropertyUnitSavedByPropertyIdAndIdAndWhichPropertyAndCollectionIdParams struct {
	PropertyUnitID    int64 `json:"property_unit_id"`
	WhichPropertyUnit int64 `json:"which_property_unit"`
	IsBranch          bool  `json:"is_branch"`
	UsersID           int64 `json:"users_id"`
	CollectionNameID  int64 `json:"collection_name_id"`
}

func (q *Queries) GetPropertyUnitSavedByPropertyIdAndIdAndWhichPropertyAndCollectionId(ctx context.Context, arg GetPropertyUnitSavedByPropertyIdAndIdAndWhichPropertyAndCollectionIdParams) (PropertyUnitSaved, error) {
	row := q.db.QueryRow(ctx, getPropertyUnitSavedByPropertyIdAndIdAndWhichPropertyAndCollectionId,
		arg.PropertyUnitID,
		arg.WhichPropertyUnit,
		arg.IsBranch,
		arg.UsersID,
		arg.CollectionNameID,
	)
	var i PropertyUnitSaved
	err := row.Scan(
		&i.ID,
		&i.PropertyUnitID,
		&i.WhichPropertyUnit,
		&i.WhichPropertyhubKey,
		&i.IsBranch,
		&i.IsSaved,
		&i.CollectionNameID,
		&i.UsersID,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const updatePropertyUnitSaved = `-- name: UpdatePropertyUnitSaved :one
UPDATE property_unit_saved
SET property_unit_id = $2,
    which_property_unit = $3,
    which_propertyhub_key = $4,
    is_branch = $5,
    is_saved = $6,
    collection_name_id = $7,
    users_id = $8,
    created_at = $9,
    updated_at = $10
Where id = $1
RETURNING id, property_unit_id, which_property_unit, which_propertyhub_key, is_branch, is_saved, collection_name_id, users_id, created_at, updated_at
`

type UpdatePropertyUnitSavedParams struct {
	ID                  int64       `json:"id"`
	PropertyUnitID      int64       `json:"property_unit_id"`
	WhichPropertyUnit   int64       `json:"which_property_unit"`
	WhichPropertyhubKey pgtype.Int8 `json:"which_propertyhub_key"`
	IsBranch            bool        `json:"is_branch"`
	IsSaved             bool        `json:"is_saved"`
	CollectionNameID    int64       `json:"collection_name_id"`
	UsersID             int64       `json:"users_id"`
	CreatedAt           time.Time   `json:"created_at"`
	UpdatedAt           time.Time   `json:"updated_at"`
}

func (q *Queries) UpdatePropertyUnitSaved(ctx context.Context, arg UpdatePropertyUnitSavedParams) (PropertyUnitSaved, error) {
	row := q.db.QueryRow(ctx, updatePropertyUnitSaved,
		arg.ID,
		arg.PropertyUnitID,
		arg.WhichPropertyUnit,
		arg.WhichPropertyhubKey,
		arg.IsBranch,
		arg.IsSaved,
		arg.CollectionNameID,
		arg.UsersID,
		arg.CreatedAt,
		arg.UpdatedAt,
	)
	var i PropertyUnitSaved
	err := row.Scan(
		&i.ID,
		&i.PropertyUnitID,
		&i.WhichPropertyUnit,
		&i.WhichPropertyhubKey,
		&i.IsBranch,
		&i.IsSaved,
		&i.CollectionNameID,
		&i.UsersID,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}
