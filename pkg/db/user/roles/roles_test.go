package roles_repo_test

import (
	"errors"
	"testing"

	mockdb "aqary_admin/internal/domain/sqlc/mock"
	"aqary_admin/internal/domain/sqlc/sqlc"
	db "aqary_admin/pkg/db/user/roles"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/stretchr/testify/assert"
	"go.uber.org/mock/gomock"
)

func TestRoleRepository(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockQuerier := mockdb.NewMockStore(ctrl)
	repo := db.NewRoleRepository(mockQuerier)

	t.Run("CreateRole", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.CreateRoleParams{Role: "Admin"}
		expectedRole := sqlc.Role{ID: 1, Role: "Admin"}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().CreateRole(ctx, arg).Return(expectedRole, nil)
			role, err := repo.CreateRole(ctx, arg)
			assert.Nil(t, err)
			assert.Equal(t, expectedRole, role)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().CreateRole(ctx, arg).Return(sqlc.Role{}, errors.New("database error"))
			role, err := repo.CreateRole(ctx, arg)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, sqlc.Role{}, role)
		})
	})

	// t.Run("GetRole", func(t *testing.T) {
	// 	ctx := &gin.Context{}
	// 	id := int64(1)
	// 	expectedRole := sqlc.Role{ID: 1, Role: "Admin"}

	// 	t.Run("Success", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetRole(ctx, id).Return(expectedRole, nil)
	// 		role, err := repo.GetRole(ctx, id)
	// 		assert.Nil(t, err)
	// 		assert.Equal(t, expectedRole, role)
	// 	})

	// 	t.Run("Not Found", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetRole(ctx, id).Return(sqlc.Role{}, pgx.ErrNoRows)
	// 		role, err := repo.GetRole(ctx, id)
	// 		assert.IsType(t, &exceptions.Exception{}, err)
	// 		assert.Equal(t, sqlc.Role{}, role)
	// 		assert.Equal(t, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "Role not found"), err)
	// 	})
	// })

	t.Run("GetRoleByRole", func(t *testing.T) {
		ctx := &gin.Context{}
		roleName := "Admin"
		expectedRole := sqlc.Role{ID: 1, Role: "Admin"}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetRoleByRole(ctx, roleName).Return(expectedRole, nil)
			role, err := repo.GetRoleByRole(ctx, sqlc.GetRoleByRoleParams{})
			assert.Nil(t, err)
			assert.Equal(t, expectedRole, role)
		})

		t.Run("Not Found", func(t *testing.T) {
			mockQuerier.EXPECT().GetRoleByRole(ctx, roleName).Return(sqlc.Role{}, pgx.ErrNoRows)
			role, err := repo.GetRoleByRole(ctx, sqlc.GetRoleByRoleParams{})
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, sqlc.Role{}, role)
			assert.Equal(t, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "Role not found"), err)
		})
	})

	t.Run("GetAllRole", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.GetAllRoleParams{Limit: 10, Offset: 0}
		expectedRoles := []sqlc.Role{{ID: 1, Role: "Admin"}, {ID: 2, Role: "User"}}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllRole(ctx, arg).Return(expectedRoles, nil)
			roles, err := repo.GetAllRole(ctx, arg)
			assert.Nil(t, err)
			assert.Equal(t, expectedRoles, roles)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllRole(ctx, arg).Return(nil, errors.New("database error"))
			roles, err := repo.GetAllRole(ctx, arg)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Nil(t, roles)
		})
	})

	t.Run("GetCountAllRoles", func(t *testing.T) {
		ctx := &gin.Context{}
		expectedCount := int64(2)

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountAllRoles(ctx, gomock.Any()).Return(expectedCount, nil)
			count, err := repo.GetCountAllRoles(ctx, 1)
			assert.Nil(t, err)
			assert.Equal(t, expectedCount, count)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountAllRoles(ctx, gomock.Any()).Return(int64(0), errors.New("database error"))
			count, err := repo.GetCountAllRoles(ctx, 1)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, int64(0), count)
		})
	})

	t.Run("GetAllRoleWithRolePermissionChecked", func(t *testing.T) {
		ctx := &gin.Context{}
		expectedRoles := []sqlc.GetAllRoleWithRolePermissionCheckedRow{
			{
				Role: "test",
				ID:   01,
				Isavailableinrolespermissions: pgtype.Bool{
					Bool:  true,
					Valid: true,
				},
			},
			{
				Role: "test 2",
				ID:   02,
				Isavailableinrolespermissions: pgtype.Bool{
					Bool:  true,
					Valid: true,
				},
			},
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllRoleWithRolePermissionChecked(ctx).Return(expectedRoles, nil)
			roles, err := repo.GetAllRoleWithRolePermissionChecked(ctx)
			assert.Nil(t, err)
			assert.Equal(t, expectedRoles, roles)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllRoleWithRolePermissionChecked(ctx).Return(nil, errors.New("database error"))
			roles, err := repo.GetAllRoleWithRolePermissionChecked(ctx)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Nil(t, roles)
		})
	})

	t.Run("UpdateRole", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.UpdateRoleParams{ID: 1, Role: "SuperAdmin"}
		expectedRole := sqlc.Role{ID: 1, Role: "SuperAdmin"}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().UpdateRole(ctx, arg).Return(expectedRole, nil)
			role, err := repo.UpdateRole(ctx, arg)
			assert.Nil(t, err)
			assert.Equal(t, expectedRole, role)
		})

		t.Run("Not Found", func(t *testing.T) {
			mockQuerier.EXPECT().UpdateRole(ctx, arg).Return(sqlc.Role{}, pgx.ErrNoRows)
			role, err := repo.UpdateRole(ctx, arg)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, sqlc.Role{}, role)
			assert.Equal(t, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "Role not found"), err)
		})
	})

	t.Run("DeleteRole", func(t *testing.T) {
		ctx := &gin.Context{}
		id := int64(1)

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().DeleteRole(ctx, id).Return(nil)
			err := repo.DeleteRole(ctx, sqlc.DeleteRoleParams{})
			assert.Nil(t, err)
		})

		t.Run("Not Found", func(t *testing.T) {
			mockQuerier.EXPECT().DeleteRole(ctx, id).Return(pgx.ErrNoRows)
			err := repo.DeleteRole(ctx, sqlc.DeleteRoleParams{})
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "Role not found"), err)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().DeleteRole(ctx, id).Return(errors.New("database error"))
			err := repo.DeleteRole(ctx, sqlc.DeleteRoleParams{})
			assert.IsType(t, &exceptions.Exception{}, err)
		})
	})
}
