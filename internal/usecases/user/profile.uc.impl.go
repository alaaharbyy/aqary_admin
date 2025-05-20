package usecase

import (
	"log"
	"time"
	"unicode"

	"aqary_admin/internal/delivery/rest/middleware"
	domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	db "aqary_admin/pkg/db/user"
	"aqary_admin/pkg/utils/exceptions"
	file_utils "aqary_admin/pkg/utils/file"
	"aqary_admin/pkg/utils/security"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
	"golang.org/x/crypto/bcrypt"
)

type ProfileUseCase interface {
	CreateProfile(ctx *gin.Context, req domain.CreateProfileRequest) (*sqlc.Profile, *exceptions.Exception)
	GetAllProfiles(ctx *gin.Context, limit int32) ([]*sqlc.Profile, *exceptions.Exception)
	GetProfile(ctx *gin.Context, id int64) (*sqlc.Profile, *exceptions.Exception)
	UpdateProfile(ctx *gin.Context, req domain.UpdateProfileRequest) (*sqlc.Profile, *exceptions.Exception)
	DeleteProfile(ctx *gin.Context, id int64) (*string, *exceptions.Exception)
	UpdateProfilePassword(ctx *gin.Context, req domain.UpdateProfilePasswordRequest) (*string, *exceptions.Exception)
	GetOrganization(ctx *gin.Context, req domain.GetOrganizationReq) ([]sqlc.GetOrganizationRow, *exceptions.Exception)
}

type profileUseCase struct {
	repo       db.UserCompositeRepo
	pool       *pgxpool.Pool
	tokenMaker security.Maker
}

func NewProfileUseCase(profileRepo db.UserCompositeRepo, pool *pgxpool.Pool, token security.Maker) ProfileUseCase {
	return &profileUseCase{
		repo:       profileRepo,
		pool:       pool,
		tokenMaker: token,
	}
}

// DeleteProfile implements ProfileUseCase.
func (uc *profileUseCase) DeleteProfile(ctx *gin.Context, id int64) (*string, *exceptions.Exception) {

	_, err := uc.repo.GetProfile(ctx, id)
	if err != nil {
		return nil, err
	}
	return uc.repo.DeleteProfile(ctx, id)
}

// GetAllProfiles implements ProfileUseCase.
func (uc *profileUseCase) GetAllProfiles(ctx *gin.Context, limit int32) ([]*sqlc.Profile, *exceptions.Exception) {
	return uc.repo.GetAllProfile(ctx)
}

// GetProfile implements ProfileUseCase.
func (uc *profileUseCase) GetProfile(ctx *gin.Context, id int64) (*sqlc.Profile, *exceptions.Exception) {
	return uc.repo.GetProfile(ctx, id)
}

// UpdateProfile implements ProfileUseCase.
func (uc *profileUseCase) UpdateProfile(ctx *gin.Context, req domain.UpdateProfileRequest) (*sqlc.Profile, *exceptions.Exception) {
	// profile image
	var profileImage string
	var updatedprofile *sqlc.Profile
	payload := ctx.MustGet(middleware.AuthorizationPayloadKey).((*security.Payload))
	user, errVisitedUser := uc.repo.GetUserByName(ctx, payload.Username)
	if errVisitedUser != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "invalid user")
	}

	profile, errProfile := uc.repo.GetProfileByUserId(ctx, user.ID)
	if errProfile != nil {
		return nil, errProfile
	}

	//UPDAT PROFILE IMAGE
	image, errFile := ctx.FormFile("profile_image_url")
	if errFile != nil {
		log.Println("if profile image testing ..", errFile)
	}
	if errFile == nil {
		profileImage, errFile = file_utils.UploadSingleFileToABS(ctx, image, "auth")
		if errFile != nil {
			// middleware.IncrementServerErrorCounter(err.Error())
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, errFile.Error())
		}

	}
	if profileImage == "" {
		profileImage = profile.ProfileImageUrl.String
	}
	allErr := sqlc.ExecuteTxWithException(ctx, uc.pool, func(q sqlc.Querier) *exceptions.Exception {

		//UPDATE USER: ExperienceSince
		_, errUser := uc.repo.UpdateUser(ctx, sqlc.UpdateUserParams{
			ID:              user.ID,
			RolesID:         user.RolesID,
			ShowHideDetails: user.ShowHideDetails,
			ExperienceSince: pgtype.Timestamptz{Time: req.ExperienceSince, Valid: true},
			UpdatedAt:       time.Now(),
			PhoneNumber:     user.PhoneNumber,
			Username:        user.Username,
		}, q)
		if errUser != nil {
			return errUser
		}

		//UPDATE profile languages
		langs, err := uc.repo.GetLanguagesIDsByProfile(ctx, profile.ID, q)
		if err != nil {
			return err
		}
		langsToDelete, langsToAdd := compareArrays(langs, req.Language)
		if langsToDelete != nil {
			err := uc.repo.DeleteProfileLanguageList(ctx, sqlc.DeleteProfileLanguageListParams{
				ProfilesID:   profile.ID,
				LanguagesIds: langsToDelete,
			}, q)
			if err != nil {
				return err
			}
		}
		for _, lang := range langsToAdd {
			_, err := uc.repo.CreateProfileLanguage(ctx, sqlc.CreateProfileLanguageParams{
				ProfilesID:     profile.ID,
				AllLanguagesID: lang,
			}, q)
			if err != nil {
				return err
			}
		}

		//UPDATE profile nationalities
		nationalities, err := uc.repo.GetNationalitiesIDsByProfile(ctx, profile.ID, q)
		if err != nil {
			return err
		}
		natsToDelete, natsToAdd := compareArrays(nationalities, req.Nationality)

		if natsToDelete != nil {
			err := uc.repo.DeleteProfileNationalityList(ctx, sqlc.DeleteProfileNationalityListParams{
				ProfilesID: profile.ID,
				Countries:  natsToDelete,
			}, q)
			if err != nil {
				return err
			}
		}

		for _, nat := range natsToAdd {
			_, err := uc.repo.CreateProfileNationalities(ctx, sqlc.CreateProfileNationalitiesParams{
				ProfilesID: profile.ID,
				CountryID:  nat,
			}, q)
			if err != nil {
				return err
			}
		}

		updatedprofile, err = uc.repo.UpdateProfile(ctx, sqlc.UpdateProfileParams{
			ID:                 profile.ID,
			FirstName:          profile.FirstName,
			LastName:           profile.LastName,
			AddressesID:        profile.AddressesID,
			ProfileImageUrl:    pgtype.Text{String: profileImage, Valid: true},
			SecondaryNumber:    profile.SecondaryNumber,
			WhatsappNumber:     profile.WhatsappNumber,
			ShowWhatsappNumber: profile.ShowWhatsappNumber,
			BotimNumber:        profile.BotimNumber,
			ShowBotimNumber:    profile.ShowBotimNumber,
			TawasalNumber:      profile.TawasalNumber,
			ShowTawasalNumber:  profile.ShowTawasalNumber,
			Gender:             profile.Gender,
			UpdatedAt:          time.Now(),
			RefNo:              profile.RefNo,
			CoverImageUrl:      profile.CoverImageUrl,
			PassportNo:         profile.PassportNo,
			PassportImageUrl:   profile.PassportImageUrl,
			PassportExpiryDate: profile.PassportExpiryDate,
			About:              pgtype.Text{String: req.AboutMe, Valid: true},
			AboutArabic:        profile.AboutArabic,
		}, q)
		if err != nil {
			return err
		}

		return nil

	})

	// check for errors
	if allErr != nil {
		return nil, allErr
	}
	return updatedprofile, nil

}

func (uc *profileUseCase) CreateProfile(ctx *gin.Context, req domain.CreateProfileRequest) (*sqlc.Profile, *exceptions.Exception) {

	return uc.repo.CreateProfile(ctx, sqlc.CreateProfileParams{
		FirstName:       req.FirstName,
		LastName:        req.LastName,
		AddressesID:     req.AddressID,
		ProfileImageUrl: pgtype.Text{String: req.ProfileImageUrl, Valid: req.ProfileImageUrl != ""},
		// PhoneNumber:     req.PhoneNumber,
		// CompanyNumber:   req.CompanyNumber,
		// WhatsappNumber:  req.WhatsappNumber,
		// Gender:          req.Gender,
		// AllLanguagesID:  req.LanguageIDs,
	}, nil)

}

// UpdateProfilePassword implements ProfileUseCase.
func (uc *profileUseCase) UpdateProfilePassword(ctx *gin.Context, req domain.UpdateProfilePasswordRequest) (*string, *exceptions.Exception) {
	resp := "successfully updated password"

	payload := ctx.MustGet(middleware.AuthorizationPayloadKey).((*security.Payload))
	user, errVisitedUser := uc.repo.GetUserByName(ctx, payload.Username)
	if errVisitedUser != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "invalid user")
	}
	passErr := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.CurrentPassword))
	if passErr != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "current password doesn't match your input")
	}

	err := VerifyPasswordCriteria(req.NewPassword)
	if err != nil {
		return nil, err
	}
	if req.CurrentPassword == req.NewPassword {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "new password must be different from current password")
	}

	hashedPassword, err1 := bcrypt.GenerateFromPassword([]byte(req.NewPassword), 6)
	if err1 != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "err hashing new password")
	}
	_, err = uc.repo.UpdateUserPassword(ctx, sqlc.UpdateUserPasswordParams{
		ID:       user.ID,
		Password: string(hashedPassword),
	})
	if err != nil {
		return nil, err
	}

	return &resp, nil
}

func (uc *profileUseCase) GetOrganization(ctx *gin.Context, req domain.GetOrganizationReq) ([]sqlc.GetOrganizationRow, *exceptions.Exception) {
	lang, _ := ctx.Get("language")

	org, err := uc.repo.GetOrganization(ctx, sqlc.GetOrganizationParams{
		Lang:      lang.(string),
		CompanyID: req.CompanyID,
	})
	if err != nil {
		return nil, err
	}
	return org, err

}
func VerifyPasswordCriteria(password string) *exceptions.Exception {

	if len(password) < 8 {
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "password must be at least 8 characters long")
	}

	var hasUpper, hasLower, hasNumber, hasSpecial bool

	for _, char := range password {
		switch {
		case unicode.IsUpper(char):
			hasUpper = true
		case unicode.IsLower(char):
			hasLower = true
		case unicode.IsNumber(char):
			hasNumber = true
		case unicode.IsPunct(char) || unicode.IsSymbol(char):
			hasSpecial = true
		}
	}

	if !hasUpper {
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "password must contain at least one uppercase letter")
	}
	if !hasLower {
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "password must contain at least one lowercase letter")
	}
	if !hasNumber {
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "password must contain at least one number")
	}
	if !hasSpecial {
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "password must contain at least one special character")
	}

	return nil
}

func compareArrays(current, new []int64) ([]int64, []int64) {
	var toDelete []int64
	var toAdd []int64

	// Compare elements in current that aren't in new
	for _, val1 := range current {
		found := false
		for _, val2 := range new {
			if val1 == val2 {
				found = true
				break
			}
		}
		if !found {
			toDelete = append(toDelete, val1)
		}
	}

	// Compare elements in new that aren't in current
	for _, val2 := range new {
		found := false
		for _, val1 := range current {
			if val2 == val1 {
				found = true
				break
			}
		}
		if !found {
			toAdd = append(toAdd, val2)
		}
	}

	return toDelete, toAdd
}
