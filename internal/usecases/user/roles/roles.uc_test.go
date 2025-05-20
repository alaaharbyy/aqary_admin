package roles_usecase_test

import (
	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	roles_usecase "aqary_admin/internal/usecases/user/roles"
	"log"

	"testing"

	db "aqary_admin/pkg/db/user/mock"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/stretchr/testify/assert"
	gomock "go.uber.org/mock/gomock"
)

func TestCreateRole(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := roles_usecase.NewRoleUseCase(mockRepo, nil, nil)

	tests := []struct {
		name           string
		req            domain.CreateRoleRequest
		mockBehavior   func()
		expectedResult *sqlc.Role
		expectedError  *exceptions.Exception
	}{
		{
			name: "Success",
			req:  domain.CreateRoleRequest{Role: "NewRole"},
			mockBehavior: func() {
				mockRepo.EXPECT().GetRoleByRole(gomock.Any(), "NewRole").Return(sqlc.Role{}, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))
				mockRepo.EXPECT().CreateRole(gomock.Any(), gomock.Any()).Return(sqlc.Role{ID: 1, Role: "NewRole"}, nil)
			},
			expectedResult: &sqlc.Role{ID: 1, Role: "NewRole"},
			expectedError:  nil,
		},
		{
			name: "Role Already Exists",
			req:  domain.CreateRoleRequest{Role: "ExistingRole"},
			mockBehavior: func() {
				mockRepo.EXPECT().GetRoleByRole(gomock.Any(), "ExistingRole").Return(sqlc.Role{ID: 1, Role: "ExistingRole"}, nil)
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.AlreadyExistCode, "Role already exists"),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.CreateRole(ctx, tt.req)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestGetRole(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := roles_usecase.NewRoleUseCase(mockRepo, nil, nil)

	tests := []struct {
		name           string
		id             int64
		mockBehavior   func()
		expectedResult *sqlc.Role
		expectedError  *exceptions.Exception
	}{
		{
			name: "Success",
			id:   1,
			mockBehavior: func() {
				mockRepo.EXPECT().GetRole(gomock.Any(), int64(1)).Return(sqlc.Role{ID: 1, Role: "TestRole"}, nil)
			},
			expectedResult: &sqlc.Role{ID: 1, Role: "TestRole"},
			expectedError:  nil,
		},
		{
			name: "Role Not Found",
			id:   2,
			mockBehavior: func() {
				mockRepo.EXPECT().GetRole(gomock.Any(), int64(2)).Return(sqlc.Role{}, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.GetRole(ctx, tt.id)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestGetAllRoles(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := roles_usecase.NewRoleUseCase(mockRepo, nil, nil)

	tests := []struct {
		name           string
		req            domain.GetAllRolesRequest
		mockBehavior   func()
		expectedResult []sqlc.Role
		expectedCount  int64
		expectedError  *exceptions.Exception
	}{
		{
			name: "Success",
			req:  domain.GetAllRolesRequest{PageNo: 1, PageSize: 10},
			mockBehavior: func() {
				mockRepo.EXPECT().GetAllRole(gomock.Any(), sqlc.GetAllRoleParams{
					Limit:  10,
					Offset: 0,
				}).Return([]sqlc.Role{{ID: 1, Role: "Role1"}, {ID: 2, Role: "Role2"}}, nil)
				mockRepo.EXPECT().GetCountAllRoles(gomock.Any(), gomock.Any()).Return(int64(2), nil)
			},
			expectedResult: []sqlc.Role{{ID: 1, Role: "Role1"}, {ID: 2, Role: "Role2"}},
			expectedCount:  2,
			expectedError:  nil,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, count, err := uc.GetAllRoles(ctx, tt.req)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedCount, count)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestGetAllRolesWithoutPagination(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	// mockRepo := mock.NewMockRoleRepository(ctrl)
	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := roles_usecase.NewRoleUseCase(mockRepo, nil, nil)

	tests := []struct {
		name           string
		mockBehavior   func()
		expectedResult []response.AllRolesOutput
		expectedCount  int64
		expectedError  *exceptions.Exception
	}{
		{
			name: "Success",
			mockBehavior: func() {
				mockRepo.EXPECT().GetAllRoleWithRolePermissionChecked(gomock.Any()).Return([]sqlc.GetAllRoleWithRolePermissionCheckedRow{
					{ID: 1, Role: "Role1", Isavailableinrolespermissions: pgtype.Bool{Bool: true, Valid: true}},
					{ID: 2, Role: "Role2", Isavailableinrolespermissions: pgtype.Bool{Bool: false, Valid: true}},
				}, nil)
				mockRepo.EXPECT().GetCountAllRoles(gomock.Any(), gomock.Any()).Return(int64(2), nil)
			},
			expectedResult: []response.AllRolesOutput{
				{ID: 1, Name: "Role1", IsRoleExist: true},
				{ID: 2, Name: "Role2", IsRoleExist: false},
			},
			expectedCount: 2,
			expectedError: nil,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, count, err := uc.GetAllRolesWithoutPagination(ctx, domain.GetAllRolesRequest{
				PageSize:     0,
				PageNo:       0,
				DepartmentID: 0,
			})

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedCount, count)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestUpdateRole(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	// mockRepo := mock.NewMockRoleRepository(ctrl)
	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := roles_usecase.NewRoleUseCase(mockRepo, nil, nil)

	tests := []struct {
		name           string
		id             int64
		req            domain.UpdateRoleRequest
		mockBehavior   func()
		expectedResult *sqlc.Role
		expectedError  *exceptions.Exception
	}{
		{
			name: "Success",
			id:   1,
			req:  domain.UpdateRoleRequest{Role: "UpdatedRole"},
			mockBehavior: func() {
				mockRepo.EXPECT().GetRole(gomock.Any(), int64(1)).Return(sqlc.Role{ID: 1, Role: "OldRole"}, nil)
				mockRepo.EXPECT().UpdateRole(gomock.Any(), gomock.Any()).Return(sqlc.Role{ID: 1, Role: "UpdatedRole"}, nil)
			},
			expectedResult: &sqlc.Role{ID: 1, Role: "UpdatedRole"},
			expectedError:  nil,
		},
		{
			name: "Role Not Found",
			id:   2,
			req:  domain.UpdateRoleRequest{Role: "UpdatedRole"},
			mockBehavior: func() {
				mockRepo.EXPECT().GetRole(gomock.Any(), int64(2)).Return(sqlc.Role{}, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockBehavior()

			ctx, _ := gin.CreateTestContext(nil)
			result, err := uc.UpdateRole(ctx, tt.id, tt.req)

			assert.Equal(t, tt.expectedResult, result)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}

func TestDeleteRole(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()
	//
	// mockRepo := mock.NewMockRoleRepository(ctrl)
	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := roles_usecase.NewRoleUseCase(mockRepo, nil, nil)

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
				mockRepo.EXPECT().GetRole(gomock.Any(), int64(1)).Return(sqlc.Role{ID: 1, Role: "RoleToDelete"}, nil)
				mockRepo.EXPECT().DeleteRole(gomock.Any(), int64(1)).Return(nil)
			},
			expectedError: nil,
		},
		{
			name: "Role Not Found",
			id:   2,
			mockBehavior: func() {
				mockRepo.EXPECT().GetRole(gomock.Any(), int64(2)).Return(sqlc.Role{}, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))
			},
			expectedError: exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode),
		},
	}

	for _, tt := range tests {
		log.Println("testing tt", tt, uc)
		// t.Run(tt.name, func(t *testing.T) {
		// 	tt.mockBehavior()

		// 	ctx, _ := gin.CreateTestContext(nil)
		// 	err := uc.DeleteRole(ctx, tt.id, 0)

		// 	assert.Equal(t, tt.expectedError, err)
		// })
	}
}
