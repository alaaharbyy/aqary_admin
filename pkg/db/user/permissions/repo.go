package permissions_repo

import (
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils/exceptions"
	repoerror "aqary_admin/pkg/utils/repo_error"
	"context"

	"github.com/gin-gonic/gin"
)

type PermissionRepo interface {
	CreatePermission(ctx *gin.Context, arg sqlc.CreatePermissionParams, q sqlc.Querier) (*sqlc.Permission, *exceptions.Exception)
	GetPermissionByTitle(ctx *gin.Context, title string) (sqlc.Permission, *exceptions.Exception)
	UpdatePermission(ctx *gin.Context, arg sqlc.UpdatePermissionParams) (sqlc.Permission, *exceptions.Exception)
	DeletePermission(ctx *gin.Context, id int64) *exceptions.Exception
	GetPermissionBySectionID(ctx *gin.Context, sectionID int64) ([]int64, *exceptions.Exception)
	GetAllSectionPermissionMV(ctx *gin.Context, limit, offset int64, search string) ([]sqlc.SectionPermissionMv, *exceptions.Exception)
	GetCountAllSectionPermissionMV(ctx *gin.Context, search string) (int64, *exceptions.Exception)
	GetAllSectionPermissionWithoutPaginationMV(ctx *gin.Context, search string) ([]sqlc.SectionPermissionMv, *exceptions.Exception)
	GetRolePermissionByRole(ctx *gin.Context, roleID int64) (sqlc.RolesPermission, *exceptions.Exception)
	GetAllSubSectionByPermissionIDMV(ctx *gin.Context, args sqlc.GetAllSubSectionByPermissionIDMVWithRelationParams) ([]sqlc.SubSectionMv, *exceptions.Exception)
	GetAllSubSectionPermissionBySubSectionButtonIDMV(ctx *gin.Context, args sqlc.GetAllSubSectionPermissionBySubSectionButtonIDMVParams) ([]sqlc.SubSectionMv, *exceptions.Exception)

	GetAllPermissionBySectionPermissionId(ctx *gin.Context, sectionPermissionID int64) ([]sqlc.Permission, *exceptions.Exception)
	GetAllSectionPermissionFromPermissionIDs(ctx context.Context, isUserID int64, permissions []int64) ([]sqlc.SectionPermissionMv, *exceptions.Exception)

	GetAllForSuperUserPermissionBySectionPermissionIdMV(ctx *gin.Context, sectionPermissionID int64, userId int64, allPermissions []int64) ([]sqlc.PermissionsMv, *exceptions.Exception)

	// New role permission methods
	CreateRolePermission(ctx *gin.Context, arg sqlc.CreateRolePermissionParams) (sqlc.RolesPermission, *exceptions.Exception)
	// GetRolePermissionByRole(ctx *gin.Context, roleID int64) (sqlc.RolePermission, *exceptions.Exception)
	GetAllRolePermission(ctx *gin.Context, arg sqlc.GetAllRolePermissionParams) ([]sqlc.GetAllRolePermissionRow, *exceptions.Exception)
	GetCountAllRolePermission(ctx *gin.Context, search string) (int64, *exceptions.Exception)
	UpdateRolePermission(ctx *gin.Context, arg sqlc.UpdateRolePermissionParams) (sqlc.RolesPermission, *exceptions.Exception)
	DeleteRolePermission(ctx *gin.Context, id int64) *exceptions.Exception
	GetRolePermission(ctx *gin.Context, id int64) (sqlc.RolesPermission, *exceptions.Exception)
	DeleteOnePermissionInRole(ctx *gin.Context, arg sqlc.DeleteOnePermissionInRoleParams) (sqlc.RolesPermission, *exceptions.Exception)
	GetAllRolePermissionWithoutPagination(ctx *gin.Context) ([]sqlc.RolesPermission, *exceptions.Exception)

	//
	CreateSectionPermission(ctx *gin.Context, arg sqlc.CreateSectionPermissionParams, q sqlc.Querier) (*sqlc.SectionPermission, *exceptions.Exception)
	GetSectionPermissionByTitle(ctx *gin.Context, title string) (sqlc.SectionPermission, *exceptions.Exception)
	GetAllSectionPermission(ctx *gin.Context, arg sqlc.GetAllSectionPermissionParams) ([]sqlc.SectionPermission, *exceptions.Exception)
	GetCountAllSectionPermission(ctx *gin.Context, search string) (int64, *exceptions.Exception)
	// GetAllSectionPermissionWithoutPagination(ctx *gin.Context) ([]sqlc.SectionPermission, *exceptions.Exception)
	// GetSectionPermission(ctx *gin.Context, id int64) (sqlc.SectionPermission, *exceptions.Exception)
	UpdateSectionPermission(ctx *gin.Context, arg sqlc.UpdateSectionPermissionParams) (sqlc.SectionPermission, *exceptions.Exception)
	DeleteSectionPermission(c *gin.Context, id int64) (*string, *exceptions.Exception)

	// sub section permission
	CreateSubSection(ctx *gin.Context, arg sqlc.CreateSubSectionParams) (sqlc.SubSection, *exceptions.Exception)
	GetAllPermission(ctx *gin.Context, arg sqlc.GetAllPermissionParams) ([]sqlc.Permission, *exceptions.Exception)
	GetCountAllPermissionSectionIds(ctx *gin.Context) (int64, *exceptions.Exception)
	GetAllIDANDPermissionsFromSubSectionPermissionWithoutPagination(ctx *gin.Context) ([]sqlc.GetAllIDANDPermissionsFromSubSectionPermissionWithoutPaginationRow, *exceptions.Exception)
	CountAllSubSection(ctx *gin.Context) (int64, *exceptions.Exception)
	// GetSubSection(ctx *gin.Context, id int64) (sqlc.SubSection, *exceptions.Exception)
	UpdateSubSection(ctx *gin.Context, arg sqlc.UpdateSubSectionParams) (sqlc.SubSection, *exceptions.Exception)
	DeleteAllSubSection(ctx *gin.Context, ids []int64) *exceptions.Exception
	DeleteSubSection(ctx *gin.Context, id int64) *exceptions.Exception

	// ---------------------
	GetAllNestedSubSectionPermissonByButtonID(ctx *gin.Context, id int64) ([]sqlc.SubSection, *exceptions.Exception)

	GetAllPermissionsNoPagination(ctx context.Context) ([]sqlc.Permission, *exceptions.Exception)
	GetAllSubSectionPermissionsNoPagination(ctx context.Context) ([]sqlc.SubSection, *exceptions.Exception)
}

type permissionRepository struct {
	querier sqlc.Querier
}

// GetAllSectionPermissionFromPermissionIDs implements PermissionRepo.
func (r *permissionRepository) GetAllSectionPermissionFromPermissionIDs(ctx context.Context, isUserID int64, permissions []int64) ([]sqlc.SectionPermissionMv, *exceptions.Exception) {

	section, err := r.querier.GetAllSectionPermissionFromPermissionIDs(ctx, sqlc.GetAllSectionPermissionFromPermissionIDsParams{
		IsSuperUser:  isUserID,
		PermissionID: permissions,
	})
	if err != nil {
		return nil, repoerror.BuildRepoErr("", "GetAllSectionPermissionFromPermissionIDs", err)
	}

	return section, nil

}

func NewPermissionRepository(querier sqlc.Querier) PermissionRepo {
	return &permissionRepository{
		querier: querier,
	}
}
