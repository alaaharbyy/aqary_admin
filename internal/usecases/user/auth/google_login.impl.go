package auth_usecase

import (
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

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"golang.org/x/crypto/bcrypt"
	"google.golang.org/api/idtoken"
)

func (au authUseCaseImpl) GoogleLogin(c *gin.Context, req domain.GoogleLoginReq) (*response.DashboardResult, *exceptions.Exception) {
	result := response.DashboardResult{}
	// req.ClientID = "412833542545-8p41ur4rnnrru4128suorgrcqvc84ram.apps.googleusercontent.com"
	// req.CountryID = 1
	// req.CompanyID = 1
	resp, err := handleGoogleAuth(c, req)
	if err != nil {
		return nil, err
	}

	email := safeString(resp["email"])
	firstName := safeString(resp["given_name"])
	lastName := safeString(resp["family_name"])
	picture := safeString(resp["picture"])
	//isEmailVerified := safeBool(resp["email_verified"])

	result.FirstName = firstName
	result.LastName = lastName
	result.Email = email
	result.ProfilePicture = picture

	user, err := au.repo.GetPlatformUserByEmailAndCompanyID(c, sqlc.GetPlatformUserByEmailAndCompanyIDParams{
		Email:      email,
		CompanyID:  pgtype.Int8{Int64: req.CompanyID, Valid: req.CompanyID != 0},
		ActiveUser: constants.ActivePlatformUserStatus.Int64(),
	})
	if err != nil && err.ErrorCode != exceptions.NoDataFoundErrorCode {
		log.Printf("failed to check user by email: %v", err)
		return nil, err
	}

	result.UserID = user.ID
	//result.UserType = user.UserTypesID
	result.UserName = email

	if err != nil && err.ErrorCode == exceptions.NoDataFoundErrorCode {
		log.Println("user not found by email, create new user")
		// by default this user will be register as an individual/owner as per analysis

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
				return err
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
				FirstName: pgtype.Text{
					String: firstName,
					Valid:  firstName != "",
				},
				LastName: pgtype.Text{
					String: lastName,
					Valid:  lastName != "",
				},
				AddressesID: address.ID,
				Status:      constants.ActivePlatformUserStatus.Int64(),
				SocialLogin: pgtype.Text{
					String: constants.GoogleSocialLoginType.Name(),
					Valid:  true,
				},
				IsEmailVerified: pgtype.Bool{
					Bool:  true,
					Valid: true,
				},
			}, q)

			if err != nil {
				status = err.ErrorCode
				return err
			}

			// profile, err := au.repo.CreateProfile(c, sqlc.CreateProfileParams{
			// 	FirstName:          firstName,
			// 	LastName:           lastName,
			// 	AddressesID:        address.ID,
			// 	ProfileImageUrl:    pgtype.Text{String: picture, Valid: picture != ""},
			// 	ShowWhatsappNumber: pgtype.Bool{},
			// 	ShowBotimNumber:    pgtype.Bool{},
			// 	ShowTawasalNumber:  pgtype.Bool{},
			// 	CreatedAt:          time.Now().Round(time.Second),
			// 	RefNo:              utils.GenerateReferenceNumber(constants.PROFILE),
			// 	UsersID:            user.ID,
			// }, q)

			// if err != nil {
			// 	status = err.ErrorCode
			// 	return err
			// }

			result.UserID = user.ID
			//result.UserType = user.UserTypesID
			result.UserName = email

			result.Gender = user.Gender.Int64
			result.Nationality = user.Nationality.Int64

			// _, err = au.repo.CreateProfileNationalities(c, sqlc.CreateProfileNationalitiesParams{
			// 	ProfilesID: profile.ID,
			// 	CountryID:  1, // by default UAE nationalities
			// }, q)
			// if err != nil {
			// 	status = err.ErrorCode
			// 	return err
			// }

			return nil
		})

		if trxErr != nil {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(status, trxErr.Error())
		}

	} else {
		log.Println("user found by email")

		if user.SocialLogin.String != constants.GoogleSocialLoginType.Name() {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "user already exists")
		}
		if !user.IsEmailVerified.Bool {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.UserNotAuthorizedErrorCode, "not authorized")
		}
		// profile, err := au.repo.GetProfileByUserId(c, user.ID)
		// if err != nil && err.ErrorCode != exceptions.NoDataFoundErrorCode {
		// 	log.Printf("failed to check user by email: %v", err)
		// 	return nil, err
		// }
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

	// TODO: FIX THE AFTER FINISH THE PROJECT
	token, e := au.tokenMaker.CreateToken(user.Username, 100*24*time.Hour)
	// accesssecurity. err := au.tokenMaker.Createsecurity.user.Username, 100*24*time.Hour)
	if e != nil {
		middleware.IncrementServerErrorCounter(fmt.Errorf("[GoogleLogin.uc.CreateToken. error:%v", e).Error())
		return nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}

	result.Token = token

	return &result, nil
}

func handleGoogleAuth(c *gin.Context, req domain.GoogleLoginReq) (map[string]interface{}, *exceptions.Exception) {

	payload, err := verifyGoogleIDToken(c, req.IDToken, req.ClientID)
	if err != nil {
		log.Printf("Failed to verify ID token: %v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.InvalidCredentialsErrorCode, "Invalid ID token")
	}

	response := map[string]interface{}{
		"email":          payload.Claims["email"],
		"name":           payload.Claims["name"],
		"picture":        payload.Claims["picture"],
		"sub":            payload.Subject,
		"email_verified": payload.Claims["email_verified"],
		"family_name":    payload.Claims["family_name"],
		"given_name":     payload.Claims["given_name"],
		"message":        "Successfully authenticated",
	}

	return response, nil
}

func verifyGoogleIDToken(ctx *gin.Context, idToken string, client_id string) (*idtoken.Payload, error) {
	validator, err := idtoken.NewValidator(ctx)
	if err != nil {
		return nil, err
	}

	payload, err := validator.Validate(ctx, idToken, client_id)
	if err != nil {
		return nil, err
	}

	return payload, nil
}
