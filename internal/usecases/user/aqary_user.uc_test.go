package usecase_test

import (
	"context"
	"testing"
	"time"

	domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	usecase "aqary_admin/internal/usecases/user"
	db "aqary_admin/pkg/db/user/mock"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/stretchr/testify/assert"
	gomock "go.uber.org/mock/gomock"
)

// timeMatcher is a custom matcher for time.Time values
type timeMatcher struct{}

func (m timeMatcher) Matches(x interface{}) bool {
	_, ok := x.(time.Time)
	return ok
}

func (m timeMatcher) String() string {
	return "is a time.Time"
}

// AnyTime returns a matcher for any time.Time value
func AnyTime() gomock.Matcher {
	return timeMatcher{}
}

// TestGetAllAqaryUserByCountry
func TestGetAllAqaryUserByCountry(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := usecase.NewAqaryUserUseCase(mockRepo, nil)

	t.Run("Successful retrieval", func(t *testing.T) {
		mockRepo.EXPECT().GetAqaryUser(gomock.Any(), int64(1)).Return(&sqlc.User{
			ID:       1,
			Username: "testuser",
			Password: "hashedpassword",
			Status:   1,
		}, nil)

		ctx, _ := gin.CreateTestContext(nil)
		result, err := uc.GetAqaryUser(ctx, 1)

		assert.Nil(t, err)
		assert.NotNil(t, result)
		assert.Equal(t, int64(1), result.ID)
		assert.Equal(t, "testuser", result.Username)
	})

	t.Run("User not found", func(t *testing.T) {
		mockRepo.EXPECT().GetAqaryUser(gomock.Any(), int64(999)).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))

		ctx, _ := gin.CreateTestContext(nil)
		_, err := uc.GetAqaryUser(ctx, 999)

		// assert.Nil(t, result)
		assert.NotNil(t, err)
		assert.Equal(t, exceptions.NoDataFoundErrorCode, err.ErrorCode)
	})

	t.Run("No users found", func(t *testing.T) {
		mockRepo.EXPECT().GetAllAqaryUsersByCountryId(gomock.Any(), sqlc.GetAllAqaryUsersByCountryIdParams{
			Limit:  10,
			Offset: 0,
			ID:     1,
		}).Return([]sqlc.GetAllAqaryUsersByCountryIdRow{}, nil)

		mockRepo.EXPECT().GetCountAllAqaryUserByCountry(gomock.Any(), int64(1)).Return(int64(0), nil)

		ctx, _ := gin.CreateTestContext(nil)
		result, count, err := uc.GetAllAqaryUserByCountry(ctx, domain.GetAllUserByCountryRequest{
			PageNo:   1,
			PageSize: 10,
			Country:  1,
		})

		assert.Nil(t, err)
		assert.Equal(t, 0, len(result))
		assert.Equal(t, int64(0), count)
	})

	t.Run("Error in GetCountAllAqaryUserByCountry", func(t *testing.T) {
		mockRepo.EXPECT().GetAllAqaryUsersByCountryId(gomock.Any(), gomock.Any()).Return([]sqlc.GetAllAqaryUsersByCountryIdRow{
			{ID: 1, Username: "user1", Email: "user1@example.com"},
		}, nil)

		mockRepo.EXPECT().GetProfile(gomock.Any(), gomock.Any()).Return(&sqlc.Profile{}, nil)
		mockRepo.EXPECT().GetDepartment(gomock.Any(), gomock.Any()).Return(sqlc.Department{}, nil)
		mockRepo.EXPECT().GetRole(gomock.Any(), gomock.Any()).Return(sqlc.Role{}, nil)
		mockRepo.EXPECT().GetAddress(gomock.Any(), gomock.Any()).Return(sqlc.Address{}, nil)
		mockRepo.EXPECT().GetCountry(gomock.Any(), gomock.Any()).Return(sqlc.Country{}, nil)
		mockRepo.EXPECT().GetState(gomock.Any(), gomock.Any()).Return(sqlc.State{}, nil)
		mockRepo.EXPECT().GetCity(gomock.Any(), gomock.Any()).Return(sqlc.City{}, nil)
		mockRepo.EXPECT().GetCommunity(gomock.Any(), gomock.Any()).Return(sqlc.Community{}, nil)
		mockRepo.EXPECT().GetSubCommunity(gomock.Any(), gomock.Any()).Return(sqlc.SubCommunity{}, nil)

		mockRepo.EXPECT().GetCountAllAqaryUserByCountry(gomock.Any(), int64(1)).Return(int64(0), exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))

		ctx, _ := gin.CreateTestContext(nil)
		_, _, err := uc.GetAllAqaryUserByCountry(ctx, domain.GetAllUserByCountryRequest{
			PageNo:   1,
			PageSize: 10,
			Country:  1,
		})

		assert.NotNil(t, err)
		assert.Equal(t, exceptions.SomethingWentWrongErrorCode, err.ErrorCode)
	})
}

// TestGetSingleAqaryUser
func TestGetSingleAqaryUser(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := usecase.NewAqaryUserUseCase(mockRepo, nil)

	t.Run("User not found", func(t *testing.T) {
		mockRepo.EXPECT().GetAqaryUser(gomock.Any(), int64(999)).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))

		ctx, _ := gin.CreateTestContext(nil)
		_, err := uc.GetSingleAqaryUser(ctx, 999, domain.GetSingleUserReq{})

		assert.NotNil(t, err)
		assert.Equal(t, exceptions.NoDataFoundErrorCode, err.ErrorCode)
	})

	t.Run("Successful retrieval", func(t *testing.T) {
		mockRepo.EXPECT().GetAqaryUser(gomock.Any(), int64(1)).Return(&sqlc.User{
			ID:         1,
			Username:   "testuser",
			Email:      "test@example.com",
			ProfilesID: 1,
			// PermissionsID: []int64{1, 2},
		}, nil)

		mockRepo.EXPECT().GetProfile(gomock.Any(), int64(1)).Return(&sqlc.Profile{
			FirstName: "Test",
			LastName:  "User",
			// PhoneNumber: "1234567890",
			AddressesID: 1,
		}, nil)

		mockRepo.EXPECT().GetDepartment(gomock.Any(), gomock.Any()).Return(sqlc.Department{
			ID:         1,
			Department: "TestDepartment",
		}, nil)

		mockRepo.EXPECT().GetRole(gomock.Any(), gomock.Any()).Return(sqlc.Role{
			ID:   1,
			Role: "TestRole",
		}, nil)

		mockRepo.EXPECT().GetAddress(gomock.Any(), int32(1)).Return(sqlc.Address{
			CountriesID:      pgtype.Int8{Int64: 1, Valid: true},
			StatesID:         pgtype.Int8{Int64: 1, Valid: true},
			CitiesID:         pgtype.Int8{Int64: 1, Valid: true},
			CommunitiesID:    pgtype.Int8{Int64: 1, Valid: true},
			SubCommunitiesID: pgtype.Int8{Int64: 1, Valid: true},
		}, nil)

		mockRepo.EXPECT().GetCountry(gomock.Any(), int32(1)).Return(sqlc.Country{
			ID:      1,
			Country: "TestCountry",
		}, nil)

		mockRepo.EXPECT().GetState(gomock.Any(), int32(1)).Return(sqlc.State{
			ID:    1,
			State: "TestState",
		}, nil)

		mockRepo.EXPECT().GetCity(gomock.Any(), int32(1)).Return(sqlc.City{
			ID:   1,
			City: "TestCity",
		}, nil)

		mockRepo.EXPECT().GetCommunity(gomock.Any(), gomock.Any()).Return(sqlc.Community{
			ID:        1,
			Community: "TestCommunity",
		}, nil)

		mockRepo.EXPECT().GetSubCommunity(gomock.Any(), gomock.Any()).Return(sqlc.SubCommunity{
			ID:           1,
			SubCommunity: "TestSubCommunity",
		}, nil)

		mockRepo.EXPECT().GetPermission(gomock.Any(), gomock.Any()).AnyTimes().Return(sqlc.Permission{
			ID:                  1,
			Title:               "TestPermission",
			SectionPermissionID: 1,
		}, nil)

		mockRepo.EXPECT().GetSectionPermission(gomock.Any(), gomock.Any()).AnyTimes().Return(sqlc.SectionPermission{
			ID:    1,
			Title: "TestSection",
		}, nil)

		mockRepo.EXPECT().GetPermissionByIdAndSectionPermissionId(gomock.Any(), gomock.Any()).AnyTimes().Return(sqlc.Permission{
			ID:    1,
			Title: "TestPermission",
		}, nil)

		ctx, _ := gin.CreateTestContext(nil)
		result, err := uc.GetSingleAqaryUser(ctx, 1, domain.GetSingleUserReq{})

		assert.Nil(t, err)
		assert.NotNil(t, result)
		assert.Equal(t, int64(1), result.ID)
		assert.Equal(t, "testuser", result.Username)
		assert.Equal(t, "Test", result.FirstName)
		assert.Equal(t, "User", result.LastName)
		assert.Equal(t, "TestCommunity", result.Community.Name)
		assert.Equal(t, "TestSubCommunity", result.SubCommunity.Name)
	})

}

// TestUpdateAqaryUser
func TestUpdateAqaryUser(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := usecase.NewAqaryUserUseCase(mockRepo, nil)

	t.Run("User not found", func(t *testing.T) {
		mockRepo.EXPECT().GetAqaryUser(gomock.Any(), int64(999)).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))

		ctx, _ := gin.CreateTestContext(nil)
		_, err := uc.UpdateAqaryUser(ctx, 999, domain.UpdateUserRequest{})

		assert.NotNil(t, err)
		assert.Equal(t, exceptions.NoDataFoundErrorCode, err.ErrorCode)
	})

	t.Run("Error in UpdateAddress", func(t *testing.T) {
		mockRepo.EXPECT().GetAqaryUser(gomock.Any(), int64(1)).Return(&sqlc.User{
			ID:         1,
			ProfilesID: 1,
		}, nil)

		mockRepo.EXPECT().GetProfile(gomock.Any(), int64(1)).Return(&sqlc.Profile{
			ID:          1,
			AddressesID: 1,
		}, nil)

		mockRepo.EXPECT().GetAddress(gomock.Any(), int32(1)).Return(sqlc.Address{
			ID: 1,
		}, nil)

		mockRepo.EXPECT().UpdateAddress(gomock.Any(), gomock.Any()).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))

		ctx, _ := gin.CreateTestContext(nil)
		_, err := uc.UpdateAqaryUser(ctx, 1, domain.UpdateUserRequest{})

		assert.NotNil(t, err)
		assert.Equal(t, exceptions.SomethingWentWrongErrorCode, err.ErrorCode)
	})

	t.Run("Successful update", func(t *testing.T) {
		mockRepo.EXPECT().GetAqaryUser(gomock.Any(), int64(1)).Return(&sqlc.User{
			ID:         1,
			Username:   "testuser",
			ProfilesID: 1,
		}, nil)

		mockRepo.EXPECT().GetProfile(gomock.Any(), int64(1)).Return(&sqlc.Profile{
			ID:          1,
			AddressesID: 1,
		}, nil)

		mockRepo.EXPECT().GetAddress(gomock.Any(), int32(1)).Return(sqlc.Address{
			ID: 1,
		}, nil)

		mockRepo.EXPECT().UpdateAddress(gomock.Any(), gomock.Any()).Return(&sqlc.Address{
			ID: 1,
		}, nil)

		mockRepo.EXPECT().UpdateProfile(gomock.Any(), gomock.Any()).Return(&sqlc.Profile{
			ID:        1,
			FirstName: "UpdatedFirst",
			LastName:  "UpdatedLast",
		}, nil)

		mockRepo.EXPECT().GetAllSubSectionByPermissionID(gomock.Any(), gomock.Any()).AnyTimes().Return([]sqlc.SubSection{}, nil)

		mockRepo.EXPECT().UpdateUser(gomock.Any(), gomock.Any()).Return(&sqlc.User{
			ID:       1,
			Username: "testuser",
			Email:    "updated@example.com",
		}, nil)

		mockRepo.EXPECT().GetDepartment(gomock.Any(), gomock.Any()).Return(sqlc.Department{
			ID:         1,
			Department: "UpdatedDepartment",
		}, nil)

		mockRepo.EXPECT().GetRole(gomock.Any(), gomock.Any()).Return(sqlc.Role{
			ID:   1,
			Role: "UpdatedRole",
		}, nil)

		mockRepo.EXPECT().GetCountry(gomock.Any(), gomock.Any()).Return(sqlc.Country{
			ID:      1,
			Country: "UpdatedCountry",
		}, nil)

		mockRepo.EXPECT().GetState(gomock.Any(), gomock.Any()).Return(sqlc.State{
			ID:    1,
			State: "UpdatedState",
		}, nil)

		mockRepo.EXPECT().GetCity(gomock.Any(), gomock.Any()).Return(sqlc.City{
			ID:   1,
			City: "UpdatedCity",
		}, nil)

		mockRepo.EXPECT().GetCommunity(gomock.Any(), gomock.Any()).Return(sqlc.Community{
			ID:        1,
			Community: "UpdatedCommunity",
		}, nil)

		mockRepo.EXPECT().GetSubCommunity(gomock.Any(), gomock.Any()).Return(sqlc.SubCommunity{
			ID:           1,
			SubCommunity: "UpdatedSubCommunity",
		}, nil)

		ctx, _ := gin.CreateTestContext(nil)
		result, err := uc.UpdateAqaryUser(ctx, 1, domain.UpdateUserRequest{
			FirstName: "UpdatedFirst",
			LastName:  "UpdatedLast",
			Phone:     "1234567890",
			Country:   1,
			State:     1,
			City:      1,
			Community: 1,
		})

		assert.Nil(t, err)
		assert.NotNil(t, result)
		assert.Equal(t, "UpdatedFirst", result.FirstName)
		assert.Equal(t, "UpdatedLast", result.LastName)
	})
}

// TestDeleteUser
func TestDeleteUser(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := usecase.NewAqaryUserUseCase(mockRepo, nil)

	t.Run("User not found", func(t *testing.T) {
		mockRepo.EXPECT().GetAqaryUser(gomock.Any(), int64(999)).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))

		ctx, _ := gin.CreateTestContext(nil)
		err := uc.DeleteUser(ctx, 999)

		assert.NotNil(t, err)
		assert.Equal(t, exceptions.NoDataFoundErrorCode, err.ErrorCode)
	})

	t.Run("Error in UpdateUserStatus", func(t *testing.T) {
		mockRepo.EXPECT().GetAqaryUser(gomock.Any(), int64(1)).Return(&sqlc.User{
			ID: 1,
		}, nil)

		mockRepo.EXPECT().UpdateUserStatus(gomock.Any(), gomock.Any()).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))

		ctx, _ := gin.CreateTestContext(nil)
		err := uc.DeleteUser(ctx, 1)

		assert.NotNil(t, err)
		assert.Equal(t, exceptions.SomethingWentWrongErrorCode, err.ErrorCode)
	})

	t.Run("Successful deletion", func(t *testing.T) {
		mockRepo.EXPECT().GetAqaryUser(gomock.Any(), int64(1)).Return(&sqlc.User{
			ID: 1,
		}, nil)

		mockRepo.EXPECT().UpdateUserStatus(gomock.Any(), gomock.Any()).DoAndReturn(
			func(_ context.Context, params sqlc.UpdateUserStatusParams) (*sqlc.User, error) {
				assert.Equal(t, int64(1), params.ID)
				assert.Equal(t, int64(6), params.Status)
				assert.WithinDuration(t, time.Now(), params.UpdatedAt, time.Second)
				return &sqlc.User{}, nil
			})

		ctx, _ := gin.CreateTestContext(nil)
		err := uc.DeleteUser(ctx, 1)

		assert.Nil(t, err)
	})
}

// TestRestoreUser
func TestRestoreUser(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := usecase.NewAqaryUserUseCase(mockRepo, nil)

	t.Run("User not found", func(t *testing.T) {
		mockRepo.EXPECT().GetAqaryDeletedUser(gomock.Any(), int64(999)).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode))

		ctx, _ := gin.CreateTestContext(nil)
		err := uc.RestoreUser(ctx, 999)

		assert.NotNil(t, err)
		assert.Equal(t, exceptions.NoDataFoundErrorCode, err.ErrorCode)
	})

	t.Run("Error in UpdateUserStatus", func(t *testing.T) {
		mockRepo.EXPECT().GetAqaryDeletedUser(gomock.Any(), int64(1)).Return(&sqlc.User{
			ID: 1,
		}, nil)

		mockRepo.EXPECT().UpdateUserStatus(gomock.Any(), gomock.Any()).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))

		ctx, _ := gin.CreateTestContext(nil)
		err := uc.RestoreUser(ctx, 1)

		assert.NotNil(t, err)
		assert.Equal(t, exceptions.SomethingWentWrongErrorCode, err.ErrorCode)
	})

	t.Run("Successful restoration", func(t *testing.T) {
		mockRepo.EXPECT().GetAqaryDeletedUser(gomock.Any(), int64(1)).Return(&sqlc.User{
			ID: 1,
		}, nil)

		mockRepo.EXPECT().UpdateUserStatus(gomock.Any(), gomock.Any()).DoAndReturn(
			func(_ context.Context, params sqlc.UpdateUserStatusParams) (*sqlc.User, error) {
				assert.Equal(t, int64(1), params.ID)
				assert.Equal(t, int64(1), params.Status)
				assert.WithinDuration(t, time.Now(), params.UpdatedAt, time.Second)
				return &sqlc.User{}, nil
			})

		ctx, _ := gin.CreateTestContext(nil)
		err := uc.RestoreUser(ctx, 1)

		assert.Nil(t, err)
	})
}

// TestGetAllDeletedAqaryUser
func TestGetAllDeletedAqaryUser(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := usecase.NewAqaryUserUseCase(mockRepo, nil)

	t.Run("No deleted users found", func(t *testing.T) {
		mockRepo.EXPECT().GetAllAqaryDeletedUser(gomock.Any(), gomock.Any()).Return([]sqlc.GetAllAqaryDeletedUserRow{}, nil)
		mockRepo.EXPECT().GetCountAllAqaryDeletedUser(gomock.Any(), gomock.Any()).Return(int64(0), nil)

		ctx, _ := gin.CreateTestContext(nil)
		result, count, err := uc.GetAllDeletedAqaryUser(ctx, domain.AllDeletedUserRequests{
			PageNo:   1,
			PageSize: 10,
			Search:   "",
		})

		assert.Nil(t, err)
		assert.Equal(t, 0, len(result))
		assert.Equal(t, int64(0), count)
	})

	t.Run("Error in GetCountAllAqaryDeletedUser", func(t *testing.T) {
		mockRepo.EXPECT().GetAllAqaryDeletedUser(gomock.Any(), gomock.Any()).Return([]sqlc.GetAllAqaryDeletedUserRow{
			{ID: 1, Username: "deleteduser1"},
		}, nil)

		mockRepo.EXPECT().GetProfile(gomock.Any(), gomock.Any()).Return(&sqlc.Profile{}, nil)
		mockRepo.EXPECT().GetRole(gomock.Any(), gomock.Any()).Return(sqlc.Role{}, nil)
		mockRepo.EXPECT().GetDepartment(gomock.Any(), gomock.Any()).Return(sqlc.Department{}, nil)

		mockRepo.EXPECT().GetCountAllAqaryDeletedUser(gomock.Any(), gomock.Any()).Return(int64(0), exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))

		ctx, _ := gin.CreateTestContext(nil)
		_, _, err := uc.GetAllDeletedAqaryUser(ctx, domain.AllDeletedUserRequests{
			PageNo:   1,
			PageSize: 10,
			Search:   "",
		})

		assert.NotNil(t, err)
		assert.Equal(t, exceptions.SomethingWentWrongErrorCode, err.ErrorCode)
	})

	t.Run("Successful retrieval", func(t *testing.T) {
		mockRepo.EXPECT().GetAllAqaryDeletedUser(gomock.Any(), sqlc.GetAllAqaryDeletedUserParams{
			Limit:  10,
			Offset: 0,
			Search: "%test%",
		}).Return([]sqlc.GetAllAqaryDeletedUserRow{
			{ID: 1, Username: "user1", Email: "user1@example.com", ProfilesID: 1},
			{ID: 2, Username: "user2", Email: "user2@example.com", ProfilesID: 2},
		}, nil)

		mockRepo.EXPECT().GetProfile(gomock.Any(), gomock.Any()).AnyTimes().Return(&sqlc.Profile{
			ID:        1,
			FirstName: "Test",
			LastName:  "User",
		}, nil)

		mockRepo.EXPECT().GetRole(gomock.Any(), gomock.Any()).AnyTimes().Return(sqlc.Role{
			ID:   1,
			Role: "TestRole",
		}, nil)

		mockRepo.EXPECT().GetDepartment(gomock.Any(), gomock.Any()).AnyTimes().Return(sqlc.Department{
			ID:         1,
			Department: "TestDepartment",
		}, nil)

		mockRepo.EXPECT().GetCountAllAqaryDeletedUser(gomock.Any(), "%test%").Return(int64(2), nil)

		ctx, _ := gin.CreateTestContext(nil)
		result, count, err := uc.GetAllDeletedAqaryUser(ctx, domain.AllDeletedUserRequests{
			PageNo:   1,
			PageSize: 10,
			Search:   "test",
		})

		assert.Nil(t, err)
		assert.Equal(t, 2, len(result))
		assert.Equal(t, int64(2), count)
		assert.Equal(t, "user1", result[0].Name)
		assert.Equal(t, "user2", result[1].Name)
	})
}

// TestGetAllDeletedAqaryUserWithoutPagination
func TestGetAllDeletedAqaryUserWithoutPagination(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	uc := usecase.NewAqaryUserUseCase(mockRepo, nil)

	t.Run("No deleted users found", func(t *testing.T) {
		mockRepo.EXPECT().GetAllAqaryDeletedUserWithoutPagination(gomock.Any()).Return([]sqlc.User{}, nil)
		mockRepo.EXPECT().GetCountAllAqaryDeletedUser(gomock.Any(), "%%").Return(int64(0), nil)

		ctx, _ := gin.CreateTestContext(nil)
		result, count, err := uc.GetAllDeletedAqaryUserWithoutPagination(ctx)

		assert.Nil(t, err)
		assert.Equal(t, 0, len(result))
		assert.Equal(t, int64(0), count)
	})

	t.Run("Error in GetAllAqaryDeletedUserWithoutPagination", func(t *testing.T) {
		mockRepo.EXPECT().GetAllAqaryDeletedUserWithoutPagination(gomock.Any()).Return(nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))

		ctx, _ := gin.CreateTestContext(nil)
		_, _, err := uc.GetAllDeletedAqaryUserWithoutPagination(ctx)

		assert.NotNil(t, err)
		assert.Equal(t, exceptions.SomethingWentWrongErrorCode, err.ErrorCode)
	})

	t.Run("Successful retrieval", func(t *testing.T) {
		mockRepo.EXPECT().GetAllAqaryDeletedUserWithoutPagination(gomock.Any()).Return([]sqlc.User{
			{ID: 1, Username: "user1", Email: "user1@example.com", ProfilesID: 1},
			{ID: 2, Username: "user2", Email: "user2@example.com", ProfilesID: 2},
		}, nil)

		mockRepo.EXPECT().GetProfile(gomock.Any(), gomock.Any()).AnyTimes().Return(&sqlc.Profile{
			ID:        1,
			FirstName: "Test",
			LastName:  "User",
		}, nil)

		mockRepo.EXPECT().GetRole(gomock.Any(), gomock.Any()).AnyTimes().Return(sqlc.Role{
			ID:   1,
			Role: "TestRole",
		}, nil)

		mockRepo.EXPECT().GetDepartment(gomock.Any(), gomock.Any()).AnyTimes().Return(sqlc.Department{
			ID:         1,
			Department: "TestDepartment",
		}, nil)

		mockRepo.EXPECT().GetCountAllAqaryDeletedUser(gomock.Any(), "%%").Return(int64(2), nil)

		ctx, _ := gin.CreateTestContext(nil)
		result, count, err := uc.GetAllDeletedAqaryUserWithoutPagination(ctx)

		assert.Nil(t, err)
		assert.Equal(t, 2, len(result))
		assert.Equal(t, int64(2), count)
		assert.Equal(t, "user1", result[0].Name)
		assert.Equal(t, "user2", result[1].Name)
	})
}
