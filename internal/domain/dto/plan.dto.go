package dto

import "time"

type Plan struct {
	ID        int64     `json:"id"`
	AuctionID int64     `json:"auctionId"`
	PlanTitle string    `json:"planTitle"`
	PlanUrls  []string  `json:"planUrls"`
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
}

type CreatePlanRequest struct {
	AuctionID int64    `json:"auctionId" valid:"required"`
	PlanTitle int64    `json:"planTitle" valid:"required"`
	PlanUrls  []string `json:"planUrls" valid:"required"`
}

// AddDocInPlanReq type to parse request body to attach(add) plan-document in plan
type AddDocInPlanReq struct {
	PlanID          int64  `json:"planId" valid:"required"`
	PlanDocumentUrl string `json:"planDocumentUrl" valid:"required"`
}

// RemoveDocFromPlanReq type to parse request body to detach(remove) plan-document from plan
type RemoveDocFromPlanReq struct {
	PlanID          int64  `json:"planId" valid:"required"`
	PlanDocumentUrl string `json:"planDocumentUrl" valid:"required"`
}

type ListPlansResponse struct {
	Plans      []Plan     `json:"plans"`
	Pagination Pagination `json:"pagination"`
}
