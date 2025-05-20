package agent_repo_repo

import (
	"fmt"

	"aqary_admin/internal/delivery/rest/middleware"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

type AgentRepo interface {
	SearchAllAgent(ctx *gin.Context, search string) ([]sqlc.SearchAllAgentRow, *exceptions.Exception)
}

type agentRepository struct {
	querier sqlc.Querier
}

func NewUserAgentRepository(querier sqlc.Querier) AgentRepo {
	return &agentRepository{
		querier: querier,
	}
}

func (r *agentRepository) SearchAllAgent(ctx *gin.Context, search string) ([]sqlc.SearchAllAgentRow, *exceptions.Exception) {
	agents, err := r.querier.SearchAllAgent(ctx, search)
	if err != nil {
		middleware.IncrementServerErrorCounter(fmt.Errorf("[agent.repo.SearchAllAgent] error:%v", err).Error())
		return nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}
	return agents, nil
}
