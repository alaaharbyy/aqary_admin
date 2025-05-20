package db

import (
	"errors"
	"fmt"
	"log"
	"strings"

	"aqary_admin/internal/delivery/rest/middleware"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/db/license"
	agent_repo_repo "aqary_admin/pkg/db/user/agent"
	auth_repo "aqary_admin/pkg/db/user/auth"
	companyusers_repo "aqary_admin/pkg/db/user/company_users"
	department_repo "aqary_admin/pkg/db/user/department"
	permissions_repo "aqary_admin/pkg/db/user/permissions"
	roles_repo "aqary_admin/pkg/db/user/roles"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"
	repoerror "aqary_admin/pkg/utils/repo_error"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
)

type UserCompositeRepoImpl struct {
	UserRepo
	ProfileRepo
	PendingUserRepo
	OtherUserRepo
	CompanyAdminRepo
	CheckEmailRepo
	AqaryUserRepo
	roles_repo.RoleRepo
	permissions_repo.PermissionRepo
	department_repo.DepartmentRepo
	companyusers_repo.CompanyUserRepo
	auth_repo.AuthRepository
	agent_repo_repo.AgentRepo
	license.LicenseRepo
}

type UserCompositeRepo interface {
	UserRepo
	ProfileRepo
	PendingUserRepo
	OtherUserRepo
	CompanyAdminRepo
	CheckEmailRepo
	AqaryUserRepo
	roles_repo.RoleRepo
	permissions_repo.PermissionRepo
	department_repo.DepartmentRepo
	companyusers_repo.CompanyUserRepo
	auth_repo.AuthRepository
	agent_repo_repo.AgentRepo
	license.LicenseRepo
}

func NewUserCompositeRepoModule(querier sqlc.Querier) UserCompositeRepo {
	return &UserCompositeRepoImpl{
		UserRepo:         NewUserRepository(querier),
		ProfileRepo:      NewProfileRepository(querier),
		PendingUserRepo:  NewPendingRepository(querier),
		OtherUserRepo:    NewOtherotherUserRepository(querier),
		CompanyAdminRepo: NewCompanyAdminRepository(querier),
		CheckEmailRepo:   NewCheckEmailRepository(querier),
		AqaryUserRepo:    NewAqaryUserRepository(querier),
		RoleRepo:         roles_repo.NewRoleRepository(querier),
		PermissionRepo:   permissions_repo.NewPermissionRepository(querier),
		DepartmentRepo:   department_repo.NewDepartmentRepository(querier),
		CompanyUserRepo:  companyusers_repo.NewCompanyUserRepository(querier),
		AuthRepository:   auth_repo.NewAuthRepository(querier),
		AgentRepo:        agent_repo_repo.NewUserAgentRepository(querier),
		LicenseRepo:      license.NewLicenseRepository(querier),
	}
}

type UserRepo interface {
	CreateUserType(c *gin.Context, arg sqlc.CreateUserTypeParams) (*sqlc.UserType, *exceptions.Exception)
	GetAllUserType(c *gin.Context) (*[]sqlc.UserType, *exceptions.Exception)
	GetAllUserTypesForWeb(c *gin.Context) (*[]sqlc.UserType, *exceptions.Exception)
	GetUserType(c *gin.Context, id int64) (*sqlc.UserType, *exceptions.Exception)
	UpdateUserType(c *gin.Context, args sqlc.UpdateUserTypeParams) (*sqlc.UserType, *exceptions.Exception)
	DeleteUserType(c *gin.Context, id int64) (*string, *exceptions.Exception)
	FilterAddressesForRole(c *gin.Context, user sqlc.User) (bool, int64, int64, bool, int64, int64, int64, int64, int64, int64, error)
	GetActiveUsersByType(c *gin.Context, args sqlc.GetActiveUsersByTypeParams) (*[]sqlc.GetActiveUsersByTypeRow, *exceptions.Exception)
	GetUserAssociatedCompanies(c *gin.Context, usersID int64) ([]sqlc.GetUserAssociatedCompaniesRow, *exceptions.Exception)

	GetUserDetailsByUserName(ctx *gin.Context, username string) (sqlc.GetUserDetailsByUserNameRow, *exceptions.Exception)
	GetAssociatedCompanies(ctx *gin.Context, arg sqlc.GetAssociatedCompaniesParams) ([]byte, *exceptions.Exception)

	// all the permission related repo
	GetAqaryUserPermissions(ctx *gin.Context, arg sqlc.GetAqaryUserPermissionsParams) ([]int64, *exceptions.Exception)
	GetAqaryUserSubSectionPermissions(ctx *gin.Context, arg sqlc.GetAqaryUserSubSectionPermissionsParams) ([]int64, *exceptions.Exception)

	GetAqaryAdminPermissions(ctx *gin.Context, id int64) (sqlc.GetAqaryAdminPermissionsRow, *exceptions.Exception)

	GetCompanyAdminPermissions(ctx *gin.Context, arg sqlc.GetCompanyAdminPermissionsParams) (sqlc.GetCompanyAdminPermissionsRow, *exceptions.Exception)
	GetRolePermissions(ctx *gin.Context, id int64) (sqlc.GetRolePermissionsRow, *exceptions.Exception)
}

type userRepository struct {
	querier sqlc.Querier
}

// GetUserAssociatedCompanies implements UserRepo.
func (u *userRepository) GetUserAssociatedCompanies(c *gin.Context, usersID int64) ([]sqlc.GetUserAssociatedCompaniesRow, *exceptions.Exception) {
	companies, err := u.querier.GetUserAssociatedCompanies(c, usersID)
	er := repoerror.BuildRepoErr("user", "GetUserAssociatedCompanies", err)
	if er != nil {
		return nil, er
	}
	return companies, nil
}

func NewUserRepository(querier sqlc.Querier) UserRepo {
	return &userRepository{
		querier: querier,
	}
}

// => isCompanyUser, companyID, companyType, isBranch, countryId, cityId, communityId, subCommunityId, userRole.ID, error
func (u *userRepository) FilterAddressesForRole(c *gin.Context, user sqlc.User) (bool, int64, int64, bool, int64, int64, int64, int64, int64, int64, error) {

	// TODO: For other countries we have to add state also

	var countryId int64
	var cityId int64
	var stateId int64

	var communityId int64
	var subCommunityId int64
	var companyID int64
	var companyType int64
	var isBranch bool
	var isCompanyUser bool

	visitedUserProfile, _ := u.querier.GetProfileByUserId(c, int64(user.ID))
	visitedUserAddress, _ := u.querier.GetAddress(c, int32(visitedUserProfile.AddressesID))
	visitedCompanyUser, _ := u.querier.GetCompanyUserByUserId(c, sqlc.GetCompanyUserByUserIdParams{
		CompanyID: 0,
		UserID:    user.ID,
	})

	countryId = visitedUserAddress.CountriesID.Int64
	isCompanyUser = utils.Ternary[bool](visitedCompanyUser.ID != 0, true, false)

	userRole, err := u.querier.GetRole(c, user.RolesID.Int64)
	if err != nil {
		fmt.Println("error while getting role ", err)
		// return []int64{}, 0, 0, []int64{}, err
	}

	// if someone is company user
	if visitedCompanyUser.ID != 0 {
		cityId = 0
		stateId = 0
		communityId = 0
		subCommunityId = 0
		companyID = visitedCompanyUser.CompanyID
		// companyType = visitedCompanyUser.CompanyType
		// isBranch = visitedCompanyUser.IsBranch.Bool
		///

	} else {
		// if someone is a management user
		log.Println("roleeeeeeeeeeeeeee:", userRole.Role)
		// ! for these roles only country matter...
		if strings.Contains(userRole.Role, "Company Admin") || strings.Contains(userRole.Role, "Country Admin") || user.UserTypesID == 6 {
			communityId = 0
			cityId = 0
			stateId = 0
			communityId = 0
		} else if strings.Contains(userRole.Role, "City") || user.UserTypesID == 2 { //! **************  2 is for agent  *****************
			cityId = visitedUserAddress.CitiesID.Int64
			communityId = 0
			stateId = 0
			subCommunityId = 0
		} else {
			cityId = 0
			stateId = 0

			communityId = visitedUserAddress.CommunitiesID.Int64
			subCommunityId = 0
		}

		companyID = 0
		companyType = 0

		isBranch = false
	}

	if user.UserTypesID == 6 {
		// countryId = 0
		isCompanyUser = false
		cityId = 0
		stateId = 0
		communityId = 0
		subCommunityId = 0
		companyID = 0
		companyType = 0
		isBranch = false
	}

	log.Println("testing companyID ", countryId, user.UserTypesID, "::", countryId)
	return isCompanyUser, companyID, companyType, isBranch, countryId, stateId, cityId, communityId, subCommunityId, userRole.ID, nil
}

// CreateUserType implements UserRepo.
func (u *userRepository) CreateUserType(c *gin.Context, arg sqlc.CreateUserTypeParams) (*sqlc.UserType, *exceptions.Exception) {
	getUserType, err := u.querier.CreateUserType(c, arg)
	buildErr("CreateUserType", err)
	return &getUserType, nil
}

// DeleteUserType implements UserRepo.
func (u *userRepository) DeleteUserType(c *gin.Context, id int64) (*string, *exceptions.Exception) {
	err := u.querier.DeleteUserType(c, id)
	buildErr("DeleteUserType", err)

	s := "successfully deleted"
	return &s, nil

}

// GetAllUserType implements UserRepo.
func (u *userRepository) GetAllUserType(c *gin.Context) (*[]sqlc.UserType, *exceptions.Exception) {
	userTypes, err := u.querier.GetAllUserType(c, sqlc.GetAllUserTypeParams{Limit: 100})
	buildErr("GetAllUserType", err)

	return &userTypes, nil
}

// GetAllUserTypesForWeb implements UserRepo.
func (u *userRepository) GetAllUserTypesForWeb(c *gin.Context) (*[]sqlc.UserType, *exceptions.Exception) {
	userTypes, err := u.querier.GetAllUserType(c, sqlc.GetAllUserTypeParams{Limit: 100})
	buildErr("GetUserGetAllUserTypesForWebType", err)

	return &userTypes, nil
}

// GetUserType implements UserRepo.
func (u *userRepository) GetUserType(c *gin.Context, id int64) (*sqlc.UserType, *exceptions.Exception) {
	userTypes, err := u.querier.GetUserType(c, int64(id))
	buildErr("GetUserType", err)
	return &userTypes, nil
}

// UpdateUserType implements UserRepo.
func (u *userRepository) UpdateUserType(c *gin.Context, args sqlc.UpdateUserTypeParams) (*sqlc.UserType, *exceptions.Exception) {
	updatedUserType, err := u.querier.UpdateUserType(c, args)
	buildErr("UpdateUserType", err)
	return &updatedUserType, nil
}

// GetAllUserType implements UserRepo.
func (u *userRepository) GetActiveUsersByType(c *gin.Context, args sqlc.GetActiveUsersByTypeParams) (*[]sqlc.GetActiveUsersByTypeRow, *exceptions.Exception) {
	users, err := u.querier.GetActiveUsersByType(c, args)
	buildErr("GetActiveUsersByType", err)

	return &users, nil
}

func buildErr(name string, err error) (any, any) {
	if err != nil {

		if errors.Is(err, pgx.ErrNoRows) {
			return nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode)
		}
		middleware.IncrementServerErrorCounter(fmt.Errorf("[auth.repo.%v] error:%v", name, err).Error())
		return nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}
	return nil, nil
}

// me api related methods
func (u *userRepository) GetUserDetailsByUserName(ctx *gin.Context, username string) (sqlc.GetUserDetailsByUserNameRow, *exceptions.Exception) {
	userDetails, err := u.querier.GetUserDetailsByUserName(ctx, username)
	buildProfileErr("GetUserDetailsByUserId", err)
	return userDetails, nil
}

func (u *userRepository) GetAssociatedCompanies(ctx *gin.Context, arg sqlc.GetAssociatedCompaniesParams) ([]byte, *exceptions.Exception) {
	companies, err := u.querier.GetAssociatedCompanies(ctx, arg)
	buildProfileErr("GetAssociatedCompanies", err)
	return companies, nil
}

func (u *userRepository) GetAqaryUserPermissions(ctx *gin.Context, arg sqlc.GetAqaryUserPermissionsParams) ([]int64, *exceptions.Exception) {

	permissions, err := u.querier.GetAqaryUserPermissions(ctx, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("", "GetAqaryUserPermissions", err)
	}
	return permissions, nil
}

func (u *userRepository) GetAqaryUserSubSectionPermissions(ctx *gin.Context, arg sqlc.GetAqaryUserSubSectionPermissionsParams) ([]int64, *exceptions.Exception) {

	permissions, err := u.querier.GetAqaryUserSubSectionPermissions(ctx, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("", "GetAqaryUserSubSectionPermissions", err)
	}
	return permissions, nil
}

func (u *userRepository) GetAqaryAdminPermissions(ctx *gin.Context, userId int64) (sqlc.GetAqaryAdminPermissionsRow, *exceptions.Exception) {

	permissions, err := u.querier.GetAqaryAdminPermissions(ctx, userId)
	if err != nil {
		return sqlc.GetAqaryAdminPermissionsRow{}, repoerror.BuildRepoErr("", "GetAqaryAdminPermissions", err)
	}
	return permissions, nil
}

func (u *userRepository) GetCompanyAdminPermissions(ctx *gin.Context, arg sqlc.GetCompanyAdminPermissionsParams) (sqlc.GetCompanyAdminPermissionsRow, *exceptions.Exception) {

	permissions, err := u.querier.GetCompanyAdminPermissions(ctx, arg)
	if err != nil {
		return sqlc.GetCompanyAdminPermissionsRow{}, repoerror.BuildRepoErr("", "GetCompanyAdminPermissions", err)
	}
	return permissions, nil
}

func (u *userRepository) GetRolePermissions(ctx *gin.Context, id int64) (sqlc.GetRolePermissionsRow, *exceptions.Exception) {

	permissions, err := u.querier.GetRolePermissions(ctx, id)
	if err != nil {
		return sqlc.GetRolePermissionsRow{}, repoerror.BuildRepoErr("", "GetRolePermissions", err)
	}
	return permissions, nil
}
