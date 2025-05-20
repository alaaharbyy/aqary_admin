package dto

import "time"

type CreatePartnerRequest struct {
	AuctionId   int64  `json:"auctionId" valid:"required"`
	PartnerName string `json:"partnerName" valid:"required"`
	PartnerLogo string `json:"partnerLogo" valid:"required"`
	Website     string `json:"website" valid:"-"`
}

type Partner struct {
	ID          int64     `json:"id"`
	RefNo       string    `json:"refNo"`
	AuctionID   int64     `json:"auctionId"`
	PartnerName string    `json:"partnerName"`
	PartnerLogo string    `json:"partnerLogo"`
	Website     string    `json:"website"`
	CreatedAt   time.Time `json:"createdAt"`
	UpdatedAt   time.Time `json:"updatedAt"`
	DeletedAt   time.Time `json:"deletedAt,omitempty"`
}

type UpdatePartnerRequest struct {
	PartnerName string `json:"partnerName" valid:"required"`
	PartnerLogo string `json:"partnerLogo" valid:"required"`
	Website     string `json:"website" valid:"-"`
}

type ListPartnersResponse struct {
	Partners   []Partner  `json:"partner"`
	Pagination Pagination `json:"pagination"`
}

type RestorePartnerRequest struct {
	PartnerID int64 `json:"partnerId" valid:"required"`
}
