package permissions_usecase

import (
	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	db "aqary_admin/pkg/db/user"
	"aqary_admin/pkg/utils/exceptions"
	"context"

	"github.com/gin-gonic/gin"
)

type PermissionUseCase interface {
	CreatePermission(ctx *gin.Context, req domain.CreatePermissionRequest) (*sqlc.Permission, *exceptions.Exception)
	GetAllPermission(ctx *gin.Context, req domain.GetAllPermissionRequest) ([]response.CustomSectionPermission, int64, *exceptions.Exception)
	GetAllPermissionWithoutPagination(ctx *gin.Context, req domain.GetAllPermissionWithoutPaginationRequest) ([]response.CustomSectionPermission, *exceptions.Exception)
	UpdatePermission(ctx *gin.Context, id int64, req domain.UpdatePermissionRequest) (*sqlc.Permission, *exceptions.Exception)
	DeletePermission(ctx *gin.Context, id int64) *exceptions.Exception
	GetPermissionByRoleID(ctx *gin.Context, roleID int64) (*response.CustomRolePermission, *exceptions.Exception)
	GetAllPermissionBySectionPermission(ctx *gin.Context, sectionID int64) ([]response.PermissionOutput, *exceptions.Exception)

	// New role permission methods
	CreateRolePermission(ctx *gin.Context, req domain.CreateRolePermissionRequest) (*sqlc.RolesPermission, *exceptions.Exception)
	GetAllRolePermission(ctx *gin.Context, req domain.GetAllRolePermissionRequest) ([]response.CustomRolePermission, int64, *exceptions.Exception)
	GetAllRolePermissionWithoutPagination(ctx *gin.Context) ([]response.CustomRolePermission, *exceptions.Exception)
	UpdateRolePermission(ctx *gin.Context, id int64, req domain.UpdateRolePermissionRequest) (*sqlc.RolesPermission, *exceptions.Exception)
	DeleteAllRolePermission(ctx *gin.Context, id int64) *exceptions.Exception
	DeleteOneRolePermission(ctx *gin.Context, id int64, req domain.DeleteOneRolePermissionRequest) (*sqlc.RolesPermission, *exceptions.Exception)
	// GetPermissionByRole(ctx *gin.Context, id int64) (*response.CustomRolePermission, *exceptions.Exception)

	// section permission
	CreateSectionPermission(ctx *gin.Context, req domain.CreateSectionPermissionRequest) (*response.SectionPermission, *exceptions.Exception)
	GetAllSectionPermission(ctx *gin.Context, req domain.GetAllSectionPermissionRequest) ([]response.SectionPermission, int64, *exceptions.Exception)
	GetAllSectionPermissionWithoutPagination(ctx *gin.Context) ([]response.SectionPermission, *exceptions.Exception)
	UpdateSectionPermission(ctx *gin.Context, id int64, req domain.UpdateSectionPermissionRequest) (*response.SectionPermission, *exceptions.Exception)
	DeleteSectionPermission(ctx *gin.Context, id int64) (*string, *exceptions.Exception)

	// sub section permission
	CreateSubSectionPermission(ctx *gin.Context, req domain.CreateSubSectionPermissionRequest) ([]*sqlc.SubSection, *exceptions.Exception)
	GetAllSubSectionPermissionByPermission(ctx *gin.Context, permissionID int64) ([]response.SubSectionPermissionOutput, *exceptions.Exception)
	GetAllSubSectionPermission(ctx *gin.Context, req domain.GetAllPermissionRequest) ([]response.CustomAlllPermission, int64, *exceptions.Exception)
	GetAllSubSectionPermissionWithoutPagination(ctx *gin.Context) ([]response.CustomAlllPermission, int64, *exceptions.Exception)
	UpdateSubSectionPermission(ctx *gin.Context, id int64, req domain.UpdateSubSectionPermissionRequest) (*sqlc.SubSection, *exceptions.Exception)
	DeleteSubSectionPermission(ctx *gin.Context, id int64) *exceptions.Exception
	GetAllNestedSubSectionPermissionWithoutPermissionByID(ctx *gin.Context, id int64) ([]sqlc.SubSection, *exceptions.Exception)
	GetAllTertiarySubSectionPermissionWithoutPermission(ctx *gin.Context, req domain.GetAllPermissionRequest) ([]response.CustomSubSectionSecondaryPermission, int64, *exceptions.Exception)
	GetAllQuaternarySubSectionPermissionWithoutPermission(ctx *gin.Context, req domain.GetAllPermissionRequest) ([]response.CustomAllSecondarySubSectionPermission, int64, *exceptions.Exception)
	GetAllQuinarySubSectionPermissionWithoutPermission(ctx *gin.Context, req domain.GetAllPermissionRequest) ([]response.CustomAllQuaternarySubSectionPermission, int64, *exceptions.Exception)

	CachePermissions(ctx context.Context) (string, *exceptions.Exception)
	CachePurgeAll(ctx context.Context) (string, *exceptions.Exception)
}

type permissionUseCase struct {
	repo  db.UserCompositeRepo
	store sqlc.Store
}

func NewPermissionUseCase(repo db.UserCompositeRepo, store sqlc.Store) PermissionUseCase {
	return &permissionUseCase{
		repo:  repo,
		store: store,
	}
}
