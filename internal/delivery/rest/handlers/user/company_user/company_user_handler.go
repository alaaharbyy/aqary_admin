package companyuser_handler

import (
	"log"
	"strconv"

	"aqary_admin/internal/delivery/rest/helper"
	domain "aqary_admin/internal/domain/requests/user"
	_ "aqary_admin/internal/domain/responses/user"
	_ "aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

// CreateCompanyUser godoc
// @Summary Create a new company user
// @Description Create a new company user with the provided details
// @Tags company-users
// @Accept json
// @Produce json
// @Param request body domain.CreateUserReq true "User details"
// @Success 200 {object} string
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/createCompanyUser [post]
// @Security bearerToken
func (h *CompanyUserHandler) CreateCompanyUser(c *gin.Context) {
	var req domain.CreateUserReq
	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[company_user.handler-CreateCompanyUser] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	companyUser, err := h.userUseCase.CreateCompanyUser(c, req)
	helper.SendApiResponseV1(c, err, companyUser)
}

// GrandPermissionToCompanyAdmin godoc
// @Summary Grant permissions to a company admin
// @Description Grant specified permissions to a company admin
// @Tags company-users
// @Accept json
// @Produce json
// @Param request body domain.Request true "Permission details"
// @Success 200 {object} string
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/grantCompanyAdminPermissions [post]
// @Security bearerToken
func (h *CompanyUserHandler) GrandPermissionToCompanyAdmin(c *gin.Context) {
	var req domain.Request
	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[company_user.handler-GrandPermissionToCompanyAdmin] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	updatedUser, err := h.userUseCase.GrandPermissionToCompanyAdmin(c, req)
	helper.SendApiResponseV1(c, err, updatedUser)
}

// // SwaggerGetRemainingCompanyQuotaRow is a wrapper for sqlc.GetRemainingCompanyQuotaRow
// // swagger:model
// type SwaggerGetRemainingCompanyQuotaRow sqlc.GetRemainingCompanyQuotaRow

// // GetCurrentSubscriptionQuota godoc
// // @Summary GetCurrentSubscriptionQuota
// // @Description GetCurrentSubscriptionQuota
// // @Tags company-users
// // @Accept json
// // @Produce json
// // @Param request body domain.GetSingleUserReq true "Permission details"
// // @Success 200 {object} []sqlc.GetRemainingCompanyQuotaRow
// // @Failure 400 {object} utils.ErrResponseSwagger
// // @Failure 500 {object} utils.ErrResponseSwagger
// // @Router /api/user/getCurrentSubscriptionQuota [GET]
// // @Security bearerToken
// func (h *CompanyUserHandler) GetCurrentSubscriptionQuota(c *gin.Context) {
// 	var req domain.GetSingleUserReq
// 	if err := c.ShouldBind(&req); err != nil {
// 		log.Printf("[company_user.handler-GetCurrentSubscriptionQuota] While binding request Error:%s ", err)
// 		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
// 		return
// 	}

// 	sub, err := h.userUseCase.GetCurrentSubscriptionQuota(c, req)
// 	if err != nil {
// 		helper.SendApiResponseV1(c, err, nil)
// 		return
// 	}

// 	helper.SendApiResponseV1(c, nil, sub)
// }

// TODO:  to add doc
func (h *CompanyUserHandler) GetUserTypeForCompanyUserPage(c *gin.Context) {

	sub, err := h.userUseCase.GetUserTypeForCompanyUserPage(c)
	if err != nil {
		helper.SendApiResponseV1(c, err, nil)
		return
	}

	helper.SendApiResponseV1(c, nil, sub)
}

// TODO:  add doc
func (h *CompanyUserHandler) GetCompanyVerifyStatus(c *gin.Context) {

	statuses := h.userUseCase.GetVerifyContants(c)
	helper.SendApiResponseV1(c, nil, statuses)

}

// TODO:  add doc
func (h *CompanyUserHandler) SetUserPackage(c *gin.Context) {

	var req domain.SetUserPackageReq
	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[company_user.handler-SetUserPackage] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	packages, err := h.userUseCase.SetUserPackage(c, req)
	if err != nil {
		helper.SendApiResponseV1(c, err, nil)
		return
	}

	helper.SendApiResponseV1(c, nil, packages)

}

// TODO:  add doc
func (h *CompanyUserHandler) GetUserPackage(c *gin.Context) {

	var req domain.GetUserPackageReq
	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[company_user.handler-GetUserPackage] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	packages, err := h.userUseCase.GetUserPackage(c, req)
	if err != nil {
		helper.SendApiResponseV1(c, err, nil)
		return
	}

	helper.SendApiResponseV1(c, nil, packages)

}

// TODO:  add doc
func (h *CompanyUserHandler) UpdateActiveCompany(c *gin.Context) {

	var req domain.UpdateActiveCompanyReq
	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[company_user.handler-UpdateActiveCompany] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	msg, err := h.userUseCase.UpdateActiveCompany(c, req)
	if err != nil {
		helper.SendApiResponseV1(c, err, nil)
		return
	}

	helper.SendApiResponseV1(c, nil, msg)

}

func (h *CompanyUserHandler) GetCompanyRemainingPackage(c *gin.Context) {

	var req domain.GetCompanyRemainingPackageReq
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	msg, err := h.userUseCase.GetCompanyRemainingPackage(c, req)

	helper.SendApiResponseV1(c, err, msg)

}

func (h *CompanyUserHandler) AddExpertiseForCompanyUser(c *gin.Context) {
	var req domain.AddExpertiseReq
	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[company_user.handler-AddExpertiseForCompanyUser] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	resp, err := h.userUseCase.AddExpertiseForCompanyUser(c, req)
	helper.SendApiResponseV1(c, err, resp)
}

func (h *CompanyUserHandler) GetAllCompanyUserExpertise(c *gin.Context) {
	var req domain.GetExpertiseByUserReq
	if err := c.ShouldBind(&req); err != nil {
		log.Printf("[company_user.handler-GetAllCompanyUserExpertise] While binding request Error:%s ", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	data, count, err := h.userUseCase.GetAllCompanyUserExpertise(c, req)
	helper.SendApiResponseWithCountV1(c, err, data, count)
}

func (h *CompanyUserHandler) GetCompanyUserExpertise(c *gin.Context) {
	id, errr := strconv.ParseInt(c.Param("id"), 10, 64)
	if errr != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "id is invalid"), nil)
		return
	}
	data, err := h.userUseCase.GetCompanyUserExpertise(c, id)
	helper.SendApiResponseV1(c, err, data)
}

// func (h *CompanyUserHandler) RemoveCompanyUserExpertise(c *gin.Context) {
// 	id, errr := strconv.ParseInt(c.Param("id"), 10, 64)
// 	if errr != nil {
// 		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "id is invalid"), nil)
// 		return
// 	}
// 	resp, err := h.userUseCase.RemoveCompanyUserExpertise(c, id)
// 	helper.SendApiResponseV1(c, err, resp)
// }
