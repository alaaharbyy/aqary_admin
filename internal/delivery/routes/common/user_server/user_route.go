package user_routes

import (
	"aqary_admin/internal/domain/sqlc/sqlc"

	// user "aqary_admin/old_repo/user/auth"

	"aqary_admin/pkg/utils/security"

	// users "..aqary/repo/user"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
)

type UserServer struct {
	Store sqlc.Querier

	Pool       *pgxpool.Pool
	TokenMaker security.Maker
	Router     *gin.Engine
}

func NewUserServer(store sqlc.Querier, pool *pgxpool.Pool, token security.Maker, router *gin.Engine) *UserServer {
	return &UserServer{
		Store:      store,
		Pool:       pool,
		TokenMaker: token,
		Router:     router,
	}
}

func (server *UserServer) UserRelatedRoutes() {

}
