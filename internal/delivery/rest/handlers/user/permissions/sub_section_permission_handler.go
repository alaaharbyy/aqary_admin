package permissions_handler

import (
	"log"

	"aqary_admin/internal/delivery/rest/helper"
	domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"

	"strconv"

	_ "aqary_admin/internal/domain/responses/user"
	_ "aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

// SwaggerSubSection is a wrapper for sqlc.SubSection
// swagger:model
type SwaggerSubSection sqlc.SubSection

// CreateSubSectionPermission godoc
// @Summary Create a new sub-section permission
// @Description Create a new sub-section permission
// @Tags sub-section-permissions
// @Accept json
// @Produce json
// @Param subSectionPermission body domain.CreateSubSectionPermissionRequest true "Sub-section Permission details"
// @Success 200 {object} sqlc.SubSection
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/createSubSectionPermission [POST]
func (h *PermissionHandler) CreateSubSectionPermission(c *gin.Context) {
	var req domain.CreateSubSectionPermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		log.Println("resting err", err)
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	subSection, err := h.userUseCase.CreateSubSectionPermission(c, req)
	helper.SendApiResponseV1(c, err, subSection)
}

// GetAllSubSectionPermissionByPermission godoc
// @Summary Get all sub-section permissions for a specific permission
// @Description Get all sub-section permissions for a specific permission
// @Tags sub-section-permissions
// @Accept json
// @Produce json
// @Param id path int true "Permission ID"
// @Success 200 {array} response.SubSectionPermissionOutput
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getAllSubSectionPermission/{id} [GET]
func (h *PermissionHandler) GetAllSubSectionPermissionByPermission(c *gin.Context) {
	id, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid ID"), nil)
		return
	}

	subSections, er := h.userUseCase.GetAllSubSectionPermissionByPermission(c, id)
	helper.SendApiResponseV1(c, er, subSections)
}

// GetAllSubSectionPermission godoc
// @Summary Get all sub-section permissions
// @Description Get all sub-section permissions with pagination
// @Tags sub-section-permissions
// @Accept json
// @Produce json
// @Param page_no query int true "Page number"
// @Param page_size query int true "Page size"
// @Success 200 {object} response.CustomAlllPermission
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getAllSubSectionPermission [GET]
func (h *PermissionHandler) GetAllSubSectionPermission(c *gin.Context) {
	var req domain.GetAllPermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	permissions, count, err := h.userUseCase.GetAllSubSectionPermission(c, req)
	helper.SendApiResponseWithCountV1(c, err, permissions, count)
}

// GetAllSubSectionPermissionWithoutPagination godoc
// @Summary Get all sub-section permissions without pagination
// @Description Get all sub-section permissions without pagination
// @Tags sub-section-permissions
// @Accept json
// @Produce json
// @Success 200 {object} response.CustomAlllPermission
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getAllSubSectionPermissionWithoutPagination [GET]
func (h *PermissionHandler) GetAllSubSectionPermissionWithoutPagination(c *gin.Context) {
	permissions, count, err := h.userUseCase.GetAllSubSectionPermissionWithoutPagination(c)
	helper.SendApiResponseWithCountV1(c, err, permissions, count)
}

// UpdateSubSectionPermission godoc
// @Summary Update a sub-section permission
// @Description Update an existing sub-section permission
// @Tags sub-section-permissions
// @Accept json
// @Produce json
// @Param id path int true "Sub-section Permission ID"
// @Param subSectionPermission body domain.UpdateSubSectionPermissionRequest true "Updated sub-section permission details"
// @Success 200 {object} sqlc.SubSection
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 404 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/updateSubSection/{id} [PUT]
func (h *PermissionHandler) UpdateSubSectionPermission(c *gin.Context) {
	id, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid ID"), nil)
		return
	}

	var req domain.UpdateSubSectionPermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	updatedSubSection, er := h.userUseCase.UpdateSubSectionPermission(c, id, req)
	helper.SendApiResponseV1(c, er, updatedSubSection)
}

// DeleteSubSectionPermission godoc
// @Summary Delete a sub-section permission
// @Description Delete an existing sub-section permission
// @Tags sub-section-permissions
// @Accept json
// @Produce json
// @Param id path int true "Sub-section Permission ID"
// @Success 200 {object} string
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 404 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/deleteSubSection/{id} [delete]
func (h *PermissionHandler) DeleteSubSectionPermission(c *gin.Context) {
	id, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid ID"), nil)
		return
	}

	er := h.userUseCase.DeleteSubSectionPermission(c, id)
	helper.SendApiResponseV1(c, er, "Sub-section permission successfully deleted")
}

// GetAllQuinarySubSectionPermissionWithoutPermission godoc
// @Summary Get all quinary sub-section permissions without permission
// @Description Get all quinary sub-section permissions without permission with pagination
// @Tags sub-section-permissions
// @Accept json
// @Produce json
// @Param page_no query int true "Page number"
// @Param page_size query int true "Page size"
// @Success 200 {object} response.CustomAllQuaternarySubSectionPermission
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getAllQuinarySubSectionPermission [GET]
func (h *PermissionHandler) GetAllQuinarySubSectionPermissionWithoutPermission(c *gin.Context) {
	var req domain.GetAllPermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	permissions, count, err := h.userUseCase.GetAllQuinarySubSectionPermissionWithoutPermission(c, req)
	helper.SendApiResponseWithCountV1(c, err, permissions, count)
}

// GetAllNestedSubSectionPermissionWithoutPermissionByID godoc
// @Summary Get all nested sub-section permissions without permission by ID
// @Description Get all nested sub-section permissions without permission for a specific ID
// @Tags sub-section-permissions
// @Accept json
// @Produce json
// @Param id path int true "Sub-section Button ID"
// @Success 200 {array} []sqlc.SubSection
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getAllNestedSubSectionPermission/{id} [GET]
func (h *PermissionHandler) GetAllNestedSubSectionPermissionWithoutPermissionByID(c *gin.Context) {
	id, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid ID"), nil)
		return
	}

	subSections, er := h.userUseCase.GetAllNestedSubSectionPermissionWithoutPermissionByID(c, id)
	helper.SendApiResponseV1(c, er, subSections)
}

// GetAllTertiarySubSectionPermissionWithoutPermission godoc
// @Summary Get all tertiary sub-section permissions without permission
// @Description Get all tertiary sub-section permissions without permission with pagination
// @Tags sub-section-permissions
// @Accept json
// @Produce json
// @Param page_no query int true "Page number"
// @Param page_size query int true "Page size"
// @Success 200 {object} response.CustomSubSectionSecondaryPermission
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getAllTertiarySubSectionPermission [GET]
func (h *PermissionHandler) GetAllTertiarySubSectionPermissionWithoutPermission(c *gin.Context) {
	var req domain.GetAllPermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	permissions, count, err := h.userUseCase.GetAllTertiarySubSectionPermissionWithoutPermission(c, req)
	helper.SendApiResponseWithCountV1(c, err, permissions, count)
}

// GetAllQuaternarySubSectionPermissionWithoutPermission godoc
// @Summary Get all quaternary sub-section permissions without permission
// @Description Get all quaternary sub-section permissions without permission with pagination
// @Tags sub-section-permissions
// @Accept json
// @Produce json
// @Param page_no query int true "Page number"
// @Param page_size query int true "Page size"
// @Success 200 {object} response.CustomAllSecondarySubSectionPermission
// @Failure 400 {object} utils.ErrResponseSwagger
// @Failure 500 {object} utils.ErrResponseSwagger
// @Router /api/user/getAllQuaternarySubSectionPermission [GET]
func (h *PermissionHandler) GetAllQuaternarySubSectionPermissionWithoutPermission(c *gin.Context) {
	var req domain.GetAllPermissionRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Invalid request"), nil)
		return
	}

	permissions, count, err := h.userUseCase.GetAllQuaternarySubSectionPermissionWithoutPermission(c, req)
	helper.SendApiResponseWithCountV1(c, err, permissions, count)
}
