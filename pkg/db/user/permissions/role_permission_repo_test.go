package permissions_repo_test

import (
	"errors"
	"testing"
	"time"

	mockdb "aqary_admin/internal/domain/sqlc/mock"
	"aqary_admin/internal/domain/sqlc/sqlc"
	db "aqary_admin/pkg/db/user/permissions"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"go.uber.org/mock/gomock"
)

func TestRolePermissionRepo(t *testing.T) {
	utils.IS_TEST_MODE = true
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockQuerier := mockdb.NewMockStore(ctrl)
	repo := db.NewPermissionRepository(mockQuerier)

	t.Run("CreateRolePermission", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.CreateRolePermissionParams{
			RolesID:              0,
			PermissionsID:        []int64{1, 2, 3},
			SubSectionPermission: []int64{},
			CreatedAt:            time.Time{},
			UpdatedAt:            time.Time{},
		}
		expectedRolePermission := sqlc.RolesPermission{
			ID:                   1,
			RolesID:              0,
			PermissionsID:        []int64{},
			SubSectionPermission: []int64{},
			CreatedAt:            time.Time{},
			UpdatedAt:            time.Time{},
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().CreateRolePermission(gomock.Any(), arg).Return(expectedRolePermission, nil)
			result, err := repo.CreateRolePermission(ctx, arg)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedRolePermission, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().CreateRolePermission(gomock.Any(), arg).Return(sqlc.RolesPermission{}, errors.New("database error"))
			_, err := repo.CreateRolePermission(ctx, arg)
			assert.NotNil(t, err)
		})
	})

	t.Run("GetAllRolePermission", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.GetAllRolePermissionParams{Limit: 10, Offset: 0}
		expectedRolePermissions := []sqlc.GetAllRolePermissionRow{{ID: 1}, {ID: 2}}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllRolePermission(gomock.Any(), arg).Return(expectedRolePermissions, nil)
			result, err := repo.GetAllRolePermission(ctx, arg)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedRolePermissions, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllRolePermission(gomock.Any(), arg).Return(nil, errors.New("database error"))
			_, err := repo.GetAllRolePermission(ctx, arg)
			assert.NotNil(t, err)
		})
	})

	t.Run("GetCountAllRolePermission", func(t *testing.T) {
		ctx := &gin.Context{}
		search := "test"
		expectedCount := int64(10)

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountAllRolePermission(gomock.Any(), search).Return(expectedCount, nil)
			result, err := repo.GetCountAllRolePermission(ctx, search)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedCount, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountAllRolePermission(gomock.Any(), search).Return(int64(0), errors.New("database error"))
			_, err := repo.GetCountAllRolePermission(ctx, search)
			assert.NotNil(t, err)
		})
	})

	t.Run("UpdateRolePermission", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.UpdateRolePermissionParams{PermissionsID: []int64{1, 2, 3}}
		expectedRolePermission := sqlc.RolesPermission{PermissionsID: arg.PermissionsID}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().UpdateRolePermission(gomock.Any(), arg).Return(expectedRolePermission, nil)
			result, err := repo.UpdateRolePermission(ctx, arg)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedRolePermission, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().UpdateRolePermission(gomock.Any(), arg).Return(sqlc.RolesPermission{}, errors.New("database error"))
			_, err := repo.UpdateRolePermission(ctx, arg)
			assert.NotNil(t, err)
		})
	})

	t.Run("DeleteRolePermission", func(t *testing.T) {
		ctx := &gin.Context{}
		id := int64(1)

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().DeleteRolePermission(gomock.Any(), id).Return(nil)
			err := repo.DeleteRolePermission(ctx, id)
			assert.IsType(t, &exceptions.Exception{}, err)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().DeleteRolePermission(gomock.Any(), id).Return(errors.New("database error"))
			err := repo.DeleteRolePermission(ctx, id)
			assert.NotNil(t, err)
		})
	})

	t.Run("GetRolePermission", func(t *testing.T) {
		ctx := &gin.Context{}
		id := int64(1)
		expectedRolePermission := sqlc.RolesPermission{ID: id}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetRolePermission(gomock.Any(), id).Return(expectedRolePermission, nil)
			result, err := repo.GetRolePermission(ctx, id)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedRolePermission, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetRolePermission(gomock.Any(), id).Return(sqlc.RolesPermission{}, errors.New("database error"))
			_, err := repo.GetRolePermission(ctx, id)
			assert.NotNil(t, err)
		})
	})

	t.Run(
		"DeleteOnePermissionInRole",
		func(t *testing.T) {
			ctx := &gin.Context{}
			arg := sqlc.DeleteOnePermissionInRoleParams{ID: 1, Column2: 2}
			expectedRolePermission := sqlc.RolesPermission{ID: arg.ID}

			t.Run("Success", func(t *testing.T) {
				mockQuerier.EXPECT().DeleteOnePermissionInRole(gomock.Any(), arg).Return(expectedRolePermission, nil)
				result, err := repo.DeleteOnePermissionInRole(ctx, arg)
				assert.IsType(t, &exceptions.Exception{}, err)
				assert.Equal(t, expectedRolePermission, result)
			})

			t.Run("Error", func(t *testing.T) {
				mockQuerier.EXPECT().DeleteOnePermissionInRole(gomock.Any(), arg).Return(sqlc.RolesPermission{}, errors.New("database error"))
				_, err := repo.DeleteOnePermissionInRole(ctx, arg)
				assert.NotNil(t, err)
			})
		},
	)

	t.Run("GetAllRolePermissionWithoutPagination", func(t *testing.T) {
		ctx := &gin.Context{}
		expectedRolePermissions := []sqlc.RolesPermission{{ID: 1}, {ID: 2}}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllRolePermissionWithoutPagination(gomock.Any()).Return(expectedRolePermissions, nil)
			result, err := repo.GetAllRolePermissionWithoutPagination(ctx)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedRolePermissions, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllRolePermissionWithoutPagination(gomock.Any()).Return(nil, errors.New("database error"))
			_, err := repo.GetAllRolePermissionWithoutPagination(ctx)
			assert.NotNil(t, err)
		})
	})

}
