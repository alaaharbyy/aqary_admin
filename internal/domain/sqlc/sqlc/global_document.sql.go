// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: global_document.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createGlobalDocument = `-- name: CreateGlobalDocument :one
INSERT INTO global_documents (
    documents_category_id, 
    documents_subcategory_id, 
    file_url,
    entity_id,
    entity_type_id,
    created_at,
    updated_at
) VALUES (
    $1, 
    $2, 
    $3, 
    $4, 
    $5, 
    $6, 
    $7)RETURNING id, documents_category_id, documents_subcategory_id, file_url, entity_id, entity_type_id, created_at, updated_at
`

type CreateGlobalDocumentParams struct {
	DocumentsCategoryID    int64     `json:"documents_category_id"`
	DocumentsSubcategoryID int64     `json:"documents_subcategory_id"`
	FileUrl                []string  `json:"file_url"`
	EntityID               int64     `json:"entity_id"`
	EntityTypeID           int64     `json:"entity_type_id"`
	CreatedAt              time.Time `json:"created_at"`
	UpdatedAt              time.Time `json:"updated_at"`
}

func (q *Queries) CreateGlobalDocument(ctx context.Context, arg CreateGlobalDocumentParams) (GlobalDocument, error) {
	row := q.db.QueryRow(ctx, createGlobalDocument,
		arg.DocumentsCategoryID,
		arg.DocumentsSubcategoryID,
		arg.FileUrl,
		arg.EntityID,
		arg.EntityTypeID,
		arg.CreatedAt,
		arg.UpdatedAt,
	)
	var i GlobalDocument
	err := row.Scan(
		&i.ID,
		&i.DocumentsCategoryID,
		&i.DocumentsSubcategoryID,
		&i.FileUrl,
		&i.EntityID,
		&i.EntityTypeID,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const deleteEntityGlobalDocument = `-- name: DeleteEntityGlobalDocument :exec
DELETE FROM global_documents WHERE id=$1
`

func (q *Queries) DeleteEntityGlobalDocument(ctx context.Context, id int64) error {
	_, err := q.db.Exec(ctx, deleteEntityGlobalDocument, id)
	return err
}

const deleteEntityGlobalDocumentByDocumentId = `-- name: DeleteEntityGlobalDocumentByDocumentId :one
DELETE FROM global_documents WHERE global_documents.id =$1 AND 
COALESCE((SELECT CASE  global_documents.entity_type_id::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = global_documents.entity_id::BIGINT)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = global_documents.entity_id::BIGINT)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = global_documents.entity_id::BIGINT)
              -- WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = global_documents.entity_id::BIGINT)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = global_documents.entity_id::BIGINT)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = global_documents.entity_id::BIGINT)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = global_documents.entity_id::BIGINT)
              -- WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = global_documents.entity_id::BIGINT)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = global_documents.entity_id::BIGINT)
              -- WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = global_documents.entity_id::BIGINT)
               ELSE 0::BIGINT
           END),6::BIGINT) NOT IN (0,6)
RETURNING global_documents.file_url
`

func (q *Queries) DeleteEntityGlobalDocumentByDocumentId(ctx context.Context, id int64) ([]string, error) {
	row := q.db.QueryRow(ctx, deleteEntityGlobalDocumentByDocumentId, id)
	var file_url []string
	err := row.Scan(&file_url)
	return file_url, err
}

const deleteEntityGlobalDocumentByURL = `-- name: DeleteEntityGlobalDocumentByURL :one
UPDATE global_documents 
SET 
	file_url = array_remove(file_url, $2::VARCHAR),
	updated_at=$1 
WHERE 
	global_documents.id= $3 AND $2::VARCHAR = ANY(file_url) AND 
	COALESCE((SELECT CASE  global_documents.entity_type_id::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = global_documents.entity_id::BIGINT)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = global_documents.entity_id::BIGINT)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = global_documents.entity_id::BIGINT)
              -- WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = global_documents.entity_id::BIGINT)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = global_documents.entity_id::BIGINT)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = global_documents.entity_id::BIGINT)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = global_documents.entity_id::BIGINT)
              -- WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = global_documents.entity_id::BIGINT)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = global_documents.entity_id::BIGINT)
              -- WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = global_documents.entity_id::BIGINT)
               ELSE 0::BIGINT
           END),6::BIGINT) NOT IN (0,6)
RETURNING id, documents_category_id, documents_subcategory_id, file_url, entity_id, entity_type_id, created_at, updated_at
`

type DeleteEntityGlobalDocumentByURLParams struct {
	UpdatedAt  time.Time `json:"updated_at"`
	FileUrl    string    `json:"file_url"`
	DocumentID int64     `json:"document_id"`
}

func (q *Queries) DeleteEntityGlobalDocumentByURL(ctx context.Context, arg DeleteEntityGlobalDocumentByURLParams) (GlobalDocument, error) {
	row := q.db.QueryRow(ctx, deleteEntityGlobalDocumentByURL, arg.UpdatedAt, arg.FileUrl, arg.DocumentID)
	var i GlobalDocument
	err := row.Scan(
		&i.ID,
		&i.DocumentsCategoryID,
		&i.DocumentsSubcategoryID,
		&i.FileUrl,
		&i.EntityID,
		&i.EntityTypeID,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const getAllEntityTypes = `-- name: GetAllEntityTypes :many
SELECT id, name FROM entity_type
`

func (q *Queries) GetAllEntityTypes(ctx context.Context) ([]EntityType, error) {
	rows, err := q.db.Query(ctx, getAllEntityTypes)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []EntityType
	for rows.Next() {
		var i EntityType
		if err := rows.Scan(&i.ID, &i.Name); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getAllParentDocCategory = `-- name: GetAllParentDocCategory :many
SELECT
    DISTINCT global_documents.documents_category_id, documents_category.category,documents_category.category_ar,
    global_documents.entity_id AS parent_id, global_documents.entity_type_id as parent_type_id
FROM 
    global_documents
    join documents_category on global_documents.documents_category_id = documents_category.id
WHERE global_documents.entity_type_id = $1 and global_documents.entity_id = $2
`

type GetAllParentDocCategoryParams struct {
	EntityTypeID int64 `json:"entity_type_id"`
	EntityID     int64 `json:"entity_id"`
}

type GetAllParentDocCategoryRow struct {
	DocumentsCategoryID int64       `json:"documents_category_id"`
	Category            string      `json:"category"`
	CategoryAr          pgtype.Text `json:"category_ar"`
	ParentID            int64       `json:"parent_id"`
	ParentTypeID        int64       `json:"parent_type_id"`
}

func (q *Queries) GetAllParentDocCategory(ctx context.Context, arg GetAllParentDocCategoryParams) ([]GetAllParentDocCategoryRow, error) {
	rows, err := q.db.Query(ctx, getAllParentDocCategory, arg.EntityTypeID, arg.EntityID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAllParentDocCategoryRow
	for rows.Next() {
		var i GetAllParentDocCategoryRow
		if err := rows.Scan(
			&i.DocumentsCategoryID,
			&i.Category,
			&i.CategoryAr,
			&i.ParentID,
			&i.ParentTypeID,
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

const getAllParentDocSubCategory = `-- name: GetAllParentDocSubCategory :many
SELECT DISTINCT global_documents.documents_subcategory_id AS id, documents_subcategory.sub_category AS title ,documents_subcategory.sub_category_ar AS title_ar
FROM global_documents
JOIN documents_subcategory on global_documents.documents_subcategory_id = documents_subcategory.id
WHERE global_documents.documents_category_id = $1 AND global_documents.entity_id = $2 AND global_documents.entity_type_id = $3
`

type GetAllParentDocSubCategoryParams struct {
	DocumentsCategoryID int64 `json:"documents_category_id"`
	EntityID            int64 `json:"entity_id"`
	EntityTypeID        int64 `json:"entity_type_id"`
}

type GetAllParentDocSubCategoryRow struct {
	ID      int64       `json:"id"`
	Title   string      `json:"title"`
	TitleAr pgtype.Text `json:"title_ar"`
}

func (q *Queries) GetAllParentDocSubCategory(ctx context.Context, arg GetAllParentDocSubCategoryParams) ([]GetAllParentDocSubCategoryRow, error) {
	rows, err := q.db.Query(ctx, getAllParentDocSubCategory, arg.DocumentsCategoryID, arg.EntityID, arg.EntityTypeID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAllParentDocSubCategoryRow
	for rows.Next() {
		var i GetAllParentDocSubCategoryRow
		if err := rows.Scan(&i.ID, &i.Title, &i.TitleAr); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getDocumentById = `-- name: GetDocumentById :one
SELECT id, documents_category_id, documents_subcategory_id, file_url, entity_id, entity_type_id, created_at, updated_at FROM global_documents
Where global_documents.id = $1
`

func (q *Queries) GetDocumentById(ctx context.Context, id int64) (GlobalDocument, error) {
	row := q.db.QueryRow(ctx, getDocumentById, id)
	var i GlobalDocument
	err := row.Scan(
		&i.ID,
		&i.DocumentsCategoryID,
		&i.DocumentsSubcategoryID,
		&i.FileUrl,
		&i.EntityID,
		&i.EntityTypeID,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const getEntityIdGlobalDocuments = `-- name: GetEntityIdGlobalDocuments :many
SELECT global_documents.id AS "global_document_id",documents_category.category,documents_category.category_ar,documents_category.id AS "category_id",documents_subcategory.sub_category,documents_subcategory.sub_category_ar,documents_subcategory.id AS "sub_category_id",global_documents.entity_id AS "entity_id" , global_documents.entity_type_id AS "entity_type_id" ,global_documents.created_at,global_documents.updated_at,global_documents.file_url
FROM 
	global_documents
INNER JOIN 
	documents_category ON documents_category.id = global_documents.documents_category_id 
INNER JOIN 
	documents_subcategory ON documents_subcategory.id = global_documents.documents_subcategory_id
WHERE 
	entity_id= $1::BIGINT AND entity_type_id= $2::BIGINT AND
	COALESCE((SELECT CASE  global_documents.entity_type_id::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = global_documents.entity_id::BIGINT)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = global_documents.entity_id::BIGINT)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = global_documents.entity_id::BIGINT)
              -- WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = global_documents.entity_id::BIGINT)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = global_documents.entity_id::BIGINT)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = global_documents.entity_id::BIGINT)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = global_documents.entity_id::BIGINT)
               --WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = global_documents.entity_id::BIGINT)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = global_documents.entity_id::BIGINT)
               --WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = global_documents.entity_id::BIGINT)
               ELSE 0::BIGINT
           END),6::BIGINT) NOT IN(0,6)
ORDER BY 
	global_documents.updated_at DESC
LIMIT $4
OFFSET $3
`

type GetEntityIdGlobalDocumentsParams struct {
	EntityID   int64       `json:"entity_id"`
	EntityType int64       `json:"entity_type"`
	Offset     pgtype.Int4 `json:"offset"`
	Limit      pgtype.Int4 `json:"limit"`
}

type GetEntityIdGlobalDocumentsRow struct {
	GlobalDocumentID int64       `json:"global_document_id"`
	Category         string      `json:"category"`
	CategoryAr       pgtype.Text `json:"category_ar"`
	CategoryID       int64       `json:"category_id"`
	SubCategory      string      `json:"sub_category"`
	SubCategoryAr    pgtype.Text `json:"sub_category_ar"`
	SubCategoryID    int64       `json:"sub_category_id"`
	EntityID         int64       `json:"entity_id"`
	EntityTypeID     int64       `json:"entity_type_id"`
	CreatedAt        time.Time   `json:"created_at"`
	UpdatedAt        time.Time   `json:"updated_at"`
	FileUrl          []string    `json:"file_url"`
}

func (q *Queries) GetEntityIdGlobalDocuments(ctx context.Context, arg GetEntityIdGlobalDocumentsParams) ([]GetEntityIdGlobalDocumentsRow, error) {
	rows, err := q.db.Query(ctx, getEntityIdGlobalDocuments,
		arg.EntityID,
		arg.EntityType,
		arg.Offset,
		arg.Limit,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetEntityIdGlobalDocumentsRow
	for rows.Next() {
		var i GetEntityIdGlobalDocumentsRow
		if err := rows.Scan(
			&i.GlobalDocumentID,
			&i.Category,
			&i.CategoryAr,
			&i.CategoryID,
			&i.SubCategory,
			&i.SubCategoryAr,
			&i.SubCategoryID,
			&i.EntityID,
			&i.EntityTypeID,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.FileUrl,
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

const getGlobalDocuments = `-- name: GetGlobalDocuments :one
WITH status_calculation AS (
  SELECT CASE  $3::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = $4::BIGINT)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = $4::BIGINT)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = $4::BIGINT)
              -- WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = @entity_id::BIGINT)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = $4::BIGINT)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = $4::BIGINT)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = $4::BIGINT)
               --WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = @entity_id::BIGINT)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = $4::BIGINT)
              -- WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = @entity_id::BIGINT)
               ELSE 0::BIGINT
           END AS status
)
SELECT 
    COALESCE(global_documents.id, 0) AS "document_id",
    COALESCE(global_documents.file_url, ARRAY[]::VARCHAR[]) AS "file_urls",
    COALESCE(global_documents.entity_id, 0) AS "entity_id",
    COALESCE(status_calculation.status,-1::BIGINT) AS "status"
FROM 
    status_calculation 
LEFT JOIN 
    global_documents ON 
        global_documents.entity_type_id =  $3::BIGINT 
        AND global_documents.entity_id = $4::BIGINT 
        AND global_documents.documents_category_id = $1
        AND global_documents.documents_subcategory_id = $2
        AND status_calculation.status NOT IN (-1,0,6)
`

type GetGlobalDocumentsParams struct {
	DocumentsCategoryID    int64 `json:"documents_category_id"`
	DocumentsSubcategoryID int64 `json:"documents_subcategory_id"`
	EntityType             int64 `json:"entity_type"`
	EntityID               int64 `json:"entity_id"`
}

type GetGlobalDocumentsRow struct {
	DocumentID int64    `json:"document_id"`
	FileUrls   []string `json:"file_urls"`
	EntityID   int64    `json:"entity_id"`
	Status     int64    `json:"status"`
}

func (q *Queries) GetGlobalDocuments(ctx context.Context, arg GetGlobalDocumentsParams) (GetGlobalDocumentsRow, error) {
	row := q.db.QueryRow(ctx, getGlobalDocuments,
		arg.DocumentsCategoryID,
		arg.DocumentsSubcategoryID,
		arg.EntityType,
		arg.EntityID,
	)
	var i GetGlobalDocumentsRow
	err := row.Scan(
		&i.DocumentID,
		&i.FileUrls,
		&i.EntityID,
		&i.Status,
	)
	return i, err
}

const getNumberOfEntityIdGlobalDocuments = `-- name: GetNumberOfEntityIdGlobalDocuments :one
SELECT COUNT(*) 
FROM 
	global_documents 
WHERE 
	entity_id= $1::BIGINT AND entity_type_id= $2::BIGINT
`

type GetNumberOfEntityIdGlobalDocumentsParams struct {
	EntityID   int64 `json:"entity_id"`
	EntityType int64 `json:"entity_type"`
}

func (q *Queries) GetNumberOfEntityIdGlobalDocuments(ctx context.Context, arg GetNumberOfEntityIdGlobalDocumentsParams) (int64, error) {
	row := q.db.QueryRow(ctx, getNumberOfEntityIdGlobalDocuments, arg.EntityID, arg.EntityType)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const updateGlobalDocument = `-- name: UpdateGlobalDocument :one
Update global_documents 
SET 
	file_url=$1, 
	updated_at=$2 
WHERE 
	entity_type_id=$3 AND entity_id=$4 AND documents_category_id=$5 AND documents_subcategory_id=$6
RETURNING id, documents_category_id, documents_subcategory_id, file_url, entity_id, entity_type_id, created_at, updated_at
`

type UpdateGlobalDocumentParams struct {
	FileUrl                []string  `json:"file_url"`
	UpdatedAt              time.Time `json:"updated_at"`
	EntityTypeID           int64     `json:"entity_type_id"`
	EntityID               int64     `json:"entity_id"`
	DocumentsCategoryID    int64     `json:"documents_category_id"`
	DocumentsSubcategoryID int64     `json:"documents_subcategory_id"`
}

func (q *Queries) UpdateGlobalDocument(ctx context.Context, arg UpdateGlobalDocumentParams) (GlobalDocument, error) {
	row := q.db.QueryRow(ctx, updateGlobalDocument,
		arg.FileUrl,
		arg.UpdatedAt,
		arg.EntityTypeID,
		arg.EntityID,
		arg.DocumentsCategoryID,
		arg.DocumentsSubcategoryID,
	)
	var i GlobalDocument
	err := row.Scan(
		&i.ID,
		&i.DocumentsCategoryID,
		&i.DocumentsSubcategoryID,
		&i.FileUrl,
		&i.EntityID,
		&i.EntityTypeID,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}
