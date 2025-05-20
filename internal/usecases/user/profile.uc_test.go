package usecase_test

import (
	"testing"

	domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	usecase "aqary_admin/internal/usecases/user"
	db "aqary_admin/pkg/db/user/mock"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/security"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/stretchr/testify/assert"
	gomock "go.uber.org/mock/gomock"
)

func TestCreateProfile(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	mockPool := &pgxpool.Pool{}
	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewProfileUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		input          domain.CreateProfileRequest
		mockBehavior   func()
		expectedResult *sqlc.Profile
		expectedError  *exceptions.Exception
	}{
		{
			name: "Successful profile creation",
			input: domain.CreateProfileRequest{
				FirstName:       "John",
				LastName:        "Doe",
				AddressID:       1,
				ProfileImageUrl: "http://example.com/image.jpg",
				PhoneNumber:     "1234567890",
				CompanyNumber:   "0987654321",
				WhatsappNumber:  "1231231234",
				Gender:          1,
				LanguageIDs:     []int64{1, 2},
			},
			mockBehavior: func() {
				mockRepo.EXPECT().CreateProfile(gomock.Any(), gomock.Any(), gomock.Any()).Return(&sqlc.Profile{
					ID:        1,
					FirstName: "John",
					LastName:  "Doe",
				}, nil)
			},
			expectedResult: &sqlc.Profile{
				ID:        1,
				FirstName: "John",
				LastName:  "Doe",
			},
			expectedError: nil,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.CreateProfile(ctx, tt.input)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestGetAllProfiles(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	mockPool := &pgxpool.Pool{}
	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewProfileUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		limit          int32
		mockBehavior   func()
		expectedResult []*sqlc.Profile
		expectedError  *exceptions.Exception
	}{
		{
			name:  "Successful retrieval of all profiles",
			limit: 10,
			mockBehavior: func() {
				mockRepo.EXPECT().GetAllProfile(gomock.Any()).Return([]*sqlc.Profile{
					{ID: 1, FirstName: "John", LastName: "Doe"},
					{ID: 2, FirstName: "Jane", LastName: "Doe"},
				}, nil)
			},
			expectedResult: []*sqlc.Profile{
				{ID: 1, FirstName: "John", LastName: "Doe"},
				{ID: 2, FirstName: "Jane", LastName: "Doe"},
			},
			expectedError: nil,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.GetAllProfiles(ctx, tt.limit)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestGetProfile(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	mockPool := &pgxpool.Pool{}
	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewProfileUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		profileID      int64
		mockBehavior   func()
		expectedResult *sqlc.Profile
		expectedError  *exceptions.Exception
	}{
		{
			name:      "Successful profile retrieval",
			profileID: 1,
			mockBehavior: func() {
				mockRepo.EXPECT().GetProfile(gomock.Any(), int64(1)).Return(&sqlc.Profile{
					ID:        1,
					FirstName: "John",
					LastName:  "Doe",
				}, nil)
			},
			expectedResult: &sqlc.Profile{
				ID:        1,
				FirstName: "John",
				LastName:  "Doe",
			},
			expectedError: nil,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.GetProfile(ctx, tt.profileID)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestUpdateProfile(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	mockPool := &pgxpool.Pool{}
	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewProfileUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		profileID      int64
		input          domain.UpdateProfileRequest
		mockBehavior   func()
		expectedResult *sqlc.Profile
		expectedError  *exceptions.Exception
	}{
		{
			name:      "Successful profile update",
			profileID: 1,
			input: domain.UpdateProfileRequest{
				FirstName: "John Updated",
				LastName:  "Doe Updated",
			},
			mockBehavior: func() {
				mockRepo.EXPECT().GetProfile(gomock.Any(), int64(1)).Return(&sqlc.Profile{
					ID:        1,
					FirstName: "John",
					LastName:  "Doe",
				}, nil)
				mockRepo.EXPECT().UpdateProfile(gomock.Any(), gomock.Any()).Return(&sqlc.Profile{
					ID:        1,
					FirstName: "John Updated",
					LastName:  "Doe Updated",
				}, nil)
			},
			expectedResult: &sqlc.Profile{
				ID:        1,
				FirstName: "John Updated",
				LastName:  "Doe Updated",
			},
			expectedError: nil,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.UpdateProfile(ctx, tt.profileID, tt.input)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestDeleteProfile(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	mockPool := &pgxpool.Pool{}
	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewProfileUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		profileID      int64
		mockBehavior   func()
		expectedResult *string
		expectedError  *exceptions.Exception
	}{
		{
			name:      "Successful profile deletion",
			profileID: 1,
			mockBehavior: func() {
				mockRepo.EXPECT().GetProfile(gomock.Any(), int64(1)).Return(&sqlc.Profile{
					ID:        1,
					FirstName: "John",
					LastName:  "Doe",
				}, nil)
				message := "Profile deleted successfully"
				mockRepo.EXPECT().DeleteProfile(gomock.Any(), int64(1)).Return(&message, nil)
			},
			expectedResult: func() *string {
				message := "Profile deleted successfully"
				return &message
			}(),
			expectedError: nil,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.DeleteProfile(ctx, tt.profileID)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}
