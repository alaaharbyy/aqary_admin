package routes

import (
	user_handler "aqary_admin/internal/delivery/rest/handlers/user"
	auth_handler "aqary_admin/internal/delivery/rest/handlers/user/auth"
	department_handler "aqary_admin/internal/delivery/rest/handlers/user/department"
	roles_handler "aqary_admin/internal/delivery/rest/handlers/user/roles"
	"aqary_admin/internal/delivery/rest/middleware"
	userUsecase "aqary_admin/internal/usecases/user"
	db "aqary_admin/pkg/db/user"

	"aqary_admin/pkg/utils/constants"
)

func SetupUserManagementRoutes(server Server) {

	userRepo := db.NewUserCompositeRepoModule(server.Store)
	usecase := userUsecase.NewUserCompositeUseCaseModule(userRepo, server.Store, server.Pool, server.TokenMaker, server.RabbitClient)
	compositeHandler := user_handler.NewCompositeHandler(usecase)

	// Add all your handlers here
	compositeHandler.AddHandler(user_handler.NewUserHandler(usecase))

	// NewPermissionHandler
	compositeHandler.AddHandler(roles_handler.NewRoleHandler(usecase))
	compositeHandler.AddHandler(auth_handler.NewAuthHandler(usecase, server.Hub, server.RabbitClient))
	compositeHandler.AddHandler(department_handler.NewDepartmentHandler(usecase))

	auth := middleware.AuthMiddleware(server.TokenMaker)
	v1Route := server.Router.Group(constants.API_V1_PATH_PREFIX_USER, auth)

	compositeHandler.RegisterAuthRoutes(v1Route)

	v1RouteWithoutAuth := server.Router.Group(constants.API_V1_PATH_PREFIX_USER)
	compositeHandler.RegisterNonAuthRoutes(v1RouteWithoutAuth)
}
