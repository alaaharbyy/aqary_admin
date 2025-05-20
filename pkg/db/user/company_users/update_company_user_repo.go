package companyusers_repo

import (
	"errors"

	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils/exceptions"
	repoerror "aqary_admin/pkg/utils/repo_error"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
)

func (r *companyUserRepository) GetCountCompanyUsersByStatuses(ctx *gin.Context, statuses []int64) (int64, *exceptions.Exception) {
	count, err := r.querier.GetCountCompanyUsersByStatuses(ctx, statuses)
	return count, repoerror.BuildRepoErr("company_user", "GetCountCompanyUsersByStatuses", err)
}

func (r *companyUserRepository) GetCompanyUser(ctx *gin.Context, id int32) (sqlc.CompanyUser, *exceptions.Exception) {
	user, err := r.querier.GetCompanyUser(ctx, id)
	if errors.Is(err, pgx.ErrNoRows) {
		return sqlc.CompanyUser{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "company user doesn't exist")
	}
	return user, repoerror.BuildRepoErr("company_user", "GetCompanyUser", err)
}

func (r *companyUserRepository) GetBrokerAgentByUserId(ctx *gin.Context, userID int64) (sqlc.BrokerCompanyAgent, *exceptions.Exception) {
	agent, err := r.querier.GetBrokerAgentByUserId(ctx, userID)
	return agent, repoerror.BuildRepoErr("company_user", "GetBrokerAgentByUserId", err)
}

func (r *companyUserRepository) UpdateBrokerAgent(ctx *gin.Context, arg sqlc.UpdateBrokerAgentParams) *exceptions.Exception {
	_, err := r.querier.UpdateBrokerAgent(ctx, arg)
	return repoerror.BuildRepoErr("company_user", "UpdateBrokerAgent", err)
}

func (r *companyUserRepository) GetBrokerBranchAgentByUserId(ctx *gin.Context, userID int64) (sqlc.BrokerCompanyBranchesAgent, *exceptions.Exception) {
	agent, err := r.querier.GetBrokerBranchAgentByUserId(ctx, userID)
	return agent, repoerror.BuildRepoErr("company_user", "GetBrokerBranchAgentByUserId", err)
}

func (r *companyUserRepository) UpdateBrokerBranchAgent(ctx *gin.Context, arg sqlc.UpdateBrokerBranchAgentParams) *exceptions.Exception {
	_, err := r.querier.UpdateBrokerBranchAgent(ctx, arg)
	return repoerror.BuildRepoErr("company_user", "UpdateBrokerBranchAgent", err)
}

func (r *companyUserRepository) UpdateAgentSubscriptionQuota(ctx *gin.Context, arg sqlc.UpdateAgentSubscriptionQuotaParams) *exceptions.Exception {
	_, err := r.querier.UpdateAgentSubscriptionQuota(ctx, arg)
	return repoerror.BuildRepoErr("company_user", "UpdateAgentSubscriptionQuota", err)
}

func (r *companyUserRepository) UpdateAgentSubscriptionQuotaBranch(ctx *gin.Context, arg sqlc.UpdateAgentSubscriptionQuotaBranchParams) *exceptions.Exception {
	_, err := r.querier.UpdateAgentSubscriptionQuotaBranch(ctx, arg)
	return repoerror.BuildRepoErr("company_user", "UpdateAgentSubscriptionQuotaBranch", err)
}

func (r *companyUserRepository) UpdateBrokerAgentStatus(ctx *gin.Context, userID int64, status int64) *exceptions.Exception {
	agent, err := r.querier.GetBrokerAgentByUserId(ctx, userID)
	if err != nil {
		return repoerror.BuildRepoErr("company_user", "GetBrokerAgentByUserId", err)
	}

	_, err = r.querier.UpdateBrokerAgentByStatus(ctx, sqlc.UpdateBrokerAgentByStatusParams{
		ID:     agent.ID,
		Status: status,
	})
	return repoerror.BuildRepoErr("company_user", "UpdateBrokerAgentStatus", err)
}

func (r *companyUserRepository) UpdateBrokerBranchAgentStatus(ctx *gin.Context, userID int64, status int64) *exceptions.Exception {
	agent, err := r.querier.GetBrokerBranchAgentByUserId(ctx, userID)
	if err != nil {
		return repoerror.BuildRepoErr("company_user", "GetBrokerBranchAgentByUserId", err)
	}

	_, err = r.querier.UpdateBrokerBranchAgentByStatus(ctx, sqlc.UpdateBrokerBranchAgentByStatusParams{
		ID:     agent.ID,
		Status: status,
	})
	return repoerror.BuildRepoErr("company_user", "UpdateBrokerBranchAgentStatus", err)
}
