package agent_usecase_test

import (
	domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	agent_usecase "aqary_admin/internal/usecases/user/agent"

	// mock_user_usecase "aqary_admin/internal/usecases/user/mock"
	db "aqary_admin/pkg/db/user/mock"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/assert/v2"
	gomock "go.uber.org/mock/gomock"

	"testing"
)

func TestAgentUseCase_SearchAllAgent(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockRepo := db.NewMockUserCompositeRepo(ctrl)
	useCase := agent_usecase.NewAgentUseCase(mockRepo)

	testCases := []struct {
		name           string
		input          domain.SearchAllAgentRequest
		mockBehavior   func(repo *db.MockUserCompositeRepo, search string)
		expectedResult []sqlc.SearchAllAgentRow
		expectedError  *exceptions.Exception
	}{
		{
			name: "Successful search",
			input: domain.SearchAllAgentRequest{
				Search: "John",
			},
			mockBehavior: func(repo *db.MockUserCompositeRepo, search string) {
				repo.EXPECT().
					SearchAllAgent(gomock.Any(), "%John%").
					Return([]sqlc.SearchAllAgentRow{{ID: 1, Username: "John Doe"}}, nil)
			},
			expectedResult: []sqlc.SearchAllAgentRow{{ID: 1, Username: "John Doe"}},
			expectedError:  nil,
		},
		{
			name: "Empty search",
			input: domain.SearchAllAgentRequest{
				Search: "",
			},
			mockBehavior: func(repo *db.MockUserCompositeRepo, search string) {
				repo.EXPECT().
					SearchAllAgent(gomock.Any(), "%%").
					Return([]sqlc.SearchAllAgentRow{{ID: 1, Username: "John Doe"}, {ID: 2, Username: "Jane Smith"}}, nil)
			},
			expectedResult: []sqlc.SearchAllAgentRow{{ID: 1, Username: "John Doe"}, {ID: 2, Username: "Jane Smith"}},
			expectedError:  nil,
		},
		{
			name: "Error case",
			input: domain.SearchAllAgentRequest{
				Search: "Error",
			},
			mockBehavior: func(repo *db.MockUserCompositeRepo, search string) {
				repo.EXPECT().
					SearchAllAgent(gomock.Any(), "%Error%").
					Return(nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))
			},
			expectedResult: nil,
			expectedError:  exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode),
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			tc.mockBehavior(mockRepo, tc.input.Search)

			ctx := &gin.Context{}
			result, err := useCase.SearchAllAgent(ctx, tc.input)

			assert.Equal(t, tc.expectedResult, result)
			assert.Equal(t, tc.expectedError, err)
		})
	}
}

func TestUtils_AddPercent(t *testing.T) {
	testCases := []struct {
		input    string
		expected string
	}{
		{"test", "%test%"},
		{"", "%%"},
		{"a b c", "%a b c%"},
	}

	for _, tc := range testCases {
		t.Run(tc.input, func(t *testing.T) {
			result := utils.AddPercent(tc.input)
			assert.Equal(t, tc.expected, result)
		})
	}
}
