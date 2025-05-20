package agent_usecase

import (
	domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	// usecase "aqary_admin/internal/usecases/user"
	db "aqary_admin/pkg/db/user"

	"github.com/gin-gonic/gin"
)

type UserAgentUseCase interface {
	SearchAllAgent(ctx *gin.Context, req domain.SearchAllAgentRequest) ([]sqlc.SearchAllAgentRow, *exceptions.Exception)
}

type agentUseCase struct {
	repo db.UserCompositeRepo
}

func NewAgentUseCase(repo db.UserCompositeRepo) UserAgentUseCase {
	return &agentUseCase{
		repo: repo,
	}
}

func (uc *agentUseCase) SearchAllAgent(ctx *gin.Context, req domain.SearchAllAgentRequest) ([]sqlc.SearchAllAgentRow, *exceptions.Exception) {
	search := utils.AddPercent(req.Search)
	return uc.repo.SearchAllAgent(ctx, search)
}
