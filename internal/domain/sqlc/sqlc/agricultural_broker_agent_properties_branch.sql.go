// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: agricultural_broker_agent_properties_branch.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createAgriculturalBrokerAgentPropertyBranch = `-- name: CreateAgriculturalBrokerAgentPropertyBranch :one
INSERT INTO agricultural_broker_agent_properties_branch (
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
    broker_companies_branches_id,
    broker_company_branches_agents,
    is_show_owner_info,
    property,
    countries_id,
    ref_no,
    developer_company_name,
    sub_developer_company_name,
    is_branch,
    category,
    investment,
    contract_start_datetime,
    contract_end_datetime,
    amount,
    unit_types,
    users_id,
    property_name,
    from_xml,
    owner_users_id
)VALUES (
     $1 ,$2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33
) RETURNING id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id, broker_companies_branches_id, broker_company_branches_agents, is_show_owner_info, property, countries_id, ref_no, developer_company_name, sub_developer_company_name, is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name, from_xml, owner_users_id
`

type CreateAgriculturalBrokerAgentPropertyBranchParams struct {
	PropertyTitle               string             `json:"property_title"`
	PropertyTitleArabic         string             `json:"property_title_arabic"`
	Description                 string             `json:"description"`
	DescriptionArabic           string             `json:"description_arabic"`
	IsVerified                  pgtype.Bool        `json:"is_verified"`
	PropertyRank                int64              `json:"property_rank"`
	AddressesID                 int64              `json:"addresses_id"`
	LocationsID                 int64              `json:"locations_id"`
	PropertyTypesID             int64              `json:"property_types_id"`
	Status                      int64              `json:"status"`
	CreatedAt                   time.Time          `json:"created_at"`
	UpdatedAt                   time.Time          `json:"updated_at"`
	FacilitiesID                []int64            `json:"facilities_id"`
	AmenitiesID                 []int64            `json:"amenities_id"`
	BrokerCompaniesBranchesID   int64              `json:"broker_companies_branches_id"`
	BrokerCompanyBranchesAgents int64              `json:"broker_company_branches_agents"`
	IsShowOwnerInfo             pgtype.Bool        `json:"is_show_owner_info"`
	Property                    int64              `json:"property"`
	CountriesID                 int64              `json:"countries_id"`
	RefNo                       string             `json:"ref_no"`
	DeveloperCompanyName        pgtype.Text        `json:"developer_company_name"`
	SubDeveloperCompanyName     pgtype.Text        `json:"sub_developer_company_name"`
	IsBranch                    pgtype.Bool        `json:"is_branch"`
	Category                    string             `json:"category"`
	Investment                  pgtype.Bool        `json:"investment"`
	ContractStartDatetime       pgtype.Timestamptz `json:"contract_start_datetime"`
	ContractEndDatetime         pgtype.Timestamptz `json:"contract_end_datetime"`
	Amount                      int64              `json:"amount"`
	UnitTypes                   []int64            `json:"unit_types"`
	UsersID                     int64              `json:"users_id"`
	PropertyName                string             `json:"property_name"`
	FromXml                     pgtype.Bool        `json:"from_xml"`
	OwnerUsersID                pgtype.Int8        `json:"owner_users_id"`
}

func (q *Queries) CreateAgriculturalBrokerAgentPropertyBranch(ctx context.Context, arg CreateAgriculturalBrokerAgentPropertyBranchParams) (AgriculturalBrokerAgentPropertiesBranch, error) {
	row := q.db.QueryRow(ctx, createAgriculturalBrokerAgentPropertyBranch,
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
		arg.BrokerCompaniesBranchesID,
		arg.BrokerCompanyBranchesAgents,
		arg.IsShowOwnerInfo,
		arg.Property,
		arg.CountriesID,
		arg.RefNo,
		arg.DeveloperCompanyName,
		arg.SubDeveloperCompanyName,
		arg.IsBranch,
		arg.Category,
		arg.Investment,
		arg.ContractStartDatetime,
		arg.ContractEndDatetime,
		arg.Amount,
		arg.UnitTypes,
		arg.UsersID,
		arg.PropertyName,
		arg.FromXml,
		arg.OwnerUsersID,
	)
	var i AgriculturalBrokerAgentPropertiesBranch
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
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.FacilitiesID,
		&i.AmenitiesID,
		&i.BrokerCompaniesBranchesID,
		&i.BrokerCompanyBranchesAgents,
		&i.IsShowOwnerInfo,
		&i.Property,
		&i.CountriesID,
		&i.RefNo,
		&i.DeveloperCompanyName,
		&i.SubDeveloperCompanyName,
		&i.IsBranch,
		&i.Category,
		&i.Investment,
		&i.ContractStartDatetime,
		&i.ContractEndDatetime,
		&i.Amount,
		&i.UnitTypes,
		&i.UsersID,
		&i.PropertyName,
		&i.FromXml,
		&i.OwnerUsersID,
	)
	return i, err
}

const deleteAgriculturalBrokerAgentPropertyBranch = `-- name: DeleteAgriculturalBrokerAgentPropertyBranch :exec
DELETE FROM agricultural_broker_agent_properties_branch
Where id = $1
`

func (q *Queries) DeleteAgriculturalBrokerAgentPropertyBranch(ctx context.Context, id int64) error {
	_, err := q.db.Exec(ctx, deleteAgriculturalBrokerAgentPropertyBranch, id)
	return err
}

const getAgriculturalBrokerAgentPropertyBranch = `-- name: GetAgriculturalBrokerAgentPropertyBranch :one
SELECT id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id, broker_companies_branches_id, broker_company_branches_agents, is_show_owner_info, property, countries_id, ref_no, developer_company_name, sub_developer_company_name, is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name, from_xml, owner_users_id FROM agricultural_broker_agent_properties_branch 
WHERE id = $1 LIMIT $1
`

func (q *Queries) GetAgriculturalBrokerAgentPropertyBranch(ctx context.Context, limit int32) (AgriculturalBrokerAgentPropertiesBranch, error) {
	row := q.db.QueryRow(ctx, getAgriculturalBrokerAgentPropertyBranch, limit)
	var i AgriculturalBrokerAgentPropertiesBranch
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
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.FacilitiesID,
		&i.AmenitiesID,
		&i.BrokerCompaniesBranchesID,
		&i.BrokerCompanyBranchesAgents,
		&i.IsShowOwnerInfo,
		&i.Property,
		&i.CountriesID,
		&i.RefNo,
		&i.DeveloperCompanyName,
		&i.SubDeveloperCompanyName,
		&i.IsBranch,
		&i.Category,
		&i.Investment,
		&i.ContractStartDatetime,
		&i.ContractEndDatetime,
		&i.Amount,
		&i.UnitTypes,
		&i.UsersID,
		&i.PropertyName,
		&i.FromXml,
		&i.OwnerUsersID,
	)
	return i, err
}

const getAllAgriculturalBrokerAgentPropertyBranch = `-- name: GetAllAgriculturalBrokerAgentPropertyBranch :many
SELECT id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id, broker_companies_branches_id, broker_company_branches_agents, is_show_owner_info, property, countries_id, ref_no, developer_company_name, sub_developer_company_name, is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name, from_xml, owner_users_id FROM agricultural_broker_agent_properties_branch
ORDER BY id
LIMIT $1
OFFSET $2
`

type GetAllAgriculturalBrokerAgentPropertyBranchParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) GetAllAgriculturalBrokerAgentPropertyBranch(ctx context.Context, arg GetAllAgriculturalBrokerAgentPropertyBranchParams) ([]AgriculturalBrokerAgentPropertiesBranch, error) {
	rows, err := q.db.Query(ctx, getAllAgriculturalBrokerAgentPropertyBranch, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []AgriculturalBrokerAgentPropertiesBranch
	for rows.Next() {
		var i AgriculturalBrokerAgentPropertiesBranch
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
			&i.Status,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.FacilitiesID,
			&i.AmenitiesID,
			&i.BrokerCompaniesBranchesID,
			&i.BrokerCompanyBranchesAgents,
			&i.IsShowOwnerInfo,
			&i.Property,
			&i.CountriesID,
			&i.RefNo,
			&i.DeveloperCompanyName,
			&i.SubDeveloperCompanyName,
			&i.IsBranch,
			&i.Category,
			&i.Investment,
			&i.ContractStartDatetime,
			&i.ContractEndDatetime,
			&i.Amount,
			&i.UnitTypes,
			&i.UsersID,
			&i.PropertyName,
			&i.FromXml,
			&i.OwnerUsersID,
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

const updateAgriculturalBrokerAgentPropertyBranch = `-- name: UpdateAgriculturalBrokerAgentPropertyBranch :one
UPDATE agricultural_broker_agent_properties_branch
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
    broker_companies_branches_id = $16,
    broker_company_branches_agents = $17,
    is_show_owner_info = $18,
    property = $19,
    countries_id = $20,
    ref_no = $21,
    developer_company_name = $22,
    sub_developer_company_name = $23,
    is_branch = $24,
    category = $25,
    investment = $26,
    contract_start_datetime = $27,
    contract_end_datetime = $28,
    amount = $29,
    unit_types = $30,
    users_id = $31,
    property_name = $32,
    from_xml = $33,
    owner_users_id = $34
Where id = $1
RETURNING id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id, broker_companies_branches_id, broker_company_branches_agents, is_show_owner_info, property, countries_id, ref_no, developer_company_name, sub_developer_company_name, is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name, from_xml, owner_users_id
`

type UpdateAgriculturalBrokerAgentPropertyBranchParams struct {
	ID                          int64              `json:"id"`
	PropertyTitle               string             `json:"property_title"`
	PropertyTitleArabic         string             `json:"property_title_arabic"`
	Description                 string             `json:"description"`
	DescriptionArabic           string             `json:"description_arabic"`
	IsVerified                  pgtype.Bool        `json:"is_verified"`
	PropertyRank                int64              `json:"property_rank"`
	AddressesID                 int64              `json:"addresses_id"`
	LocationsID                 int64              `json:"locations_id"`
	PropertyTypesID             int64              `json:"property_types_id"`
	Status                      int64              `json:"status"`
	CreatedAt                   time.Time          `json:"created_at"`
	UpdatedAt                   time.Time          `json:"updated_at"`
	FacilitiesID                []int64            `json:"facilities_id"`
	AmenitiesID                 []int64            `json:"amenities_id"`
	BrokerCompaniesBranchesID   int64              `json:"broker_companies_branches_id"`
	BrokerCompanyBranchesAgents int64              `json:"broker_company_branches_agents"`
	IsShowOwnerInfo             pgtype.Bool        `json:"is_show_owner_info"`
	Property                    int64              `json:"property"`
	CountriesID                 int64              `json:"countries_id"`
	RefNo                       string             `json:"ref_no"`
	DeveloperCompanyName        pgtype.Text        `json:"developer_company_name"`
	SubDeveloperCompanyName     pgtype.Text        `json:"sub_developer_company_name"`
	IsBranch                    pgtype.Bool        `json:"is_branch"`
	Category                    string             `json:"category"`
	Investment                  pgtype.Bool        `json:"investment"`
	ContractStartDatetime       pgtype.Timestamptz `json:"contract_start_datetime"`
	ContractEndDatetime         pgtype.Timestamptz `json:"contract_end_datetime"`
	Amount                      int64              `json:"amount"`
	UnitTypes                   []int64            `json:"unit_types"`
	UsersID                     int64              `json:"users_id"`
	PropertyName                string             `json:"property_name"`
	FromXml                     pgtype.Bool        `json:"from_xml"`
	OwnerUsersID                pgtype.Int8        `json:"owner_users_id"`
}

func (q *Queries) UpdateAgriculturalBrokerAgentPropertyBranch(ctx context.Context, arg UpdateAgriculturalBrokerAgentPropertyBranchParams) (AgriculturalBrokerAgentPropertiesBranch, error) {
	row := q.db.QueryRow(ctx, updateAgriculturalBrokerAgentPropertyBranch,
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
		arg.BrokerCompaniesBranchesID,
		arg.BrokerCompanyBranchesAgents,
		arg.IsShowOwnerInfo,
		arg.Property,
		arg.CountriesID,
		arg.RefNo,
		arg.DeveloperCompanyName,
		arg.SubDeveloperCompanyName,
		arg.IsBranch,
		arg.Category,
		arg.Investment,
		arg.ContractStartDatetime,
		arg.ContractEndDatetime,
		arg.Amount,
		arg.UnitTypes,
		arg.UsersID,
		arg.PropertyName,
		arg.FromXml,
		arg.OwnerUsersID,
	)
	var i AgriculturalBrokerAgentPropertiesBranch
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
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.FacilitiesID,
		&i.AmenitiesID,
		&i.BrokerCompaniesBranchesID,
		&i.BrokerCompanyBranchesAgents,
		&i.IsShowOwnerInfo,
		&i.Property,
		&i.CountriesID,
		&i.RefNo,
		&i.DeveloperCompanyName,
		&i.SubDeveloperCompanyName,
		&i.IsBranch,
		&i.Category,
		&i.Investment,
		&i.ContractStartDatetime,
		&i.ContractEndDatetime,
		&i.Amount,
		&i.UnitTypes,
		&i.UsersID,
		&i.PropertyName,
		&i.FromXml,
		&i.OwnerUsersID,
	)
	return i, err
}

const updateAgriculturalBrokerAgentPropertyBranchRank = `-- name: UpdateAgriculturalBrokerAgentPropertyBranchRank :one
UPDATE agricultural_broker_agent_properties_branch SET property_rank = $2 WHERE id = $1 RETURNING id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id, broker_companies_branches_id, broker_company_branches_agents, is_show_owner_info, property, countries_id, ref_no, developer_company_name, sub_developer_company_name, is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name, from_xml, owner_users_id
`

type UpdateAgriculturalBrokerAgentPropertyBranchRankParams struct {
	ID           int64 `json:"id"`
	PropertyRank int64 `json:"property_rank"`
}

func (q *Queries) UpdateAgriculturalBrokerAgentPropertyBranchRank(ctx context.Context, arg UpdateAgriculturalBrokerAgentPropertyBranchRankParams) (AgriculturalBrokerAgentPropertiesBranch, error) {
	row := q.db.QueryRow(ctx, updateAgriculturalBrokerAgentPropertyBranchRank, arg.ID, arg.PropertyRank)
	var i AgriculturalBrokerAgentPropertiesBranch
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
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.FacilitiesID,
		&i.AmenitiesID,
		&i.BrokerCompaniesBranchesID,
		&i.BrokerCompanyBranchesAgents,
		&i.IsShowOwnerInfo,
		&i.Property,
		&i.CountriesID,
		&i.RefNo,
		&i.DeveloperCompanyName,
		&i.SubDeveloperCompanyName,
		&i.IsBranch,
		&i.Category,
		&i.Investment,
		&i.ContractStartDatetime,
		&i.ContractEndDatetime,
		&i.Amount,
		&i.UnitTypes,
		&i.UsersID,
		&i.PropertyName,
		&i.FromXml,
		&i.OwnerUsersID,
	)
	return i, err
}

const updateAgriculturalBrokerAgentPropertyBranchStatus = `-- name: UpdateAgriculturalBrokerAgentPropertyBranchStatus :one
 UPDATE agricultural_broker_agent_properties_branch SET status = $2 WHERE id = $1 RETURNING id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id, broker_companies_branches_id, broker_company_branches_agents, is_show_owner_info, property, countries_id, ref_no, developer_company_name, sub_developer_company_name, is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name, from_xml, owner_users_id
`

type UpdateAgriculturalBrokerAgentPropertyBranchStatusParams struct {
	ID     int64 `json:"id"`
	Status int64 `json:"status"`
}

func (q *Queries) UpdateAgriculturalBrokerAgentPropertyBranchStatus(ctx context.Context, arg UpdateAgriculturalBrokerAgentPropertyBranchStatusParams) (AgriculturalBrokerAgentPropertiesBranch, error) {
	row := q.db.QueryRow(ctx, updateAgriculturalBrokerAgentPropertyBranchStatus, arg.ID, arg.Status)
	var i AgriculturalBrokerAgentPropertiesBranch
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
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.FacilitiesID,
		&i.AmenitiesID,
		&i.BrokerCompaniesBranchesID,
		&i.BrokerCompanyBranchesAgents,
		&i.IsShowOwnerInfo,
		&i.Property,
		&i.CountriesID,
		&i.RefNo,
		&i.DeveloperCompanyName,
		&i.SubDeveloperCompanyName,
		&i.IsBranch,
		&i.Category,
		&i.Investment,
		&i.ContractStartDatetime,
		&i.ContractEndDatetime,
		&i.Amount,
		&i.UnitTypes,
		&i.UsersID,
		&i.PropertyName,
		&i.FromXml,
		&i.OwnerUsersID,
	)
	return i, err
}

const updateAgriculturalBrokerAgentPropertyBranchVerifyStatus = `-- name: UpdateAgriculturalBrokerAgentPropertyBranchVerifyStatus :one
UPDATE agricultural_broker_agent_properties_branch SET is_verified = $2 WHERE id = $1 RETURNING id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id, broker_companies_branches_id, broker_company_branches_agents, is_show_owner_info, property, countries_id, ref_no, developer_company_name, sub_developer_company_name, is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name, from_xml, owner_users_id
`

type UpdateAgriculturalBrokerAgentPropertyBranchVerifyStatusParams struct {
	ID         int64       `json:"id"`
	IsVerified pgtype.Bool `json:"is_verified"`
}

func (q *Queries) UpdateAgriculturalBrokerAgentPropertyBranchVerifyStatus(ctx context.Context, arg UpdateAgriculturalBrokerAgentPropertyBranchVerifyStatusParams) (AgriculturalBrokerAgentPropertiesBranch, error) {
	row := q.db.QueryRow(ctx, updateAgriculturalBrokerAgentPropertyBranchVerifyStatus, arg.ID, arg.IsVerified)
	var i AgriculturalBrokerAgentPropertiesBranch
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
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.FacilitiesID,
		&i.AmenitiesID,
		&i.BrokerCompaniesBranchesID,
		&i.BrokerCompanyBranchesAgents,
		&i.IsShowOwnerInfo,
		&i.Property,
		&i.CountriesID,
		&i.RefNo,
		&i.DeveloperCompanyName,
		&i.SubDeveloperCompanyName,
		&i.IsBranch,
		&i.Category,
		&i.Investment,
		&i.ContractStartDatetime,
		&i.ContractEndDatetime,
		&i.Amount,
		&i.UnitTypes,
		&i.UsersID,
		&i.PropertyName,
		&i.FromXml,
		&i.OwnerUsersID,
	)
	return i, err
}

const updateAgriculureBrokerAgentPropertyBranchStatus = `-- name: UpdateAgriculureBrokerAgentPropertyBranchStatus :one
UPDATE agricultural_broker_agent_properties_branch Set status=$2 Where id=$1 RETURNING id, property_title, property_title_arabic, description, description_arabic, is_verified, property_rank, addresses_id, locations_id, property_types_id, status, created_at, updated_at, facilities_id, amenities_id, broker_companies_branches_id, broker_company_branches_agents, is_show_owner_info, property, countries_id, ref_no, developer_company_name, sub_developer_company_name, is_branch, category, investment, contract_start_datetime, contract_end_datetime, amount, unit_types, users_id, property_name, from_xml, owner_users_id
`

type UpdateAgriculureBrokerAgentPropertyBranchStatusParams struct {
	ID     int64 `json:"id"`
	Status int64 `json:"status"`
}

func (q *Queries) UpdateAgriculureBrokerAgentPropertyBranchStatus(ctx context.Context, arg UpdateAgriculureBrokerAgentPropertyBranchStatusParams) (AgriculturalBrokerAgentPropertiesBranch, error) {
	row := q.db.QueryRow(ctx, updateAgriculureBrokerAgentPropertyBranchStatus, arg.ID, arg.Status)
	var i AgriculturalBrokerAgentPropertiesBranch
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
		&i.Status,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.FacilitiesID,
		&i.AmenitiesID,
		&i.BrokerCompaniesBranchesID,
		&i.BrokerCompanyBranchesAgents,
		&i.IsShowOwnerInfo,
		&i.Property,
		&i.CountriesID,
		&i.RefNo,
		&i.DeveloperCompanyName,
		&i.SubDeveloperCompanyName,
		&i.IsBranch,
		&i.Category,
		&i.Investment,
		&i.ContractStartDatetime,
		&i.ContractEndDatetime,
		&i.Amount,
		&i.UnitTypes,
		&i.UsersID,
		&i.PropertyName,
		&i.FromXml,
		&i.OwnerUsersID,
	)
	return i, err
}
