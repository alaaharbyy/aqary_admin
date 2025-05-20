package auth_usecase

import (
	"aqary_admin/config"
	"aqary_admin/internal/delivery/rest/middleware"
	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/old_repo/model"
	"aqary_admin/pkg/utils/constants"
	"aqary_admin/pkg/utils/exceptions"
	"fmt"
	"log"
	"strconv"
	"time"

	"github.com/Timothylock/go-signin-with-apple/apple"
	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"golang.org/x/crypto/bcrypt"
)

func (au authUseCaseImpl) AppleLogin(c *gin.Context, req domain.AppleLoginReq) (*response.DashboardResult, *exceptions.Exception) {

	var clientID string
	var secretKey string
	var appleTeamId string
	var appleKeyId string

	if req.CompanyID == 2 {
		clientID = config.AppConfig.AppleClientIDInvestment
		secretKey = config.AppConfig.ApplePrivateKeyInvestment
		appleTeamId = config.AppConfig.AppleTeamIDInvestment
		appleKeyId = config.AppConfig.AppleKeyIDInvestment
	} else if req.CompanyID == 1 {
		clientID = config.AppConfig.AppleClientIDFineHome
		secretKey = config.AppConfig.ApplePrivateKeyFineHome
		appleTeamId = config.AppConfig.AppleTeamIDFineHome
		appleKeyId = config.AppConfig.AppleKeyIDFineHome
	} else {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "company does not exist")
	}

	secret, err := apple.GenerateClientSecret(secretKey, appleTeamId, clientID, appleKeyId)

	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "Authentication service is unavailable. Please try again later.")
	}

	client := apple.New()

	request := apple.AppValidationTokenRequest{
		ClientID:     clientID,
		ClientSecret: secret,
		Code:         req.Code,
	}

	var resp apple.ValidationResponse

	// Do the verification
	err = client.VerifyAppToken(c, request, &resp)
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.UserNotAuthorizedErrorCode, "Invalid authentication credentials. Please sign in again.")
	}
	// Get the unique user ID
	userId, err := apple.GetUniqueID(resp.IDToken)
	fmt.Println(userId)

	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.UserNotAuthorizedErrorCode, "Unable to verify your identity. Please sign in again.")
	}

	// Get the email
	claim, err := apple.GetClaims(resp.IDToken)
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.UserNotAuthorizedErrorCode, "Failed to retrieve account information. Please try again.")
	}

	email, ok := (*claim)["email"].(string)
	if !ok || email == "" {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "Unable to retrieve your email. Please ensure your Apple ID is properly configured.")
	}

	user, err2 := au.repo.GetPlatformUserByEmailAndCompanyID(c, sqlc.GetPlatformUserByEmailAndCompanyIDParams{
		Email:      email,
		CompanyID:  pgtype.Int8{Int64: req.CompanyID, Valid: req.CompanyID != 0},
		ActiveUser: constants.ActivePlatformUserStatus.Int64(),
	})

	if err2 != nil && err2.ErrorCode != exceptions.NoDataFoundErrorCode {
		log.Printf("failed to check user by email: %v", err2)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "encountered an issue while trying to log in")

	}

	var result response.DashboardResult

	if err2 != nil && err2.ErrorCode == exceptions.NoDataFoundErrorCode {
		log.Println("user not found by email, create new user")

		var status exceptions.ErrorCode

		// encrypted password ....
		encryptedPassword, _ := bcrypt.GenerateFromPassword([]byte("123456"), 6) // default password
		password := string(encryptedPassword)

		trxErr := sqlc.ExecuteTx(c, au.pool, func(q *sqlc.Queries) error {

			address, err := au.repo.CreateAddress(c, sqlc.CreateAddressParams{
				CountriesID: pgtype.Int8{Int64: req.CountryID, Valid: true}, //  by default address is UAE
			}, q)

			if err != nil {
				status = err.ErrorCode
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "encountered an issue while trying to log in")
			}

			user, err := au.repo.CreatePlatformUser(c, sqlc.CreatePlatformUserParams{
				CompanyID: pgtype.Int8{
					Int64: req.CompanyID,
					Valid: req.CompanyID != 0,
				},
				Username:    email,
				Email:       email,
				Password:    password,
				CountryCode: pgtype.Text{},
				PhoneNumber: pgtype.Int8{},
				AddressesID: address.ID,
				Status:      constants.ActivePlatformUserStatus.Int64(),
				SocialLogin: pgtype.Text{
					String: constants.AppleSocialLoginType.Name(),
					Valid:  true,
				},
				IsEmailVerified: pgtype.Bool{
					Bool:  true,
					Valid: true,
				},
			}, q)

			if err != nil {
				status = err.ErrorCode
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "encountered an issue while trying to log in")
			}

			result = response.DashboardResult{
				UserID:              user.ID,
				FirstName:           user.FirstName.String,
				LastName:            user.LastName.String,
				Email:               email,
				UserName:            user.Username,
				ProfilePicture:      user.ProfileImageUrl.String,
				IsCompanyVerified:   false,
				SectionPermission:   nil,
				ActiveCompany:       user.CompanyID.Int64,
				AssociatedCompanies: []model.CustomFormat{},
			}
			return nil
		})

		if trxErr != nil {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(status, trxErr.Error())
		}
	} else {
		log.Println("user found by email")

		if user.SocialLogin.String != constants.AppleSocialLoginType.Name() {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "user already exists")
		}
		if !user.IsEmailVerified.Bool {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.UserNotAuthorizedErrorCode, "not authorized")
		}

		var countryCode int
		// Split the number
		if user.PhoneNumber.Valid {
			cc := user.CountryCode.String[:3] // First 3 digits

			countryCode, _ = strconv.Atoi(cc)
		}

		result = response.DashboardResult{
			UserID:              user.ID,
			FirstName:           user.FirstName.String,
			LastName:            user.LastName.String,
			Email:               user.Email,
			UserName:            user.Username,
			ProfilePicture:      user.ProfileImageUrl.String,
			CountryCode:         int64(countryCode),
			PhoneNumber:         fmt.Sprintf("%d", user.PhoneNumber.Int64),
			HaveCompany:         user.CompanyID.Valid,
			IsCompanyVerified:   false,
			SectionPermission:   nil,
			ActiveCompany:       user.CompanyID.Int64,
			AssociatedCompanies: []model.CustomFormat{},
			Gender:              user.Gender.Int64,
			Nationality:         user.Nationality.Int64,
		}
	}

	token, e := au.tokenMaker.CreateToken(user.Username, 100*24*time.Hour)
	// accesssecurity. err := au.tokenMaker.Createsecurity.user.Username, 100*24*time.Hour)
	if e != nil {
		middleware.IncrementServerErrorCounter(fmt.Errorf("[AppleLogin.uc.CreateToken. error:%v", e).Error())
		return nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}

	result.Token = token

	return &result, nil
}
