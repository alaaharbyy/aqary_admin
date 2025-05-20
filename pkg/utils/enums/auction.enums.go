package enums

import "fmt"

// AuctionCategory represent the type for auction_category => On-Site/Online
type AuctionCategory int64

// Enum vlues for AuctionCategory
const (
	OnSiteAuctionCategory AuctionCategory = iota + 1
	OnlineAuctionCategory
)

// auctionCategorytring maps AuctionCategory values to their string representations
var auctionCategoryString = map[AuctionCategory]string{
	OnSiteAuctionCategory: "On-Site",
	OnlineAuctionCategory: "Online",
}

// auctionCategoryValues maps string representations to their AuctionCategory values
var auctionCategoryValues = map[string]AuctionCategory{
	"On-Site": OnSiteAuctionCategory,
	"Online":  OnlineAuctionCategory,
}

// String returns the string representation of the AuctionCategory
func (ac AuctionCategory) String() string {
	return auctionCategoryString[ac]
}

// ParsePlanTitle converts a string to a AuctionCategory value
func ParseAuctionCategory(s string) (AuctionCategory, error) {
	ac, ok := auctionCategoryValues[s]
	if !ok {
		return 0, fmt.Errorf("invalid auction category: %s", s)
	}
	return ac, nil
}

// ------------------------------------------------------------------------------

// AuctionType represent the type for auction_type => local/international
type AuctionType int64

const (
	LocalAuction AuctionType = iota + 1
	InternationalAuction
)

var auctionTypeString = map[AuctionType]string{
	LocalAuction:         "local",
	InternationalAuction: "international",
}
var auctionTypeValues = map[string]AuctionType{
	"local":         LocalAuction,
	"international": InternationalAuction,
}

func (at AuctionType) String() string {
	return auctionTypeString[at]
}
func ParseAuctionType(s string) (AuctionType, error) {
	at, ok := auctionTypeValues[s]
	if !ok {
		return 0, fmt.Errorf("invalid auction type: %s", s)
	}
	return at, nil
}

// ------------------------------------------------------------------------------

// AuctionStatus represents the type for auction status => Draft/Live/Published/Ended/Cancelled/Deleted
type AuctionStatus int64

// Enum values for AuctionStatus
const (
	DraftAuctionStatus AuctionStatus = iota + 1
	LiveAuctionStatus
	PublishedAuctionStatus
	EndedAuctionStatus
	CancelledAuctionStatus
	DeletedAuctionStatus
)

// auctionStatusString maps AuctionStatus values to their string representations
var auctionStatusString = map[AuctionStatus]string{
	DraftAuctionStatus:     "Draft",
	LiveAuctionStatus:      "Live",
	PublishedAuctionStatus: "Published",
	EndedAuctionStatus:     "Ended",
	CancelledAuctionStatus: "Cancelled",
	DeletedAuctionStatus:   "Deleted",
}

// auctionStatusValues maps string representations to their AuctionStatus values
var auctionStatusValues = map[string]AuctionStatus{
	"Draft":     DraftAuctionStatus,
	"Live":      LiveAuctionStatus,
	"Published": PublishedAuctionStatus,
	"Ended":     EndedAuctionStatus,
	"Cancelled": CancelledAuctionStatus,
	"Deleted":   DeletedAuctionStatus,
}

// String returns the string representation of the AuctionStatus
func (as AuctionStatus) String() string {
	return auctionStatusString[as]
}

// ParsePlanTitle converts a string to a AuctionStatus value
func ParseAuctionStatus(s string) (AuctionStatus, error) {
	p, ok := auctionStatusValues[s]
	if !ok {
		return 0, fmt.Errorf("invalid auction status: %s", s)
	}
	return p, nil
}

// ------------------------------------------------------------------------------

// AuctionPropertyType represents the type for auction property_type => Residential/Commercial/Agriculture/Industrial
// Value of AuctionPropertyType will store in auctions.property_categories column
type AuctionPropertyType int64

const (
	Residential AuctionPropertyType = iota + 1
	Commercial
	Agriculture
	Industrial
)

// auctionPropertyTypeString maps AuctionPropertyType values to their string representations
var auctionPropertyTypeString = map[AuctionPropertyType]string{
	Residential: "Residential",
	Commercial:  "Commercial",
	Agriculture: "Agriculture",
	Industrial:  "Industrial",
}

// auctionPropertyTypeValues maps string representations to their AuctionPropertyType values
var auctionPropertyTypeValues = map[string]AuctionPropertyType{
	"Residential": Residential,
	"Commercial":  Commercial,
	"Agriculture": Agriculture,
	"Industrial":  Industrial,
}

// String returns the string representation of the AuctionPropertyType
func (apt AuctionPropertyType) String() string {
	return auctionPropertyTypeString[apt]
}

// ParseAuctionPropertyType converts a string to a AuctionPropertyType value
func ParseAuctionPropertyType(s string) (AuctionPropertyType, error) {
	apt, ok := auctionPropertyTypeValues[s]
	if !ok {
		return 0, fmt.Errorf("invalid auction property type: %s", s)
	}
	return apt, nil
}

// ------------------------------------------------------------------------------

// Ownership represents the type for auction ownership
type Ownership int64

// Enum values for Ownerships
const (
	FreeholdOwnerships Ownership = iota + 1
	GCCOwnerships
	LocalOwnerships
	LeaseholdOwnerships
	USUFRUCTOwnerships
	FreezoneOwnerships
	OthersOwnerships
)

// auctionOwnershipString maps Ownerships values to their string representations
var auctionOwnershipString = map[Ownership]string{
	FreeholdOwnerships:  "Freehold",
	GCCOwnerships:       "GCC",
	LocalOwnerships:     "Local",
	LeaseholdOwnerships: "Leasehold",
	USUFRUCTOwnerships:  "USUFRUCT",
	FreezoneOwnerships:  "Freezone",
	OthersOwnerships:    "Others",
}

// auctionOwnershipValues maps string representations to their Ownership values
var auctionOwnershipValues = map[string]Ownership{
	"Freehold":  FreeholdOwnerships,
	"GCC":       GCCOwnerships,
	"Local":     LocalOwnerships,
	"Leasehold": LeaseholdOwnerships,
	"USUFRUCT":  USUFRUCTOwnerships,
	"Freezone":  FreezoneOwnerships,
	"Others":    OthersOwnerships,
}

// String returns the string representation of the Ownership
func (as Ownership) String() string {
	return auctionOwnershipString[as]
}

// ParsePlanTitle converts a string to a Ownership value
func ParseAuctionOwnership(s string) (Ownership, error) {
	ao, ok := auctionOwnershipValues[s]
	if !ok {
		return 0, fmt.Errorf("invalid auction status: %s", s)
	}
	return ao, nil
}

// SelectType represents the type of property selected of auction
type SelectType int64

const (
	PropertySelectType SelectType = 1
	UnitSelectType     SelectType = 2
)

var selectTypeString = map[SelectType]string{
	PropertySelectType: "Property",
	UnitSelectType:     "Units",
}
var selectTypeValues = map[string]SelectType{
	"Property": PropertySelectType,
	"Units":    UnitSelectType,
}

func (st SelectType) String() string {
	return selectTypeString[st]
}
func ParseSelectType(s string) (SelectType, error) {
	st, ok := selectTypeValues[s]
	if !ok {
		return 0, fmt.Errorf("invalid select type: %s", s)
	}
	return st, nil
}
