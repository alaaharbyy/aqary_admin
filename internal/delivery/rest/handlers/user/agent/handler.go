package agent_handler

import (
	userUserCase "aqary_admin/internal/usecases/user"

	"github.com/gin-gonic/gin"
)

type UserAgentHandler struct {
	userUseCase userUserCase.UserCompositeUseCase
}

func NewAgentHandler(userUseCase userUserCase.UserCompositeUseCase) *UserAgentHandler {
	return &UserAgentHandler{
		userUseCase: userUseCase,
	}
}

// RegisterNonAuthRoutes implements user_handler.Handler.
func (h *UserAgentHandler) RegisterNonAuthRoutes(*gin.RouterGroup) {
	// no handlers yet
}

// RegisterNonAuthRoutes implements user_handler.Handler.
func (h *UserAgentHandler) RegisterAuthRoutes(r *gin.RouterGroup) {

	// ! agent
	// r.GET("/getAllAgents", h.SearchAllAgent)

}

func (h *UserAgentHandler) GetUserUseCase() userUserCase.UserCompositeUseCase {
	return h.userUseCase
}
