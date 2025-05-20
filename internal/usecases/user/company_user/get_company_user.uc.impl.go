package companyuser_usecase

import (
	"aqary_admin/internal/delivery/rest/middleware"
	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"strconv"
	"strings"
	"time"

	// permission "aqary_admin/old_repo/user/permissions"
	"log"

	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/constants"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/fn"
	"aqary_admin/pkg/utils/security"

	"github.com/gin-gonic/gin"
)

func (uc *companyUserUseCase) GetAllCompanyUser(c *gin.Context, req domain.GetCompanyUserReq) (any, int64, *exceptions.Exception) {

	payload := c.MustGet(middleware.AuthorizationPayloadKey).((*security.Payload))
	visitedUser, err := uc.repo.GetUserByName(c, payload.Username)
	if err != nil {
		return nil, 0, err
	}

	if req.UserType == 2 {

		users, er := uc.repo.GetAllCompanyUsers(c, sqlc.GetAllCompanyUsersParams{
			Limit:     req.PageSize,
			Offset:    (req.PageNo - 1) * req.PageSize,
			Search:    utils.AddPercent(req.Search),
			CompanyID: visitedUser.ActiveCompany.Int64,
		})
		if er != nil {
			return nil, 0, er
		}

		var outputList []response.AllCompanyUserRes

		for _, user := range users {

			outputList = append(outputList, response.AllCompanyUserRes{
				ID:            user.UserID.Int64,
				CompanyUserID: user.CompanyUserID,
				CompanyID:     user.CompanyID,
				ProfileImage:  user.ProfileImageUrl.String,
				CompanyName:   user.CompanyName.String,
				UserName:      user.FirstName.String + " " + user.LastName.String,
				Department:    user.Department.String,
				Role:          user.Role.String,
				BRNNo:         user.LicenseNo.String,
				Status:        fn.CustomFormat{ID: user.Status.Int64, Name: constants.CompanyUserType.ConstantName(user.Status.Int64)},
				IsVerfied:     user.IsVerified.Bool,
				CompanyType:   constants.CompanyTypes.ConstantName(user.CompanyType.Int64),
				Phone:         user.PhoneNumber.String,
				Email:         user.Email.String,
			})
		}

		var err *exceptions.Exception
		totalCount, err := uc.repo.GetCountAllCompanyUsers(c, sqlc.GetCountAllCompanyUsersParams{
			Search:    utils.AddPercent(req.Search),
			CompanyID: visitedUser.ActiveCompany.Int64,
		})
		if err != nil {
			return nil, 0, err
		}

		return outputList, totalCount, nil

	} else if req.UserType == 4 { //  freelance type

		users, er := uc.repo.GetAllFreelanceUsers(c, sqlc.GetAllFreelanceUsersParams{
			Limit:  req.PageSize,
			Offset: (req.PageNo - 1) * req.PageSize,
			Search: utils.AddPercent(req.Search),
		})
		if er != nil {
			return nil, 0, er
		}

		var outputList []response.AllFreelanceUserRes

		for _, user := range users {

			outputList = append(outputList, response.AllFreelanceUserRes{
				UserID:       user.ID, // user id
				ProfileImage: user.ProfileImageUrl.String,

				UserName: user.FirstName.String + " " + user.LastName.String,
				BRNNo:    user.Brn.String,
				Status: fn.CustomFormat{
					ID:   user.Status,
					Name: constants.CompanyUserType.ConstantName(user.Status),
				},
				IsVerfied: user.IsVerified.Bool,
				Phone:     user.PhoneNumber.String,
				Email:     user.Email,
			})
		}

		var err *exceptions.Exception
		totalCount, err := uc.repo.CountAllFreelanceUsers(c, utils.AddPercent(req.Search))
		if err != nil {
			return nil, 0, err
		}

		return outputList, totalCount, nil

	} else if req.UserType == 3 { //  owner or individual

		users, er := uc.repo.GetAllOwnerUsers(c, sqlc.GetAllOwnerUsersParams{
			Limit:  req.PageSize,
			Offset: (req.PageNo - 1) * req.PageSize,
			Search: utils.AddPercent(req.Search),
		})
		if er != nil {
			return nil, 0, er
		}

		var outputList []response.AllOwnerUserRes

		for _, user := range users {
			outputList = append(outputList, response.AllOwnerUserRes{
				UserID:       user.ID, // user id
				ProfileImage: user.ProfileImageUrl.String,
				UserName:     user.FirstName.String + " " + user.LastName.String,
				Status: fn.CustomFormat{
					ID:   user.Status,
					Name: constants.CompanyUserType.ConstantName(user.Status),
				},
				IsVerfied: user.IsVerified.Bool,
				Phone:     user.PhoneNumber.String,
				Email:     user.Email,
			})
		}

		var err *exceptions.Exception
		totalCount, err := uc.repo.CountAllFreelanceUsers(c, utils.AddPercent(req.Search))
		if err != nil {
			return nil, 0, err
		}

		return outputList, totalCount, nil

	}

	return nil, 0, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "please mention the correct tab index")
	// return outputList, totalCount, nil
}

type CompanyUserOutput struct {
	ID                int64           `json:"id"`
	UsersID           sqlc.User       `json:"user"`
	CompanyID         sqlc.Company    `json:"company"`
	CompanyDepartment sqlc.Department `json:"department"`
	UserRank          fn.CustomFormat `json:"user_rank"`
	IsVerified        bool            `json:"is_verified"`
	Email             string          `json:"email"`
	Username          string          `json:"username"`
	Status            fn.CustomFormat `json:"status"`
	RolesID           sqlc.Role       `json:"role"`
	ProfilesID        sqlc.Profile    `json:"profile"`
	ShowHideDetails   bool            `json:"show_hide_details"`
	ExperienceSince   time.Time       `json:"experience_since"`
}

func (uc *companyUserUseCase) GetCompanyUser(c *gin.Context, req domain.GetASingleUserReq) (any, *exceptions.Exception) {
	user, err := uc.repo.GetUserRegardlessOfStatus(c, req.ID)
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "User not found ::")
	}

	role, err := uc.repo.GetRole(c, user.RolesID.Int64)
	if err != nil {
		log.Printf("Error fetching role: %v", err)
	}

	department, err := uc.repo.GetDepartment(c, sqlc.GetDepartmentParams{
		CompanyID:    0,
		DepartmentID: role.DepartmentID.Int64,
	})
	if err != nil {
		log.Printf("Error fetching department: %v", err)
	}

	profile, err := uc.repo.GetProfileByUserId(c, user.ID)
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "Profile not found")
	}

	// Nationalities
	allNationalitites := []sqlc.Country{}
	allNational, errr := uc.store.GetAllNationalitiesByProfileID(c, profile.ID)
	if errr != nil {
		log.Printf("Error fetching nationalities: %v", errr)
	}
	for _, nat := range allNational {
		allNationalitites = append(allNationalitites, sqlc.Country{
			ID:      nat.CountryID,
			Country: nat.Country,
		})
	}

	// Languages
	allLanguage := []fn.CustomFormat{}
	allLanguages, errr := uc.store.GetAllLanguagesByUserID(c, profile.ID)
	if errr != nil {
		log.Printf("Error fetching languages: %v", errr)
	}
	for _, lang := range allLanguages {
		allLanguage = append(allLanguage, fn.CustomFormat{
			ID:   lang.AllLanguagesID,
			Name: lang.Language,
		})
	}

	// Subscriptions
	var standard, feature, premium, topdeal int64
	subcriptions, errr := uc.store.GetAgentProductByUserID(c, user.ID)
	if errr != nil {
		log.Printf("Error fetching subscriptions: %v", errr)
	}
	for _, sub := range subcriptions {
		switch {
		case strings.EqualFold(sub.Product, "standard"):
			standard = int64(sub.NoOfProducts.Int32)
		case strings.EqualFold(sub.Product, "featured"):
			feature = int64(sub.NoOfProducts.Int32)
		case strings.EqualFold(sub.Product, "premium"):
			premium = int64(sub.NoOfProducts.Int32)
		case strings.EqualFold(sub.Product, "top deals"):
			topdeal = int64(sub.NoOfProducts.Int32)
		}
	}

	// Social media
	allSoc, errr := uc.store.GetAllSocialByUser(c, user.ID)
	if errr != nil {
		log.Printf("Error fetching social media: %v", err)
	}
	var facebook, twitter, linkedin string
	for _, soc := range allSoc {
		switch {
		case strings.EqualFold(soc.SocialMediaName, "facebook"):
			facebook = soc.SocialMediaUrl
		case strings.EqualFold(soc.SocialMediaName, "twitter"):
			twitter = soc.SocialMediaUrl
		case strings.EqualFold(soc.SocialMediaName, "linkedin"):
			linkedin = soc.SocialMediaUrl
		}
	}

	// Licenses
	brn, errr := uc.store.GetBrnLicenseByUserID(c, user.ID)
	if errr != nil {
		log.Printf("Error fetching BRN license: %v", errr)
	}
	noc, errr := uc.store.GetNocLicenseByUserID(c, user.ID)
	if errr != nil {
		log.Printf("Error fetching NOC license: %v", errr)
	}

	// Bank details
	var bankCountry any
	var bankCurrency any
	bank, err := uc.repo.GetUserBankAccountDetails(c, user.ID)
	if err != nil {
		log.Printf("Error fetching bank details: %v", err)
	}
	if bank != nil {
		getBankCountry, err := uc.repo.GetCountry(c, int32(bank.CountriesID))
		if err != nil {
			log.Printf("Error fetching bank country: %v", err)
		}

		if getBankCountry.ID != 0 {
			bankCountry = getBankCountry
		}
		getBankCurrency, errr := uc.store.GetCurrency(c, int32(bank.CurrencyID))
		if err != nil {
			log.Printf("Error fetching bank currency: %v", errr)
		}

		if getBankCurrency.ID != 0 {
			bankCurrency = CurrencyOutput{
				ID:       getBankCurrency.ID,
				Currency: getBankCurrency.Currency,
			}
		}

	}

	// Address details
	var country sqlc.Country
	var state sqlc.State
	var city sqlc.City
	var community sqlc.Community
	var subCommunity sqlc.SubCommunity

	address, err := uc.repo.GetAddress(c, int32(profile.AddressesID))
	if err != nil {
		log.Printf("Error fetching address: %v", err)
	} else {
		country, _ = uc.repo.GetCountry(c, int32(address.CountriesID.Int64))
		state, _ = uc.repo.GetState(c, int32(address.StatesID.Int64))
		city, _ = uc.repo.GetCity(c, int32(address.CitiesID.Int64))
		community, _ = uc.repo.GetCommunity(c, int32(address.CommunitiesID.Int64))
		subCommunity, _ = uc.repo.GetSubCommunity(c, int32(address.SubCommunitiesID.Int64))
	}

	var departmentO any

	if department.ID != 0 {
		departmentO = DepartmentOutput{
			ID:         safeDepartmentID(department),
			Department: safeDepartmentName(department),
		}
	} else {
		departmentO = nil
	}

	var roleO any

	if role.ID != 0 {
		roleO = RoleOutput{
			ID:   safeRoleID(role),
			Role: safeRoleName(role),
		}
	} else {
		roleO = nil
	}

	var genderO any

	if profile.Gender.Int64 != 0 {
		genderO = fn.CustomFormat{
			ID:   profile.Gender.Int64,
			Name: constants.Gender.ConstantName(profile.Gender.Int64),
		}
	} else {
		genderO = nil
	}

	//  get the compnay user for leaders
	companyUser, _ := uc.store.GetCompanyUserByUserId(c, sqlc.GetCompanyUserByUserIdParams{
		CompanyID: 0,
		UserID:    user.ID,
	})

	var getLeaderName string
	if companyUser.ID != 0 {
		getUser, _ := uc.store.GetUserRegardlessOfStatus(c, companyUser.UsersID)
		getProfile, _ := uc.store.GetProfile(c, getUser.ProfilesID)
		if getProfile.ID != 0 {
			getLeaderName = getProfile.FirstName + " " + getProfile.LastName
		}
	}

	output := domain.CompanyUserOutput{
		UserID:       user.ID,
		FirstName:    profile.FirstName,
		LastName:     profile.LastName,
		Email:        user.Email,
		Username:     user.Username,
		PrimaryPhone: strconv.FormatInt(user.CountryCode.Int64, 10) + "-" + user.PhoneNumber.String,

		SecondaryPhone:             profile.SecondaryNumber.String,
		Gender:                     genderO,
		WhatsappNumber:             profile.WhatsappNumber.String,
		ShowWhatsAppNumber:         profile.ShowBotimNumber.Bool,
		BotimNumber:                profile.BotimNumber.String,
		ShowBotimNumber:            profile.ShowBotimNumber.Bool,
		TawasalNumber:              profile.TawasalNumber.String,
		ShowTawasalNumber:          profile.ShowTawasalNumber.Bool,
		IsShowUserDetails:          user.ShowHideDetails.Bool,
		UserTypeID:                 fn.CustomFormat{ID: user.UserTypesID, Name: constants.UserTypes.ConstantName(user.UserTypesID)},
		DepartmentID:               departmentO,
		RoleID:                     roleO,
		About:                      profile.About.String,
		AboutArabic:                profile.AboutArabic.String,
		BRNNo:                      safeBRNLicenseNo(brn),
		BRN_Expiry:                 safeBRNLicenseExpiryDate(brn),
		BrnLicenseIssueDate:        safeBRNLicenseIssueDate(brn),
		BrnLicenseRegistrationDate: safeBRNLicenseRegistrationDate(brn),
		BrnLicenseExpiryDate:       safeBRNLicenseExpiryDate(brn),
		Nationality:                allNationalitites,
		SpokenLanguages:            allLanguage,
		ExperienceSince:            user.ExperienceSince.Time,
		Facebook:                   facebook,
		LinkedIn:                   linkedin,
		Twitter:                    twitter,
		CountryID:                  country,
		StateID:                    state,
		CityID:                     city,
		CommunityID:                community,
		SubCommunityID:             subCommunity,
		Standard:                   standard,
		Feature:                    feature,
		Premium:                    premium,
		TopDeal:                    topdeal,
		PassportNo:                 profile.PassportNo.String,
		PassportExpiryDate:         profile.PassportExpiryDate,
		IsVerified:                 user.IsVerified.Bool,
		NocNo:                      safeNOCLicenseNo(noc),
		AccountNo:                  safeBankAccountNumber(bank),
		AccountName:                safeBankAccountName(bank),
		IBANNo:                     safeBankIBAN(bank),
		BankCountryID:              bankCountry,
		CurrencyID:                 bankCurrency,
		BankName:                   safeBankName(bank),
		BankBranch:                 safeBankBranch(bank),
		SwiftCode:                  safeBankSwiftCode(bank),
		ProfileImage:               profile.ProfileImageUrl.String,
		CoverImage:                 profile.CoverImageUrl.String,
		NocFile:                    safeNOCLicenseFileURL(noc),
		PassportImage:              profile.PassportImageUrl.String,
		LeaderID:                   getLeaderName,
	}
	return output, nil
}

type DepartmentOutput struct {
	ID         int64  `json:"id"`
	Department string `json:"department"`
}

type RoleOutput struct {
	ID   int64  `json:"id"`
	Role string `json:"role"`
}

type LanguagesOutput struct {
	ID       int64  `json:"id"`
	Language string `json:"language"`
}

type CurrencyOutput struct {
	ID       int64  `json:"ID"`
	Currency string `json:"Currency"`
}

func (uc *companyUserUseCase) GetCompanyOfUser(c *gin.Context, userID int64) (sqlc.CompanyUser, *exceptions.Exception) {
	users, err := uc.repo.GetCompanyUsersByUsersID(c, userID)
	if err != nil {
		return sqlc.CompanyUser{}, err
	}
	return users, nil
}
