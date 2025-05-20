package routes

import (
	investHandler "aqary_admin/internal/delivery/rest/handlers/aqary_investment"

	authHanlder "aqary_admin/internal/delivery/rest/handlers/user/auth"
	"aqary_admin/internal/delivery/rest/middleware"
	"aqary_admin/pkg/utils/constants"
	"aqary_admin/pkg/utils/security"

	// _ "aqary_admin/cmd/docs"

	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"

	// _ "aqary_admin/docs/docs.go"
	_ "aqary_admin/cmd/docs"
)

func SetUpRestHanlders(server Server) {

	SetupUserManagementRoutes(server)

}

func SetUpAuthHandlers(router *gin.Engine, handler *authHanlder.AuthHandler, tokenMaker security.Maker) {

	auth := middleware.AuthMiddleware(tokenMaker)
	v1Route := router.Group(constants.API_V1_PATH_PREFIX)
	{
		v1Route.POST("/user/register", handler.RegisterHandler)
		v1Route.POST("/user/dashboardLogin", handler.DashboardLogin)
	}

	v1RouteWithAuth := router.Group(constants.API_V1_PATH_PREFIX, auth)
	{
		v1RouteWithAuth.POST("/user/resetPassword/:id", handler.ResetPassword)
		v1RouteWithAuth.POST("/user/resetPasswordWithoutPassword/:id", handler.ResetPasswordWithoutOldPassword)
	}
}

func SetUpAqaryInvestmentHandlers(router *gin.Engine, handler *investHandler.AllHandler, tokenMaker security.Maker) {

	//url := ginSwagger.URL("/swagger/doc.json")
	router.GET("/swagger2/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	auth := middleware.AuthMiddleware(tokenMaker)

	v1Route := router.Group(constants.API_V1_PATH_PREFIX)
	{
		v1Route.GET("/investment/searchLocationsHandler", handler.SearchLocationsHandler)
	}

	v1RouteWithAuth := router.Group(constants.API_V1_PATH_PREFIX, auth)
	{
		v1RouteWithAuth.POST("tobeimplemented")
	}
}
