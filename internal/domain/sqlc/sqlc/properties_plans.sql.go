// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: properties_plans.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createPropertyPlan = `-- name: CreatePropertyPlan :one
INSERT INTO properties_plans (
    img_url,
    title,
    properties_id,
    property,
    created_at,
    updated_at

)VALUES (
    $1, $2, $3, $4, $5, $6
) RETURNING id, img_url, title, projects_id, properties_id, property, created_at, updated_at
`

type CreatePropertyPlanParams struct {
	ImgUrl       []string  `json:"img_url"`
	Title        string    `json:"title"`
	PropertiesID int64     `json:"properties_id"`
	Property     int64     `json:"property"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

func (q *Queries) CreatePropertyPlan(ctx context.Context, arg CreatePropertyPlanParams) (PropertiesPlan, error) {
	row := q.db.QueryRow(ctx, createPropertyPlan,
		arg.ImgUrl,
		arg.Title,
		arg.PropertiesID,
		arg.Property,
		arg.CreatedAt,
		arg.UpdatedAt,
	)
	var i PropertiesPlan
	err := row.Scan(
		&i.ID,
		&i.ImgUrl,
		&i.Title,
		&i.ProjectsID,
		&i.PropertiesID,
		&i.Property,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const deletePropertyPlan = `-- name: DeletePropertyPlan :exec
DELETE FROM properties_plans
Where id = $1
`

func (q *Queries) DeletePropertyPlan(ctx context.Context, id int64) error {
	_, err := q.db.Exec(ctx, deletePropertyPlan, id)
	return err
}

const getAllPropertyPlan = `-- name: GetAllPropertyPlan :many
SELECT id, img_url, title, projects_id, properties_id, property, created_at, updated_at FROM properties_plans
ORDER BY id
LIMIT $1
OFFSET $2
`

type GetAllPropertyPlanParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) GetAllPropertyPlan(ctx context.Context, arg GetAllPropertyPlanParams) ([]PropertiesPlan, error) {
	rows, err := q.db.Query(ctx, getAllPropertyPlan, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []PropertiesPlan
	for rows.Next() {
		var i PropertiesPlan
		if err := rows.Scan(
			&i.ID,
			&i.ImgUrl,
			&i.Title,
			&i.ProjectsID,
			&i.PropertiesID,
			&i.Property,
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

const getAllPropertyPlanById = `-- name: GetAllPropertyPlanById :many
SELECT id, img_url, title, properties_id, property, created_at, updated_at 
 FROM properties_plans 
WHERE properties_id = $3 AND property = $4
ORDER BY created_at DESC
LIMIT $1 OFFSET $2
`

type GetAllPropertyPlanByIdParams struct {
	Limit        int32 `json:"limit"`
	Offset       int32 `json:"offset"`
	PropertiesID int64 `json:"properties_id"`
	Property     int64 `json:"property"`
}

type GetAllPropertyPlanByIdRow struct {
	ID           int64     `json:"id"`
	ImgUrl       []string  `json:"img_url"`
	Title        string    `json:"title"`
	PropertiesID int64     `json:"properties_id"`
	Property     int64     `json:"property"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

func (q *Queries) GetAllPropertyPlanById(ctx context.Context, arg GetAllPropertyPlanByIdParams) ([]GetAllPropertyPlanByIdRow, error) {
	rows, err := q.db.Query(ctx, getAllPropertyPlanById,
		arg.Limit,
		arg.Offset,
		arg.PropertiesID,
		arg.Property,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAllPropertyPlanByIdRow
	for rows.Next() {
		var i GetAllPropertyPlanByIdRow
		if err := rows.Scan(
			&i.ID,
			&i.ImgUrl,
			&i.Title,
			&i.PropertiesID,
			&i.Property,
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

const getAllPropertyPlanByIdWithoutPagination = `-- name: GetAllPropertyPlanByIdWithoutPagination :many
SELECT id, img_url, title, properties_id, property, created_at, updated_at 
 FROM properties_plans 
WHERE properties_id = $1 AND property = $2
ORDER BY created_at DESC
`

type GetAllPropertyPlanByIdWithoutPaginationParams struct {
	PropertiesID int64 `json:"properties_id"`
	Property     int64 `json:"property"`
}

type GetAllPropertyPlanByIdWithoutPaginationRow struct {
	ID           int64     `json:"id"`
	ImgUrl       []string  `json:"img_url"`
	Title        string    `json:"title"`
	PropertiesID int64     `json:"properties_id"`
	Property     int64     `json:"property"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

func (q *Queries) GetAllPropertyPlanByIdWithoutPagination(ctx context.Context, arg GetAllPropertyPlanByIdWithoutPaginationParams) ([]GetAllPropertyPlanByIdWithoutPaginationRow, error) {
	rows, err := q.db.Query(ctx, getAllPropertyPlanByIdWithoutPagination, arg.PropertiesID, arg.Property)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAllPropertyPlanByIdWithoutPaginationRow
	for rows.Next() {
		var i GetAllPropertyPlanByIdWithoutPaginationRow
		if err := rows.Scan(
			&i.ID,
			&i.ImgUrl,
			&i.Title,
			&i.PropertiesID,
			&i.Property,
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

const getAllPropertyPlanByPropertyIdWhichProperty = `-- name: GetAllPropertyPlanByPropertyIdWhichProperty :many
SELECT id, img_url, title, projects_id, properties_id, property, created_at, updated_at FROM properties_plans 
WHERE properties_id = $1  AND property = $2
`

type GetAllPropertyPlanByPropertyIdWhichPropertyParams struct {
	PropertiesID int64 `json:"properties_id"`
	Property     int64 `json:"property"`
}

func (q *Queries) GetAllPropertyPlanByPropertyIdWhichProperty(ctx context.Context, arg GetAllPropertyPlanByPropertyIdWhichPropertyParams) ([]PropertiesPlan, error) {
	rows, err := q.db.Query(ctx, getAllPropertyPlanByPropertyIdWhichProperty, arg.PropertiesID, arg.Property)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []PropertiesPlan
	for rows.Next() {
		var i PropertiesPlan
		if err := rows.Scan(
			&i.ID,
			&i.ImgUrl,
			&i.Title,
			&i.ProjectsID,
			&i.PropertiesID,
			&i.Property,
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

const getAllPropertyPlanWithoutPagination = `-- name: GetAllPropertyPlanWithoutPagination :many
SELECT id, img_url, title, projects_id, properties_id, property, created_at, updated_at FROM properties_plans
ORDER BY id
`

func (q *Queries) GetAllPropertyPlanWithoutPagination(ctx context.Context) ([]PropertiesPlan, error) {
	rows, err := q.db.Query(ctx, getAllPropertyPlanWithoutPagination)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []PropertiesPlan
	for rows.Next() {
		var i PropertiesPlan
		if err := rows.Scan(
			&i.ID,
			&i.ImgUrl,
			&i.Title,
			&i.ProjectsID,
			&i.PropertiesID,
			&i.Property,
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

const getCountAllPropertyPlanById = `-- name: GetCountAllPropertyPlanById :one
SELECT COUNT(id)
 FROM properties_plans 
WHERE properties_id = $1 AND property = $2
`

type GetCountAllPropertyPlanByIdParams struct {
	PropertiesID int64 `json:"properties_id"`
	Property     int64 `json:"property"`
}

func (q *Queries) GetCountAllPropertyPlanById(ctx context.Context, arg GetCountAllPropertyPlanByIdParams) (int64, error) {
	row := q.db.QueryRow(ctx, getCountAllPropertyPlanById, arg.PropertiesID, arg.Property)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const getPropertiesPlansByProjectId = `-- name: GetPropertiesPlansByProjectId :many
select  id, img_url, title, projects_id, properties_id, property, created_at, updated_at from properties_plans where properties_plans.projects_id = $1
`

func (q *Queries) GetPropertiesPlansByProjectId(ctx context.Context, projectsID pgtype.Int8) ([]PropertiesPlan, error) {
	rows, err := q.db.Query(ctx, getPropertiesPlansByProjectId, projectsID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []PropertiesPlan
	for rows.Next() {
		var i PropertiesPlan
		if err := rows.Scan(
			&i.ID,
			&i.ImgUrl,
			&i.Title,
			&i.ProjectsID,
			&i.PropertiesID,
			&i.Property,
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

const getPropertyNameByIdAndProperty = `-- name: GetPropertyNameByIdAndProperty :one
WITH x AS (
  SELECT property_name FROM project_properties 
  WHERE project_properties.id = $1 AND 1::bigint = $2::bigint
  UNION ALL
  SELECT property_name FROM freelancers_properties 
  WHERE freelancers_properties.id = $1 AND 2::bigint = $2::bigint
  UNION ALL
  SELECT property_name FROM broker_company_agent_properties 
  WHERE broker_company_agent_properties.id = $1 AND 3::bigint = $2::bigint
  UNION ALL
  SELECT property_name FROM owner_properties 
  WHERE owner_properties.id = $1 AND 4::bigint = $2::bigint
)SELECT property_name FROM x LIMIT 1
`

type GetPropertyNameByIdAndPropertyParams struct {
	ID       int64 `json:"id"`
	Property int64 `json:"property"`
}

func (q *Queries) GetPropertyNameByIdAndProperty(ctx context.Context, arg GetPropertyNameByIdAndPropertyParams) (string, error) {
	row := q.db.QueryRow(ctx, getPropertyNameByIdAndProperty, arg.ID, arg.Property)
	var property_name string
	err := row.Scan(&property_name)
	return property_name, err
}

const getPropertyPlan = `-- name: GetPropertyPlan :one
SELECT id, img_url, title, projects_id, properties_id, property, created_at, updated_at FROM properties_plans 
WHERE id = $1 LIMIT $1
`

func (q *Queries) GetPropertyPlan(ctx context.Context, limit int32) (PropertiesPlan, error) {
	row := q.db.QueryRow(ctx, getPropertyPlan, limit)
	var i PropertiesPlan
	err := row.Scan(
		&i.ID,
		&i.ImgUrl,
		&i.Title,
		&i.ProjectsID,
		&i.PropertiesID,
		&i.Property,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const getPropertyPlanByTitle = `-- name: GetPropertyPlanByTitle :one
SELECT id, img_url, title, projects_id, properties_id, property, created_at, updated_at FROM properties_plans 
WHERE title = $1 AND properties_id = $2 AND property = $3
`

type GetPropertyPlanByTitleParams struct {
	Title        string `json:"title"`
	PropertiesID int64  `json:"properties_id"`
	Property     int64  `json:"property"`
}

func (q *Queries) GetPropertyPlanByTitle(ctx context.Context, arg GetPropertyPlanByTitleParams) (PropertiesPlan, error) {
	row := q.db.QueryRow(ctx, getPropertyPlanByTitle, arg.Title, arg.PropertiesID, arg.Property)
	var i PropertiesPlan
	err := row.Scan(
		&i.ID,
		&i.ImgUrl,
		&i.Title,
		&i.ProjectsID,
		&i.PropertiesID,
		&i.Property,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}

const updatePropertyPlan = `-- name: UpdatePropertyPlan :one
UPDATE properties_plans
SET  img_url = $2,
    title = $3,
    properties_id = $4,
    property = $5,
    created_at = $6,
    updated_at = $7
Where id = $1
RETURNING id, img_url, title, projects_id, properties_id, property, created_at, updated_at
`

type UpdatePropertyPlanParams struct {
	ID           int64     `json:"id"`
	ImgUrl       []string  `json:"img_url"`
	Title        string    `json:"title"`
	PropertiesID int64     `json:"properties_id"`
	Property     int64     `json:"property"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

func (q *Queries) UpdatePropertyPlan(ctx context.Context, arg UpdatePropertyPlanParams) (PropertiesPlan, error) {
	row := q.db.QueryRow(ctx, updatePropertyPlan,
		arg.ID,
		arg.ImgUrl,
		arg.Title,
		arg.PropertiesID,
		arg.Property,
		arg.CreatedAt,
		arg.UpdatedAt,
	)
	var i PropertiesPlan
	err := row.Scan(
		&i.ID,
		&i.ImgUrl,
		&i.Title,
		&i.ProjectsID,
		&i.PropertiesID,
		&i.Property,
		&i.CreatedAt,
		&i.UpdatedAt,
	)
	return i, err
}
