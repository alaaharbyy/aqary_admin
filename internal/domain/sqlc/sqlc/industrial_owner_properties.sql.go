// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: industrial_owner_properties.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createIndustrialOwnerProperty = `-- name: CreateIndustrialOwnerProperty :one
INSERT INTO industrial_owner_properties (
    property_title,
    property_title_arabic,
    description,
    description_arabic,
    is_verified,
    property_rank,
    addresses_id,
    locations_id,
    property_types_id,
    status,
    created_at,
    updated_at,
    facilities_id,
    amenities_id,
    is_show_owner_info,
    property,
    countries_id,
    ref_no,
    category,
    investment,
    contract_start_datetime,
    contract_end_datetime,
    amount,
    unit_types,
    users_id,
    property_name
)VALUES (
     $1 ,$2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26
) RETURNING id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, facilities_id, amenities_id, status, created_at, updated_at, is_show_owner_info, property, countries_id, ref_no, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name
`

type CreateIndustrialOwnerPropertyParams struct {
	PropertyTitle         string             `json:"property_title"`
	PropertyTitleArabic   string             `json:"property_title_arabic"`
	Description           string             `json:"description"`
	DescriptionArabic     string             `json:"description_arabic"`
	IsVerified            pgtype.Bool        `json:"is_verified"`
	PropertyRank          int64              `json:"property_rank"`
	AddressesID           int64              `json:"addresses_id"`
	LocationsID           int64              `json:"locations_id"`
	PropertyTypesID       int64              `json:"property_types_id"`
	Status                int64              `json:"status"`
	CreatedAt             time.Time          `json:"created_at"`
	UpdatedAt             time.Time          `json:"updated_at"`
	FacilitiesID          []int64            `json:"facilities_id"`
	AmenitiesID           []int64            `json:"amenities_id"`
	IsShowOwnerInfo       pgtype.Bool        `json:"is_show_owner_info"`
	Property              int64              `json:"property"`
	CountriesID           int64              `json:"countries_id"`
	RefNo                 string             `json:"ref_no"`
	Category              string             `json:"category"`
	Investment            pgtype.Bool        `json:"investment"`
	ContractStartDatetime pgtype.Timestamptz `json:"contract_start_datetime"`
	ContractEndDatetime   pgtype.Timestamptz `json:"contract_end_datetime"`
	Amount                int64              `json:"amount"`
	UnitTypes             []int64            `json:"unit_types"`
	UsersID               int64              `json:"users_id"`
	PropertyName          string             `json:"property_name"`
}

func (q *Queries) CreateIndustrialOwnerProperty(ctx context.Context, arg CreateIndustrialOwnerPropertyParams) (IndustrialOwnerProperty, error) {
	row := q.db.QueryRow(ctx, createIndustrialOwnerProperty,
		arg.PropertyTitle,
		arg.PropertyTitleArabic,
		arg.Description,
		arg.DescriptionArabic,
		arg.IsVerified,
		arg.PropertyRank,
		arg.AddressesID,
		arg.LocationsID,
		arg.PropertyTypesID,
		arg.Status,
		arg.CreatedAt,
		arg.UpdatedAt,
		arg.FacilitiesID,
		arg.AmenitiesID,
		arg.IsShowOwnerInfo,
		arg.Property,
		arg.CountriesID,
		arg.RefNo,
		arg.Category,
		arg.Investment,
		arg.ContractStartDatetime,
		arg.ContractEndDatetime,
		arg.Amount,
		arg.UnitTypes,
		arg.UsersID,
		arg.PropertyName,
	)
	var i IndustrialOwnerProperty
	err := row.Scan(
		&i.ID,
		&i.PropertyTitle,
		&i.PropertyTitleArabic,
		&i.Description,
		&i.DescriptionArabic,
		&i.IsVerified,
		&i.PropertyRank,
		&i.AddressesID,
		&i.LocationsID,
		&i.PropertyTypesID,
		&i.FacilitiesID,
		&i.AmenitiesID,
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.IsShowOwnerInfo,
		&i.Property,
		&i.CountriesID,
		&i.RefNo,
		&i.Category,
		&i.Investment,
		&i.ContractStartDatetime,
		&i.ContractEndDatetime,
		&i.Amount,
		&i.UnitTypes,
		&i.UsersID,
		&i.PropertyName,
	)
	return i, err
}

const deleteIndustrialOwnerProperty = `-- name: DeleteIndustrialOwnerProperty :exec
DELETE FROM industrial_owner_properties
Where id = $1
`

func (q *Queries) DeleteIndustrialOwnerProperty(ctx context.Context, id int64) error {
	_, err := q.db.Exec(ctx, deleteIndustrialOwnerProperty, id)
	return err
}

const getAllIndustrialOwnerProperty = `-- name: GetAllIndustrialOwnerProperty :many
SELECT id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, facilities_id, amenities_id, status, created_at, updated_at, is_show_owner_info, property, countries_id, ref_no, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name FROM industrial_owner_properties
ORDER BY id
LIMIT $1
OFFSET $2
`

type GetAllIndustrialOwnerPropertyParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) GetAllIndustrialOwnerProperty(ctx context.Context, arg GetAllIndustrialOwnerPropertyParams) ([]IndustrialOwnerProperty, error) {
	rows, err := q.db.Query(ctx, getAllIndustrialOwnerProperty, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []IndustrialOwnerProperty
	for rows.Next() {
		var i IndustrialOwnerProperty
		if err := rows.Scan(
			&i.ID,
			&i.PropertyTitle,
			&i.PropertyTitleArabic,
			&i.Description,
			&i.DescriptionArabic,
			&i.IsVerified,
			&i.PropertyRank,
			&i.AddressesID,
			&i.LocationsID,
			&i.PropertyTypesID,
			&i.FacilitiesID,
			&i.AmenitiesID,
			&i.Status,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.IsShowOwnerInfo,
			&i.Property,
			&i.CountriesID,
			&i.RefNo,
			&i.Category,
			&i.Investment,
			&i.ContractStartDatetime,
			&i.ContractEndDatetime,
			&i.Amount,
			&i.UnitTypes,
			&i.UsersID,
			&i.PropertyName,
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

const getIndustrialOwnerProperty = `-- name: GetIndustrialOwnerProperty :one
SELECT id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, facilities_id, amenities_id, status, created_at, updated_at, is_show_owner_info, property, countries_id, ref_no, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name FROM industrial_owner_properties 
WHERE id = $1 LIMIT $1
`

func (q *Queries) GetIndustrialOwnerProperty(ctx context.Context, limit int32) (IndustrialOwnerProperty, error) {
	row := q.db.QueryRow(ctx, getIndustrialOwnerProperty, limit)
	var i IndustrialOwnerProperty
	err := row.Scan(
		&i.ID,
		&i.PropertyTitle,
		&i.PropertyTitleArabic,
		&i.Description,
		&i.DescriptionArabic,
		&i.IsVerified,
		&i.PropertyRank,
		&i.AddressesID,
		&i.LocationsID,
		&i.PropertyTypesID,
		&i.FacilitiesID,
		&i.AmenitiesID,
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.IsShowOwnerInfo,
		&i.Property,
		&i.CountriesID,
		&i.RefNo,
		&i.Category,
		&i.Investment,
		&i.ContractStartDatetime,
		&i.ContractEndDatetime,
		&i.Amount,
		&i.UnitTypes,
		&i.UsersID,
		&i.PropertyName,
	)
	return i, err
}

const updateIndustrialOwnerProperty = `-- name: UpdateIndustrialOwnerProperty :one
UPDATE industrial_owner_properties
SET   property_title = $2,
    property_title_arabic = $3,
    description = $4,
    description_arabic = $5,
    is_verified = $6,
    property_rank = $7,
    addresses_id = $8,
    locations_id = $9,
    property_types_id = $10,
    status = $11,
    created_at = $12,
    updated_at = $13,
    facilities_id = $14,
    amenities_id = $15,
    is_show_owner_info = $16,
    property = $17,
    countries_id = $18,
    ref_no = $19,
    category = $20,
    investment = $21,
    contract_start_datetime = $22,
    contract_end_datetime = $23,
    amount = $24,
    unit_types = $25,
    users_id = $26,
    property_name = $27
Where id = $1
RETURNING id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, facilities_id, amenities_id, status, created_at, updated_at, is_show_owner_info, property, countries_id, ref_no, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name
`

type UpdateIndustrialOwnerPropertyParams struct {
	ID                    int64              `json:"id"`
	PropertyTitle         string             `json:"property_title"`
	PropertyTitleArabic   string             `json:"property_title_arabic"`
	Description           string             `json:"description"`
	DescriptionArabic     string             `json:"description_arabic"`
	IsVerified            pgtype.Bool        `json:"is_verified"`
	PropertyRank          int64              `json:"property_rank"`
	AddressesID           int64              `json:"addresses_id"`
	LocationsID           int64              `json:"locations_id"`
	PropertyTypesID       int64              `json:"property_types_id"`
	Status                int64              `json:"status"`
	CreatedAt             time.Time          `json:"created_at"`
	UpdatedAt             time.Time          `json:"updated_at"`
	FacilitiesID          []int64            `json:"facilities_id"`
	AmenitiesID           []int64            `json:"amenities_id"`
	IsShowOwnerInfo       pgtype.Bool        `json:"is_show_owner_info"`
	Property              int64              `json:"property"`
	CountriesID           int64              `json:"countries_id"`
	RefNo                 string             `json:"ref_no"`
	Category              string             `json:"category"`
	Investment            pgtype.Bool        `json:"investment"`
	ContractStartDatetime pgtype.Timestamptz `json:"contract_start_datetime"`
	ContractEndDatetime   pgtype.Timestamptz `json:"contract_end_datetime"`
	Amount                int64              `json:"amount"`
	UnitTypes             []int64            `json:"unit_types"`
	UsersID               int64              `json:"users_id"`
	PropertyName          string             `json:"property_name"`
}

func (q *Queries) UpdateIndustrialOwnerProperty(ctx context.Context, arg UpdateIndustrialOwnerPropertyParams) (IndustrialOwnerProperty, error) {
	row := q.db.QueryRow(ctx, updateIndustrialOwnerProperty,
		arg.ID,
		arg.PropertyTitle,
		arg.PropertyTitleArabic,
		arg.Description,
		arg.DescriptionArabic,
		arg.IsVerified,
		arg.PropertyRank,
		arg.AddressesID,
		arg.LocationsID,
		arg.PropertyTypesID,
		arg.Status,
		arg.CreatedAt,
		arg.UpdatedAt,
		arg.FacilitiesID,
		arg.AmenitiesID,
		arg.IsShowOwnerInfo,
		arg.Property,
		arg.CountriesID,
		arg.RefNo,
		arg.Category,
		arg.Investment,
		arg.ContractStartDatetime,
		arg.ContractEndDatetime,
		arg.Amount,
		arg.UnitTypes,
		arg.UsersID,
		arg.PropertyName,
	)
	var i IndustrialOwnerProperty
	err := row.Scan(
		&i.ID,
		&i.PropertyTitle,
		&i.PropertyTitleArabic,
		&i.Description,
		&i.DescriptionArabic,
		&i.IsVerified,
		&i.PropertyRank,
		&i.AddressesID,
		&i.LocationsID,
		&i.PropertyTypesID,
		&i.FacilitiesID,
		&i.AmenitiesID,
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.IsShowOwnerInfo,
		&i.Property,
		&i.CountriesID,
		&i.RefNo,
		&i.Category,
		&i.Investment,
		&i.ContractStartDatetime,
		&i.ContractEndDatetime,
		&i.Amount,
		&i.UnitTypes,
		&i.UsersID,
		&i.PropertyName,
	)
	return i, err
}

const updateIndustrialOwnerPropertyRank = `-- name: UpdateIndustrialOwnerPropertyRank :one
UPDATE industrial_owner_properties SET property_rank = $2 WHERE id = $1 RETURNING id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, facilities_id, amenities_id, status, created_at, updated_at, is_show_owner_info, property, countries_id, ref_no, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name
`

type UpdateIndustrialOwnerPropertyRankParams struct {
	ID           int64 `json:"id"`
	PropertyRank int64 `json:"property_rank"`
}

func (q *Queries) UpdateIndustrialOwnerPropertyRank(ctx context.Context, arg UpdateIndustrialOwnerPropertyRankParams) (IndustrialOwnerProperty, error) {
	row := q.db.QueryRow(ctx, updateIndustrialOwnerPropertyRank, arg.ID, arg.PropertyRank)
	var i IndustrialOwnerProperty
	err := row.Scan(
		&i.ID,
		&i.PropertyTitle,
		&i.PropertyTitleArabic,
		&i.Description,
		&i.DescriptionArabic,
		&i.IsVerified,
		&i.PropertyRank,
		&i.AddressesID,
		&i.LocationsID,
		&i.PropertyTypesID,
		&i.FacilitiesID,
		&i.AmenitiesID,
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.IsShowOwnerInfo,
		&i.Property,
		&i.CountriesID,
		&i.RefNo,
		&i.Category,
		&i.Investment,
		&i.ContractStartDatetime,
		&i.ContractEndDatetime,
		&i.Amount,
		&i.UnitTypes,
		&i.UsersID,
		&i.PropertyName,
	)
	return i, err
}

const updateIndustrialOwnerPropertyStatus = `-- name: UpdateIndustrialOwnerPropertyStatus :one
 UPDATE industrial_owner_properties SET status = $2 WHERE id = $1 RETURNING id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, facilities_id, amenities_id, status, created_at, updated_at, is_show_owner_info, property, countries_id, ref_no, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name
`

type UpdateIndustrialOwnerPropertyStatusParams struct {
	ID     int64 `json:"id"`
	Status int64 `json:"status"`
}

func (q *Queries) UpdateIndustrialOwnerPropertyStatus(ctx context.Context, arg UpdateIndustrialOwnerPropertyStatusParams) (IndustrialOwnerProperty, error) {
	row := q.db.QueryRow(ctx, updateIndustrialOwnerPropertyStatus, arg.ID, arg.Status)
	var i IndustrialOwnerProperty
	err := row.Scan(
		&i.ID,
		&i.PropertyTitle,
		&i.PropertyTitleArabic,
		&i.Description,
		&i.DescriptionArabic,
		&i.IsVerified,
		&i.PropertyRank,
		&i.AddressesID,
		&i.LocationsID,
		&i.PropertyTypesID,
		&i.FacilitiesID,
		&i.AmenitiesID,
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.IsShowOwnerInfo,
		&i.Property,
		&i.CountriesID,
		&i.RefNo,
		&i.Category,
		&i.Investment,
		&i.ContractStartDatetime,
		&i.ContractEndDatetime,
		&i.Amount,
		&i.UnitTypes,
		&i.UsersID,
		&i.PropertyName,
	)
	return i, err
}

const updateIndustrialOwnerPropertyVerifyStatus = `-- name: UpdateIndustrialOwnerPropertyVerifyStatus :one
UPDATE industrial_owner_properties SET is_verified = $2 WHERE id = $1 RETURNING id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, facilities_id, amenities_id, status, created_at, updated_at, is_show_owner_info, property, countries_id, ref_no, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name
`

type UpdateIndustrialOwnerPropertyVerifyStatusParams struct {
	ID         int64       `json:"id"`
	IsVerified pgtype.Bool `json:"is_verified"`
}

func (q *Queries) UpdateIndustrialOwnerPropertyVerifyStatus(ctx context.Context, arg UpdateIndustrialOwnerPropertyVerifyStatusParams) (IndustrialOwnerProperty, error) {
	row := q.db.QueryRow(ctx, updateIndustrialOwnerPropertyVerifyStatus, arg.ID, arg.IsVerified)
	var i IndustrialOwnerProperty
	err := row.Scan(
		&i.ID,
		&i.PropertyTitle,
		&i.PropertyTitleArabic,
		&i.Description,
		&i.DescriptionArabic,
		&i.IsVerified,
		&i.PropertyRank,
		&i.AddressesID,
		&i.LocationsID,
		&i.PropertyTypesID,
		&i.FacilitiesID,
		&i.AmenitiesID,
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.IsShowOwnerInfo,
		&i.Property,
		&i.CountriesID,
		&i.RefNo,
		&i.Category,
		&i.Investment,
		&i.ContractStartDatetime,
		&i.ContractEndDatetime,
		&i.Amount,
		&i.UnitTypes,
		&i.UsersID,
		&i.PropertyName,
	)
	return i, err
}
