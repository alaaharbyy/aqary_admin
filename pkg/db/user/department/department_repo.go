package department_repo

import (
	"errors"
	"fmt"
	"log"
	"strings"

	"aqary_admin/internal/delivery/rest/middleware"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
)

type DepartmentRepo interface {
	GetDepartmentByTitle(c *gin.Context, args sqlc.GetDepartmentByDepartmentParams) (*sqlc.Department, *exceptions.Exception)
	CreateDepartment(c *gin.Context, args sqlc.CreateDepartmentParams) (*sqlc.Department, *exceptions.Exception)
	// GetDepartment(ctx *gin.Context, id int32) (*sqlc.Department, *exceptions.Exception)
	GetAllDepartment(ctx *gin.Context, arg sqlc.GetAllDepartmentParams) ([]sqlc.Department, *exceptions.Exception)
	GetCountAllDepartment(ctx *gin.Context, args sqlc.GetCountAllDepartmentParams) (int64, *exceptions.Exception)
	GetAllDepartmentWithoutPagination(ctx *gin.Context) ([]sqlc.Department, *exceptions.Exception)
	UpdateDepartment(ctx *gin.Context, arg sqlc.UpdateDepartmentParams) (*sqlc.Department, *exceptions.Exception)
	DeleteDepartment(ctx *gin.Context, args sqlc.DeleteDepartmentParams) *exceptions.Exception
}

type departmentRepository struct {
	querier sqlc.Querier
}

func NewDepartmentRepository(q sqlc.Querier) DepartmentRepo {
	return &departmentRepository{
		querier: q,
	}
}

func (r *departmentRepository) CreateDepartment(ctx *gin.Context, arg sqlc.CreateDepartmentParams) (*sqlc.Department, *exceptions.Exception) {
	department, err := r.querier.CreateDepartment(ctx, arg)
	if err != nil {
		return nil, buildDepartmentErr("CreateDepartment", err)
	}
	return &department, nil
}

func (r *departmentRepository) GetDepartmentByTitle(ctx *gin.Context, arg sqlc.GetDepartmentByDepartmentParams) (*sqlc.Department, *exceptions.Exception) {
	department, err := r.querier.GetDepartmentByDepartment(ctx, arg)
	if err != nil {
		return nil, buildDepartmentErr("GetDepartmentByTitle", err)
	}
	return &department, nil
}

func (r *departmentRepository) GetAllDepartment(ctx *gin.Context, arg sqlc.GetAllDepartmentParams) ([]sqlc.Department, *exceptions.Exception) {
	departments, err := r.querier.GetAllDepartment(ctx, arg)
	if err != nil {
		return nil, buildDepartmentErr("GetAllDepartment", err)
	}
	return departments, nil
}

func (r *departmentRepository) GetCountAllDepartment(ctx *gin.Context, args sqlc.GetCountAllDepartmentParams) (int64, *exceptions.Exception) {
	count, err := r.querier.GetCountAllDepartment(ctx, args)
	if err != nil {
		return 0, buildDepartmentErr("GetCountAllDepartment", err)
	}
	return count, nil
}

func (r *departmentRepository) GetAllDepartmentWithoutPagination(ctx *gin.Context) ([]sqlc.Department, *exceptions.Exception) {
	departments, err := r.querier.GetAllDepartmentWithoutPagination(ctx)
	if err != nil {
		return nil, buildDepartmentErr("GetAllDepartmentWithoutPagination", err)
	}
	return departments, nil
}

func (r *departmentRepository) UpdateDepartment(ctx *gin.Context, arg sqlc.UpdateDepartmentParams) (*sqlc.Department, *exceptions.Exception) {
	department, err := r.querier.UpdateDepartment(ctx, arg)
	if err != nil {
		return nil, buildDepartmentErr("UpdateDepartment", err)
	}
	return &department, nil
}

func (r *departmentRepository) DeleteDepartment(ctx *gin.Context, args sqlc.DeleteDepartmentParams) *exceptions.Exception {
	err := r.querier.DeleteDepartment(ctx, args)
	if err != nil {
		if strings.Contains(err.Error(), "violates foreign key constraint") {
			log.Println("testing department delete err", err)
			var ErrDepartmentHasRoles = errors.New("cannot delete department because it has associated roles")
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, ErrDepartmentHasRoles.Error())
		}

		return buildDepartmentErr("DeleteDepartment", err)
	}
	return nil
}

func buildDepartmentErr(name string, err error) *exceptions.Exception {
	if err != nil {
		log.Printf("[department.repo.%v] error:%v", name, err)
		if errors.Is(err, pgx.ErrNoRows) {
			log.Printf("[aqary_user.repo.%v] error:%v", name, err)
			return exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode)
		}
		middleware.IncrementServerErrorCounter(fmt.Errorf("[aqary_user.repo.%v] error:%v", name, err).Error())
		return exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}
	return nil
}
