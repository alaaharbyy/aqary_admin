package dto

import (
	"time"
)

type Address struct {
	ID           int64   `json:"Id" valid:"positive,optional"`
	Country      int64   `json:"country" valid:"required,positive"`
	State        int64   `json:"state" valid:"required,positive"`
	City         int64   `json:"city" valid:"required,positive"`
	Community    int64   `json:"community" valid:"optional,positive"`
	SubCommunity int64   `json:"subCommunity" valid:"optional,positive"`
	LocationURL  string  `json:"locationUrl" valid:"required,url"`
	Lat          float64 `json:"lat" valid:"-"`
	Lng          float64 `json:"lng" valid:"-"`
}

type TenentContract struct {
	ContractStartDate time.Time `json:"contractStartDate" valid:"required"`
	ContractEndDate   time.Time `json:"contractEndDate" valid:"required"`
	Amount            float64   `json:"amount" valid:"required,positive"`
}

type AuctionPropertyInfo struct {
	PropertyUnitId      int64           `json:"propertyUnitId" valid:"optional,positive"` //propertyId OR unitId
	SelectType          int64           `json:"selectType" valid:"required"`              //Property , Unit
	IsExistingProperty  bool            `json:"isExistingProperty" valid:"-"`
	PropertyType        int64           `json:"propertyType" valid:"required,positive"`
	PropertyUsage       int64           `json:"propertyUsage" valid:"required,positive"`
	PropertyName        string          `json:"propertyName" valid:"required,alphaNumSpecial"`
	SectorNo            string          `json:"sectorNo" valid:"required,alphaNumSpecial"`
	PlotNo              string          `json:"plotNo" valid:"required,alphaNumSpecial"`
	PlotAreaInSqFt      float64         `json:"plotAreaInSqFt" valid:"required,positive"`
	BuiltUpAreaInSqFt   float64         `json:"builtUpAreaInSqFt" valid:"optional,positive"`
	ViewsID             []int64         `json:"viewsID" valid:"optional,positiveNonEmptySlice"`
	Furnished           int64           `json:"furnished" valid:"required,positive"`
	NoOfFloors          int64           `json:"noOfFloors" valid:"required,positive"`
	NoOfUnits           int64           `json:"noOfUnits" valid:"required,positive"`
	NoOfParking         int64           `json:"noOfParking" valid:"optional,positive"`
	NoOfRetailCenters   int64           `json:"noOfRetailCenters" valid:"optional,positive"`
	NoOfElevators       int64           `json:"noOfElevators" valid:"optional,positive"`
	NoOfPools           int64           `json:"noOfPools" valid:"optional,positive"`
	Ownership           int64           `json:"ownership" valid:"required,positive"`
	IsLuxury            bool            `json:"isLuxury" valid:"-"`
	HasTenants          bool            `json:"hasTenants" valid:"-"`
	TenentContract      *TenentContract `json:"tenentContract" valid:"optional"`
	PropertyTitle       string          `json:"propertyTitle" valid:"-"`
	PropertyTitleArabic string          `json:"propertyTitleArabic" valid:"-"`
	Description         string          `json:"description" valid:"required"`
	DescriptionAr       string          `json:"descriptionAr" valid:"required"`
	PropertyLocation    *Address        `json:"propertyLocation" valid:"required"`
	Amenities           []int64         `json:"amenities" valid:"optional,positiveNonEmptySlice"`
	Facilities          []int64         `json:"facilities" valid:"optional,positiveNonEmptySlice"`
}

type AuctionInputsDto struct {
	AuctionCategory    int64                `json:"auctionCategory" valid:"required,positive"`
	AuctionTitle       string               `json:"auctionTitle" valid:"required"`
	AuctionUrl         string               `json:"auctionUrl" valid:"required,url"`
	StartDate          time.Time            `json:"startDate" valid:"required"`
	EndDate            time.Time            `json:"endDate" valid:"required"`
	MinBidAmount       float64              `json:"minBidAmount" valid:"required,positive"`
	MinIncrementAmount float64              `json:"minIncrementAmount" valid:"required,positive"`
	WinningBidAmount   float64              `json:"winningBidAmount" valid:"optional,positive"`
	PrebidStartDate    time.Time            `json:"prebidStartDate" valid:"-"`
	Tags               []int64              `json:"tags" valid:"optional,positiveNonEmptySlice"`
	AuctionLocation    *Address             `json:"auctionLocation" valid:"required"`
	PropertyInfo       *AuctionPropertyInfo `json:"propertyInfo" valid:"required"`
	CompaniesId        int64                `json:"companiesId" valid:"required"` //TODO: in future companyId should fetch from loginToken
	MobileNumber       string               `json:"mobileNumber" valid:"phone,optional"`
	EmailAddress       string               `json:"email" valid:"email,optional"`
	Whatsapp           string               `json:"whatsapp" valid:"phone,optional"`
}

type AuctionViewDetails struct {
	ID                 int64                `json:"id"`
	RefNo              string               `json:"refNo"`
	AuctionCategory    int64                `json:"auctionCategory"`
	AuctionTitle       string               `json:"auctionTitle"`
	AuctionUrl         string               `json:"auctionUrl"`
	StartDate          time.Time            `json:"startDate"`
	EndDate            time.Time            `json:"endDate"`
	MinBidAmount       float64              `json:"minBidAmount"`
	MinIncrementAmount float64              `json:"minIncrementAmount"`
	WinningBidAmount   float64              `json:"winningBidAmount"`
	PrebidStartDate    time.Time            `json:"prebidStartDate"`
	QualityScore       float64              `json:"qualityScore"`
	Tags               []int64              `json:"tags"`
	AuctionLocation    *Address             `json:"auctionLocation"`
	PropertyInfo       *AuctionPropertyInfo `json:"propertyInfo"`
	CompaniesId        int64                `json:"companiesId"`
	NoOfBidders        int64                `json:"noOfBidders"`
	Subscription       string               `json:"subscription"`
	MobileNumber       string               `json:"mobileNumber"`
	EmailAddress       string               `json:"email"`
	Whatsapp           string               `json:"whatsapp"`
	AuctionStatus      int64                `json:"auctionStatus"`
	CreatedAt          time.Time            `json:"createdAt"`
	UpdatedAt          time.Time            `json:"updatedAt"`
}

// AuctionListAttributes attributes in auctions list
type AuctionListAttributes struct {
	ID                  int64     `json:"id"`
	RefNo               string    `json:"refNo"`
	AuctionPropertyType string    `json:"auctionPropertyType"` // property category
	VerifyStatus        bool      `json:"verifyStatus"`
	PropertyName        string    `json:"propertyName"`
	Status              string    `json:"status"`
	AuctionCategory     string    `json:"auctionCategory"` //online/on-site
	AuctionType         string    `json:"auctionType"`     // local/international .....
	MinBidAmount        float64   `json:"minBidAmount"`
	WinningBidAmount    float64   `json:"winningBidAmount"`
	QualityScore        float64   `json:"qualityScore"`
	NoOfBidders         int64     `json:"noOfBidders"`
	Subscription        string    `json:"subscription"`
	StartDate           time.Time `json:"startDate"`
	EndDate             time.Time `json:"endDate"`
	PreBidStartDate     time.Time `json:"preBidStartDate"`
	Description         string    `json:"description"`
	DescriptionAr       string    `json:"descriptionAr"`
	CreatedAt           time.Time `json:"createdAt"`
	UpdatedAt           time.Time `json:"updatedAt"`
}

type ListAuctionResponse struct {
	Auctions   []AuctionListAttributes `json:"auctions"`
	Pagination Pagination              `json:"pagination"`
}

type RestoreAuction struct {
	AuctionID int64 `json:"auctionId" valid:"required"`
}
