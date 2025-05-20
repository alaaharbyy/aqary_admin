package db_test

import (
	"context"
	"errors"
	"testing"
	"time"

	mockdb "aqary_admin/internal/domain/sqlc/mock"
	"aqary_admin/internal/domain/sqlc/sqlc"
	db "aqary_admin/pkg/db/user"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/stretchr/testify/assert"
	"go.uber.org/mock/gomock"
)

func TestPendingUserRepository(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockQuerier := mockdb.NewMockStore(ctrl)
	repo := db.NewPendingRepository(mockQuerier)

	t.Run("GetAllCompanyPendingUser", func(t *testing.T) {
		ctx := context.Background()
		args := sqlc.GetAllCompanyPendingUserParams{Limit: 10, Offset: 0}
		expectedUsers := []sqlc.User{{ID: 1, Username: "user1"}, {ID: 2, Username: "user2"}}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllCompanyPendingUser(ctx, args).Return(expectedUsers, nil)
			users, err := repo.GetAllCompanyPendingUser(ctx, args)
			assert.Nil(t, err)
			assert.Equal(t, len(expectedUsers), len(users))
			for i, user := range users {
				assert.Equal(t, expectedUsers[i], *user)
			}
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetAllCompanyPendingUser(ctx, args).Return(nil, errors.New("something went wrong"))
			_, err := repo.GetAllCompanyPendingUser(ctx, args)
			// assert.Nil(t, xusers)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode), err)
		})
	})

	t.Run("GetCountAllPendingUser", func(t *testing.T) {
		ctx := context.Background()
		expectedCount := int64(10)

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountAllPendingUser(ctx).Return(expectedCount, nil)
			count, err := repo.GetCountAllPendingUser(ctx)
			assert.Nil(t, err)
			assert.Equal(t, &expectedCount, count)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountAllPendingUser(ctx).Return(int64(0), errors.New("database error"))
			count, err := repo.GetCountAllPendingUser(ctx)
			assert.Nil(t, count)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode), err)
		})
	})

	t.Run("GetPendingUser", func(t *testing.T) {
		ctx := context.Background()
		id := int64(1)
		expectedUser := sqlc.User{ID: id, Username: "user1"}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetPendingUser(ctx, id).Return(expectedUser, nil)
			user, err := repo.GetPendingUser(ctx, id)
			assert.Nil(t, err)
			assert.Equal(t, &expectedUser, user)
		})

		t.Run("Not Found", func(t *testing.T) {
			mockQuerier.EXPECT().GetPendingUser(ctx, id).Return(sqlc.User{}, pgx.ErrNoRows)
			_, err := repo.GetPendingUser(ctx, id)
			// assert.Nil(t, user)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode), err)
		})
	})

	t.Run("UpdateUserStatus", func(t *testing.T) {
		ctx := context.Background()
		args := sqlc.UpdateUserStatusParams{ID: 1, Status: 2}
		expectedUser := sqlc.User{ID: 1, Status: 2}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().UpdateUserStatus(ctx, args).Return(expectedUser, nil)
			user, err := repo.UpdateUserStatus(ctx, args)
			assert.Nil(t, err)
			assert.Equal(t, &expectedUser, user)
		})

		t.Run("Database Error", func(t *testing.T) {
			mockQuerier.EXPECT().UpdateUserStatus(ctx, args).Return(sqlc.User{}, errors.New("database error"))
			_, err := repo.UpdateUserStatus(ctx, args)
			// assert.Nil(t, user)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode), err)
		})
	})

	// t.Run("GetProfile", func(t *testing.T) {
	// 	ctx := &gin.Context{}
	// 	id := int64(1)
	// 	expectedProfile := sqlc.Profile{ID: id, FirstName: "John"}

	// 	t.Run("Success", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetProfile(ctx, id).Return(expectedProfile, nil)
	// 		profile, err := repo.GetProfile(ctx, id)
	// 		assert.Nil(t, err)
	// 		assert.Equal(t, expectedProfile, profile)
	// 	})

	// 	t.Run("Not Found", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetProfile(ctx, id).Return(sqlc.Profile{}, pgx.ErrNoRows)
	// 		profile, err := repo.GetProfile(ctx, id)
	// 		assert.Equal(t, sqlc.Profile{}, profile)
	// 		assert.IsType(t, &exceptions.Exception{}, err)
	// 		assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode), err)
	// 	})
	// })

	t.Run("GetACompanyByUserID", func(t *testing.T) {
		ctx := &gin.Context{}
		userID := int64(1)
		expectedCompany := sqlc.GetACompanyByUserIDRow{
			CompanyID:   0,
			UsersID:     userID,
			CompanyType: pgtype.Int8{},
			IsBranch:    pgtype.Bool{},
			IsVerified:  pgtype.Bool{},
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetACompanyByUserID(ctx, userID).Return(expectedCompany, nil)
			company, err := repo.GetACompanyByUserID(ctx, userID)
			assert.Nil(t, err)
			assert.Equal(t, expectedCompany, company)
		})

		t.Run("Not Found", func(t *testing.T) {
			mockQuerier.EXPECT().GetACompanyByUserID(ctx, userID).Return(sqlc.GetACompanyByUserIDRow{}, pgx.ErrNoRows)
			company, err := repo.GetACompanyByUserID(ctx, userID)
			assert.Equal(t, sqlc.GetACompanyByUserIDRow{}, company)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode), err)
		})
	})

	t.Run("GetDepartment", func(t *testing.T) {
		// ctx := &gin.Context{}
		// id := int32(1)
		// expectedDepartment := sqlc.Department{
		// 	ID:         int64(id),
		// 	Department: "",
		// 	Status:     0,
		// 	CreatedAt:  time.Time{},
		// 	UpdatedAt:  time.Time{},
		// }

		t.Run("Success", func(t *testing.T) {
			// mockQuerier.EXPECT().GetDepartment(ctx, id).Return(expectedDepartment, nil)
			// department, err := repo.GetDepartment(ctx, arg sqlc.GetDepartmentParams)
			// assert.Nil(t, err)
			// assert.Equal(t, expectedDepartment, department)
		})

		t.Run("Not Found", func(t *testing.T) {
			// mockQuerier.EXPECT().GetDepartment(ctx, id).Return(sqlc.Department{}, pgx.ErrNoRows)
			// department, err := repo.GetDepartment(ctx, id)
			// assert.Equal(t, sqlc.Department{}, department)
			// assert.IsType(t, &exceptions.Exception{}, err)
			// assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode), err)
		})
	})

	///////////////////////

	t.Run("GetRole", func(t *testing.T) {
		ctx := &gin.Context{}
		id := int64(1)
		expectedRole := sqlc.Role{
			ID:        id,
			Role:      "",
			CreatedAt: time.Time{},
			UpdatedAt: time.Time{},
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetRole(ctx, id).Return(expectedRole, nil)
			role, err := repo.GetRole(ctx, id)
			assert.Nil(t, err)
			assert.Equal(t, expectedRole, role)
		})

		t.Run("Not Found", func(t *testing.T) {
			mockQuerier.EXPECT().GetRole(ctx, id).Return(sqlc.Role{}, pgx.ErrNoRows)
			role, err := repo.GetRole(ctx, id)
			assert.Equal(t, sqlc.Role{}, role)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode), err)
		})
	})

	t.Run("GetAddress", func(t *testing.T) {
		ctx := &gin.Context{}
		id := int32(1)
		expectedAddress := sqlc.Address{
			ID:               int64(id),
			CountriesID:      pgtype.Int8{},
			StatesID:         pgtype.Int8{},
			CitiesID:         pgtype.Int8{},
			CommunitiesID:    pgtype.Int8{},
			SubCommunitiesID: pgtype.Int8{},
			LocationsID:      pgtype.Int8{},
			CreatedAt:        time.Time{},
			UpdatedAt:        time.Time{},
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetAddress(ctx, id).Return(expectedAddress, nil)
			address, err := repo.GetAddress(ctx, id)
			assert.Nil(t, err)
			assert.Equal(t, expectedAddress, address)
		})

		t.Run("Not Found", func(t *testing.T) {
			mockQuerier.EXPECT().GetAddress(ctx, id).Return(sqlc.Address{}, pgx.ErrNoRows)
			address, err := repo.GetAddress(ctx, id)
			assert.Equal(t, sqlc.Address{}, address)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode), err)
		})
	})

	t.Run("GetCountry", func(t *testing.T) {
		ctx := &gin.Context{}
		id := int32(1)
		expectedCountry := sqlc.Country{
			ID:          int64(id),
			Country:     "",
			Flag:        "",
			CreatedAt:   time.Time{},
			UpdatedAt:   time.Time{},
			Alpha2Code:  pgtype.Text{},
			Alpha3Code:  pgtype.Text{},
			CountryCode: pgtype.Int8{},
			Lat:         pgtype.Float8{},
			Lng:         pgtype.Float8{},
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountry(ctx, id).Return(expectedCountry, nil)
			country, err := repo.GetCountry(ctx, id)
			assert.Nil(t, err)
			assert.Equal(t, expectedCountry, country)
		})

		t.Run("Not Found", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountry(ctx, id).Return(sqlc.Country{}, pgx.ErrNoRows)
			country, err := repo.GetCountry(ctx, id)
			assert.Equal(t, sqlc.Country{}, country)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode), err)
		})
	})

	t.Run("GetState", func(t *testing.T) {
		ctx := &gin.Context{}
		id := int32(1)
		expectedState := sqlc.State{
			ID:          int64(id),
			State:       "",
			CountriesID: pgtype.Int8{},
			CreatedAt:   time.Time{},
			UpdatedAt:   time.Time{},
			Lat:         pgtype.Float8{},
			Lng:         pgtype.Float8{},
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetState(ctx, id).Return(expectedState, nil)
			state, err := repo.GetState(ctx, id)
			assert.Nil(t, err)
			assert.Equal(t, expectedState, state)
		})

		t.Run("Not Found", func(t *testing.T) {
			mockQuerier.EXPECT().GetState(ctx, id).Return(sqlc.State{}, pgx.ErrNoRows)
			state, err := repo.GetState(ctx, id)
			assert.Equal(t, sqlc.State{}, state)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode), err)
		})
	})

	t.Run("GetCity", func(t *testing.T) {
		ctx := &gin.Context{}
		id := int32(1)
		expectedCity := sqlc.City{
			ID:        int64(id),
			City:      "",
			StatesID:  pgtype.Int8{},
			CreatedAt: time.Time{},
			UpdatedAt: time.Time{},
			Lat:       pgtype.Float8{},
			Lng:       pgtype.Float8{},
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetCity(ctx, id).Return(expectedCity, nil)
			city, err := repo.GetCity(ctx, id)
			assert.Nil(t, err)
			assert.Equal(t, expectedCity, city)
		})

		t.Run("Not Found", func(t *testing.T) {
			mockQuerier.EXPECT().GetCity(ctx, id).Return(sqlc.City{}, pgx.ErrNoRows)
			city, err := repo.GetCity(ctx, id)
			assert.Equal(t, sqlc.City{}, city)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode), err)
		})
	})

	t.Run("GetCommunity", func(t *testing.T) {
		ctx := &gin.Context{}
		id := int32(1)
		expectedCommunity := sqlc.Community{
			ID:        int64(id),
			Community: "",
			CitiesID:  pgtype.Int8{},
			CreatedAt: time.Time{},
			UpdatedAt: time.Time{},
			Lat:       pgtype.Float8{},
			Lng:       pgtype.Float8{},
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetCommunity(ctx, id).Return(expectedCommunity, nil)
			community, err := repo.GetCommunity(ctx, id)
			assert.Nil(t, err)
			assert.Equal(t, expectedCommunity, community)
		})

		t.Run("Not Found", func(t *testing.T) {
			mockQuerier.EXPECT().GetCommunity(ctx, id).Return(sqlc.Community{}, pgx.ErrNoRows)
			community, err := repo.GetCommunity(ctx, id)
			assert.Equal(t, sqlc.Community{}, community)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode), err)
		})
	})

	t.Run("GetSubCommunity", func(t *testing.T) {
		ctx := &gin.Context{}
		id := int32(1)
		expectedSubCommunity := sqlc.SubCommunity{
			ID:            int64(id),
			SubCommunity:  "",
			CommunitiesID: pgtype.Int8{},
			CreatedAt:     time.Time{},
			UpdatedAt:     time.Time{},
			Lng:           pgtype.Float8{},
			Lat:           pgtype.Float8{},
		}

		t.Run("Success", func(t *testing.T) {
			mockQuerier.EXPECT().GetSubCommunity(ctx, id).Return(expectedSubCommunity, nil)
			subCommunity, err := repo.GetSubCommunity(ctx, id)
			assert.Nil(t, err)
			assert.Equal(t, expectedSubCommunity, subCommunity)
		})

		t.Run("Not Found", func(t *testing.T) {
			mockQuerier.EXPECT().GetSubCommunity(ctx, id).Return(sqlc.SubCommunity{}, pgx.ErrNoRows)
			subCommunity, err := repo.GetSubCommunity(ctx, id)
			assert.Equal(t, sqlc.SubCommunity{}, subCommunity)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode), err)
		})
	})

}
