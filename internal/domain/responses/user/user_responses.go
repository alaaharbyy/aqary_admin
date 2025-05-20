package response

import (
	"aqary_admin/old_repo/model"
	"aqary_admin/pkg/utils/fn"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

// type UserOutput struct {
// 	ID                   int64       `json:"id"`
// 	Email                string      `json:"email"`
// 	Username             string      `json:"username"`
// 	Password             string      `json:"password"`
// 	Status               int64       `json:"status"`
// 	RolesID              pgtype.Int8 `json:"roles_id"`
// 	Department           pgtype.Int8 `json:"department"`
// 	ProfilesID           int64       `json:"profiles_id"`
// 	UserTypesID          int64       `json:"user_types_id"`
// 	SocialLogin          pgtype.Text `json:"social_login"`
// 	CreatedAt            time.Time   `json:"created_at"`
// 	UpdatedAt            time.Time   `json:"updated_at"`
// 	PermissionsID        []int64     `json:"permissions_id"`
// 	SubSectionPermission []int64     `json:"sub_section_permission"`
// 	IsVerified           pgtype.Bool `json:"is_verified"`
// }

type UserType struct {
	ID     int64  `json:"id"`
	Type   string `json:"user_type"`
	TypeAr string `json:"user_type_ar"`
}

type AllPendingUserOutput struct {
	ID                 int64  `json:"id"`
	Username           string `json:"username"`
	Email              string `json:"email"`
	Phone              string `json:"phone"`
	Department         string `json:"department"`
	Role               string `json:"role"`
	Country            string `json:"country"`
	State              string `json:"state"`
	City               string `json:"city"`
	Community          string `json:"community"`
	SubCommunity       string `json:"sub_community"`
	VerificationStatus string `json:"verification_status"`
	CompanyID          int64  `json:"company_id"`
	CompanyType        int64  `json:"company_type"`
	IsBranch           bool   `json:"is_branch"`
}

// type AllUserOutput struct {
// 	ID           int64  `json:"id"`
// 	Username     string `json:"username"`
// 	Email        string `json:"email"`
// 	Phone        string `json:"phone"`
// 	Department   string `json:"department"`
// 	Role         string `json:"role"`
// 	Country      string `json:"country"`
// 	State        string `json:"state"`
// 	City         string `json:"city"`
// 	Community    string `json:"community"`
// 	SubCommunity string `json:"sub_community"`
// }

// type UserOutput struct {
// 	ID           int64           `json:"id"`
// 	Username     string          `json:"username"`
// 	FirstName    string          `json:"first_name"`
// 	LastName     string          `json:"last_name"`
// 	Email        string          `json:"email"`
// 	Phone        string          `json:"phone"`
// 	UserTypeId   int64           `json:"user_type_id"`
// 	Department   fn.CustomFormat `json:"department"`
// 	Role         fn.CustomFormat `json:"role"`
// 	Country      fn.CustomFormat `json:"country"`
// 	State        fn.CustomFormat `json:"state"`
// 	City         fn.CustomFormat `json:"city"`
// 	Community    fn.CustomFormat `json:"community"`
// 	SubCommunity fn.CustomFormat `json:"sub_community"`
// 	Permission   interface{}     `json:"permission"`
// }

// 0----------------------------------
type DeletedAqaryUserOutput struct {
	ID          int64  `json:"id"`
	Name        string `json:"name"`
	PhoneNumber string `json:"phone_number"`
	Email       string `json:"email"`
	Role        string `json:"role"`
	Department  string `json:"department"`
}

type UpdatedUserOutput struct {
	ID                   int64           `json:"id"`
	Username             string          `json:"username"`
	FirstName            string          `json:"first_name"`
	LastName             string          `json:"last_name"`
	Email                string          `json:"email"`
	Phone                string          `json:"phone"`
	Department           fn.CustomFormat `json:"department"`
	Role                 fn.CustomFormat `json:"role"`
	Country              fn.CustomFormat `json:"country"`
	State                fn.CustomFormat `json:"state"`
	City                 fn.CustomFormat `json:"city"`
	Community            fn.CustomFormat `json:"community"`
	SubCommunity         fn.CustomFormat `json:"sub_community"`
	Permission           []int64         `json:"permission"`
	SubSectionPermission []int64         `json:"sub_section_permission"`
}

type AllUserOutput struct {
	ID           int64           `json:"id"`
	Username     string          `json:"username"`
	Email        string          `json:"email"`
	Phone        string          `json:"phone"`
	Department   string          `json:"department"`
	Role         string          `json:"role"`
	Location     string          `json:"location"`
	Country      string          `json:"country"`
	State        string          `json:"state"`
	City         string          `json:"city"`
	Community    string          `json:"community"`
	SubCommunity string          `json:"sub_community"`
	Status       fn.CustomFormat `json:"status"`
}

type RoleOutput struct {
	ID   int64  `json:"id"`
	Role string `json:"role"`
}

type DepartmentOutput struct {
	ID         int64  `json:"id"`
	Department string `json:"department"`
}

type UserOutput struct {
	ID           int64           `json:"id"`
	Username     string          `json:"username"`
	FirstName    string          `json:"first_name"`
	LastName     string          `json:"last_name"`
	Email        string          `json:"email"`
	Phone        string          `json:"phone"`
	UserTypeId   int64           `json:"user_type_id"`
	Department   any             `json:"department"`
	Role         any             `json:"role"`
	Country      fn.CustomFormat `json:"country"`
	State        fn.CustomFormat `json:"state"`
	City         fn.CustomFormat `json:"city"`
	Community    fn.CustomFormat `json:"community"`
	SubCommunity fn.CustomFormat `json:"sub_community"`
	Permission   interface{}     `json:"permission"`
}
type User struct {
	ID           int64
	Username     string
	Password     string
	Status       int8
	RoleID       int64
	DepartmentID int64
	ProfileID    int64
	UserTypeID   int64
}

type GetCompanyUserReq struct {
	PageNo   int32  `form:"page_no" binding:"required"`
	PageSize int32  `form:"page_size" binding:"required"`
	Search   string `form:"search"`
}

type AllCompanyUserRes struct {
	ID            int64  `json:"id"`
	CompanyUserID int64  `json:"company_user_id"`
	CompanyID     int64  `json:"company_id"`
	ProfileImage  string `json:"profile_image"`
	CompanyName   string `json:"company_name"`
	UserName      string `json:"username"`
	Department    string `json:"department"`
	Role          string `json:"role"`
	BRNNo         string `json:"brn_no"`
	Status        any    `json:"status"`
	IsVerfied     any    `json:"is_verified"`
	CompanyType   string `json:"company_type"`
	Phone         string `json:"primary_phone"`
	Email         string `json:"email"`
}

type AllFreelanceUserRes struct {
	UserID       int64  `json:"id"`
	ProfileImage string `json:"profile_image"`
	UserName     string `json:"username"`
	BRNNo        string `json:"brn_no"`
	Noc          string `json:"noc"`
	IsVerfied    any    `json:"is_verified"`
	Phone        string `json:"primary_phone"`
	Email        string `json:"email"`
	Status       any    `json:"status"`
}

type AllOwnerUserRes struct {
	UserID       int64  `json:"id"`
	ProfileImage string `json:"profile_image"`
	UserName     string `json:"username"`
	Phone        string `json:"primary_phone"`
	Status       any    `json:"status"`
	IsVerfied    any    `json:"is_verified"`
	Email        string `json:"email"`
}

type Company struct {
	ID          int64  `json:"id"`
	CompanyName string `json:"company_name"`
	CompanyType int64  `json:"company_type"`
	IsBranch    bool   `json:"is_branch"`
}

type GetCompanyUserRes struct {
	CompanyUserID     int64   `json:"id"`
	Company           Company `json:"company"`
	FirstName         string  `json:"first_name"`
	LastName          string  `json:"last_name"`
	ProfileImage      string  `json:"profile_image"`
	Email             string  `json:"email"`
	PrimaryPhone      string  `json:"primary_phone"`
	SecondaryPhone    string  `json:"secondary_phone"`
	WhatsappNumber    string  `json:"whatsapp_number"`
	IsShowUserDetails bool    `json:"is_show_user_details"`
	Designation       string  `json:"designation"`
	Gender            int64   `json:"gender"`
	About             string  `json:"about"`
	AboutArabic       string  `json:"about_arabic"`
	ExperienceSince   any     `json:"experience_since"`
	LinkedIn          string  `json:"linkedin"`
	Facebook          string  `json:"facebook"`
	Twitter           string  `json:"twitter"`
	Botim             string  `json:"botim"`
	Tawasal           string  `json:"tawasal"`
	Nationality       any     `json:"nationality"`
	SpokenLanguages   any     `json:"spoken_languages"`
	Locations         any     `json:"locations"`
	BRN               string  `json:"brn"`
	BRN_Expiry        any     `json:"brn_expiry"`
	Standard          int64   `json:"standard"`
	Feature           int64   `json:"feature"`
	Premium           int64   `json:"premium"`
	TopDeal           int64   `json:"topdeal"`
	SectionPermisison any     `json:"section_permission"`
}

type GetUsersByStatusResponse struct {
	ID           int64       `json:"id"`
	ProfileImage string      `json:"profile_image"`
	CompanyName  pgtype.Text `json:"company_name"`
	UserType     string      `json:"user_type"`
	AgentName    string      `json:"agent_name"`
	Designation  string      `json:"designation"`
	Phone        string      `json:"phone"`
	Email        string      `json:"email"`
}

type UserCountOutput struct {
	TotalUsers    int64 `json:"total_users"`
	ActiveUsers   int64 `json:"active_users"`
	InActiveUsers int64 `json:"inactive_users"`
}

func ContainRolesId(list []CustomRolePermission, target int64) bool {
	for _, item := range list {
		if item.ID == target {
			return true
		}
	}
	return false
}

func ContainSectionId(list []CustomSectionPermissions, target int64) bool {
	for _, item := range list {
		if item.ID == target {
			return true
		}
	}
	return false
}

type RoleOutout struct {
	Id          int64  `json:"role_id"`
	Role        string `json:"role"`
	Permissions any    `json:"permissions"`
}

type GetUserDetailsByUserNameResponse struct {
	Email               string                 `json:"email"`
	Username            string                 `json:"username"`
	Status              model.CustomFormat     `json:"status"`
	UserTypesID         int64                  `json:"user_types_id"`
	IsVerified          bool                   `json:"is_verified"`
	ShowHideDetails     bool                   `json:"show_hide_details"`
	PhoneNumber         string                 `json:"phone_number"`
	CountryCode         int64                  `json:"country_code"`
	IsEmailVerified     bool                   `json:"is_email_verified"`
	IsPhoneVerified     bool                   `json:"is_phone_verified"`
	FirstName           string                 `json:"first_name"`
	LastName            string                 `json:"last_name"`
	FullName            interface{}            `json:"full_name"`
	ProfileImageUrl     string                 `json:"profile_image_url"`
	SecondaryNumber     string                 `json:"secondary_number"`
	CoverImageUrl       string                 `json:"cover_image_url"`
	About               string                 `json:"about"`
	Gender              string                 `json:"gender"`
	RefNo               string                 `json:"ref_no"`
	FullAddress         string                 `json:"full_address"`
	ActiveCompany       ActiveCompany          `json:"active_company"`
	UserType            model.CustomUserFormat `json:"user_type"`
	AssociatedCompanies []AssociatedCompany    `json:"associated_companies"`
	// AllPermissions      *[]CustomSectionPermission `json:"all_permissions"`
	AllPermissions         *[]int64           `json:"all_permissions"`
	DefaultCountrySettings DefaultSettingsRes `json:"default_settings"`
	Country                CountryResp        `json:"country"`
	//extra user details
	ExperienceSince time.Time          `json:"experience_since"`
	Nationality     model.CustomFormat `json:"nationality"`
	Language        model.CustomFormat `json:"language"`
	WhatsappNumber  string             `json:"whatsapp_number"`
	//for organization api
	Organization string             `json:"organization"`
	UserRole     model.CustomFormat `json:"user_role"`
}

type DefaultSettingsRes struct {
	Currency     CurrencyRes `json:"currency"`
	BaseCurrency CurrencyRes `json:"base_currency"`
	DecimalPlace uint        `json:"decimal"`
	Measurement  string      `json:"measurement"`
}
type CountryResp struct {
	CountryID   int64  `json:"country_id"`
	Country     string `json:"country"`
	CountryFlag string `json:"flag"`
}
type CurrencyRes struct {
	ID   int64  `json:"id"`
	Code string `json:"code"`
	Icon string `json:"icon"`
}

// [{"company_id" : 170, "company_name" : "broker company2011211111w34", "is_verified" : true, "role_id" : null, "role_name" : null}, {"company_id" : 1, "company_name" : "Fine Home", "is_verified" : true, "role_id" : null, "role_name" : null}]
type AssociatedCompanies struct {
	CompanyId   int64  `json:"company_id"`
	CompanyName string `json:"company_name"`
	IsVerified  bool   `json:"is_verified"`
	RoleId      int64  `json:"role_id"`
	RoleName    string `json:"role_name"`
}

type ActiveCompany struct {
	CompanyId   int64  `json:"id"`
	CompanyName string `json:"name"`
	IsVerified  bool   `json:"verified"`
	Logo        string `json:"logo"`
	CoverImage  string `json:"cover_image"`
	WebsiteURL  string `json:"website_url"`
}

type AssociatedCompany struct {
	CompanyId   int64  `json:"id"`
	CompanyName string `json:"name"`
	IsVerified  bool   `json:"verified"`
	Logo        string `json:"logo"`
}
