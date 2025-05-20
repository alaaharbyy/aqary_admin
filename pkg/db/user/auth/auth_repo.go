package auth_repo

import (
	"errors"
	"fmt"
	"log"

	"aqary_admin/internal/delivery/rest/middleware"
	domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"

	auth_utils "aqary_admin/pkg/utils/auth"
	"aqary_admin/pkg/utils/exceptions"
	repoerror "aqary_admin/pkg/utils/repo_error"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
)

type AuthRepository interface {
	GetCountryByName(c *gin.Context, country string) (*sqlc.Country, error)
	CreateCountry(c *gin.Context, args sqlc.CreateCountryParams, q sqlc.Querier) (*sqlc.Country, error)
	GetSuperUser(c *gin.Context) (*sqlc.User, error)
	GetLanguageByLanguage(c *gin.Context, language string) (*sqlc.AllLanguage, error)
	CreateLanguage(c *gin.Context, args sqlc.CreateLanguageParams, q sqlc.Querier) (*sqlc.AllLanguage, error)
	GetCompanySectionPermission(c *gin.Context) (*sqlc.SectionPermission, error)
	GetAddCompanyPermission(c *gin.Context) (*sqlc.Permission, error)
	GetPermissionMV(c *gin.Context, id int64) (*sqlc.PermissionsMv, error)
	GetSectionPermissionMV(c *gin.Context, id int64) (*sqlc.SectionPermissionMv, error)

	CreateUserPermission(c *gin.Context, args sqlc.CreateUserPermissionParams, q sqlc.Querier) (sqlc.UserCompanyPermission, *exceptions.Exception)
	CreateUserPermissionTest(c *gin.Context, args sqlc.CreateUserPermissionTestParams, q sqlc.Querier) (sqlc.UserCompanyPermissionsTest, *exceptions.Exception)

	GetUserPermissionByID(c *gin.Context, args sqlc.GetUserPermissionsByIDParams) (sqlc.UserCompanyPermission, *exceptions.Exception)

	GetUserCompanyPermissionByID(c *gin.Context, args sqlc.GetUserCompanyPermissionsByIDParams) ([]int64, *exceptions.Exception)
	GetUserCompanySubSectionPermissionsByID(c *gin.Context, args sqlc.GetUserCompanySubSectionPermissionsByIDParams) ([]int64, *exceptions.Exception)

	GetUserPermissionsTestByID(c *gin.Context, args sqlc.GetUserPermissionsTestByIDParams) ([]int64, *exceptions.Exception)
	GetUserSubSectionPermissionsTestByID(c *gin.Context, args sqlc.GetUserSubSectionPermissionsTestByIDParams) ([]int64, *exceptions.Exception)
	GetAllPermissionFromUserByID(c *gin.Context, args sqlc.GetUserPermissionsByIDParams) (*sqlc.UserCompanyPermission, *exceptions.Exception)

	UpdateUserPermissionByID(c *gin.Context, args sqlc.UpdateUserPermissionsByIDParams) (sqlc.UserCompanyPermission, *exceptions.Exception)
	UpdateUserStatusWithoutUpdateTime(c *gin.Context, req domain.UserUpdateStatusReq) (*sqlc.User, *exceptions.Exception)
}

// GetAllPermissionFromUserByID implements AuthRepository.
func (u *authRepository) GetAllPermissionFromUserByID(c *gin.Context, args sqlc.GetUserPermissionsByIDParams) (*sqlc.UserCompanyPermission, *exceptions.Exception) {
	userPerm, err := u.querier.GetUserPermissionsByID(c, args)
	if err != nil {
		return nil, repoerror.BuildRepoErr("auth repo", "GetUserPermissionByID", err)
	}
	return &userPerm, nil
}

func (u authRepository) GetCountryByName(c *gin.Context, userName string) (*sqlc.Country, error) {

	country, err := u.querier.GetCountryByName(c, userName)
	log.Println("testing country by name", country)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("no country found")
		}
		middleware.IncrementServerErrorCounter(fmt.Errorf("[auth.repo.GetCountryByName] error:%v", err).Error())
		return nil, err
	}
	return &country, nil
}

func (u authRepository) CreateCountry(c *gin.Context, args sqlc.CreateCountryParams, q sqlc.Querier) (*sqlc.Country, error) {
	//lint:ignore SA4005 Intentional assignment to u.querier
	u.querier, q = auth_utils.CheckAuthForTests(c, u.querier, q)
	country, err := q.CreateCountry(c, args)
	if err != nil {
		middleware.IncrementServerErrorCounter(fmt.Errorf("[auth.repo.CreateCountry] error:%v", err).Error())
		return nil, err
	}
	return &country, nil
}

func (u authRepository) GetSuperUser(c *gin.Context) (*sqlc.User, error) {
	superUser, err := u.querier.GetSuperUser(c)

	if err != nil {
		middleware.IncrementServerErrorCounter(fmt.Errorf("[auth.repo.GetSuperUser] error:%v", err).Error())
		return nil, err
	}

	return &superUser, nil
}

func (u authRepository) GetLanguageByLanguage(c *gin.Context, language string) (*sqlc.AllLanguage, error) {

	l, err := u.querier.GetLanguageByLanguage(c, language)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("not language found")
		}
		middleware.IncrementServerErrorCounter(fmt.Errorf("[auth.repo.GetLanguageByLanguage] error:%v", err).Error())
		return nil, err
	}
	return &l, nil
}

func (u authRepository) CreateLanguage(c *gin.Context, args sqlc.CreateLanguageParams, q sqlc.Querier) (*sqlc.AllLanguage, error) {
	//lint:ignore SA4005 Intentional assignment to u.querier
	u.querier, q = auth_utils.CheckAuthForTests(c, u.querier, q)
	language, err := q.CreateLanguage(c, args)
	if err != nil {
		middleware.IncrementServerErrorCounter(fmt.Errorf("[auth.repo.CreateLanguage] error:%v", err).Error())
		return nil, err
	}
	return &language, nil
}

func (u authRepository) GetCompanySectionPermission(c *gin.Context) (*sqlc.SectionPermission, error) {
	sectionPermission, err := u.querier.GetCompanySectionPermission(c)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, fmt.Errorf("no company section permission available")
		}
		middleware.IncrementServerErrorCounter(fmt.Errorf("[auth.repo.GetCompanySectionPermission] error:%v", err).Error())
		return nil, err
	}

	return &sectionPermission, nil
}

func (u authRepository) GetAddCompanyPermission(c *gin.Context) (*sqlc.Permission, error) {

	permission, err := u.querier.GetAddCompanyPermission(c)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, fmt.Errorf("no company permission found")
		}
		middleware.IncrementServerErrorCounter(fmt.Errorf("[auth.repo.GetAddCompanyPermission] error:%v", err).Error())
		return nil, fmt.Errorf("error while getting company permission:%v", err)
	}
	return &permission, nil

}

func (u authRepository) GetPermissionMV(c *gin.Context, id int64) (*sqlc.PermissionsMv, error) {

	p, err := u.querier.GetPermissionMV(c, id)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("no permisison mv found")
		}
		middleware.IncrementServerErrorCounter(fmt.Errorf("[auth.repo.GetPermissionMV] error:%v", err).Error())
		return nil, err
	}
	return &p, nil
}

func (u authRepository) GetSectionPermissionMV(c *gin.Context, id int64) (*sqlc.SectionPermissionMv, error) {
	sectionPermission, err := u.querier.GetSectionPermissionMV(c, id)

	log.Println("error is here", err)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("no section permission found")
		}
		middleware.IncrementServerErrorCounter(fmt.Errorf("[auth.repo.GetSectionPermissionMV] error:%v", err).Error())
		return nil, err
	}
	return &sectionPermission, nil
}

type authRepository struct {
	querier sqlc.Querier
}

// UpdateUserStatusWithoutUpdateTime implements AuthRepository.
func (u *authRepository) UpdateUserStatusWithoutUpdateTime(c *gin.Context, req domain.UserUpdateStatusReq) (*sqlc.User, *exceptions.Exception) {
	user, err := u.querier.UpdateUserStatusWithoutUpdateTime(c, sqlc.UpdateUserStatusWithoutUpdateTimeParams{
		ID:     req.ID,
		Status: req.Status,
	})
	if err != nil {
		return nil, repoerror.BuildRepoErr("auth repo", "UpdateUserStatusWithoutUpdateTime", err)
	}
	return &user, nil
}

// GetUserPermissionsTestByID implements AuthRepository.
func (u *authRepository) GetUserPermissionsTestByID(c *gin.Context, args sqlc.GetUserPermissionsTestByIDParams) ([]int64, *exceptions.Exception) {
	userPerm, err := u.querier.GetUserPermissionsTestByID(c, args)
	if err != nil {
		return nil, repoerror.BuildRepoErr("auth repo", "GetUserPermissionsTestByID", err)
	}
	return userPerm, nil
}

// GetUserSubSectionPermissionsTestByID implements AuthRepository.
func (u *authRepository) GetUserSubSectionPermissionsTestByID(c *gin.Context, args sqlc.GetUserSubSectionPermissionsTestByIDParams) ([]int64, *exceptions.Exception) {
	userPerm, err := u.querier.GetUserSubSectionPermissionsTestByID(c, args)
	if err != nil {
		return nil, repoerror.BuildRepoErr("auth repo", "GetUserSubSectionPermissionsTestByID", err)
	}
	return userPerm, nil
}

// GetUserPermissionByID implements AuthRepository.
func (u *authRepository) GetUserPermissionByID(c *gin.Context, args sqlc.GetUserPermissionsByIDParams) (sqlc.UserCompanyPermission, *exceptions.Exception) {
	userPerm, err := u.querier.GetUserPermissionsByID(c, args)
	if err != nil {
		return sqlc.UserCompanyPermission{}, repoerror.BuildRepoErr("auth repo", "GetUserPermissionByID", err)
	}
	return userPerm, nil
}

func (u *authRepository) GetUserCompanyPermissionByID(c *gin.Context, args sqlc.GetUserCompanyPermissionsByIDParams) ([]int64, *exceptions.Exception) {
	userPerm, err := u.querier.GetUserCompanyPermissionsByID(c, args)
	if err != nil {
		return nil, repoerror.BuildRepoErr("auth repo", "GetUserCompanyPermissionByID", err)
	}
	return userPerm, nil
}

func (u *authRepository) GetUserCompanySubSectionPermissionsByID(c *gin.Context, args sqlc.GetUserCompanySubSectionPermissionsByIDParams) ([]int64, *exceptions.Exception) {
	userPerm, err := u.querier.GetUserCompanySubSectionPermissionsByID(c, args)
	if err != nil {
		return nil, repoerror.BuildRepoErr("auth repo", "GetUserCompanySubSectionPermissionsByID", err)
	}
	return userPerm, nil
}

// GetUserPermissionByID implements AuthRepository.
func (u *authRepository) UpdateUserPermissionByID(c *gin.Context, args sqlc.UpdateUserPermissionsByIDParams) (sqlc.UserCompanyPermission, *exceptions.Exception) {
	userPerm, err := u.querier.UpdateUserPermissionsByID(c, args)
	if err != nil {
		return sqlc.UserCompanyPermission{}, repoerror.BuildRepoErr("auth UpdateUserPermissionByID", "UpdateUserPermissionByID", err)
	}
	return userPerm, nil
}

// CreateUserPermission implements AuthRepository.
func (u *authRepository) CreateUserPermission(c *gin.Context, args sqlc.CreateUserPermissionParams, q sqlc.Querier) (sqlc.UserCompanyPermission, *exceptions.Exception) {

	u.querier, q = auth_utils.CheckAuthForTests(c, u.querier, q)

	userPermission, err := q.CreateUserPermission(c, args)
	if err != nil {
		return sqlc.UserCompanyPermission{}, repoerror.BuildRepoErr("CreateUserPermission", "CreateUserPermission", err)
	}
	return userPermission, nil
}

// CreateUserPermission implements AuthRepository.
func (u *authRepository) CreateUserPermissionTest(c *gin.Context, args sqlc.CreateUserPermissionTestParams, q sqlc.Querier) (sqlc.UserCompanyPermissionsTest, *exceptions.Exception) {

	// u.querier, q = auth_utils.CheckAuthForTests(c, u.querier, q)

	userPermission, err := u.querier.CreateUserPermissionTest(c, args)
	if err != nil {
		log.Println("testing user permisison error", err)
		return sqlc.UserCompanyPermissionsTest{}, repoerror.BuildRepoErr("repo", "CreateUserPermissionTest", err)
	}
	return userPermission, nil
}

func NewAuthRepository(querier sqlc.Querier) AuthRepository {
	return &authRepository{
		querier: querier,
	}
}
