package permissions_repo

import (
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils/exceptions"
	repoerror "aqary_admin/pkg/utils/repo_error"

	"github.com/gin-gonic/gin"
)

func (r *permissionRepository) CreateSubSection(ctx *gin.Context, arg sqlc.CreateSubSectionParams) (sqlc.SubSection, *exceptions.Exception) {
	subSection, err := r.querier.CreateSubSection(ctx, arg)
	return subSection, repoerror.BuildRepoErr("permission", "CreateSubSection", err)
}

func (r *permissionRepository) GetAllPermission(ctx *gin.Context, arg sqlc.GetAllPermissionParams) ([]sqlc.Permission, *exceptions.Exception) {
	permissions, err := r.querier.GetAllPermission(ctx, arg)
	return permissions, repoerror.BuildRepoErr("permission", "GetAllPermission", err)
}

func (r *permissionRepository) GetCountAllPermissionSectionIds(ctx *gin.Context) (int64, *exceptions.Exception) {
	count, err := r.querier.GetCountAllPermissionSectionIds(ctx)
	return count, repoerror.BuildRepoErr("permission", "GetCountAllPermissionSectionIds", err)
}

func (r *permissionRepository) GetAllIDANDPermissionsFromSubSectionPermissionWithoutPagination(ctx *gin.Context) ([]sqlc.GetAllIDANDPermissionsFromSubSectionPermissionWithoutPaginationRow, *exceptions.Exception) {
	subSections, err := r.querier.GetAllIDANDPermissionsFromSubSectionPermissionWithoutPagination(ctx)
	return subSections, repoerror.BuildRepoErr("permission", "GetAllIDANDPermissionsFromSubSectionPermissionWithoutPagination", err)
}

func (r *permissionRepository) CountAllSubSection(ctx *gin.Context) (int64, *exceptions.Exception) {
	count, err := r.querier.CountAllSubSection(ctx)
	return count, repoerror.BuildRepoErr("permission", "CountAllSubSection", err)
}

func (r *permissionRepository) UpdateSubSection(ctx *gin.Context, arg sqlc.UpdateSubSectionParams) (sqlc.SubSection, *exceptions.Exception) {
	subSection, err := r.querier.UpdateSubSection(ctx, arg)
	return subSection, repoerror.BuildRepoErr("permission", "UpdateSubSection", err)
}

func (r *permissionRepository) DeleteAllSubSection(ctx *gin.Context, ids []int64) *exceptions.Exception {
	err := r.querier.DeleteAllSubSection(ctx, ids)
	return repoerror.BuildRepoErr("permission", "DeleteAllSubSection", err)
}

func (r *permissionRepository) DeleteSubSection(ctx *gin.Context, id int64) *exceptions.Exception {
	err := r.querier.DeleteSubSection(ctx, id)
	return repoerror.BuildRepoErr("permission", "DeleteSubSection", err)
}

func (r *permissionRepository) GetAllNestedSubSectionPermissonByButtonID(ctx *gin.Context, id int64) ([]sqlc.SubSection, *exceptions.Exception) {
	subSections, err := r.querier.GetAllNestedSubSectionPermissonByButtonID(ctx, id)
	return subSections, repoerror.BuildRepoErr("permission", "GetAllNestedSubSectionPermissonByButtonID", err)
}
