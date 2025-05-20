package usecase

import (
	"encoding/json"
	"fmt"
	"log"
	"strings"
	"sync"

	"aqary_admin/internal/delivery/redis"
	"aqary_admin/internal/delivery/rest/middleware"
	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	permissions_usecase "aqary_admin/internal/usecases/user/permissions"
	"aqary_admin/old_repo/model"
	db "aqary_admin/pkg/db/user"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/constants"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/security"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
	"go.uber.org/zap"
)

type UserUseCase interface {
	CreateUserType(c *gin.Context, req domain.UserTypeRequest) (*sqlc.UserType, *exceptions.Exception)
	GetAllUserTypes(c *gin.Context) ([]*response.UserType, *exceptions.Exception)
	GetAllUserTypesForWeb(c *gin.Context) ([]*response.UserType, *exceptions.Exception)
	GetUserType(c *gin.Context, id int64) (*response.UserType, *exceptions.Exception)
	UpdateUserType(c *gin.Context, id int64, req domain.UserTypeRequest) (*sqlc.UserType, *exceptions.Exception)
	DeleteUserType(c *gin.Context, id int64) (*string, *exceptions.Exception)
	GetActiveUsersBySubscriberType(c *gin.Context, typeId int64, req domain.GetActiveUsersByTypeRequest) (*[]sqlc.GetActiveUsersByTypeRow, *exceptions.Exception)
	GetAllUserTypeForDashBoard(c *gin.Context) ([]model.CustomUserFormat, *exceptions.Exception)
	GetUserDetailsByUserName(ctx *gin.Context) (*response.GetUserDetailsByUserNameResponse, *exceptions.Exception)
}
type userUseCaseImpl struct {
	repo       db.UserCompositeRepo
	pool       *pgxpool.Pool
	tokenMaker security.Maker
}

func NewUserUseCase(repo db.UserCompositeRepo, pool *pgxpool.Pool, tokenMaker security.Maker) *userUseCaseImpl {
	return &userUseCaseImpl{
		repo:       repo,
		pool:       pool,
		tokenMaker: tokenMaker,
	}
}

func (uu *userUseCaseImpl) CreateUserType(c *gin.Context, req domain.UserTypeRequest) (*sqlc.UserType, *exceptions.Exception) {
	userType, err := uu.repo.CreateUserType(c, sqlc.CreateUserTypeParams{
		UserType:   req.Type,
		UserTypeAr: pgtype.Text{String: req.TypeAr, Valid: true},
	})
	if err != nil {
		return nil, err
	}
	return userType, nil
}

func (uu *userUseCaseImpl) GetAllUserTypes(c *gin.Context) ([]*response.UserType, *exceptions.Exception) {
	var outputDatamodel response.UserType
	var outputDataModelList []*response.UserType

	userTypes, err := uu.repo.GetAllUserType(c)
	if err != nil {
		return nil, err
	}

	log.Println("testing user type with error", err, "::", userTypes)
	if len(*userTypes) > 0 {
		for _, u := range *userTypes {
			outputDatamodel.ID = u.ID
			outputDatamodel.Type = u.UserType
			outputDatamodel.TypeAr = u.UserTypeAr.String
			outputDataModelList = append(outputDataModelList, &outputDatamodel)
		}

		return outputDataModelList, nil
	}
	return nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode)
}

func (uu *userUseCaseImpl) GetAllUserTypesForWeb(c *gin.Context) ([]*response.UserType, *exceptions.Exception) {
	var outputDatamodel response.UserType
	var outputDataModelList []*response.UserType

	userTypes, err := uu.repo.GetAllUserType(c)

	if err != nil {
		return nil, err
	}

	if len(*userTypes) > 0 {
		for i, u := range *userTypes {
			if i == 0 || i == 2 || i == 3 {
				outputDatamodel.ID = u.ID
				outputDatamodel.Type = u.UserType
				outputDatamodel.TypeAr = u.UserTypeAr.String
				outputDataModelList = append(outputDataModelList, &outputDatamodel)
			}
		}
		return outputDataModelList, nil
	}
	return nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode)

}

func (uu *userUseCaseImpl) GetAllUserTypeForDashBoard(c *gin.Context) ([]model.CustomUserFormat, *exceptions.Exception) { //for userType dropdown in dashboard
	var outputDatamodel model.CustomUserFormat
	var outputDataModelList []model.CustomUserFormat

	//freelancer user type
	outputDatamodel.ID = int64(constants.FreelancerUserTypes.Int())
	outputDatamodel.Name = constants.FreelancerUserTypes.Name()
	outputDatamodel.EntityTypeID = int64(constants.FreelancerEntityType.Int())

	outputDataModelList = append(outputDataModelList, outputDatamodel)

	//owner or individual user type
	outputDatamodel.ID = int64(constants.OwnerOrIndividualUserTypes.Int())
	outputDatamodel.Name = constants.OwnerOrIndividualUserTypes.Name()
	outputDatamodel.EntityTypeID = int64(constants.UserEntityType.Int())

	outputDataModelList = append(outputDataModelList, outputDatamodel)

	//company user type
	outputDatamodel.ID = int64(constants.CompanyAdminUserTypes.Int())
	outputDatamodel.Name = constants.CompanyAdminUserTypes.Name()
	outputDatamodel.EntityTypeID = int64(constants.CompanyEntityType.Int())

	outputDataModelList = append(outputDataModelList, outputDatamodel)

	return outputDataModelList, nil

}

func (uu *userUseCaseImpl) GetUserType(c *gin.Context, id int64) (*response.UserType, *exceptions.Exception) {

	userTypes, err := uu.repo.GetUserType(c, id)

	if err != nil {
		return nil, err
	}

	if userTypes.ID == int64(id) {

		return &response.UserType{
			ID:     userTypes.ID,
			Type:   userTypes.UserType,
			TypeAr: userTypes.UserTypeAr.String,
		}, nil
	}

	return nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode)

}

func (uu *userUseCaseImpl) UpdateUserType(c *gin.Context, id int64, req domain.UserTypeRequest) (*sqlc.UserType, *exceptions.Exception) {

	usertype, err := uu.repo.GetUserType(c, id)
	if err != nil {
		return nil, err
	}

	if usertype.ID == int64(id) {
		if req.Type == "" {
			req.Type = usertype.UserType
		}

		args := sqlc.UpdateUserTypeParams{
			ID:         int64(id),
			UserType:   req.Type,
			UserTypeAr: pgtype.Text{String: req.TypeAr, Valid: true},
		}
		updatedUserType, err := uu.repo.UpdateUserType(c, args)

		if err != nil {
			return nil, err
		} else {
			return updatedUserType, nil
		}
	}

	return nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode)
}

func (uu *userUseCaseImpl) DeleteUserType(c *gin.Context, id int64) (*string, *exceptions.Exception) {

	userType, err := uu.repo.GetUserType(c, id)
	if err != nil {
		return nil, err
	}

	if userType.ID == int64(id) {
		message, err := uu.repo.DeleteUserType(c, int64(id))
		if err != nil {
			return nil, err
		} else {
			return message, nil
		}
	}

	return nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode)

}

func (uu *userUseCaseImpl) GetActiveUsersBySubscriberType(c *gin.Context, typeId int64, req domain.GetActiveUsersByTypeRequest) (*[]sqlc.GetActiveUsersByTypeRow, *exceptions.Exception) {

	if typeId == constants.FreelancerSubscriberType.Int64() {
		typeId = constants.FreelancerUserTypes.Int64()
	}

	args := sqlc.GetActiveUsersByTypeParams{
		UserType:  typeId,
		CountryID: req.CountryID,
		Search:    utils.AddPercent(req.Search),
	}

	users, err := uu.repo.GetActiveUsersByType(c, args)

	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "encountered an issue while getting users")
	}

	return users, nil
}

func (uc *userUseCaseImpl) GetUserDetailsByUserName(ctx *gin.Context) (*response.GetUserDetailsByUserNameResponse, *exceptions.Exception) {
	DefaultCountrySettings := response.DefaultSettingsRes{}

	settings := &utils.DefaultSettings{}
	payload, _ := ctx.MustGet(middleware.AuthorizationPayloadKey).(*security.Payload)

	userDetails, err := uc.repo.GetUserDetailsByUserName(ctx, payload.Username)
	if err != nil {
		return nil, err
	}
	if userDetails.UserTypesID != constants.AqaryUserUserTypes.Int64() && userDetails.UserTypesID != constants.SuperAdminUserTypes.Int64() {

		MarshelErr := json.Unmarshal(userDetails.DefaultSettings, settings)
		if MarshelErr != nil {
			fmt.Println(MarshelErr)
			//todo: return when we have stable database with settings and settings used on dashboard
			// return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "unable to unmrashal user default settings")
		} else {
			DefaultCountrySettings = response.DefaultSettingsRes{
				Currency: response.CurrencyRes{
					ID:   settings.CurrencyID,
					Code: userDetails.DefaultCurrencyCode,
					Icon: userDetails.DefaultCurrencyIcon,
				},
				BaseCurrency: response.CurrencyRes{
					ID:   settings.BaseCurrencyID,
					Code: userDetails.BaseCurrencyCode,
					Icon: userDetails.BaseCurrencyIcon,
				},
				DecimalPlace: settings.DecimalPlace,
				Measurement:  settings.Measurement,
			}
		}

	}

	country := response.CountryResp{
		CountryID:   userDetails.CountriesID.Int64,
		Country:     userDetails.Country.String,
		CountryFlag: userDetails.Flag.String,
	}
	var activeCompany response.ActiveCompany
	err1 := json.Unmarshal(userDetails.ActiveCompany, &activeCompany)
	if err1 != nil {
		fmt.Println("Error unmarshalling activeCompany")
	}

	var userTypeData model.CustomFormat
	err2 := json.Unmarshal(userDetails.UserType, &userTypeData)
	if err2 != nil {
		fmt.Println("Error unmarshalling UserType")
	}
	var entityTypeId int64
	if userTypeData.ID == constants.FreelancerUserTypes.Int64() {
		entityTypeId = constants.FreelancerEntityType.Int64()
	} else if userTypeData.ID == constants.OwnerOrIndividualUserTypes.Int64() {
		entityTypeId = constants.UserEntityType.Int64()
	} else if userTypeData.ID == constants.CompanyAdminUserTypes.Int64() {
		entityTypeId = constants.CompanyEntityType.Int64()
	}

	userDetail := model.CustomUserFormat{
		ID:           userTypeData.ID,
		Name:         userTypeData.Name,
		EntityTypeID: entityTypeId,
	}

	// get associated company information
	var associatedCompanies []response.AssociatedCompany
	if userDetails.ActCompany.Int64 != 0 {
		associated, err := uc.repo.GetAssociatedCompanies(ctx, sqlc.GetAssociatedCompaniesParams{
			ID:      userDetails.ActCompany.Int64,
			UsersID: userDetails.UserID,
		})

		if err != nil {
			fmt.Printf("error while fetching associated companies: %s", err)
		}

		if len(associatedCompanies) > 0 {
			errr := json.Unmarshal(associated, &associatedCompanies)
			if errr != nil {
				fmt.Println("Error unmarshalling associatedCompanies")
			}
		}

	}

	permissions, _ := uc.GetPermissionIdsForUser(ctx, userDetails)

	return &response.GetUserDetailsByUserNameResponse{
		Email:                  userDetails.Email,
		Username:               userDetails.Username,
		Status:                 model.CustomFormat{ID: userDetails.Status, Name: constants.Statuses.ConstantName(userDetails.Status)},
		UserTypesID:            userDetails.UserTypesID,
		IsVerified:             userDetails.IsVerified.Bool,
		ShowHideDetails:        userDetails.ShowHideDetails.Bool,
		PhoneNumber:            userDetails.PhoneNumber.String,
		CountryCode:            userDetails.CountryCode.Int64,
		IsEmailVerified:        userDetails.IsEmailVerified.Bool,
		IsPhoneVerified:        userDetails.IsPhoneVerified.Bool,
		FirstName:              userDetails.FirstName.String,
		LastName:               userDetails.LastName.String,
		FullName:               userDetails.FullName,
		ProfileImageUrl:        userDetails.ProfileImageUrl.String,
		SecondaryNumber:        userDetails.SecondaryNumber.String,
		CoverImageUrl:          userDetails.CoverImageUrl.String,
		About:                  userDetails.About.String,
		Gender:                 constants.Gender.ConstantName(userDetails.Gender.Int64),
		RefNo:                  userDetails.RefNo.String,
		FullAddress:            userDetails.FullAddress.String,
		ActiveCompany:          activeCompany,
		UserType:               userDetail,
		AssociatedCompanies:    associatedCompanies,
		AllPermissions:         &permissions,
		DefaultCountrySettings: DefaultCountrySettings,
		Country:                country,
		ExperienceSince:        userDetails.ExperienceSince.Time,
		Nationality: model.CustomFormat{
			ID:     userDetails.NationalityID.Int64,
			Name:   userDetails.Nationality.String,
			NameAr: userDetails.NationalityAr.String,
		},
		Language: model.CustomFormat{
			ID:     userDetails.LanguageID.Int64,
			Name:   userDetails.Language.String,
			NameAr: "",
		},
		WhatsappNumber: userDetails.WhatsappNumber.String,
		Organization:   "",
		UserRole: model.CustomFormat{
			ID:     userDetails.RolesID.Int64,
			Name:   userDetails.Role.String,
			NameAr: "",
		},
	}, nil
}

func (uc *userUseCaseImpl) GetPermissionsForUser(ctx *gin.Context, userDetails sqlc.GetUserDetailsByUserNameRow) ([]response.CustomSectionPermission, *exceptions.Exception) {
	var allSections []response.CustomSectionPermission

	redisClient, er := redis.NewRedisClient()
	if er != nil {
		log.Fatal("Failed to connect", zap.Error(er))
	}
	defer redisClient.Close()

	// var cacheKey string

	var userPermission []int64
	var userSubSectionId []int64
	// isSuperAdmin := false

	// get permissions for user
	if userDetails.UserTypesID == constants.SuperAdminUserTypes.Int64() {
		// super admin send all
		// isSuperAdmin = true

	} else if userDetails.UserTypesID == constants.AqaryUserUserTypes.Int64() {
		// if it's aqary admin get permissions from usercompanypermissions
		if userDetails.UserTypesID == constants.CompanyAdminUserTypes.Int64() {

			permissions, err := uc.repo.GetAqaryAdminPermissions(ctx, userDetails.UserID)
			if err != nil {
				fmt.Println("Error getting aqary admin permissions: ", err)
			}
			userPermission = permissions.Permissions
			userSubSectionId = permissions.SubPermissions

		} else {
			// aqary user will be getting permissions from role + usercompanypermissions
			permissions, err := uc.repo.GetAqaryUserPermissions(ctx, sqlc.GetAqaryUserPermissionsParams{
				UserID:  userDetails.UserID,
				RolesID: userDetails.RolesID.Int64,
			})

			if err != nil {
				fmt.Println("Error getting aqary user permissions: ", err)
			}
			userPermission = permissions

			subPermissions, err := uc.repo.GetAqaryUserSubSectionPermissions(ctx, sqlc.GetAqaryUserSubSectionPermissionsParams{
				UserID:  userDetails.UserID,
				RolesID: userDetails.RolesID.Int64,
			})
			if err != nil {
				fmt.Println("Error getting aqary user sub section permissions: ", err)
			}

			userSubSectionId = subPermissions
		}

	} else {
		// in case of company and company admin needs to get from user company permissions
		if userDetails.Role.String == "company admin" {
			permissions, err := uc.repo.GetCompanyAdminPermissions(ctx, sqlc.GetCompanyAdminPermissionsParams{
				UserID:    userDetails.UserID,
				CompanyID: userDetails.ActCompany.Int64,
			})

			if err != nil {
				fmt.Println("Error getting company admin permissions: ", err)
			}

			userPermission = permissions.Permissions
			userSubSectionId = permissions.SubPermissions

		} else {
			// in case of company user needs to be get from roles permissions. make sure it's not company admin role.
			rolePermissions, err := uc.repo.GetRolePermissions(ctx, userDetails.RolesID.Int64)
			if err != nil {
				fmt.Println("Error getting role permissions: ", err)
			}
			userPermission = rolePermissions.Permissions
			userSubSectionId = rolePermissions.SubPermissions
		}

	}

	sectionsPermission := sqlc.SectionPermissionMv{}
	var sectionsPermissionList []sqlc.SectionPermissionMv

	if len(userPermission) == 0 {

		cacheSectionPermission, err := redisClient.GetAllJSONFromFolder(ctx, "sectionPermissions")

		if err == nil {
			for _, v := range cacheSectionPermission {
				json.Unmarshal(v, &sectionsPermission)
				sectionsPermissionList = append(sectionsPermissionList, sectionsPermission)
			}
		}

	} else {
		// var userSectionIds []int64
		// get section ids in array from permission cache by getting permission cache with key
		type sectionPermission struct {
			ID                  int64 `json:"id"`
			SectionPermissionId int64 `json:"section_permission_id"`
		}

		spermission := sectionPermission{}
		var sectionIds []int64

		for _, value := range userPermission {
			cachePermission, err := redisClient.GetJSONFromFolder(ctx, "permissions", fmt.Sprintf("%v", value))

			if err != nil {
				fmt.Println("error getting permissions from cache:", err)
				continue
			}

			json.Unmarshal(cachePermission, &spermission)

			sectionPermission, err := redisClient.GetJSONFromFolder(ctx, "sectionPermissions", fmt.Sprintf("%v", spermission.SectionPermissionId))
			if err != nil {
				continue
			}

			json.Unmarshal(sectionPermission, &sectionsPermission)
			if utils.Contains(sectionIds, spermission.SectionPermissionId) {
				continue
			}
			sectionIds = append(sectionIds, spermission.SectionPermissionId)
			sectionsPermissionList = append(sectionsPermissionList, sectionsPermission)

		}

	}

	userId := utils.Ternary[int64](userDetails.UserTypesID == constants.SuperAdminUserTypes.Int64(), 0, userDetails.UserID)
	// GetAllSectionPermissionFromPermissionIDs
	if len(sectionsPermissionList) == 0 {

		sections, errr := uc.repo.GetAllSectionPermissionFromPermissionIDs(ctx, userId, userPermission)
		if errr != nil {
			return nil, nil
		}
		sectionsPermissionList = sections
	}

	var wg sync.WaitGroup
	sectionChan := make(chan response.CustomSectionPermission, len(sectionsPermissionList))

	for _, section := range sectionsPermissionList {
		wg.Add(1)
		go func(s sqlc.SectionPermissionMv) {
			defer wg.Done()
			customSection := permissions_usecase.ProcessSection(ctx, uc.repo, section, userId, userPermission, userSubSectionId, false, redisClient) // false: to expend to till end
			sectionChan <- customSection
		}(section)
	}

	go func() {
		wg.Wait()
		close(sectionChan)
	}()

	for section := range sectionChan {
		allSections = append(allSections, section)
	}

	return allSections, nil

}

func (uc *userUseCaseImpl) GetPermissionIdsForUser(ctx *gin.Context, userDetails sqlc.GetUserDetailsByUserNameRow) ([]int64, *exceptions.Exception) {
	var userPermission []int64
	var userSubSectionId []int64

	var AllPermissions []int64

	redisClient, er := redis.NewRedisClient()
	if er != nil {
		log.Fatal("Failed to connect", zap.Error(er))
	}
	defer redisClient.Close()

	// get permissions for user
	if userDetails.UserTypesID == constants.SuperAdminUserTypes.Int64() {
		return []int64{00}, nil

	} else if userDetails.UserTypesID == constants.AqaryUserUserTypes.Int64() {
		// if it's aqary admin get permissions from usercompanypermissions
		if userDetails.UserTypesID == constants.CompanyAdminUserTypes.Int64() {

			permissions, err := uc.repo.GetAqaryAdminPermissions(ctx, userDetails.UserID)
			if err != nil {
				fmt.Println("Error getting aqary admin permissions: ", err)
			}
			userPermission = permissions.Permissions
			userSubSectionId = permissions.SubPermissions

		} else {
			// aqary user will be getting permissions from role + usercompanypermissions
			permissions, err := uc.repo.GetAqaryUserPermissions(ctx, sqlc.GetAqaryUserPermissionsParams{
				UserID:  userDetails.UserID,
				RolesID: userDetails.RolesID.Int64,
			})

			if err != nil {
				fmt.Println("Error getting aqary user permissions: ", err)
			}
			userPermission = permissions

			subPermissions, err := uc.repo.GetAqaryUserSubSectionPermissions(ctx, sqlc.GetAqaryUserSubSectionPermissionsParams{
				UserID:  userDetails.UserID,
				RolesID: userDetails.RolesID.Int64,
			})
			if err != nil {
				fmt.Println("Error getting aqary user sub section permissions: ", err)
			}

			userSubSectionId = subPermissions
		}

	} else {
		// in case of company and company admin needs to get from user company permissions
		if strings.ToLower(userDetails.Role.String) == "company admin" {
			permissions, err := uc.repo.GetCompanyAdminPermissions(ctx, sqlc.GetCompanyAdminPermissionsParams{
				UserID:    userDetails.UserID,
				CompanyID: userDetails.ActCompany.Int64,
			})

			if err != nil {
				fmt.Println("Error getting company admin permissions: ", err)
			}

			userPermission = permissions.Permissions
			userSubSectionId = permissions.SubPermissions

		} else {
			// in case of company user needs to be get from roles permissions. make sure it's not company admin role.
			rolePermissions, err := uc.repo.GetRolePermissions(ctx, userDetails.RolesID.Int64)
			if err != nil {
				fmt.Println("Error getting role permissions: ", err)
			}
			userPermission = rolePermissions.Permissions
			userSubSectionId = rolePermissions.SubPermissions
		}

	}

	fmt.Println("::USER-PERMISSIONS::", userPermission)
	fmt.Println("::USER-TYPE::", userDetails.UserTypesID)
	// get section ids in array from permission cache by getting permission cache with key
	type sectionPermission struct {
		ID                  int64 `json:"id"`
		SectionPermissionId int64 `json:"section_permission_id"`
	}

	spermission := sectionPermission{}
	var sectionIds []int64

	for _, value := range userPermission {
		cachePermission, err := redisClient.GetJSONFromFolder(ctx, "permissions", fmt.Sprintf("%v", value))

		if err != nil {
			fmt.Println("error getting permissions from cache:", err)
			continue
		}

		json.Unmarshal(cachePermission, &spermission)

		if utils.Contains(sectionIds, spermission.SectionPermissionId) {
			continue
		}
		sectionIds = append(sectionIds, spermission.SectionPermissionId)

	}

	if len(sectionIds) == 0 {
		// get from database
		sections, errr := uc.repo.GetAllSectionPermissionFromPermissionIDs(ctx, userDetails.UserID, userPermission)
		if errr != nil {
			return nil, nil
		}

		for _, value := range sections {
			sectionIds = append(sectionIds, value.ID)
		}
	}

	AllPermissions = utils.MergeUnique(sectionIds, userPermission, userSubSectionId)

	return AllPermissions, nil
}
