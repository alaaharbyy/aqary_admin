package user_handler

import (
	"log"

	"aqary_admin/internal/delivery/rest/helper"
	domain "aqary_admin/internal/domain/requests/user"
	_ "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	_ "aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

// SwaggerProfile is a wrapper for sqlc.Profile
// swagger:model
type SwaggerProfile sqlc.Profile

// CreateProfileRequest godoc
// @Summary CreateProfileRequest
// @Description CreateProfileRequest
// @Tags profile
// @Param UserTypeRequest body domain.CreateProfileRequest true "CreateProfileRequest"
// @Success 200 {object} sqlc.Profile
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/createusertype [POST]
// @Security bearerToken

func (h *UserHandler) CreateProfile(c *gin.Context) {
	var (
		req domain.CreateProfileRequest
	)
	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[user.handler-CreateProfile] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	profile, err := h.UserUseCase.CreateProfile(c, req)
	helper.SendApiResponseV1(c, err, profile)
}

// UpdateProfile
func (h *UserHandler) UpdateProfile(c *gin.Context) {
	var (
		req domain.UpdateProfileRequest
	)
	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[user.handler-UpdateProfile] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	updatedProfile, err := h.UserUseCase.UpdateProfile(c, req)
	helper.SendApiResponseV1(c, err, updatedProfile)
}

// UpdateProfilePasswords
func (h *UserHandler) UpdateProfilePassword(c *gin.Context) {
	var (
		req domain.UpdateProfilePasswordRequest
	)
	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[user.handler-UpdateProfilePassword] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	response, err := h.UserUseCase.UpdateProfilePassword(c, req)
	helper.SendApiResponseV1(c, err, response)
}

func (h *UserHandler) GetOrganization(c *gin.Context) {
	var (
		req domain.GetOrganizationReq
	)
	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[user.handler-GetOrganization] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	response, err := h.UserUseCase.GetOrganization(c, req)
	helper.SendApiResponseV1(c, err, response)
}
