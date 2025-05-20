package usecase

import (
	"aqary_admin/internal/delivery/rest/middleware"
	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	permissions_usecase "aqary_admin/internal/usecases/user/permissions"
	"encoding/json"
	"errors"
	"fmt"

	// permission "aqary_admin/old_repo/user/permissions"
	"log"
	"sync"
	"time"

	db "aqary_admin/pkg/db/user"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/constants"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/fn"
	"aqary_admin/pkg/utils/security"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
)

type AqaryUserUseCase interface {
	GetAqaryUser(ctx *gin.Context, id int64) (*response.User, *exceptions.Exception)
	GetAllAqaryUser(ctx *gin.Context, req domain.GetAllUserRequest) ([]response.AllUserOutput, int64, *exceptions.Exception)
	GetAllAqaryUserByCountry(ctx *gin.Context, req domain.GetAllUserByCountryRequest) ([]response.AllUserOutput, int64, *exceptions.Exception)
	GetSingleAqaryUser(ctx *gin.Context, id int64, req domain.GetSingleUserReq) (*response.UserOutput, *exceptions.Exception)
	UpdateAqaryUser(ctx *gin.Context, id int64, req domain.UpdateUserRequest) (*response.UpdatedUserOutput, *exceptions.Exception)
	DeleteUser(ctx *gin.Context, id int64) *exceptions.Exception
	RestoreUser(ctx *gin.Context, id int64) *exceptions.Exception
	GetAllDeletedAqaryUser(ctx *gin.Context, req domain.AllDeletedUserRequests) ([]response.DeletedAqaryUserOutput, int64, *exceptions.Exception)
	GetAllDeletedAqaryUserWithoutPagination(ctx *gin.Context) ([]response.DeletedAqaryUserOutput, int64, *exceptions.Exception)
	GetAllTeamLeaders(c *gin.Context) (any, *exceptions.Exception)
}

type aqaryUserUseCase struct {
	repo  db.UserCompositeRepo
	store sqlc.Store
}

func NewAqaryUserUseCase(repo db.UserCompositeRepo, store sqlc.Store) AqaryUserUseCase {
	return &aqaryUserUseCase{
		repo:  repo,
		store: store,
	}
}

func (uc *aqaryUserUseCase) GetAqaryUser(ctx *gin.Context, id int64) (*response.User, *exceptions.Exception) {
	user, err := uc.repo.GetAqaryUser(ctx, id)
	if err != nil {
		return nil, err
	}

	return &response.User{
		ID:       user.ID,
		Username: user.Username,
		Password: user.Password,
		Status:   int8(user.Status),
		RoleID:   user.RolesID.Int64,
		// DepartmentID: user.Department.Int64,
		ProfileID:  user.ProfilesID,
		UserTypeID: user.UserTypesID,
	}, nil
}

func (uc *aqaryUserUseCase) GetAllAqaryUser(ctx *gin.Context, req domain.GetAllUserRequest) ([]response.AllUserOutput, int64, *exceptions.Exception) {

	log.Println("testing if comming here ....")
	users, err := uc.repo.GetAllAqaryUser(ctx, sqlc.GetAllAqaryUserParams{
		Limit:  req.PageSize,
		Offset: (req.PageNo - 1) * req.PageSize,
		Search: utils.AddPercent(req.Search),
	})
	log.Println("testing user output", users, ":::", err)
	if err != nil {
		return nil, 0, err
	}

	var outputs []response.AllUserOutput
	for _, user := range users {
		location, _ := uc.store.GetLocationByAddressId(ctx, user.AddressesID)
		output := response.AllUserOutput{
			ID:         user.ID,
			Username:   user.Username,
			Email:      user.Email,
			Phone:      user.PhoneNumber.String,
			Department: user.Department,
			Role:       user.Role,
			Location:   location,
			Status: fn.CustomFormat{
				ID:   user.Status,
				Name: constants.CompanyUserType.ConstantName(user.Status), // user permissionn
			},
		}
		outputs = append(outputs, output)
	}

	count, err := uc.repo.GetCountAllAqaryUser(ctx, utils.AddPercent(req.Search))
	if err != nil {
		return nil, 0, err
	}

	return outputs, count, nil
}

func (uc *aqaryUserUseCase) GetAllAqaryUserByCountry(ctx *gin.Context, req domain.GetAllUserByCountryRequest) ([]response.AllUserOutput, int64, *exceptions.Exception) {
	users, err := uc.repo.GetAllAqaryUsersByCountryId(ctx, sqlc.GetAllAqaryUsersByCountryIdParams{
		Limit:  req.PageSize,
		Offset: (req.PageNo - 1) * req.PageSize,
		ID:     req.Country,
	})
	if err != nil {
		return nil, 0, err
	}

	var outputs []response.AllUserOutput
	for _, user := range users {
		profile, _ := uc.repo.GetProfileByUserId(ctx, user.ID)

		// department, _ := uc.repo.GetDepartment(ctx, int32(user.Department.Int64))
		// role, _ := uc.repo.GetRole(ctx, user.RolesID.Int64)

		address, _ := uc.repo.GetAddress(ctx, int32(profile.AddressesID))

		country, _ := uc.repo.GetCountry(ctx, int32(address.CountriesID.Int64))

		state, _ := uc.repo.GetState(ctx, int32(address.StatesID.Int64))

		city, _ := uc.repo.GetCity(ctx, int32(address.CitiesID.Int64))

		community, _ := uc.repo.GetCommunity(ctx, int32(address.CommunitiesID.Int64))

		subCommunity, _ := uc.repo.GetSubCommunity(ctx, int32(address.SubCommunitiesID.Int64))

		output := response.AllUserOutput{
			ID:       user.ID,
			Username: user.Username,
			Email:    user.Email,
			Phone:    user.PhoneNumber.String,
			// Department:   department.Title,
			// Role:         role.Role,
			Country:      country.Country,
			State:        state.State,
			City:         city.City,
			Community:    community.Community,
			SubCommunity: subCommunity.SubCommunity,
		}
		outputs = append(outputs, output)
	}

	count, err := uc.repo.GetCountAllAqaryUserByCountry(ctx, req.Country)
	if err != nil {
		return nil, 0, err
	}

	return outputs, count, nil
}

func (uc *aqaryUserUseCase) GetSingleAqaryUser(ctx *gin.Context, id int64, req domain.GetSingleUserReq) (*response.UserOutput, *exceptions.Exception) {
	user, err := uc.repo.GetAqaryUser(ctx, id)
	if err != nil {
		return nil, err
	}

	profile, err := uc.repo.GetProfile(ctx, int64(user.ProfilesID))
	if err != nil {
		log.Println(err)
	}

	role, err := uc.repo.GetRole(ctx, user.RolesID.Int64)
	if err != nil {
		log.Println("error while getting role:", err)
	}

	department, err := uc.repo.GetDepartment(ctx, sqlc.GetDepartmentParams{
		CompanyID:    req.CompanyID,
		DepartmentID: role.DepartmentID.Int64,
	})
	if err != nil {
		log.Println(err)
	}

	log.Println("testing department and role", department.Department, "::", role.DepartmentID.Int64)
	address, err := uc.repo.GetAddress(ctx, int32(profile.AddressesID))
	if err != nil {
		log.Println(err)
	}

	country, err := uc.repo.GetCountry(ctx, int32(address.CountriesID.Int64))
	if err != nil {
		log.Println(err)
	}

	state, err := uc.repo.GetState(ctx, int32(address.StatesID.Int64))
	if err != nil {
		log.Println(err)
	}

	city, err := uc.repo.GetCity(ctx, int32(address.CitiesID.Int64))
	if err != nil {
		log.Println(err)
	}

	community, err := uc.repo.GetCommunity(ctx, int32(address.CommunitiesID.Int64))

	if err != nil {
		log.Println(err)
	}

	subCommunity, err := uc.repo.GetSubCommunity(ctx, int32(address.SubCommunitiesID.Int64))
	if err != nil {
		log.Println(err)
	}

	output := &response.UserOutput{
		ID:           user.ID,
		Username:     user.Username,
		FirstName:    profile.FirstName,
		LastName:     profile.LastName,
		Email:        user.Email,
		Phone:        user.PhoneNumber.String,
		UserTypeId:   user.UserTypesID,
		Department:   utils.Ternary[any](department.ID == 0, nil, response.DepartmentOutput{ID: department.ID, Department: department.Department}),
		Role:         utils.Ternary[any](role.ID == 0, nil, response.RoleOutput{ID: role.ID, Role: role.Role}),
		Country:      fn.CustomFormat{ID: country.ID, Name: country.Country},
		State:        fn.CustomFormat{ID: state.ID, Name: state.State},
		City:         fn.CustomFormat{ID: city.ID, Name: city.City},
		Community:    fn.CustomFormat{ID: community.ID, Name: community.Community},
		SubCommunity: fn.CustomFormat{ID: subCommunity.ID, Name: subCommunity.SubCommunity},
	}

	var userPermission []int64
	var userSubSectionId []int64

	userPerm, errr := uc.store.GetUserPermissionsByID(ctx, sqlc.GetUserPermissionsByIDParams{
		IsCompanyUser: 0, // not needed for management users.....
		CompanyID:     pgtype.Int8{},
		UserID:        user.ID,
	})
	if errr != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, errr.Error())
	}

	userPermission = userPerm.PermissionsID
	userSubSectionId = userPerm.SubSectionsID

	// it will fetch all section in case of super admin else fetch only assign one
	// userId := utils.Ternary[int64](visitedUser.UserTypesID == constants.SuperAdminUserTypes.Int64(), 0, visitedUser.ID)
	userId := int64(1) //: zero mean ignore only for super admin
	sections, sectionErr := uc.repo.GetAllSectionPermissionFromPermissionIDs(ctx, userId, userPermission)
	if sectionErr != nil {
		return nil, sectionErr
	}

	// log.Println("testing section length", len(sections))
	var wg sync.WaitGroup
	sectionChan := make(chan response.CustomSectionPermission, len(sections))

	for _, section := range sections {
		wg.Add(1)
		go func(s sqlc.SectionPermissionMv) {
			defer wg.Done()
			customSection := permissions_usecase.ProcessSection(ctx, uc.repo, section, userId, userPermission, userSubSectionId, false, nil) // false: to expend to till end
			sectionChan <- customSection
		}(section)
	}

	go func() {
		wg.Wait()
		close(sectionChan)
	}()

	var allSections []response.CustomSectionPermission
	for section := range sectionChan {
		allSections = append(allSections, section)
	}

	output.Permission = allSections
	return output, nil
}

func ContainSectionId(list []response.CustomSectionPermissions, target int64) bool {
	for _, item := range list {
		if item.ID == target {
			return true
		}
	}
	return false
}

func (uc *aqaryUserUseCase) UpdateAqaryUser(ctx *gin.Context, id int64, req domain.UpdateUserRequest) (*response.UpdatedUserOutput, *exceptions.Exception) {
	user, err := uc.repo.GetAqaryUser(ctx, id)
	if err != nil {
		return nil, err
	}

	profile, err := uc.repo.GetProfile(ctx, int64(user.ProfilesID))
	if err != nil {
		return nil, err
	}

	address, err := uc.repo.GetAddress(ctx, int32(profile.AddressesID))
	if err != nil {
		return nil, err
	}

	// Update address
	updatedAddress, err := uc.repo.UpdateAddress(ctx, sqlc.UpdateAddressParams{
		ID: address.ID,
		CountriesID: pgtype.Int8{
			Int64: req.Country,
			Valid: req.Country != 0,
		},
		StatesID: pgtype.Int8{
			Int64: req.State,
			Valid: req.State != 0,
		},
		CitiesID: pgtype.Int8{
			Int64: req.City,
			Valid: req.City != 0,
		},
		CommunitiesID: pgtype.Int8{
			Int64: req.Community,
			Valid: req.Community != 0,
		},
		SubCommunitiesID: pgtype.Int8{
			Int64: req.SubCommunity,
			Valid: req.SubCommunity != 0,
		},
		LocationsID: address.LocationsID,
	})
	if err != nil {
		return nil, err
	}

	// Update profile
	updatedProfile, err := uc.repo.UpdateProfile(ctx, sqlc.UpdateProfileParams{
		ID:              profile.ID,
		FirstName:       req.FirstName,
		LastName:        req.LastName,
		AddressesID:     updatedAddress.ID,
		ProfileImageUrl: profile.ProfileImageUrl,
		// PhoneNumber: pgtype.Text{
		// 	String: req.Phone,
		// 	Valid:  req.Phone != "",
		// },
		WhatsappNumber: profile.WhatsappNumber,
		Gender:         profile.Gender,
		UpdatedAt:      time.Now(),
		RefNo:          profile.RefNo,
	}, nil)
	if err != nil {
		return nil, err
	}

	// now collecting internal button permission for each

	var perm []domain.PermissionButton
	var uniquePermissionList []int64
	var uniqueSubSectionList []int64

	if req.Permissions != "" {
		jsonErr := json.Unmarshal([]byte(req.Permissions), &perm)
		if jsonErr != nil {
			fmt.Println("Error unmarshaling JSON:", jsonErr)
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, jsonErr.Error())
		}

		// Print the unmarshaled data
		fmt.Printf("Unmarshaled data: %+v\n", perm)
	}

	for _, p := range perm {
		if p.ButtonID != 0 {
			uniqueSubSectionList = append(uniqueSubSectionList, int64(p.ID))
			if p.PermissionID != 0 {
				uniquePermissionList = append(uniquePermissionList, int64(p.PermissionID)) // permissons
			}
			if p.SecondaryID != 0 {
				uniqueSubSectionList = append(uniqueSubSectionList, int64(p.SecondaryID)) // permissons
			}

			if p.TertiaryID != 0 {
				uniqueSubSectionList = append(uniqueSubSectionList, int64(p.TertiaryID)) // permissons
			}

			if p.QuaternaryID != 0 {
				uniqueSubSectionList = append(uniqueSubSectionList, int64(p.QuaternaryID)) // permissons
			}
		} else {
			uniquePermissionList = append(uniquePermissionList, int64(p.ID)) // permissons
			if p.PermissionID != 0 {
				uniquePermissionList = append(uniquePermissionList, int64(p.PermissionID)) // permissons
			}
			if p.SecondaryID != 0 {
				uniqueSubSectionList = append(uniqueSubSectionList, int64(p.SecondaryID)) // permissons
			}

			if p.TertiaryID != 0 {
				uniqueSubSectionList = append(uniqueSubSectionList, int64(p.TertiaryID)) // permissons
			}

			if p.QuaternaryID != 0 {
				uniqueSubSectionList = append(uniqueSubSectionList, int64(p.QuaternaryID)) // permissons
			}
		}
	}

	// if username is empty, it must be occupy the old one
	// the username cannot be empty in database
	if req.Username == "" {
		req.Username = user.Username
	}

	log.Println("testing role id", req.Role)
	// Update user
	updatedUser, err := uc.repo.UpdateUser(ctx, sqlc.UpdateUserParams{
		ID: id,
		// Status:  1,
		RolesID: pgtype.Int8{Int64: req.Role, Valid: req.Role != 0},
		// ProfilesID:  updatedProfile.ID,
		// UserTypesID: constants.AqaryUserUserTypes.Int64(), // aqary management user
		// SocialLogin: pgtype.Text{},
		ShowHideDetails: user.ShowHideDetails,
		ExperienceSince: user.ExperienceSince,
		UpdatedAt:       time.Now(),
		PhoneNumber: pgtype.Text{
			String: req.Phone,
			Valid:  req.Phone != "",
		},
		Username: req.Username,
	}, nil)
	if err != nil {
		return nil, err
	}

	// also update the user permissions ....................................................................

	// Fetch updated related data
	role, _ := uc.repo.GetRole(ctx, updatedUser.RolesID.Int64)
	department, _ := uc.repo.GetDepartment(ctx, sqlc.GetDepartmentParams{
		CompanyID:    req.CompanyID,
		DepartmentID: role.DepartmentID.Int64,
	})
	country, _ := uc.repo.GetCountry(ctx, int32(req.Country))
	state, _ := uc.repo.GetState(ctx, int32(req.State))
	city, _ := uc.repo.GetCity(ctx, int32(req.City))
	community, _ := uc.repo.GetCommunity(ctx, int32(req.Community))
	subCommunity, _ := uc.repo.GetSubCommunity(ctx, int32(req.SubCommunity))

	// update the user permission
	updatedPerm, err := uc.repo.UpdateUserPermissionByID(ctx, sqlc.UpdateUserPermissionsByIDParams{
		PermissionID: uniquePermissionList,
		SubSectionID: uniqueSubSectionList,
		IsCompany:    req.CompanyID,
		CompanyID: pgtype.Int8{
			Int64: req.CompanyID,
			Valid: true,
		},
		UserID: updatedUser.ID,
	})
	if err != nil {
		log.Println("error while updating user permission ", err)
		if err.ErrorCode == exceptions.NoDataFoundErrorCode {
			updatedPerm, _ = uc.repo.CreateUserPermission(ctx, sqlc.CreateUserPermissionParams{
				PermissionsID: uniquePermissionList,
				SubSectionsID: uniqueSubSectionList,
				CompanyID: pgtype.Int8{
					Int64: req.CompanyID,
					Valid: true,
				},
				UserID: updatedUser.ID,
			}, nil)
		} else {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "can't update user permission")
		}
	}

	output := &response.UpdatedUserOutput{
		ID:        updatedUser.ID,
		Username:  updatedUser.Username,
		FirstName: updatedProfile.FirstName,
		LastName:  updatedProfile.LastName,
		Email:     updatedUser.Email,
		Phone:     updatedUser.PhoneNumber.String,
		Department: fn.CustomFormat{
			ID:   department.ID,
			Name: department.Department,
		},
		Role: fn.CustomFormat{
			ID:   role.ID,
			Name: role.Role,
		},
		Country: fn.CustomFormat{
			ID:   country.ID,
			Name: country.Country,
		},
		State: fn.CustomFormat{
			ID:   state.ID,
			Name: state.State,
		},
		City: fn.CustomFormat{
			ID:   city.ID,
			Name: city.City,
		},
		Community: fn.CustomFormat{
			ID:   community.ID,
			Name: community.Community,
		},
		SubCommunity: fn.CustomFormat{
			ID:   subCommunity.ID,
			Name: subCommunity.SubCommunity,
		},
		Permission:           updatedPerm.PermissionsID,
		SubSectionPermission: updatedPerm.SubSectionsID,
	}

	return output, nil
}

func (uc *aqaryUserUseCase) DeleteUser(ctx *gin.Context, id int64) *exceptions.Exception {
	user, err := uc.repo.GetAqaryUser(ctx, id)
	if err != nil {
		return err
	}

	_, err = uc.repo.UpdateUserStatus(ctx, sqlc.UpdateUserStatusParams{
		ID:     user.ID,
		Status: 6,
		// UpdatedAt: time.Now(),
	})
	if err != nil {
		return err
	}

	return nil
}

func (uc *aqaryUserUseCase) RestoreUser(ctx *gin.Context, id int64) *exceptions.Exception {
	user, err := uc.repo.GetAqaryDeletedUser(ctx, id)
	if err != nil {
		return err
	}

	_, err = uc.repo.UpdateUserStatus(ctx, sqlc.UpdateUserStatusParams{
		ID:        user.ID,
		Status:    1,
		UpdatedAt: time.Now(),
	})
	if err != nil {
		return err

	}
	return nil
}

func (uc *aqaryUserUseCase) GetAllDeletedAqaryUser(ctx *gin.Context, req domain.AllDeletedUserRequests) ([]response.DeletedAqaryUserOutput, int64, *exceptions.Exception) {
	users, err := uc.repo.GetAllAqaryDeletedUser(ctx, sqlc.GetAllAqaryDeletedUserParams{
		Limit:  req.PageSize,
		Offset: (req.PageNo - 1) * req.PageSize,
		Search: utils.AddPercent(req.Search),
	})
	if err != nil {
		return nil, 0, err
	}

	var outputs []response.DeletedAqaryUserOutput
	for _, user := range users {
		profile, err := uc.repo.GetProfileByUserId(ctx, user.ID)
		if err != nil {
			log.Println("testing profile err", err)
			// return nil, 0, err
		}

		role, err := uc.repo.GetRole(ctx, user.RolesID.Int64)
		if err != nil {
			log.Println("testing role err", err)
			// return nil, 0, err
		}

		department, err := uc.repo.GetDepartment(ctx, sqlc.GetDepartmentParams{
			CompanyID:    0,
			DepartmentID: role.DepartmentID.Int64,
		})
		if err != nil {
			log.Println("testing department err", err)
			// return nil, 0, err
		}

		output := response.DeletedAqaryUserOutput{
			ID:          user.ID,
			Name:        profile.FirstName + " " + profile.LastName,
			PhoneNumber: user.PhoneNumber.String,
			Email:       user.Email,
			Role:        role.Role,
			Department:  department.Department,
		}
		outputs = append(outputs, output)
	}

	count, err := uc.repo.GetCountAllAqaryDeletedUser(ctx, utils.AddPercent(req.Search))
	if err != nil {
		return nil, 0, err
	}

	return outputs, count, nil
}

func (uc *aqaryUserUseCase) GetAllDeletedAqaryUserWithoutPagination(ctx *gin.Context) ([]response.DeletedAqaryUserOutput, int64, *exceptions.Exception) {
	users, err := uc.repo.GetAllAqaryDeletedUserWithoutPagination(ctx)
	if err != nil {
		return nil, 0, err
	}

	var outputs []response.DeletedAqaryUserOutput
	for _, user := range users {
		profile, _ := uc.repo.GetProfileByUserId(ctx, user.ID)

		// TODO: Need to fix this later
		role, _ := uc.repo.GetRole(ctx, user.RolesID.Int64)

		department, _ := uc.repo.GetDepartment(ctx, sqlc.GetDepartmentParams{
			CompanyID:    0,
			DepartmentID: role.ID,
		})

		output := response.DeletedAqaryUserOutput{
			ID:          user.ID,
			Name:        profile.FirstName + " " + profile.LastName,
			PhoneNumber: user.PhoneNumber.String,
			Email:       user.Email,
			Role:        role.Role,
			Department:  department.Department,
		}
		outputs = append(outputs, output)
	}

	count, err := uc.repo.GetCountAllAqaryDeletedUser(ctx, "%%")
	if err != nil {
		return nil, 0, err
	}

	return outputs, count, nil
}

func (uc *aqaryUserUseCase) GetAllTeamLeaders(c *gin.Context) (any, *exceptions.Exception) {

	payload := c.MustGet(middleware.AuthorizationPayloadKey).((*security.Payload))
	// checking for authorization ....
	visitedUser, err := uc.store.GetUserByName(c, payload.Username)
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCode(exceptions.UserNotAuthorizedErrorCode)
	}

	companyUser, _ := uc.store.GetCompanyUserByUserId(c, sqlc.GetCompanyUserByUserIdParams{
		CompanyID: 0,
		UserID:    visitedUser.ID,
	})

	// also check if the company is

	company, _ := uc.store.GetACompanyByUserID(c, visitedUser.ID)

	log.Println("testing company user ", companyUser, "testing ", company, ":user:", visitedUser.ID)

	allTeamLeader, err := uc.store.GetAllTeamLeaders(c, utils.Ternary[int64](visitedUser.UserTypesID == 1, company.CompanyID, companyUser.CompanyID)) //  company id
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return "no team leader found", nil
		}
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	var teamLeaders []fn.CustomFormat
	for _, team := range allTeamLeader {
		teamLeaders = append(teamLeaders, fn.CustomFormat{
			ID:   team.ID,
			Name: team.FirstName + " " + team.LastName,
		})
	}

	return teamLeaders, nil
}
