package dto

import "time"

type Media struct {
	ID          int64     `json:"id"`
	AuctionID   int64     `json:"auctionId"`
	GalleryType string    `json:"galleryType"`
	MediaType   string    `json:"mediaType"`
	MediaUrls   []string  `json:"mediaUrls"`
	CreatedAt   time.Time `json:"createdAt"`
	UpdatedAt   time.Time `json:"updatedAt"`
	DeletedAt   time.Time `json:"deletedAt"`
}

type CreateMediaRequest struct {
	Auction     int64    `json:"auctionId" valid:"required"`
	GalleryType int64    `json:"galleryType" valid:"required"`
	MediaType   int64    `json:"mediaType" valid:"required"`
	MediaUrls   []string `json:"mediaUrls" valid:"required"`
}

type AddInMediaUrlsRequest struct {
	MediaId   int64    `json:"mediaId" valid:"required"`
	MediaUrl   string `json:"mediaUrl" valid:"required"`
}

type RemoveFromMediaUrlsRequest struct {
	MediaId   int64    `json:"mediaId" valid:"required"`
	MediaUrl   string `json:"mediaUrl" valid:"required"`
}

type ListMediaResponse struct {
	MediaList  []Media    `json:"media"`
	Pagination Pagination `json:"pagination"`
}
