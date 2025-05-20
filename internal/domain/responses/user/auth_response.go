package response

import "aqary_admin/old_repo/model"

type DashboardResult struct {
	UserID              int64                `json:"user_id"`
	FirstName           string               `json:"first_name"`
	LastName            string               `json:"last_name"`
	Token               string               `json:"token"`
	Email               string               `json:"email"`
	UserName            string               `json:"username"`
	ProfilePicture      string               `json:"profile_picture"`
	CountryCode         int64                `json:"country_code"`
	PhoneNumber         string               `json:"phone_number"`
	HaveCompany         bool                 `json:"have_company"`
	IsCompanyVerified   bool                 `json:"is_company_verified"`
	UserType            int64                `json:"user_types_id"`
	SectionPermission   any                  `json:"section_permissions"`
	ActiveCompany       int64                `json:"active_company"`
	AssociatedCompanies []model.CustomFormat `json:"associated_companies"`
	Gender              int64                `json:"gender"`
	Nationality         int64                `json:"nationality"`
}

type SignUpResponse struct {
	EmailSecretKey string `json:"email_secret_key"`
}

type AppleResponseTest struct {
	UserID string `json:"user_id"`
	Email  string `json:"email"`
}
