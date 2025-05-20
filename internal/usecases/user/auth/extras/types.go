package extras

import (
	"time"
)

type RegisterRequest struct {
	// ! need for profile...
	FirstName      string `form:"first_name"`
	LastName       string `form:"last_name"`
	Country        int64  `form:"country"`
	State          *int64 `form:"state"`
	City           *int64 `form:"city"`
	Community      *int64 `form:"community"`
	Email          string `form:"email" binding:"required"`
	PhoneNumber    string `form:"phone_number" `
	CompanyNumber  string `form:"company_number" `
	WhatsappNumber string `form:"whatsapp_number" `
	Gender         int64  `form:"gender"`

	//! //////
	UserName     string `form:"username" binding:"required"`
	Password     string `form:"password" binding:"required"`
	Status       int8   `form:"status"`
	RoleID       int64  `form:"roles_id"`                         // ?  FK -< roles.id
	DepartmentID int64  `form:"department"`                       // ? FK - department.id
	UserTypeID   int64  `form:"user_types_id" binding:"required"` // ? FK - user_types.id

	AllLanguageID []int64 `form:"all_languages_id[]"`

	// ! in case of usertypeid is 2 or the user is agent
	BRN       string    `form:"brn"`
	BRNExpiry time.Time `form:"brn_expiry"`

	BrokerCompanyID int64   `form:"broker_company_id"`
	IsBranch        *bool   `form:"is_branch"`
	PermissionId    []int64 `form:"permissions_id[]"`
	SubSectionId    []int64 `form:"subsection_id[]"`
}

type UserRequest struct {
	Email    string `form:"email"`
	Username string `form:"username"`
	Password string `form:"password" binding:"required"`
}

type Result struct {
	UserID         int64
	Token          string
	Email          string
	UserName       string
	FirstName      string
	LastName       string
	ProfilePicture string
	Role           string
}

type DashboardRequest struct {
	Email    string `form:"email"`
	Username string `form:"username"`
	Password string `form:"password" binding:"required"`
}

type DashboardResult struct {
	UserID            int64  `json:"user_id"`
	FirstName         string `json:"first_name"`
	LastName          string `json:"last_name"`
	Token             string `json:"token"`
	Email             string `json:"email"`
	UserName          string `json:"username"`
	ProfilePicture    string `json:"profile_picture"`
	PhoneNumber       string `json:"phone_number"`
	HaveCompany       bool   `json:"have_company"`
	IsCompanyVerified bool   `json:"is_company_verified"`
	UserType          int64  `json:"user_types_id"`
	SectionPermission any    `json:"section_permissions"`
}

type GetAllPermissionRequest struct {
	PageNo   int32 `form:"page_no"`
	PageSize int32 `form:"page_size"`
}

type CustomAllSecondaryPermission struct {
	ID                 int64                        `json:"id"`
	Label              string                       `json:"label"`
	SubLabel           string                       `json:"sub_label"`
	TertairyPermission []CustomAllTernaryPermission `json:"Ternary_permission"`
}

type CustomAllTernaryPermission struct {
	ID       int64  `json:"id"`
	Label    string `json:"label"`
	SubLabel string `json:"sub_label"`
}

type CustomSectionPermission struct {
	ID               int64                 `json:"id"`
	Label            string                `json:"label"`
	SubLabel         string                `json:"sub_label"`
	CustomPermission []CustomAllPermission `json:"permissions"`
}

type CustomAllPermission struct {
	ID                           int64                           `json:"id"`
	Label                        string                          `json:"label"`
	SubLabel                     string                          `json:"sub_label"`
	CustomAllSecondaryPermission []CustomAllSubSectionPermission `json:"secondary_permissions"`
}

type CustomAllSubSectionPermission struct {
	ID                     int64  `json:"id"`
	Label                  string `json:"label"`
	SubLabel               string `json:"sub_label"`
	Indicator              int64  `form:"indicator"`
	SubSectionButtonID     int64  `form:"sub_section_button_id"`
	SubSectionButtonAction string `form:"sub_section_button_action"`
}
