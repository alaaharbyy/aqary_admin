package permissions_repo

import (
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils"
	auth_utils "aqary_admin/pkg/utils/auth"
	"aqary_admin/pkg/utils/exceptions"
	repoerror "aqary_admin/pkg/utils/repo_error"
	"context"
	"log"

	"github.com/gin-gonic/gin"
)

func (r *permissionRepository) CreatePermission(ctx *gin.Context, arg sqlc.CreatePermissionParams, q sqlc.Querier) (*sqlc.Permission, *exceptions.Exception) {
	r.querier, q = auth_utils.CheckAuthForTests(ctx, r.querier, q)
	log.Println("testing error ", "::", arg)
	r.querier, q = auth_utils.CheckAuthForTests(ctx, r.querier, q)
	permission, err := q.CreatePermission(ctx, arg)
	log.Println("testing error ", err, "::", arg)
	return &permission, repoerror.BuildRepoErr("permission", "CreatePermission", err)
}

func (r *permissionRepository) GetPermissionByTitle(ctx *gin.Context, title string) (sqlc.Permission, *exceptions.Exception) {
	permission, err := r.querier.GetPermissionBySubTitle(ctx, title)
	return permission, repoerror.BuildRepoErr("permission", "GetPermissionBySubTitle", err)
}

func (r *permissionRepository) GetPermission(ctx *gin.Context, id int64) (sqlc.Permission, *exceptions.Exception) {
	permission, err := r.querier.GetPermission(ctx, id)
	return permission, repoerror.BuildRepoErr("permission", "GetPermission", err)
}

func (r *permissionRepository) UpdatePermission(ctx *gin.Context, arg sqlc.UpdatePermissionParams) (sqlc.Permission, *exceptions.Exception) {
	permission, err := r.querier.UpdatePermission(ctx, arg)
	return permission, repoerror.BuildRepoErr("permission", "UpdatePermission", err)
}

func (r *permissionRepository) DeletePermission(ctx *gin.Context, id int64) *exceptions.Exception {
	err := r.querier.DeletePermission(ctx, id)
	return repoerror.BuildRepoErr("permission", "DeletePermission", err)
}

func (r *permissionRepository) GetPermissionBySectionID(ctx *gin.Context, sectionID int64) ([]int64, *exceptions.Exception) {
	permissions, err := r.querier.GetPermissionBySectionID(ctx, sectionID)
	return permissions, repoerror.BuildRepoErr("permission", "GetPermissionBySectionID", err)
}

func (r *permissionRepository) GetAllSectionPermissionMV(ctx *gin.Context, limit, offset int64, search string) ([]sqlc.SectionPermissionMv, *exceptions.Exception) {
	sections, err := r.querier.GetAllSectionPermissionMV(ctx, sqlc.GetAllSectionPermissionMVParams{
		Limit:  int32(limit),
		Offset: int32(offset),
		Search: utils.AddPercent(search),
	})
	return sections, repoerror.BuildRepoErr("permission", "GetAllSectionPermissionMV", err)
}

func (r *permissionRepository) GetCountAllSectionPermissionMV(ctx *gin.Context, search string) (int64, *exceptions.Exception) {
	count, err := r.querier.GetCountAllSectionPermissionMV(ctx, utils.AddPercent(search))
	return count, repoerror.BuildRepoErr("permission", "GetCountAllSectionPermissionMV", err)
}

func (r *permissionRepository) GetAllSectionPermissionWithoutPaginationMV(ctx *gin.Context, search string) ([]sqlc.SectionPermissionMv, *exceptions.Exception) {
	sections, err := r.querier.GetAllSectionPermissionWithoutPaginationMV(ctx, utils.AddPercent(search))
	return sections, repoerror.BuildRepoErr("permission", "GetAllSectionPermissionWithoutPaginationMV", err)
}

func (r *permissionRepository) GetRolePermissionByRole(ctx *gin.Context, roleID int64) (sqlc.RolesPermission, *exceptions.Exception) {
	rolePermission, err := r.querier.GetRolePermissionByRole(ctx, roleID)
	return rolePermission, repoerror.BuildRepoErr("permission", "GetRolePermissionByRole", err)
}

func (r *permissionRepository) GetAllSubSectionByPermissionIDMV(ctx *gin.Context, args sqlc.GetAllSubSectionByPermissionIDMVWithRelationParams) ([]sqlc.SubSectionMv, *exceptions.Exception) {
	subSections, err := r.querier.GetAllSubSectionByPermissionIDMVWithRelation(ctx, args)
	return subSections, repoerror.BuildRepoErr("permission", "GetAllSubSectionByPermissionIDMV", err)
}

func (r *permissionRepository) GetAllSubSectionPermissionBySubSectionButtonIDMV(ctx *gin.Context, args sqlc.GetAllSubSectionPermissionBySubSectionButtonIDMVParams) ([]sqlc.SubSectionMv, *exceptions.Exception) {
	subSections, err := r.querier.GetAllSubSectionPermissionBySubSectionButtonIDMV(ctx, args)
	return subSections, repoerror.BuildRepoErr("permission", "GetAllSubSectionPermissionBySubSectionButtonIDMV", err)
}

func (r *permissionRepository) GetAllPermissionBySectionPermissionId(ctx *gin.Context, sectionPermissionID int64) ([]sqlc.Permission, *exceptions.Exception) {
	permissions, err := r.querier.GetAllPermissionBySectionPermissionId(ctx, sectionPermissionID)
	return permissions, repoerror.BuildRepoErr("permission", "GetAllPermissionBySectionPermissionId", err)
}

func (r *permissionRepository) GetAllForSuperUserPermissionBySectionPermissionIdMV(ctx *gin.Context, sectionPermissionID int64, userId int64, allPermissions []int64) ([]sqlc.PermissionsMv, *exceptions.Exception) {
	permissions, err := r.querier.GetAllForSuperUserPermissionBySectionPermissionIdMV(ctx, sqlc.GetAllForSuperUserPermissionBySectionPermissionIdMVParams{
		Issuperuserid:       userId,
		Permission:          allPermissions,
		SectionPermissionID: sectionPermissionID,
	})
	return permissions, repoerror.BuildRepoErr("permission", "GetAllForSuperUserPermissionBySectionPermissionIdMV", err)
}

func (r *permissionRepository) GetAllPermissionsNoPagination(ctx context.Context) ([]sqlc.Permission, *exceptions.Exception) {
	permissions, err := r.querier.GetAllPermissions(ctx)
	return permissions, repoerror.BuildRepoErr("permission", "GetAllPermissionsNoPagination", err)
}

func (r *permissionRepository) GetAllSubSectionPermissionsNoPagination(ctx context.Context) ([]sqlc.SubSection, *exceptions.Exception) {
	subSectionPermissions, err := r.querier.GetAllSubSectionPermissions(ctx)
	return subSectionPermissions, repoerror.BuildRepoErr("permission", "GetAllSubSectionPermissionsNoPagination", err)
}
