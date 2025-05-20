package roles_repo

import (
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils/exceptions"
	repoerror "aqary_admin/pkg/utils/repo_error"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
)

type RoleRepo interface {
	CreateRole(ctx *gin.Context, arg sqlc.CreateRoleParams) (sqlc.Role, *exceptions.Exception)
	GetRoleByRole(ctx *gin.Context, args sqlc.GetRoleByRoleParams) (sqlc.Role, *exceptions.Exception)
	GetAllRole(ctx *gin.Context, arg sqlc.GetAllRoleParams) ([]sqlc.Role, *exceptions.Exception)
	GetCountAllRoles(ctx *gin.Context, departmentID int64) (int64, *exceptions.Exception)
	GetAllRoleWithRolePermissionChecked(ctx *gin.Context) ([]sqlc.GetAllRoleWithRolePermissionCheckedRow, *exceptions.Exception)
	UpdateRole(ctx *gin.Context, arg sqlc.UpdateRoleParams) (sqlc.Role, *exceptions.Exception)
	DeleteRole(ctx *gin.Context, args sqlc.DeleteRoleParams) *exceptions.Exception
}

type roleRepository struct {
	querier sqlc.Querier
}

func NewRoleRepository(querier sqlc.Querier) RoleRepo {
	return &roleRepository{
		querier: querier,
	}
}

func (r *roleRepository) CreateRole(ctx *gin.Context, arg sqlc.CreateRoleParams) (sqlc.Role, *exceptions.Exception) {
	role, err := r.querier.CreateRole(ctx, arg)
	if err != nil {
		return sqlc.Role{}, repoerror.BuildRepoErr("role", "CreateRole", err)
	}
	return role, nil
}

func (r *roleRepository) GetRoleByRole(ctx *gin.Context, args sqlc.GetRoleByRoleParams) (sqlc.Role, *exceptions.Exception) {
	roleResult, err := r.querier.GetRoleByRole(ctx, args)
	if err != nil {
		if err == pgx.ErrNoRows {
			return sqlc.Role{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "Role not found")
		}
		return sqlc.Role{}, repoerror.BuildRepoErr("role", "GetRoleByRole", err)
	}
	return roleResult, nil
}

func (r *roleRepository) GetAllRole(ctx *gin.Context, arg sqlc.GetAllRoleParams) ([]sqlc.Role, *exceptions.Exception) {
	roles, err := r.querier.GetAllRole(ctx, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("role", "GetAllRole", err)
	}
	return roles, nil
}

func (r *roleRepository) GetCountAllRoles(ctx *gin.Context, departmentId int64) (int64, *exceptions.Exception) {
	count, err := r.querier.GetCountAllRoles(ctx, pgtype.Int8{
		Int64: departmentId,
		Valid: departmentId != 0,
	})
	if err != nil {
		return 0, repoerror.BuildRepoErr("role", "GetCountAllRoles", err)
	}
	return count, nil
}

func (r *roleRepository) GetAllRoleWithRolePermissionChecked(ctx *gin.Context) ([]sqlc.GetAllRoleWithRolePermissionCheckedRow, *exceptions.Exception) {
	roles, err := r.querier.GetAllRoleWithRolePermissionChecked(ctx)
	if err != nil {
		return nil, repoerror.BuildRepoErr("role", "GetAllRoleWithRolePermissionChecked", err)
	}
	return roles, nil
}

func (r *roleRepository) UpdateRole(ctx *gin.Context, arg sqlc.UpdateRoleParams) (sqlc.Role, *exceptions.Exception) {
	role, err := r.querier.UpdateRole(ctx, arg)
	if err != nil {
		if err == pgx.ErrNoRows {
			return sqlc.Role{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "Role not found")
		}
		return sqlc.Role{}, repoerror.BuildRepoErr("role", "UpdateRole", err)
	}
	return role, nil
}

func (r *roleRepository) DeleteRole(ctx *gin.Context, args sqlc.DeleteRoleParams) *exceptions.Exception {
	err := r.querier.DeleteRole(ctx, args)
	if err != nil {
		if err == pgx.ErrNoRows {
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "Role not found")
		}
		return repoerror.BuildRepoErr("role", "DeleteRole", err)
	}
	return nil
}
