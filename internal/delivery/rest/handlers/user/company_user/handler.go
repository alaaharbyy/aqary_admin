package companyuser_handler

import (
	userUserCase "aqary_admin/internal/usecases/user"

	"github.com/gin-gonic/gin"
)

type CompanyUserHandler struct {
	userUseCase userUserCase.UserCompositeUseCase
}

// RegisterAuthRoutes implements user_handler.Handler.
func (h *CompanyUserHandler) RegisterAuthRoutes(r *gin.RouterGroup) {

	r.GET("/getCompanyRemainingPackage", h.GetCompanyRemainingPackage)
	r.POST("/createCompanyUser", h.CreateCompanyUser)
	r.POST("/grantCompanyAdminPermissions", h.GrandPermissionToCompanyAdmin)
	r.GET("/getAllCompanyUser", h.GetAllCompanyUser)
	r.GET("/getCompanyUser", h.GetCompanyUser)
	r.GET("/getCompanyOfUser", h.GetCompanyOfUser)
	r.GET("/getCompanyUsersByStatus", h.GetCompanyUsersByStatus)
	r.PUT("/updateCompanyUserByStatus", h.UpdateCompanyUserByStatus)
	r.PUT("/updateCompanyUser", h.UpdateCompanyUser)
	r.GET("/getCountCompanyUsers", h.GetCountCompanyUsers)
	r.PUT("/resetCompanyUserPassword", h.ResetCompanyUserPassword)

	// r.GET("/getCurrentSubscriptionQuota", h.GetCurrentSubscriptionQuota)
	r.GET("/getUserTypeForCompanyUserPage", h.GetUserTypeForCompanyUserPage)
	r.GET("/getCompanyUserVerifyStatuses", h.GetCompanyVerifyStatus)
	r.PUT("/updateUserVerification", h.UpdateUserVerification)
	r.GET("/getCompanyUserPermission", h.GetCompanyUserPermission)
	r.GET("/getUserLicenses/:id", h.GetUserLicenses)
	r.POST("/verifiyUserLicense", h.UserLicenseVerification)
	r.POST("/setTeamLead", h.SetTeamLeader)

	r.GET("/getUserPackage", h.GetUserPackage)
	r.POST("/setUserPackage", h.SetUserPackage)

	r.GET("/getSubscriptionOrderPackageDetailByUserID", h.GetSubscriptionOrderPackageDetailByUserID)
	r.PUT("/updateActiveCompany", h.UpdateActiveCompany)

	// company user expertise
	r.POST("/addExpertiseForCompanyUser", h.AddExpertiseForCompanyUser)
	r.GET("/getCompanyUserExpertise", h.GetAllCompanyUserExpertise)
	r.GET("/getCompanyUserExpertise/:id", h.GetCompanyUserExpertise)
	// r.DELETE("/removeCompanyUserExpertise/:id", h.RemoveCompanyUserExpertise)

}

func NewCompanyUserHandler(userUseCase userUserCase.UserCompositeUseCase) *CompanyUserHandler {
	return &CompanyUserHandler{
		userUseCase: userUseCase,
	}
}

// RegisterNonAuthRoutes implements user_handler.Handler.
func (h *CompanyUserHandler) RegisterNonAuthRoutes(r *gin.RouterGroup) {

}
