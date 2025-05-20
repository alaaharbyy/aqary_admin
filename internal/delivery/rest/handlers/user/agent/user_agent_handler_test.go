package agent_handler_test

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	agent_handler "aqary_admin/internal/delivery/rest/handlers/user/agent"
	domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	mock_user_usecase "aqary_admin/internal/usecases/user/mock"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"

	"go.uber.org/mock/gomock"
)

// only test
type ApiResponse struct {
	Error interface{}              `json:"error"`
	Data  []sqlc.SearchAllAgentRow `json:"data"`
}

func TestUserAgentHandler_SearchAllAgent(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockUserUseCase := mock_user_usecase.NewMockUserCompositeUseCase(ctrl)
	handler := agent_handler.NewAgentHandler(mockUserUseCase)
	gin.SetMode(gin.TestMode)

	tests := []struct {
		name               string
		setupRequest       func() *http.Request
		mockBehavior       func()
		expectedStatusCode int
		checkResponse      func(*testing.T, ApiResponse)
	}{
		{
			name: "Successful search",
			setupRequest: func() *http.Request {
				req, _ := http.NewRequest("GET", "/api/agents/search?search=test", nil)
				return req
			},
			mockBehavior: func() {
				mockUserUseCase.EXPECT().
					SearchAllAgent(gomock.Any(), domain.SearchAllAgentRequest{Search: "test"}).
					Return([]sqlc.SearchAllAgentRow{
						{
							ID:       1,
							Username: "Test",
							// PhoneNumber: "0000",
						},
					}, nil)
			},
			expectedStatusCode: http.StatusOK,
			checkResponse: func(t *testing.T, response ApiResponse) {
				assert.Nil(t, response.Error)
				assert.Len(t, response.Data, 1)
				assert.Equal(t, int64(1), response.Data[0].ID)
				assert.Equal(t, "Test", response.Data[0].Username)
				assert.Equal(t, "0000", response.Data[0].PhoneNumber)
			},
		},
		{
			name: "Empty search result",
			setupRequest: func() *http.Request {
				req, _ := http.NewRequest("GET", "/api/agents/search?search=nonexistent", nil)
				return req
			},
			mockBehavior: func() {
				mockUserUseCase.EXPECT().
					SearchAllAgent(gomock.Any(), domain.SearchAllAgentRequest{Search: "nonexistent"}).
					Return([]sqlc.SearchAllAgentRow{}, nil)
			},
			expectedStatusCode: http.StatusOK,
			checkResponse: func(t *testing.T, response ApiResponse) {
				assert.Nil(t, response.Error)
				assert.Empty(t, response.Data)
			},
		},
		{
			name: "Use case error",
			setupRequest: func() *http.Request {
				req, _ := http.NewRequest("GET", "/api/agents/search?search=error", nil)
				return req
			},
			mockBehavior: func() {
				mockUserUseCase.EXPECT().
					SearchAllAgent(gomock.Any(), domain.SearchAllAgentRequest{Search: "error"}).
					Return(nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode))
			},
			expectedStatusCode: http.StatusInternalServerError,
			checkResponse: func(t *testing.T, response ApiResponse) {
				assert.NotNil(t, response.Error)
				assert.Nil(t, response.Data)
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			router := gin.New()
			router.GET("/api/agents/search", handler.SearchAllAgent)

			tt.mockBehavior()

			w := httptest.NewRecorder()
			router.ServeHTTP(w, tt.setupRequest())

			assert.Equal(t, tt.expectedStatusCode, w.Code)

			var response ApiResponse
			json.Unmarshal(w.Body.Bytes(), &response)
			// assert.NoError(t, err)

			tt.checkResponse(t, response)
		})
	}

	t.Run("Binding Error", func(t *testing.T) {
		req := httptest.NewRequest("GET", "/api/agents", nil)
		w := httptest.NewRecorder()
		c, _ := gin.CreateTestContext(w)
		c.Request = req

		handler.SearchAllAgent(c)

		assert.Equal(t, http.StatusBadRequest, w.Code)
		var response map[string]interface{}
		json.Unmarshal(w.Body.Bytes(), &response)
		assert.NotNil(t, response["error"])
	})
}

func TestNewAgentHandler(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockUserUseCase := mock_user_usecase.NewMockUserCompositeUseCase(ctrl)
	handler := agent_handler.NewAgentHandler(mockUserUseCase)

	assert.NotNil(t, handler, "NewAgentHandler should return a non-nil handler")
	assert.Equal(t, mockUserUseCase, handler.GetUserUseCase(), "Handler should have the correct use case")
}

func TestUserAgentHandler_RegisterAuthRoutes(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockUserUseCase := mock_user_usecase.NewMockUserCompositeUseCase(ctrl)
	handler := agent_handler.NewAgentHandler(mockUserUseCase)

	// Create a new gin engine
	gin.SetMode(gin.TestMode)
	router := gin.New()

	// Create a new router group
	authGroup := router.Group("/auth")

	// Call the RegisterAuthRoutes method
	handler.RegisterAuthRoutes(authGroup)

	// Test the registered route
	mockUserUseCase.EXPECT().SearchAllAgent(gomock.Any(), gomock.Any()).Return(nil, nil)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/auth/getAllAgents?search='test'", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code, "Status code should be 200 OK")

	// Test a non-existent route
	w = httptest.NewRecorder()
	req, _ = http.NewRequest("GET", "/auth/nonexistentRoute", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code, "Status code should be 404 Not Found for non-existent route")
}

func TestUserAgentHandler_RegisterNonAuthRoutes(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	mockUserUseCase := mock_user_usecase.NewMockUserCompositeUseCase(ctrl)
	handler := agent_handler.NewAgentHandler(mockUserUseCase)

	// Create a new gin engine
	gin.SetMode(gin.TestMode)
	router := gin.New()

	// Create a new router group
	nonAuthGroup := router.Group("/non-auth")

	// Call the RegisterNonAuthRoutes method
	handler.RegisterNonAuthRoutes(nonAuthGroup)

	// Since RegisterNonAuthRoutes is empty, we're just ensuring it doesn't panic
	assert.NotPanics(t, func() {
		handler.RegisterNonAuthRoutes(nonAuthGroup)
	}, "RegisterNonAuthRoutes should not panic")
}
