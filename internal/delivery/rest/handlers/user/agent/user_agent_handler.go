package agent_handler

import (
	"aqary_admin/internal/delivery/rest/helper"
	domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	_ "aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

// SwaggerSearchAllAgentRow is a wrapper for sqlc.SearchAllAgentRow
// swagger:model
type SwaggerSearchAllAgentRow sqlc.SearchAllAgentRow

// SearchAllAgent godoc
// @Summary Search all agents
// @Description Search for agents based on a search string
// @Tags agents
// @Accept json
// @Produce json
// @Param search query string false "Search string"
// @Success 200 {object} []sqlc.SearchAllAgentRow
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/agents/search [get]
func (h *UserAgentHandler) SearchAllAgent(c *gin.Context) {
	var req domain.SearchAllAgentRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	agents, err := h.userUseCase.SearchAllAgent(c, req)

	helper.SendApiResponseV1(c, err, agents)
}
