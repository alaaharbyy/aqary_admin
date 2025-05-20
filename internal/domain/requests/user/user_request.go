package domain

import "time"

type UserTypeRequest struct {
	Type   string `json:"user_type"`
	TypeAr string `json:"user_type_ar"`
}

type CreateProfileRequest struct {
	FirstName       string  `json:"first_name"`
	LastName        string  `json:"last_name"`
	AddressID       int64   `json:"addresses_id"`
	Email           string  `json:"email"`
	ProfileImageUrl string  `json:"profile_image_url"`
	PhoneNumber     string  `json:"phone_number"`
	CompanyNumber   string  `json:"company_number"`
	WhatsappNumber  string  `json:"whatsapp_number"`
	Gender          int64   `json:"gender"`
	LanguageIDs     []int64 `json:"all_languages_id"`
}

type UpdateProfileRequest struct {
	//company stuff
	FacebookUrl string `form:"facebook_url"`
	TwitterUrl  string `form:"twitter_url"`
	LinkedInUrl string `form:"linkedin_url"`
	// WebsiteUrl    string `form:"website_url"`
	// CompanyNumber string `form:"company_number"`

	AboutMe         string    `form:"about_me"`
	Language        []int64   `form:"language[]"`
	Nationality     []int64   `form:"nationality[]"`
	ExperienceSince time.Time `form:"experience_since"`
}

type UpdateProfilePasswordRequest struct {
	CurrentPassword string `form:"current_password" binding:"required"`
	NewPassword     string `form:"new_password" binding:"required"`
}

type GetOrganizationReq struct {
	CompanyID int64 `form:"company_id" binding:"required"`
}

// type GetAllUserRequest struct {
// 	PageSize int32 `form:"page_size" binding:"required,min=1"`
// 	PageNo   int32 `form:"page_no" binding:"required,min=1"`
// }

type GetAllOtherUserByCountryRequest struct {
	PageSize int32 `form:"page_size" binding:"required"`
	PageNo   int32 `form:"page_no" binding:"required"`
	Country  int64 `form:"country_id"  binding:"required"`
}

type ResetPasswordWithoutOldPasswordForCompanyAdminRequest struct {
	Id              int64  `form:"user_id" binding:"required"`
	NewPassword     string `form:"new_password" binding:"required"`
	ConfirmPassword string `form:"confirm_password" binding:"required"`
}

type AddCompanyAdminPermissionRequest struct {
	CompanyType int64   `form:"company_type" binding:"required"`
	Id          int64   `form:"company_id" binding:"required"`
	IsBranch    bool    `form:"is_branch"`
	Permissions []int64 `form:"permissions_id[]" binding:"required"`
}

type CheckEmailRequest struct {
	Email string `form:"email" binding:"required"`
}

type CheckMobileRequest struct {
	Phone       string `form:"phone" binding:"required"`
	CountryCode int64  `form:"country_code" binding:"required"`
}

type CheckUsernameRequest struct {
	Username string `form:"username" binding:"required"`
}

type GetAllUserRequest struct {
	PageSize int32  `form:"page_size" binding:"required,min=1"`
	PageNo   int32  `form:"page_no" binding:"required,min=1"`
	Search   string `form:"search"`
}

type GetAllUserByCountryRequest struct {
	PageSize int32 `form:"page_size" binding:"required,min=1"`
	PageNo   int32 `form:"page_no" binding:"required,min=1"`
	Country  int64 `form:"country_id" binding:"required"`
}

type UpdateUserRequest struct {
	CompanyID    int64  `form:"company_id"`
	FirstName    string `form:"first_name"`
	LastName     string `form:"last_name"`
	Email        string `form:"email"`
	Phone        string `form:"phone_number"`
	Department   int64  `form:"department"`
	Role         int64  `form:"roles_id"`
	Country      int64  `form:"country"`
	State        int64  `form:"state"`
	City         int64  `form:"city"`
	Community    int64  `form:"community"`
	SubCommunity int64  `form:"sub_community"`
	Permissions  string `form:"permissions"`
	Username     string `form:"username"`
}

type AllDeletedUserRequests struct {
	PageSize int32  `form:"page_size" binding:"required,min=1"`
	PageNo   int32  `form:"page_no" binding:"required,min=1"`
	Search   string `form:"search"`
}

type CreateDepartmentRequest struct {
	Title       string `form:"title"`
	ArabicTitle string `form:"title_ar"`
	CompanyID   int64  `form:"company_id"`
}

type GetDepartmentRequest struct {
	Id        int64 `form:"id"`
	CompanyID int64 `form:"company_id"`
}
type GetAllDepartmentRequest struct {
	PageSize  int32  `form:"page_size" binding:"required,min=1"`
	PageNo    int32  `form:"page_no" binding:"required,min=1"`
	CompanyID int64  `form:"company_id"`
	Search    string `form:"search"`
}

type UpdateDepartmentRequest struct {
	ID               int64  `form:"id"`
	Department       string `form:"title"`
	ArabicDepartment string `form:"title_ar"`
	CompanyID        int64  `form:"company_id"`
}

type SearchAllAgentRequest struct {
	Search string `form:"search"`
}

type GetUsersByStatusReq struct {
	PageSize int32  `form:"page_size" binding:"required"`
	PageNo   int32  `form:"page_no" binding:"required"`
	Status   int64  `form:"status" binding:"required"`
	Search   string `form:"search"`
}

type ResetReq struct {
	CompanyUserID int64  `form:"id" binding:"required"`
	Password      string `form:"password" binding:"required"`
}

type UpdateCompanyUserRequest struct {
	ID             int64  `form:"id" binding:"required"`
	CompanyID      int64  `form:"company_id"`
	FirstName      string `form:"first_name"`
	LastName       string `form:"last_name"`
	Email          string `form:"email"`
	Username       string `form:"username"`
	PrimaryPhone   string `form:"primary_phone_number"`
	SecondaryPhone string `form:"secondary_phone_number"`
	Gender         int64  `form:"gender"`

	// numbers
	WhatsappNumber     string `form:"whatsapp_number"`
	ShowWhatsAppNumber bool   `form:"show_whatsapp_number"`
	BotimNumber        string `form:"botim_number"`
	ShowBotimNumber    bool   `form:"show_botim_number"`
	TawasalNumber      string `form:"tawasal_number"`
	ShowTawasalNumber  bool   `form:"show_tawasal_number"`

	// profile image
	// cover image

	IsShowUserDetails bool  `form:"is_show_user_details"`
	UserTypeID        int64 `form:"user_type_id"`

	DepartmentID int64  `form:"department_id"`
	RoleID       int64  `form:"role_id"`
	About        string `form:"about"`
	AboutArabic  string `form:"about_arabic"`

	// ? other detail
	BRNNo string `form:"brn_no"`
	// brn file ...................................
	BrnLicenseIssueDate        *time.Time `form:"brn_license_issue_date"`
	BrnLicenseRegistrationDate *time.Time `form:"license_registration_date"`
	BrnLicenseExpiryDate       *time.Time `form:"license_expiry_date"`

	Nationality     []int64    `form:"nationalities"`
	SpokenLanguages []int64    `form:"spoken_languages"`
	ExperienceSince *time.Time `form:"experience_since"`

	Facebook string `form:"facebook"`
	LinkedIn string `form:"linkedin"`
	Twitter  string `form:"twitter"`
	// Locations []int64 `form:"locations"`
	// location
	CountryID      int64  `form:"country_id"` // should be same as company
	StateID        *int64 `form:"state_id"`
	CityID         *int64 `form:"city_id"`
	CommunityID    *int64 `form:"community_id"`
	SubCommunityID *int64 `form:"sub_community_id"`

	Standard *int64 `form:"standard"`
	Feature  *int64 `form:"feature"`
	Premium  *int64 `form:"premium"`
	TopDeal  *int64 `form:"topdeal"`

	//
	PassportNo string `form:"passport_no"`
	// passport_image
	PassportExpiryDate *time.Time `form:"passport_expiry_date"`

	ShowHideDetails bool `form:"show_hide_details"`
	IsVerified      bool `form:"is_verified"`

	// freelacer
	// noc_file
	NocNo string `form:"noc_no"`

	// all bank details.....
	AccountNo     string `form:"account_no"`
	AccountName   string `form:"account_name"`
	IBANNo        string `form:"iban_no"`
	BankCountryID int64  `form:"bank_country_id"`
	CurrencyID    int64  `form:"currency_id"`
	BankName      string `form:"bank_name"`
	BankBranch    string `form:"bank_branch"`
	SwiftCode     string `form:"swift_code"`

	//
	LeaderID int64 `form:"leader_id"`
}

type GetUserPackageReq struct {
	CompanyID int64 `form:"company_id"`
	UserID    int64 `form:"user_id"`
}

type SetUserPackageReq struct {
	CompanyID int64  `form:"company_id"`
	UserID    int64  `form:"user_id"`
	Standard  *int64 `form:"standard"`
	Feature   *int64 `form:"feature"`
	Premium   *int64 `form:"premium"`
	TopDeal   *int64 `form:"topdeal"`
}

type GetSingleUserReq struct {
	CompanyID int64 `form:"company_id"`
}

type UpdateUserVerificationReq struct {
	UserID    int64 `form:"user_id" binding:"required"`
	IsVerfied bool  `form:"is_verified"`
}

type GetUserTypeForAdminOutput struct {
	Freelancer any `form:"freelancer,omitempty"`
	Individual any `form:"Individual,omitempty"`
}

type GetUserTypeForCompanyAdminOutput struct {
	Admin any `form:"admin,omitempty"`
	Agent any `form:"agent,omitempty"`
}

type GetActiveUsersByTypeRequest struct {
	CountryID int64  `form:"country_id" binding:"required"`
	Search    string `form:"search"`
}
