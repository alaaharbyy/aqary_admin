package roles_usecase

import (
	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	db "aqary_admin/pkg/db/user"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
)

type RoleUseCase interface {
	CreateRole(ctx *gin.Context, req domain.CreateRoleRequest) (*domain.RoleOutput, *exceptions.Exception)
	GetRole(ctx *gin.Context, id int64) (*response.RoleOutout, *exceptions.Exception)
	GetAllRoles(ctx *gin.Context, req domain.GetAllRolesRequest) ([]sqlc.Role, int64, *exceptions.Exception)
	GetAllRolesWithoutPagination(ctx *gin.Context, req domain.GetAllRolesRequest) ([]response.AllRolesOutput, int64, *exceptions.Exception)
	UpdateRole(ctx *gin.Context, id int64, req domain.UpdateRoleRequest) (*domain.RoleOutput, *exceptions.Exception)
	DeleteRole(ctx *gin.Context, req domain.DeleteRoleRequest) *exceptions.Exception
}

type roleUseCase struct {
	repo  db.UserCompositeRepo
	store sqlc.Store
	pool  *pgxpool.Pool
}

func NewRoleUseCase(repo db.UserCompositeRepo, store sqlc.Store, pool *pgxpool.Pool) RoleUseCase {
	return &roleUseCase{
		repo:  repo,
		store: store,
		pool:  pool,
	}
}
