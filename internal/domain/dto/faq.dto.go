package dto

import (
	"time"
)

type CreateFaqRequest struct {
	Question string `json:"question" valid:"required"`
	Answer   string `json:"answer" valid:"required"`
}

type Faq struct {
	ID        int64     `json:"Id"`
	RefNo     string    `json:"refNo"`
	Question  string    `json:"question"`
	Answer    string    `json:"answer"`
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
	DeletedAt time.Time `json:"deletedAt,omitempty"`
}

type UpdateFaqRequest struct {
	Question string `json:"question" valid:"required"`
	Answer   string `json:"answer" valid:"required"`
}

type ListFAQsResponse struct {
	FAQs       []Faq      `json:"faqs"`
	Pagination Pagination `json:"pagination"`
}

type RestoreFaqRequest struct {
	FaqId int64 `json:"faqId" valid:"required"`
}
