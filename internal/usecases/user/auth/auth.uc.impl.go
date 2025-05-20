package auth_usecase

import (
	"aqary_admin/internal/delivery/redis"
	"aqary_admin/internal/delivery/rest/middleware"
	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/internal/notification/message"
	"aqary_admin/internal/notification/models"
	"aqary_admin/internal/usecases/user/auth/extras"
	"aqary_admin/old_repo/model"
	"aqary_admin/translations"
	"encoding/base64"
	"encoding/json"
	"strconv"
	"sync"

	"fmt"
	"log"
	"strings"
	"time"

	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/constants"
	"aqary_admin/pkg/utils/exceptions"
	file_utils "aqary_admin/pkg/utils/file"
	"aqary_admin/pkg/utils/security"

	db "aqary_admin/pkg/db/user"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/wagslane/go-rabbitmq"
	"go.uber.org/zap"
	"golang.org/x/crypto/bcrypt"
	// "aqary_admin/pkg/utils/auth/"
)

type AuthUseCase interface {
	// -------------------------------Sign Up-------------------------------------------------
	IntialSignUp(c *gin.Context, req domain.IntialSignUpRequest) (*string, *exceptions.Exception)
	VerifySignUpOTP(c *gin.Context, req domain.VerifyOTPEmailAndPhoneNumber) (*string, *exceptions.Exception)
	SignUp(c *gin.Context, req domain.SignUpRequest) (*string, *exceptions.Exception)
	// ---------------------------------------------------------------------------------------------
	Register(c *gin.Context, req domain.RegisterRequest) (*UserOutput, *exceptions.Exception)
	DashboardLogin(c *gin.Context, req domain.LoginReq) (*response.DashboardResult, *exceptions.Exception)
	ResetPassword(c *gin.Context, id int64, req domain.ResetPasswordRequest) (*string, *exceptions.Exception)
	ResetPasswordWithoutOldPassword(c *gin.Context, id int64, req domain.ResetPasswordWithoutOldPasswordRequest) (*string, *exceptions.Exception)
	GetUserPermission(c *gin.Context, compId int64) (any, *exceptions.Exception)
	UpdateUserStatusWithoutUpdateTime(c *gin.Context, req domain.UserUpdateStatusReq) (*sqlc.User, *exceptions.Exception)
	//---------- Forgot Password --------------
	ForgotPassword(c *gin.Context, req domain.ForgotPasswordRequest) (*string, *exceptions.Exception)
	ResendOTP(c *gin.Context, req domain.ResendOTPRequest) (*string, *exceptions.Exception)
	VerifyOTP(c *gin.Context, req domain.VerifyOTPRequest) (*string, *exceptions.Exception)

	UpdatePassword(c *gin.Context, req domain.UpdatePasswordRequest) (*string, *exceptions.Exception)
	//------------------------------------------
	UAEPassLogin(c *gin.Context, req domain.UAEPassLoginReq) (*response.DashboardResult, *exceptions.Exception)
	GoogleLogin(c *gin.Context, req domain.GoogleLoginReq) (*response.DashboardResult, *exceptions.Exception)
	FacebookLogin(c *gin.Context, req domain.FacebookLoginReq) (*response.DashboardResult, *exceptions.Exception)
	AppleLogin(c *gin.Context, req domain.AppleLoginReq) (*response.DashboardResult, *exceptions.Exception)
}

type authUseCaseImpl struct {
	repo         db.UserCompositeRepo
	pool         *pgxpool.Pool
	store        sqlc.Store
	tokenMaker   security.Maker
	rabbitClient *rabbitmq.Conn
}

// UpdatePassword implements AuthUseCase.
func (au *authUseCaseImpl) UpdatePassword(c *gin.Context, req domain.UpdatePasswordRequest) (*string, *exceptions.Exception) {

	redisClient, err := redis.NewRedisClient()
	if err != nil {
		log.Fatal("Failed to connect", zap.Error(err))
	}
	defer redisClient.Close()

	val, err := redisClient.Get(c, req.SecretKey)
	if err != nil {
		log.Printf("failed to retrieve data from redis:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "invalid secret_key")
	}

	userId, err := strconv.Atoi(val)
	if err != nil {
		log.Printf("failed to parse string to int:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error())
	}

	encryptedPassword, _ := bcrypt.GenerateFromPassword([]byte(req.NewPassword), 6)

	_, errr := au.repo.UpdatePlatformUserPassword(c, sqlc.UpdatePlatformUserPasswordParams{
		ID:       int64(userId),
		Password: string(encryptedPassword),
	})
	if errr != nil {
		log.Printf("failed to updated password in maindb:Error:%v", errr)
		return nil, errr
	}

	err = redisClient.Del(c, req.SecretKey)
	if err != nil {
		log.Printf("failed to delete the user data from redis:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	successMsg := "password updated successfully"
	return &successMsg, nil
}

func (au *authUseCaseImpl) ResendOTP(c *gin.Context, req domain.ResendOTPRequest) (*string, *exceptions.Exception) {
	redisClient, err := redis.NewRedisClient()
	if err != nil {
		log.Fatal("Failed to connect", zap.Error(err))
	}
	defer redisClient.Close()

	// decode the secrte key
	decoded, _ := base64.StdEncoding.DecodeString(req.SecretKey)
	decodedStr := string(decoded)
	parts := strings.Split(decodedStr, "|")
	cacheKeyUser := parts[0]
	// otpCacheKey := parts[1]

	var userData ForgotPasswordData

	// get the user detail to resend otp and decrease the attempts.
	userDataByte, err := redisClient.GetJSONFromFolder(c, "forgotpassword", cacheKeyUser)

	if err != nil || len(userDataByte) <= 0 {
		log.Printf("error while processing or no data found:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "no data found")
	}

	errr := json.Unmarshal(userDataByte, &userData)
	if errr != nil {
		log.Printf("failed to unmarshal userdatabyte:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "error while unmarshal")
	}

	if userData.Attempts <= 0 {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "maximum attempts exceeded. Please try again in a while")
	}

	userData.Attempts--

	userBytes, err := json.Marshal(userData)
	if err != nil {
		log.Printf("failed to marshal main user data:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "error while processing")
	}
	// get the ttl for existing user
	// Get the remaining TTL (time-to-live) of the key from Redis
	ttl, err := redisClient.TTL(c, "forgotpassword:"+cacheKeyUser)
	if err != nil {
		log.Printf("failed to get TTL for user data:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "error while processing")

	}

	// save user data for 60 minute
	err = redisClient.SetJSONInFolder(c, "forgotpassword", cacheKeyUser, userBytes, ttl)
	if err != nil {
		log.Printf("failed to store main user data in redis:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "error while processing")

	}

	otp := utils.GenerateOTP()

	otpObj := OTPData{
		Otp:      otp,
		UserID:   userData.UserID,
		ExpireAt: time.Now().Add(3 * time.Minute).Unix(),
	}

	otpBytes, er := json.Marshal(otpObj)
	if er != nil {
		log.Printf("failed to marshal otp data:Error:%v", er)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())
	}

	// generate secret key
	secretKey := generateSecretKey(c)

	// save secretkey with value otpRedis struct which is holding otp & userid
	er = redisClient.SetJSONInFolder(c, "otp", secretKey, otpBytes, 3*time.Minute)
	if er != nil {
		log.Printf("failed to store otp data in redis:Error:%v", er)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())
	}

	// TODO send otp to email here
	fullName := userData.FirstName + " " + userData.LastName

	emailData := models.Notification{
		Type:          message.EmailNotificationType,
		Provider:      message.EmailProvider,
		Recipient:     userData.Email,
		RecipientName: fullName,
		TemplateId:    constants.OTP_EMAIL,
		Subject:       translations.T(c, "emails.otp-subject"),
		Payload: map[string]string{
			"customer_name": fullName,
			"OTP":           strconv.Itoa(otp),
			"minutes":       "3",
		},
	}

	// Publish message to queue in go routine
	go func() {
		message.PublishMessage(au.rabbitClient, "", emailData, []string{message.NotificationQueue})
	}()

	// encode both tokens into one
	joined := cacheKeyUser + "|" + secretKey

	encodedKey := base64.StdEncoding.EncodeToString([]byte(joined))

	return &encodedKey, nil
}

// VerifyOTP implements AuthUseCase.
func (au *authUseCaseImpl) VerifyOTP(c *gin.Context, req domain.VerifyOTPRequest) (*string, *exceptions.Exception) {
	redisClient, err := redis.NewRedisClient()
	if err != nil {
		log.Fatal("Failed to connect", zap.Error(err))
	}
	defer redisClient.Close()

	// decode the secrte key
	decoded, _ := base64.StdEncoding.DecodeString(req.SecretKey)
	decodedStr := string(decoded)
	parts := strings.Split(decodedStr, "|")

	cacheSecretKey := parts[1]

	// get data from redis to verify
	bytess, err := redisClient.GetJSONFromFolder(c, "otp", cacheSecretKey)
	if err != nil {
		log.Printf("failed to retriev otp data from redis:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "otp expired or invalid")
	}

	// if not exists in redis throw error otp expired
	if bytess == nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "otp expired")
	}

	// unmarshal json the otp struct
	var otpData OTPData
	err = json.Unmarshal(bytess, &otpData)
	if err != nil {
		log.Printf("failed to unmarshal otp data:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "otp expired or invalid")
	}

	// // Max 3 attempts allowed
	// if otpData.Attempts <= 0 {
	// 	return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "maximum attempts exceeded")
	// }

	if otpData.Otp != req.OTP {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "otp is invalid")
	}

	// if otp is valid than delete the key imediatly
	err = redisClient.Del(c, fmt.Sprintf("otp:%s", cacheSecretKey))
	if err != nil {
		log.Printf("failed to delete otp data from redis:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	// generate a new secret key for next step(user will sent with updated password)
	secretKey := generateSecretKey(c)

	// save the new generate secret key in redis with value user_id
	err = redisClient.Set(c, secretKey, otpData.UserID, 30*time.Minute)
	if err != nil {
		log.Printf("failed to store user id in redis:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	return &secretKey, nil
}

// ForgotPassword implements AuthUseCase.
func (au *authUseCaseImpl) ForgotPassword(c *gin.Context, req domain.ForgotPasswordRequest) (*string, *exceptions.Exception) {
	var secretKey string

	if req.Email == "" && req.PhoneNumber == "" {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "email or phone_number is required")
	}

	redisClient, er := redis.NewRedisClient()
	if er != nil {
		log.Printf("failed to connect", zap.Error(er))
	}
	defer redisClient.Close()

	if req.Email == "" {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.InvalidCredentialsErrorCode, "invalid credentials")
	}

	// Get user detail first and validate
	user, err := au.repo.GetUserByEmailRegardlessSuperAdmin(c, sqlc.GetUserByEmailRegardlessParams{
		Email:     req.Email,
		CompanyID: pgtype.Int8{Int64: req.CompanyId, Valid: true},
	})
	if err != nil {
		log.Printf("failed to retrieve user data from maindb:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.InvalidCredentialsErrorCode, "invalid credentials")
	}
	// create a key now
	cacheKeyUser := user.Email + "&" + strconv.Itoa(int(user.CompanyID.Int64))

	// check if this user already tried or not.
	var userData ForgotPasswordData
	var hasData bool
	userDataBytes, er := redisClient.GetJSONFromFolder(c, "forgotpassword", cacheKeyUser)

	if er == nil && userDataBytes != nil {
		errr := json.Unmarshal(userDataBytes, &userData)
		if errr == nil {
			// check for attempts
			if userData.Attempts <= 0 {
				return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "maximum attempts exceeded. Please try again in a while")
			} else {
				userData.Attempts--
				hasData = true
			}

		}
	}

	if hasData == true {
		userBytes, err := json.Marshal(userData)
		if err != nil {
			log.Printf("failed to marshal main user data:Error:%v", err)
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}
		// get the ttl for existing user
		// Get the remaining TTL (time-to-live) of the key from Redis
		ttl, err := redisClient.TTL(c, "forgotpassword:"+cacheKeyUser)
		if err != nil {
			log.Printf("failed to get TTL for user data:Error:%v", err)
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}

		// save user data for 60 minute
		err = redisClient.SetJSONInFolder(c, "forgotpassword", cacheKeyUser, userBytes, ttl)
		if err != nil {
			log.Printf("failed to store main user data in redis:Error:%v", err)
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}
	} else {
		userData = ForgotPasswordData{
			Email:     req.Email,
			Attempts:  3, //max 3 attempts are allowed for forgot password also for resent otp
			ExpireAt:  time.Now().Add(60 * time.Minute).Unix(),
			FirstName: user.FirstName.String,
			LastName:  user.LastName.String,
			UserID:    user.ID,
		}

		fgtPassByt, er := json.Marshal(userData)
		if er != nil {
			log.Printf("failed to marshal forgotpassword data:Error:%v", er)
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())
		}

		er = redisClient.SetJSONInFolder(c, "forgotpassword", cacheKeyUser, fgtPassByt, 60*time.Minute)
		if er != nil {
			log.Printf("failed to store forgotpassword data in redis:Error:%v", er)
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())
		}
	}

	otp := utils.GenerateOTP()

	otpObj := OTPData{
		Otp:      otp,
		UserID:   user.ID,
		ExpireAt: time.Now().Add(3 * time.Minute).Unix(),
	}

	otpBytes, er := json.Marshal(otpObj)
	if er != nil {
		log.Printf("failed to marshal otp data:Error:%v", er)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())
	}

	// generate secret key
	secretKey = generateSecretKey(c)

	// save secretkey with value otpRedis struct which is holding otp & userid
	er = redisClient.SetJSONInFolder(c, "otp", secretKey, otpBytes, 3*time.Minute)
	if er != nil {
		log.Printf("failed to store otp data in redis:Error:%v", er)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())
	}

	// TODO send otp to email here
	fullName := user.FirstName.String + " " + user.LastName.String

	emailData := models.Notification{
		Type:          message.EmailNotificationType,
		Provider:      message.EmailProvider,
		Recipient:     user.Email,
		RecipientName: fullName,
		TemplateId:    constants.OTP_EMAIL,
		Subject:       translations.T(c, "emails.otp-subject"),
		Payload: map[string]string{
			"customer_name": fullName,
			"OTP":           strconv.Itoa(otp),
			"minutes":       "3",
		},
	}

	// Publish message to queue in go routine
	go func() {
		message.PublishMessage(au.rabbitClient, message.EmailNotificationType, emailData, []string{message.NotificationQueue})
	}()

	// encode both tokens into one
	joined := cacheKeyUser + "|" + secretKey

	encodedKey := base64.StdEncoding.EncodeToString([]byte(joined))

	return &encodedKey, nil
}

// UpdateUserStatus implements AuthUseCase.
func (au *authUseCaseImpl) UpdateUserStatusWithoutUpdateTime(c *gin.Context, req domain.UserUpdateStatusReq) (*sqlc.User, *exceptions.Exception) {
	_, err := au.repo.GetUser(c, req.ID)
	if err != nil {
		return nil, err
	}

	updatedUser, err := au.repo.UpdateUserStatusWithoutUpdateTime(c, req)
	if err != nil {
		return nil, err
	}

	return updatedUser, nil
}

// GetUserPermission implements AuthUseCase.
func (au *authUseCaseImpl) GetUserPermission(c *gin.Context, compId int64) (any, *exceptions.Exception) {

	//check for aqary user (type_id=5)
	// get user from the token
	payload, _ := c.MustGet(middleware.AuthorizationPayloadKey).(*security.Payload)
	visitedUser, err := au.repo.GetUserByName(c, payload.Username)
	if err != nil {
		return "", exceptions.GetExceptionByErrorCode(exceptions.DocumentNotFoundErrorCode)
	}
	// TODO: for security we need to add check for  the current user is belong to this company or not
	// GetUserPermissionsByID
	userPerm, err := au.repo.GetUserPermissionByID(c, sqlc.GetUserPermissionsByIDParams{
		IsCompanyUser: compId,
		CompanyID: pgtype.Int8{
			Int64: compId,
			Valid: true,
		},
		UserID: visitedUser.ID,
	})

	var customSectionPermssion = make(chan extras.CustomSectionPermission)
	var wg sync.WaitGroup

	for i := range userPerm.PermissionsID {
		wg.Add(1)

		go func(index int) {
			defer wg.Done()

			if r := recover(); r != nil {
				log.Printf("Recovered in DashboardLogin: %v", r)
				// Handle the panic, maybe return an error
			}

			permission, _ := au.repo.GetPermissionMV(c, int64(userPerm.PermissionsID[index]))
			if err != nil {
				log.Printf("Error getting permission: %v", err)
				return
			}
			if permission == nil {
				log.Printf("No permission found for ID: %d", userPerm.PermissionsID[index])
				return
			}
			if permission.SectionPermissionID == 0 {
				return
			}
			section, err := au.repo.GetSectionPermissionMV(c, permission.SectionPermissionID)

			log.Println("checking the cause", err)

			var customPermissions []extras.CustomAllPermission
			var customPermission extras.CustomAllPermission

			//! permissions
			customPermission.ID = permission.ID
			customPermission.Label = permission.Title
			customPermission.SubLabel = permission.SubTitle.String

			customPermissions = append(customPermissions, customPermission)

			if section.ID != 0 || customPermission.ID != 0 {
				customSectionPermssion <- extras.CustomSectionPermission{
					ID:               section.ID,
					Label:            section.Title,
					SubLabel:         section.SubTitle.String,
					CustomPermission: customPermissions,
				}
			}
		}(i)
	}

	go func() {
		wg.Wait()
		close(customSectionPermssion)
	}()

	var processedPermission = make(chan []extras.CustomSectionPermission)
	go func() {

		allSectionPermission := []extras.CustomSectionPermission{}
		for sc := range customSectionPermssion {

			if utils.ContainSectionId(allSectionPermission, sc.ID) {
				allSectionPermission[len(allSectionPermission)-1].CustomPermission = append(allSectionPermission[len(allSectionPermission)-1].CustomPermission, extras.CustomAllPermission{
					ID:                           sc.CustomPermission[0].ID,
					Label:                        sc.CustomPermission[0].Label,
					SubLabel:                     sc.CustomPermission[0].SubLabel,
					CustomAllSecondaryPermission: []extras.CustomAllSubSectionPermission{},
				})
			} else {
				allSectionPermission = append(allSectionPermission, sc)
			}
		}

		processedPermission <- allSectionPermission
	}()

	return <-processedPermission, nil

}

func NewAuthUseCase(repo db.UserCompositeRepo, store sqlc.Store, pool *pgxpool.Pool, tokenMaker security.Maker, rabbitClient *rabbitmq.Conn) AuthUseCase {
	return &authUseCaseImpl{
		repo:         repo,
		pool:         pool,
		store:        store,
		tokenMaker:   tokenMaker,
		rabbitClient: rabbitClient,
	}
}

func (au authUseCaseImpl) Register(c *gin.Context, req domain.RegisterRequest) (*UserOutput, *exceptions.Exception) {

	var password string
	var profileImage string

	// var departmentId int64
	var state pgtype.Int8
	var city pgtype.Int8
	var community pgtype.Int8
	var subCommunity pgtype.Int8

	var status exceptions.ErrorCode
	// var user *sqlc.User
	var output UserOutput

	err := sqlc.ExecuteTxWithException(c, au.pool, func(q sqlc.Querier) *exceptions.Exception {

		// it's only checking testing purpose
		// don't remove this line or update
		// au.store, q = auth_utils.CheckAuthForTests(c, au.store, q)

		// if country not given from user ....
		if req.Country == 0 {
			uae, err := au.repo.GetCountryByName(c, utils.AddPercent("united arab emirates"))
			if err != nil {
				if strings.EqualFold(err.Error(), "no country found") {
					// not need to return error here this is only for default in case not available
					uae, _ := au.repo.CreateCountry(c, sqlc.CreateCountryParams{
						Country: "united arab emiratessss",
						Flag:    "", // TODO: ADD FLAG HERE in future
					}, q)
					req.Country = uae.ID

					log.Println("uae", uae)
				} else {
					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
				}
			} else {
				req.Country = uae.ID
			}
		}

		// email and user both are checking here ....
		oldUser, err := q.GetUserByName(c, req.UserName)
		// to remove this .......
		if err != nil {
			middleware.IncrementServerErrorCounter(err.Error())
		}

		if oldUser.Username == req.UserName {
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "username is already exist")
		}

		oldUser2, _ := q.GetUserByEmail(c, req.Email)
		if oldUser2.Email == req.Email {
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "email is already exist")
		}

		//  check if usertype exist in case if they send a wrong type
		userType, er := au.repo.GetUserType(c, req.UserTypeID)
		if userType == nil {
			return er
		}

		superUser, err := au.repo.GetSuperUser(c)

		if err != nil {
			log.Println(err, superUser)
		} else {
			//! check for super user
			if userType.ID == 6 {
				status = exceptions.BadRequestErrorCode
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "not allowed to create this kind of user ")
			}
		}

		// ! agent .....
		// if userType.ID == 2 {
		// TODO: fix this later
		// status, err = extras.AgentValidation(c, req, q)
		// log.Println("ch", err)
		// if err != nil {
		// 	return err
		// }
		// }

		if req.State != nil {
			state.Valid = true
			state.Int64 = *req.State
		} else {
			state.Valid = false
		}

		if req.City != nil {
			city.Valid = true
			city.Int64 = *req.City
		} else {
			city.Valid = false
		}

		if req.Community != nil {
			community.Valid = true
			community.Int64 = *req.Community
		} else {
			community.Valid = false
		}

		if req.SubCommunity != nil {
			subCommunity.Valid = true
			subCommunity.Int64 = *req.Community
		} else {
			subCommunity.Valid = false
		}

		addressArgs := sqlc.CreateAddressParams{
			CountriesID:      pgtype.Int8{Int64: req.Country, Valid: true},
			StatesID:         state,
			CitiesID:         city,
			CommunitiesID:    community,
			SubCommunitiesID: subCommunity,
			LocationsID:      pgtype.Int8{},
		}

		address, er := au.repo.CreateAddress(c, addressArgs, q)
		if er != nil {
			status = exceptions.SomethingWentWrongErrorCode
			return er
		}

		// profile  image upload
		image, err := c.FormFile("profile_image_url")
		if err != nil {
			log.Println("if profile image testing ..", address)
		}
		if err == nil {
			resp, err := file_utils.UploadSingleFileToABS(c, image, "auth")
			if err != nil {
				// middleware.IncrementServerErrorCounter(err.Error())
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
			}
			profileImage = resp
		}

		// cover image .......
		if len(req.AllLanguageID) == 0 {
			var language *sqlc.AllLanguage
			language, err = au.repo.GetLanguageByLanguage(c, "english")
			if err != nil {
				if strings.EqualFold(err.Error(), "not language found") {
					language, _ = au.repo.CreateLanguage(c, sqlc.CreateLanguageParams{
						Language:  "english",
						CreatedAt: time.Now(),
					}, q)
					log.Println("testing language created", language)
				}
				// return err
			}
			req.AllLanguageID = []int64{language.ID}
		}

		// encrypted password ....
		encryptedPassword, _ := bcrypt.GenerateFromPassword([]byte(req.Password), 6)
		password = string(encryptedPassword)

		if req.UserTypeID != 5 && req.RoleID != 0 {
			status = exceptions.BadRequestErrorCode
			errText := "role can only be assign to aqary management user"
			// return errors.New(errText)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errText)
		}

		// ! check the department if exist
		if req.DepartmentID != 0 {
			if req.UserTypeID != 5 {
				errText := "department can only be assign to aqary management user"
				// return errors.New(errText)
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, errText)

			}
		}

		// now collecting internal button permission for each

		var perm []domain.PermissionButton
		var uniquePermissionList []int64
		var uniqueSubSectionList []int64

		if req.Permissions != "" {
			jsonErr := json.Unmarshal([]byte(req.Permissions), &perm)
			if jsonErr != nil {
				fmt.Println("Error unmarshaling JSON:", jsonErr)
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, jsonErr.Error())
			}
		}

		for _, p := range perm {
			if p.ButtonID != 0 {
				uniqueSubSectionList = append(uniqueSubSectionList, int64(p.ID))
				if p.PermissionID != 0 {
					uniquePermissionList = append(uniquePermissionList, int64(p.PermissionID)) // permissons
				}
				if p.SecondaryID != 0 {
					uniqueSubSectionList = append(uniqueSubSectionList, int64(p.SecondaryID)) // permissons
				}

				if p.TertiaryID != 0 {
					uniqueSubSectionList = append(uniqueSubSectionList, int64(p.TertiaryID)) // permissons
				}

				if p.QuaternaryID != 0 {
					uniqueSubSectionList = append(uniqueSubSectionList, int64(p.QuaternaryID)) // permissons
				}
			} else {
				uniquePermissionList = append(uniquePermissionList, int64(p.ID)) // permissons
				if p.PermissionID != 0 {
					uniquePermissionList = append(uniquePermissionList, int64(p.PermissionID)) // permissons
				}
				if p.SecondaryID != 0 {
					uniqueSubSectionList = append(uniqueSubSectionList, int64(p.SecondaryID)) // permissons
				}

				if p.TertiaryID != 0 {
					uniqueSubSectionList = append(uniqueSubSectionList, int64(p.TertiaryID)) // permissons
				}

				if p.QuaternaryID != 0 {
					uniqueSubSectionList = append(uniqueSubSectionList, int64(p.QuaternaryID)) // permissons
				}
			}
		}

		// if the user is company admin then we give the basic permission for add company
		if req.UserTypeID == 1 {

			var permission *sqlc.Permission
			var sectionPermission *sqlc.SectionPermission

			sectionPermission, err = au.repo.GetCompanySectionPermission(c)
			if err != nil {
				log.Println("testing error ", strings.EqualFold(err.Error(), "no company section permission available"))

				if strings.EqualFold(err.Error(), "no company section permission available") {
					var er *exceptions.Exception
					sectionPermission, er = au.repo.CreateSectionPermission(c, sqlc.CreateSectionPermissionParams{
						Title: "companies",
						SubTitle: pgtype.Text{
							String: "companies",
							Valid:  true,
						},
						CreatedAt: time.Now(),
						UpdatedAt: time.Now(),
					}, q)
					log.Println("testing section permission created", er)
					if er != nil {
						return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, fmt.Errorf("cannot give permission: %v", er).Error())
					}
				}
				// status = exceptions.SomethingWentWrongErrorCode
				// return fmt.Errorf("error while getting company section permission:%v", err)
			}
			permission, err = au.repo.GetAddCompanyPermission(c)
			if err != nil {
				if strings.EqualFold(err.Error(), "no company permission found") {
					var er *exceptions.Exception
					permission, er = au.repo.CreatePermission(c, sqlc.CreatePermissionParams{
						Title: "Add Company",
						SubTitle: pgtype.Text{
							String: "add-company",
							Valid:  true,
						},
						SectionPermissionID: sectionPermission.ID,
						CreatedAt:           time.Now(),
						UpdatedAt:           time.Now(),
					}, q)
					log.Println("testing   permission created", permission)

					if er != nil {
						return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, fmt.Errorf("cannot give permission: %v", er).Error())
					}
				}
				// status = exceptions.SomethingWentWrongErrorCode
				// return fmt.Errorf("error while getting company permission:%v", err)
			}
			uniquePermissionList = append(uniquePermissionList, permission.ID)
		}

		userArgs := sqlc.CreateUserParams{
			Email:    req.Email,
			Username: req.UserName,
			Password: password,
			Status:   1,
			RolesID:  pgtype.Int8{Int64: req.RoleID, Valid: req.RoleID != 0},
			PhoneNumber: pgtype.Text{
				String: req.PrimaryPhoneNumber,
				Valid:  req.PrimaryPhoneNumber != "",
			},
			UserTypesID:     userType.ID,
			SocialLogin:     pgtype.Text{},
			ShowHideDetails: pgtype.Bool{Bool: true, Valid: true},
			ExperienceSince: pgtype.Timestamptz{},
			IsVerified:      pgtype.Bool{Bool: false, Valid: true},
			CreatedAt:       time.Now(),
			UpdatedAt:       time.Now(),
		}

		// user, er = au.repo.CreateUser(c, userArgs, q)
		// if er != nil {
		// 	status = exceptions.SomethingWentWrongErrorCode
		// 	return er
		// }

		user, er := au.repo.CreateUser(c, userArgs, q)
		if er != nil {
			log.Println("testing error, er:", err)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())
		}

		profileArgs := sqlc.CreateProfileParams{
			FirstName:       req.FirstName,
			LastName:        req.LastName,
			AddressesID:     address.ID,
			ProfileImageUrl: pgtype.Text{String: profileImage, Valid: profileImage != ""},

			SecondaryNumber:    pgtype.Text{},
			WhatsappNumber:     pgtype.Text{},
			ShowWhatsappNumber: pgtype.Bool{},
			BotimNumber:        pgtype.Text{},
			ShowBotimNumber:    pgtype.Bool{},
			TawasalNumber:      pgtype.Text{},
			ShowTawasalNumber:  pgtype.Bool{},
			Gender: pgtype.Int8{
				Int64: req.Gender,
				Valid: req.Gender != 0,
			},
			CreatedAt:        time.Now(),
			UpdatedAt:        time.Now(),
			RefNo:            utils.GenerateReferenceNumber(constants.PROFILE),
			CoverImageUrl:    pgtype.Text{},
			PassportNo:       pgtype.Text{},
			PassportImageUrl: pgtype.Text{},
			About:            pgtype.Text{},
			AboutArabic:      pgtype.Text{},
			UsersID:          user.ID,
		}

		_, er = au.repo.CreateProfile(c, profileArgs, q)
		if er != nil {
			status = exceptions.SomethingWentWrongErrorCode
			return er
		}

		// remove the duplicates ......
		uniquePermissionList = utils.MakeUnique(uniquePermissionList)
		uniqueSubSectionList = utils.MakeUnique(uniqueSubSectionList)

		userPermission, errr := q.CreateUserPermission(c, sqlc.CreateUserPermissionParams{
			UserID:        user.ID,
			CompanyID:     pgtype.Int8{},
			PermissionsID: uniquePermissionList,
			SubSectionsID: uniqueSubSectionList,
		})
		if errr != nil {
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, errr.Error())
		}

		output.User = *user
		output.AllPermission = userPermission

		log.Println("testing output :", output, "::", user)

		return nil
	})

	if err != nil {
		// if not empty & already uploaded then deleted it again
		if profileImage != "" {
			utils.DeleteSingleFileFromABS(profileImage)
		}
		log.Println("testing error :::")
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(status, err.Error())
	}

	return &output, nil
}

type UserOutput struct {
	User          sqlc.User `json:"user"`
	AllPermission any       `json:"allPermissions"`
}

func (au authUseCaseImpl) DashboardLogin(c *gin.Context, req domain.LoginReq) (*response.DashboardResult, *exceptions.Exception) {

	var user sqlc.User
	var err error

	// if both are given
	if req.Email != "" && req.Username != "" {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "provide email or username only")
	}

	// if none is given...
	if req.Email == "" && req.Username == "" {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.CannotGiveEmailAndUsernameErrorCode, "email or usernamne is required")
	}

	if req.Username != "" {
		var er *exceptions.Exception
		user, er = au.repo.GetUserByName(c, req.Username)
		log.Println("testing error ", err, "::", user, "testing name", req.Username)
		if er != nil {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, er.Error())
		}
	}

	if req.Email != "" {
		var er *exceptions.Exception
		user, er = au.repo.GetUserByEmail(c, req.Email)
		if er != nil {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())
		}
	}

	passwordError := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password))
	if passwordError != nil {
		return nil, exceptions.GetExceptionByErrorCode(exceptions.InvalidCredentialsErrorCode)
	}
	// TODO: FIX THE AFTER FINISH THE PROJECT
	token, err := au.tokenMaker.CreateToken(user.Username, 100*24*time.Hour)
	// accesssecurity. err := au.tokenMaker.Createsecurity.user.Username, 100*24*time.Hour)
	if err != nil {
		middleware.IncrementServerErrorCounter(fmt.Errorf("[DashboardLogin.uc.Createsecurity. error:%v", err).Error())
		return nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}

	profile, _ := au.repo.GetProfileByUserId(c, user.ID)

	// var customSectionPermssion = make(chan extras.CustomSectionPermission)

	// var wg sync.WaitGroup

	// for i := range user.PermissionsID {
	// 	wg.Add(1)

	// 	go func(index int) {
	// 		defer wg.Done()

	// 		if r := recover(); r != nil {
	// 			log.Printf("Recovered in DashboardLogin: %v", r)
	// 			// Handle the panic, maybe return an error
	// 		}

	// 		permission, _ := au.repo.GetPermissionMV(c, int64(user.PermissionsID[index]))
	// 		if err != nil {
	// 			log.Printf("Error getting permission: %v", err)
	// 			return
	// 		}
	// 		if permission == nil {
	// 			log.Printf("No permission found for ID: %d", user.PermissionsID[index])
	// 			return
	// 		}
	// 		if permission.SectionPermissionID == 0 {
	// 			return
	// 		}
	// 		section, err := au.repo.GetSectionPermissionMV(c, permission.SectionPermissionID)

	// 		log.Println("checking the cause", err)

	// 		var customPermissions []extras.CustomAllPermission
	// 		var customPermission extras.CustomAllPermission

	// 		//! permissions
	// 		customPermission.ID = permission.ID
	// 		customPermission.Label = permission.Title
	// 		customPermission.SubLabel = permission.SubTitle.String

	// 		customPermissions = append(customPermissions, customPermission)

	// 		if section.ID != 0 || customPermission.ID != 0 {
	// 			customSectionPermssion <- extras.CustomSectionPermission{
	// 				ID:               section.ID,
	// 				Label:            section.Title,
	// 				SubLabel:         section.SubTitle.String,
	// 				CustomPermission: customPermissions,
	// 			}
	// 		}
	// 	}(i)
	// }

	// go func() {
	// 	wg.Wait()
	// 	close(customSectionPermssion)
	// }()

	// var processedPermission = make(chan []extras.CustomSectionPermission)
	// go func() {

	// 	allSectionPermission := []extras.CustomSectionPermission{}
	// 	for sc := range customSectionPermssion {

	// 		if utils.ContainSectionId(allSectionPermission, sc.ID) {
	// 			allSectionPermission[len(allSectionPermission)-1].CustomPermission = append(allSectionPermission[len(allSectionPermission)-1].CustomPermission, extras.CustomAllPermission{
	// 				ID:                           sc.CustomPermission[0].ID,
	// 				Label:                        sc.CustomPermission[0].Label,
	// 				SubLabel:                     sc.CustomPermission[0].SubLabel,
	// 				CustomAllSecondaryPermission: []extras.CustomAllSubSectionPermission{},
	// 			})
	// 		} else {
	// 			allSectionPermission = append(allSectionPermission, sc)
	// 		}
	// 	}

	// 	processedPermission <- allSectionPermission
	// }()

	companyUser, _ := au.repo.GetACompanyByUserID(c, user.ID)
	isCompanyUser := 0
	isVerified := false
	if companyUser.CompanyID == 0 {
		isCompanyUser = 0
		isVerified = false
	} else {
		isCompanyUser = int(companyUser.CompanyID)
		isVerified = companyUser.IsVerified.Bool
	}
	if user.ID == 1309 || user.ID == 1287 || user.ID == 1286 || user.ID == 1285 || user.ID == 1284 || user.ID == 1283 || user.ID == 1282 || user.ID == 1281 || user.ID == 1280 || user.ID == 1279 || user.ID == 11 {
		// skip these for now b/c it's a super admin
	} else {
		// TODO: remove the comments
		// if isCompanyUser != 0 && !isVerified {
		// 	return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.CompanyNotVerifiedErrorCode, "your company is not verified")
		// }
	}

	associatedCompanies, er := au.repo.GetUserAssociatedCompanies(c, user.ID)
	if er != nil {
		log.Printf("error while GetUserAssociatedCompanies : %v", er)
	}

	var asComp []model.CustomFormat
	for _, ac := range associatedCompanies {
		asComp = append(asComp, model.CustomFormat{
			ID:   ac.ID,
			Name: ac.CompanyName,
		})
	}

	rsp := response.DashboardResult{
		UserID:              user.ID,
		FirstName:           profile.FirstName,
		LastName:            profile.LastName,
		Token:               token,
		Email:               user.Email,
		UserName:            user.Username,
		ProfilePicture:      profile.ProfileImageUrl.String,
		PhoneNumber:         user.PhoneNumber.String,
		HaveCompany:         utils.Ternary[bool](isCompanyUser != 0, true, false),
		IsCompanyVerified:   isVerified,
		UserType:            user.UserTypesID,
		ActiveCompany:       user.ActiveCompany.Int64,
		AssociatedCompanies: asComp,
		// SectionPermission: <-processedPermission,
	}

	return &rsp, nil
}

func (au authUseCaseImpl) ResetPassword(c *gin.Context, id int64, req domain.ResetPasswordRequest) (*string, *exceptions.Exception) {

	user, err := au.repo.GetUserRegardlessOfStatus(c, id)
	if err != nil {
		return nil, err
	}

	passwordError := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.OldPassword))
	if passwordError != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "old password is wrong")
	}

	encryptedPassword, _ := bcrypt.GenerateFromPassword([]byte(req.NewPassword), 6)

	_, errr := au.repo.UpdateUserPassword(c, sqlc.UpdateUserPasswordParams{
		ID:       id,
		Password: string(encryptedPassword),
	})
	if errr != nil {
		return nil, err
	}

	output := "successfully updated the password"

	return &output, nil
}

func (au authUseCaseImpl) ResetPasswordWithoutOldPassword(c *gin.Context, id int64, req domain.ResetPasswordWithoutOldPasswordRequest) (*string, *exceptions.Exception) {

	user, err := au.repo.GetUserRegardlessOfStatus(c, id)
	if err != nil {
		return nil, err
	}

	encryptedPassword, _ := bcrypt.GenerateFromPassword([]byte(req.NewPassword), 6)

	_, errr := au.repo.UpdateUserPassword(c, sqlc.UpdateUserPasswordParams{
		ID:       user.ID,
		Password: string(encryptedPassword),
	})
	if errr != nil {
		return nil, err
	}

	output := "successfully updated the password"

	return &output, nil
}
