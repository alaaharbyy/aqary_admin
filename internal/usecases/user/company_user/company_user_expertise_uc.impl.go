package companyuser_usecase

import (
	domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils/exceptions"
	"fmt"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
)

// AddExpertiseForCompanyUser implements CompanyUserUseCase.
func (uc *companyUserUseCase) AddExpertiseForCompanyUser(c *gin.Context, req domain.AddExpertiseReq) (*string, *exceptions.Exception) {
	// Get all existing expertise records for this company user
	existingExpertise, err := uc.repo.GetCompanyUserExpertise(c, sqlc.GetCompanyUserExpertiseParams{
		CompanyUserID: req.CompanyUserID,
	}, nil)
	if err != nil {
		return nil, err
	}

	// Create a map of existing expertise IDs for easier lookup
	existingExpertiseMap := make(map[int64]bool)
	for _, expertise := range existingExpertise {
		existingExpertiseMap[expertise.ExpertiseID] = true
	}

	// Track IDs to create (in request but not in DB)
	var toCreate []int64
	for _, expertiseID := range req.ExpertiseIDs {
		if !existingExpertiseMap[expertiseID] {
			toCreate = append(toCreate, expertiseID)
		}
	}

	// Track IDs to delete (in DB but not in request)
	var toDelete []int64
	requestExpertiseMap := make(map[int64]bool)
	for _, expertiseID := range req.ExpertiseIDs {
		requestExpertiseMap[expertiseID] = true
	}

	for _, expertise := range existingExpertise {
		if !requestExpertiseMap[expertise.ExpertiseID] {
			toDelete = append(toDelete, expertise.ExpertiseID)
		}
	}

	// Delete expertise records that are no longer in the request
	err = uc.repo.BulkDeleteCompanyUserExpertise(c, sqlc.BulkDeleteCompanyUserExpertiseParams{
		ExpertiseIds:  toDelete,
		CompanyUserID: req.CompanyUserID,
	}, nil)
	if err != nil {
		return nil, err
	}

	// Create new expertise records
	for _, expertiseID := range toCreate {
		_, err := uc.repo.CreateCompanyUserExpertise(c, sqlc.CreateCompanyUserExpertiseParams{
			ExpertiseID:   expertiseID,
			CompanyUserID: req.CompanyUserID,
		}, nil)
		if err != nil {
			return nil, err
		}
	}

	// Generate response message
	var resp string
	if len(toCreate) > 0 && len(toDelete) > 0 {
		resp = fmt.Sprintf("Successfully added %d and removed %d expertise records for company user", len(toCreate), len(toDelete))
	} else if len(toCreate) > 0 {
		resp = fmt.Sprintf("Successfully added %d expertise records for company user", len(toCreate))
	} else if len(toDelete) > 0 {
		resp = fmt.Sprintf("Successfully removed %d expertise records for company user", len(toDelete))
	} else {
		resp = "No changes needed to expertise records"
	}

	return &resp, nil
}

type GetCompanyUserExpertiseRow struct {
	ID          int64       `json:"id"`
	ExpertiseID int64       `json:"expertise_id"`
	Title       string      `json:"title"`
	TitleAr     pgtype.Text `json:"title_ar"`
}

// GetAllCompanyUserExpertise implements CompanyUserUseCase.
func (uc *companyUserUseCase) GetAllCompanyUserExpertise(c *gin.Context, req domain.GetExpertiseByUserReq) (any, int64, *exceptions.Exception) {
	var offset, limit pgtype.Int4

	if req.PageNo != 0 && req.PageSize != 0 {
		offset = pgtype.Int4{Int32: int32(req.PageNo-1) * int32(req.PageSize), Valid: true}
		limit = pgtype.Int4{Int32: int32(req.PageSize), Valid: true}

		if req.PageSize < 1 || req.PageSize > 100 {
			return nil, 0, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "page size should be between 1 and 100")
		}
		if req.PageNo <= 0 {
			return nil, 0, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "page no should be greater than 0")

		}
	}
	data, err := uc.repo.GetCompanyUserExpertise(c, sqlc.GetCompanyUserExpertiseParams{
		CompanyUserID: req.CompanyUserID,
		Offset:        offset,
		Limit:         limit,
	}, nil)
	if err != nil {
		return nil, 0, err
	}

	count, err := uc.repo.GetCompanyUserExpertiseCount(c, req.CompanyUserID, nil)
	if err != nil {
		return nil, 0, err
	}
	return data, count, nil
}

// GetCompanyUserExpertise implements CompanyUserUseCase.
func (uc *companyUserUseCase) GetCompanyUserExpertise(c *gin.Context, req int64) (any, *exceptions.Exception) {
	data, err := uc.repo.GetSingleCompanyUserExpertise(c, req, nil)
	if err != nil {
		return nil, err
	}
	return data, nil
}

// // RemoveCompanyUserExpertise implements CompanyUserUseCase.
// func (uc *companyUserUseCase) RemoveCompanyUserExpertise(c *gin.Context, req int64) (*string, *exceptions.Exception) {
// 	err := uc.repo.DeleteCompanyUserExpertise(c, req, nil)
// 	if err != nil {
// 		return nil, err
// 	}
// 	resp := "successfully deleted"
// 	return &resp, nil
// }
