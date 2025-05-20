package user_handler

import (
	"strconv"

	"aqary_admin/internal/delivery/rest/helper"
	domain "aqary_admin/internal/domain/requests/user"
	_ "aqary_admin/internal/domain/responses/user"
	_ "aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

// GetAllUserRequest godoc
// @Summary GetAllPendingUser
// @Description GetAllPendingUser
// @Tags pending_user
// @Param UserTypeRequest body domain.GetAllUserRequest true "GetAllUserRequest"
// @Success 200 {object} []response.AllPendingUserOutput
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/getAllPeddingUsers [GET]
// @Security bearerToken
func (h *UserHandler) GetAllPendingUser(c *gin.Context) {
	var req domain.GetAllUserRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "please provide all the required fields"), nil)
		return
	}

	outputs, count, err := h.UserUseCase.GetAllPendingUser(c, req)
	helper.SendApiResponseWithCountV1(c, err, outputs, count)

}

// DeletePendingUser godoc
// @Summary DeletePendingUser
// @Description DeletePendingUser
// @Tags pending_user
// @Success 200 {object} string
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/deletePendingUser [DELETE]
// @Security bearerToken
func (h *UserHandler) DeletePendingUser(c *gin.Context) {
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

	outputs, er := h.UserUseCase.DeletePendingUser(c, int64(id))
	helper.SendApiResponseV1(c, er, outputs)

}
