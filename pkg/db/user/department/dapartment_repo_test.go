package department_repo_test

import (
	mockdb "aqary_admin/internal/domain/sqlc/mock"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"time"

	"errors"
	"testing"

	db "aqary_admin/pkg/db/user/department"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/stretchr/testify/assert"
	"go.uber.org/mock/gomock"
)

func TestDepartmentRepository(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockQuerier := mockdb.NewMockStore(ctrl)
	repo := db.NewDepartmentRepository(mockQuerier)

	t.Run("CreateDepartment", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.CreateDepartmentParams{
			Department: "",
			CreatedAt:  time.Time{},
			Status:     0,
			CompanyID:  pgtype.Int8{},
			UpdatedAt:  time.Time{},
		}
		expectedDepartment := sqlc.Department{
			ID:         1,
			Department: "",
			Status:     0,
			CompanyID:  pgtype.Int8{},
			CreatedAt:  time.Time{},
			UpdatedAt:  time.Time{},
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().CreateDepartment(ctx, arg).Return(expectedDepartment, nil)
			department, err := repo.CreateDepartment(ctx, arg)
			assert.Nil(t, err)
			assert.Equal(t, &expectedDepartment, department)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().CreateDepartment(ctx, arg).Return(sqlc.Department{}, errors.New("database error"))
			department, err := repo.CreateDepartment(ctx, arg)
			assert.Nil(t, department)
			assert.IsType(t, &exceptions.Exception{}, err)
		})
	})

	t.Run("GetDepartmentByTitle", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.GetDepartmentByDepartmentParams{
			CompanyID:  nil,
			Department: "",
		}
		expectedDepartment := sqlc.Department{
			ID:         1,
			Department: "",
			Status:     0,
			CompanyID:  pgtype.Int8{},
			CreatedAt:  time.Time{},
			UpdatedAt:  time.Time{},
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetDepartmentByDepartment(ctx, arg).Return(expectedDepartment, nil)
			department, err := repo.GetDepartmentByTitle(ctx, arg)
			assert.Nil(t, err)
			assert.Equal(t, &expectedDepartment, department)
		})

		t.Run("Not Found", func(t *testing.T) {
			mockQuerier.EXPECT().GetDepartmentByDepartment(ctx, arg).Return(sqlc.Department{}, pgx.ErrNoRows)
			department, err := repo.GetDepartmentByTitle(ctx, arg)
			assert.Nil(t, department)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode), err)
		})
	})

	t.Run(
		"GetAllDepartment",
		func(t *testing.T) {
			ctx := &gin.Context{}
			arg := sqlc.GetAllDepartmentParams{Limit: 10, Offset: 0}
			expectedDepartments := []sqlc.Department{}

			t.Run("Success", func(t *testing.T) {
				mockQuerier.EXPECT().GetAllDepartment(ctx, arg).Return(expectedDepartments, nil)
				departments, err := repo.GetAllDepartment(ctx, arg)
				assert.Nil(t, err)
				assert.Equal(t, expectedDepartments, departments)
			})

			t.Run("Database Error", func(t *testing.T) {
				mockQuerier.EXPECT().GetAllDepartment(ctx, arg).Return(nil, errors.New("database error"))
				departments, err := repo.GetAllDepartment(ctx, arg)
				assert.Nil(t, departments)
				assert.IsType(t, &exceptions.Exception{}, err)
			})
		},
	)

	t.Run("GetCountAllDepartment", func(t *testing.T) {
		ctx := &gin.Context{}
		search := "HR"
		expectedCount := int64(1)

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountAllDepartment(ctx, search).Return(expectedCount, nil)
			count, err := repo.GetCountAllDepartment(ctx, sqlc.GetCountAllDepartmentParams{})
			assert.Nil(t, err)
			assert.Equal(t, expectedCount, count)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountAllDepartment(ctx, search).Return(int64(0), errors.New("database error"))
			count, err := repo.GetCountAllDepartment(ctx, sqlc.GetCountAllDepartmentParams{})
			assert.Equal(t, int64(0), count)
			assert.IsType(t, &exceptions.Exception{}, err)
		})
	})

	t.Run("GetAllDepartmentWithoutPagination", func(t *testing.T) {
		ctx := &gin.Context{}
		expectedDepartments := []sqlc.Department{}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllDepartmentWithoutPagination(ctx).Return(expectedDepartments, nil)
			departments, err := repo.GetAllDepartmentWithoutPagination(ctx)
			assert.Nil(t, err)
			assert.Equal(t, expectedDepartments, departments)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllDepartmentWithoutPagination(ctx).Return(nil, errors.New("database error"))
			departments, err := repo.GetAllDepartmentWithoutPagination(ctx)
			assert.Nil(t, departments)
			assert.IsType(t, &exceptions.Exception{}, err)
		})
	})

	t.Run("UpdateDepartment", func(t *testing.T) {
		ctx := &gin.Context{}
		arg := sqlc.UpdateDepartmentParams{
			ID:         1,
			Department: "",
			UpdatedAt:  time.Time{},
			CompanyID:  nil,
		}
		expectedDepartment := sqlc.Department{
			ID:         1,
			Department: "",
			Status:     0,
			CompanyID:  pgtype.Int8{},
			CreatedAt:  time.Time{},
			UpdatedAt:  time.Time{},
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().UpdateDepartment(ctx, arg).Return(expectedDepartment, nil)
			department, err := repo.UpdateDepartment(ctx, arg)
			assert.Nil(t, err)
			assert.Equal(t, &expectedDepartment, department)
		})

		t.Run("Not Found", func(t *testing.T) {
			mockQuerier.EXPECT().UpdateDepartment(ctx, arg).Return(sqlc.Department{}, pgx.ErrNoRows)
			department, err := repo.UpdateDepartment(ctx, arg)
			assert.Nil(t, department)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode), err)
		})
	})

	t.Run("DeleteDepartment", func(t *testing.T) {
		ctx := &gin.Context{}
		id := int64(1)

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().DeleteDepartment(ctx, id).Return(nil)
			err := repo.DeleteDepartment(ctx, sqlc.DeleteDepartmentParams{})
			assert.Nil(t, err)
		})

		t.Run("Not Found", func(t *testing.T) {
			mockQuerier.EXPECT().DeleteDepartment(ctx, id).Return(pgx.ErrNoRows)
			err := repo.DeleteDepartment(ctx, sqlc.DeleteDepartmentParams{})
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode), err)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().DeleteDepartment(ctx, id).Return(errors.New("database error"))
			err := repo.DeleteDepartment(ctx, sqlc.DeleteDepartmentParams{})
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode), err)
		})
	})
}
