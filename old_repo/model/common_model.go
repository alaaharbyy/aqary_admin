package model

import (
	"mime/multipart"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

type CreateLocationRequest struct {
	Lat string `json:"lat"`
	Lng string `json:"lng"`
}

type CreateCountryRequest struct {
	Country string                `form:"country"`
	Flag    *multipart.FileHeader `form:"flag"`
}

type CreateSubCommunityRequest struct {
	SubCommunity string `json:"subcommunity" binding:"required"`
	CommunityId  int64  `json:"community_id"`
}

type CreateStateRequest struct {
	State     string `json:"state" binding:"required"`
	CountryId int64  `json:"country_id"`
}

type CreateCityRequest struct {
	City    string `json:"city" binding:"required"`
	StateId int64  `json:"state_id"`
}

type CreateCommunityRequest struct {
	Community string `json:"community" binding:"required"`
	CitiesId  int64  `json:"city_id"`
}

type CreateLanguageRequest struct {
	Language string `form:"language"`
	Code     string `form:"code"`
}

type UpdateCountryRequest struct {
	Country string `form:"country"`
	// Flag    *multipart.FileHeader `form:"flag"`
	CountryCode int64  `form:"country_code"`
	Alpha2Code  string `form:"alpha2_code"`
	Alpha3Code  string `form:"alpha3_code"`
}

type UpdateStateRequest struct {
	State     string `json:"state"`
	CountryId int64  `json:"country_id"`
}

type UpdateCityRequest struct {
	City    string `json:"city"`
	StateId int64  `json:"state_id"`
}

type UpdateCommunityRequest struct {
	Community string `json:"community"`
	CitiesId  int64  `json:"city_id"`
}

type UpdateSubCommunityRequest struct {
	SubCommunity string `json:"subcommunity"`
	CommunityId  int64  `json:"community_id"`
}

type Department struct {
	ID    int64
	Title string
}

type Currency struct {
	ID           int64
	Currency     string
	Code         string
	Flag         string
	CurrencyRate float64
}

type PropertyType struct {
	ID            int64          `json:"id"`
	Title         string         `json:"label"`
	IsResidential bool           `json:"is_residential"`
	IsCommercial  bool           `json:"is_commercial"`
	Facts         []CustomFormat `json:"facts"` // []CustomFormat
	Category      string         `json:"category"`
}
type Facility struct {
	ID       int64  `json:"id"`
	Title    string `json:"label"`
	TitleAr  string `json:"label_ar"`
	Icon     string `json:"icon"`
	Category string `json:"category"`
}
type Amenity struct {
	ID       int64  `json:"id"`
	Title    string `json:"label"`
	TitleAr  string `json:"label_ar"`
	Icon     string `json:"icon"`
	Category string `json:"category"`
}

type PropertRank struct {
	ID     int64  `json:"id"`
	Rank   string `json:"rank"`
	Price  int64  `json:"price"`
	Status int64  `json:"status"`
}

type CustomFormat struct {
	ID     int64  `json:"id"`
	Name   string `json:"label"`
	NameAr string `json:"label_ar,omitempty"`
}

type CustomUserFormat struct {
	ID           int64  `json:"id"`
	Name         string `json:"label"`
	EntityTypeID int64  `json:"entity_type_id"`
}

type ReferenceAgent struct {
	AgentID        int64     `json:"agent_id"`
	AgentName      string    `json:"agent_name"`
	Note           string    `json:"note"`
	AssignmentDate time.Time `json:"assignment_date"`
}

type facts_unit_type struct {
	Id    int64  `json:"id,omitempty"`
	Icon  string `json:"icon,omitempty"`
	Slug  string `json:"slug,omitempty"`
	Title string `json:"title,omitempty"`
}

type Facts_unit_type_format struct {
	SaleFacts []facts_unit_type `json:"sale,omitempty"`
	RentFacts []facts_unit_type `json:"rent,omitempty"`
}

type GlobalPropertyType struct {
	ID                int64                         `json:"id"`
	Type              string                        `json:"type"`
	Code              string                        `json:"code"`
	PropertyTypeFacts map[string][]PropertyTypeFact `json:"property_type_facts"`
	Usage             int64                         `json:"usage"`
	CreatedAt         time.Time                     `json:"created_at"`
	UpdatedAt         time.Time                     `json:"updated_at"`
	Status            int64                         `json:"status"`
	Icon              pgtype.Text                   `json:"icon"`
	IsProject         pgtype.Bool                   `json:"is_project"`
	TypeAr            pgtype.Text                   `json:"type_ar"`
}

type PropertyTypeFact struct {
	ID     int64   `json:"id"`
	Title  *string `json:"title,omitempty"`
	Status *int    `json:"status,omitempty"`
	Icon   *string `json:"icon,omitempty"`
}

type DocCategory struct {
	ID       int64  `json:"id"`
	Category string `json:"label"`
}

type DocSubCategory struct {
	ID          int64  `json:"id"`
	SubCategory string `json:"label"`
	CategoryID  int64  `json:"category_id"`
}

type UnitType struct {
	ID            int64        `json:"id"`
	Description   pgtype.Text  `json:"description"`
	DescriptionAr pgtype.Text  `json:"description_ar"`
	ImageUrl      []string     `json:"image_url"`
	MinArea       float64      `json:"min_area"`
	MaxArea       float64      `json:"max_area"`
	MinPrice      float64      `json:"min_price"`
	MaxPrice      float64      `json:"max_price"`
	Parking       int64        `json:"parking"`
	Balcony       int64        `json:"balcony"`
	PropertiesID  int64        `json:"properties_id"`
	Property      int64        `json:"key"`
	PropertyType  PropertyType `json:"property_type"`
	Title         string       `json:"title"`
	Bedrooms      pgtype.Text  `json:"bedrooms"`
	IsBranch      bool         `json:"is_branch"`
}

type UnitTypes struct {
	ID     int64  `json:"id"`
	Type   string `json:"type"`
	TypeAr string `json:"type_ar"`
}
