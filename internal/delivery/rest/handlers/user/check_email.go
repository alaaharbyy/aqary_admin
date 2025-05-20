package user_handler

import (
	"aqary_admin/internal/delivery/rest/helper"
	domain "aqary_admin/internal/domain/requests/user"
	_ "aqary_admin/internal/domain/responses/user"
	"aqary_admin/pkg/utils"

	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

// CheckEmail godoc
// @Summary CheckEmail
// @Description Check if an email already exists
// @Tags users
// @Param request body domain.CheckEmailRequest true "CheckEmailRequest"
// @Success 200 {object} string
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 409 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/checkEmail [POST]
func (h *UserHandler) CheckEmail(c *gin.Context) {
	var req domain.CheckEmailRequest
	if err := c.ShouldBind(&req); err != nil {
		msg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, msg), nil)
		return
	}
	exists, _ := h.UserUseCase.CheckEmail(c, req.Email)
	helper.SendApiResponseV1(c, nil, utils.Ternary[bool](exists, true, false))

}

// CheckUsername godoc
// @Summary CheckUsername
// @Description Check if a username already exists
// @Tags users
// @Param request body domain.CheckUsernameRequest true "CheckUsernameRequest"
// @Success 200 {object} string
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 409 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/checkUsername [POST]
func (h *UserHandler) CheckUsername(c *gin.Context) {
	var req domain.CheckUsernameRequest
	if err := c.ShouldBind(&req); err != nil {
		msg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, msg), nil)
		return
	}

	exists, _ := h.UserUseCase.CheckUsername(c, req.Username)
	helper.SendApiResponseV1(c, nil, utils.Ternary[bool](exists, true, false))

}

// CheckPhone godoc
// @Summary CheckPhone
// @Description Check if an phone already exists
// @Tags users
// @Param request body domain.CheckMobileRequest true "CheckMobileRequest"
// @Success 200 {object} string
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 409 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/CheckPhone [POST]
func (h *UserHandler) CheckPhone(c *gin.Context) {
	var req domain.CheckMobileRequest
	if err := c.ShouldBind(&req); err != nil {
		msg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, msg), nil)
		return
	}
	exists, _ := h.UserUseCase.CheckPhone(c, req)
	helper.SendApiResponseV1(c, nil, utils.Ternary[bool](exists, true, false))

}
