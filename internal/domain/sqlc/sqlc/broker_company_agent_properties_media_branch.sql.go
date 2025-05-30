// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: broker_company_agent_properties_media_branch.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createBrokerCompanyAgentPropertyBranchMedia = `-- name: CreateBrokerCompanyAgentPropertyBranchMedia :one
INSERT INTO broker_company_agent_properties_media_branch (
    image_url,
    image360_url,
    video_url,
    panaroma_url,
    main_media_section,
    broker_company_agent_properties_branch_id,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING id, image_url, image360_url, video_url, panaroma_url, main_media_section, broker_company_agent_properties_branch_id, created_at, updated_at, is_branch
`

type CreateBrokerCompanyAgentPropertyBranchMediaParams struct {
	ImageUrl                             []string  `json:"image_url"`
	Image360Url                          []string  `json:"image360_url"`
	VideoUrl                             []string  `json:"video_url"`
	PanaromaUrl                          []string  `json:"panaroma_url"`
	MainMediaSection                     string    `json:"main_media_section"`
	BrokerCompanyAgentPropertiesBranchID int64     `json:"broker_company_agent_properties_branch_id"`
	CreatedAt                            time.Time `json:"created_at"`
	UpdatedAt                            time.Time `json:"updated_at"`
}

func (q *Queries) CreateBrokerCompanyAgentPropertyBranchMedia(ctx context.Context, arg CreateBrokerCompanyAgentPropertyBranchMediaParams) (BrokerCompanyAgentPropertiesMediaBranch, error) {
	row := q.db.QueryRow(ctx, createBrokerCompanyAgentPropertyBranchMedia,
		arg.ImageUrl,
		arg.Image360Url,
		arg.VideoUrl,
		arg.PanaromaUrl,
		arg.MainMediaSection,
		arg.BrokerCompanyAgentPropertiesBranchID,
		arg.CreatedAt,
		arg.UpdatedAt,
	)
	var i BrokerCompanyAgentPropertiesMediaBranch
	err := row.Scan(
		&i.ID,
		&i.ImageUrl,
		&i.Image360Url,
		&i.VideoUrl,
		&i.PanaromaUrl,
		&i.MainMediaSection,
		&i.BrokerCompanyAgentPropertiesBranchID,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.IsBranch,
	)
	return i, err
}

const deleteBrokerCompanyAgentPropertyBranchMedia = `-- name: DeleteBrokerCompanyAgentPropertyBranchMedia :exec
DELETE FROM broker_company_agent_properties_media_branch
Where id = $1
`

func (q *Queries) DeleteBrokerCompanyAgentPropertyBranchMedia(ctx context.Context, id int64) error {
	_, err := q.db.Exec(ctx, deleteBrokerCompanyAgentPropertyBranchMedia, id)
	return err
}

const getAllBrokerCompanyAgentBranchPropertiesByMainMediaSectionAndId = `-- name: GetAllBrokerCompanyAgentBranchPropertiesByMainMediaSectionAndId :one
with x As (
 SELECT id, image_url, image360_url, video_url, panaroma_url, main_media_section, broker_company_agent_properties_branch_id, created_at, updated_at, is_branch FROM broker_company_agent_properties_media_branch
 WHERE main_media_section = $2 AND broker_company_agent_properties_branch_id = $1
) SELECT id, image_url, image360_url, video_url, panaroma_url, main_media_section, broker_company_agent_properties_branch_id, created_at, updated_at, is_branch From x
`

type GetAllBrokerCompanyAgentBranchPropertiesByMainMediaSectionAndIdParams struct {
	BrokerCompanyAgentPropertiesBranchID int64  `json:"broker_company_agent_properties_branch_id"`
	MainMediaSection                     string `json:"main_media_section"`
}

type GetAllBrokerCompanyAgentBranchPropertiesByMainMediaSectionAndIdRow struct {
	ID                                   int64       `json:"id"`
	ImageUrl                             []string    `json:"image_url"`
	Image360Url                          []string    `json:"image360_url"`
	VideoUrl                             []string    `json:"video_url"`
	PanaromaUrl                          []string    `json:"panaroma_url"`
	MainMediaSection                     string      `json:"main_media_section"`
	BrokerCompanyAgentPropertiesBranchID int64       `json:"broker_company_agent_properties_branch_id"`
	CreatedAt                            time.Time   `json:"created_at"`
	UpdatedAt                            time.Time   `json:"updated_at"`
	IsBranch                             pgtype.Bool `json:"is_branch"`
}

func (q *Queries) GetAllBrokerCompanyAgentBranchPropertiesByMainMediaSectionAndId(ctx context.Context, arg GetAllBrokerCompanyAgentBranchPropertiesByMainMediaSectionAndIdParams) (GetAllBrokerCompanyAgentBranchPropertiesByMainMediaSectionAndIdRow, error) {
	row := q.db.QueryRow(ctx, getAllBrokerCompanyAgentBranchPropertiesByMainMediaSectionAndId, arg.BrokerCompanyAgentPropertiesBranchID, arg.MainMediaSection)
	var i GetAllBrokerCompanyAgentBranchPropertiesByMainMediaSectionAndIdRow
	err := row.Scan(
		&i.ID,
		&i.ImageUrl,
		&i.Image360Url,
		&i.VideoUrl,
		&i.PanaromaUrl,
		&i.MainMediaSection,
		&i.BrokerCompanyAgentPropertiesBranchID,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.IsBranch,
	)
	return i, err
}

const getAllBrokerCompanyAgentBranchPropertiesMainMediaSectionById = `-- name: GetAllBrokerCompanyAgentBranchPropertiesMainMediaSectionById :many
With x As (
 SELECT  main_media_section FROM broker_company_agent_properties_media_branch
 WHERE broker_company_agent_properties_branch_id  = $1
) SELECT main_media_section From x
`

func (q *Queries) GetAllBrokerCompanyAgentBranchPropertiesMainMediaSectionById(ctx context.Context, brokerCompanyAgentPropertiesBranchID int64) ([]string, error) {
	rows, err := q.db.Query(ctx, getAllBrokerCompanyAgentBranchPropertiesMainMediaSectionById, brokerCompanyAgentPropertiesBranchID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []string
	for rows.Next() {
		var main_media_section string
		if err := rows.Scan(&main_media_section); err != nil {
			return nil, err
		}
		items = append(items, main_media_section)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getAllBrokerCompanyAgentPropertyBranchMedia = `-- name: GetAllBrokerCompanyAgentPropertyBranchMedia :many
SELECT id, image_url, image360_url, video_url, panaroma_url, main_media_section, broker_company_agent_properties_branch_id, created_at, updated_at, is_branch FROM broker_company_agent_properties_media_branch
ORDER BY id
LIMIT $1
OFFSET $2
`

type GetAllBrokerCompanyAgentPropertyBranchMediaParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) GetAllBrokerCompanyAgentPropertyBranchMedia(ctx context.Context, arg GetAllBrokerCompanyAgentPropertyBranchMediaParams) ([]BrokerCompanyAgentPropertiesMediaBranch, error) {
	rows, err := q.db.Query(ctx, getAllBrokerCompanyAgentPropertyBranchMedia, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []BrokerCompanyAgentPropertiesMediaBranch
	for rows.Next() {
		var i BrokerCompanyAgentPropertiesMediaBranch
		if err := rows.Scan(
			&i.ID,
			&i.ImageUrl,
			&i.Image360Url,
			&i.VideoUrl,
			&i.PanaromaUrl,
			&i.MainMediaSection,
			&i.BrokerCompanyAgentPropertiesBranchID,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.IsBranch,
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

const getAllBrokerCompanyAgentPropertyBranchMediaById = `-- name: GetAllBrokerCompanyAgentPropertyBranchMediaById :many
Select id, image_url, image360_url, video_url, panaroma_url, main_media_section, broker_company_agent_properties_branch_id, created_at, updated_at, is_branch from broker_company_agent_properties_media_branch 
WHERE broker_company_agent_properties_branch_id = $1
`

func (q *Queries) GetAllBrokerCompanyAgentPropertyBranchMediaById(ctx context.Context, brokerCompanyAgentPropertiesBranchID int64) ([]BrokerCompanyAgentPropertiesMediaBranch, error) {
	rows, err := q.db.Query(ctx, getAllBrokerCompanyAgentPropertyBranchMediaById, brokerCompanyAgentPropertiesBranchID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []BrokerCompanyAgentPropertiesMediaBranch
	for rows.Next() {
		var i BrokerCompanyAgentPropertiesMediaBranch
		if err := rows.Scan(
			&i.ID,
			&i.ImageUrl,
			&i.Image360Url,
			&i.VideoUrl,
			&i.PanaromaUrl,
			&i.MainMediaSection,
			&i.BrokerCompanyAgentPropertiesBranchID,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.IsBranch,
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

const getBranchBrokerCompanyAgentPropertyMediaByPropertyIdAndMediaSection = `-- name: GetBranchBrokerCompanyAgentPropertyMediaByPropertyIdAndMediaSection :one
SELECT 
 id,image_url,image360_url,video_url,panaroma_url,
 main_media_section,broker_company_agent_properties_branch_id,
 created_at,updated_at,is_branch 
FROM
 broker_company_agent_properties_media_branch 
WHERE 
 broker_company_agent_properties_branch_id = $1 
AND
  main_media_section = $2
`

type GetBranchBrokerCompanyAgentPropertyMediaByPropertyIdAndMediaSectionParams struct {
	BrokerCompanyAgentPropertiesBranchID int64  `json:"broker_company_agent_properties_branch_id"`
	MainMediaSection                     string `json:"main_media_section"`
}

func (q *Queries) GetBranchBrokerCompanyAgentPropertyMediaByPropertyIdAndMediaSection(ctx context.Context, arg GetBranchBrokerCompanyAgentPropertyMediaByPropertyIdAndMediaSectionParams) (BrokerCompanyAgentPropertiesMediaBranch, error) {
	row := q.db.QueryRow(ctx, getBranchBrokerCompanyAgentPropertyMediaByPropertyIdAndMediaSection, arg.BrokerCompanyAgentPropertiesBranchID, arg.MainMediaSection)
	var i BrokerCompanyAgentPropertiesMediaBranch
	err := row.Scan(
		&i.ID,
		&i.ImageUrl,
		&i.Image360Url,
		&i.VideoUrl,
		&i.PanaromaUrl,
		&i.MainMediaSection,
		&i.BrokerCompanyAgentPropertiesBranchID,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.IsBranch,
	)
	return i, err
}

const getBrokerCompanyAgentPropertyBranchMedia = `-- name: GetBrokerCompanyAgentPropertyBranchMedia :one
SELECT id, image_url, image360_url, video_url, panaroma_url, main_media_section, broker_company_agent_properties_branch_id, created_at, updated_at, is_branch FROM broker_company_agent_properties_media_branch 
WHERE id = $1 LIMIT $1
`

func (q *Queries) GetBrokerCompanyAgentPropertyBranchMedia(ctx context.Context, limit int32) (BrokerCompanyAgentPropertiesMediaBranch, error) {
	row := q.db.QueryRow(ctx, getBrokerCompanyAgentPropertyBranchMedia, limit)
	var i BrokerCompanyAgentPropertiesMediaBranch
	err := row.Scan(
		&i.ID,
		&i.ImageUrl,
		&i.Image360Url,
		&i.VideoUrl,
		&i.PanaromaUrl,
		&i.MainMediaSection,
		&i.BrokerCompanyAgentPropertiesBranchID,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.IsBranch,
	)
	return i, err
}

const updateBrokerCompanyAgentPropertyBranchMedia = `-- name: UpdateBrokerCompanyAgentPropertyBranchMedia :one
UPDATE broker_company_agent_properties_media_branch
SET   image_url = $2,
    image360_url = $3,
    video_url = $4,
    panaroma_url = $5,
    main_media_section = $6,
    broker_company_agent_properties_branch_id = $7,
    created_at = $8,
    updated_at = $9
Where id = $1
RETURNING id, image_url, image360_url, video_url, panaroma_url, main_media_section, broker_company_agent_properties_branch_id, created_at, updated_at, is_branch
`

type UpdateBrokerCompanyAgentPropertyBranchMediaParams struct {
	ID                                   int64     `json:"id"`
	ImageUrl                             []string  `json:"image_url"`
	Image360Url                          []string  `json:"image360_url"`
	VideoUrl                             []string  `json:"video_url"`
	PanaromaUrl                          []string  `json:"panaroma_url"`
	MainMediaSection                     string    `json:"main_media_section"`
	BrokerCompanyAgentPropertiesBranchID int64     `json:"broker_company_agent_properties_branch_id"`
	CreatedAt                            time.Time `json:"created_at"`
	UpdatedAt                            time.Time `json:"updated_at"`
}

func (q *Queries) UpdateBrokerCompanyAgentPropertyBranchMedia(ctx context.Context, arg UpdateBrokerCompanyAgentPropertyBranchMediaParams) (BrokerCompanyAgentPropertiesMediaBranch, error) {
	row := q.db.QueryRow(ctx, updateBrokerCompanyAgentPropertyBranchMedia,
		arg.ID,
		arg.ImageUrl,
		arg.Image360Url,
		arg.VideoUrl,
		arg.PanaromaUrl,
		arg.MainMediaSection,
		arg.BrokerCompanyAgentPropertiesBranchID,
		arg.CreatedAt,
		arg.UpdatedAt,
	)
	var i BrokerCompanyAgentPropertiesMediaBranch
	err := row.Scan(
		&i.ID,
		&i.ImageUrl,
		&i.Image360Url,
		&i.VideoUrl,
		&i.PanaromaUrl,
		&i.MainMediaSection,
		&i.BrokerCompanyAgentPropertiesBranchID,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.IsBranch,
	)
	return i, err
}
