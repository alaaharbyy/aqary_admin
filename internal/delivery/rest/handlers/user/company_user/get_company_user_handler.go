package companyuser_handler

import (
	"aqary_admin/internal/delivery/rest/helper"
	domain "aqary_admin/internal/domain/requests/user"
	_ "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils"

	"errors"
	"strconv"

	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

// SwaggerCompanyUser is a wrapper for sqlc.CompanyUser
// swagger:model
type SwaggerCompanyUser sqlc.CompanyUser

// GetAllCompanyUser godoc
// @Summary Get all company users
// @Description Get a list of all company users with pagination and search
// @Tags company-users
// @Accept json
// @Produce json
// @Param request query domain.GetCompanyUserReq true "Query parameters"
// @Success 200 {object} response.AllCompanyUserRes
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getAllCompanyUser [GET]
func (h *CompanyUserHandler) GetAllCompanyUser(c *gin.Context) {
	var req domain.GetCompanyUserReq
	if err := c.ShouldBind(&req); err != nil {
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}

	users, totalCount, err := h.userUseCase.GetAllCompanyUser(c, req)
	if err != nil {
		helper.SendApiResponseV1(c, err, nil)
		return
	}

	if users == nil {
		helper.SendApiResponseWithCountV1(c, nil, "company user doesn't exist", 0)
		return
	}

	helper.SendApiResponseWithCountV1(c, nil, users, totalCount)
}

// GetCompanyUser godoc
// @Summary Get a single company user
// @Description Get details of a single company user by ID
// @Tags company-users
// @Accept json
// @Produce json
// @Param id path int true "Company User ID"
// @Success 200 {object} response.GetCompanyUserRes
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getCompanyUser [GET]
func (h *CompanyUserHandler) GetCompanyUser(c *gin.Context) {

	var req domain.GetASingleUserReq
	if err := c.ShouldBind(&req); err != nil {
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}

	user, errr := h.userUseCase.GetCompanyUser(c, req)
	if errr != nil {
		helper.SendApiResponseV1(c, errr, nil)
		return
	}

	helper.SendApiResponseV1(c, nil, user)
}

// GetCompanyOfUser godoc
// @Summary Get company of a user
// @Description Get company details of a user by user ID
// @Tags company-users
// @Accept json
// @Produce json
// @Param user_id query int true "User ID"
// @Success 200 {object} sqlc.CompanyUser
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/users/getCompanyOfUser [GET]
func (h *CompanyUserHandler) GetCompanyOfUser(c *gin.Context) {
	strID, errr := c.GetQuery("user_id")
	if !errr {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "user_id is required"), nil)
		return
	}
	userID, err := strconv.Atoi(strID)
	if err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "user_id is invalid"), nil)
		return
	}

	users, er := h.userUseCase.GetCompanyOfUser(c, int64(userID))
	if er != nil {
		helper.SendApiResponseV1(c, er, nil)
		return
	}

	helper.SendApiResponseV1(c, nil, users)
}

// GetCompanyUsersByStatus godoc
// @Summary Get company users by status
// @Description Get a list of company users filtered by status
// @Tags company-users
// @Accept json
// @Produce json
// @Param request query domain.GetUsersByStatusReq true "Query parameters"
// @Success 200 {object} response.GetUsersByStatusResponse
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getCompanyUsersByStatus [GET]

func (h *CompanyUserHandler) GetCompanyUsersByStatus(c *gin.Context) {
	var req domain.GetUsersByStatusReq
	if err := c.ShouldBind(&req); err != nil {
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}

	users, totalCount, err := h.userUseCase.GetCompanyUsersByStatus(c, req)
	if err != nil {
		if errors.Is(err, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode)) {
			helper.SendApiResponseWithCountV1(c, nil, "company user doesn't exist", 0)
			return
		}
		helper.SendApiResponseV1(c, err, nil)
		return
	}

	if len(users) == 0 {
		helper.SendApiResponseWithCountV1(c, nil, "company user doesn't exist", 0)
		return
	}

	helper.SendApiResponseWithCountV1(c, err, users, totalCount)
}

// TODO:  to add docs
func (h *CompanyUserHandler) UpdateUserVerification(c *gin.Context) {
	var req domain.UpdateUserVerificationReq
	if err := c.ShouldBind(&req); err != nil {
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}

	users, err := h.userUseCase.UpdateUserVerification(c, req)
	if err != nil {
		helper.SendApiResponseV1(c, err, nil)
		return
	}

	helper.SendApiResponseV1(c, nil, users)
}

// TODO:  to add docs
func (h *CompanyUserHandler) GetCompanyUserPermission(c *gin.Context) {
	var req domain.Request
	if err := c.ShouldBind(&req); err != nil {
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}

	users, err := h.userUseCase.GetCompanyUserPermission(c, req)
	if err != nil {
		helper.SendApiResponseV1(c, err, nil)
		return
	}

	helper.SendApiResponseV1(c, nil, users)
}

// TODO:  to add docs
func (h *CompanyUserHandler) GetUserLicenses(c *gin.Context) {
	var req domain.GetUserLicensesReq
	if err := c.ShouldBindUri(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	// getUserLicenses
	userLicenses, licenseErr := h.userUseCase.GetUserLicenses(c, req.ID)
	if licenseErr != nil {
		helper.SendApiResponseV1(c, licenseErr, nil)
		return
	}

	if len(userLicenses) == 0 {
		helper.SendApiResponseV1(c, nil, "no license found")
		return
	}

	helper.SendApiResponseV1(c, nil, userLicenses)
}

// TODO:  to add docs
func (h *CompanyUserHandler) UserLicenseVerification(c *gin.Context) {

	var req domain.CreateUserLicenseVerficiationReq
	if err := c.ShouldBind(&req); err != nil {
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}

	msg, err := h.userUseCase.UserLicenseVerification(c, req)
	helper.SendApiResponseV1(c, err, msg)
}

// TODO:  to add docs
func (h *CompanyUserHandler) SetTeamLeader(c *gin.Context) {
	var req domain.SetTeamLeaderReq
	if err := c.ShouldBind(&req); err != nil {
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}

	// getUserLicenses
	userLicensesVerification, licenseErr := h.userUseCase.SetTeamLeader(c, req)
	if licenseErr != nil {
		helper.SendApiResponseV1(c, licenseErr, nil)
		return
	}
	helper.SendApiResponseV1(c, nil, userLicensesVerification)
}

// TODO:  to add docs
func (h *CompanyUserHandler) GetSubscriptionOrderPackageDetailByUserID(c *gin.Context) {
	var req domain.GetSubscriptionOrderPackageDetailByUserIDReq
	if err := c.ShouldBind(&req); err != nil {
		errMsg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errMsg), nil)
		return
	}

	// getUserLicenses
	subs, subsErr := h.userUseCase.GetSubscriptionOrderPackageDetailByUserID(c, req)
	if subsErr != nil {
		helper.SendApiResponseV1(c, subsErr, nil)
		return
	}
	helper.SendApiResponseV1(c, nil, subs)
}
