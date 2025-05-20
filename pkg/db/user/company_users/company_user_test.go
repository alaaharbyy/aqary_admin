package companyusers_repo_test

import (
	"time"

	mockdb "aqary_admin/internal/domain/sqlc/mock"
	"aqary_admin/internal/domain/sqlc/sqlc"
	db "aqary_admin/pkg/db/user/company_users"

	// db "aqary_admin/pkg/db/user/companyusers_repo"
	"errors"
	"testing"

	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/stretchr/testify/assert"
	"go.uber.org/mock/gomock"
)

func TestCompanyUserRepo(t *testing.T) {
	utils.IS_TEST_MODE = true
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockQuerier := mockdb.NewMockStore(ctrl)
	repo := db.NewCompanyUserRepository(mockQuerier)

	// t.Run("GetUserByName", func(t *testing.T) {
	// 	c := &gin.Context{}
	// 	username := "test_user"
	// 	expectedUser := sqlc.User{ID: 1, Username: username}

	// 	t.Run("When user is found", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetUserByName(c, username).Return(expectedUser, nil)
	// 		user, err := repo.GetUserByName(c, username)
	// 		assert.Nil(t, err)
	// 		assert.Equal(t, &expectedUser, user)
	// 	})

	// 	t.Run("When user is not found", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetUserByName(c, username).Return(sqlc.User{}, pgx.ErrNoRows)
	// 		user, err := repo.GetUserByName(c, username)
	// 		assert.Nil(t, user)
	// 		assert.IsType(t, &exceptions.Exception{}, err)
	// 		assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode), err)
	// 	})
	// })

	t.Run("GetCompanies", func(t *testing.T) {
		c := &gin.Context{}
		companyID := int64(1)
		expectedCompany := sqlc.Company{ID: companyID, CompanyName: "Test Company"}

		t.Run("When company is found", func(t *testing.T) {
			mockQuerier.EXPECT().GetCompanies(c, companyID).Return(expectedCompany, nil)
			company, err := repo.GetCompanies(c, companyID)
			assert.Nil(t, err)
			assert.Equal(t, &expectedCompany, company)
		})

		t.Run("When company is not found", func(t *testing.T) {
			mockQuerier.EXPECT().GetCompanies(c, companyID).Return(sqlc.Company{}, pgx.ErrNoRows)
			_, err := repo.GetCompanies(c, companyID)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode), err)
		})
	})

	t.Run("CreateCompanyUser", func(t *testing.T) {
		c := &gin.Context{}
		args := sqlc.CreateCompanyUserParams{UsersID: 1, CompanyID: 1}
		expectedCompanyUser := sqlc.CompanyUser{ID: 1, UsersID: args.UsersID, CompanyID: args.CompanyID}

		t.Run("When company user is created successfully", func(t *testing.T) {
			mockQuerier.EXPECT().CreateCompanyUser(c, args).Return(expectedCompanyUser, nil)
			companyUser, err := repo.CreateCompanyUser(c, args, mockQuerier)
			assert.Nil(t, err)
			assert.Equal(t, &expectedCompanyUser, companyUser)
		})

		t.Run("When error occurs", func(t *testing.T) {
			expectedError := errors.New("database error")
			mockQuerier.EXPECT().CreateCompanyUser(c, args).Return(sqlc.CompanyUser{}, expectedError)
			_, err := repo.CreateCompanyUser(c, args, mockQuerier)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode), err)
		})
	})

	t.Run("GetAllCompanyUsers", func(t *testing.T) {
		c := &gin.Context{}
		args := sqlc.GetAllCompanyUsersParams{}
		expectedUsers := []sqlc.GetAllCompanyUsersRow{{CompanyUserID: 1}, {CompanyUserID: 2}}

		t.Run("When company users are found", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllCompanyUsers(c, args).Return(expectedUsers, nil)
			users, err := repo.GetAllCompanyUsers(c, args)
			assert.Nil(t, err)
			assert.Equal(t, expectedUsers, users)
		})

		t.Run("When error occurs", func(t *testing.T) {
			expectedError := errors.New("database error")
			mockQuerier.EXPECT().GetAllCompanyUsers(c, args).Return(nil, expectedError)
			_, err := repo.GetAllCompanyUsers(c, args)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode), err)
		})
	})

	t.Run("GetCountAllCompanyUsers", func(t *testing.T) {
		c := &gin.Context{}
		expectedCount := int64(10)

		t.Run("When count is retrieved successfully", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountAllCompanyUsers(c, gomock.Any()).Return(expectedCount, nil)
			count, err := repo.GetCountAllCompanyUsers(c, "")
			assert.Nil(t, err)
			assert.Equal(t, expectedCount, count)
		})
	})

	t.Run("GetCompanyUserById", func(t *testing.T) {
		// c := &gin.Context{}
		// userID := int64(1)
		// expectedUser := sqlc.GetCompanyUserByIdRow{CompanyUserID: userID}

		t.Run("When company user is found", func(t *testing.T) {
			// mockQuerier.EXPECT().GetCompanyUserById(c, userID).Return(expectedUser, nil)
			// user, err := repo.GetCompanyUserById(c, userID)
			// assert.Nil(t, err)
			// assert.Equal(t, expectedUser, user)
		})
	})

	t.Run("GetCompanyUsersByUsersID", func(t *testing.T) {
		c := &gin.Context{}
		userID := int64(1)
		expectedCompanyUser := sqlc.CompanyUser{UsersID: userID}

		t.Run("When company user is found", func(t *testing.T) {
			mockQuerier.EXPECT().GetCompanyUsersByUsersID(c, userID).Return(expectedCompanyUser, nil)
			companyUser, err := repo.GetCompanyUsersByUsersID(c, userID)
			assert.Nil(t, err)
			assert.Equal(t, expectedCompanyUser, companyUser)
		})
	})

	t.Run("GetAllLanguagesByIds", func(t *testing.T) {
		c := &gin.Context{}
		ids := []int64{1, 2}
		expectedLanguages := []sqlc.AllLanguage{{ID: 1}, {ID: 2}}

		t.Run("When languages are found", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllLanguagesByIds(c, ids).Return(expectedLanguages, nil)
			languages, err := repo.GetAllLanguagesByIds(c, ids)
			assert.Nil(t, err)
			assert.Equal(t, expectedLanguages, languages)
		})
	})

	t.Run("GetAllCititesByIds", func(t *testing.T) {
		c := &gin.Context{}
		ids := []int64{1, 2}
		expectedCities := []sqlc.City{{ID: 1}, {ID: 2}}

		t.Run("When cities are found", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllCititesByIds(c, ids).Return(expectedCities, nil)
			cities, err := repo.GetAllCititesByIds(c, ids)
			assert.Nil(t, err)
			assert.Equal(t, expectedCities, cities)
		})
	})

	t.Run("GetCompanyUserBranchAgentAndQuotaByUserId", func(t *testing.T) {
		c := &gin.Context{}
		userID := int64(1)
		expectedRow := sqlc.GetCompanyUserBranchAgentAndQuotaByUserIdRow{
			BrokerCompanyAgentsID:          userID,
			Brn:                            "",
			ExperienceSince:                pgtype.Timestamptz{},
			Nationalities:                  []int64{},
			BrnExpiry:                      time.Time{},
			VerificationDocumentUrl:        "",
			About:                          pgtype.Text{},
			AboutArabic:                    pgtype.Text{},
			LinkedinProfileUrl:             pgtype.Text{},
			FacebookProfileUrl:             pgtype.Text{},
			TwitterProfileUrl:              pgtype.Text{},
			IsVerified:                     pgtype.Bool{},
			ProfilesID:                     0,
			ServiceAreas:                   []int64{},
			AgentSubscriptionQuotaBranchID: pgtype.Int8{},
			Standard:                       pgtype.Int8{},
			Featured:                       pgtype.Int8{},
			Premium:                        pgtype.Int8{},
			TopDeal:                        pgtype.Int8{},
		}

		t.Run("When branch agent and quota are found", func(t *testing.T) {
			mockQuerier.EXPECT().GetCompanyUserBranchAgentAndQuotaByUserId(c, userID).Return(expectedRow, nil)
			row, err := repo.GetCompanyUserBranchAgentAndQuotaByUserId(c, userID)
			assert.Nil(t, err)
			assert.Equal(t, expectedRow, row)
		})
	})

	t.Run("GetCompanyUserAgentAndQuotaByUserId", func(t *testing.T) {
		c := &gin.Context{}
		userID := int64(1)
		expectedRow := sqlc.GetCompanyUserAgentAndQuotaByUserIdRow{BrokerCompanyAgentsID: userID}

		t.Run("When agent and quota are found", func(t *testing.T) {
			mockQuerier.EXPECT().GetCompanyUserAgentAndQuotaByUserId(c, userID).Return(expectedRow, nil)
			row, err := repo.GetCompanyUserAgentAndQuotaByUserId(c, userID)
			assert.Nil(t, err)
			assert.Equal(t, expectedRow, row)
		})
	})

	// t.Run("GetCountry", func(t *testing.T) {
	// 	c := &gin.Context{}
	// 	countryID := int32(1)
	// 	expectedCountry := sqlc.Country{ID: int64(countryID)}

	// 	t.Run("When country is found", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetCountry(c, countryID).Return(expectedCountry, nil)
	// 		country, err := repo.GetCountry(c, countryID)
	// 		assert.Nil(t, err)
	// 		assert.Equal(t, expectedCountry, country)
	// 	})
	// })

	// t.Run("GetPermission", func(t *testing.T) {
	// 	c := &gin.Context{}
	// 	permissionID := int64(1)
	// 	expectedPermission := sqlc.Permission{ID: permissionID}

	// 	t.Run("When permission is found", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetPermission(c, permissionID).Return(expectedPermission, nil)
	// 		permission, err := repo.GetPermission(c, permissionID)
	// 		assert.Nil(t, err)
	// 		assert.Equal(t, expectedPermission, permission)
	// 	})
	// })

	// t.Run("GetSectionPermission", func(t *testing.T) {
	// 	c := &gin.Context{}
	// 	sectionID := int64(1)
	// 	expectedSectionPermission := sqlc.SectionPermission{ID: sectionID}

	// 	t.Run("When section permission is found", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetSectionPermission(c, sectionID).Return(expectedSectionPermission, nil)
	// 		sectionPermission, err := repo.GetSectionPermission(c, sectionID)
	// 		assert.Nil(t, err)
	// 		assert.Equal(t, expectedSectionPermission, sectionPermission)
	// 	})
	// })

	// t.Run("GetPermissionBySectionID", func(t *testing.T) {
	// 	c := &gin.Context{}
	// 	sectionID := int64(1)
	// 	expectedPermissions := []int64{1, 2, 3}

	// 	t.Run("When permissions are found", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetPermissionBySectionID(c, sectionID).Return(expectedPermissions, nil)
	// 		permissions, err := repo.GetPermissionBySectionID(c, sectionID)
	// 		assert.Nil(t, err)
	// 		assert.Equal(t, expectedPermissions, permissions)
	// 	})
	// })

	// t.Run("GetAllSubSectionPermissionBySubSectionButtonID", func(t *testing.T) {
	// 	c := &gin.Context{}
	// 	subSectionID := int64(1)
	// 	expectedSubSections := []sqlc.SubSection{{ID: 1}, {ID: 2}}

	// 	t.Run("When sub sections are found", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetAllSubSectionPermissionBySubSectionButtonID(c, subSectionID).Return(expectedSubSections, nil)
	// 		subSections, err := repo.GetAllSubSectionPermissionBySubSectionButtonID(c, subSectionID)
	// 		assert.Nil(t, err)
	// 		assert.Equal(t, expectedSubSections, subSections)
	// 	})
	// })

	t.Run("GetAllCompanyUsersByStatus", func(t *testing.T) {
		c := &gin.Context{}
		args := sqlc.GetAllCompanyUsersByStatusParams{}
		expectedUsers := []sqlc.GetAllCompanyUsersByStatusRow{{ID: 1}, {ID: 2}}

		t.Run("When company users are found", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllCompanyUsersByStatus(c, args).Return(expectedUsers, nil)
			users, err := repo.GetAllCompanyUsersByStatus(c, args)
			assert.Nil(t, err)
			assert.Equal(t, expectedUsers, users)
		})
	})

	t.Run("CountAllCompanyUsersByStatus", func(t *testing.T) {
		c := &gin.Context{}
		args := sqlc.CountAllCompanyUsersByStatusParams{}
		expectedCount := int64(10)

		t.Run("When count is retrieved successfully", func(t *testing.T) {
			mockQuerier.EXPECT().CountAllCompanyUsersByStatus(c, args).Return(expectedCount, nil)
			count, err := repo.CountAllCompanyUsersByStatus(c, args)
			assert.Nil(t, err)
			assert.Equal(t, expectedCount, count)
		})
	})

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// t.Run("GetUserByEmail", func(t *testing.T) {
	// 	ctx := &gin.Context{}
	// 	email := "test@example.com"
	// 	expectedUser := sqlc.User{ID: 1, Email: email}

	// 	t.Run("Success", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetUserByEmail(ctx, email).Return(expectedUser, nil)
	// 		user, err := repo.GetUserByEmail(ctx, email)
	// 		assert.Nil(t, err)
	// 		assert.Equal(t, &expectedUser, user)
	// 	})

	// 	t.Run("User Not Found", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetUserByEmail(ctx, email).Return(sqlc.User{}, pgx.ErrNoRows)
	// 		user, err := repo.GetUserByEmail(ctx, email)
	// 		assert.Nil(t, err)
	// 		assert.Nil(t, user)
	// 	})

	// 	t.Run("Database Error", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetUserByEmail(ctx, email).Return(sqlc.User{}, errors.New("database error"))
	// 		user, err := repo.GetUserByEmail(ctx, email)
	// 		assert.Nil(t, user)
	// 		assert.IsType(t, &exceptions.Exception{}, err)
	// 	})
	// })

	t.Run("CreateAddress", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.CreateAddressParams{
			CountriesID:      pgtype.Int8{},
			StatesID:         pgtype.Int8{},
			CitiesID:         pgtype.Int8{},
			CommunitiesID:    pgtype.Int8{},
			SubCommunitiesID: pgtype.Int8{},
			LocationsID:      pgtype.Int8{},
		}
		expectedAddress := sqlc.Address{
			ID:               1,
			CountriesID:      pgtype.Int8{},
			StatesID:         pgtype.Int8{},
			CitiesID:         pgtype.Int8{},
			CommunitiesID:    pgtype.Int8{},
			SubCommunitiesID: pgtype.Int8{},
			LocationsID:      pgtype.Int8{},
			CreatedAt:        time.Time{},
			UpdatedAt:        time.Time{},
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().CreateAddress(ctx, arg).Return(expectedAddress, nil)
			address, err := repo.CreateAddress(ctx, arg, mockQuerier)
			assert.Nil(t, err)
			assert.Equal(t, &expectedAddress, address)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().CreateAddress(ctx, arg).Return(sqlc.Address{}, errors.New("database error"))
			address, err := repo.CreateAddress(ctx, arg, mockQuerier)
			assert.Nil(t, address)
			assert.IsType(t, &exceptions.Exception{}, err)
		})
	})

	// t.Run("CreateProfile", func(t *testing.T) {
	// 	ctx := &gin.Context{}
	// 	arg := sqlc.CreateProfileParams{FirstName: "John"}
	// 	expectedProfile := sqlc.Profile{ID: 1, FirstName: arg.FirstName}

	// 	t.Run("Success", func(t *testing.T) {
	// 		mockQuerier.EXPECT().CreateProfile(ctx, arg).Return(expectedProfile, nil)
	// 		profile, err := repo.CreateProfile(ctx, arg, mockQuerier)
	// 		assert.Nil(t, err)
	// 		assert.Equal(t, &expectedProfile, profile)
	// 	})

	// 	t.Run("Database Error", func(t *testing.T) {
	// 		mockQuerier.EXPECT().CreateProfile(ctx, arg).Return(sqlc.Profile{}, errors.New("database error"))
	// 		profile, err := repo.CreateProfile(ctx, arg, mockQuerier)
	// 		assert.Nil(t, profile)
	// 		assert.IsType(t, &exceptions.Exception{}, err)
	// 	})
	// })

	t.Run("CreateUser", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.CreateUserParams{Email: "test@example.com"}
		expectedUser := sqlc.User{ID: 1, Email: arg.Email}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().CreateUser(ctx, arg).Return(expectedUser, nil)
			user, err := repo.CreateUser(ctx, arg, mockQuerier)
			assert.Nil(t, err)
			assert.Equal(t, &expectedUser, user)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().CreateUser(ctx, arg).Return(sqlc.User{}, errors.New("database error"))
			user, err := repo.CreateUser(ctx, arg, mockQuerier)
			assert.Nil(t, user)
			assert.IsType(t, &exceptions.Exception{}, err)
		})
	})

	t.Run("CreateBrokerBranchAgent", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.CreateBrokerBranchAgentParams{UsersID: 1}
		expectedAgent := sqlc.BrokerCompanyBranchesAgent{ID: 1, UsersID: arg.UsersID}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().CreateBrokerBranchAgent(ctx, arg).Return(expectedAgent, nil)
			agent, err := repo.CreateBrokerBranchAgent(ctx, arg, mockQuerier)
			assert.Nil(t, err)
			assert.Equal(t, &expectedAgent, agent)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().CreateBrokerBranchAgent(ctx, arg).Return(sqlc.BrokerCompanyBranchesAgent{}, errors.New("database error"))
			agent, err := repo.CreateBrokerBranchAgent(ctx, arg, mockQuerier)
			assert.Nil(t, agent)
			assert.IsType(t, &exceptions.Exception{}, err)
		})
	})

	t.Run("CreateBrokerAgent", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.CreateBrokerAgentParams{UsersID: 1}
		expectedAgent := sqlc.BrokerCompanyAgent{ID: 1, UsersID: arg.UsersID}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().CreateBrokerAgent(ctx, arg).Return(expectedAgent, nil)
			agent, err := repo.CreateBrokerAgent(ctx, arg, mockQuerier)
			assert.Nil(t, err)
			assert.Equal(t, &expectedAgent, agent)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().CreateBrokerAgent(ctx, arg).Return(sqlc.BrokerCompanyAgent{}, errors.New("database error"))
			agent, err := repo.CreateBrokerAgent(ctx, arg, mockQuerier)
			assert.Nil(t, agent)
			assert.IsType(t, &exceptions.Exception{}, err)
		})
	})

	t.Run("CreateAgentSubscriptionQuotaBranch", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.CreateAgentSubscriptionQuotaBranchParams{BrokerCompanyBranchesAgentsID: 1}
		expectedQuota := sqlc.AgentSubscriptionQuotaBranch{ID: 1, BrokerCompanyBranchesAgentsID: arg.BrokerCompanyBranchesAgentsID}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().CreateAgentSubscriptionQuotaBranch(ctx, arg).Return(expectedQuota, nil)
			quota, err := repo.CreateAgentSubscriptionQuotaBranch(ctx, arg, mockQuerier)
			assert.Nil(t, err)
			assert.Equal(t, &expectedQuota, quota)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().CreateAgentSubscriptionQuotaBranch(ctx, arg).Return(sqlc.AgentSubscriptionQuotaBranch{}, errors.New("database error"))
			quota, err := repo.CreateAgentSubscriptionQuotaBranch(ctx, arg, mockQuerier)
			assert.Nil(t, quota)
			assert.IsType(t, &exceptions.Exception{}, err)
		})
	})

	t.Run("CreateAgentSubscriptionQuota", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.CreateAgentSubscriptionQuotaParams{BrokerCompanyAgentsID: 1}
		expectedQuota := sqlc.AgentSubscriptionQuotum{ID: 1, BrokerCompanyAgentsID: arg.BrokerCompanyAgentsID}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().CreateAgentSubscriptionQuota(ctx, arg).Return(expectedQuota, nil)
			quota, err := repo.CreateAgentSubscriptionQuota(ctx, arg, mockQuerier)
			assert.Nil(t, err)
			assert.Equal(t, &expectedQuota, quota)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().CreateAgentSubscriptionQuota(ctx, arg).Return(sqlc.AgentSubscriptionQuotum{}, errors.New("database error"))
			quota, err := repo.CreateAgentSubscriptionQuota(ctx, arg, mockQuerier)
			assert.Nil(t, quota)
			assert.IsType(t, &exceptions.Exception{}, err)
		})
	})

	t.Run("GetCompanyAdmin", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.GetCompanyAdminParams{CompanyID: 1}
		expectedAdminID := int64(1)

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetCompanyAdmin(ctx, arg).Return(expectedAdminID, nil)
			adminID, err := repo.GetCompanyAdmin(ctx, arg)
			assert.Nil(t, err)
			assert.Equal(t, expectedAdminID, adminID)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetCompanyAdmin(ctx, arg).Return(int64(0), errors.New("database error"))
			adminID, err := repo.GetCompanyAdmin(ctx, arg)
			assert.Equal(t, int64(0), adminID)
			assert.IsType(t, &exceptions.Exception{}, err)
		})
	})

	t.Run("GetUserRegardlessOfStatus", func(t *testing.T) {
		ctx := &gin.Context{}
		userID := int64(1)
		expectedUser := sqlc.User{ID: userID}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetUserRegardlessOfStatus(ctx, userID).Return(expectedUser, nil)
			user, err := repo.GetUserRegardlessOfStatus(ctx, userID)
			assert.Nil(t, err)
			assert.Equal(t, &expectedUser, user)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetUserRegardlessOfStatus(ctx, userID).Return(sqlc.User{}, errors.New("database error"))
			user, err := repo.GetUserRegardlessOfStatus(ctx, userID)
			assert.Nil(t, user)
			assert.IsType(t, &exceptions.Exception{}, err)
		})
	})

	// t.Run("UpdateUserPermission", func(t *testing.T) {
	// 	ctx := &gin.Context{}
	// 	arg := sqlc.UpdateUserPermissionParams{
	// 		ID:                   1,
	// 		PermissionsID:        []int64{},
	// 		SubSectionPermission: []int64{},
	// 	}
	// 	expectedUser := sqlc.User{
	// 		ID:                   arg.ID,
	// 		Email:                "",
	// 		Username:             "",
	// 		Password:             "",
	// 		Status:               0,
	// 		RolesID:              pgtype.Int8{},
	// 		Department:           pgtype.Int8{},
	// 		ProfilesID:           0,
	// 		UserTypesID:          0,
	// 		SocialLogin:          pgtype.Text{},
	// 		CreatedAt:            time.Time{},
	// 		UpdatedAt:            time.Time{},
	// 		PermissionsID:        []int64{},
	// 		SubSectionPermission: []int64{},
	// 		IsVerified:           pgtype.Bool{},
	// 	}

	// 	t.Run("Success", func(t *testing.T) {
	// 		mockQuerier.EXPECT().UpdateUserPermission(ctx, arg).Return(expectedUser, nil)
	// 		user, err := repo.UpdateUserPermission(ctx, arg)
	// 		assert.Nil(t, err)
	// 		assert.Equal(t, &expectedUser, user)
	// 	})

	// 	t.Run("Database Error", func(t *testing.T) {
	// 		mockQuerier.EXPECT().UpdateUserPermission(ctx, arg).Return(sqlc.User{}, errors.New("database error"))
	// 		user, err := repo.UpdateUserPermission(ctx, arg)
	// 		assert.Nil(t, user)
	// 		assert.IsType(t, &exceptions.Exception{}, err)
	// 	})
	// })

	// t.Run("GetAllSubSectionByPermissionID", func(t *testing.T) {
	// 	ctx := &gin.Context{}
	// 	permissionID := int64(1)
	// 	expectedSubSections := []sqlc.SubSection{{ID: 1}, {ID: 2}}

	// 	t.Run("Success", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetAllSubSectionByPermissionID(ctx, permissionID).Return(expectedSubSections, nil)
	// 		subSections, err := repo.GetAllSubSectionByPermissionID(ctx, permissionID)
	// 		assert.Nil(t, err)
	// 		assert.Equal(t, expectedSubSections, subSections)
	// 	})

	// 	t.Run("Database Error", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetAllSubSectionByPermissionID(ctx, permissionID).Return(nil, errors.New("database error"))
	// 		subSections, err := repo.GetAllSubSectionByPermissionID(ctx, permissionID)
	// 		assert.Nil(t, subSections)
	// 		assert.IsType(t, &exceptions.Exception{}, err)
	// 	})
	// })

}
