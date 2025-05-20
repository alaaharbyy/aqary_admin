package department_handler

import (
	userUserCase "aqary_admin/internal/usecases/user"

	"github.com/gin-gonic/gin"
)

type DepartmentHandler struct {
	usecase userUserCase.UserCompositeUseCase
}

func NewDepartmentHandler(usecase userUserCase.UserCompositeUseCase) *DepartmentHandler {
	return &DepartmentHandler{
		usecase: usecase,
	}
}

// RegisterNonAuthRoutes implements user_handler.Handler.
func (h *DepartmentHandler) RegisterNonAuthRoutes(*gin.RouterGroup) {
	// no handlers yet
}

// RegisterNonAuthRoutes implements user_handler.Handler.
func (h *DepartmentHandler) RegisterAuthRoutes(r *gin.RouterGroup) {

	//! department
	r.POST("/createDepartment", h.CreateDepartment)
	r.GET("/getDepartment", h.GetDepartment)
	r.GET("/getAllDepartments", h.GetAllDepartments)
	// r.GET("/getAllDepartmentWithoutPagination", h.GetAllDepartmentsWithoutPagination)
	r.PUT("/updateDepartment", h.UpdateDepartment)
	r.DELETE("/deleteDepartment", h.DeleteDepartment)

}
