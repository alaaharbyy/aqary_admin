package user_handler

import (
	usecase "aqary_admin/internal/usecases/user"
	userUserCase "aqary_admin/internal/usecases/user"

	"github.com/gin-gonic/gin"
)

// type UserHandler struct {
// 	UserUseCase userUserCase.UserCompositeUseCase
// }

// func NewUseCaseHandler(userUseCase userUserCase.UserCompositeUseCase) *UserHandler {
// 	return &UserHandler{
// 		UserUseCase: userUseCase,
// 	}
// }

////////////////////////////////////////////////////! user handler   ////////////////////////////////

type UserHandler struct {
	UserUseCase userUserCase.UserCompositeUseCase
}

// RegisterNonAuthRoutes implements Handler.
func (h *UserHandler) RegisterNonAuthRoutes(r *gin.RouterGroup) {
	// no handlers yet
	// ! **********     Registeration
	r.POST("/checkEmail", h.CheckEmail)
	r.POST("/checkUsername", h.CheckUsername)
	r.POST("/checkPhone", h.CheckPhone)
}

func NewUserHandler(useCase usecase.UserCompositeUseCase) *UserHandler {
	return &UserHandler{UserUseCase: useCase}
}

func (h *UserHandler) RegisterAuthRoutes(r *gin.RouterGroup) {

	//!  user types
	r.POST("/createusertype", h.CreateUserType)
	r.GET("/getallusertype", h.GetAllUserTypes)
	r.GET("/getallDashBoardUsertype", h.GetAllUserTypesDashBoard)
	r.GET("/getAlluserTypeForWeb", h.GetAllUserTypesForWeb)
	r.GET("/getusertype/:id", h.GetUserType)
	r.PUT("/updateusertype/:id", h.UpdateUserType)
	r.DELETE("/deleteusertype/:id", h.DeleteUserType)

	r.GET("/getActiveUsers/:typeid", h.GetActiveUsersByType)

	// ! profile
	//! user profile
	r.POST("/createprofile", h.CreateProfile)
	// r.GET("/getallprofiles", users.GetAllProfiles)
	// r.GET("/getprofile/:id", users.GetProfile)
	r.PUT("/updateprofile", h.UpdateProfile)
	r.PUT("/updateprofilepassword", h.UpdateProfilePassword)
	r.GET("/getOrganization", h.GetOrganization)
	// r.DELETE("/deleteprofile/:id", users.DeleteProfile)

	// ! pending users related ...
	r.GET("/getAllPeddingUsers", h.GetAllPendingUser)
	r.DELETE("/deletePendingUser/:id", h.DeletePendingUser)

	// ! other users related ...
	r.GET("/getAllRegisteredUsers", h.GetAllOtherUser)
	r.GET("/getAllRegisteredUsersByCountryId", h.GetAllOtherUserByCountry)

	// ! permisison for company user
	r.POST("/addCompanyAdminPermissions", h.AddCompanyAdminPermission)
	// r.POST("/resetPasswordForCompanies", h.ResetPasswordWithoutOldPasswordForCompanies)
	r.GET("/getUser/:id", h.GetSingleUser)

	// !aqary users related ...
	r.GET("/getAllAqaryUsers", h.GetAllAqaryUser)
	r.GET("/getAllAqaryUsersByCountryId", h.GetAllAqaryUserByCountry)
	r.GET("/getSingleAqaryUser/:id", h.GetSingleAqaryUser)
	r.PUT("/updateAqaryUser/:id", h.UpdateAqaryUser)
	r.DELETE("/deleteAqaryUser/:id", h.DeleteUser)
	r.POST("/restoreAqaryUser/:id", h.RestoreUser)
	r.GET("/getAllDeletedAqaryUser", h.GetAllDeletedAqaryUser)
	r.GET("/getAllDeletedAqaryUserWithoutPagination", h.GetAllDeletedAqaryUserWithoutPagination)

	// ! other users related ...
	r.DELETE("/deleteRegisteredUser/:id", h.DeleteUser)
	r.GET("/getAllTeamLeaders", h.GetAllTeamLeaders)

	// me api
	r.GET("/me", h.GetUserDetailsByUserName)

}
