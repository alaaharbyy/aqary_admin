package domain

import (
	"aqary_admin/pkg/utils/fn"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

type CreateUserReq struct {
	CompanyID      int64  `form:"company_id"`
	FirstName      string `form:"first_name" binding:"required"`
	LastName       string `form:"last_name" binding:"required"`
	Email          string `form:"email" binding:"required"`
	Username       string `form:"username" binding:"required"`
	PrimaryPhone   string `form:"primary_phone_number" binding:"required"`
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
	UserTypeID        int64 `form:"user_type_id" binding:"required"`

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
	CountryID      int64 `form:"country_id"` // should be same as company
	StateID        int64 `form:"state_id"`
	CityID         int64 `form:"city_id"`
	CommunityID    int64 `form:"community_id"`
	SubCommunityID int64 `form:"sub_community_id"`

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

type CompanyUserOutput struct {
	UserID         int64  `json:"user_id"`
	FirstName      string `json:"first_name"`
	LastName       string `json:"last_name"`
	Email          string `json:"email"`
	Username       string `json:"username"`
	CountryCode    int64  `json:"country_code"`
	PrimaryPhone   string `json:"primary_phone_number"`
	SecondaryPhone string `json:"secondary_phone_number"`
	Gender         any    `json:"gender"`

	// numbers
	WhatsappNumber     string `json:"whatsapp_number"`
	ShowWhatsAppNumber bool   `json:"show_whatsapp_number"`
	BotimNumber        string `json:"botim_number"`
	ShowBotimNumber    bool   `json:"show_botim_number"`
	TawasalNumber      string `json:"tawasal_number"`
	ShowTawasalNumber  bool   `json:"show_tawasal_number"`

	IsShowUserDetails bool `json:"is_show_user_details"`
	UserTypeID        any  `json:"user_type_id" binding:"required"`

	DepartmentID any    `json:"department_id"`
	RoleID       any    `json:"role_id"`
	About        string `json:"about"`
	AboutArabic  string `json:"about_arabic"`

	// ? other detail
	BRNNo      string             `json:"brn_no"`
	BRN_Expiry pgtype.Timestamptz `json:"brn_expiry"`
	// brn file ...................................
	BrnLicenseIssueDate        time.Time          `json:"brn_license_issue_date"`
	BrnLicenseRegistrationDate time.Time          `json:"license_registration_date"`
	BrnLicenseExpiryDate       pgtype.Timestamptz `json:"license_expiry_date"`

	Nationality     any       `json:"nationalities"`
	SpokenLanguages any       `json:"spoken_languages"`
	ExperienceSince time.Time `json:"experience_since"`

	Facebook string `json:"facebook"`
	LinkedIn string `json:"linkedin"`
	Twitter  string `json:"twitter"`

	// Locations []int64 `form:"locations"`
	// location
	CountryID      any `json:"country_id"` // should be same as company
	StateID        any `json:"state_id"`
	CityID         any `json:"city_id"`
	CommunityID    any `json:"community_id"`
	SubCommunityID any `json:"sub_community_id"`

	Standard int64 `json:"standard"`
	Feature  int64 `json:"feature"`
	Premium  int64 `json:"premium"`
	TopDeal  int64 `json:"topdeal"`

	//--
	PassportNo         string             `json:"passport_no"`
	PassportExpiryDate pgtype.Timestamptz `json:"passport_expiry_date"`

	IsVerified bool `json:"is_verified"`

	// freelacer
	NocNo string `json:"noc_no"`

	// all bank details.....
	AccountNo     string `json:"account_no"`
	AccountName   string `json:"account_name"`
	IBANNo        string `json:"iban_no"`
	BankCountryID any    `json:"bank_country_id"`
	CurrencyID    any    `json:"currency_id"`
	BankName      string `json:"bank_name"`
	BankBranch    string `json:"bank_branch"`
	SwiftCode     string `json:"swift_code"`

	ProfileImage  string `json:"profile_image"`
	CoverImage    string `json:"cover_image"`
	NocFile       string `json:"noc_file"`
	PassportImage string `json:"passport_image"`
	LeaderID      string `json:"leader_name"`
}

type Request struct {
	CompanyID   int64  `form:"company_id"`
	UserID      int64  `form:"user_id" binding:"required"`
	Permissions string `form:"permissions"`
}

type GetCompanyUserReq struct {
	PageNo   int32  `form:"page_no" binding:"required"`
	PageSize int32  `form:"page_size" binding:"required"`
	Search   string `form:"search"`
	UserType int64  `form:"user_type" `
}

type GetASingleUserReq struct {
	ID       int64 `form:"id" binding:"required"`
	UserType int64 `form:"user_type" binding:"required"`
}

type AllCompanyUserRes struct {
	ID           int64  `json:"id"`
	ProfileImage string `json:"profile_image"`
	CompanyName  string `json:"company_name"`
	UserName     string `json:"username"`
	Designation  string `json:"designation"`
	CompanyType  string `json:"company_type"`
	Phone        string `json:"primary_phone"`
	Email        string `json:"email"`
}

type UserUpdateStatusReq struct {
	ID     int64 `form:"id"`
	Status int64 `form:"status"`
}

type CreatePermissionRequest struct {
	Title               string `form:"title" binding:"required"`
	SubTitle            string `form:"sub_title" binding:"required"`
	SectionPermissionId int64  `form:"section_permission_id" binding:"required"`
}

// type GetAllPermissionRequest struct {
// 	PageNo   int64 `form:"page_no" binding:"required,min=1"`
// 	PageSize int64 `form:"page_size" binding:"required,min=1,max=100"`
// }

type UpdatePermissionRequest struct {
	Title               string `form:"title"`
	SubTitle            string `form:"sub_title"`
	SectionPermissionId int64  `form:"section_permission_id"`
}

type CreateUserLicenseVerficiationReq struct {
	LisenceID        int64  `form:"license_id" binding:"required"`
	VerificationType int64  `form:"verification_type" binding:"required,oneof=1 2"` // 1 => request for approve or verify & 2 => for reject
	Notes            string `form:"notes"`
}

type UserLicenseOutput struct {
	ID                      int64           `json:"id"`
	LicenseFileUrl          string          `json:"license_file_url"`
	LicenseNo               string          `json:"license_no"`
	LicenseIssueDate        string          `json:"license_issue_date"`
	LicenseRegistrationDate string          `json:"license_registration_date"`
	LicenseExpiryDate       time.Time       `json:"license_expiry_date"`
	LicenseTypeID           fn.CustomFormat `json:"license_type_id"`
	StateID                 int64           `json:"state_id"`
	EntityTypeID            int64           `json:"entity_type_id"`
	EntityID                int64           `json:"entity_id"`
	VerificationStatus      int64           `json:"verification_status"`
}

type SetTeamLeaderReq struct {
	UserID   int64 `form:"user_id" binding:"required"`
	LeaderID int64 `form:"leader_id" binding:"required"`
}

type GetSubscriptionOrderPackageDetailByUserIDReq struct {
	UserType int64 `form:"user_type" binding:"required"`
	UserID   int64 `form:"user_id" binding:"required"`
	Type     int64 `form:"type"`
}

type Subscriptions struct {
	Quantity int64  `json:"quantity"`
	Price    string `json:"price"`
	Discount int64  `json:"discount"`
}

type SubscriptionPackageDetailOutput struct {
	Standard   Subscriptions `json:"standard"`
	Feature    Subscriptions `json:"freature"`
	Premium    Subscriptions `json:"premium"`
	TopDeal    Subscriptions `json:"top_deal"`
	TotalUnits int64         `json:"total_units"`
	Amount     string        `json:"amount"`
	Duration   string        `json:"duration"`
	StartDate  time.Time     `json:"start_date"`
	EndDate    time.Time     `json:"end_date"`
	Status     any           `json:"status"`
}

type FreeSubscriptions struct {
	Quantity  int64     `json:"quantity"`
	StartDate time.Time `json:"start_date"`
	EndDate   time.Time `json:"end_date"`
}

type FreeSubscriptionPackageDetailOutput struct {
	Standard   FreeSubscriptions `json:"standard"`
	Feature    FreeSubscriptions `json:"freature"`
	Premium    FreeSubscriptions `json:"premium"`
	TopDeal    FreeSubscriptions `json:"top_deal"`
	TotalUnits int64             `json:"total_units"`
	Amount     string            `json:"amount"`
	Duration   string            `json:"duration"`
	StartDate  time.Time         `json:"start_date"`
	EndDate    time.Time         `json:"end_date"`
	Status     any               `json:"status"`
}

type UpdateActiveCompanyReq struct {
	ActiveCompany int64 `form:"active_company" binding:"required"`
}

type GetCompanyRemainingPackageReq struct {
	CompanyId int64 `form:"company_id"`
}
type GetUserLicensesReq struct {
	ID int64 `uri:"id" binding:"required"`
}

type AddExpertiseReq struct {
	CompanyUserID int64   `form:"company_user_id" binding:"required"`
	ExpertiseIDs  []int64 `form:"expertise_ids" binding:"required"`
}

type GetExpertiseByUserReq struct {
	CompanyUserID int64 `form:"company_user_id" binding:"required"`
	PageNo        int32 `form:"page_no"`
	PageSize      int32 `form:"page_size"`
}
