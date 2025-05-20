package auth_handler

import (
	"aqary_admin/internal/delivery/websocket"
	usecase "aqary_admin/internal/usecases/user"

	"github.com/gin-gonic/gin"
	"github.com/wagslane/go-rabbitmq"
)

type AuthHandler struct {
	userUseCase  usecase.UserCompositeUseCase
	hub          *websocket.Hub
	rabbitClient *rabbitmq.Conn
}

func NewAuthHandler(userUseCase usecase.UserCompositeUseCase, hub *websocket.Hub, conn *rabbitmq.Conn) *AuthHandler {
	return &AuthHandler{
		userUseCase:  userUseCase,
		hub:          hub,
		rabbitClient: conn,
	}
}

// RegisterNonAuthRoutes implements user_handler.Handler.
func (h *AuthHandler) RegisterNonAuthRoutes(r *gin.RouterGroup) {
	r.POST("/register", h.RegisterHandler)
	r.POST("/dashboardLogin", h.DashboardLogin)
	r.POST("/forgotPassword", h.ForgotPassword)
	r.POST("/verifyOTP", h.VerifyOTP)
	r.POST("/resendOTP", h.ResendOTP)
	r.POST("/updatePassword", h.UpdatePassword)
	r.POST("/uaepasslogin", h.UAEPassLogin)
	r.POST("/googleLogin", h.GoogleLogin)
	r.POST("/facebookLogin", h.FacebookLogin)
	r.POST("/appleLogin", h.AppleLogin)

	// r.POST("/signUp", h.SignUp)
	r.POST("/verifySignUpOTP", h.VerifySignUpOTP)
	r.POST("/signUp", h.IntialSignUp)
}

// RegisterNonAuthRoutes implements user_handler.Handler.
func (h *AuthHandler) RegisterAuthRoutes(r *gin.RouterGroup) {

	r.POST("/resetPassword/:id", h.ResetPassword)
	r.POST("/resetPasswordWithoutPassword/:id", h.ResetPasswordWithoutOldPassword)
	r.POST("/getPermission/:id", h.GetUserPermission)
	r.PUT("/updateUserStatus", h.UpdateUserStatus)

}
