package user_handler

import (
	"log"
	"strconv"

	"aqary_admin/internal/delivery/rest/helper"
	domain "aqary_admin/internal/domain/requests/user"
	_ "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	_ "aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

// SwaggerUserType is a wrapper for sqlc.UserType
// swagger:model
type SwaggerUserType sqlc.UserType

// CreateUserType godoc
// @Summary CreateUserType
// @Description CreateUserType
// @Tags usertype
// @Param UserTypeRequest body domain.UserTypeRequest true "UserTypeRequest"
// @Success 200 {object} sqlc.UserType
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/createusertype [POST]
// @Security bearerToken
func (h *UserHandler) CreateUserType(c *gin.Context) {
	var (
		req domain.UserTypeRequest
	)
	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[user.handler-CreateUserType] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	usertype, err := h.UserUseCase.CreateUserType(c, req)
	helper.SendApiResponseV1(c, err, usertype)
}

// GetAllUserTypes godoc
// @Summary GetAllUserTypes
// @Description GetAllUserTypes
// @Tags usertype
// @Success 200 {object} []sqlc.UserType
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/getallusertype [GET]
// @Security bearerToken
func (h *UserHandler) GetAllUserTypes(c *gin.Context) {
	usertypes, err := h.UserUseCase.GetAllUserTypes(c)
	helper.SendApiResponseV1(c, err, usertypes)
}

func (h *UserHandler) GetAllUserTypesDashBoard(c *gin.Context) {
	usertypes, err := h.UserUseCase.GetAllUserTypeForDashBoard(c)
	helper.SendApiResponseV1(c, err, usertypes)
}

// GetAllUserTypesForWeb godoc
// @Summary GetAllUserTypesForWeb
// @Description GetAllUserTypesForWeb
// @Tags usertype
// @Success 200 {object} []sqlc.UserType
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/getAlluserTypeForWeb [GET]
// @Security bearerToken
func (h *UserHandler) GetAllUserTypesForWeb(c *gin.Context) {
	usertypes, err := h.UserUseCase.GetAllUserTypesForWeb(c)
	helper.SendApiResponseV1(c, err, usertypes)
}

// GetUserType godoc
// @Summary CreateUserType
// @Description CreateUserType
// @Tags usertype
// @Success 200 {object} sqlc.UserType
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/getusertype/:id [GET]
// @Security bearerToken
func (h *UserHandler) GetUserType(c *gin.Context) {
	idString, ok := c.Params.Get("id")
	if !ok {
		log.Printf("[user.handler-GetUserType] invalid id")
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "invalid id"), nil)
	}
	id, err := strconv.Atoi(idString)
	if err != nil {
		log.Printf("[user.handler-GetUserType] invalid id: %v", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "invalid id"), nil)
	}

	usertype, errr := h.UserUseCase.GetUserType(c, int64(id))
	helper.SendApiResponseV1(c, errr, usertype)
}

// UpdateUserType godoc
// @Summary UpdateUserType
// @Description UpdateUserType
// @Tags usertype
// @Param UserTypeRequest body domain.UserTypeRequest true "UserTypeRequest"
// @Success 200 {object} sqlc.UserType
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/updateusertype/:id [PUT]
// @Security bearerToken
func (h *UserHandler) UpdateUserType(c *gin.Context) {
	idString, ok := c.Params.Get("id")
	if !ok {
		log.Printf("[user.handler-UpdateUserType] invalid id")
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "invalid id"), nil)
	}
	id, err := strconv.Atoi(idString)
	if err != nil {
		log.Printf("[user.handler-UpdateUserType] invalid id: %v", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "invalid id"), nil)
	}

	var (
		req domain.UserTypeRequest
	)
	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[user.handler-UpdateUserType] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	usertype, errr := h.UserUseCase.UpdateUserType(c, int64(id), req)
	helper.SendApiResponseV1(c, errr, usertype)
}

// DeleteUserType godoc
// @Summary DeleteUserType
// @Description DeleteUserType
// @Tags usertype
// @Success 200 {object} sqlc.UserType
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/user/deleteusertype/:id [DELETE]
// @Security bearerToken
func (h *UserHandler) DeleteUserType(c *gin.Context) {
	idString, ok := c.Params.Get("id")
	if !ok {
		log.Printf("[user.handler-GetUserType] invalid id")
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "invalid id"), nil)
	}
	id, err := strconv.Atoi(idString)
	if err != nil {
		log.Printf("[user.handler-GetUserType] invalid id: %v", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "invalid id"), nil)
	}

	usertype, errr := h.UserUseCase.DeleteUserType(c, int64(id))
	helper.SendApiResponseV1(c, errr, usertype)
}

func (h *UserHandler) GetActiveUsersByType(c *gin.Context) {
	idString, ok := c.Params.Get("typeid")
	if !ok {
		log.Printf("[user.handler-GetActiveUsersByType] invalid id")
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "invalid id"), nil)
	}
	id, err := strconv.Atoi(idString)
	if err != nil {
		log.Printf("[user.handler-GetActiveUsersByType] invalid id: %v", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "invalid id"), nil)
	}

	var (
		req domain.GetActiveUsersByTypeRequest
	)
	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[user.handler-GetActiveUsersByType] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	activeusers, errr := h.UserUseCase.GetActiveUsersBySubscriberType(c, int64(id), req)
	helper.SendApiResponseV1(c, errr, activeusers)
}

func (h *UserHandler) GetUserDetailsByUserName(c *gin.Context) {
	userDetails, err := h.UserUseCase.GetUserDetailsByUserName(c)
	helper.SendApiResponseV1(c, err, userDetails)
}
