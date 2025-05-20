package license

import (
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils/exceptions"
	repoerror "aqary_admin/pkg/utils/repo_error"
	"context"

	"github.com/gin-gonic/gin"
)

type LicenseRepo interface {
	CreateLicense(c *gin.Context, arg sqlc.CreateLicenseParams, q sqlc.Querier) (*sqlc.License, *exceptions.Exception)
	CreateStateLicenseFields(c *gin.Context, arg sqlc.CreateStateLicenseFieldsParams, q sqlc.Querier) (*sqlc.StateLicenseField, *exceptions.Exception)
	GetLicensesByEntityAndEntityTypeID(c *gin.Context, arg sqlc.GetLicensesByEntityAndEntityTypeIDParams) ([]sqlc.GetLicensesByEntityAndEntityTypeIDRow, *exceptions.Exception)
	UpdateLicense(c *gin.Context, arg sqlc.UpdateLicenseParams, q sqlc.Querier) (*sqlc.License, *exceptions.Exception)
	DeleteAllLicensesByIds(c *gin.Context, ids []int64, q sqlc.Querier) *exceptions.Exception
	UpdateStateLicenseFieldsByLicense(c *gin.Context, arg sqlc.UpdateStateLicenseFieldsByLicenseParams, q sqlc.Querier) (*sqlc.StateLicenseField, *exceptions.Exception)
	DeleteStateLicenseFieldsByNames(c *gin.Context, arg sqlc.DeleteStateLicenseFieldsByNamesParams, q sqlc.Querier) *exceptions.Exception
	UpdateLicenseStateByEntityAndEntityTypeId(c *gin.Context, arg sqlc.UpdateLicenseStateByEntityAndEntityTypeIdParams, q sqlc.Querier) *exceptions.Exception
	GetLicensesByID(ctx context.Context, id int64) (*sqlc.License, *exceptions.Exception)
	GetUserLicenseByID(ctx context.Context, id int64) (*sqlc.License, *exceptions.Exception)
}

type licenseRepo struct {
	querier sqlc.Querier
}

// GetUserLicenseByID implements LicenseRepo.
func (l *licenseRepo) GetUserLicenseByID(ctx context.Context, id int64) (*sqlc.License, *exceptions.Exception) {
	license, err := l.querier.GetUserLicenseByID(ctx, id)
	if err != nil {
		return nil, repoerror.BuildRepoErr("license", "GetUserLicenseByID", err)
	}
	return &license, nil
}

// GetLicensesByID implements LicenseRepo.
func (l *licenseRepo) GetLicensesByID(ctx context.Context, id int64) (*sqlc.License, *exceptions.Exception) {
	license, err := l.querier.GetLicensesByID(ctx, id)
	if err != nil {
		return nil, repoerror.BuildRepoErr("license", "GetLicensesByID", err)
	}
	return &license, nil
}

// UpdateLicenseStateByEntityAndEntityTypeId implements LicenseRepo.
func (l *licenseRepo) UpdateLicenseStateByEntityAndEntityTypeId(c *gin.Context, arg sqlc.UpdateLicenseStateByEntityAndEntityTypeIdParams, q sqlc.Querier) *exceptions.Exception {
	err := q.UpdateLicenseStateByEntityAndEntityTypeId(c, arg)
	return repoerror.BuildRepoErr("license", "UpdateLicenseStateByEntityAndEntityTypeId", err)
}

// DeleteStateLicenseFieldsByNames implements LicenseRepo.
func (l *licenseRepo) DeleteStateLicenseFieldsByNames(c *gin.Context, arg sqlc.DeleteStateLicenseFieldsByNamesParams, q sqlc.Querier) *exceptions.Exception {
	err := q.DeleteStateLicenseFieldsByNames(c, arg)
	return repoerror.BuildRepoErr("license", "DeleteStateLicenseFieldsByNames", err)
}

// UpdateStateLicenseFieldsByLicense implements LicenseRepo.
func (l *licenseRepo) UpdateStateLicenseFieldsByLicense(c *gin.Context, arg sqlc.UpdateStateLicenseFieldsByLicenseParams, q sqlc.Querier) (*sqlc.StateLicenseField, *exceptions.Exception) {
	license, err := q.UpdateStateLicenseFieldsByLicense(c, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("license", "UpdateStateLicenseFieldsByLicense", err)
	}
	return &license, nil
}

// DeleteAllLicensesByIds implements LicenseRepo.
func (l *licenseRepo) DeleteAllLicensesByIds(c *gin.Context, ids []int64, q sqlc.Querier) *exceptions.Exception {
	err := q.DeleteAllLicensesByIds(c, ids)
	return repoerror.BuildRepoErr("license", "DeleteAllLicensesByIds", err)
}

// UpdateLicense implements LicenseRepo.
func (l *licenseRepo) UpdateLicense(c *gin.Context, arg sqlc.UpdateLicenseParams, q sqlc.Querier) (*sqlc.License, *exceptions.Exception) {
	license, err := q.UpdateLicense(c, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("license", "UpdateLicense", err)
	}
	return &license, nil
}

// GetLicensesByEntityAndEntityTypeID implements LicenseRepo.
func (l *licenseRepo) GetLicensesByEntityAndEntityTypeID(c *gin.Context, arg sqlc.GetLicensesByEntityAndEntityTypeIDParams) ([]sqlc.GetLicensesByEntityAndEntityTypeIDRow, *exceptions.Exception) {
	license, err := l.querier.GetLicensesByEntityAndEntityTypeID(c, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("license", "GetLicensesByEntityAndEntityTypeID", err)
	}
	return license, nil
}

// CreateLicense implements LicenseRepo.
func (l *licenseRepo) CreateLicense(c *gin.Context, arg sqlc.CreateLicenseParams, q sqlc.Querier) (*sqlc.License, *exceptions.Exception) {
	license, err := q.CreateLicense(c, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("license", "CreateLicense", err)
	}
	return &license, nil
}

// CreateStateLicenseFields implements LicenseRepo.
func (l *licenseRepo) CreateStateLicenseFields(c *gin.Context, arg sqlc.CreateStateLicenseFieldsParams, q sqlc.Querier) (*sqlc.StateLicenseField, *exceptions.Exception) {
	license, err := q.CreateStateLicenseFields(c, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("license", "CreateStateLicenseFields", err)
	}
	return &license, nil
}

func NewLicenseRepository(querier sqlc.Querier) LicenseRepo {
	return &licenseRepo{
		querier: querier,
	}
}
