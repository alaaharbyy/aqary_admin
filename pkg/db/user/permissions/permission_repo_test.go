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
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/stretchr/testify/assert"
	"go.uber.org/mock/gomock"
)

func TestPermissionRepo(t *testing.T) {
	utils.IS_TEST_MODE = true
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockQuerier := mockdb.NewMockStore(ctrl)
	repo := db.NewPermissionRepository(mockQuerier)

	t.Run("CreatePermission", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.CreatePermissionParams{
			Title:               "Test Permission",
			SubTitle:            pgtype.Text{String: "Test Subtitle", Valid: true},
			SectionPermissionID: 1,
		}
		expectedPermission := &sqlc.Permission{
			ID:                  1,
			Title:               arg.Title,
			SubTitle:            arg.SubTitle,
			SectionPermissionID: arg.SectionPermissionID,
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().CreatePermission(gomock.Any(), arg).Return(*expectedPermission, nil)
			result, err := repo.CreatePermission(ctx, arg, mockQuerier)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedPermission, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().CreatePermission(gomock.Any(), arg).Return(sqlc.Permission{}, errors.New("database error"))
			_, err := repo.CreatePermission(ctx, arg, mockQuerier)
			assert.NotNil(t, err)
		})
	})

	t.Run("GetPermissionBySubTitle", func(t *testing.T) {
		ctx := &gin.Context{}
		subTitle := pgtype.Text{String: "Test Subtitle", Valid: true}
		expectedPermission := sqlc.Permission{
			ID:       1,
			Title:    "Test Permission",
			SubTitle: subTitle,
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetPermissionBySubTitle(gomock.Any(), subTitle).Return(expectedPermission, nil)
			result, err := repo.GetPermissionByTitle(ctx, subTitle.String)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedPermission, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetPermissionBySubTitle(gomock.Any(), subTitle).Return(sqlc.Permission{}, errors.New("database error"))
			_, err := repo.GetPermissionByTitle(ctx, subTitle.String)
			assert.NotNil(t, err)
		})
	})

	t.Run("UpdatePermission", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.UpdatePermissionParams{
			ID:    1,
			Title: "Updated Permission",
		}
		expectedPermission := sqlc.Permission{
			ID:    arg.ID,
			Title: arg.Title,
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().UpdatePermission(gomock.Any(), arg).Return(expectedPermission, nil)
			result, err := repo.UpdatePermission(ctx, arg)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedPermission, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().UpdatePermission(gomock.Any(), arg).Return(sqlc.Permission{}, errors.New("database error"))
			_, err := repo.UpdatePermission(ctx, arg)
			assert.NotNil(t, err)
		})
	})

	t.Run("DeletePermission", func(t *testing.T) {
		ctx := &gin.Context{}
		id := int64(1)

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().DeletePermission(gomock.Any(), id).Return(nil)
			err := repo.DeletePermission(ctx, id)
			assert.IsType(t, &exceptions.Exception{}, err)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().DeletePermission(gomock.Any(), id).Return(errors.New("database error"))
			err := repo.DeletePermission(ctx, id)
			assert.NotNil(t, err)
		})
	})

	t.Run("GetPermissionBySectionID", func(t *testing.T) {
		ctx := &gin.Context{}
		sectionID := int64(1)
		expectedPermissions := []int64{1, 2, 3}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetPermissionBySectionID(gomock.Any(), sectionID).Return(expectedPermissions, nil)
			result, err := repo.GetPermissionBySectionID(ctx, sectionID)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedPermissions, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetPermissionBySectionID(gomock.Any(), sectionID).Return(nil, errors.New("database error"))
			_, err := repo.GetPermissionBySectionID(ctx, sectionID)
			assert.NotNil(t, err)
		})
	})

	t.Run("GetAllSectionPermissionMV", func(t *testing.T) {
		ctx := &gin.Context{}
		limit, offset := int64(10), int64(0)
		expectedSections := []sqlc.SectionPermissionMv{{ID: 1}, {ID: 2}}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllSectionPermissionMV(gomock.Any(), sqlc.GetAllSectionPermissionMVParams{
				Limit:  int32(limit),
				Offset: int32(offset),
			}).Return(expectedSections, nil)
			result, err := repo.GetAllSectionPermissionMV(ctx, limit, offset, "")
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedSections, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllSectionPermissionMV(gomock.Any(), sqlc.GetAllSectionPermissionMVParams{
				Limit:  int32(limit),
				Offset: int32(offset),
			}).Return(nil, errors.New("database error"))
			_, err := repo.GetAllSectionPermissionMV(ctx, limit, offset, "")
			assert.NotNil(t, err)
		})
	})

	// Add more tests for other methods...

	t.Run("CreateSubSection", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.CreateSubSectionParams{
			SubSectionName: "Test SubSection",
			PermissionsID:  1,
		}
		expectedSubSection := sqlc.SubSection{
			ID:             1,
			SubSectionName: arg.SubSectionName,
			PermissionsID:  arg.PermissionsID,
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().CreateSubSection(gomock.Any(), arg).Return(expectedSubSection, nil)
			result, err := repo.CreateSubSection(ctx, arg)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedSubSection, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().CreateSubSection(gomock.Any(), arg).Return(sqlc.SubSection{}, errors.New("database error"))
			_, err := repo.CreateSubSection(ctx, arg)
			assert.NotNil(t, err)
		})
	})

	t.Run("GetAllPermission", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.GetAllPermissionParams{Limit: 10, Offset: 0}
		expectedPermissions := []sqlc.Permission{{ID: 1}, {ID: 2}}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllPermission(gomock.Any(), arg).Return(expectedPermissions, nil)
			result, err := repo.GetAllPermission(ctx, arg)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedPermissions, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllPermission(gomock.Any(), arg).Return(nil, errors.New("database error"))
			_, err := repo.GetAllPermission(ctx, arg)
			assert.NotNil(t, err)
		})
	})

	// Continue with tests for all other methods in the PermissionRepo interface...

	t.Run("CreateSectionPermission", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.CreateSectionPermissionParams{
			Title: "Test Section Permission",
		}
		expectedSectionPermission := &sqlc.SectionPermission{
			ID:    1,
			Title: arg.Title,
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().CreateSectionPermission(gomock.Any(), arg).Return(*expectedSectionPermission, nil)
			result, err := repo.CreateSectionPermission(ctx, arg, mockQuerier)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedSectionPermission, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().CreateSectionPermission(gomock.Any(), arg).Return(sqlc.SectionPermission{}, errors.New("database error"))
			_, err := repo.CreateSectionPermission(ctx, arg, mockQuerier)
			assert.NotNil(t, err)
		})
	})

	t.Run("GetCountAllSectionPermissionMV", func(t *testing.T) {
		ctx := &gin.Context{}
		expectedCount := int64(10)

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountAllSectionPermissionMV(gomock.Any(), gomock.Any()).Return(expectedCount, nil)
			result, err := repo.GetCountAllSectionPermissionMV(ctx, "%%")
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedCount, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountAllSectionPermissionMV(gomock.Any(), gomock.Any()).Return(int64(0), errors.New("database error"))
			_, err := repo.GetCountAllSectionPermissionMV(ctx, "%%")
			assert.NotNil(t, err)
		})
	})

	t.Run("GetAllSectionPermissionWithoutPaginationMV", func(t *testing.T) {
		ctx := &gin.Context{}
		expectedSections := []sqlc.SectionPermissionMv{{ID: 1}, {ID: 2}}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllSectionPermissionWithoutPaginationMV(gomock.Any(), gomock.Any()).Return(expectedSections, nil)
			result, err := repo.GetAllSectionPermissionWithoutPaginationMV(ctx, "")
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedSections, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllSectionPermissionWithoutPaginationMV(gomock.Any(), gomock.Any()).Return(nil, errors.New("database error"))
			_, err := repo.GetAllSectionPermissionWithoutPaginationMV(ctx, "")
			assert.NotNil(t, err)
		})
	})

	t.Run("GetRolePermissionByRole", func(t *testing.T) {
		ctx := &gin.Context{}
		roleID := int64(1)
		expectedRolePermission := sqlc.RolesPermission{
			ID:                   1,
			RolesID:              roleID,
			PermissionsID:        []int64{},
			SubSectionPermission: []int64{},
			CreatedAt:            time.Time{},
			UpdatedAt:            time.Time{},
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetRolePermissionByRole(gomock.Any(), roleID).Return(expectedRolePermission, nil)
			result, err := repo.GetRolePermissionByRole(ctx, roleID)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedRolePermission, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetRolePermissionByRole(gomock.Any(), roleID).Return(sqlc.RolesPermission{}, errors.New("database error"))
			_, err := repo.GetRolePermissionByRole(ctx, roleID)
			assert.NotNil(t, err)
		})
	})

	t.Run("GetAllSubSectionByPermissionIDMV", func(t *testing.T) {
		ctx := &gin.Context{}
		permissionID := int64(1)
		expectedSubSections := []sqlc.SubSectionMv{{ID: 1}, {ID: 2}}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllSubSectionByPermissionIDMV(gomock.Any(), permissionID).Return(expectedSubSections, nil)
			result, err := repo.GetAllSubSectionByPermissionIDMV(ctx, sqlc.GetAllSubSectionByPermissionIDMVWithRelationParams{
				IsSuperUser:   0,
				SubSectionsID: []int64{},
				PermissionsID: permissionID,
			})
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedSubSections, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllSubSectionByPermissionIDMV(gomock.Any(), permissionID).Return(nil, errors.New("database error"))
			_, err := repo.GetAllSubSectionByPermissionIDMV(ctx, sqlc.GetAllSubSectionByPermissionIDMVWithRelationParams{
				IsSuperUser:   0,
				SubSectionsID: []int64{},
				PermissionsID: permissionID,
			})
			assert.NotNil(t, err)
		})
	})

	t.Run("GetAllSubSectionPermissionBySubSectionButtonIDMV", func(t *testing.T) {
		ctx := &gin.Context{}
		subSectionButtonID := int64(1)
		expectedSubSections := []sqlc.SubSectionMv{{ID: 1}, {ID: 2}}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllSubSectionPermissionBySubSectionButtonIDMV(gomock.Any(), subSectionButtonID).Return(expectedSubSections, nil)
			result, err := repo.GetAllSubSectionPermissionBySubSectionButtonIDMV(ctx, sqlc.GetAllSubSectionPermissionBySubSectionButtonIDMVParams{})
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedSubSections, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllSubSectionPermissionBySubSectionButtonIDMV(gomock.Any(), subSectionButtonID).Return(nil, errors.New("database error"))
			_, err := repo.GetAllSubSectionPermissionBySubSectionButtonIDMV(ctx, sqlc.GetAllSubSectionPermissionBySubSectionButtonIDMVParams{})
			assert.NotNil(t, err)
		})
	})

	t.Run("GetAllPermissionBySectionPermissionId", func(t *testing.T) {
		ctx := &gin.Context{}
		sectionPermissionID := int64(1)
		expectedPermissions := []sqlc.Permission{{ID: 1}, {ID: 2}}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllPermissionBySectionPermissionId(gomock.Any(), sectionPermissionID).Return(expectedPermissions, nil)
			result, err := repo.GetAllPermissionBySectionPermissionId(ctx, sectionPermissionID)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, expectedPermissions, result)
		})

		t.Run("Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllPermissionBySectionPermissionId(gomock.Any(), sectionPermissionID).Return(nil, errors.New("database error"))
			_, err := repo.GetAllPermissionBySectionPermissionId(ctx, sectionPermissionID)
			assert.NotNil(t, err)
		})
	})
}
