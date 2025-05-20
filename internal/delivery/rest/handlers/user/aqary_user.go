package user_handler

import (
	"aqary_admin/internal/delivery/rest/helper"
	domain "aqary_admin/internal/domain/requests/user"
	"log"

	// _ "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"

	_ "aqary_admin/internal/domain/responses/user"
	_ "aqary_admin/pkg/utils"

	"strconv"

	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

// GetAllAqaryUser godoc
// @Summary Get all Aqary users
// @Description Get a list of all Aqary users with pagination
// @Tags aqary_users
// @Param page_size query int true "Page Size"
// @Param page_no query int true "Page Number"
// @Param search query string false "Search string"
// @Success 200 {object} []response.AllUserOutput
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/getAllAqaryUsers [GET]
func (h *UserHandler) GetAllAqaryUser(c *gin.Context) {
	var req domain.GetAllUserRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}
	users, count, err := h.UserUseCase.GetAllAqaryUser(c, req)
	helper.SendApiResponseWithCountV1(c, err, users, count)
}

// GetAllAqaryUserByCountry godoc
// @Summary Get all Aqary users by country
// @Description Get a list of all Aqary users filtered by country with pagination
// @Tags aqary_users
// @Param page_size query int true "Page Size"
// @Param page_no query int true "Page Number"
// @Param country_id query int true "Country ID"
// @Success 200 {object} []response.AllUserOutput
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/getAllAqaryUsersByCountryId [get]
func (h *UserHandler) GetAllAqaryUserByCountry(c *gin.Context) {
	var req domain.GetAllUserByCountryRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	users, count, err := h.UserUseCase.GetAllAqaryUserByCountry(c, req)
	helper.SendApiResponseWithCountV1(c, err, users, count)
}

// GetSingleAqaryUser godoc
// @Summary Get detailed information of a single Aqary user
// @Description Get detailed information of a single Aqary user by ID
// @Tags aqary_users
// @Param id path int true "User ID"
// @Success 200 {object} response.UserOutput
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/getSingleAqaryUser/{id} [get]
func (h *UserHandler) GetSingleAqaryUser(c *gin.Context) {
	id, errr := strconv.ParseInt(c.Param("id"), 10, 64)
	if errr != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "id is invalid"), nil)
		return
	}

	var req domain.GetSingleUserReq
	if err := c.ShouldBind(&req); err != nil {
		log.Println("resting err", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	user, err := h.UserUseCase.GetSingleAqaryUser(c, id, req)
	helper.SendApiResponseV1(c, err, user)
}

// UpdateAqaryUser godoc
// @Summary Update an Aqary user
// @Description Update details of an Aqary user
// @Tags aqary_users
// @Param id path int true "User ID"
// @Param user body domain.UpdateUserRequest true "User details to update"
// @Success 200 {object} response.UpdatedUserOutput
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/updateAqaryUser/{id} [put]
func (h *UserHandler) UpdateAqaryUser(c *gin.Context) {
	id, errr := strconv.ParseInt(c.Param("id"), 10, 64)
	if errr != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "id is invalid"), nil)

		return
	}

	var req domain.UpdateUserRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	updatedUser, err := h.UserUseCase.UpdateAqaryUser(c, id, req)
	helper.SendApiResponseV1(c, err, updatedUser)
}

// DeleteUser godoc
// @Summary Delete an Aqary user
// @Description Delete an Aqary user by ID
// @Tags aqary_users
// @Param id path int true "User ID"
// @Success 200 {object} string
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/deleteAqaryUser/{id} [delete]
func (h *UserHandler) DeleteUser(c *gin.Context) {
	id, errr := strconv.ParseInt(c.Param("id"), 10, 64)
	if errr != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "id is invalid"), nil)
		return
	}

	err := h.UserUseCase.DeleteUser(c, id)
	helper.SendApiResponseV1(c, err, "User successfully deleted")
}

// RestoreUser godoc
// @Summary Restore a deleted Aqary user
// @Description Restore a previously deleted Aqary user by ID
// @Tags aqary_users
// @Param id path int true "User ID"
// @Success 200 {object} string
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/restoreAqaryUser/{id} [post]
func (h *UserHandler) RestoreUser(c *gin.Context) {
	id, errr := strconv.ParseInt(c.Param("id"), 10, 64)
	if errr != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "id is invalid"), nil)

		return
	}

	err := h.UserUseCase.RestoreUser(c, id)
	helper.SendApiResponseV1(c, err, "User successfully restored")
}

// GetAllDeletedAqaryUser godoc
// @Summary Get all deleted Aqary users
// @Description Get a list of all deleted Aqary users with pagination
// @Tags aqary_users
// @Param page_size query int true "Page Size"
// @Param page_no query int true "Page Number"
// @Param search query string false "Search string"
// @Success 200 {object} []response.DeletedAqaryUserOutput
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/getAllDeletedAqaryUser [get]
func (h *UserHandler) GetAllDeletedAqaryUser(c *gin.Context) {
	var req domain.AllDeletedUserRequests
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "id is invalid"), nil)
		return
	}

	users, count, err := h.UserUseCase.GetAllDeletedAqaryUser(c, req)
	helper.SendApiResponseWithCountV1(c, err, users, count)
}

// SwaggerSearchAllAgentRow is a wrapper for sqlc.SearchAllAgentRow
// swagger:model
type SwaggerSearchAllAgentRow sqlc.SearchAllAgentRow

// GetAllDeletedAqaryUserWithoutPagination godoc
// @Summary Get all deleted Aqary users without pagination
// @Description Get a list of all deleted Aqary users without pagination
// @Tags aqary_users
// @Success 200 {object} []response.DeletedAqaryUserOutput
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/getAllDeletedAqaryUserWithoutPagination [get]
func (h *UserHandler) GetAllDeletedAqaryUserWithoutPagination(c *gin.Context) {
	users, count, err := h.UserUseCase.GetAllDeletedAqaryUserWithoutPagination(c)
	helper.SendApiResponseWithCountV1(c, err, users, count)
}

// TODO:  add docs
func (h *UserHandler) GetAllTeamLeaders(c *gin.Context) {
	users, err := h.UserUseCase.GetAllTeamLeaders(c)
	if err != nil {
		helper.SendApiResponseV1(c, err, nil)
		return
	}
	helper.SendApiResponseV1(c, nil, users)
}
