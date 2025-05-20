package roles_handler

import (
	"aqary_admin/internal/delivery/rest/helper"
	domain "aqary_admin/internal/domain/requests/user"
	_ "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"log"

	"strconv"

	_ "aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

// SwaggerRole is a wrapper for sqlc.Role
// swagger:model
type SwaggerRole sqlc.Role

// CreateRole godoc
// @Summary Create a new role
// @Description Create a new role
// @Tags roles
// @Accept json
// @Produce json
// @Param role body domain.CreateRoleRequest true "Role details"
// @Success 200 {object} sqlc.Role
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 409 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/createRole [post]
func (h *RoleHandler) CreateRole(c *gin.Context) {
	var req domain.CreateRoleRequest
	if err := c.ShouldBind(&req); err != nil {
		log.Println("testing err", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}
	createdRole, err := h.UseCase.CreateRole(c, req)
	helper.SendApiResponseV1(c, err, createdRole)
}

// GetRole godoc
// @Summary Get a role by ID
// @Description Get a role by its ID
// @Tags roles
// @Accept json
// @Produce json
// @Param id path int true "Role ID"
// @Success 200 {object} sqlc.Role
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 404 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getRole/{id} [get]
func (h *RoleHandler) GetRole(c *gin.Context) {
	id, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid ID"), nil)
		return
	}

	role, er := h.UseCase.GetRole(c, id)
	helper.SendApiResponseV1(c, er, role)
}

// GetAllRoles godoc
// @Summary Get all roles with pagination
// @Description Get all roles with pagination
// @Tags roles
// @Accept json
// @Produce json
// @Param page_size query int true "Page size"
// @Param page_no query int true "Page number"
// @Success 200 {object} []sqlc.Role
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getAllRoles [get]
func (h *RoleHandler) GetAllRoles(c *gin.Context) {
	var req domain.GetAllRolesRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	roles, count, err := h.UseCase.GetAllRoles(c, req)
	helper.SendApiResponseWithCountV1(c, err, roles, count)
}

// GetAllRolesWithoutPagination godoc
// @Summary Get all roles without pagination
// @Description Get all roles without pagination
// @Tags roles
// @Accept json
// @Produce json
// @Success 200 {object} response.AllRolesOutput
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getAllRolesWithoutPagination/all [get]
func (h *RoleHandler) GetAllRolesWithoutPagination(c *gin.Context) {

	var req domain.GetAllRolesRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	roles, count, err := h.UseCase.GetAllRolesWithoutPagination(c, req)
	helper.SendApiResponseWithCountV1(c, err, roles, count)
}

// UpdateRole godoc
// @Summary Update a role
// @Description Update an existing role
// @Tags roles
// @Accept json
// @Produce json
// @Param id path int true "Role ID"
// @Param role body domain.UpdateRoleRequest true "Updated role details"
// @Success 200 {object} sqlc.Role
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 404 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/updateRole/{id} [put]
func (h *RoleHandler) UpdateRole(c *gin.Context) {
	id, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid ID"), nil)
		return
	}

	var req domain.UpdateRoleRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	updatedRole, er := h.UseCase.UpdateRole(c, id, req)
	helper.SendApiResponseV1(c, er, updatedRole)
}

// DeleteRole godoc
// @Summary Delete a role
// @Description Delete an existing role
// @Tags roles
// @Accept json
// @Produce json
// @Param id path int true "Role ID"
// @Success 200 {object} string
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 404 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/deleteRole/{id} [delete]
func (h *RoleHandler) DeleteRole(c *gin.Context) {

	var req domain.DeleteRoleRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	er := h.UseCase.DeleteRole(c, req)
	helper.SendApiResponseV1(c, er, "Role successfully deleted")
}
