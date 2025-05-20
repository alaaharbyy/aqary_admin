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
	"context"
	"encoding/json"
	"fmt"
	"log"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"golang.org/x/crypto/bcrypt"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/facebook"
)

// Facebook Secrets
var facebookOAuthConfig = &oauth2.Config{
	ClientID:     config.AppConfig.FACEBOOK_ClIENTID,
	ClientSecret: config.AppConfig.FACEBOOK_ClIENTSECRET,
	Endpoint:     facebook.Endpoint,
}

// FacebookLogin implements AuthUseCase.
func (uc *authUseCaseImpl) FacebookLogin(c *gin.Context, req domain.FacebookLoginReq) (*response.DashboardResult, *exceptions.Exception) {
	result := response.DashboardResult{}
	userData, err := fetchFacebookUser(req.IDToken)
	if err != nil {
		return nil, err
	}

	email := safeString(userData["email"])
	firstName := safeString(userData["name"])
	lastName := safeString(userData["name"])

	result.FirstName = firstName
	result.LastName = lastName
	result.Email = email

	pictureURL := ""
	if pictureData, ok := userData["picture"].(map[string]interface{}); ok {
		if data, ok := pictureData["data"].(map[string]interface{}); ok {
			if url, ok := data["url"].(string); ok {
				pictureURL = url
			}
		}
	}

	result.ProfilePicture = pictureURL

	user, err := uc.repo.GetPlatformUserByEmailAndCompanyID(c, sqlc.GetPlatformUserByEmailAndCompanyIDParams{
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

		trxErr := sqlc.ExecuteTx(c, uc.pool, func(q *sqlc.Queries) error {

			address, err := uc.repo.CreateAddress(c, sqlc.CreateAddressParams{
				CountriesID: pgtype.Int8{Int64: req.CountryID, Valid: true}, //  by default address is UAE
			}, q)

			if err != nil {
				status = err.ErrorCode
				return err
			}

			user, err := uc.repo.CreatePlatformUser(c, sqlc.CreatePlatformUserParams{
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
					String: constants.FacebookSocialLoginType.Name(),
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

		if user.SocialLogin.String != constants.FacebookSocialMedia.Name() {
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
	token, e := uc.tokenMaker.CreateToken(user.Username, 100*24*time.Hour)
	// accesssecurity. err := au.tokenMaker.Createsecurity.user.Username, 100*24*time.Hour)
	if e != nil {
		middleware.IncrementServerErrorCounter(fmt.Errorf("[GoogleLogin.uc.CreateToken. error:%v", e).Error())
		return nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}

	result.Token = token

	return &result, nil

}

func fetchFacebookUser(accessToken string) (map[string]interface{}, *exceptions.Exception) {
	ctx := context.Background()
	token := &oauth2.Token{AccessToken: accessToken}

	// Use OAuth2 client with the token
	client := facebookOAuthConfig.Client(ctx, token)

	// Fetch user info
	resp, err := client.Get("https://graph.facebook.com/me?fields=id,name,email,picture")
	if err != nil {
		log.Printf("Failed to verify ID token: %v", err)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.InvalidCredentialsErrorCode, "Invalid ID token")
	}
	defer resp.Body.Close()

	var user map[string]interface{}
	if err := json.NewDecoder(resp.Body).Decode(&user); err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.InvalidCredentialsErrorCode, "error decoding response")
	}

	return user, nil
}
