package department_usecase_test

import (
	domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	department_usecase "aqary_admin/internal/usecases/user/department"

	"testing"

	db "aqary_admin/pkg/db/user/mock"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	gomock "go.uber.org/mock/gomock"
)

func TestCreateDepartment(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := department_usecase.NewDepartmentUseCase(mockRepo)

	tests := []struct {
		name           string
		req            domain.CreateDepartmentRequest
		mockBehavior   func()
		expectedResult *sqlc.Department
		expectedError  *exceptions.Exception
	}{
		{
			name: "Success",
			req:  domain.CreateDepartmentRequest{Title: "New Department"},
			mockBehavior: func() {
				mockRepo.EXPECT().GetDepartmentByTitle(gomock.Any(), sqlc.GetDepartmentByDepartmentParams{Department: "New Department"}).Return(&sqlc.Department{}, nil)
				mockRepo.EXPECT().CreateDepartment(gomock.Any(), gomock.Any()).Return(&sqlc.Department{ID: 1, Department: "New Department"}, nil)
			},
			expectedResult: &sqlc.Department{ID: 1, Department: "New Department"},
			expectedError:  nil,
		},
		{
			name: "Department Already Exists",
			req:  domain.CreateDepartmentRequest{Title: "Existing Department"},
			mockBehavior: func() {
				mockRepo.EXPECT().GetDepartmentByTitle(gomock.Any(), sqlc.GetDepartmentByDepartmentParams{Department: "Existing Department"}).Return(&sqlc.Department{Department: "Existing Department"}, nil)
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.AlreadyExistCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.CreateDepartment(ctx, tt.req)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestGetDepartment(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	// mockRepo := mock.NewMockUserCompositeRepo(ctrl)
	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := department_usecase.NewDepartmentUseCase(mockRepo)

	tests := []struct {
		name           string
		id             int32
		mockBehavior   func()
		expectedResult *sqlc.Department
		expectedError  *exceptions.Exception
	}{
		{
			name: "Success",
			id:   1,
			mockBehavior: func() {
				mockRepo.EXPECT().GetDepartment(gomock.Any(), int32(1)).Return(sqlc.Department{ID: 1, Department: "Test Department"}, nil)
			},
			expectedResult: &sqlc.Department{ID: 1, Department: "Test Department"},
			expectedError:  nil,
		},
		{
			name: "Department Not Found",
			id:   2,
			mockBehavior: func() {
				mockRepo.EXPECT().GetDepartment(gomock.Any(), int32(2)).Return(sqlc.Department{}, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.GetDepartment(ctx, domain.GetDepartmentRequest{})

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestGetAllDepartments(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	// mockRepo := mock.NewMockUserCompositeRepo(ctrl)
	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := department_usecase.NewDepartmentUseCase(mockRepo)

	tests := []struct {
		name           string
		req            domain.GetAllDepartmentRequest
		mockBehavior   func()
		expectedResult []sqlc.Department
		expectedCount  int64
		expectedError  *exceptions.Exception
	}{
		{
			name: "Success",
			req:  domain.GetAllDepartmentRequest{PageNo: 1, PageSize: 10, Search: "test"},
			mockBehavior: func() {
				mockRepo.EXPECT().GetAllDepartment(gomock.Any(), sqlc.GetAllDepartmentParams{
					Limit:  10,
					Offset: 0,
					Search: "%test%",
				}).Return([]sqlc.Department{{ID: 1, Department: "Test Department"}}, nil)
				mockRepo.EXPECT().GetCountAllDepartment(gomock.Any(), "%test%").Return(int64(1), nil)
			},
			expectedResult: []sqlc.Department{{ID: 1, Department: "Test Department"}},
			expectedCount:  1,
			expectedError:  nil,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, count, err := uc.GetAllDepartments(ctx, tt.req)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedCount, count)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestGetAllDepartmentsWithoutPagination(t *testing.T) {
	// ctrl := gomock.NewController(t)
	// defer ctrl.Finish()

	// // mockRepo := mock.NewMockUserCompositeRepo(ctrl)
	// mockRepo := db.NewMockUserCompositeRepo(ctrl)
	// uc := department_usecase.NewDepartmentUseCase(mockRepo)

	// tests := []struct {
	// 	name           string
	// 	mockBehavior   func()
	// 	expectedResult []fn.CustomFormat
	// 	expectedCount  int64
	// 	expectedError  *exceptions.Exception
	// }{
	// 	{
	// 		name: "Success",
	// 		mockBehavior: func() {
	// 			mockRepo.EXPECT().GetAllDepartmentWithoutPagination(gomock.Any()).Return([]sqlc.Department{
	// 				// {ID: 1, Title: "Department 1"},
	// 				// {ID: 2, Title: "Department 2"},
	// 			}, nil)
	// 			mockRepo.EXPECT().GetCountAllDepartment(gomock.Any(), "%%").Return(int64(2), nil)
	// 		},
	// 		expectedResult: []fn.CustomFormat{
	// 			{ID: 1, Name: "Department 1"},
	// 			{ID: 2, Name: "Department 2"},
	// 		},
	// 		expectedCount: 2,
	// 		expectedError: nil,
	// 	},
	// }

	// for _, tt := range tests {
	// 	t.Run(tt.name, func(t *testing.T) {
	// 		tt.mockBehavior()

	// 		// ctx, _ := gin.CreateTestContext(nil)
	// 		// // result, count, err := uc.GetAllDepartmentsWithoutPagination(ctx)

	// 		testin

	// 		// assert.Equal(t, tt.expectedResult, result)
	// 		// assert.Equal(t, tt.expectedCount, count)
	// 		// assert.Equal(t, tt.expectedError, err)
	// 	})
	// }
}

func TestUpdateDepartment(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	// mockRepo := mock.NewMockUserCompositeRepo(ctrl)
	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := department_usecase.NewDepartmentUseCase(mockRepo)

	tests := []struct {
		name           string
		id             int32
		req            domain.UpdateDepartmentRequest
		mockBehavior   func()
		expectedResult *sqlc.Department
		expectedError  *exceptions.Exception
	}{
		{
			name: "Success",
			id:   1,
			req:  domain.UpdateDepartmentRequest{Department: "Updated Department"},
			mockBehavior: func() {
				mockRepo.EXPECT().GetDepartment(gomock.Any(), int32(1)).Return(sqlc.Department{ID: 1, Department: "Old Department"}, nil)
				mockRepo.EXPECT().UpdateDepartment(gomock.Any(), gomock.Any()).Return(&sqlc.Department{ID: 1, Department: "Updated Department"}, nil)
			},
			expectedResult: &sqlc.Department{ID: 1, Department: "Updated Department"},
			expectedError:  nil,
		},
		{
			name: "Department Not Found",
			id:   2,
			req:  domain.UpdateDepartmentRequest{Department: "Updated Department"},
			mockBehavior: func() {
				mockRepo.EXPECT().GetDepartment(gomock.Any(), int32(2)).Return(sqlc.Department{}, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.UpdateDepartment(ctx, domain.UpdateDepartmentRequest{})

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestDeleteDepartment(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	// mockRepo := mock.NewMockUserCompositeRepo(ctrl)
	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := department_usecase.NewDepartmentUseCase(mockRepo)

	tests := []struct {
		name          string
		id            int64
		mockBehavior  func()
		expectedError *exceptions.Exception
	}{
		{
			name: "Success",
			id:   1,
			mockBehavior: func() {
				mockRepo.EXPECT().GetDepartment(gomock.Any(), int32(1)).Return(sqlc.Department{ID: 1, Department: "Department to Delete"}, nil)
				mockRepo.EXPECT().DeleteDepartment(gomock.Any(), int64(1)).Return(nil)
			},
			expectedError: nil,
		},
		{
			name: "Department Not Found",
			id:   2,
			mockBehavior: func() {
				mockRepo.EXPECT().GetDepartment(gomock.Any(), int32(2)).Return(sqlc.Department{}, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))
			},
			expectedError: exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			err := uc.DeleteDepartment(ctx, domain.GetDepartmentRequest{})

			assert.Equal(t, tt.expectedError, err)
		})
	}
}
