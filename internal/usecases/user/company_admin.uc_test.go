package usecase_test

import (
	"testing"

	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	usecase "aqary_admin/internal/usecases/user"
	db "aqary_admin/pkg/db/user/mock"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/fn"
	"aqary_admin/pkg/utils/security"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/stretchr/testify/assert"
	gomock "go.uber.org/mock/gomock"
)

func TestAddCompanyAdminPermission(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	mockPool := &pgxpool.Pool{}
	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewCompanyAdminUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		input          domain.AddCompanyAdminPermissionRequest
		mockBehavior   func()
		expectedResult *sqlc.User
		expectedError  *exceptions.Exception
	}{
		{
			name: "Successful permission addition",
			input: domain.AddCompanyAdminPermissionRequest{
				Id:          1,
				CompanyType: 1,
				Permissions: []int64{1, 2, 3},
			},
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserIDFromCompanies(gomock.Any(), sqlc.GetUserIDFromCompaniesParams{
					ID:          1,
					CompanyType: 1,
				}).Return(int64(1), nil)

				mockRepo.EXPECT().GetUser(gomock.Any(), int64(1)).Return(&sqlc.User{
					ID: 1,
				}, nil)

				mockRepo.EXPECT().UpdateUserPermission(gomock.Any(), sqlc.UpdateUserPermissionParams{
					UserID:        1,
					PermissionsID: []int64{1, 2, 3},
					SubSectionsID: []int64{},
				}).Return(&sqlc.User{
					ID: 1,
					// PermissionsID: []int64{1, 2, 3},
				}, nil)
			},
			expectedResult: &sqlc.User{
				ID: 1,
				// PermissionsID: []int64{1, 2, 3},
			},
			expectedError: nil,
		},
		{
			name: "Error getting user ID",
			input: domain.AddCompanyAdminPermissionRequest{
				Id:          1,
				CompanyType: 1,
				Permissions: []int64{1, 2, 3},
			},
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserIDFromCompanies(gomock.Any(), sqlc.GetUserIDFromCompaniesParams{
					ID:          1,
					CompanyType: 1,
				}).Return(int64(0), exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.AddCompanyAdminPermission(ctx, tt.input)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestGetSingleUser(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	mockPool := &pgxpool.Pool{}
	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewCompanyAdminUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		userID         int64
		mockBehavior   func()
		expectedResult *response.UserOutput
		expectedError  *exceptions.Exception
	}{
		{
			name:   "Successful user retrieval",
			userID: 1,
			mockBehavior: func() {
				mockRepo.EXPECT().GetUser(gomock.Any(), int64(1)).Return(&sqlc.User{
					ID:         1,
					Username:   "testuser",
					Email:      "test@example.com",
					ProfilesID: 1,
					// PermissionsID:        []int64{1, 2},
					// SubSectionPermission: []int64{1, 2},
					UserTypesID: 2,
					// Department:  pgtype.Int8{Int64: 1, Valid: true},
					RolesID: pgtype.Int8{Int64: 1, Valid: true},
				}, nil)

				mockRepo.EXPECT().GetProfile(gomock.Any(), int64(1)).Return(&sqlc.Profile{
					ID:        1,
					FirstName: "Test",
					LastName:  "User",
					// PhoneNumber: "1234567890",
					AddressesID: 1,
				}, nil)

				mockRepo.EXPECT().GetDepartment(gomock.Any(), int32(1)).Return(sqlc.Department{
					ID:         1,
					Department: "TestDepartment",
				}, nil)

				mockRepo.EXPECT().GetRole(gomock.Any(), int64(1)).Return(sqlc.Role{
					ID:   1,
					Role: "TestRole",
				}, nil)

				mockRepo.EXPECT().GetAddress(gomock.Any(), int32(1)).Return(sqlc.Address{
					ID:               1,
					CountriesID:      pgtype.Int8{Int64: 1, Valid: true},
					StatesID:         pgtype.Int8{Int64: 1, Valid: true},
					CitiesID:         pgtype.Int8{Int64: 1, Valid: true},
					CommunitiesID:    pgtype.Int8{Int64: 1, Valid: true},
					SubCommunitiesID: pgtype.Int8{Int64: 1, Valid: true},
				}, nil)

				mockRepo.EXPECT().GetCountry(gomock.Any(), int32(1)).Return(sqlc.Country{
					ID:      1,
					Country: "TestCountry",
				}, nil)

				mockRepo.EXPECT().GetState(gomock.Any(), int32(1)).Return(sqlc.State{
					ID:    1,
					State: "TestState",
				}, nil)

				mockRepo.EXPECT().GetCity(gomock.Any(), int32(1)).Return(sqlc.City{
					ID:   1,
					City: "TestCity",
				}, nil)

				mockRepo.EXPECT().GetCommunity(gomock.Any(), int32(1)).Return(sqlc.Community{
					ID:        1,
					Community: "TestCommunity",
				}, nil)

				mockRepo.EXPECT().GetSubCommunity(gomock.Any(), int32(1)).Return(sqlc.SubCommunity{
					ID:           1,
					SubCommunity: "TestSubCommunity",
				}, nil)

				// Permission-related expectations
				mockRepo.EXPECT().GetAllSectionPermissionWithoutPagination(gomock.Any()).Return([]sqlc.SectionPermission{
					{ID: 1, Title: "TestSection", SubTitle: pgtype.Text{String: "TestSubTitle", Valid: true}, Indicator: 1},
				}, nil)

				mockRepo.EXPECT().GetAllForSuperUserPermissionBySectionPermissionId(gomock.Any(), gomock.Any()).Return([]sqlc.Permission{
					{ID: 1, Title: "TestPermission"},
					{ID: 2, Title: "TestPermission2"},
				}, nil)

				mockRepo.EXPECT().GetAllSubSectionByPermissionID(gomock.Any(), gomock.Any()).Return([]sqlc.SubSection{
					{ID: 1, SubSectionName: "TestSubSection", SubSectionNameConstant: "TEST_SUB_SECTION", Indicator: 1, PermissionsID: 1},
					{ID: 2, SubSectionName: "TestSubSection2", SubSectionNameConstant: "TEST_SUB_SECTION_2", Indicator: 2, PermissionsID: 2},
				}, nil).AnyTimes()

				mockRepo.EXPECT().GetAllSubSectionPermissionBySubSectionButtonID(gomock.Any(), gomock.Any()).Return([]sqlc.SubSection{
					{ID: 1, SubSectionName: "TestTernarySubSection", SubSectionNameConstant: "TEST_TERNARY_SUB_SECTION", Indicator: 1, PermissionsID: 1},
				}, nil).AnyTimes()

				mockRepo.EXPECT().GetPermission(gomock.Any(), gomock.Any()).Return(sqlc.Permission{
					ID:    1,
					Title: "TestPermission",
					SubTitle: pgtype.Text{
						String: "TestSubTitle",
						Valid:  true,
					},
					Indicator: 1,
				}, nil).AnyTimes()
			},
			expectedResult: &response.UserOutput{
				ID:         1,
				Username:   "testuser",
				FirstName:  "Test",
				LastName:   "User",
				Email:      "test@example.com",
				Phone:      "1234567890",
				UserTypeId: 2,
				Department: fn.CustomFormat{
					ID:   1,
					Name: "TestDepartment",
				},
				Role: fn.CustomFormat{
					ID:   1,
					Name: "TestRole",
				},
				Country: fn.CustomFormat{
					ID:   1,
					Name: "TestCountry",
				},
				State: fn.CustomFormat{
					ID:   1,
					Name: "TestState",
				},
				City: fn.CustomFormat{
					ID:   1,
					Name: "TestCity",
				},
				Community: fn.CustomFormat{
					ID:   1,
					Name: "TestCommunity",
				},
				SubCommunity: fn.CustomFormat{
					ID:   1,
					Name: "TestSubCommunity",
				},
			},
			expectedError: nil,
		},
		// ... other test cases ...
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.GetSingleUser(ctx, tt.userID, domain.GetSingleUserReq{})

			if tt.expectedError != nil {
				assert.Equal(t, tt.expectedError, err)
				assert.Nil(t, result)
			} else {
				assert.Nil(t, err)
				assert.NotNil(t, result)
				assert.Equal(t, tt.expectedResult.ID, result.ID)
				assert.Equal(t, tt.expectedResult.Username, result.Username)
				assert.Equal(t, tt.expectedResult.FirstName, result.FirstName)
				assert.Equal(t, tt.expectedResult.LastName, result.LastName)
				assert.Equal(t, tt.expectedResult.Email, result.Email)
				assert.Equal(t, tt.expectedResult.Phone, result.Phone)
				assert.Equal(t, tt.expectedResult.UserTypeId, result.UserTypeId)
				assert.Equal(t, tt.expectedResult.Department, result.Department)
				assert.Equal(t, tt.expectedResult.Role, result.Role)
				assert.Equal(t, tt.expectedResult.Country, result.Country)
				assert.Equal(t, tt.expectedResult.State, result.State)
				assert.Equal(t, tt.expectedResult.City, result.City)
				assert.Equal(t, tt.expectedResult.Community, result.Community)
				assert.Equal(t, tt.expectedResult.SubCommunity, result.SubCommunity)

				// Basic check for permissions without detailed assertions
				assert.NotNil(t, result.Permission)
				// assert.Greater(t, len(result.Permission), 0)

				// // You can add more detailed checks for the permission structure if needed
				// // For example:
				// assert.Equal(t, int64(1), result.Permission[0].ID)
				// assert.Equal(t, "TestSection", result.Permission[0].Label)
				// assert.Greater(t, len(result.Permission[0].CustomPermission), 0)
			}
		})
	}
}
