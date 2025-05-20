package department_handler

import (
	// user_handler "aqary_admin/internal/delivery/rest/handlers/user"

	"aqary_admin/internal/delivery/rest/helper"
	domain "aqary_admin/internal/domain/requests/user"
	_ "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	_ "aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/fn"
	"log"

	"github.com/gin-gonic/gin"
)

// SwaggerDepartment is a wrapper for sqlc.Department
// swagger:model
type SwaggerDepartment sqlc.Department

// SwaggerCustomFormat is a wrapper for fn.CustomFormat
// swagger:model
type SwaggerCustomFormat fn.CustomFormat

// CreateDepartment godoc
// @Summary create department
// @Description CreateDepartment
// @Tags department
// @Param request body domain.CreateDepartmentRequest true "CreateDepartmentRequest"
// @Success 200 {object} sqlc.Department
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/department/createDepartment [POST]
func (h *DepartmentHandler) CreateDepartment(c *gin.Context) {

	var req domain.CreateDepartmentRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	department, err := h.usecase.CreateDepartment(c, req)
	helper.SendApiResponseV1(c, err, department)

}

// GetDepartment godoc
// @Summary Get a department by ID
// @Description Get details of a department by its ID
// @Tags departments
// @Accept json
// @Produce json
// @Param id path int true "Department ID"
// @Success 200 {object} sqlc.Department
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/departments/{id} [get]
func (h *DepartmentHandler) GetDepartment(c *gin.Context) {
	// idString, err := c.Params.Get("id")
	// if !err {
	// 	helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "id is invalid"), nil)
	// 	return
	// }

	// id, errr := strconv.Atoi(idString)
	// if errr != nil {
	// 	helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "cannot convert id"), nil)
	// 	return
	// }

	var req domain.GetDepartmentRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	log.Print("tesitng req", req)

	department, ex := h.usecase.GetDepartment(c, req)
	helper.SendApiResponseV1(c, ex, department)
}

// GetAllDepartments godoc
// @Summary Get all departments
// @Description Get a list of all departments with pagination
// @Tags departments
// @Accept json
// @Produce json
// @Param page_size query int true "Page Size"
// @Param page_no query int true "Page Number"
// @Param search query string false "Search string"
// @Success 200 {object} []sqlc.Department
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/departments [get]
func (h *DepartmentHandler) GetAllDepartments(c *gin.Context) {
	var req domain.GetAllDepartmentRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Please provide all the required fields"), nil)
		return
	}

	departments, count, err := h.usecase.GetAllDepartments(c, req)
	helper.SendApiResponseWithCountV1(c, err, departments, count)
}

// GetAllDepartmentsWithoutPagination godoc
// @Summary Get all departments without pagination
// @Description Get a list of all departments without pagination
// @Tags departments
// @Accept json
// @Produce json
// @Success 200 {object} []fn.CustomFormat
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/departments/all [get]
// func (h *DepartmentHandler) GetAllDepartmentsWithoutPagination(c *gin.Context) {
// departments, count, err := h.usecase.GetAllDepartmentsWithoutPagination(c)
// helper.SendApiResponseWithCountV1(c, err, departments, count)
// }

// UpdateDepartment godoc
// @Summary Update a department
// @Description Update a department's details
// @Tags departments
// @Accept json
// @Produce json
// @Param id path int true "Department ID"
// @Param department body domain.UpdateDepartmentRequest true "Department details to update"
// @Success 200 {object} sqlc.Department
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/departments/{id} [put]
func (h *DepartmentHandler) UpdateDepartment(c *gin.Context) {
	// idString, err := c.Params.Get("id")
	// if !err {
	// 	helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "id is invalid"), nil)
	// 	return
	// }

	// id, errr := strconv.Atoi(idString)
	// if errr != nil {
	// 	helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "cannot convert id"), nil)
	// 	return
	// }

	var req domain.UpdateDepartmentRequest
	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "please provide the fields"), nil)
		return
	}

	department, ex := h.usecase.UpdateDepartment(c, req)
	helper.SendApiResponseV1(c, ex, department)
}

// DeleteDepartment godoc
// @Summary Delete a department
// @Description Delete a department by its ID
// @Tags departments
// @Accept json
// @Produce json
// @Param id path int true "Department ID"
// @Success 200 {object} string
// @Failure 400  {object} utils.ErrResponseSwagger
// @Failure 500  {object} utils.ErrResponseSwagger
// @Router /api/departments/{id} [delete]
func (h *DepartmentHandler) DeleteDepartment(c *gin.Context) {
	var req domain.GetDepartmentRequest

	if err := c.ShouldBind(&req); err != nil {
		helper.SendApiResponseV1(c, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error()), nil)
		return
	}

	ex := h.usecase.DeleteDepartment(c, req)

	helper.SendApiResponseV1(c, ex, "successfully deleted...")
}
