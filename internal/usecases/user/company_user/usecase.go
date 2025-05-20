package companyuser_usecase

import (
	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

type CompanyUserUseCase interface {
	CreateCompanyUser(c *gin.Context, req domain.CreateUserReq) (any, *exceptions.Exception)
	GrandPermissionToCompanyAdmin(ctx *gin.Context, req domain.Request) (*sqlc.UserCompanyPermission, *exceptions.Exception)

	GetAllCompanyUser(c *gin.Context, req domain.GetCompanyUserReq) (any, int64, *exceptions.Exception)
	GetCompanyUser(c *gin.Context, req domain.GetASingleUserReq) (any, *exceptions.Exception)
	GetCompanyOfUser(c *gin.Context, userID int64) (sqlc.CompanyUser, *exceptions.Exception)

	// status
	GetCompanyUsersByStatus(c *gin.Context, req domain.GetUsersByStatusReq) ([]response.GetUsersByStatusResponse, int64, *exceptions.Exception)

	// updates
	GetCountCompanyUsers(ctx *gin.Context) (*response.UserCountOutput, *exceptions.Exception)
	ResetCompanyUserPassword(ctx *gin.Context, req domain.ResetReq) *exceptions.Exception
	// UpdateCompanyUserByStatus(ctx *gin.Context, req domain.UpdateUserByStatusReq) *exceptions.Exception

	UpdateCompanyUser(ctx *gin.Context, req domain.UpdateCompanyUserRequest) (any, *exceptions.Exception)

	// GetCurrentSubscriptionQuota(c *gin.Context, req domain.GetSingleUserReq) (any, *exceptions.Exception)
	GetUserTypeForCompanyUserPage(c *gin.Context) (any, *exceptions.Exception)

	GetVerifyContants(c *gin.Context) any
	UpdateUserVerification(c *gin.Context, req domain.UpdateUserVerificationReq) (*sqlc.User, *exceptions.Exception)

	GetCompanyUserPermission(c *gin.Context, req domain.Request) (any, *exceptions.Exception)
	GetUserLicenses(c *gin.Context, userID int64) ([]domain.UserLicenseOutput, *exceptions.Exception)
	UserLicenseVerification(c *gin.Context, req domain.CreateUserLicenseVerficiationReq) (*string, *exceptions.Exception)

	SetTeamLeader(c *gin.Context, req domain.SetTeamLeaderReq) (any, *exceptions.Exception)
	SetUserPackage(c *gin.Context, req domain.SetUserPackageReq) (any, *exceptions.Exception)
	GetUserPackage(c *gin.Context, req domain.GetUserPackageReq) (any, *exceptions.Exception)
	GetSubscriptionOrderPackageDetailByUserID(c *gin.Context, req domain.GetSubscriptionOrderPackageDetailByUserIDReq) (any, *exceptions.Exception)
	UpdateActiveCompany(c *gin.Context, req domain.UpdateActiveCompanyReq) (*string, *exceptions.Exception)
	GetCompanyRemainingPackage(c *gin.Context, req domain.GetCompanyRemainingPackageReq) (any, *exceptions.Exception)
	AddExpertiseForCompanyUser(c *gin.Context, req domain.AddExpertiseReq) (*string, *exceptions.Exception)
	GetAllCompanyUserExpertise(c *gin.Context, req domain.GetExpertiseByUserReq) (any, int64, *exceptions.Exception)
	GetCompanyUserExpertise(c *gin.Context, req int64) (any, *exceptions.Exception)
	// RemoveCompanyUserExpertise(c *gin.Context, req int64) (*string, *exceptions.Exception)
}
