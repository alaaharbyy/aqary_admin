package permissions_handler

import (
	userUserCase "aqary_admin/internal/usecases/user"

	"github.com/gin-gonic/gin"
)

type PermissionHandler struct {
	userUseCase userUserCase.UserCompositeUseCase
}

func NewPermissionHandler(userUseCase userUserCase.UserCompositeUseCase) *PermissionHandler {
	return &PermissionHandler{
		userUseCase: userUseCase,
	}
}

// RegisterNonAuthRoutes implements user_handler.Handler.
func (h *PermissionHandler) RegisterNonAuthRoutes(*gin.RouterGroup) {
	//
}

// RegisterNonAuthRoutes implements user_handler.Handler.
func (h *PermissionHandler) RegisterAuthRoutes(r *gin.RouterGroup) {

	// ! permission
	r.POST("/createPermission", h.CreatePermission)
	r.GET("/getAllPermissionBySectionId/:id", h.GetAllPermissionBySectionPermission)
	r.GET("/getAllPermission", h.GetAllPermission)
	r.GET("/getAllPermissionWithoutPagination", h.GetAllPermissionWithoutPagination)
	r.PUT("/updatePermission/:id", h.UpdatePermission)
	r.DELETE("/deletePermission/:id", h.DeletePermission)
	r.GET("/getPermissionByRoleID/:id", h.GetPermissionByRoleID)

	// ! role permissions
	r.POST("/createRolePermission", h.CreateRolePermission)
	r.GET("/getAllRolePermission", h.GetAllRolePermission)
	r.GET("/getAllRolePermissionWithoutPagination", h.GetAllRolePermissionWithoutPagination)
	r.PUT("/updateRolePermission/:id", h.UpdateRolePermission)
	r.DELETE("/deleteAllRolePermission/:id", h.DeleteAllRolePermission)
	r.DELETE("/deleteOneRolePermission/:id", h.DeleteOneRolePermission)

	// ! section permission
	r.POST("/createSectionPermission", h.CreateSectionPermission)
	r.GET("/getAllSectionPermission", h.GetAllSectionPermission)
	r.GET("/getAllSectionPermissionWithoutPagination", h.GetAllSectionPermissionWithoutPagination)
	r.PUT("/updateSectionPermission/:id", h.UpdateSectionPermission)
	r.DELETE("/deleteSectionPermission/:id", h.DeleteSectionPermission)

	// ! Sub Section
	r.POST("/createSubSectionPermission", h.CreateSubSectionPermission)
	r.GET("/getAllSubSectionPermission/:id", h.GetAllSubSectionPermissionByPermission)
	r.GET("/getAllSubSectionPermission", h.GetAllSubSectionPermission)
	r.GET("/getAllSubSectionPermissionWithoutPagination", h.GetAllSubSectionPermissionWithoutPagination)

	r.GET("/getAllNestedSubSectionPermission/:id", h.GetAllNestedSubSectionPermissionWithoutPermissionByID)
	r.GET("/getAllTertiarySubSectionPermission", h.GetAllTertiarySubSectionPermissionWithoutPermission)
	r.GET("/getAllQuaternarySubSectionPermission", h.GetAllQuaternarySubSectionPermissionWithoutPermission)

	r.GET("/getAllQuinarySubSectionPermission", h.GetAllQuinarySubSectionPermissionWithoutPermission)

	r.PUT("/updateSubSection/:id", h.UpdateSubSectionPermission)
	r.DELETE("/deleteSubSection/:id", h.DeleteSubSectionPermission)

	r.POST("/cachePermissions", h.CachePermissions)
	r.POST("/cachePurgeAll", h.CachePurgeAll)

}
