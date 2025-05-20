package agent_repo_repo_test

import (
	"errors"
	"net/http/httptest"
	"testing"

	mockdb "aqary_admin/internal/domain/sqlc/mock"
	"aqary_admin/internal/domain/sqlc/sqlc"
	db "aqary_admin/pkg/db/user/agent"
	"aqary_admin/pkg/utils/exceptions"

	// "github.com/golang/mock/gomock"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"go.uber.org/mock/gomock"
)

func TestAgentRepository_SearchAllAgent(t *testing.T) {

	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockQuerier := mockdb.NewMockStore(ctrl)
	repo := db.NewUserAgentRepository(mockQuerier)

	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)

	search := "agent"

	t.Run("Successful search", func(t *testing.T) {
		expectedAgents := []sqlc.SearchAllAgentRow{
			{ID: 1, Username: "Agent 1"},
			{ID: 2, Username: "Agent 2"},
		}

		mockQuerier.EXPECT().
			SearchAllAgent(gomock.Any(), search).
			Return(expectedAgents, nil)

		agents, err := repo.SearchAllAgent(c, search)

		assert.Nil(t, err)
		assert.Equal(t, expectedAgents, agents)

		// assert.Equal(t, expectedAgents, agents)
	})

	t.Run("Database error", func(t *testing.T) {
		mockQuerier.EXPECT().
			SearchAllAgent(gomock.Any(), search).
			Return(nil, errors.New("database error"))

		agents, err := repo.SearchAllAgent(c, search)

		assert.Nil(t, agents)
		assert.IsType(t, &exceptions.Exception{}, err)
		// assert.Equal(t, exceptions.SomethingWentWrongErrorCode, err)
	})

	t.Run("Empty result", func(t *testing.T) {
		mockQuerier.EXPECT().
			SearchAllAgent(gomock.Any(), search).
			Return([]sqlc.SearchAllAgentRow{}, nil)

		agents, err := repo.SearchAllAgent(c, search)

		// assert.NoError(t, err)
		assert.Nil(t, err)
		assert.Empty(t, agents)
	})
}
