package db

import (
	"context"
	"errors"
	"fmt"

	"aqary_admin/internal/delivery/rest/middleware"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
)

type CompanyAdminRepo interface {
	GetUser(ctx *gin.Context, id int64) (*sqlc.GetUserRegardlessOfStatusRow, *exceptions.Exception)
	UpdateUserPassword(ctx *gin.Context, args sqlc.UpdateUserPasswordParams) (*sqlc.User, *exceptions.Exception)
	UpdatePlatformUserPassword(ctx *gin.Context, args sqlc.UpdatePlatformUserPasswordParams) (*sqlc.PlatformUser, *exceptions.Exception)
	GetUserIDFromCompanies(ctx *gin.Context, args sqlc.GetUserIDFromCompaniesParams) (int64, *exceptions.Exception)
	UpdateUserPermission(ctx *gin.Context, args sqlc.UpdateUserPermissionParams) (*sqlc.UserCompanyPermission, *exceptions.Exception)

	GetAllSectionPermissionWithoutPagination(ctx *gin.Context) ([]sqlc.SectionPermission, *exceptions.Exception)
	GetAllForSuperUserPermissionBySectionPermissionId(ctx *gin.Context, id int64) ([]sqlc.Permission, *exceptions.Exception)

	GetAllSubSectionByPermissionID(c *gin.Context, id int64) ([]sqlc.SubSection, *exceptions.Exception)
	GetAllSubSectionPermissionBySubSectionButtonID(c *gin.Context, id int64) ([]sqlc.SubSection, *exceptions.Exception)
	GetPermission(c *gin.Context, id int64) (sqlc.Permission, *exceptions.Exception)
	// VerifyingCompanyUser(ctx context.Context, id int64) (*sqlc.User, *exceptions.Exception)
	VerifyAndAvailableUser(ctx context.Context, id int64, q sqlc.Querier) (*sqlc.User, *exceptions.Exception)
}

type companyAdminRepository struct {
	querier sqlc.Querier
}

// VerifyAndAvailableUser implements CompanyAdminRepo.
func (r *companyAdminRepository) VerifyAndAvailableUser(ctx context.Context, id int64, q sqlc.Querier) (*sqlc.User, *exceptions.Exception) {
	user, err := q.VerifyAndAvailableUser(ctx, id)
	if err != nil {
		return nil, buildCompanyAdminErr("VerifyAndAvailableUser", err)
	}
	return &user, nil
}

func NewCompanyAdminRepository(querier sqlc.Querier) CompanyAdminRepo {
	return &companyAdminRepository{
		querier: querier,
	}
}

// GetPermission implements CompanyAdminRepo.
func (r *companyAdminRepository) GetPermission(c *gin.Context, id int64) (sqlc.Permission, *exceptions.Exception) {
	permission, err := r.querier.GetPermission(c, id)
	return permission, buildCompanyAdminErr("GetPermission", err)
}

// VerifyingCompanyUser implements CompanyAdminRepo.
// func (r *companyAdminRepository) VerifyingCompanyUser(ctx context.Context, id int64) (*sqlc.User, *exceptions.Exception) {
// 	user, err :=r.querier.VerifyAndAvailableUser(ctx, id)
// 	if err != nil {
// 		return nil, buildCompanyAdminErr("VerifyAndAvailableUser", err)
// 	}
// 	return &user, nil
// }

// GetAllSubSectionByPermissionID implements CompanyAdminRepo.
func (r *companyAdminRepository) GetAllSubSectionByPermissionID(c *gin.Context, id int64) ([]sqlc.SubSection, *exceptions.Exception) {
	subSection, err := r.querier.GetAllSubSectionByPermissionID(c, id)
	return subSection, buildCompanyAdminErr("GetAllSubSectionByPermissionID", err)
}

// GetAllSubSectionPermissionBySubSectionButtonID implements CompanyAdminRepo.
func (r *companyAdminRepository) GetAllSubSectionPermissionBySubSectionButtonID(c *gin.Context, id int64) ([]sqlc.SubSection, *exceptions.Exception) {
	subSection, err := r.querier.GetAllSubSectionPermissionBySubSectionButtonID(c, id)
	return subSection, buildCompanyAdminErr("GetAllSubSectionPermissionBySubSectionButtonID", err)

}

func (r *companyAdminRepository) GetUser(ctx *gin.Context, id int64) (*sqlc.GetUserRegardlessOfStatusRow, *exceptions.Exception) {
	user, err := r.querier.GetUserRegardlessOfStatus(ctx, id)
	return &user, buildCompanyAdminErr("GetUser", err)
}

func (r *companyAdminRepository) UpdateUserPassword(ctx *gin.Context, args sqlc.UpdateUserPasswordParams) (*sqlc.User, *exceptions.Exception) {
	user, err := r.querier.UpdateUserPassword(ctx, args)
	return &user, buildCompanyAdminErr("UpdateUserPassword", err)
}

func (r *companyAdminRepository) UpdatePlatformUserPassword(ctx *gin.Context, args sqlc.UpdatePlatformUserPasswordParams) (*sqlc.PlatformUser, *exceptions.Exception) {
	user, err := r.querier.UpdatePlatformUserPassword(ctx, args)
	return &user, buildCompanyAdminErr("UpdateUserPassword", err)
}

func (r *companyAdminRepository) GetUserIDFromCompanies(ctx *gin.Context, args sqlc.GetUserIDFromCompaniesParams) (int64, *exceptions.Exception) {
	userID, err := r.querier.GetUserIDFromCompanies(ctx, args)
	return userID, buildCompanyAdminErr("GetUserIDFromCompanies", err)
}

func (r *companyAdminRepository) UpdateUserPermission(ctx *gin.Context, args sqlc.UpdateUserPermissionParams) (*sqlc.UserCompanyPermission, *exceptions.Exception) {
	user, err := r.querier.UpdateUserPermission(ctx, args)
	return &user, buildCompanyAdminErr("UpdateUserPermission", err)
}

func (r *companyAdminRepository) GetAllSectionPermissionWithoutPagination(ctx *gin.Context) ([]sqlc.SectionPermission, *exceptions.Exception) {
	sections, err := r.querier.GetAllSectionPermissionWithoutPagination(ctx)
	return sections, buildCompanyAdminErr("GetAllSectionPermissionWithoutPagination", err)
}

func (r *companyAdminRepository) GetAllForSuperUserPermissionBySectionPermissionId(ctx *gin.Context, id int64) ([]sqlc.Permission, *exceptions.Exception) {
	permissions, err := r.querier.GetAllForSuperUserPermissionBySectionPermissionId(ctx, id)
	return permissions, buildCompanyAdminErr("GetAllForSuperUserPermissionBySectionPermissionId", err)
}

func buildCompanyAdminErr(name string, err error) *exceptions.Exception {
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode)
		}
		middleware.IncrementServerErrorCounter(fmt.Errorf("[users.repo.%v] error:%v", name, err).Error())
		return exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}
	return nil
}
