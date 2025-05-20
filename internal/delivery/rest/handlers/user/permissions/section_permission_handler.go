package permissions_handler

import (
	"aqary_admin/internal/delivery/rest/helper"

	"strconv"

	domain "aqary_admin/internal/domain/requests/user"
	_ "aqary_admin/internal/domain/responses/user"
	_ "aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

// CreateSectionPermission godoc
// @Summary Create a new section permission
// @Description Create a new section permission
// @Tags section-permissions
// @Accept json
// @Produce json
// @Param sectionPermission body domain.CreateSectionPermissionRequest true "Section Permission details"
// @Success 200 {object} response.SectionPermission
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 409 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/createSectionPermission [post]
func (h *PermissionHandler) CreateSectionPermission(c *gin.Context) {
	var req domain.CreateSectionPermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	sectionPermission, err := h.userUseCase.CreateSectionPermission(c, req)
	helper.SendApiResponseV1(c, err, sectionPermission)
}

// GetAllSectionPermission godoc
// @Summary Get all section permissions
// @Description Get all section permissions with pagination
// @Tags section-permissions
// @Accept json
// @Produce json
// @Param page_no query int true "Page number"
// @Param page_size query int true "Page size"
// @Param search query string false "Search term"
// @Success 200 {object} response.SectionPermission
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getAllSectionPermission [get]
func (h *PermissionHandler) GetAllSectionPermission(c *gin.Context) {
	var req domain.GetAllSectionPermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	sectionPermissions, count, err := h.userUseCase.GetAllSectionPermission(c, req)
	helper.SendApiResponseWithCountV1(c, err, sectionPermissions, count)
}

// GetAllSectionPermissionWithoutPagination godoc
// @Summary Get all section permissions without pagination
// @Description Get all section permissions without pagination
// @Tags section-permissions
// @Accept json
// @Produce json
// @Success 200 {array} response.SectionPermission
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getAllSectionPermissionWithoutPagination [get]
func (h *PermissionHandler) GetAllSectionPermissionWithoutPagination(c *gin.Context) {
	sectionPermissions, err := h.userUseCase.GetAllSectionPermissionWithoutPagination(c)
	helper.SendApiResponseV1(c, err, sectionPermissions)
}

// UpdateSectionPermission godoc
// @Summary Update a section permission
// @Description Update an existing section permission
// @Tags section-permissions
// @Accept json
// @Produce json
// @Param id path int true "Section Permission ID"
// @Param sectionPermission body domain.UpdateSectionPermissionRequest true "Updated section permission details"
// @Success 200 {object} string
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 404 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/updateSectionPermission/{id} [put]
func (h *PermissionHandler) UpdateSectionPermission(c *gin.Context) {
	id, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid ID"), nil)
		return
	}

	var req domain.UpdateSectionPermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	updatedSectionPermission, er := h.userUseCase.UpdateSectionPermission(c, id, req)
	helper.SendApiResponseV1(c, er, updatedSectionPermission)
}

// DeleteSectionPermission godoc
// @Summary Delete a section permission
// @Description Update an existing section permission
// @Tags section-permissions
// @Accept json
// @Produce json
// @Param id path int true "Section Permission ID"
// @Success 200 {object} string
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 404 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/deleteSectionPermission/{id} [delete]
func (h *PermissionHandler) DeleteSectionPermission(c *gin.Context) {
	id, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid ID"), nil)
		return
	}
	updatedSectionPermission, er := h.userUseCase.DeleteSectionPermission(c, id)
	helper.SendApiResponseV1(c, er, updatedSectionPermission)
}
