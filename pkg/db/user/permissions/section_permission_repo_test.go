package permissions_repo_test

import (
	"errors"
	"testing"

	mockdb "aqary_admin/internal/domain/sqlc/mock"
	"aqary_admin/internal/domain/sqlc/sqlc"
	db "aqary_admin/pkg/db/user/permissions"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"go.uber.org/mock/gomock"
)

func TestSectionPermissionRepo(t *testing.T) {
	utils.IS_TEST_MODE = true
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockQuerier := mockdb.NewMockStore(ctrl)
	repo := db.NewPermissionRepository(mockQuerier)

	t.Run("GetSectionPermissionByTitle", func(t *testing.T) {
		ctx := &gin.Context{}
		title := "Test Section Permission"
		expectedSectionPermission := sqlc.SectionPermission{ID: 1, Title: title}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetSectionPermissionByTitle(gomock.Any(), title).Return(expectedSectionPermission, nil)
			result, err := repo.GetSectionPermissionByTitle(ctx, title)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedSectionPermission, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetSectionPermissionByTitle(gomock.Any(), title).Return(sqlc.SectionPermission{}, errors.New("database error"))
			_, err := repo.GetSectionPermissionByTitle(ctx, title)
			assert.NotNil(t, err)
		})
	})

	t.Run("GetAllSectionPermission", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.GetAllSectionPermissionParams{Limit: 10, Offset: 0}
		expectedSectionPermissions := []sqlc.SectionPermission{{ID: 1}, {ID: 2}}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllSectionPermission(gomock.Any(), arg).Return(expectedSectionPermissions, nil)
			result, err := repo.GetAllSectionPermission(ctx, arg)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedSectionPermissions, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllSectionPermission(gomock.Any(), arg).Return(nil, errors.New("database error"))
			_, err := repo.GetAllSectionPermission(ctx, arg)
			assert.NotNil(t, err)
		})
	})

	t.Run("GetCountAllSectionPermission", func(t *testing.T) {
		ctx := &gin.Context{}
		search := "test"
		expectedCount := int64(10)

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountAllSectionPermission(gomock.Any(), search).Return(expectedCount, nil)
			result, err := repo.GetCountAllSectionPermission(ctx, search)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedCount, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountAllSectionPermission(gomock.Any(), search).Return(int64(0), errors.New("database error"))
			_, err := repo.GetCountAllSectionPermission(ctx, search)
			assert.NotNil(t, err)
		})
	})

	t.Run("UpdateSectionPermission", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.UpdateSectionPermissionParams{ID: 1, Title: "Updated Section Permission"}
		expectedSectionPermission := sqlc.SectionPermission{ID: arg.ID, Title: arg.Title}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().UpdateSectionPermission(gomock.Any(), arg).Return(expectedSectionPermission, nil)
			result, err := repo.UpdateSectionPermission(ctx, arg)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedSectionPermission, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().UpdateSectionPermission(gomock.Any(), arg).Return(sqlc.SectionPermission{}, errors.New("database error"))
			_, err := repo.UpdateSectionPermission(ctx, arg)
			assert.NotNil(t, err)
		})
	})

	t.Run("GetCountAllPermissionSectionIds", func(t *testing.T) {
		ctx := &gin.Context{}
		expectedCount := int64(10)

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountAllPermissionSectionIds(gomock.Any()).Return(expectedCount, nil)
			result, err := repo.GetCountAllPermissionSectionIds(ctx)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedCount, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountAllPermissionSectionIds(gomock.Any()).Return(int64(0), errors.New("database error"))
			_, err := repo.GetCountAllPermissionSectionIds(ctx)
			assert.NotNil(t, err)
		})
	})

	t.Run("GetAllIDANDPermissionsFromSubSectionPermissionWithoutPagination", func(t *testing.T) {
		ctx := &gin.Context{}
		expectedRows := []sqlc.GetAllIDANDPermissionsFromSubSectionPermissionWithoutPaginationRow{{ID: 1}, {ID: 2}}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllIDANDPermissionsFromSubSectionPermissionWithoutPagination(gomock.Any()).Return(expectedRows, nil)
			result, err := repo.GetAllIDANDPermissionsFromSubSectionPermissionWithoutPagination(ctx)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedRows, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllIDANDPermissionsFromSubSectionPermissionWithoutPagination(gomock.Any()).Return(nil, errors.New("database error"))
			_, err := repo.GetAllIDANDPermissionsFromSubSectionPermissionWithoutPagination(ctx)
			assert.NotNil(t, err)
		})
	})

	t.Run("CountAllSubSection", func(t *testing.T) {
		ctx := &gin.Context{}
		expectedCount := int64(10)

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().CountAllSubSection(gomock.Any()).Return(expectedCount, nil)
			result, err := repo.CountAllSubSection(ctx)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedCount, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().CountAllSubSection(gomock.Any()).Return(int64(0), errors.New("database error"))
			_, err := repo.CountAllSubSection(ctx)
			assert.NotNil(t, err)
		})
	})

	t.Run("DeleteAllSubSection", func(t *testing.T) {
		ctx := &gin.Context{}
		ids := []int64{1, 2, 3}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().DeleteAllSubSection(gomock.Any(), ids).Return(nil)
			err := repo.DeleteAllSubSection(ctx, ids)
			assert.IsType(t, &exceptions.Exception{}, err)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().DeleteAllSubSection(gomock.Any(), ids).Return(errors.New("database error"))
			err := repo.DeleteAllSubSection(ctx, ids)
			assert.NotNil(t, err)
		})
	})

	t.Run("DeleteSubSection", func(t *testing.T) {
		ctx := &gin.Context{}
		id := int64(1)

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().DeleteSubSection(gomock.Any(), id).Return(nil)
			err := repo.DeleteSubSection(ctx, id)
			assert.IsType(t, &exceptions.Exception{}, err)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().DeleteSubSection(gomock.Any(), id).Return(errors.New("database error"))
			err := repo.DeleteSubSection(ctx, id)
			assert.NotNil(t, err)
		})
	})

	t.Run("GetAllNestedSubSectionPermissonByButtonID", func(t *testing.T) {
		ctx := &gin.Context{}
		id := int64(1)
		expectedSubSections := []sqlc.SubSection{{ID: 1}, {ID: 2}}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllNestedSubSectionPermissonByButtonID(gomock.Any(), id).Return(expectedSubSections, nil)
			result, err := repo.GetAllNestedSubSectionPermissonByButtonID(ctx, id)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedSubSections, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllNestedSubSectionPermissonByButtonID(gomock.Any(), id).Return(nil, errors.New("database error"))
			_, err := repo.GetAllNestedSubSectionPermissonByButtonID(ctx, id)
			assert.NotNil(t, err)
		})
	})

}
