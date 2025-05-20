package roles_handler

import (
	usecase "aqary_admin/internal/usecases/user"

	"github.com/gin-gonic/gin"
)

type RoleHandler struct {
	UseCase usecase.UserCompositeUseCase
}

// RegisterNonAuthRoutes implements user_handler.Handler.
func (h *RoleHandler) RegisterNonAuthRoutes(*gin.RouterGroup) {
	// no handlers yet
}

// NewRoleHandler creates a new RoleHandler
func NewRoleHandler(useCase usecase.UserCompositeUseCase) *RoleHandler {
	return &RoleHandler{
		UseCase: useCase,
	}
}

func (h *RoleHandler) RegisterAuthRoutes(r *gin.RouterGroup) {
	r.POST("/createRole", h.CreateRole)
	r.GET("/getRole/:id", h.GetRole)
	r.GET("/getAllRoles", h.GetAllRoles)
	r.PUT("/updateRole/:id", h.UpdateRole)
	r.GET("/getAllRolesWithoutPagination", h.GetAllRolesWithoutPagination)
	r.DELETE("/deleteRole", h.DeleteRole)
}
