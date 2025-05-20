package dto

import (
	"aqary_admin/pkg/utils/enums"
	"time"
)

type ChangesInput struct {
	FieldName string
	Before    string
	After     string
}

type TransactionalActivityInputs struct {
	AuctionId    int64
	Activity     string
	UserId       int64
	Changes      []ChangesInput
	ActivityDate time.Time
}

type PortalViewActivityInputs struct {
	AuctionId    int64
	PortalUrl    string
	Activity     string
	UserId       int64
	ActivityDate time.Time
}

type FileViewActivityInputs struct {
	AuctionId    int64
	FileUrl      string
	FileCategory enums.FileCategory
	Activity     string
	UserId       int64
	ActivityDate time.Time
}

type Activity struct {
	ID           int64     `json:"id"`
	AuctionID    int64     `json:"auctionId"`
	ActivityType string    `json:"activityType"`
	FileCategory string    `json:"fileCategory"`
	FileUrl      string    `json:"fileUrl"`
	PortalUrl    string    `json:"portalUrl"`
	Activity     string    `json:"activity"`
	UserID       int64     `json:"userId"`
	CompanyName  string    `json:"companyName"`
	ActivityDate time.Time `json:"activityDate"`
	CreatedAt    time.Time `json:"createdAt"`
	UpdatedAt    time.Time `json:"updatedAt"`
}

type ActivityChange struct {
	ID           int64     `json:"id"`
	SectionID    int64     `json:"sectionId"`
	ActivitiesID int64     `json:"activitiesId"`
	FieldName    string    `json:"fieldName"`
	Before       string    `json:"before"`
	After        string    `json:"after"`
	ActivityDate time.Time `json:"activityDate"`
	CreatedAt    time.Time `json:"createdAt"`
	UpdatedAt    time.Time `json:"updatedAt"`
}

type ListActivitiesResp struct {
	Activities []Activity `json:"activities"`
	Pagination Pagination `json:"pagination"`
}

type GetActivityChangesResp struct {
	ActivityChanges []ActivityChange `json:"activityChanges"`
	Pagination      Pagination       `json:"pagination"`
}
