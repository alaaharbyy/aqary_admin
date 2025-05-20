package usecase_test

import (
	"testing"

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

func TestCheckEmail(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	mockPool := &pgxpool.Pool{}
	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewCheckEmailUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		email          string
		mockBehavior   func()
		expectedResult bool
		expectedError  *exceptions.Exception
	}{
		{
			name:  "Email exists",
			email: "existing@example.com",
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserByEmail(gomock.Any(), "existing@example.com").Return(sqlc.User{
					Email: "existing@example.com",
				}, nil)
			},
			expectedResult: true,
			expectedError:  nil,
		},
		{
			name:  "Email does not exist",
			email: "nonexistent@example.com",
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserByEmail(gomock.Any(), "nonexistent@example.com").Return(sqlc.User{
					Email: "",
				}, nil)
			},
			expectedResult: false,
			expectedError:  nil,
		},
		{
			name:  "Error occurred",
			email: "error@example.com",
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserByEmail(gomock.Any(), "error@example.com").Return(sqlc.User{}, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))
			},
			expectedResult: false,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.CheckEmail(ctx, tt.email)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestCheckUsername(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	mockPool := &pgxpool.Pool{}

	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewCheckEmailUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		username       string
		mockBehavior   func()
		expectedResult bool
		expectedError  *exceptions.Exception
	}{
		{
			name:     "Username exists",
			username: "existinguser",
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserByName(gomock.Any(), "existinguser").Return(sqlc.User{
					Username: "existinguser",
				}, nil)
			},
			expectedResult: true,
			expectedError:  nil,
		},
		{
			name:     "Username does not exist",
			username: "nonexistentuser",
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserByName(gomock.Any(), "nonexistentuser").Return(sqlc.User{
					Username: "",
				}, nil)
			},
			expectedResult: false,
			expectedError:  nil,
		},
		{
			name:     "Error occurred",
			username: "erroruser",
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserByName(gomock.Any(), "erroruser").Return(sqlc.User{}, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))
			},
			expectedResult: false,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.CheckUsername(ctx, tt.username)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}
