package user_handler

import (
	"aqary_admin/internal/delivery/rest/helper"
	domain "aqary_admin/internal/domain/requests/user"
	_ "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"

	"strconv"

	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	_ "github.com/jackc/pgx/v5/pgtype"
)

// SwaggerUser is a wrapper for sqlc.User
// swagger:model
type SwaggerUser sqlc.User

// AddCompanyAdminPermission godoc
// @Summary AddCompanyAdminPermission
// @Description AddCompanyAdminPermission
// @Tags company_admin
// @Param request body domain.AddCompanyAdminPermissionRequest true "AddCompanyAdminPermissionRequest"
// @Success 200 {object} sqlc.User
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/addCompanyAdminPermission [POST]
// @Security bearerToken

func (h *UserHandler) AddCompanyAdminPermission(c *gin.Context) {
	var req domain.AddCompanyAdminPermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		msg := utils.CustomBindingFormError(err, req)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, msg), nil)
		return
	}

	updatedUser, err := h.UserUseCase.AddCompanyAdminPermission(c, req)
	helper.SendApiResponseV1(c, err, updatedUser)
}

// GetSingleUser godoc
// @Summary GetSingleUser
// @Description GetSingleUser
// @Tags users
// @Param id path int true "User ID"
// @Success 200 {object} response.UserOutput
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getSingleUser/{id} [GET]
// @Security bearerToken
func (h *UserHandler) GetSingleUser(c *gin.Context) {
	idString, err := c.Params.Get("id")
	if !err {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "id is invalid"), nil)
		return
	}

	id, errr := strconv.Atoi(idString)
	if errr != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "cannot convert id"), nil)
		return
	}

	var req domain.GetSingleUserReq
	if er := c.ShouldBind(&req); er != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, er.Error()), nil)
	}

	output, er := h.UserUseCase.GetSingleUser(c, int64(id), req)
	helper.SendApiResponseV1(c, er, output)
}
