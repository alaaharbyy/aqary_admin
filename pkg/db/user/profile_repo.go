package db

import (
	"context"
	"errors"
	"fmt"

	"aqary_admin/internal/delivery/rest/middleware"
	"aqary_admin/internal/domain/sqlc/sqlc"
	auth_utils "aqary_admin/pkg/utils/auth"
	"aqary_admin/pkg/utils/exceptions"
	repoerror "aqary_admin/pkg/utils/repo_error"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
)

type ProfileRepo interface {
	CreateProfile(ctx *gin.Context, args sqlc.CreateProfileParams, q sqlc.Querier) (*sqlc.Profile, *exceptions.Exception)
	GetAllProfile(ctx context.Context) ([]*sqlc.Profile, *exceptions.Exception)
	GetProfile(ctx context.Context, id int64) (*sqlc.Profile, *exceptions.Exception)
	UpdateProfile(ctx context.Context, args sqlc.UpdateProfileParams, q sqlc.Querier) (*sqlc.Profile, *exceptions.Exception)
	DeleteProfile(ctx context.Context, id int64) (*string, *exceptions.Exception)
	GetProfileByUserId(ctx context.Context, userid int64) (*sqlc.Profile, *exceptions.Exception)
	CreateProfileNationalities(ctx *gin.Context, arg sqlc.CreateProfileNationalitiesParams, q sqlc.Querier) (*sqlc.ProfileNationality, *exceptions.Exception)
	CreateProfileLanguage(ctx context.Context, arg sqlc.CreateProfileLanguageParams, q sqlc.Querier) (*sqlc.ProfileLanguage, *exceptions.Exception)

	GetNationalitiesIDsByProfile(ctx context.Context, arg int64, q sqlc.Querier) ([]int64, *exceptions.Exception)
	GetLanguagesIDsByProfile(ctx context.Context, arg int64, q sqlc.Querier) ([]int64, *exceptions.Exception)

	DeleteProfileNationalityList(ctx context.Context, arg sqlc.DeleteProfileNationalityListParams, q sqlc.Querier) *exceptions.Exception
	DeleteProfileLanguageList(ctx context.Context, arg sqlc.DeleteProfileLanguageListParams, q sqlc.Querier) *exceptions.Exception

	GetOrganization(ctx *gin.Context, arg sqlc.GetOrganizationParams) ([]sqlc.GetOrganizationRow, *exceptions.Exception)

	// GetUserDetailsByUserName(ctx context.Context, username string) (sqlc.GetUserDetailsByUserNameRow, *exceptions.Exception)
	// GetAssociatedCompanies(ctx context.Context, arg sqlc.GetAssociatedCompaniesParams) ([]byte, *exceptions.Exception)

	// // all the permission related repo
	// GetAqaryUserPermissions(ctx context.Context, arg sqlc.GetAqaryUserPermissionsParams) ([]int64, *exceptions.Exception)
	// GetAqaryUserSubSectionPermissions(ctx context.Context, arg sqlc.GetAqaryUserSubSectionPermissionsParams) ([]int64, *exceptions.Exception)

	// GetAqaryAdminPermissions(ctx context.Context, id int64) (sqlc.GetAqaryAdminPermissionsRow, *exceptions.Exception)

	// GetCompanyAdminPermissions(ctx context.Context, arg sqlc.GetCompanyAdminPermissionsParams) (sqlc.GetCompanyAdminPermissionsRow, *exceptions.Exception)
	// GetRolePermissions(ctx context.Context, id int64) (sqlc.GetRolePermissionsRow, *exceptions.Exception)
}

type profileRepository struct {
	querier sqlc.Querier
}

// GetOrganization implements ProfileRepo.
func (u *profileRepository) GetOrganization(ctx *gin.Context, arg sqlc.GetOrganizationParams) ([]sqlc.GetOrganizationRow, *exceptions.Exception) {
	organization, err := u.querier.GetOrganization(ctx, arg)
	buildProfileErr("GetOrganization", err)
	return organization, nil
}

// DeleteProfileLanguageList implements ProfileRepo.
func (u *profileRepository) DeleteProfileLanguageList(ctx context.Context, arg sqlc.DeleteProfileLanguageListParams, q sqlc.Querier) *exceptions.Exception {
	if q == nil {
		q = u.querier
	}

	u.querier, q = auth_utils.CheckAuthForTests(ctx, u.querier, q)
	err := q.DeleteProfileLanguageList(ctx, arg)
	buildProfileErr("DeleteProfileLanguageList", err)
	return nil
}

// DeleteProfileNationalityList implements ProfileRepo.
func (u *profileRepository) DeleteProfileNationalityList(ctx context.Context, arg sqlc.DeleteProfileNationalityListParams, q sqlc.Querier) *exceptions.Exception {
	if q == nil {
		q = u.querier
	}

	u.querier, q = auth_utils.CheckAuthForTests(ctx, u.querier, q)
	err := q.DeleteProfileNationalityList(ctx, arg)
	buildProfileErr("DeleteProfileNationalityList", err)
	return nil
}

// GetLanguagesIDsByProfile implements ProfileRepo.
func (u *profileRepository) GetLanguagesIDsByProfile(ctx context.Context, arg int64, q sqlc.Querier) ([]int64, *exceptions.Exception) {
	if q == nil {
		q = u.querier
	}

	u.querier, q = auth_utils.CheckAuthForTests(ctx, u.querier, q)
	languages, err := q.GetLanguagesIDsByProfile(ctx, arg)
	buildProfileErr("GetLanguagesIDsByProfile", err)
	return languages, nil
}

// GetNationalitiesIDsByProfile implements ProfileRepo.
func (u *profileRepository) GetNationalitiesIDsByProfile(ctx context.Context, arg int64, q sqlc.Querier) ([]int64, *exceptions.Exception) {
	if q == nil {
		q = u.querier
	}

	u.querier, q = auth_utils.CheckAuthForTests(ctx, u.querier, q)
	nationalities, err := q.GetNationalitiesIDsByProfile(ctx, arg)
	buildProfileErr("GetNationalitiesIDsByProfile", err)
	return nationalities, nil
}

// CreateProfileLanguage implements ProfileRepo.
func (u *profileRepository) CreateProfileLanguage(ctx context.Context, arg sqlc.CreateProfileLanguageParams, q sqlc.Querier) (*sqlc.ProfileLanguage, *exceptions.Exception) {
	if q == nil {
		q = u.querier
	}

	u.querier, q = auth_utils.CheckAuthForTests(ctx, u.querier, q)
	language, err := q.CreateProfileLanguage(ctx, arg)
	buildProfileErr("CreateProfileLanguage", err)
	return &language, nil
}

// // CheckProfileLanguageExists implements ProfileRepo.
// func (u *profileRepository) CheckProfileLanguageExists(ctx context.Context, arg sqlc.CheckProfileLanguageExistsParams) (*sqlc.CheckProfileLanguageExistsRow, *exceptions.Exception) {
// 	language, err := u.querier.CheckProfileLanguageExists(ctx, arg)
// 	buildProfileErr("CheckProfileLanguageExists", err)
// 	return &language, nil
// }

// // CheckProfileNationalityExists implements ProfileRepo.
// func (u *profileRepository) CheckProfileNationalityExists(ctx context.Context, arg sqlc.CheckProfileNationalityExistsParams) (*sqlc.CheckProfileNationalityExistsRow, *exceptions.Exception) {
// 	nationality, err := u.querier.CheckProfileNationalityExists(ctx, arg)
// 	buildProfileErr("CheckProfileNationalityExists", err)
// 	return &nationality, nil
// }

// CreateProfileNationalities implements ProfileRepo.
func (u *profileRepository) CreateProfileNationalities(ctx *gin.Context, arg sqlc.CreateProfileNationalitiesParams, q sqlc.Querier) (*sqlc.ProfileNationality, *exceptions.Exception) {
	if q == nil {
		q = u.querier
	}

	u.querier, q = auth_utils.CheckAuthForTests(ctx, u.querier, q)
	profile, err := q.CreateProfileNationalities(ctx, arg)
	// buildProfileErr("CreateProfile", err)
	if err != nil {
		return nil, repoerror.BuildRepoErr("profile", "CreateProfileNationalities", err)
	}
	return &profile, nil
}

// GetProfileByUserId implements ProfileRepo.
func (u *profileRepository) GetProfileByUserId(ctx context.Context, userid int64) (*sqlc.Profile, *exceptions.Exception) {
	profile, err := u.querier.GetProfileByUserId(ctx, userid)
	buildProfileErr("GetProfileByUserId", err)
	return &profile, nil
}

func NewProfileRepository(querier sqlc.Querier) ProfileRepo {
	return &profileRepository{
		querier: querier,
	}
}

func (u *profileRepository) CreateProfile(ctx *gin.Context, args sqlc.CreateProfileParams, q sqlc.Querier) (*sqlc.Profile, *exceptions.Exception) {
	if q == nil {
		q = u.querier
	}

	u.querier, q = auth_utils.CheckAuthForTests(ctx, u.querier, q)
	profile, err := q.CreateProfile(ctx, args)
	// buildProfileErr("CreateProfile", err)
	if err != nil {
		return nil, repoerror.BuildRepoErr("profile", "CreateProfile", err)
	}
	return &profile, nil
}

func (u *profileRepository) GetAllProfile(ctx context.Context) ([]*sqlc.Profile, *exceptions.Exception) {

	var allProfiles []*sqlc.Profile
	profiles, err := u.querier.GetAllProfile(ctx, sqlc.GetAllProfileParams{Limit: 100})
	buildErr("GetAllProfile", err)
	for _, p := range profiles {
		allProfiles = append(allProfiles, &p)
	}
	return allProfiles, nil
}

func (u *profileRepository) GetProfile(ctx context.Context, id int64) (*sqlc.Profile, *exceptions.Exception) {
	profile, err := u.querier.GetProfile(ctx, id)
	buildProfileErr("GetProfile", err)
	return &profile, nil
}

func (u *profileRepository) UpdateProfile(ctx context.Context, args sqlc.UpdateProfileParams, q sqlc.Querier) (*sqlc.Profile, *exceptions.Exception) {
	if q == nil {
		q = u.querier
	}

	u.querier, q = auth_utils.CheckAuthForTests(ctx, u.querier, q)
	profile, err := q.UpdateProfile(ctx, args)
	buildProfileErr("UpdateProfile", err)

	return &profile, nil
}

func (u *profileRepository) DeleteProfile(ctx context.Context, id int64) (*string, *exceptions.Exception) {
	err := u.querier.DeleteProfile(ctx, id)
	buildProfileErr("DeleteProfile", err)
	s := "successfully deleted profile"
	return &s, nil
}

func buildProfileErr(name string, err error) (any, any) {
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode)
		}
		middleware.IncrementServerErrorCounter(fmt.Errorf("[users.repo.%v] error:%v", name, err).Error())
		return nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}
	return nil, nil
}
