package user_handler

import (
	"aqary_admin/internal/delivery/rest/helper"
	domain "aqary_admin/internal/domain/requests/user"
	_ "aqary_admin/internal/domain/responses/user"
	_ "aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

// GetAllOtherUser godoc
// @Summary GetAllOtherUser
// @Description GetAllOtherUser
// @Tags other_user
// @Param UserTypeRequest body domain.GetAllUserRequest true "GetAllUserRequest"
// @Success 200 {object} []response.AllUserOutput
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/getAllOtherUsers [GET]
// @Security bearerToken
func (h *UserHandler) GetAllOtherUser(c *gin.Context) {
	var req domain.GetAllUserRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "please provide all the required fields"), nil)
		return
	}

	outputs, count, err := h.UserUseCase.GetAllOtherUser(c, req)
	helper.SendApiResponseWithCountV1(c, err, outputs, count)
}

// GetAllOtherUserByCountry godoc
// @Summary GetAllOtherUserByCountry
// @Description GetAllOtherUserByCountry
// @Tags other_user
// @Param UserTypeRequest body domain.GetAllOtherUserByCountryRequest true "GetAllOtherUserByCountryRequest"
// @Success 200 {object} []response.AllUserOutput
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/getAllOtherUsersByCountry [GET]
// @Security bearerToken
func (h *UserHandler) GetAllOtherUserByCountry(c *gin.Context) {
	var req domain.GetAllOtherUserByCountryRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "please provide all the required fields"), nil)
		return
	}

	outputs, count, err := h.UserUseCase.GetAllOtherUserByCountry(c, req)
	helper.SendApiResponseWithCountV1(c, err, outputs, count)
}
