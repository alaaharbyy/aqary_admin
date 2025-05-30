// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: addresses.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createAddress = `-- name: CreateAddress :one
INSERT INTO addresses (
    countries_id,
    states_id,  
    cities_id,
    communities_id,
    sub_communities_id,
    locations_id
)VALUES (
    $1, $2, $3, $4, $5, $6
) RETURNING id, countries_id, states_id, cities_id, communities_id, sub_communities_id, locations_id, created_at, updated_at, property_map_location_id, full_address, full_address_ar
`

type CreateAddressParams struct {
	CountriesID      pgtype.Int8 `json:"countries_id"`
	StatesID         pgtype.Int8 `json:"states_id"`
	CitiesID         pgtype.Int8 `json:"cities_id"`
	CommunitiesID    pgtype.Int8 `json:"communities_id"`
	SubCommunitiesID pgtype.Int8 `json:"sub_communities_id"`
	LocationsID      pgtype.Int8 `json:"locations_id"`
}

func (q *Queries) CreateAddress(ctx context.Context, arg CreateAddressParams) (Address, error) {
	row := q.db.QueryRow(ctx, createAddress,
		arg.CountriesID,
		arg.StatesID,
		arg.CitiesID,
		arg.CommunitiesID,
		arg.SubCommunitiesID,
		arg.LocationsID,
	)
	var i Address
	err := row.Scan(
		&i.ID,
		&i.CountriesID,
		&i.StatesID,
		&i.CitiesID,
		&i.CommunitiesID,
		&i.SubCommunitiesID,
		&i.LocationsID,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.PropertyMapLocationID,
		&i.FullAddress,
		&i.FullAddressAr,
	)
	return i, err
}

const deleteAddress = `-- name: DeleteAddress :exec
DELETE FROM addresses
Where id = $1
`

func (q *Queries) DeleteAddress(ctx context.Context, id int64) error {
	_, err := q.db.Exec(ctx, deleteAddress, id)
	return err
}

const deleteXMLAddresses = `-- name: DeleteXMLAddresses :exec
DELETE FROM addresses
WHERE id = ANY($1::bigint[])
`

func (q *Queries) DeleteXMLAddresses(ctx context.Context, idsToDelete []int64) error {
	_, err := q.db.Exec(ctx, deleteXMLAddresses, idsToDelete)
	return err
}

const getAddress = `-- name: GetAddress :one
SELECT id, countries_id, states_id, cities_id, communities_id, sub_communities_id, locations_id, created_at, updated_at, property_map_location_id, full_address, full_address_ar FROM addresses 
WHERE id = $1 LIMIT $1
`

func (q *Queries) GetAddress(ctx context.Context, limit int32) (Address, error) {
	row := q.db.QueryRow(ctx, getAddress, limit)
	var i Address
	err := row.Scan(
		&i.ID,
		&i.CountriesID,
		&i.StatesID,
		&i.CitiesID,
		&i.CommunitiesID,
		&i.SubCommunitiesID,
		&i.LocationsID,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.PropertyMapLocationID,
		&i.FullAddress,
		&i.FullAddressAr,
	)
	return i, err
}

const getAddressAllDetailsByID = `-- name: GetAddressAllDetailsByID :one
SELECT 
ad.id,
ad.countries_id,
ad.states_id,
ad.cities_id,
ad.communities_id,
ad.sub_communities_id,
ad.locations_id,
ad.created_at,
ad.updated_at,
 
 
ad_country.id as ad_country_id,
ad_country.country as ad_country_country,
ad_country.flag as ad_country_flag,
ad_country.created_at as ad_country_created_at,
ad_country.updated_at as ad_country_updated_at,
ad_country.alpha2_code as ad_country_alpha2_code,
ad_country.alpha3_code as ad_country_alpha3_code,
ad_country.country_code as ad_country_country_code,
ad_country.lat as ad_country_country_lat,
ad_country.lng as ad_country_country_lng,
 
ad_states.id as ad_states_id,
ad_states.state as ad_states_state,
ad_states.countries_id as ad_states_countries_id,
ad_states.created_at as ad_states_created_at,
ad_states.updated_at as ad_states_updated_at,
ad_states.lat as ad_states_lat,
ad_states.lng as ad_states_lng,
 
ad_cities.id as ad_cities_id,
ad_cities.city as ad_cities_city,
ad_cities.states_id as ad_cities_states_id,
ad_cities.created_at as ad_cities_created_at,
ad_cities.updated_at as ad_cities_updated_at,
ad_cities.lat as ad_cities_lat,
ad_cities.lng as ad_cities_lng,
 
 
ad_communities.id as ad_communities_id,
ad_communities.community as ad_communities_community,
ad_communities.cities_id as ad_communities_cities_id,
ad_communities.created_at as ad_communities_created_at,
ad_communities.updated_at as ad_communities_updated_at,
ad_communities.lat as ad_communities_lat,
ad_communities.lng as ad_communities_lng,
 
 
ad_sub_communities.id as ad_sub_communities_id,
ad_sub_communities.sub_community as ad_sub_communities_sub_community,
ad_sub_communities.communities_id as ad_sub_communities_communities_id,
ad_sub_communities.created_at as ad_sub_communities_created_at,
ad_sub_communities.updated_at as ad_sub_communities_updated_at,
ad_sub_communities.lat as ad_sub_communities_lat,
ad_sub_communities.lng as ad_sub_communities_lng
 
 
FROM addresses ad
left join countries as ad_country ON ad.countries_id = ad_country.id
left join states as ad_states ON ad.states_id = ad_states.id
left join cities as ad_cities ON ad.cities_id = ad_cities.id
left join communities as ad_communities ON ad.communities_id = ad_communities.id
left join sub_communities as ad_sub_communities ON ad.sub_communities_id = ad_sub_communities.id
WHERE ad.id = $1 LIMIT 1
`

type GetAddressAllDetailsByIDRow struct {
	ID                            int64              `json:"id"`
	CountriesID                   pgtype.Int8        `json:"countries_id"`
	StatesID                      pgtype.Int8        `json:"states_id"`
	CitiesID                      pgtype.Int8        `json:"cities_id"`
	CommunitiesID                 pgtype.Int8        `json:"communities_id"`
	SubCommunitiesID              pgtype.Int8        `json:"sub_communities_id"`
	LocationsID                   pgtype.Int8        `json:"locations_id"`
	CreatedAt                     time.Time          `json:"created_at"`
	UpdatedAt                     time.Time          `json:"updated_at"`
	AdCountryID                   pgtype.Int8        `json:"ad_country_id"`
	AdCountryCountry              pgtype.Text        `json:"ad_country_country"`
	AdCountryFlag                 pgtype.Text        `json:"ad_country_flag"`
	AdCountryCreatedAt            pgtype.Timestamptz `json:"ad_country_created_at"`
	AdCountryUpdatedAt            pgtype.Timestamptz `json:"ad_country_updated_at"`
	AdCountryAlpha2Code           pgtype.Text        `json:"ad_country_alpha2_code"`
	AdCountryAlpha3Code           pgtype.Text        `json:"ad_country_alpha3_code"`
	AdCountryCountryCode          pgtype.Int8        `json:"ad_country_country_code"`
	AdCountryCountryLat           pgtype.Float8      `json:"ad_country_country_lat"`
	AdCountryCountryLng           pgtype.Float8      `json:"ad_country_country_lng"`
	AdStatesID                    pgtype.Int8        `json:"ad_states_id"`
	AdStatesState                 pgtype.Text        `json:"ad_states_state"`
	AdStatesCountriesID           pgtype.Int8        `json:"ad_states_countries_id"`
	AdStatesCreatedAt             pgtype.Timestamptz `json:"ad_states_created_at"`
	AdStatesUpdatedAt             pgtype.Timestamptz `json:"ad_states_updated_at"`
	AdStatesLat                   pgtype.Float8      `json:"ad_states_lat"`
	AdStatesLng                   pgtype.Float8      `json:"ad_states_lng"`
	AdCitiesID                    pgtype.Int8        `json:"ad_cities_id"`
	AdCitiesCity                  pgtype.Text        `json:"ad_cities_city"`
	AdCitiesStatesID              pgtype.Int8        `json:"ad_cities_states_id"`
	AdCitiesCreatedAt             pgtype.Timestamptz `json:"ad_cities_created_at"`
	AdCitiesUpdatedAt             pgtype.Timestamptz `json:"ad_cities_updated_at"`
	AdCitiesLat                   pgtype.Float8      `json:"ad_cities_lat"`
	AdCitiesLng                   pgtype.Float8      `json:"ad_cities_lng"`
	AdCommunitiesID               pgtype.Int8        `json:"ad_communities_id"`
	AdCommunitiesCommunity        pgtype.Text        `json:"ad_communities_community"`
	AdCommunitiesCitiesID         pgtype.Int8        `json:"ad_communities_cities_id"`
	AdCommunitiesCreatedAt        pgtype.Timestamptz `json:"ad_communities_created_at"`
	AdCommunitiesUpdatedAt        pgtype.Timestamptz `json:"ad_communities_updated_at"`
	AdCommunitiesLat              pgtype.Float8      `json:"ad_communities_lat"`
	AdCommunitiesLng              pgtype.Float8      `json:"ad_communities_lng"`
	AdSubCommunitiesID            pgtype.Int8        `json:"ad_sub_communities_id"`
	AdSubCommunitiesSubCommunity  pgtype.Text        `json:"ad_sub_communities_sub_community"`
	AdSubCommunitiesCommunitiesID pgtype.Int8        `json:"ad_sub_communities_communities_id"`
	AdSubCommunitiesCreatedAt     pgtype.Timestamptz `json:"ad_sub_communities_created_at"`
	AdSubCommunitiesUpdatedAt     pgtype.Timestamptz `json:"ad_sub_communities_updated_at"`
	AdSubCommunitiesLat           pgtype.Float8      `json:"ad_sub_communities_lat"`
	AdSubCommunitiesLng           pgtype.Float8      `json:"ad_sub_communities_lng"`
}

func (q *Queries) GetAddressAllDetailsByID(ctx context.Context, id int64) (GetAddressAllDetailsByIDRow, error) {
	row := q.db.QueryRow(ctx, getAddressAllDetailsByID, id)
	var i GetAddressAllDetailsByIDRow
	err := row.Scan(
		&i.ID,
		&i.CountriesID,
		&i.StatesID,
		&i.CitiesID,
		&i.CommunitiesID,
		&i.SubCommunitiesID,
		&i.LocationsID,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.AdCountryID,
		&i.AdCountryCountry,
		&i.AdCountryFlag,
		&i.AdCountryCreatedAt,
		&i.AdCountryUpdatedAt,
		&i.AdCountryAlpha2Code,
		&i.AdCountryAlpha3Code,
		&i.AdCountryCountryCode,
		&i.AdCountryCountryLat,
		&i.AdCountryCountryLng,
		&i.AdStatesID,
		&i.AdStatesState,
		&i.AdStatesCountriesID,
		&i.AdStatesCreatedAt,
		&i.AdStatesUpdatedAt,
		&i.AdStatesLat,
		&i.AdStatesLng,
		&i.AdCitiesID,
		&i.AdCitiesCity,
		&i.AdCitiesStatesID,
		&i.AdCitiesCreatedAt,
		&i.AdCitiesUpdatedAt,
		&i.AdCitiesLat,
		&i.AdCitiesLng,
		&i.AdCommunitiesID,
		&i.AdCommunitiesCommunity,
		&i.AdCommunitiesCitiesID,
		&i.AdCommunitiesCreatedAt,
		&i.AdCommunitiesUpdatedAt,
		&i.AdCommunitiesLat,
		&i.AdCommunitiesLng,
		&i.AdSubCommunitiesID,
		&i.AdSubCommunitiesSubCommunity,
		&i.AdSubCommunitiesCommunitiesID,
		&i.AdSubCommunitiesCreatedAt,
		&i.AdSubCommunitiesUpdatedAt,
		&i.AdSubCommunitiesLat,
		&i.AdSubCommunitiesLng,
	)
	return i, err
}

const getAddressByCountryId = `-- name: GetAddressByCountryId :one
SELECT id, countries_id, states_id, cities_id, communities_id, sub_communities_id, locations_id, created_at, updated_at, property_map_location_id, full_address, full_address_ar FROM addresses 
WHERE countries_id = $2 LIMIT $1
`

type GetAddressByCountryIdParams struct {
	Limit       int32       `json:"limit"`
	CountriesID pgtype.Int8 `json:"countries_id"`
}

func (q *Queries) GetAddressByCountryId(ctx context.Context, arg GetAddressByCountryIdParams) (Address, error) {
	row := q.db.QueryRow(ctx, getAddressByCountryId, arg.Limit, arg.CountriesID)
	var i Address
	err := row.Scan(
		&i.ID,
		&i.CountriesID,
		&i.StatesID,
		&i.CitiesID,
		&i.CommunitiesID,
		&i.SubCommunitiesID,
		&i.LocationsID,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.PropertyMapLocationID,
		&i.FullAddress,
		&i.FullAddressAr,
	)
	return i, err
}

const getAllAddress = `-- name: GetAllAddress :many
SELECT id, countries_id, states_id, cities_id, communities_id, sub_communities_id, locations_id, created_at, updated_at, property_map_location_id, full_address, full_address_ar FROM addresses
ORDER BY id
LIMIT $1
OFFSET $2
`

type GetAllAddressParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) GetAllAddress(ctx context.Context, arg GetAllAddressParams) ([]Address, error) {
	rows, err := q.db.Query(ctx, getAllAddress, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []Address
	for rows.Next() {
		var i Address
		if err := rows.Scan(
			&i.ID,
			&i.CountriesID,
			&i.StatesID,
			&i.CitiesID,
			&i.CommunitiesID,
			&i.SubCommunitiesID,
			&i.LocationsID,
			&i.CreatedAt,
			&i.UpdatedAt,
			&i.PropertyMapLocationID,
			&i.FullAddress,
			&i.FullAddressAr,
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

const getAllPropertyLocationsBySubCommunity = `-- name: GetAllPropertyLocationsBySubCommunity :many
SELECT id,property AS "label" FROM properties_map_location 
WHERE sub_communities_id=$1
`

type GetAllPropertyLocationsBySubCommunityRow struct {
	ID    int64  `json:"id"`
	Label string `json:"label"`
}

func (q *Queries) GetAllPropertyLocationsBySubCommunity(ctx context.Context, subCommunitiesID int64) ([]GetAllPropertyLocationsBySubCommunityRow, error) {
	rows, err := q.db.Query(ctx, getAllPropertyLocationsBySubCommunity, subCommunitiesID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAllPropertyLocationsBySubCommunityRow
	for rows.Next() {
		var i GetAllPropertyLocationsBySubCommunityRow
		if err := rows.Scan(&i.ID, &i.Label); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getCompleteAddress = `-- name: GetCompleteAddress :one
SELECT addresses.id, addresses.countries_id, addresses.states_id, addresses.cities_id, addresses.communities_id, addresses.sub_communities_id, addresses.locations_id, addresses.created_at, addresses.updated_at, addresses.property_map_location_id, addresses.full_address, addresses.full_address_ar, countries.country,states."state",cities.city,communities.community,sub_communities.sub_community,locations.lat,locations.lng
FROM addresses
LEFT JOIN countries ON countries.id = addresses.countries_id
LEFT JOIN states ON states.id = addresses.states_id
LEFT JOIN cities ON cities.id = addresses.cities_id
LEFT JOIN communities ON communities.id = addresses.communities_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
LEFT JOIN locations ON locations.id = addresses.locations_id
WHERE addresses.id = $1
`

type GetCompleteAddressRow struct {
	ID                    int64       `json:"id"`
	CountriesID           pgtype.Int8 `json:"countries_id"`
	StatesID              pgtype.Int8 `json:"states_id"`
	CitiesID              pgtype.Int8 `json:"cities_id"`
	CommunitiesID         pgtype.Int8 `json:"communities_id"`
	SubCommunitiesID      pgtype.Int8 `json:"sub_communities_id"`
	LocationsID           pgtype.Int8 `json:"locations_id"`
	CreatedAt             time.Time   `json:"created_at"`
	UpdatedAt             time.Time   `json:"updated_at"`
	PropertyMapLocationID pgtype.Int8 `json:"property_map_location_id"`
	FullAddress           pgtype.Text `json:"full_address"`
	FullAddressAr         pgtype.Text `json:"full_address_ar"`
	Country               pgtype.Text `json:"country"`
	State                 pgtype.Text `json:"state"`
	City                  pgtype.Text `json:"city"`
	Community             pgtype.Text `json:"community"`
	SubCommunity          pgtype.Text `json:"sub_community"`
	Lat                   pgtype.Text `json:"lat"`
	Lng                   pgtype.Text `json:"lng"`
}

func (q *Queries) GetCompleteAddress(ctx context.Context, id int64) (GetCompleteAddressRow, error) {
	row := q.db.QueryRow(ctx, getCompleteAddress, id)
	var i GetCompleteAddressRow
	err := row.Scan(
		&i.ID,
		&i.CountriesID,
		&i.StatesID,
		&i.CitiesID,
		&i.CommunitiesID,
		&i.SubCommunitiesID,
		&i.LocationsID,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.PropertyMapLocationID,
		&i.FullAddress,
		&i.FullAddressAr,
		&i.Country,
		&i.State,
		&i.City,
		&i.Community,
		&i.SubCommunity,
		&i.Lat,
		&i.Lng,
	)
	return i, err
}

const updateAddress = `-- name: UpdateAddress :one
UPDATE addresses
SET  countries_id=$2,
    states_id=$3,  
    cities_id=$4,
    communities_id=$5,
    sub_communities_id=$6,
    locations_id = $7 
Where id = $1
RETURNING id, countries_id, states_id, cities_id, communities_id, sub_communities_id, locations_id, created_at, updated_at, property_map_location_id, full_address, full_address_ar
`

type UpdateAddressParams struct {
	ID               int64       `json:"id"`
	CountriesID      pgtype.Int8 `json:"countries_id"`
	StatesID         pgtype.Int8 `json:"states_id"`
	CitiesID         pgtype.Int8 `json:"cities_id"`
	CommunitiesID    pgtype.Int8 `json:"communities_id"`
	SubCommunitiesID pgtype.Int8 `json:"sub_communities_id"`
	LocationsID      pgtype.Int8 `json:"locations_id"`
}

func (q *Queries) UpdateAddress(ctx context.Context, arg UpdateAddressParams) (Address, error) {
	row := q.db.QueryRow(ctx, updateAddress,
		arg.ID,
		arg.CountriesID,
		arg.StatesID,
		arg.CitiesID,
		arg.CommunitiesID,
		arg.SubCommunitiesID,
		arg.LocationsID,
	)
	var i Address
	err := row.Scan(
		&i.ID,
		&i.CountriesID,
		&i.StatesID,
		&i.CitiesID,
		&i.CommunitiesID,
		&i.SubCommunitiesID,
		&i.LocationsID,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.PropertyMapLocationID,
		&i.FullAddress,
		&i.FullAddressAr,
	)
	return i, err
}

const updateAddressBy = `-- name: UpdateAddressBy :one
UPDATE addresses
SET  countries_id=$2,
    states_id=$3,  
    cities_id=$4,
    communities_id=$5,
    sub_communities_id=$6,
    locations_id = $7 
Where id = $1
RETURNING id, countries_id, states_id, cities_id, communities_id, sub_communities_id, locations_id, created_at, updated_at, property_map_location_id, full_address, full_address_ar
`

type UpdateAddressByParams struct {
	ID               int64       `json:"id"`
	CountriesID      pgtype.Int8 `json:"countries_id"`
	StatesID         pgtype.Int8 `json:"states_id"`
	CitiesID         pgtype.Int8 `json:"cities_id"`
	CommunitiesID    pgtype.Int8 `json:"communities_id"`
	SubCommunitiesID pgtype.Int8 `json:"sub_communities_id"`
	LocationsID      pgtype.Int8 `json:"locations_id"`
}

func (q *Queries) UpdateAddressBy(ctx context.Context, arg UpdateAddressByParams) (Address, error) {
	row := q.db.QueryRow(ctx, updateAddressBy,
		arg.ID,
		arg.CountriesID,
		arg.StatesID,
		arg.CitiesID,
		arg.CommunitiesID,
		arg.SubCommunitiesID,
		arg.LocationsID,
	)
	var i Address
	err := row.Scan(
		&i.ID,
		&i.CountriesID,
		&i.StatesID,
		&i.CitiesID,
		&i.CommunitiesID,
		&i.SubCommunitiesID,
		&i.LocationsID,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.PropertyMapLocationID,
		&i.FullAddress,
		&i.FullAddressAr,
	)
	return i, err
}

const updateSubCommunityInAddress = `-- name: UpdateSubCommunityInAddress :one
UPDATE addresses
SET sub_communities_id=$2, locations_id = $3
Where id = $1
RETURNING id, countries_id, states_id, cities_id, communities_id, sub_communities_id, locations_id, created_at, updated_at, property_map_location_id, full_address, full_address_ar
`

type UpdateSubCommunityInAddressParams struct {
	ID               int64       `json:"id"`
	SubCommunitiesID pgtype.Int8 `json:"sub_communities_id"`
	LocationsID      pgtype.Int8 `json:"locations_id"`
}

func (q *Queries) UpdateSubCommunityInAddress(ctx context.Context, arg UpdateSubCommunityInAddressParams) (Address, error) {
	row := q.db.QueryRow(ctx, updateSubCommunityInAddress, arg.ID, arg.SubCommunitiesID, arg.LocationsID)
	var i Address
	err := row.Scan(
		&i.ID,
		&i.CountriesID,
		&i.StatesID,
		&i.CitiesID,
		&i.CommunitiesID,
		&i.SubCommunitiesID,
		&i.LocationsID,
		&i.CreatedAt,
		&i.UpdatedAt,
		&i.PropertyMapLocationID,
		&i.FullAddress,
		&i.FullAddressAr,
	)
	return i, err
}

const updateXMLAddress = `-- name: UpdateXMLAddress :exec
UPDATE addresses
SET  countries_id=$2,  
states_id = $3,
    cities_id=$4,
    communities_id=$5,
    sub_communities_id=$6,
    locations_id = $7
Where id = $1
`

type UpdateXMLAddressParams struct {
	ID               int64       `json:"id"`
	CountriesID      pgtype.Int8 `json:"countries_id"`
	StatesID         pgtype.Int8 `json:"states_id"`
	CitiesID         pgtype.Int8 `json:"cities_id"`
	CommunitiesID    pgtype.Int8 `json:"communities_id"`
	SubCommunitiesID pgtype.Int8 `json:"sub_communities_id"`
	LocationsID      pgtype.Int8 `json:"locations_id"`
}

func (q *Queries) UpdateXMLAddress(ctx context.Context, arg UpdateXMLAddressParams) error {
	_, err := q.db.Exec(ctx, updateXMLAddress,
		arg.ID,
		arg.CountriesID,
		arg.StatesID,
		arg.CitiesID,
		arg.CommunitiesID,
		arg.SubCommunitiesID,
		arg.LocationsID,
	)
	return err
}
