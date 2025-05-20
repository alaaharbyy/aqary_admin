package usecase_test

import (
	"testing"

	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	usecase "aqary_admin/internal/usecases/user"
	db "aqary_admin/pkg/db/user/mock"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/security"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/stretchr/testify/assert"
	gomock "go.uber.org/mock/gomock"
)

func TestGetAllPendingUser(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	mockPool := &pgxpool.Pool{}
	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewPendingUserUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		input          domain.GetAllUserRequest
		mockBehavior   func()
		expectedResult []*response.AllPendingUserOutput
		expectedCount  *int64
		expectedError  *exceptions.Exception
	}{
		{
			name: "Successful retrieval",
			input: domain.GetAllUserRequest{
				PageNo:   1,
				PageSize: 10,
			},
			mockBehavior: func() {
				mockRepo.EXPECT().GetAllCompanyPendingUser(gomock.Any(), sqlc.GetAllCompanyPendingUserParams{
					Limit:  10,
					Offset: 0,
				}).Return([]*sqlc.User{
					{ID: 1, Username: "user1", Email: "user1@example.com", ProfilesID: 1},
					{ID: 2, Username: "user2", Email: "user2@example.com", ProfilesID: 2},
				}, nil)

				mockRepo.EXPECT().GetProfile(gomock.Any(), int64(1)).Return(&sqlc.Profile{
					// PhoneNumber: "1234567890",
					AddressesID: 1,
				}, nil)
				mockRepo.EXPECT().GetProfile(gomock.Any(), int64(2)).Return(&sqlc.Profile{
					// PhoneNumber: "0987654321",
					AddressesID: 2,
				}, nil)

				mockRepo.EXPECT().GetACompanyByUserID(gomock.Any(), int64(1)).Return(sqlc.GetACompanyByUserIDRow{
					CompanyID:   1,
					CompanyType: pgtype.Int8{Int64: 1, Valid: true},
					IsBranch:    pgtype.Bool{Bool: false, Valid: true},
				}, nil)
				mockRepo.EXPECT().GetACompanyByUserID(gomock.Any(), int64(2)).Return(sqlc.GetACompanyByUserIDRow{
					CompanyID:   2,
					CompanyType: pgtype.Int8{Int64: 2, Valid: true},
					IsBranch:    pgtype.Bool{Bool: true, Valid: true},
				}, nil)

				// mockRepo.EXPECT().GetDepartment(gomock.Any(), gomock.Any()).AnyTimes().Return(sqlc.Department{
				// 	Title: "TestDepartment",
				// }, nil)

				// mockRepo.EXPECT().GetRole(gomock.Any(), gomock.Any()).AnyTimes().Return(sqlc.Role{
				// 	Role: "TestRole",
				// }, nil)

				mockRepo.EXPECT().GetAddress(gomock.Any(), gomock.Any()).AnyTimes().Return(sqlc.Address{
					CountriesID:   pgtype.Int8{Int64: 1, Valid: true},
					StatesID:      pgtype.Int8{Int64: 1, Valid: true},
					CitiesID:      pgtype.Int8{Int64: 1, Valid: true},
					CommunitiesID: pgtype.Int8{Int64: 1, Valid: true},
				}, nil)

				mockRepo.EXPECT().GetCountry(gomock.Any(), gomock.Any()).AnyTimes().Return(sqlc.Country{
					Country: "TestCountry",
				}, nil)

				mockRepo.EXPECT().GetState(gomock.Any(), gomock.Any()).AnyTimes().Return(sqlc.State{
					State: "TestState",
				}, nil)

				mockRepo.EXPECT().GetCity(gomock.Any(), gomock.Any()).AnyTimes().Return(sqlc.City{
					City: "TestCity",
				}, nil)

				mockRepo.EXPECT().GetCommunity(gomock.Any(), gomock.Any()).AnyTimes().Return(sqlc.Community{
					Community: "TestCommunity",
				}, nil)

				// mockRepo.EXPECT().GetSubCommunity(gomock.Any(), gomock.Any()).AnyTimes().Return(sqlc.SubCommunity{
				// 	SubCommunity: "TestSubCommunity",
				// }, nil)

				count := int64(2)
				mockRepo.EXPECT().GetCountAllPendingUser(gomock.Any()).Return(&count, nil)
			},
			expectedResult: []*response.AllPendingUserOutput{
				{
					ID:                 1,
					Username:           "user1",
					Email:              "user1@example.com",
					Phone:              "1234567890",
					CompanyID:          1,
					CompanyType:        1,
					IsBranch:           false,
					Department:         "",
					Role:               "",
					Country:            "TestCountry",
					State:              "TestState",
					City:               "TestCity",
					Community:          "TestCommunity",
					SubCommunity:       "",
					VerificationStatus: "VERIFIED PHASE-1",
				},
				{
					ID:                 2,
					Username:           "user2",
					Email:              "user2@example.com",
					Phone:              "0987654321",
					CompanyID:          2,
					CompanyType:        2,
					IsBranch:           true,
					Department:         "",
					Role:               "",
					Country:            "TestCountry",
					State:              "TestState",
					City:               "TestCity",
					Community:          "TestCommunity",
					SubCommunity:       "",
					VerificationStatus: "VERIFIED PHASE-1",
				},
			},
			expectedCount: func() *int64 { count := int64(2); return &count }(),
			expectedError: nil,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, count, err := uc.GetAllPendingUser(ctx, tt.input)

			assert.Equal(t, tt.expectedCount, count)
			assert.Equal(t, tt.expectedError, err)
			assert.Equal(t, len(tt.expectedResult), len(result))

			for i, expectedUser := range tt.expectedResult {
				assert.Equal(t, expectedUser.ID, result[i].ID)
				assert.Equal(t, expectedUser.Username, result[i].Username)
				assert.Equal(t, expectedUser.Email, result[i].Email)
				assert.Equal(t, expectedUser.Phone, result[i].Phone)
				assert.Equal(t, expectedUser.CompanyID, result[i].CompanyID)
				assert.Equal(t, expectedUser.CompanyType, result[i].CompanyType)
				assert.Equal(t, expectedUser.IsBranch, result[i].IsBranch)
				assert.Equal(t, expectedUser.Department, result[i].Department)
				assert.Equal(t, expectedUser.Role, result[i].Role)
				assert.Equal(t, expectedUser.Country, result[i].Country)
				assert.Equal(t, expectedUser.State, result[i].State)
				assert.Equal(t, expectedUser.City, result[i].City)
				assert.Equal(t, expectedUser.Community, result[i].Community)
				assert.Equal(t, expectedUser.SubCommunity, result[i].SubCommunity)
				assert.Equal(t, expectedUser.VerificationStatus, result[i].VerificationStatus)
			}
		})
	}
}

func TestDeletePendingUser(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	mockPool := &pgxpool.Pool{}
	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewPendingUserUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		userID         int64
		mockBehavior   func()
		expectedResult *sqlc.User
		expectedError  *exceptions.Exception
	}{
		{
			name:   "Successful deletion",
			userID: 1,
			mockBehavior: func() {
				mockRepo.EXPECT().GetPendingUser(gomock.Any(), int64(1)).Return(&sqlc.User{
					ID: 1,
				}, nil)

				mockRepo.EXPECT().UpdateUserStatus(gomock.Any(), sqlc.UpdateUserStatusParams{
					ID:     1,
					Status: 6,
				}).Return(&sqlc.User{
					ID:     1,
					Status: 6,
				}, nil)
			},
			expectedResult: &sqlc.User{
				ID:     1,
				Status: 6,
			},
			expectedError: nil,
		},
		{
			name:   "User not found",
			userID: 999,
			mockBehavior: func() {
				mockRepo.EXPECT().GetPendingUser(gomock.Any(), int64(999)).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.DeletePendingUser(ctx, tt.userID)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}
