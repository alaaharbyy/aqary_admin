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
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/stretchr/testify/assert"
	gomock "go.uber.org/mock/gomock"
)

func TestCreateUserType(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserRepo(ctrl)
	mockPool := &pgxpool.Pool{}
	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewUserUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		input          domain.UserTypeRequest
		mockBehavior   func()
		expectedResult *sqlc.UserType
		expectedError  *exceptions.Exception
	}{
		{
			name:  "Successful user type creation",
			input: domain.UserTypeRequest{Type: "Admin"},
			mockBehavior: func() {
				mockRepo.EXPECT().CreateUserType(gomock.Any(), "Admin").Return(&sqlc.UserType{
					ID:       1,
					UserType: "Admin",
				}, nil)
			},
			expectedResult: &sqlc.UserType{
				ID:       1,
				UserType: "Admin",
			},
			expectedError: nil,
		},
		{
			name:  "Empty user type",
			input: domain.UserTypeRequest{Type: ""},
			mockBehavior: func() {
				mockRepo.EXPECT().CreateUserType(gomock.Any(), "").Return(nil, exceptions.GetExceptionByErrorCode(exceptions.BadRequestErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.BadRequestErrorCode),
		},
		{
			name:  "Duplicate user type",
			input: domain.UserTypeRequest{Type: "Admin"},
			mockBehavior: func() {
				mockRepo.EXPECT().CreateUserType(gomock.Any(), "Admin").Return(nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.CreateUserType(ctx, tt.input)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestGetAllUserTypes(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserRepo(ctrl)
	mockPool := &pgxpool.Pool{}
	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewUserUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		mockBehavior   func()
		expectedResult []*response.UserType
		expectedError  *exceptions.Exception
	}{
		{
			name: "Successful retrieval of all user types",
			mockBehavior: func() {
				mockRepo.EXPECT().GetAllUserType(gomock.Any()).Return(&[]sqlc.UserType{
					// {ID: 1, UserType: "Admin"},
					{ID: 2, UserType: "User"},
				}, nil)
			},
			expectedResult: []*response.UserType{
				// {ID: 1, Type: "Admin"},
				{ID: 2, Type: "User"},
			},
			expectedError: nil,
		},
		{
			name: "No user types found",
			mockBehavior: func() {
				mockRepo.EXPECT().GetAllUserType(gomock.Any()).Return(&[]sqlc.UserType{}, nil)
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode),
		},
		{
			name: "Database error",
			mockBehavior: func() {
				mockRepo.EXPECT().GetAllUserType(gomock.Any()).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.GetAllUserTypes(ctx)

			assert.Equal(t, tt.expectedError, err)

			if tt.expectedResult == nil {
				assert.Nil(t, result)
			} else {
				assert.Equal(t, len(tt.expectedResult), len(result))
				for i, expectedUserType := range tt.expectedResult {
					assert.Equal(t, expectedUserType.ID, result[i].ID)
					assert.Equal(t, expectedUserType.Type, result[i].Type)
				}
			}
		})
	}
}

func TestGetAllUserTypesForWeb(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserRepo(ctrl)
	mockPool := &pgxpool.Pool{}
	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewUserUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		mockBehavior   func()
		expectedResult []*response.UserType
		expectedError  *exceptions.Exception
	}{
		{
			name: "Successful retrieval of user types for web",
			mockBehavior: func() {
				mockRepo.EXPECT().GetAllUserType(gomock.Any()).Return(&[]sqlc.UserType{
					// {ID: 1, UserType: "Admin"},
					{ID: 1, UserType: "User"},
					// {ID: 3, UserType: "Manager"},
					// {ID: 4, UserType: "Guest"},
				}, nil)
			},
			expectedResult: []*response.UserType{
				{ID: 1, Type: "User"},
				// {ID: 3, Type: "Manager"},
				// {ID: 4, Type: "Guest"},
			},
			expectedError: nil,
		},
		{
			name: "No user types found",
			mockBehavior: func() {
				mockRepo.EXPECT().GetAllUserType(gomock.Any()).Return(&[]sqlc.UserType{}, nil)
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode),
		},
		{
			name: "Database error",
			mockBehavior: func() {
				mockRepo.EXPECT().GetAllUserType(gomock.Any()).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.GetAllUserTypesForWeb(ctx)

			assert.Equal(t, tt.expectedError, err)

			if tt.expectedResult == nil {
				assert.Nil(t, result)
			} else {
				assert.Equal(t, len(tt.expectedResult), len(result))
				for i, expectedUserType := range tt.expectedResult {
					assert.Equal(t, expectedUserType.ID, result[i].ID)
					assert.Equal(t, expectedUserType.Type, result[i].Type)
				}
			}
		})
	}
}

func TestGetUserType(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserRepo(ctrl)
	mockPool := &pgxpool.Pool{}
	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewUserUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		id             int64
		mockBehavior   func()
		expectedResult *response.UserType
		expectedError  *exceptions.Exception
	}{
		{
			name: "Successful retrieval of user type",
			id:   1,
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserType(gomock.Any(), int64(1)).Return(&sqlc.UserType{
					ID:       1,
					UserType: "Admin",
				}, nil)
			},
			expectedResult: &response.UserType{
				ID:   1,
				Type: "Admin",
			},
			expectedError: nil,
		},
		{
			name: "User type not found",
			id:   999,
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserType(gomock.Any(), int64(999)).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode),
		},
		{
			name: "no data found",
			id:   1,
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserType(gomock.Any(), int64(1)).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode),
		},
		{
			name: "Database error",
			id:   1,
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserType(gomock.Any(), int64(1)).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.GetUserType(ctx, tt.id)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestUpdateUserType(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserRepo(ctrl)
	mockPool := &pgxpool.Pool{}
	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewUserUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		id             int64
		input          domain.UserTypeRequest
		mockBehavior   func()
		expectedResult *sqlc.UserType
		expectedError  *exceptions.Exception
	}{
		{
			name:  "Successful update of user type",
			id:    1,
			input: domain.UserTypeRequest{Type: "SuperAdmin"},
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserType(gomock.Any(), int64(1)).Return(&sqlc.UserType{
					ID:       1,
					UserType: "Admin",
				}, nil)
				mockRepo.EXPECT().UpdateUserType(gomock.Any(), sqlc.UpdateUserTypeParams{
					ID:       1,
					UserType: "SuperAdmin",
				}).Return(&sqlc.UserType{
					ID:       1,
					UserType: "SuperAdmin",
				}, nil)
			},
			expectedResult: &sqlc.UserType{
				ID:       1,
				UserType: "SuperAdmin",
			},
			expectedError: nil,
		},
		{
			name:  "User type not found",
			id:    999,
			input: domain.UserTypeRequest{Type: "SuperAdmin"},
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserType(gomock.Any(), int64(999)).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode),
		},
		{
			name:  "Empty update",
			id:    1,
			input: domain.UserTypeRequest{Type: ""},
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserType(gomock.Any(), int64(1)).Return(&sqlc.UserType{
					ID:       1,
					UserType: "Admin",
				}, nil)
				mockRepo.EXPECT().UpdateUserType(gomock.Any(), sqlc.UpdateUserTypeParams{
					ID:       1,
					UserType: "Admin",
				}).Return(&sqlc.UserType{
					ID:       1,
					UserType: "Admin",
				}, nil)
			},
			expectedResult: &sqlc.UserType{
				ID:       1,
				UserType: "Admin",
			},
			expectedError: nil,
		},
		{
			name:  "Database error during update",
			id:    1,
			input: domain.UserTypeRequest{Type: "SuperAdmin"},
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserType(gomock.Any(), int64(1)).Return(&sqlc.UserType{
					ID:       1,
					UserType: "Admin",
				}, nil)
				mockRepo.EXPECT().UpdateUserType(gomock.Any(), sqlc.UpdateUserTypeParams{
					ID:       1,
					UserType: "SuperAdmin",
				}).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.UpdateUserType(ctx, tt.id, tt.input)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestDeleteUserType(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserRepo(ctrl)
	mockPool := &pgxpool.Pool{}
	mockTokenMaker := security.NewMockMaker(ctrl)

	uc := usecase.NewUserUseCase(mockRepo, mockPool, mockTokenMaker)

	tests := []struct {
		name           string
		id             int64
		mockBehavior   func()
		expectedResult *string
		expectedError  *exceptions.Exception
	}{
		{
			name: "Successful deletion of user type",
			id:   1,
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserType(gomock.Any(), int64(1)).Return(&sqlc.UserType{
					ID:       1,
					UserType: "Admin",
				}, nil)
				message := "User type deleted successfully"
				mockRepo.EXPECT().DeleteUserType(gomock.Any(), int64(1)).Return(&message, nil)
			},
			expectedResult: func() *string {
				message := "User type deleted successfully"
				return &message
			}(),
			expectedError: nil,
		},
		{
			name: "User type not found",
			id:   999,
			mockBehavior: func() {
				mockRepo.EXPECT().GetUserType(gomock.Any(), int64(999)).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.DeleteUserType(ctx, tt.id)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}
