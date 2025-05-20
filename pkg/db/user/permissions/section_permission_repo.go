package permissions_repo

import (
	"aqary_admin/internal/domain/sqlc/sqlc"
	auth_utils "aqary_admin/pkg/utils/auth"
	"aqary_admin/pkg/utils/exceptions"
	repoerror "aqary_admin/pkg/utils/repo_error"

	"github.com/gin-gonic/gin"
)

func (r *permissionRepository) CreateSectionPermission(ctx *gin.Context, arg sqlc.CreateSectionPermissionParams, q sqlc.Querier) (*sqlc.SectionPermission, *exceptions.Exception) {
	r.querier, q = auth_utils.CheckAuthForTests(ctx, r.querier, q)
	sectionPermission, err := q.CreateSectionPermission(ctx, arg)
	return &sectionPermission, repoerror.BuildRepoErr("permission", "CreateSectionPermission", err)
}

func (r *permissionRepository) GetSectionPermissionByTitle(ctx *gin.Context, title string) (sqlc.SectionPermission, *exceptions.Exception) {
	sectionPermission, err := r.querier.GetSectionPermissionByTitle(ctx, title)
	return sectionPermission, repoerror.BuildRepoErr("permission", "GetSectionPermissionByTitle", err)
}

func (r *permissionRepository) GetAllSectionPermission(ctx *gin.Context, arg sqlc.GetAllSectionPermissionParams) ([]sqlc.SectionPermission, *exceptions.Exception) {
	sectionPermissions, err := r.querier.GetAllSectionPermission(ctx, arg)
	return sectionPermissions, repoerror.BuildRepoErr("permission", "GetAllSectionPermission", err)
}

func (r *permissionRepository) GetCountAllSectionPermission(ctx *gin.Context, search string) (int64, *exceptions.Exception) {
	count, err := r.querier.GetCountAllSectionPermission(ctx, search)
	return count, repoerror.BuildRepoErr("permission", "GetCountAllSectionPermission", err)
}

func (r *permissionRepository) UpdateSectionPermission(ctx *gin.Context, arg sqlc.UpdateSectionPermissionParams) (sqlc.SectionPermission, *exceptions.Exception) {
	sectionPermission, err := r.querier.UpdateSectionPermission(ctx, arg)
	return sectionPermission, repoerror.BuildRepoErr("permission", "UpdateSectionPermission", err)
}

func (r *permissionRepository) DeleteSectionPermission(ctx *gin.Context, id int64) (*string, *exceptions.Exception) {

	err := r.querier.DeleteSectionPermission(ctx, id)
	if err != nil {
		return nil, repoerror.BuildRepoErr("Section Permission", "DeleteSectionPermission", err)
	}

	out := "successfully deleted"
	return &out, repoerror.BuildRepoErr("permission", "CreateSectionPermission", err)
}
