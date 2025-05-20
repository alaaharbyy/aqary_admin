package usecase_test

import (
	"testing"

	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	usecase "aqary_admin/internal/usecases/user"
	db "aqary_admin/pkg/db/user/mock"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/stretchr/testify/assert"
	gomock "go.uber.org/mock/gomock"
)

func TestGetAllOtherUser(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := usecase.NewOtheruserUseCase(mockRepo)

	tests := []struct {
		name           string
		input          domain.GetAllUserRequest
		mockBehavior   func()
		expectedResult []*response.AllUserOutput
		expectedCount  int64
		expectedError  *exceptions.Exception
	}{
		{
			name: "Successful retrieval",
			input: domain.GetAllUserRequest{
				PageNo:   1,
				PageSize: 10,
			},
			mockBehavior: func() {
				mockRepo.EXPECT().GetAllOtherUser(gomock.Any(), sqlc.GetAllOtherUserParams{
					Limit:  10,
					Offset: 0,
				}).Return([]sqlc.User{
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

				mockRepo.EXPECT().GetCountAllOtherUser(gomock.Any()).Return(int64(2), nil)
			},
			expectedResult: []*response.AllUserOutput{
				{
					ID:           1,
					Username:     "user1",
					Email:        "user1@example.com",
					Phone:        "1234567890",
					Department:   "",
					Role:         "",
					Country:      "TestCountry",
					State:        "TestState",
					City:         "TestCity",
					Community:    "TestCommunity",
					SubCommunity: "",
				},
				{
					ID:           2,
					Username:     "user2",
					Email:        "user2@example.com",
					Phone:        "0987654321",
					Department:   "",
					Role:         "",
					Country:      "TestCountry",
					State:        "TestState",
					City:         "TestCity",
					Community:    "TestCommunity",
					SubCommunity: "",
				},
			},
			expectedCount: 2,
			expectedError: nil,
		},
		{
			name: "Error retrieving users",
			input: domain.GetAllUserRequest{
				PageNo:   1,
				PageSize: 10,
			},
			mockBehavior: func() {
				mockRepo.EXPECT().GetAllOtherUser(gomock.Any(), sqlc.GetAllOtherUserParams{
					Limit:  10,
					Offset: 0,
				}).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))
			},
			expectedResult: nil,
			expectedCount:  0,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, count, err := uc.GetAllOtherUser(ctx, tt.input)

			assert.Equal(t, tt.expectedCount, count)
			assert.Equal(t, tt.expectedError, err)

			assert.Equal(t, len(tt.expectedResult), len(result), "Result length mismatch")
			for i := range tt.expectedResult {
				compareAllUserOutput(t, tt.expectedResult[i], result[i])
			}
		})
	}
}

func TestGetAllOtherUserByCountry(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := usecase.NewOtheruserUseCase(mockRepo)

	tests := []struct {
		name           string
		input          domain.GetAllOtherUserByCountryRequest
		mockBehavior   func()
		expectedResult []*response.AllUserOutput
		expectedCount  int64
		expectedError  *exceptions.Exception
	}{
		{
			name: "Successful retrieval by country",
			input: domain.GetAllOtherUserByCountryRequest{
				PageNo:   1,
				PageSize: 10,
				Country:  1,
			},
			mockBehavior: func() {
				mockRepo.EXPECT().GetAllOtherUsersByCountryId(gomock.Any(), sqlc.GetAllOtherUsersByCountryIdParams{
					Limit:  10,
					Offset: 0,
					ID:     1,
				}).Return([]sqlc.GetAllOtherUsersByCountryIdRow{
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

				mockRepo.EXPECT().GetCountAllOtherUserByCountry(gomock.Any(), int64(1)).Return(int64(2), nil)
			},
			expectedResult: []*response.AllUserOutput{
				{
					ID:           1,
					Username:     "user1",
					Email:        "user1@example.com",
					Phone:        "1234567890",
					Department:   "",
					Role:         "",
					Country:      "TestCountry",
					State:        "TestState",
					City:         "TestCity",
					Community:    "TestCommunity",
					SubCommunity: "",
				},
				{
					ID:           2,
					Username:     "user2",
					Email:        "user2@example.com",
					Phone:        "0987654321",
					Department:   "",
					Role:         "",
					Country:      "TestCountry",
					State:        "TestState",
					City:         "TestCity",
					Community:    "TestCommunity",
					SubCommunity: "",
				},
			},
			expectedCount: 2,
			expectedError: nil,
		},
		{
			name: "Error retrieving users by country",
			input: domain.GetAllOtherUserByCountryRequest{
				PageNo:   1,
				PageSize: 10,
				Country:  1,
			},
			mockBehavior: func() {
				mockRepo.EXPECT().GetAllOtherUsersByCountryId(gomock.Any(), sqlc.GetAllOtherUsersByCountryIdParams{
					Limit:  10,
					Offset: 0,
					ID:     1,
				}).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))
			},
			expectedResult: nil,
			expectedCount:  0,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, count, err := uc.GetAllOtherUserByCountry(ctx, tt.input)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedCount, count)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func compareAllUserOutput(t *testing.T, expected, actual *response.AllUserOutput) {
	assert.Equal(t, expected.ID, actual.ID)
	assert.Equal(t, expected.Username, actual.Username)
	assert.Equal(t, expected.Email, actual.Email)
	assert.Equal(t, expected.Phone, actual.Phone)
	assert.Equal(t, expected.Department, actual.Department)
	assert.Equal(t, expected.Role, actual.Role)
	assert.Equal(t, expected.Country, actual.Country)
	assert.Equal(t, expected.State, actual.State)
	assert.Equal(t, expected.City, actual.City)
	assert.Equal(t, expected.Community, actual.Community)
	assert.Equal(t, expected.SubCommunity, actual.SubCommunity)
}
