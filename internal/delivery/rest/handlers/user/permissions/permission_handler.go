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

// SwaggerPermission is a wrapper for sqlc.Permission
// swagger:model
type SwaggerPermission sqlc.Permission

// CreatePermission godoc
// @Summary Create a new permission
// @Description Create a new permission with the provided details
// @Tags permissions
// @Accept json
// @Produce json
// @Param permission body domain.CreatePermissionRequest true "Permission details"
// @Success 200 {object} sqlc.Permission
// @Failure 400 {object} exceptions.Exception
// @Failure 500 {object} exceptions.Exception
// @Router /api/user/createPermission [POST]

func (h *PermissionHandler) CreatePermission(c *gin.Context) {
	var req domain.CreatePermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	permission, err := h.userUseCase.CreatePermission(c, req)
	if err != nil {
		helper.SendApiResponseV1(c, err, nil)
		return
	}

	helper.SendApiResponseV1(c, nil, permission)
}

// GetAllPermission godoc
// @Summary Get all permissions
// @Description Get all permissions with pagination
// @Tags permissions
// @Accept json
// @Produce json
// @Param page_no query int true "Page number"
// @Param page_size query int true "Page size"
// @Success 200 {object} response.CustomSectionPermission
// @Failure 400 {object} exceptions.Exception
// @Failure 500 {object} exceptions.Exception
// @Router /api/user/getAllPermission [GET]

func (h *PermissionHandler) GetAllPermission(c *gin.Context) {
	var req domain.GetAllPermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	permissions, count, err := h.userUseCase.GetAllPermission(c, req)
	if err != nil {
		helper.SendApiResponseV1(c, err, nil)
		return
	}

	helper.SendApiResponseWithCountV1(c, nil, permissions, count)
}

// GetAllPermissionWithoutPagination godoc
// @Summary Get all permissions without pagination
// @Description Get all permissions without pagination
// @Tags permissions
// @Accept json
// @Produce json
// @Success 200 {array} response.CustomSectionPermission
// @Failure 500 {object} exceptions.Exception
// @Router  /api/user/getAllPermissionWithoutPagination  [GET]
func (h *PermissionHandler) GetAllPermissionWithoutPagination(c *gin.Context) {
	var req domain.GetAllPermissionWithoutPaginationRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}
	permissions, err := h.userUseCase.GetAllPermissionWithoutPagination(c, req)
	if err != nil {
		helper.SendApiResponseV1(c, err, nil)
		return
	}

	helper.SendApiResponseV1(c, nil, permissions)
}

// UpdatePermission godoc
// @Summary Update a permission
// @Description Update an existing permission
// @Tags permissions
// @Accept json
// @Produce json
// @Param id path int true "Permission ID"
// @Param permission body domain.UpdatePermissionRequest true "Updated permission details"
// @Success 200 {object} sqlc.Permission
// @Failure 400 {object} exceptions.Exception
// @Failure 404 {object} exceptions.Exception
// @Failure 500 {object} exceptions.Exception
// @Router /api/user/updatePermission/{id} [PUT]

func (h *PermissionHandler) UpdatePermission(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid ID"), nil)
		return
	}

	var req domain.UpdatePermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	updatedPermission, er := h.userUseCase.UpdatePermission(c, id, req)
	if er != nil {
		helper.SendApiResponseV1(c, er, nil)
		return
	}

	helper.SendApiResponseV1(c, nil, updatedPermission)
}

// DeletePermission godoc
// @Summary Delete a permission
// @Description Delete an existing permission
// @Tags permissions
// @Accept json
// @Produce json
// @Param id path int true "Permission ID"
// @Success 200 {object} string
// @Failure 400 {object} exceptions.Exception
// @Failure 404 {object} exceptions.Exception
// @Failure 500 {object} exceptions.Exception
// @Router /api/user/deletePermission/{id} [delete]

func (h *PermissionHandler) DeletePermission(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid ID"), nil)
		return
	}

	er := h.userUseCase.DeletePermission(c, id)
	if er != nil {
		helper.SendApiResponseV1(c, er, nil)
		return
	}

	helper.SendApiResponseV1(c, nil, "Permission deleted successfully")
}

// GetPermissionByRoleID godoc
// @Summary Get permissions by role ID
// @Description Get permissions associated with a specific role
// @Tags permissions
// @Accept json
// @Produce json
// @Param id path int true "Role ID"
// @Success 200 {object} response.CustomRolePermission
// @Failure 400 {object} exceptions.Exception
// @Failure 404 {object} exceptions.Exception
// @Failure 500 {object} exceptions.Exception
// @Router /api/user/getPermissionByRoleID/{id} [GET]

func (h *PermissionHandler) GetPermissionByRoleID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid ID"), nil)
		return
	}

	rolePermissions, er := h.userUseCase.GetPermissionByRoleID(c, id)
	if er != nil {
		helper.SendApiResponseV1(c, er, nil)
		return
	}

	helper.SendApiResponseV1(c, nil, rolePermissions)
}

// GetAllPermissionBySectionPermission godoc
// @Summary Get permissions by section permission ID
// @Description Get all permissions associated with a specific section permission
// @Tags permissions
// @Accept json
// @Produce json
// @Param id path int true "Section Permission ID"
// @Success 200 {array} response.PermissionOutput
// @Failure 400 {object} exceptions.Exception
// @Failure 500 {object} exceptions.Exception
// @Router /api/user/getAllPermissionBySectionId/{id} [get]

func (h *PermissionHandler) GetAllPermissionBySectionPermission(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid ID"), nil)
		return
	}

	permissions, er := h.userUseCase.GetAllPermissionBySectionPermission(c, id)
	if er != nil {
		helper.SendApiResponseV1(c, er, nil)
		return
	}

	helper.SendApiResponseV1(c, nil, permissions)
}

func (h *PermissionHandler) CachePermissions(c *gin.Context) {
	status, err := h.userUseCase.CachePermissions(c)
	if err != nil {
		helper.SendApiResponseV1(c, err, nil)
	}

	helper.SendApiResponseV1(c, nil, status)
}

func (h *PermissionHandler) CachePurgeAll(c *gin.Context) {
	status, err := h.userUseCase.CachePurgeAll(c)
	if err != nil {
		helper.SendApiResponseV1(c, err, nil)
	}

	helper.SendApiResponseV1(c, nil, status)
}
