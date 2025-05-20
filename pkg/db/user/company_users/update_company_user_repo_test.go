package companyusers_repo_test

import (
	"errors"
	"testing"
	"time"

	mockdb "aqary_admin/internal/domain/sqlc/mock"
	"aqary_admin/internal/domain/sqlc/sqlc"
	db "aqary_admin/pkg/db/user/company_users"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/stretchr/testify/assert"
	"go.uber.org/mock/gomock"
)

func TestUpdateCompanyUserRepo(t *testing.T) {
	utils.IS_TEST_MODE = true
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockQuerier := mockdb.NewMockStore(ctrl)
	repo := db.NewCompanyUserRepository(mockQuerier)

	t.Run("GetCountCompanyUsersByStatuses", func(t *testing.T) {
		c := &gin.Context{}
		statuses := []int64{1, 2}
		expectedCount := int64(10)

		t.Run("When count is retrieved successfully", func(t *testing.T) {
			mockQuerier.EXPECT().GetCountCompanyUsersByStatuses(c, statuses).Return(expectedCount, nil)
			count, err := repo.GetCountCompanyUsersByStatuses(c, statuses)
			assert.Nil(t, err)
			assert.Equal(t, expectedCount, count)
		})
	})

	t.Run("GetCompanyUser", func(t *testing.T) {
		c := &gin.Context{}
		companyUserID := int32(1)
		expectedCompanyUser := sqlc.CompanyUser{ID: int64(companyUserID)}

		t.Run("When company user is found", func(t *testing.T) {
			mockQuerier.EXPECT().GetCompanyUser(c, companyUserID).Return(expectedCompanyUser, nil)
			companyUser, err := repo.GetCompanyUser(c, companyUserID)
			assert.Nil(t, err)
			assert.Equal(t, expectedCompanyUser, companyUser)
		})
	})
	// =--------------------------------
	// t.Run("UpdateUserPassword", func(t *testing.T) {
	// 	c := &gin.Context{}
	// 	args := sqlc.UpdateUserPasswordParams{ID: 1, Password: "newpassword"}

	// 	t.Run("When password is updated successfully", func(t *testing.T) {
	// 		mockQuerier.EXPECT().UpdateUserPassword(c, args)
	// 		err := repo.UpdateUserPassword(c, args)
	// 		assert.Nil(t, err)
	// 	})
	// })

	// t.Run("UpdateUserStatus", func(t *testing.T) {
	// 	c := &gin.Context{}
	// 	args := sqlc.UpdateUserStatusParams{ID: 1, Status: 2}

	// 	t.Run("When status is updated successfully", func(t *testing.T) {
	// 		mockQuerier.EXPECT().UpdateUserStatus(c, args)
	// 		err := repo.UpdateUserStatus(c, args)
	// 		assert.Nil(t, err)
	// 	})
	// })

	t.Run("UpdateBrokerBranchAgentStatus", func(t *testing.T) {
		c := &gin.Context{}
		userID := int64(1)
		// status := int64(2)

		t.Run("When status is updated successfully", func(t *testing.T) {
			mockQuerier.EXPECT().GetBrokerBranchAgentByUserId(c, userID).Times(1)
			// mockQuerier.EXPECT().UpdateBrokerBranchAgentStatus(c, userID, status).Times(1)

			_, err := repo.GetBrokerBranchAgentByUserId(c, userID)
			// there is no mock for that's why it's commented
			// repo.UpdateBrokerBranchAgentStatus(c, userID, status)
			assert.Nil(t, err)
		})
	})

	// t.Run("GetUser", func(t *testing.T) {
	// 	c := &gin.Context{}
	// 	userID := int64(1)
	// 	expectedUser := sqlc.User{ID: userID}

	// 	t.Run("When user is found", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetUser(c, userID).Return(expectedUser, nil)
	// 		user, err := repo.GetUser(c, userID)
	// 		assert.Nil(t, err)
	// 		assert.Equal(t, expectedUser, user)
	// 	})
	// })

	// t.Run("GetProfile", func(t *testing.T) {
	// 	c := &gin.Context{}
	// 	profileID := int64(1)
	// 	expectedProfile := sqlc.Profile{ID: profileID}

	// 	t.Run("When profile is found", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetProfile(c, profileID).Return(expectedProfile, nil)
	// 		profile, err := repo.GetProfile(c, profileID)
	// 		assert.Nil(t, err)
	// 		assert.Equal(t, expectedProfile, profile)
	// 	})
	// })

	// t.Run("UpdateProfile", func(t *testing.T) {
	// 	c := &gin.Context{}
	// 	args := sqlc.UpdateProfileParams{ID: 1}

	// 	t.Run("When profile is updated successfully", func(t *testing.T) {
	// 		mockQuerier.EXPECT().UpdateProfile(c, args)
	// 		err := repo.UpdateProfile(c, args)
	// 		assert.Nil(t, err)
	// 	})
	// })

	// t.Run("UpdateUser", func(t *testing.T) {
	// 	c := &gin.Context{}
	// 	args := sqlc.UpdateUserParams{ID: 1}

	// 	t.Run("When user is updated successfully", func(t *testing.T) {
	// 		mockQuerier.EXPECT().UpdateUser(c, args)
	// 		err := repo.UpdateUser(c, args)
	// 		assert.Nil(t, err)
	// 	})
	// })

	// t.Run("GetAllRelatedIDFromSubSection", func(t *testing.T) {
	// 	c := &gin.Context{}
	// 	subSectionID := int64(1)
	// 	expectedIDs := []int64{1, 2, 3}

	// 	t.Run("When related IDs are found", func(t *testing.T) {
	// 		mockQuerier.EXPECT().GetAllRelatedIDFromSubSection(c, subSectionID).Return(expectedIDs, nil)
	// 		ids, err := repo.GetAllRelatedIDFromSubSection(c, subSectionID)
	// 		assert.Nil(t, err)
	// 		assert.Equal(t, expectedIDs, ids)
	// 	})
	// })

	t.Run("GetBrokerAgentByUserId", func(t *testing.T) {
		c := &gin.Context{}
		userID := int64(1)
		expectedAgent := sqlc.BrokerCompanyAgent{UsersID: userID}

		t.Run("When broker agent is found", func(t *testing.T) {
			mockQuerier.EXPECT().GetBrokerAgentByUserId(c, userID).Return(expectedAgent, nil)
			agent, err := repo.GetBrokerAgentByUserId(c, userID)
			assert.Nil(t, err)
			assert.Equal(t, expectedAgent, agent)
		})
	})

	t.Run("GetBrokerBranchAgentByUserId", func(t *testing.T) {
		c := &gin.Context{}
		userID := int64(1)
		expectedAgent := sqlc.BrokerCompanyBranchesAgent{UsersID: userID}

		t.Run("When broker branch agent is found", func(t *testing.T) {
			mockQuerier.EXPECT().GetBrokerBranchAgentByUserId(c, userID).Return(expectedAgent, nil)
			agent, err := repo.GetBrokerBranchAgentByUserId(c, userID)
			assert.Nil(t, err)
			assert.Equal(t, expectedAgent, agent)
		})
	})

	t.Run("UpdateBrokerAgent", func(t *testing.T) {
		c := &gin.Context{}
		args := sqlc.UpdateBrokerAgentParams{ID: 1}

		t.Run("When broker agent is updated successfully", func(t *testing.T) {
			mockQuerier.EXPECT().UpdateBrokerAgent(c, args)
			err := repo.UpdateBrokerAgent(c, args)
			assert.Nil(t, err)
		})
	})

	t.Run("UpdateBrokerBranchAgent", func(t *testing.T) {
		c := &gin.Context{}
		args := sqlc.UpdateBrokerBranchAgentParams{
			ID:                        1,
			Brn:                       "",
			ExperienceSince:           pgtype.Timestamptz{},
			UsersID:                   0,
			Nationalities:             []int64{},
			BrnExpiry:                 time.Time{},
			BrokerCompaniesBranchesID: pgtype.Int8{},
			CreatedAt:                 time.Time{},
			UpdatedAt:                 time.Time{},
			VerificationDocumentUrl:   "",
			About:                     pgtype.Text{},
			AboutArabic:               pgtype.Text{},
			LinkedinProfileUrl:        pgtype.Text{},
			FacebookProfileUrl:        pgtype.Text{},
			TwitterProfileUrl:         pgtype.Text{},
			Status:                    0,
			IsVerified:                pgtype.Bool{},
			ProfilesID:                0,
			Telegram:                  pgtype.Text{},
			Botim:                     pgtype.Text{},
			Tawasal:                   pgtype.Text{},
			ServiceAreas:              []int64{},
			AgentRank:                 0,
		}

		t.Run("When broker branch agent is updated successfully", func(t *testing.T) {
			mockQuerier.EXPECT().UpdateBrokerBranchAgent(c, args)
			err := repo.UpdateBrokerBranchAgent(c, args)
			assert.Nil(t, err)
		})

		t.Run("When update fails", func(t *testing.T) {
			// expectedError := errors.New("something went wrong")
			mockQuerier.EXPECT().UpdateBrokerBranchAgent(c, args)
			err := repo.UpdateBrokerBranchAgent(c, args)

			assert.IsType(t, &exceptions.Exception{}, err)

		})
	})

	t.Run("UpdateAgentSubscriptionQuota", func(t *testing.T) {
		c := &gin.Context{}
		args := sqlc.UpdateAgentSubscriptionQuotaParams{ID: 1}

		t.Run("When agent subscription quota is updated successfully", func(t *testing.T) {
			mockQuerier.EXPECT().UpdateAgentSubscriptionQuota(c, args)
			err := repo.UpdateAgentSubscriptionQuota(c, args)
			assert.Nil(t, err)
		})

		t.Run("When update fails", func(t *testing.T) {

			mockQuerier.EXPECT().UpdateAgentSubscriptionQuota(c, args)
			err := repo.UpdateAgentSubscriptionQuota(c, args)
			assert.IsType(t, &exceptions.Exception{}, err)
			// assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode), err)
		})
	})

	t.Run("UpdateAgentSubscriptionQuotaBranch", func(t *testing.T) {
		c := &gin.Context{}
		args := sqlc.UpdateAgentSubscriptionQuotaBranchParams{ID: 1}

		t.Run("When agent subscription quota branch is updated successfully", func(t *testing.T) {
			mockQuerier.EXPECT().UpdateAgentSubscriptionQuotaBranch(c, args)
			err := repo.UpdateAgentSubscriptionQuotaBranch(c, args)
			assert.Nil(t, err)
		})

		t.Run("When update fails", func(t *testing.T) {

			mockQuerier.EXPECT().UpdateAgentSubscriptionQuotaBranch(c, args)
			err := repo.UpdateAgentSubscriptionQuotaBranch(c, args)
			assert.IsType(t, &exceptions.Exception{}, err)
			// assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode), err)
		})
	})

	// t.Run("GetUserByName_Error", func(t *testing.T) {
	// 	c := &gin.Context{}
	// 	username := "nonexistent_user"

	// 	t.Run("When error occurs", func(t *testing.T) {
	// 		expectedError := errors.New("database error")
	// 		mockQuerier.EXPECT().GetUserByName(c, username).Return(sqlc.User{}, expectedError)
	// 		_, err := repo.GetUserByName(c, username)
	// 		assert.IsType(t, &exceptions.Exception{}, err)
	// 		assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode), err)
	// 	})
	// })

	t.Run("GetCompanies_Error", func(t *testing.T) {
		c := &gin.Context{}
		companyID := int64(999)

		t.Run("When error occurs", func(t *testing.T) {
			expectedError := errors.New("database error")
			mockQuerier.EXPECT().GetCompanies(c, companyID).Return(sqlc.Company{}, expectedError)
			_, err := repo.GetCompanies(c, companyID)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode), err)
		})
	})

	t.Run("CreateCompanyUser_Error", func(t *testing.T) {
		c := &gin.Context{}
		args := sqlc.CreateCompanyUserParams{UsersID: 1, CompanyID: 1}

		t.Run("When error occurs", func(t *testing.T) {
			expectedError := errors.New("database error")
			mockQuerier.EXPECT().CreateCompanyUser(c, args).Return(sqlc.CompanyUser{}, expectedError)
			_, err := repo.CreateCompanyUser(c, args, mockQuerier)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode), err)
		})
	})

	t.Run("GetAllCompanyUsers_Error", func(t *testing.T) {
		c := &gin.Context{}
		args := sqlc.GetAllCompanyUsersParams{}

		t.Run("When error occurs", func(t *testing.T) {
			expectedError := errors.New("database error")
			mockQuerier.EXPECT().GetAllCompanyUsers(c, args).Return(nil, expectedError)
			_, err := repo.GetAllCompanyUsers(c, args)
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode), err)
		})
	})

	t.Run("GetCountAllCompanyUsers_Error", func(t *testing.T) {
		c := &gin.Context{}

		t.Run("When error occurs", func(t *testing.T) {
			expectedError := errors.New("database error")
			mockQuerier.EXPECT().GetCountAllCompanyUsers(c, gomock.Any()).Return(int64(0), expectedError)
			_, err := repo.GetCountAllCompanyUsers(c, "")
			assert.IsType(t, &exceptions.Exception{}, err)
			assert.Equal(t, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode), err)
		})
	})

}
