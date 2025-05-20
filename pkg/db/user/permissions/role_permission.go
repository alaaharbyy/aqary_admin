package permissions_repo

import (
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils/exceptions"
	repoerror "aqary_admin/pkg/utils/repo_error"

	"github.com/gin-gonic/gin"
)

// / Implement existing permission methods...
func (r *permissionRepository) CreateRolePermission(ctx *gin.Context, arg sqlc.CreateRolePermissionParams) (sqlc.RolesPermission, *exceptions.Exception) {
	rolePermission, err := r.querier.CreateRolePermission(ctx, arg)
	return rolePermission, repoerror.BuildRepoErr("permission", "CreateRolePermission", err)
}

func (r *permissionRepository) GetAllRolePermission(ctx *gin.Context, arg sqlc.GetAllRolePermissionParams) ([]sqlc.GetAllRolePermissionRow, *exceptions.Exception) {
	rolePermissions, err := r.querier.GetAllRolePermission(ctx, arg)
	return rolePermissions, repoerror.BuildRepoErr("permission", "GetAllRolePermission", err)
}

func (r *permissionRepository) GetCountAllRolePermission(ctx *gin.Context, search string) (int64, *exceptions.Exception) {
	count, err := r.querier.GetCountAllRolePermission(ctx, search)
	return count, repoerror.BuildRepoErr("permission", "GetCountAllRolePermission", err)
}

func (r *permissionRepository) UpdateRolePermission(ctx *gin.Context, arg sqlc.UpdateRolePermissionParams) (sqlc.RolesPermission, *exceptions.Exception) {
	rolePermission, err := r.querier.UpdateRolePermission(ctx, arg)
	return rolePermission, repoerror.BuildRepoErr("permission", "UpdateRolePermission", err)
}

func (r *permissionRepository) DeleteRolePermission(ctx *gin.Context, id int64) *exceptions.Exception {
	err := r.querier.DeleteRolePermission(ctx, id)
	return repoerror.BuildRepoErr("permission", "DeleteRolePermission", err)
}

func (r *permissionRepository) GetRolePermission(ctx *gin.Context, id int64) (sqlc.RolesPermission, *exceptions.Exception) {
	rolePermission, err := r.querier.GetRolePermission(ctx, id)
	return rolePermission, repoerror.BuildRepoErr("permission", "GetRolePermission", err)
}

func (r *permissionRepository) DeleteOnePermissionInRole(ctx *gin.Context, arg sqlc.DeleteOnePermissionInRoleParams) (sqlc.RolesPermission, *exceptions.Exception) {
	rolePermission, err := r.querier.DeleteOnePermissionInRole(ctx, arg)
	return rolePermission, repoerror.BuildRepoErr("permission", "DeleteOnePermissionInRole", err)
}

func (r *permissionRepository) GetAllRolePermissionWithoutPagination(ctx *gin.Context) ([]sqlc.RolesPermission, *exceptions.Exception) {
	rolePermissions, err := r.querier.GetAllRolePermissionWithoutPagination(ctx)
	return rolePermissions, repoerror.BuildRepoErr("permission", "GetAllRolePermissionWithoutPagination", err)
}
