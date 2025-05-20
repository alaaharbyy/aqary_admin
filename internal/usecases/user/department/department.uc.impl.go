package department_usecase

import (
	"log"
	"time"

	"aqary_admin/internal/delivery/rest/middleware"
	domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	db "aqary_admin/pkg/db/user"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/security"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
)

type DepartmentUseCase interface {
	CreateDepartment(c *gin.Context, req domain.CreateDepartmentRequest) (*sqlc.Department, *exceptions.Exception)
	GetDepartment(ctx *gin.Context, req domain.GetDepartmentRequest) (*sqlc.Department, *exceptions.Exception)
	GetAllDepartments(ctx *gin.Context, req domain.GetAllDepartmentRequest) ([]sqlc.Department, int64, *exceptions.Exception)
	// GetAllDepartmentsWithoutPagination(ctx *gin.Context) ([]fn.CustomFormat, int64, *exceptions.Exception)
	UpdateDepartment(ctx *gin.Context, req domain.UpdateDepartmentRequest) (*sqlc.Department, *exceptions.Exception)
	DeleteDepartment(ctx *gin.Context, req domain.GetDepartmentRequest) *exceptions.Exception
}

type departmentUseCase struct {
	repo db.UserCompositeRepo
}

// CreateDepartment implements usecase.DepartmentUseCase.
func (d *departmentUseCase) CreateDepartment(c *gin.Context, req domain.CreateDepartmentRequest) (*sqlc.Department, *exceptions.Exception) {

	// req.Title = utils.SanitizeString(req.Title)
	_, err := d.repo.GetDepartmentByTitle(c, sqlc.GetDepartmentByDepartmentParams{
		CompanyID:  req.CompanyID,
		Department: req.Title,
	})
	if err != nil {
		log.Println("error while getting department:", err)
		// return nil, err
	}

	department, err := d.repo.CreateDepartment(c, sqlc.CreateDepartmentParams{
		Department: req.Title,
		DepartmentAr: pgtype.Text{
			String: req.ArabicTitle,
			Valid:  req.ArabicTitle != "",
		},
		CreatedAt: time.Now(),
		Status:    1,
		CompanyID: pgtype.Int8{Int64: req.CompanyID, Valid: req.CompanyID != 0},
		UpdatedAt: time.Now(),
	})
	if err != nil {
		return nil, err
	}

	return department, nil
}

func (uc *departmentUseCase) GetDepartment(ctx *gin.Context, req domain.GetDepartmentRequest) (*sqlc.Department, *exceptions.Exception) {
	department, err := uc.repo.GetDepartment(ctx, sqlc.GetDepartmentParams{
		CompanyID:    req.CompanyID,
		DepartmentID: req.Id,
	})

	log.Println("testing department output ", department, "::", err)
	if err != nil {
		return nil, err
	}

	return &department, nil
}

func (uc *departmentUseCase) GetAllDepartments(ctx *gin.Context, req domain.GetAllDepartmentRequest) ([]sqlc.Department, int64, *exceptions.Exception) {

	payload := ctx.MustGet(middleware.AuthorizationPayloadKey).((*security.Payload))
	visitedUser, err := uc.repo.GetUserByName(ctx, payload.Username)
	if err != nil {
		return nil, 0, err
	}

	if req.CompanyID == 0 {
		req.CompanyID = visitedUser.ActiveCompany.Int64
	}

	departments, err := uc.repo.GetAllDepartment(ctx, sqlc.GetAllDepartmentParams{
		Limit:     req.PageSize,
		Offset:    (req.PageNo - 1) * req.PageSize,
		CompanyID: req.CompanyID,
		Search:    utils.AddPercent(req.Search),
	})
	if err != nil {
		return nil, 0, err
	}

	count, err := uc.repo.GetCountAllDepartment(ctx, sqlc.GetCountAllDepartmentParams{
		CompanyID: req.CompanyID,
		Search:    utils.AddPercent(req.Search),
	})
	if err != nil {
		return nil, 0, err
	}
	return departments, count, nil
}

func (uc *departmentUseCase) UpdateDepartment(ctx *gin.Context, req domain.UpdateDepartmentRequest) (*sqlc.Department, *exceptions.Exception) {
	oldDepartment, err := uc.repo.GetDepartment(ctx, sqlc.GetDepartmentParams{
		CompanyID:    req.CompanyID,
		DepartmentID: req.ID,
	})
	log.Println("testing old department ", oldDepartment, "::", err)
	if err != nil {
		return nil, err
	}

	updateDepartment, err := uc.repo.UpdateDepartment(ctx, sqlc.UpdateDepartmentParams{
		ID:         oldDepartment.ID,
		Department: req.Department,
		DepartmentAr: pgtype.Text{
			String: req.ArabicDepartment,
			Valid:  req.ArabicDepartment != "",
		},
		UpdatedAt: time.Now(),
		CompanyID: req.CompanyID,
	})
	if err != nil {
		return nil, err
	}

	return updateDepartment, nil
}

func (uc *departmentUseCase) DeleteDepartment(ctx *gin.Context, req domain.GetDepartmentRequest) *exceptions.Exception {
	department, err := uc.repo.GetDepartment(ctx, sqlc.GetDepartmentParams{
		CompanyID:    req.CompanyID,
		DepartmentID: req.Id,
	})
	if err != nil {
		return err
	}

	if department.ID != req.Id {
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "id is not a valid department id")
	}

	er := uc.repo.DeleteDepartment(ctx, sqlc.DeleteDepartmentParams{
		ID:        req.Id,
		CompanyID: req.CompanyID,
	})
	if er != nil {
		return er
	}

	return nil
}

func NewDepartmentUseCase(repo db.UserCompositeRepo) DepartmentUseCase {
	return &departmentUseCase{
		repo: repo,
	}
}
