package companyuser_handler

import (
	"aqary_admin/internal/delivery/rest/helper"
	domain "aqary_admin/internal/domain/requests/user"
	_ "aqary_admin/internal/domain/responses/user"
	_ "aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

// GetCountCompanyUsers godoc
// @Summary Get count of company users
// @Description Get count of active, inactive, and total company users
// @Tags company_users
// @Success 200 {object} response.UserCountOutput
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getCountCompanyUsers [GET]
// @Security bearerToken
func (h *CompanyUserHandler) GetCountCompanyUsers(c *gin.Context) {
	output, err := h.userUseCase.GetCountCompanyUsers(c)
	helper.SendApiResponseV1(c, err, output)
}

// ResetCompanyUserPassword godoc
// @Summary Reset company user password
// @Description Reset the password for a company user
// @Tags company_users
// @Param resetReq body domain.ResetPasswordRequest true "Reset password request"
// @Success 200 {object} string
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 404 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/resetCompanyUserPassword [PUT]
// @Security bearerToken
func (h *CompanyUserHandler) ResetCompanyUserPassword(c *gin.Context) {
	var req domain.ResetReq
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "please provide all the required fields"), nil)
		return
	}

	err := h.userUseCase.ResetCompanyUserPassword(c, req)
	if err != nil {
		helper.SendApiResponseV1(c, err, nil)
		return
	}

	helper.SendApiResponseV1(c, nil, "password reset successfully!")
}

// UpdateCompanyUserByStatus godoc
// @Summary Update company user status
// @Description Update the status of a company user
// @Tags company_users
// @Param updateReq body domain.UpdateUserByStatusReq true "Update user status request"
// @Success 200 {object} string
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 404 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/updateCompanyUserByStatus [PUT]
// @Security bearerToken
// func (h *CompanyUserHandler) UpdateCompanyUserByStatus(c *gin.Context) {
// 	var req domain.UpdateUserByStatusReq
// 	if err := c.ShouldBind(&req); err != nil {
// 		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "please provide all the required fields"), nil)
// 		return
// 	}

// 	err := h.userUseCase.UpdateCompanyUserByStatus(c, req)
// 	if err != nil {
// 		helper.SendApiResponseV1(c, err, nil)
// 		return
// 	}

// 	helper.SendApiResponseV1(c, nil, "updated successfully!")
// }

// UpdateCompanyUser godoc
// @Summary Update company user
// @Description Update details of a company user
// @Tags company_users
// @Accept multipart/form-data
// @Param updateReq formData domain.UpdateUserRequest true "Update user request"
// @Success 200 {object} string
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 404 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/updateCompanyUser [PUT]
// @Security bearerToken
func (h *CompanyUserHandler) UpdateCompanyUser(c *gin.Context) {
	var req domain.UpdateCompanyUserRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	_, err := h.userUseCase.UpdateCompanyUser(c, req)

	helper.SendApiResponseV1(c, err, "updated successfully!")
}
