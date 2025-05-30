// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: sub_category.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createSubDocumentCategory = `-- name: CreateSubDocumentCategory :one
INSERT INTO 
	documents_subcategory (sub_category,created_at,updated_at,documents_category_id,status,sub_category_ar)
SELECT $1,$2,$3,$4,$5,$6
FROM 
	documents_category
WHERE 
	id= $4::BIGINT AND status!=6
RETURNING 1
`

type CreateSubDocumentCategoryParams struct {
	SubCategory         string      `json:"sub_category"`
	CreatedAt           time.Time   `json:"created_at"`
	UpdatedAt           time.Time   `json:"updated_at"`
	DocumentsCategoryID int64       `json:"documents_category_id"`
	Status              int64       `json:"status"`
	SubCategoryAr       pgtype.Text `json:"sub_category_ar"`
}

func (q *Queries) CreateSubDocumentCategory(ctx context.Context, arg CreateSubDocumentCategoryParams) (pgtype.Int8, error) {
	row := q.db.QueryRow(ctx, createSubDocumentCategory,
		arg.SubCategory,
		arg.CreatedAt,
		arg.UpdatedAt,
		arg.DocumentsCategoryID,
		arg.Status,
		arg.SubCategoryAr,
	)
	var column_1 pgtype.Int8
	err := row.Scan(&column_1)
	return column_1, err
}

const deleteRestoreSubDocumentCategory = `-- name: DeleteRestoreSubDocumentCategory :one
UPDATE documents_subcategory
SET 
	status=$2, 
	updated_at=$3 
WHERE 
	id=$1 RETURNING id
`

type DeleteRestoreSubDocumentCategoryParams struct {
	ID        int64     `json:"id"`
	Status    int64     `json:"status"`
	UpdatedAt time.Time `json:"updated_at"`
}

func (q *Queries) DeleteRestoreSubDocumentCategory(ctx context.Context, arg DeleteRestoreSubDocumentCategoryParams) (int64, error) {
	row := q.db.QueryRow(ctx, deleteRestoreSubDocumentCategory, arg.ID, arg.Status, arg.UpdatedAt)
	var id int64
	err := row.Scan(&id)
	return id, err
}

const getAllSubDocumentCategories = `-- name: GetAllSubDocumentCategories :many
SELECT id,sub_category,updated_at,sub_category_ar
FROM 
	documents_subcategory
WHERE 
	status=$1 AND documents_category_id= $2::BIGINT
ORDER BY updated_at DESC 
LIMIT $4 OFFSET $3
`

type GetAllSubDocumentCategoriesParams struct {
	Status             int64       `json:"status"`
	DocumentCategoryID int64       `json:"document_category_id"`
	Offset             pgtype.Int4 `json:"offset"`
	Limit              pgtype.Int4 `json:"limit"`
}

type GetAllSubDocumentCategoriesRow struct {
	ID            int64       `json:"id"`
	SubCategory   string      `json:"sub_category"`
	UpdatedAt     time.Time   `json:"updated_at"`
	SubCategoryAr pgtype.Text `json:"sub_category_ar"`
}

func (q *Queries) GetAllSubDocumentCategories(ctx context.Context, arg GetAllSubDocumentCategoriesParams) ([]GetAllSubDocumentCategoriesRow, error) {
	rows, err := q.db.Query(ctx, getAllSubDocumentCategories,
		arg.Status,
		arg.DocumentCategoryID,
		arg.Offset,
		arg.Limit,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAllSubDocumentCategoriesRow
	for rows.Next() {
		var i GetAllSubDocumentCategoriesRow
		if err := rows.Scan(
			&i.ID,
			&i.SubCategory,
			&i.UpdatedAt,
			&i.SubCategoryAr,
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

const getNumberOfSubDocumentCategories = `-- name: GetNumberOfSubDocumentCategories :one
SELECT COUNT(*) 
FROM 
	documents_subcategory
WHERE 
	status=$1 AND documents_category_id= $2::BIGINT
`

type GetNumberOfSubDocumentCategoriesParams struct {
	Status             int64 `json:"status"`
	DocumentCategoryID int64 `json:"document_category_id"`
}

func (q *Queries) GetNumberOfSubDocumentCategories(ctx context.Context, arg GetNumberOfSubDocumentCategoriesParams) (int64, error) {
	row := q.db.QueryRow(ctx, getNumberOfSubDocumentCategories, arg.Status, arg.DocumentCategoryID)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const getSubDocumentCategoryByID = `-- name: GetSubDocumentCategoryByID :one
SELECT id,sub_category,sub_category_ar
FROM 
	documents_subcategory
WHERE 
	id=$1 AND status!=6
`

type GetSubDocumentCategoryByIDRow struct {
	ID            int64       `json:"id"`
	SubCategory   string      `json:"sub_category"`
	SubCategoryAr pgtype.Text `json:"sub_category_ar"`
}

func (q *Queries) GetSubDocumentCategoryByID(ctx context.Context, id int64) (GetSubDocumentCategoryByIDRow, error) {
	row := q.db.QueryRow(ctx, getSubDocumentCategoryByID, id)
	var i GetSubDocumentCategoryByIDRow
	err := row.Scan(&i.ID, &i.SubCategory, &i.SubCategoryAr)
	return i, err
}

const updateSubDocumentCategory = `-- name: UpdateSubDocumentCategory :exec
UPDATE 
	documents_subcategory
SET 
	sub_category=$2,
	updated_at=$3,
	sub_category_ar=$4
WHERE	
	id=$1 AND status!=6
`

type UpdateSubDocumentCategoryParams struct {
	ID            int64       `json:"id"`
	SubCategory   string      `json:"sub_category"`
	UpdatedAt     time.Time   `json:"updated_at"`
	SubCategoryAr pgtype.Text `json:"sub_category_ar"`
}

func (q *Queries) UpdateSubDocumentCategory(ctx context.Context, arg UpdateSubDocumentCategoryParams) error {
	_, err := q.db.Exec(ctx, updateSubDocumentCategory,
		arg.ID,
		arg.SubCategory,
		arg.UpdatedAt,
		arg.SubCategoryAr,
	)
	return err
}
