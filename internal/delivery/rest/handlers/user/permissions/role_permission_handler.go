package permissions_handler

import (
	"strconv"

	"aqary_admin/internal/delivery/rest/helper"
	domain "aqary_admin/internal/domain/requests/user"
	_ "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	_ "aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

// SwaggerRolesPermission is a wrapper for sqlc.RolesPermission
// swagger:model
type SwaggerRolesPermission sqlc.RolesPermission

// CreateRolePermission godoc
// @Summary Create a new role permission
// @Description Create a new role permission
// @Tags role-permissions
// @Accept json
// @Produce json
// @Param rolePermission body domain.CreateRolePermissionRequest true "Role Permission details"
// @Success 200 {object} sqlc.RolesPermission
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/createRolePermission [post]
func (h *PermissionHandler) CreateRolePermission(c *gin.Context) {
	var req domain.CreateRolePermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	rolePermission, err := h.userUseCase.CreateRolePermission(c, req)
	helper.SendApiResponseV1(c, err, rolePermission)
}

// GetAllRolePermission godoc
// @Summary Get all role permissions
// @Description Get all role permissions with pagination
// @Tags role-permissions
// @Accept json
// @Produce json
// @Param page_no query int true "Page number"
// @Param page_size query int true "Page size"
// @Param search query string false "Search term"
// @Success 200 {object} response.CustomRolePermission
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getAllRolePermission [get]
func (h *PermissionHandler) GetAllRolePermission(c *gin.Context) {
	var req domain.GetAllRolePermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	rolePermissions, count, err := h.userUseCase.GetAllRolePermission(c, req)
	helper.SendApiResponseWithCountV1(c, err, rolePermissions, count)
}

// GetAllRolePermissionWithoutPagination godoc
// @Summary Get all role permissions without pagination
// @Description Get all role permissions without pagination
// @Tags role-permissions
// @Accept json
// @Produce json
// @Success 200 {array} response.CustomRolePermission
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getAllRolePermissionWithoutPagination/all [get]
func (h *PermissionHandler) GetAllRolePermissionWithoutPagination(c *gin.Context) {
	rolePermissions, err := h.userUseCase.GetAllRolePermissionWithoutPagination(c)
	helper.SendApiResponseV1(c, err, rolePermissions)
}

// UpdateRolePermission godoc
// @Summary Update a role permission
// @Description Update an existing role permission
// @Tags role-permissions
// @Accept json
// @Produce json
// @Param id path int true "Role Permission ID"
// @Param rolePermission body domain.UpdateRolePermissionRequest true "Updated role permission details"
// @Success 200 {object} sqlc.RolesPermission
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 404 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/updateRolePermission/{id} [put]
func (h *PermissionHandler) UpdateRolePermission(c *gin.Context) {
	id, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid ID"), nil)
		return
	}

	var req domain.UpdateRolePermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	updatedRolePermission, er := h.userUseCase.UpdateRolePermission(c, id, req)
	helper.SendApiResponseV1(c, er, updatedRolePermission)
}

// DeleteAllRolePermission godoc
// @Summary Delete all permissions for a role
// @Description Delete all permissions for an existing role
// @Tags role-permissions
// @Accept json
// @Produce json
// @Param id path int true "Role ID"
// @Success 200 {object} string
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 404 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/deleteAllRolePermission/{id} [delete]
func (h *PermissionHandler) DeleteAllRolePermission(c *gin.Context) {
	id, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid ID"), nil)
		return
	}

	er := h.userUseCase.DeleteAllRolePermission(c, id)
	helper.SendApiResponseV1(c, er, "All role permissions deleted successfully")
}

// DeleteOneRolePermission godoc
// @Summary Delete a single permission from a role
// @Description Delete a single permission from an existing role
// @Tags role-permissions
// @Accept json
// @Produce json
// @Param id path int true "Role Permission ID"
// @Param permission body domain.DeleteOneRolePermissionRequest true "Permission to delete"
// @Success 200 {object} sqlc.RolesPermission
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 404 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/deleteOneRolePermission/{id} [delete]
func (h *PermissionHandler) DeleteOneRolePermission(c *gin.Context) {
	id, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid ID"), nil)
		return
	}

	var req domain.DeleteOneRolePermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	updatedRolePermission, er := h.userUseCase.DeleteOneRolePermission(c, id, req)
	helper.SendApiResponseV1(c, er, updatedRolePermission)
}
