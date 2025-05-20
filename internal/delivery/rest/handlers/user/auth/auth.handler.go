package auth_handler

import (
	"log"
	"strconv"

	"aqary_admin/internal/delivery/rest/helper"
	domain "aqary_admin/internal/domain/requests/user"
	_ "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils"
	_ "aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

func (c *AuthHandler) IntialSignUp(ctx *gin.Context) {
	var req domain.IntialSignUpRequest
	if err := ctx.ShouldBind(&req); err != nil {
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(ctx, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}
	IntialSignUp, err := c.userUseCase.IntialSignUp(ctx, req)

	helper.SendApiResponseV1(ctx, err, IntialSignUp)

}

func (c *AuthHandler) VerifySignUpOTP(ctx *gin.Context) {
	var req domain.VerifyOTPEmailAndPhoneNumber
	if err := ctx.ShouldBind(&req); err != nil {
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(ctx, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}
	VerifyOTP, err := c.userUseCase.VerifySignUpOTP(ctx, req)

	helper.SendApiResponseV1(ctx, err, VerifyOTP)

}

// func (c *AuthHandler) SignUp(ctx *gin.Context) {
// 	var req domain.SignUpRequest
// 	if err := ctx.ShouldBind(&req); err != nil {
// 		errMsg := utils.CustomBindingFormError(err, req)
// 		helper.SendApiResponseV1(ctx, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
// 		return
// 	}
// 	SignUp, err := c.userUseCase.SignUp(ctx, req)

// 	helper.SendApiResponseV1(ctx, err, SignUp)

// }

// Register godoc
// @Summary Registeruser
// @Description Register user
// @Tags auth
// @Param RegisterRequest body domain.RegisterRequest true "RegisterRequest"
// @Success 200 {object} string "done"
// @Router /api/user/register [POST]
// @Security bearerToken
func (h *AuthHandler) RegisterHandler(c *gin.Context) {
	var (
		req domain.RegisterRequest
	)
	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[auth.handler-Registeration] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	user, err := h.userUseCase.Register(c, req)
	helper.SendApiResponseV1(c, err, user)
}

// DashboardLogin godoc
// @Summary  DashboardLogin
// @Description  dashboard  login
// @tags auth
// @param DashboardLogin body domain.LoginReq true "DashboardLogin"
// @Success 200 {object} response.DashboardResult
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/dashboardLogin [POST]
func (h *AuthHandler) DashboardLogin(c *gin.Context) {

	var (
		req domain.LoginReq
	)

	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[auth.handler-Login] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	user, err := h.userUseCase.DashboardLogin(c, req)

	helper.SendApiResponseV1(c, err, user)
}

// ResetPassword godoc
// @Summary  ResetPassword
// @Description  ResetPassword
// @tags auth
// @param DashboardLogin body domain.LoginReq true "ResetPassword"
// @Success 200 {object} string
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/resetPassword [POST]
func (h *AuthHandler) ResetPassword(c *gin.Context) {

	var (
		req domain.ResetPasswordRequest
	)

	idString, err := c.Params.Get("id")
	if !err {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "cannot convert id"), nil)

	}

	id, errr := strconv.Atoi(idString)
	if errr != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "invalid id"), nil)
		return
	}

	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[auth.handler-ResetPassword] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)

		return
	}

	user, er := h.userUseCase.ResetPassword(c, int64(id), req)
	if er == nil {
		h.hub.SendNotificationToUser(idString, "Reset Password", "Successfully reset password")
	}
	helper.SendApiResponseV1(c, er, user)
}

// ResetPasswordWihtoutOldPassword godoc
// @Summary  ResetPasswordWithoutOldPasswordRequest
// @Description  ResetPasswordWithoutOldPasswordRequest
// @tags auth
// @param DashboardLogin body domain.ResetPasswordWithoutOldPasswordRequest true "ResetPasswordWithoutOldPasswordRequest"
// @Success 200 {object} string
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/resetPasswordWithoutPassword [POST]
func (h *AuthHandler) ResetPasswordWithoutOldPassword(c *gin.Context) {

	var (
		req domain.ResetPasswordWithoutOldPasswordRequest
	)

	idString, err := c.Params.Get("id")
	if !err {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "cannot convert id"), nil)

	}

	id, errr := strconv.Atoi(idString)
	if errr != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "invalid id"), nil)

		return
	}

	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[auth.handler-ResetPassword] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)

		return
	}

	user, er := h.userUseCase.ResetPasswordWithoutOldPassword(c, int64(id), req)
	if er == nil {
		h.hub.SendNotificationToUser(idString, "Reset Password", "Successfully reset password")
	}
	helper.SendApiResponseV1(c, er, user)
}

// ResetPasswordWihtoutOldPassword godoc
// @Summary  ResetPasswordWithoutOldPasswordRequest
// @Description  ResetPasswordWithoutOldPasswordRequest
// @tags auth
// @param DashboardLogin body domain.ResetPasswordWithoutOldPasswordRequest true "ResetPasswordWithoutOldPasswordRequest"
// @Success 200 {object} string
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/getUserPermission [GET]
func (h *AuthHandler) GetUserPermission(c *gin.Context) {
	idString, err := c.Params.Get("id")
	if !err {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "cannot convert id"), nil)
	}

	id, errr := strconv.Atoi(idString)
	if errr != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "invalid id"), nil)
		return
	}
	userPerm, er := h.userUseCase.GetUserPermission(c, int64(id)) // it will be company id
	helper.SendApiResponseV1(c, er, userPerm)
}

// SwaggerUser is a wrapper for sqlc.User
// swagger:model
type SwaggerUser sqlc.User

// UserUpdateStatusReq godoc
// @Summary  UserUpdateStatusReq
// @Description  ResetPasswordWithoutOldPasswordRequest
// @tags auth
// @param DashboardLogin body  domain.UserUpdateStatusReq true "UserUpdateStatusReq"
// @Success 200 {object} sqlc.User
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/updateUserState [PUT]
func (h *AuthHandler) UpdateUserStatus(c *gin.Context) {

	var (
		req domain.UserUpdateStatusReq
	)
	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[auth.handler-UpdateUserStatus] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	userPerm, er := h.userUseCase.UpdateUserStatusWithoutUpdateTime(c, req)
	if er != nil {
		helper.SendApiResponseV1(c, er, nil)
		return
	}
	helper.SendApiResponseV1(c, er, userPerm)
}

// ForgotPassword godoc
// @Summary  ForgotPassword
// @Description  forgot password
// @tags auth
// @param ForgotPassword body domain.ForgotPasswordRequest true "ForgotPassword"
// @Success 200 {object} string
// @Failure 401  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/forgotPassword [POST]
func (h *AuthHandler) ForgotPassword(c *gin.Context) {

	var (
		req domain.ForgotPasswordRequest
	)

	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[auth.handler-ForgotPassword] While binding request Error:%s ", err)
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}

	secretKey, err := h.userUseCase.ForgotPassword(c, req)

	helper.SendApiResponseV1(c, err, secretKey)
}

func (h *AuthHandler) ResendOTP(c *gin.Context) {

	var (
		req domain.ResendOTPRequest
	)

	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[auth.handler-ForgotPassword] While binding request Error:%s ", err)
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}

	secretKey, err := h.userUseCase.ResendOTP(c, req)

	helper.SendApiResponseV1(c, err, secretKey)
}

// VerifyOTP godoc
// @Summary  VerifyOTP
// @Description  Forgot password verify OTP
// @tags auth
// @param VerifyOTP body domain.VerifyOTPRequest true "VerifyOTP"
// @Success 200 {object} string
// @Failure 401  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/verifyOTP [POST]
func (h *AuthHandler) VerifyOTP(c *gin.Context) {

	var (
		req domain.VerifyOTPRequest
	)

	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[auth.handler-VerifyOTP] While binding request Error:%s ", err)
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}

	msg, err := h.userUseCase.VerifyOTP(c, req)

	helper.SendApiResponseV1(c, err, msg)
}

// UpdatePassword godoc
// @Summary  UpdatePassword
// @Description update password
// @tags auth
// @param updatePassword body domain.UpdatePasswordRequest true "UpdatePassword"
// @Success 200 {object} string
// @Failure 401  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/updatePassword [POST]
func (h *AuthHandler) UpdatePassword(c *gin.Context) {

	var (
		req domain.UpdatePasswordRequest
	)

	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[auth.handler-UpdatePassword] While binding request Error:%s ", err)
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}

	msg, err := h.userUseCase.UpdatePassword(c, req)

	helper.SendApiResponseV1(c, err, msg)
}

// UAEPassLogin godoc
// @Summary  UAEPassLogin
// @Description social login i.e uaepass
// @tags auth
// @param authorization_code body domain.UAEPassLoginReq true "UAEPassLogin"
// @param redirect_uri body domain.UAEPassLoginReq true "UAEPassLogin"
// @param code body domain.UAEPassLoginReq true "UAEPassLogin"
// @Success 200 {object} string
// @Failure 401  {object} utils.ErrResponseSwagger
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/uaepasslogin [POST]
func (h *AuthHandler) UAEPassLogin(c *gin.Context) {

	var (
		req domain.UAEPassLoginReq
	)

	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[auth.handler-UAEPassLogin] While binding request Error:%s ", err)
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}

	data, err := h.userUseCase.UAEPassLogin(c, req)

	helper.SendApiResponseV1(c, err, data)
}

// UAEPassLogin godoc
// @Summary  UAEPassLogin
// @Description social login i.e uaepass
// @tags auth
// @param authorization_code body domain.UAEPassLoginReq true "UAEPassLogin"
// @param redirect_uri body domain.UAEPassLoginReq true "UAEPassLogin"
// @param code body domain.UAEPassLoginReq true "UAEPassLogin"
// @Success 200 {object} string
// @Failure 401  {object} utils.ErrResponseSwagger
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/uaepasslogin [POST]
func (h *AuthHandler) GoogleLogin(c *gin.Context) {

	// helper.SendApiResponseV1(c, err, data)

	var (
		req domain.GoogleLoginReq
	)

	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[auth.handler-UAEPassLogin] While binding request Error:%s ", err)
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}

	data, err := h.userUseCase.GoogleLogin(c, req)

	helper.SendApiResponseV1(c, err, data)
}

// FacebookLogin godoc
// @Summary  FacebookLogin
// @Description social login i.e facebook
// @tags auth
// @param authorization_code body domain.FacebookLoginReq true "FacebookLogin"
// @param redirect_uri body domain.FacebookLoginReq true "FacebookLogin"
// @param code body domain.FacebookLoginReq true "FacebookLogin"
// @Success 200 {object} string
// @Failure 401  {object} utils.ErrResponseSwagger
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/facebooklogin [POST]
func (h *AuthHandler) FacebookLogin(c *gin.Context) {

	// helper.SendApiResponseV1(c, err, data)

	var (
		req domain.FacebookLoginReq
	)

	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[auth.handler-FacebookLogin] While binding request Error:%s ", err)
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}

	data, err := h.userUseCase.FacebookLogin(c, req)

	helper.SendApiResponseV1(c, err, data)
}

func (h *AuthHandler) AppleLogin(c *gin.Context) {

	var (
		req domain.AppleLoginReq
	)

	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[auth.handler-AppleLogin] While binding request Error:%s ", err)
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}

	data, err := h.userUseCase.AppleLogin(c, req)

	helper.SendApiResponseV1(c, err, data)
}
