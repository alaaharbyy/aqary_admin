package domain

import (
	"time"
)

type IntialSignUpRequest struct {
	UserName    string `form:"user_name" binding:"required"`
	Email       string `form:"email" binding:"required"`
	Password    string `form:"password" binding:"required"`
	FirstName   string `form:"first_name"`
	LastName    string `form:"last_name"`
	PhoneNumber string `form:"phone_number" binding:"required"`
}
type SignUpRequest struct {
	SecretKey string `form:"secret_key" binding:"required"`
}
type VerifyOTPEmailAndPhoneNumber struct {
	// MainSecretKey string `form:"main_secret_key" binding:"required"`
	Type      int    `form:"type"  binding:"required,oneof=1 2"`
	SecretKey string `form:"secret_key" binding:"required"`
	OTP       int    `form:"otp" binding:"required"`
}
type RegisterRequest struct {
	// ! need for profile...
	FirstName    string `form:"first_name"`
	LastName     string `form:"last_name"`
	Country      int64  `form:"country"`
	State        *int64 `form:"state"`
	City         *int64 `form:"city"`
	Community    *int64 `form:"community"`
	SubCommunity *int64 `form:"sub_community"`
	Email        string `form:"email" binding:"required"`
	Gender       int64  `form:"gender"`

	// ?
	PrimaryPhoneNumber   string `form:"phone_number"`
	SecondaryPhoneNumber string `form:"secondary_phone_number"`
	CompanyNumber        string `form:"company_number"`
	WhatsappNumber       string `form:"whatsapp_number"`
	Botim                string `form:"botim"`
	Tawasal              string `form:"tawasal"`

	//! //////
	UserName     string `form:"username" binding:"required"`
	Password     string `form:"password" binding:"required"`
	Status       int8   `form:"status"`
	RoleID       int64  `form:"roles_id"`                         // ?  FK -< roles.id
	DepartmentID int64  `form:"department"`                       // ? FK - department.id
	UserTypeID   int64  `form:"user_types_id" binding:"required"` // ? FK - user_types.id

	AllLanguageID []int64 `form:"all_languages_id[]"`

	// ! in case of usertypeid is 2 or the user is agent
	BRN             string    `form:"brn"`
	BRNExpiry       time.Time `form:"brn_expiry"`
	BrokerCompanyID int64     `form:"broker_company_id"`

	//.....................
	HideUserDetail bool `form:"hide_user_detail"`
	// profile_image_url
	// cover_image
	Description string `form:"description"`

	Permissions string `form:"permissions"`
}

type LoginReq struct {
	Email    string `form:"email"`
	Username string `form:"username"`
	Password string `form:"password" binding:"required"`
}

type ResetPasswordRequest struct {
	OldPassword string `form:"old_password" binding:"required"`
	NewPassword string `form:"new_password" binding:"required"`
}

type ResetPasswordWithoutOldPasswordRequest struct {
	NewPassword string `form:"new_password" binding:"required"`
}

type UpdateUserByStatusReq struct {
	ID       int64 `form:"id" binding:"required"` // @ user id
	Status   int64 `form:"status" binding:"required"`
	UserType int64 `form:"user_type"`
}

type ForgotPasswordRequest struct {
	Email       string `form:"email"`
	PhoneNumber string `form:"phone_number"`
	CompanyId   int64  `form:"company_id" binding:"required"`
}

type ResendOTPRequest struct {
	SecretKey string `form:"secret_key" binding:"required"`
}

type VerifyOTPRequest struct {
	SecretKey string `form:"secret_key" binding:"required"`
	OTP       int    `form:"otp" binding:"required"`
}
type UpdatePasswordRequest struct {
	SecretKey   string `form:"secret_key" binding:"required"`
	NewPassword string `form:"new_password" binding:"required"`
}

type ResentOTPRequest struct {
	SecretKey string `form:"secret_key" binding:"required"`
}

type UAEPassLoginReq struct {
	RedirectUri string `form:"redirect_uri" binding:"required"`
	Code        string `form:"code" binding:"required"`
	CompanyID   int64  `form:"company_id"`
	CountryID   int64  `form:"country_id" binding:"required"`
}

type GoogleLoginReq struct {
	ClientID  string `form:"client_id" binding:"required"`
	IDToken   string `form:"id_token" binding:"required"`
	CompanyID int64  `form:"company_id"`
	CountryID int64  `form:"country_id" binding:"required"`
}

type FacebookLoginReq struct {
	// ClientID  string `form:"client_id" binding:"required"`
	IDToken   string `form:"id_token" binding:"required"`
	CompanyID int64  `form:"company_id"`
	CountryID int64  `form:"country_id" binding:"required"`
}

type AppleLoginReq struct {
	Code      string `form:"code" binding:"required"`
	CompanyID int64  `form:"company_id"`
	CountryID int64  `form:"country_id" binding:"required"`
}
