// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: project_documents.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createProjectDocuments = `-- name: CreateProjectDocuments :one
INSERT INTO project_documents (
    documents_category_id,
    documents_subcategory_id,
    file_url,
    created_at,
    updated_at,
    projects_id,
    status
)VALUES (
    $1, $2, $3, $4, $5, $6, $7
) RETURNING id, documents_category_id, documents_subcategory_id, file_url, created_at, updated_at, projects_id, status
`

type CreateProjectDocumentsParams struct {
	DocumentsCategoryID    int64     `json:"documents_category_id"`
	DocumentsSubcategoryID int64     `json:"documents_subcategory_id"`
	FileUrl                []string  `json:"file_url"`
	CreatedAt              time.Time `json:"created_at"`
	UpdatedAt              time.Time `json:"updated_at"`
	ProjectsID             int64     `json:"projects_id"`
	Status                 int64     `json:"status"`
}

func (q *Queries) CreateProjectDocuments(ctx context.Context, arg CreateProjectDocumentsParams) (ProjectDocument, error) {
	row := q.db.QueryRow(ctx, createProjectDocuments,
		arg.DocumentsCategoryID,
		arg.DocumentsSubcategoryID,
		arg.FileUrl,
		arg.CreatedAt,
		arg.UpdatedAt,
		arg.ProjectsID,
		arg.Status,
	)
	var i ProjectDocument
	err := row.Scan(
		&i.ID,
		&i.DocumentsCategoryID,
		&i.DocumentsSubcategoryID,
		&i.FileUrl,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.ProjectsID,
		&i.Status,
	)
	return i, err
}

const deleteProjectDocuments = `-- name: DeleteProjectDocuments :exec
DELETE FROM project_documents
Where id = $1
`

func (q *Queries) DeleteProjectDocuments(ctx context.Context, id int64) error {
	_, err := q.db.Exec(ctx, deleteProjectDocuments, id)
	return err
}

const getAllDocsByProjectID = `-- name: GetAllDocsByProjectID :many
SELECT project_documents.id, project_documents.documents_category_id, project_documents.documents_subcategory_id, project_documents.file_url, project_documents.created_at, project_documents.updated_at, project_documents.projects_id, project_documents.status, documents_category.category,documents_category.category_ar,documents_subcategory.sub_category FROM project_documents 
LEFT JOIN documents_category ON documents_category.id = project_documents.documents_category_id 
LEFT JOIN documents_subcategory ON documents_subcategory.id = project_documents.documents_subcategory_id 
WHERE project_documents.projects_id = $3 ORDER BY project_documents.created_at DESC LIMIT $1 OFFSET $2
`

type GetAllDocsByProjectIDParams struct {
	Limit      int32 `json:"limit"`
	Offset     int32 `json:"offset"`
	ProjectsID int64 `json:"projects_id"`
}

type GetAllDocsByProjectIDRow struct {
	ID                     int64       `json:"id"`
	DocumentsCategoryID    int64       `json:"documents_category_id"`
	DocumentsSubcategoryID int64       `json:"documents_subcategory_id"`
	FileUrl                []string    `json:"file_url"`
	CreatedAt              time.Time   `json:"created_at"`
	UpdatedAt              time.Time   `json:"updated_at"`
	ProjectsID             int64       `json:"projects_id"`
	Status                 int64       `json:"status"`
	Category               pgtype.Text `json:"category"`
	CategoryAr             pgtype.Text `json:"category_ar"`
	SubCategory            pgtype.Text `json:"sub_category"`
}

func (q *Queries) GetAllDocsByProjectID(ctx context.Context, arg GetAllDocsByProjectIDParams) ([]GetAllDocsByProjectIDRow, error) {
	rows, err := q.db.Query(ctx, getAllDocsByProjectID, arg.Limit, arg.Offset, arg.ProjectsID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAllDocsByProjectIDRow
	for rows.Next() {
		var i GetAllDocsByProjectIDRow
		if err := rows.Scan(
			&i.ID,
			&i.DocumentsCategoryID,
			&i.DocumentsSubcategoryID,
			&i.FileUrl,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.ProjectsID,
			&i.Status,
			&i.Category,
			&i.CategoryAr,
			&i.SubCategory,
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

const getAllDocsByProjectIDWithOutPagination = `-- name: GetAllDocsByProjectIDWithOutPagination :many
SELECT project_documents.id, project_documents.documents_category_id, project_documents.documents_subcategory_id, project_documents.file_url, project_documents.created_at, project_documents.updated_at, project_documents.projects_id, project_documents.status, documents_category.category,documents_category.category_ar,documents_subcategory.sub_category FROM project_documents 
LEFT JOIN documents_category ON documents_category.id = project_documents.documents_category_id 
LEFT JOIN documents_subcategory ON documents_subcategory.id = project_documents.documents_subcategory_id 
WHERE project_documents.projects_id = $1
`

type GetAllDocsByProjectIDWithOutPaginationRow struct {
	ID                     int64       `json:"id"`
	DocumentsCategoryID    int64       `json:"documents_category_id"`
	DocumentsSubcategoryID int64       `json:"documents_subcategory_id"`
	FileUrl                []string    `json:"file_url"`
	CreatedAt              time.Time   `json:"created_at"`
	UpdatedAt              time.Time   `json:"updated_at"`
	ProjectsID             int64       `json:"projects_id"`
	Status                 int64       `json:"status"`
	Category               pgtype.Text `json:"category"`
	CategoryAr             pgtype.Text `json:"category_ar"`
	SubCategory            pgtype.Text `json:"sub_category"`
}

func (q *Queries) GetAllDocsByProjectIDWithOutPagination(ctx context.Context, projectsID int64) ([]GetAllDocsByProjectIDWithOutPaginationRow, error) {
	rows, err := q.db.Query(ctx, getAllDocsByProjectIDWithOutPagination, projectsID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAllDocsByProjectIDWithOutPaginationRow
	for rows.Next() {
		var i GetAllDocsByProjectIDWithOutPaginationRow
		if err := rows.Scan(
			&i.ID,
			&i.DocumentsCategoryID,
			&i.DocumentsSubcategoryID,
			&i.FileUrl,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.ProjectsID,
			&i.Status,
			&i.Category,
			&i.CategoryAr,
			&i.SubCategory,
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

const getAllProjectDocuments = `-- name: GetAllProjectDocuments :many
SELECT id, documents_category_id, documents_subcategory_id, file_url, created_at, updated_at, projects_id, status FROM project_documents
ORDER BY id
LIMIT $1
OFFSET $2
`

type GetAllProjectDocumentsParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) GetAllProjectDocuments(ctx context.Context, arg GetAllProjectDocumentsParams) ([]ProjectDocument, error) {
	rows, err := q.db.Query(ctx, getAllProjectDocuments, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []ProjectDocument
	for rows.Next() {
		var i ProjectDocument
		if err := rows.Scan(
			&i.ID,
			&i.DocumentsCategoryID,
			&i.DocumentsSubcategoryID,
			&i.FileUrl,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.ProjectsID,
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

const getCountDocsByProjectId = `-- name: GetCountDocsByProjectId :one
SELECT COUNT(*) FROM project_documents WHERE project_documents.projects_id = $1
`

func (q *Queries) GetCountDocsByProjectId(ctx context.Context, projectsID int64) (int64, error) {
	row := q.db.QueryRow(ctx, getCountDocsByProjectId, projectsID)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const getProjectDocById = `-- name: GetProjectDocById :one
SELECT project_documents.id, project_documents.documents_category_id, project_documents.documents_subcategory_id, project_documents.file_url, project_documents.created_at, project_documents.updated_at, project_documents.projects_id, project_documents.status,documents_category.category,documents_category.category_ar,documents_subcategory.sub_category FROM project_documents
LEFT JOIN documents_category ON documents_category.id = project_documents.documents_category_id 
LEFT JOIN documents_subcategory ON documents_subcategory.id = project_documents.documents_subcategory_id 
WHERE project_documents.id = $1
`

type GetProjectDocByIdRow struct {
	ID                     int64       `json:"id"`
	DocumentsCategoryID    int64       `json:"documents_category_id"`
	DocumentsSubcategoryID int64       `json:"documents_subcategory_id"`
	FileUrl                []string    `json:"file_url"`
	CreatedAt              time.Time   `json:"created_at"`
	UpdatedAt              time.Time   `json:"updated_at"`
	ProjectsID             int64       `json:"projects_id"`
	Status                 int64       `json:"status"`
	Category               pgtype.Text `json:"category"`
	CategoryAr             pgtype.Text `json:"category_ar"`
	SubCategory            pgtype.Text `json:"sub_category"`
}

func (q *Queries) GetProjectDocById(ctx context.Context, id int64) (GetProjectDocByIdRow, error) {
	row := q.db.QueryRow(ctx, getProjectDocById, id)
	var i GetProjectDocByIdRow
	err := row.Scan(
		&i.ID,
		&i.DocumentsCategoryID,
		&i.DocumentsSubcategoryID,
		&i.FileUrl,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.ProjectsID,
		&i.Status,
		&i.Category,
		&i.CategoryAr,
		&i.SubCategory,
	)
	return i, err
}

const getProjectDocByIdandCategory = `-- name: GetProjectDocByIdandCategory :one
SELECT project_documents.id, project_documents.documents_category_id, project_documents.documents_subcategory_id, project_documents.file_url, project_documents.created_at, project_documents.updated_at, project_documents.projects_id, project_documents.status,documents_category.category,documents_subcategory.sub_category FROM project_documents
LEFT JOIN documents_category ON documents_category.id = project_documents.documents_category_id
LEFT JOIN documents_subcategory ON documents_subcategory.id = project_documents.documents_subcategory_id
WHERE project_documents.projects_id = $1 AND  project_documents.documents_category_id = $2 AND project_documents.documents_subcategory_id = $3
`

type GetProjectDocByIdandCategoryParams struct {
	ProjectsID             int64 `json:"projects_id"`
	DocumentsCategoryID    int64 `json:"documents_category_id"`
	DocumentsSubcategoryID int64 `json:"documents_subcategory_id"`
}

type GetProjectDocByIdandCategoryRow struct {
	ID                     int64       `json:"id"`
	DocumentsCategoryID    int64       `json:"documents_category_id"`
	DocumentsSubcategoryID int64       `json:"documents_subcategory_id"`
	FileUrl                []string    `json:"file_url"`
	CreatedAt              time.Time   `json:"created_at"`
	UpdatedAt              time.Time   `json:"updated_at"`
	ProjectsID             int64       `json:"projects_id"`
	Status                 int64       `json:"status"`
	Category               pgtype.Text `json:"category"`
	SubCategory            pgtype.Text `json:"sub_category"`
}

func (q *Queries) GetProjectDocByIdandCategory(ctx context.Context, arg GetProjectDocByIdandCategoryParams) (GetProjectDocByIdandCategoryRow, error) {
	row := q.db.QueryRow(ctx, getProjectDocByIdandCategory, arg.ProjectsID, arg.DocumentsCategoryID, arg.DocumentsSubcategoryID)
	var i GetProjectDocByIdandCategoryRow
	err := row.Scan(
		&i.ID,
		&i.DocumentsCategoryID,
		&i.DocumentsSubcategoryID,
		&i.FileUrl,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.ProjectsID,
		&i.Status,
		&i.Category,
		&i.SubCategory,
	)
	return i, err
}

const getProjectDocCategoriesByPhase = `-- name: GetProjectDocCategoriesByPhase :many
SELECT 
documents_category.id AS documents_category_id, 
documents_category.category AS documents_category,
documents_category.category_ar AS document_category_ar,
documents_subcategory.id AS documents_subcategory_id,
documents_subcategory.sub_category AS documents_subcategory
FROM project_documents
INNER JOIN phases ON phases.id = $1 AND phases.projects_id = project_documents.projects_id
INNER JOIN documents_category ON documents_category.id = project_documents.documents_category_id
INNER JOIN documents_subcategory ON documents_subcategory.id = project_documents.documents_subcategory_id
ORDER BY documents_category.id
`

type GetProjectDocCategoriesByPhaseRow struct {
	DocumentsCategoryID    int64       `json:"documents_category_id"`
	DocumentsCategory      string      `json:"documents_category"`
	DocumentCategoryAr     pgtype.Text `json:"document_category_ar"`
	DocumentsSubcategoryID int64       `json:"documents_subcategory_id"`
	DocumentsSubcategory   string      `json:"documents_subcategory"`
}

func (q *Queries) GetProjectDocCategoriesByPhase(ctx context.Context, phaseID int64) ([]GetProjectDocCategoriesByPhaseRow, error) {
	rows, err := q.db.Query(ctx, getProjectDocCategoriesByPhase, phaseID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetProjectDocCategoriesByPhaseRow
	for rows.Next() {
		var i GetProjectDocCategoriesByPhaseRow
		if err := rows.Scan(
			&i.DocumentsCategoryID,
			&i.DocumentsCategory,
			&i.DocumentCategoryAr,
			&i.DocumentsSubcategoryID,
			&i.DocumentsSubcategory,
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

const getProjectDocuments = `-- name: GetProjectDocuments :one
SELECT id, documents_category_id, documents_subcategory_id, file_url, created_at, updated_at, projects_id, status FROM project_documents
WHERE id = $1 LIMIT $1
`

func (q *Queries) GetProjectDocuments(ctx context.Context, limit int32) (ProjectDocument, error) {
	row := q.db.QueryRow(ctx, getProjectDocuments, limit)
	var i ProjectDocument
	err := row.Scan(
		&i.ID,
		&i.DocumentsCategoryID,
		&i.DocumentsSubcategoryID,
		&i.FileUrl,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.ProjectsID,
		&i.Status,
	)
	return i, err
}

const getProjectPropDocCategoriesByUnit = `-- name: GetProjectPropDocCategoriesByUnit :many
SELECT 
documents_category.id AS documents_category_id, 
documents_category.category AS documents_category,
documents_category.category_ar AS document_category_ar,
documents_subcategory.id AS documents_subcategory_id,
documents_subcategory.sub_category AS documents_subcategory
FROM project_properties_documents
INNER JOIN units ON units.id = $1 AND units.properties_id = project_properties_documents.project_properties_id AND units.property = 1
INNER JOIN documents_category ON documents_category.id = project_properties_documents.documents_category_id
INNER JOIN documents_subcategory ON documents_subcategory.id = project_properties_documents.documents_subcategory_id
ORDER BY documents_category.id
`

type GetProjectPropDocCategoriesByUnitRow struct {
	DocumentsCategoryID    int64       `json:"documents_category_id"`
	DocumentsCategory      string      `json:"documents_category"`
	DocumentCategoryAr     pgtype.Text `json:"document_category_ar"`
	DocumentsSubcategoryID int64       `json:"documents_subcategory_id"`
	DocumentsSubcategory   string      `json:"documents_subcategory"`
}

func (q *Queries) GetProjectPropDocCategoriesByUnit(ctx context.Context, unitID int64) ([]GetProjectPropDocCategoriesByUnitRow, error) {
	rows, err := q.db.Query(ctx, getProjectPropDocCategoriesByUnit, unitID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetProjectPropDocCategoriesByUnitRow
	for rows.Next() {
		var i GetProjectPropDocCategoriesByUnitRow
		if err := rows.Scan(
			&i.DocumentsCategoryID,
			&i.DocumentsCategory,
			&i.DocumentCategoryAr,
			&i.DocumentsSubcategoryID,
			&i.DocumentsSubcategory,
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

const updateProjectDocumentFiles = `-- name: UpdateProjectDocumentFiles :one
UPDATE project_documents
SET file_url = $2,
updated_at = $3
Where id = $1
RETURNING id, documents_category_id, documents_subcategory_id, file_url, created_at, updated_at, projects_id, status
`

type UpdateProjectDocumentFilesParams struct {
	ID        int64     `json:"id"`
	FileUrl   []string  `json:"file_url"`
	UpdatedAt time.Time `json:"updated_at"`
}

func (q *Queries) UpdateProjectDocumentFiles(ctx context.Context, arg UpdateProjectDocumentFilesParams) (ProjectDocument, error) {
	row := q.db.QueryRow(ctx, updateProjectDocumentFiles, arg.ID, arg.FileUrl, arg.UpdatedAt)
	var i ProjectDocument
	err := row.Scan(
		&i.ID,
		&i.DocumentsCategoryID,
		&i.DocumentsSubcategoryID,
		&i.FileUrl,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.ProjectsID,
		&i.Status,
	)
	return i, err
}

const updateProjectDocuments = `-- name: UpdateProjectDocuments :one
UPDATE project_documents
SET   documents_category_id = $2,
      documents_subcategory_id = $3,
      file_url = $4,
      created_at =$5,
      updated_at = $6,
      projects_id = $7,
      status = $8
Where id = $1
RETURNING id, documents_category_id, documents_subcategory_id, file_url, created_at, updated_at, projects_id, status
`

type UpdateProjectDocumentsParams struct {
	ID                     int64     `json:"id"`
	DocumentsCategoryID    int64     `json:"documents_category_id"`
	DocumentsSubcategoryID int64     `json:"documents_subcategory_id"`
	FileUrl                []string  `json:"file_url"`
	CreatedAt              time.Time `json:"created_at"`
	UpdatedAt              time.Time `json:"updated_at"`
	ProjectsID             int64     `json:"projects_id"`
	Status                 int64     `json:"status"`
}

func (q *Queries) UpdateProjectDocuments(ctx context.Context, arg UpdateProjectDocumentsParams) (ProjectDocument, error) {
	row := q.db.QueryRow(ctx, updateProjectDocuments,
		arg.ID,
		arg.DocumentsCategoryID,
		arg.DocumentsSubcategoryID,
		arg.FileUrl,
		arg.CreatedAt,
		arg.UpdatedAt,
		arg.ProjectsID,
		arg.Status,
	)
	var i ProjectDocument
	err := row.Scan(
		&i.ID,
		&i.DocumentsCategoryID,
		&i.DocumentsSubcategoryID,
		&i.FileUrl,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.ProjectsID,
		&i.Status,
	)
	return i, err
}
