package permissions_usecase

import (
	"strings"
	"time"

	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
)

func (uc *permissionUseCase) CreateSectionPermission(ctx *gin.Context, req domain.CreateSectionPermissionRequest) (*response.SectionPermission, *exceptions.Exception) {
	req.Title = utils.SanitizeString(req.Title)

	oldSectionPermission, err := uc.repo.GetSectionPermissionByTitle(ctx, req.Title)
	if err == nil && strings.EqualFold(oldSectionPermission.Title, req.Title) {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "Section permission already exists")
	}

	sectionPermission, err := uc.repo.CreateSectionPermission(ctx, sqlc.CreateSectionPermissionParams{
		Title: req.Title,
		SubTitle: pgtype.Text{
			String: req.SubTitle,
			Valid:  true,
		},
		CreatedAt: time.Now(),
	}, nil)
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "Failed to create section permission")
	}

	return &response.SectionPermission{
		ID:       sectionPermission.ID,
		Title:    sectionPermission.Title,
		SubTitle: sectionPermission.SubTitle.String,
	}, nil
}

func (uc *permissionUseCase) GetAllSectionPermission(ctx *gin.Context, req domain.GetAllSectionPermissionRequest) ([]response.SectionPermission, int64, *exceptions.Exception) {
	sections, err := uc.repo.GetAllSectionPermission(ctx, sqlc.GetAllSectionPermissionParams{
		Limit:  int32(req.PageSize),
		Offset: int32((req.PageNo - 1) * req.PageSize),
		Search: utils.AddPercent(req.Search),
	})
	if err != nil {
		return nil, 0, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "Failed to fetch section permissions")
	}

	count, err := uc.repo.GetCountAllSectionPermission(ctx, utils.AddPercent(req.Search))
	if err != nil {
		return nil, 0, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "Failed to count section permissions")
	}

	var responseSections []response.SectionPermission
	for _, section := range sections {
		responseSections = append(responseSections, response.SectionPermission{
			ID:       section.ID,
			Title:    section.Title,
			SubTitle: section.SubTitle.String,
		})
	}

	return responseSections, count, nil
}

func (uc *permissionUseCase) GetAllSectionPermissionWithoutPagination(ctx *gin.Context) ([]response.SectionPermission, *exceptions.Exception) {
	sections, err := uc.repo.GetAllSectionPermissionWithoutPagination(ctx)
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "Failed to fetch section permissions")
	}

	var responseSections []response.SectionPermission
	for _, section := range sections {
		responseSections = append(responseSections, response.SectionPermission{
			ID:       section.ID,
			Title:    section.Title,
			SubTitle: section.SubTitle.String,
		})
	}

	return responseSections, nil
}

func (uc *permissionUseCase) UpdateSectionPermission(ctx *gin.Context, id int64, req domain.UpdateSectionPermissionRequest) (*response.SectionPermission, *exceptions.Exception) {
	oldSectionPermission, err := uc.repo.GetSectionPermission(ctx, id)
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "Section permission not found")
	}

	req.Title = utils.SanitizeString(req.Title)

	if req.Title == "" {
		req.Title = oldSectionPermission.Title
	}
	if req.SubTitle == "" {
		req.SubTitle = oldSectionPermission.SubTitle.String
	}

	updatedSectionPermission, err := uc.repo.UpdateSectionPermission(ctx, sqlc.UpdateSectionPermissionParams{
		ID:    oldSectionPermission.ID,
		Title: req.Title,
		SubTitle: pgtype.Text{
			String: req.SubTitle,
			Valid:  true,
		},
		CreatedAt: oldSectionPermission.CreatedAt,
		UpdatedAt: time.Now(),
	})
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "Failed to update section permission")
	}

	return &response.SectionPermission{
		ID:       updatedSectionPermission.ID,
		Title:    updatedSectionPermission.Title,
		SubTitle: updatedSectionPermission.SubTitle.String,
	}, nil
}

func (uc *permissionUseCase) DeleteSectionPermission(ctx *gin.Context, id int64) (*string, *exceptions.Exception) {
	_, err := uc.repo.GetSectionPermission(ctx, id)
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "Section permission not found")
	}

	out, err := uc.repo.DeleteSectionPermission(ctx, id)
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, err.Error())
	}
	return out, nil

}
