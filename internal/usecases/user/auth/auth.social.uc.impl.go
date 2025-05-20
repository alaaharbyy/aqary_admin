package auth_usecase

import (
	"aqary_admin/internal/delivery/redis"
	"aqary_admin/internal/delivery/rest/middleware"
	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/constants"
	"aqary_admin/pkg/utils/exceptions"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"go.uber.org/zap"
	"golang.org/x/crypto/bcrypt"
)

type UserDetailsForRedis struct {
	UserName    string `json:"user_name"`
	Email       string `json:"email"`
	PhoneNumber string `json:"phone_number"`
	Password    string `json:"password"`
	FirstName   string `json:"first_name"`
	LastName    string `json:"last_name"`
	// PhoneOTP    SignUpOTP `json:"phone_otp"`
	// EmailOTP    SignUpOTP `json:"email_otp"`
}

type SignUpOTP struct {
	MainSecretKey string `json:"main_secret_key"`
	Otp           int    `json:"otp"`
	Attempts      int    `json:"attempts"`
	ExpireAt      int64  `json:"expire_at"`
}

func (uc *authUseCaseImpl) IntialSignUp(c *gin.Context, req domain.IntialSignUpRequest) (*string, *exceptions.Exception) {
	var password string
	emailError := ValidateEmail(req.Email)
	if emailError != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "invalid email")
	}

	passwordError := VerifyPasswordCriteria(req.Password)
	if passwordError != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "password not strong enough")
	}

	oldUser2, _ := uc.store.GetUserByEmail(c, req.Email)
	if oldUser2.Email == req.Email {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "email already exists")
	}

	oldUser3, _ := uc.store.GetUserByPhoneNumber(c, pgtype.Text{String: req.PhoneNumber, Valid: true})
	if oldUser3.PhoneNumber.String == req.PhoneNumber {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "phone number already exists")
	}

	oldUser, _ := uc.store.GetUserByName(c, req.UserName)
	if oldUser.Username == req.UserName {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "username already exists")
	}
	// encrypted password ....
	encryptedPassword, _ := bcrypt.GenerateFromPassword([]byte(req.Password), 6)
	password = string(encryptedPassword)

	//------------------------------------------------------------------------//
	//--------create secret key for this user details in redissss ------------//
	//-----------------------------------------------------------------------//

	redisClient, Rediserr := redis.NewRedisClient()
	if Rediserr != nil {
		log.Fatal("Failed to connect", zap.Error(Rediserr))
	}
	defer redisClient.Close()

	//----------------- store main data -----------------------------------------------------------------------------

	userBytes, err := json.Marshal(UserDetailsForRedis{
		UserName:    req.UserName,
		Email:       req.Email,
		PhoneNumber: req.PhoneNumber,
		Password:    password,
		FirstName:   req.FirstName,
		LastName:    req.LastName,
	})
	if err != nil {
		log.Printf("failed to marshal main user data:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	secretKey := generateSecretKey(c)

	err = redisClient.SetJSONInFolder(c, "otp", secretKey, userBytes, 30*time.Minute) //** creating redis **//
	if err != nil {
		log.Printf("failed to store main user data in redis:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	//----------------- store email data ------------------------------------------------------------------------------

	emailOTP := SignUpOTP{
		MainSecretKey: secretKey,
		Otp:           generateOTP(c),
		Attempts:      3,
		ExpireAt:      time.Now().Add(5 * time.Minute).Unix(),
	}
	emailBytes, err := json.Marshal(emailOTP)
	if err != nil {
		log.Printf("failed to marshal email otp data:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	emailsecretKey := generateSecretKey(c)

	err = redisClient.SetJSONInFolder(c, "otp", emailsecretKey, emailBytes, 5*time.Minute) //** creating redis **//
	if err != nil {
		log.Printf("failed to store email otp data in redis:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	return &emailsecretKey, nil

}

func (uc *authUseCaseImpl) VerifySignUpOTP(c *gin.Context, req domain.VerifyOTPEmailAndPhoneNumber) (*string, *exceptions.Exception) {
	var resp *string
	redisClient, err := redis.NewRedisClient()
	if err != nil {
		log.Fatal("Failed to connect", zap.Error(err))
	}
	defer redisClient.Close()

	switch req.Type {
	case 1:
		///////////////////////////////////////////// GET EMAIL DETAILS //////////////////////////////////////////////////////////////

		bytess, err := redisClient.GetJSONFromFolder(c, "otp", req.SecretKey)
		if err != nil {
			log.Printf("failed to retriev otp data from redis:Error:%v", err)
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}

		if bytess == nil {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "otp expired")
		}

		var emailOTP SignUpOTP
		err = json.Unmarshal(bytess, &emailOTP)
		if err != nil {
			log.Printf("failed to unmarshal otp data:Error:%v", err)
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}

		////////////////////////////////////////////////// CHECK EMAIL OTP //////////////////////////////////////////////////////////////
		if emailOTP.Attempts <= 0 {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "maximum attempts exceeded")
		}

		date := time.Unix(emailOTP.ExpireAt, 0)
		if date.Before(time.Now()) {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "otp expired")

		}

		if emailOTP.Otp != req.OTP {
			emailOTP.Attempts--

			err = redisClient.Del(c, fmt.Sprintf("otp:%s", req.SecretKey))
			if err != nil {
				log.Printf("failed to delete otp data from redis:Error:%v", err)
				return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
			}
			otpByt, _ := json.Marshal(emailOTP)
			err := redisClient.SetJSONInFolder(c, "otp", req.SecretKey, otpByt, time.Until(time.Unix(emailOTP.ExpireAt, 0)))
			if err != nil {
				log.Printf("failed to update otp data in redis:Error:%v", err)
				return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
			}

			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "otp is invalid")
		}
		////////////////////////////////// CREATE PHONE SECRET KEY ///////////////////////////////////////////////////////////
		phoneDetails := SignUpOTP{
			MainSecretKey: emailOTP.MainSecretKey,
			Otp:           generateOTP(c),
			Attempts:      3,
			ExpireAt:      time.Now().Add(5 * time.Minute).Unix(),
		}
		phoneBytes, err := json.Marshal(phoneDetails)
		if err != nil {
			log.Printf("failed to marshal email otp data:Error:%v", err)
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}

		phonesecretKey := generateSecretKey(c)
		//** creating redis **//
		err = redisClient.SetJSONInFolder(c, "otp", phonesecretKey, phoneBytes, 5*time.Minute) //** creating redis **
		if err != nil {
			log.Printf("failed to store email otp data in redis:Error:%v", err)
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}
		resp = &phonesecretKey

	case 2:
		///////////////////////////////////////////// GET PHONE DETAILS //////////////////////////////////////////////////////////////
		var phoneOTP SignUpOTP

		bytess, err := redisClient.GetJSONFromFolder(c, "otp", req.SecretKey)
		if err != nil {
			log.Printf("failed to retriev otp data from redis:Error:%v", err)
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}

		if bytess == nil {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "otp expired")
		}

		err = json.Unmarshal(bytess, &phoneOTP)
		if err != nil {
			log.Printf("failed to unmarshal otp data:Error:%v", err)
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}

		////////////////////////////////////////////////// CHECK PHONE OTP //////////////////////////////////////////////////////////////
		if phoneOTP.Attempts <= 0 {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "maximum attempts exceeded")
		}

		date := time.Unix(phoneOTP.ExpireAt, 0)
		if date.Before(time.Now()) {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "otp expired")
		}

		if phoneOTP.Otp != req.OTP {
			phoneOTP.Attempts--

			err = redisClient.Del(c, fmt.Sprintf("otp:%s", req.SecretKey))
			if err != nil {
				log.Printf("failed to delete otp data from redis:Error:%v", err)
				return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
			}
			otpByt, _ := json.Marshal(phoneOTP)
			err := redisClient.SetJSONInFolder(c, "otp", req.SecretKey, otpByt, time.Until(time.Unix(phoneOTP.ExpireAt, 0)))
			if err != nil {
				log.Printf("failed to update otp data in redis:Error:%v", err)
				return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
			}

			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "otp is invalid")
		}

		respone, SignUperr := uc.SignUp(c, domain.SignUpRequest{
			SecretKey: phoneOTP.MainSecretKey,
		})
		if SignUperr != nil {
			return nil, SignUperr
		}
		resp = respone

	}

	err = redisClient.Del(c, fmt.Sprintf("otp:%s", req.SecretKey))
	if err != nil {
		log.Printf("failed to delete otp data from redis:Error:%v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}
	return resp, nil
}

func (uc *authUseCaseImpl) SignUp(c *gin.Context, req domain.SignUpRequest) (*string, *exceptions.Exception) {
	var status exceptions.ErrorCode

	resp := "successful signup"

	err := sqlc.ExecuteTxWithException(c, uc.pool, func(q sqlc.Querier) *exceptions.Exception {

		redisClient, err := redis.NewRedisClient()
		if err != nil {
			log.Fatal("Failed to connect", zap.Error(err))
		}
		defer redisClient.Close()

		bytess, err := redisClient.GetJSONFromFolder(c, "otp", req.SecretKey)
		if err != nil {
			log.Printf("failed to retrieve user data from redis:Error:%v", err)
			status = exceptions.BadRequestErrorCode
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}

		if bytess == nil {
			status = exceptions.BadRequestErrorCode
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "session expired")
		}

		var otpData UserDetailsForRedis
		err = json.Unmarshal(bytess, &otpData)
		if err != nil {
			status = exceptions.SomethingWentWrongErrorCode
			log.Printf("failed to unmarshal user details for creatig user and profile:Error:%v", err)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}

		address, er := uc.repo.CreateAddress(c, sqlc.CreateAddressParams{
			CountriesID:      pgtype.Int8{Int64: 1, Valid: true},
			StatesID:         pgtype.Int8{},
			CitiesID:         pgtype.Int8{},
			CommunitiesID:    pgtype.Int8{},
			SubCommunitiesID: pgtype.Int8{},
			LocationsID:      pgtype.Int8{},
		}, q)
		if er != nil {
			status = exceptions.SomethingWentWrongErrorCode
			return er
		}

		user, er := uc.repo.CreateSignUpUser(c, sqlc.CreateSignUpUserParams{
			Email:           otpData.Email,
			Username:        otpData.UserName,
			Password:        otpData.Password,
			Status:          1,
			RolesID:         pgtype.Int8{},
			UserTypesID:     3,
			SocialLogin:     pgtype.Text{},
			ShowHideDetails: pgtype.Bool{Bool: false, Valid: true},
			ExperienceSince: pgtype.Timestamptz{},
			IsVerified:      pgtype.Bool{Bool: false, Valid: true},
			CreatedAt:       time.Now(),
			UpdatedAt:       time.Now(),
			PhoneNumber:     pgtype.Text{},
			IsPhoneVerified: pgtype.Bool{Bool: true, Valid: true},
			IsEmailVerified: pgtype.Bool{Bool: true, Valid: true},
		}, q)
		if er != nil {
			status = exceptions.SomethingWentWrongErrorCode
			log.Println("testing error, er:", err)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())
		}

		_, er = uc.repo.CreateProfile(c, sqlc.CreateProfileParams{
			FirstName:       otpData.FirstName,
			LastName:        otpData.LastName,
			AddressesID:     address.ID,
			ProfileImageUrl: pgtype.Text{},

			SecondaryNumber:    pgtype.Text{},
			WhatsappNumber:     pgtype.Text{},
			ShowWhatsappNumber: pgtype.Bool{Bool: false, Valid: true},
			BotimNumber:        pgtype.Text{},
			ShowBotimNumber:    pgtype.Bool{Bool: false, Valid: true},
			TawasalNumber:      pgtype.Text{},
			ShowTawasalNumber:  pgtype.Bool{Bool: false, Valid: true},

			CreatedAt:        time.Now(),
			UpdatedAt:        time.Now(),
			RefNo:            utils.GenerateReferenceNumber(constants.PROFILE),
			CoverImageUrl:    pgtype.Text{},
			PassportNo:       pgtype.Text{},
			PassportImageUrl: pgtype.Text{},
			About:            pgtype.Text{},
			AboutArabic:      pgtype.Text{},
			UsersID:          user.ID,
		}, q)
		if er != nil {
			return er
		}
		err = redisClient.Del(c, fmt.Sprintf("otp:%s", req.SecretKey))
		if err != nil {
			status = exceptions.SomethingWentWrongErrorCode
			log.Printf("failed to delete otp data from redis:Error:%v", err)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}

		return nil
	})

	if err != nil {
		log.Println("testing error :::")
		resp = " error with signing up"
		return &resp, exceptions.GetExceptionByErrorCodeWithCustomMessage(status, err.Error())
	}

	return &resp, nil
}

// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
type TokenData struct {
	AccessToken string `json:"access_token"`
	Scope       string `json:"scope"`
	TokenType   string `json:"Bearer"`
	ExpiresIn   int64  `json:"expires_in"`
}

type UserData struct {
	// UUID          string   `json:"uuid"`
	// Sub           string   `json:"sub"`
	// FullNameAR    string   `json:"fullnameAR"`
	// FirstNameAR   string   `json:"firstnameAR"`
	// LastNameAR    string   `json:"lastnameAR"`
	// FullNameEN    string   `json:"fullnameEN"`
	FirstNameEN string `json:"firstnameEN"`
	LastNameEN  string `json:"lastnameEN"`
	Mobile      string `json:"mobile"`
	Email       string `json:"email"`
	// UserType      string   `json:"userType"`
	// NationalityAR string   `json:"nationalityAR"`
	NationalityEN string `json:"nationalityEN"`
	// SPUUID        string   `json:"spuuid"`
	// ACR           string   `json:"acr"`
	// TitleEN       string   `json:"titleEN"`
	// TitleAR       string   `json:"titleAR"`
	// AMR           []string `json:"amr"`

	// Citizen/Resident Profile
	Gender string `json:"gender"`
	// IDNumber string `json:"idn"`
	// IDType   string `json:"idType"`

	// Visitor Profile
	// UnifiedID   string `json:"unifiedID"`
	// ProfileType string `json:"profileType"`
}
type BadReqError struct {
	ErrorDescription string `json:"error_description"`
	Error            string `json:"error"`
}

// UAEPassLogin implements AuthUseCase.
func (au *authUseCaseImpl) UAEPassLogin(c *gin.Context, req domain.UAEPassLoginReq) (*response.DashboardResult, *exceptions.Exception) {
	var output response.DashboardResult
	var user sqlc.PlatformUser
	var tokenData TokenData
	err := getToken(c, req, &tokenData)
	if err != nil {
		log.Printf("failed to getToken Error:%v", err)
		return nil, err
	}

	var userData UserData
	er := getUserInfo(c, tokenData, &userData)
	if er != nil {
		log.Printf("failed to getUserInfo Error:%v", er)
		return nil, er
	}

	user, err = au.repo.GetPlatformUserByEmailAndCompanyID(c, sqlc.GetPlatformUserByEmailAndCompanyIDParams{
		Email: userData.Email,
		CompanyID: pgtype.Int8{
			Int64: req.CompanyID,
			Valid: req.CompanyID != 0,
		},
		ActiveUser: constants.ActivePlatformUserStatus.Int64(),
	})

	if err != nil && err.ErrorCode == exceptions.NoDataFoundErrorCode {

		var gender pgtype.Int8
		if userData.Gender != "" {
			if strings.EqualFold(userData.Gender, constants.MaleGender.Name()) {
				gender = pgtype.Int8{Int64: constants.MaleGender.Int64(), Valid: true}
			} else {
				gender = pgtype.Int8{Int64: constants.FemaleGender.Int64(), Valid: true}
			}
		}

		var status exceptions.ErrorCode
		trxErr := sqlc.ExecuteTx(c, au.pool, func(q *sqlc.Queries) error {

			address, err := au.repo.CreateAddress(c, sqlc.CreateAddressParams{
				CountriesID:      pgtype.Int8{Int64: req.CountryID, Valid: true}, //  by default address is UAE
				StatesID:         pgtype.Int8{},
				CitiesID:         pgtype.Int8{},
				CommunitiesID:    pgtype.Int8{},
				SubCommunitiesID: pgtype.Int8{},
				LocationsID:      pgtype.Int8{},
			}, q)

			if err != nil {
				status = err.ErrorCode
				return err
			}

			// encrypted password ....
			encryptedPassword, _ := bcrypt.GenerateFromPassword([]byte("123456"), 6) // default password
			password := string(encryptedPassword)

			var phone, countryCode int
			if userData.Mobile != "" {
				// Split the number
				cc := userData.Mobile[:3] // First 3 digits
				ph := userData.Mobile[3:] // Remaining digits

				countryCode, _ = strconv.Atoi(cc)
				phone, _ = strconv.Atoi(ph)
			}

			usr, err := au.repo.CreatePlatformUser(c, sqlc.CreatePlatformUserParams{
				CompanyID: pgtype.Int8{
					Int64: req.CompanyID,
					Valid: req.CompanyID != 0,
				},
				Username: userData.Email,
				Email:    userData.Email,
				Password: password,
				CountryCode: pgtype.Text{
					String: fmt.Sprintf("%d", countryCode),
					Valid:  phone != 0,
				},
				PhoneNumber: pgtype.Int8{Int64: int64(phone), Valid: phone != 0},
				FirstName: pgtype.Text{
					String: userData.FirstNameEN,
					Valid:  userData.FirstNameEN != "",
				},
				LastName: pgtype.Text{
					String: userData.LastNameEN,
					Valid:  userData.LastNameEN != "",
				},
				AddressesID: address.ID,
				Status:      constants.ActivePlatformUserStatus.Int64(),
				SocialLogin: pgtype.Text{
					String: constants.UAEPassSocialLoginType.Name(),
					Valid:  true,
				},
				Gender: gender,
				IsEmailVerified: pgtype.Bool{
					Bool:  true,
					Valid: true,
				},
			}, q)
			// usr, err := au.repo.CreateSignUpUser(c, sqlc.CreateSignUpUserParams{
			// 	Email:    userData.Email,
			// 	Username: userData.Email,
			// 	Password: password,
			// 	Status:   constants.DraftStatus.Int64(),
			// 	RolesID:  pgtype.Int8{},
			// 	PhoneNumber: pgtype.Text{
			// 		String: userData.Mobile,
			// 		Valid:  userData.Mobile != "",
			// 	},
			// 	UserTypesID: constants.OwnerOrIndividualUserTypes.Int64(), // by default this user will be register as an individual/owner as per analysis
			// 	SocialLogin: pgtype.Text{
			// 		String: constants.UAEPassSocialLoginType.Name(),
			// 		Valid:  true,
			// 	},
			// 	ShowHideDetails: pgtype.Bool{Bool: false, Valid: true},
			// 	ExperienceSince: pgtype.Timestamptz{},
			// 	IsVerified:      pgtype.Bool{Bool: false, Valid: true},
			// 	CreatedAt:       time.Now().Round(time.Second),
			// 	UpdatedAt:       time.Time{},
			// 	IsEmailVerified: pgtype.Bool{Bool: true, Valid: true},
			// 	IsPhoneVerified: pgtype.Bool{Bool: true, Valid: true},
			// }, q)
			if err != nil {
				status = err.ErrorCode
				return err
			}
			user = *usr

			// profile, err := au.repo.CreateProfile(c, sqlc.CreateProfileParams{
			// 	FirstName:          userData.FirstNameEN,
			// 	LastName:           userData.LastNameEN,
			// 	AddressesID:        address.ID,
			// 	ProfileImageUrl:    pgtype.Text{},
			// 	SecondaryNumber:    pgtype.Text{},
			// 	WhatsappNumber:     pgtype.Text{},
			// 	ShowWhatsappNumber: pgtype.Bool{},
			// 	BotimNumber:        pgtype.Text{},
			// 	ShowBotimNumber:    pgtype.Bool{},
			// 	TawasalNumber:      pgtype.Text{},
			// 	ShowTawasalNumber:  pgtype.Bool{},
			// 	Gender:             gender,
			// 	CreatedAt:          time.Now().Round(time.Second),
			// 	UpdatedAt:          time.Time{},
			// 	RefNo:              utils.GenerateReferenceNumber(constants.PROFILE),
			// 	CoverImageUrl:      pgtype.Text{},
			// 	PassportNo:         pgtype.Text{},
			// 	PassportImageUrl:   pgtype.Text{},
			// 	PassportExpiryDate: pgtype.Timestamptz{},
			// 	About:              pgtype.Text{},
			// 	AboutArabic:        pgtype.Text{},
			// 	UsersID:            usr.ID,
			// }, q)
			// if err != nil {
			// 	status = err.ErrorCode
			// 	return err
			// }

			// TODO: FIX THE AFTER FINISH THE PROJECT
			token, er := au.tokenMaker.CreateToken(user.Username, 100*24*time.Hour)
			// accesssecurity. err := au.tokenMaker.Createsecurity.user.Username, 100*24*time.Hour)
			if er != nil {
				status = exceptions.SomethingWentWrongErrorCode
				middleware.IncrementServerErrorCounter(fmt.Errorf("[SocialLogin.uc.CreateToken. error:%v", er).Error())
				return exceptions.GetExceptionByErrorCode(status)
			}

			country_code_output, _ := strconv.ParseInt(user.CountryCode.String, 10, 64)
			output = response.DashboardResult{
				UserID:         user.ID,
				FirstName:      user.FirstName.String,
				LastName:       user.LastName.String,
				Token:          token,
				Email:          user.Email,
				UserName:       user.Username,
				ProfilePicture: user.ProfileImageUrl.String,
				PhoneNumber:    fmt.Sprintf("%d", user.PhoneNumber.Int64),
				HaveCompany:    user.CompanyID.Int64 != 0,
				ActiveCompany:  user.CompanyID.Int64,
				CountryCode:    country_code_output,
				Gender:         user.Gender.Int64,
				Nationality:    user.Nationality.Int64,
				// IsCompanyVerified: isVerified,
				UserType: 0,
				// SectionPermission: <-processedPermission,
			}

			return nil
		})

		if trxErr != nil {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(status, trxErr.Error())
		}
	}

	if user.SocialLogin.String != constants.UAEPassSocialLoginType.Name() {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "user already exists")
	}
	if !user.IsEmailVerified.Bool {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.UserNotAuthorizedErrorCode, "not authorized")
	}
	// TODO: FIX THE AFTER FINISH THE PROJECT
	token, e := au.tokenMaker.CreateToken(user.Username, 100*24*time.Hour)
	// accesssecurity. err := au.tokenMaker.Createsecurity.user.Username, 100*24*time.Hour)
	if e != nil {
		middleware.IncrementServerErrorCounter(fmt.Errorf("[SocialLogin.uc.CreateToken. error:%v", e).Error())
		return nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}

	//profile, _ := au.repo.GetProfileByUserId(c, user.ID)
	country_code_output, _ := strconv.ParseInt(user.CountryCode.String, 10, 64)

	output = response.DashboardResult{
		UserID:         user.ID,
		FirstName:      user.FirstName.String,
		LastName:       user.LastName.String,
		Token:          token,
		Email:          user.Email,
		UserName:       user.Username,
		ProfilePicture: user.ProfileImageUrl.String,
		PhoneNumber:    fmt.Sprintf("%d", user.PhoneNumber.Int64),
		HaveCompany:    user.CompanyID.Int64 != 0,
		ActiveCompany:  user.CompanyID.Int64,
		Gender:         user.Gender.Int64,
		Nationality:    user.Nationality.Int64,
		// IsCompanyVerified: isVerified,
		UserType:    0,
		CountryCode: country_code_output,
		// SectionPermission: <-processedPermission,
	}

	return &output, nil
}

func getToken(c *gin.Context, req domain.UAEPassLoginReq, dest *TokenData) *exceptions.Exception {

	params := url.Values{}
	params.Add("grant_type", "authorization_code")
	params.Add("redirect_uri", req.RedirectUri)
	params.Add("code", req.Code)

	requestURL := fmt.Sprintf("%s?%s", constants.UAEPASS_TOKEN_EXCHANGE_API_URL, params.Encode())
	httpReq, err := http.NewRequestWithContext(c, http.MethodPost, requestURL, nil)
	if err != nil {
		log.Printf("failed to request for token:%v", err)
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	httpReq.Header.Set("Authorization", fmt.Sprintf("Basic %s", constants.UAEPASS_AUTH_CREDENTIAL))
	httpReq.Header.Set("Content-Type", "multipart/form-data")

	response, err := http.DefaultClient.Do(httpReq)
	if err != nil {
		log.Printf("failed to get response from client: %v", err)
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}
	defer response.Body.Close()

	if response.StatusCode != http.StatusOK {
		log.Printf("Error: received status code %d", response.StatusCode)
	}

	bodyByte, err := io.ReadAll(response.Body)
	if err != nil {
		log.Printf("failed to read response body:%v", err)
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	switch response.StatusCode {
	case http.StatusOK:
		err = json.Unmarshal(bodyByte, dest)
		if err != nil {
			log.Printf("failed to unmarshal response body:%v", err)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}
	case http.StatusBadRequest:
		var er BadReqError
		err = json.Unmarshal(bodyByte, &er)
		if err != nil {
			log.Printf("failed to unmarshal response body:%v", err)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, er.ErrorDescription)
	case http.StatusUnauthorized:
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.UserNotAuthorizedErrorCode, "unauthorized")
	default:
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, string(bodyByte))
	}

	return nil
}

func getUserInfo(c *gin.Context, tokenData TokenData, dest *UserData) *exceptions.Exception {

	httpReq, err := http.NewRequestWithContext(c, http.MethodGet, constants.UAEPASS_USER_INFO_API_URL, nil)
	if err != nil {
		log.Printf("failed to request for userinfo:%v", err)
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	httpReq.Header.Set("Authorization", fmt.Sprintf("Bearer %s", tokenData.AccessToken))

	response, err := http.DefaultClient.Do(httpReq)
	if err != nil {
		log.Printf("failed to get response from client: %v", err)
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}
	defer response.Body.Close()

	if response.StatusCode != http.StatusOK {
		log.Printf("Error: received status code %d", response.StatusCode)
	}

	bodyByte, err := io.ReadAll(response.Body)
	if err != nil {
		log.Printf("failed to read response body:%v", err)
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	switch response.StatusCode {
	case http.StatusOK:
		err = json.Unmarshal(bodyByte, dest)
		if err != nil {
			log.Printf("failed to unmarshal response body:%v", err)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}
	case http.StatusBadRequest:
		var er BadReqError
		err = json.Unmarshal(bodyByte, &er)
		if err != nil {
			log.Printf("failed to unmarshal response body:%v", err)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, er.ErrorDescription)
	case http.StatusUnauthorized:
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.UserNotAuthorizedErrorCode, "unauthorized")
	default:
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, string(bodyByte))
	}

	return nil
}
