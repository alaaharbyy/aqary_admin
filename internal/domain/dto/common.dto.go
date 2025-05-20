package dto

type Pagination struct {
	Page        int32 `json:"page"`
	Limit       int32 `json:"limit"`
	TotalRecord int64 `json:"totalRecord"`
}

type ListParams struct {
	Page   int32
	Limit  int32
	Search string //may or may not present
}