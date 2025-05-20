package dto

import "time"

type Document struct {
	ID           int64     `json:"id"`
	AuctionID    int64     `json:"auctionId"`
	DocumentType string    `json:"documentType"`
	DocumentUrls []string  `json:"documentUrl"`
	CreatedAt    time.Time `json:"createdAt"`
	UpdatedAt    time.Time `json:"updatedAt"`
}

type CreateDocumentRequest struct {
	AuctionID    int64    `json:"auctionId" valid:"required"`
	DocumentType int64    `json:"documentType" valid:"required"`
	DocumentUrls []string `json:"documentUrl" valid:"required"`
}

// AddInDocumentUrls type to parse request body to attach(add) document in documentUrls
type AddInDocumentUrlsRequest struct {
	DocumentID  int64  `json:"documentId" valid:"required"`
	DocumentUrl string `json:"DocumentUrl" valid:"required"`
}

// RemoveFromDocumentUrls type to parse request body to detach(remove) document from documentUrls
type RemoveFromDocumentUrlsRequest struct {
	DocumentID  int64  `json:"documentId" valid:"required"`
	DocumentUrl string `json:"DocumentUrl" valid:"required"`
}

type ListDocumentsResponse struct {
	Documents  []Document `json:"documents"`
	Pagination Pagination `json:"pagination"`
}
