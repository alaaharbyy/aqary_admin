package companyuser_usecase

import (
	"aqary_admin/internal/delivery/rest/middleware"
	domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/constants"
	"aqary_admin/pkg/utils/exceptions"
	file_utils "aqary_admin/pkg/utils/file"
	"aqary_admin/pkg/utils/security"
	"fmt"
	"log"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"golang.org/x/crypto/bcrypt"
)

var COMPANY_USERS_PATH = "companyusers"

func (uc *companyUserUseCase) CreateCompanyUser(c *gin.Context, req domain.CreateUserReq) (any, *exceptions.Exception) {

	var countryId int64
	var passportImage, coverImage, profileImage, brnFile, nocImage string

	authPayload, ok := c.MustGet(middleware.AuthorizationPayloadKey).(*security.Payload)
	if !ok {
		log.Println("testing auth payload not ok")
		// return nil, exceptions.GetExceptionByErrorCode(exce)
	}
	visitedUser, err := uc.repo.GetUserByName(c, authPayload.Username)
	if err != nil {
		log.Println("testing auth payload  not ok err ", err)
		return nil, err
	}

	if req.CompanyID == 0 {
		req.CompanyID = visitedUser.ActiveCompany.Int64
	}

	existUser, _ := uc.repo.GetUserByEmail(c, req.Email)
	if existUser.ID != 0 && existUser.Email == req.Email {
		log.Println("create company user err :: 2", err)
		return nil, exceptions.GetExceptionByErrorCode(exceptions.EmailAlreadyExistsErrorCode)
	}

	log.Println("tewsting test ", req.RoleID == 0 && !(req.UserTypeID == 3 || req.UserTypeID == 4), "::", req.UserTypeID)
	// for owner and for user freelancer it's not required ...
	switch {
	case req.RoleID == 0 && !(req.UserTypeID == 3 || req.UserTypeID == 4):
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "role id required")

	case req.DepartmentID == 0 && !(req.UserTypeID == 3 || req.UserTypeID == 4):
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "department id required")
	}

	var companyUser *sqlc.CompanyUser
	var user *sqlc.User
	errr := sqlc.ExecuteTxWithException(c, uc.pool, func(q sqlc.Querier) *exceptions.Exception {

		// // get the company id from
		// companyVisitedUser, err := q.GetCompanyUserByUserId(c, sqlc.GetCompanyUserByUserIdParams{
		// 	CompanyID: req.CompanyID,
		// 	UserID:    visitedUser.ID,
		// })
		// if err != nil {
		// 	log.Println("error while getting company visited User:", err)
		// 	// return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		// }
		// if companyVisitedUser.ID != 0 {
		if req.CountryID == 0 {
			company, _ := q.GetCompanyById(c, visitedUser.ActiveCompany.Int64)
			if company.ID != 0 {
				companyAddress, _ := q.GetAddress(c, int32(company.AddressesID))
				countryId = companyAddress.CountriesID.Int64
			}
		} else {
			countryId = req.CountryID
		}
		// } else {
		// 	countryId = req.CountryID
		// }

		address, er := uc.repo.CreateAddress(c, sqlc.CreateAddressParams{
			CountriesID: pgtype.Int8{
				Int64: countryId,
				Valid: countryId != 0,
			},
			StatesID: pgtype.Int8{
				Int64: req.StateID,
				Valid: req.StateID != 0,
			},
			CitiesID: pgtype.Int8{
				Int64: req.CityID,
				Valid: req.CityID != 0,
			},
			CommunitiesID: pgtype.Int8{
				Int64: req.CommunityID,
				Valid: req.CommunityID != 0,
			},
			SubCommunitiesID: pgtype.Int8{
				Int64: req.SubCommunityID,
				Valid: req.SubCommunityID != 0,
			},
			LocationsID: pgtype.Int8{},
		}, q)
		if er != nil {
			log.Println("create address err :: ", er)
			return er
		}

		file, err := c.FormFile("profile_image")
		if file != nil && err == nil {
			var er error
			profileImage, er = file_utils.UploadSingleFileToABS(c, file, COMPANY_USERS_PATH)
			if er != nil {
				log.Println("image uploading err :: ", er)
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "[CreateCompanyUser] error while uploading image")
			}
		}
		coverImageFile, err := c.FormFile("cover_image")
		if coverImageFile != nil && err == nil {
			var er error
			coverImage, er = file_utils.UploadSingleFileToABS(c, coverImageFile, COMPANY_USERS_PATH)
			if er != nil {
				log.Println("image uploading err :: ", er)
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "[CreateCompanyUser] error while uploading cover image")
			}
		}

		passportImageFile, err := c.FormFile("passport_image")
		if passportImageFile != nil && err == nil {
			var er error
			passportImage, er = file_utils.UploadSingleFileToABS(c, passportImageFile, COMPANY_USERS_PATH)
			if er != nil {
				log.Println("image uploading err :: ", er)
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "[CreateCompanyUser] error while uploading passport image")
			}
		}

		var passportExpieryDate pgtype.Timestamptz
		if req.PassportExpiryDate != nil {
			passportExpieryDate.Time = *req.PassportExpiryDate
			passportExpieryDate.Valid = true
		} else {
			passportExpieryDate.Valid = false
		}

		encryptedPassword, errr := bcrypt.GenerateFromPassword([]byte("123456"), 6)
		if errr != nil {
			log.Println("encryption password err :: ", err)
			// status = http.StatusInternalServerError
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "[CreateCompanyUser] error while generating password")
		}

		var experiance time.Time
		if req.ExperienceSince != nil {
			experiance = *req.ExperienceSince
		}

		code, phone := utils.SplitAndParsePhoneNumber(req.PrimaryPhone)

		var userErr *exceptions.Exception
		user, userErr = uc.repo.CreateUser(c, sqlc.CreateUserParams{
			Email:       req.Email,
			Username:    req.Username,
			Password:    string(encryptedPassword),
			Status:      2,
			RolesID:     pgtype.Int8{Int64: req.RoleID, Valid: true},
			UserTypesID: req.UserTypeID,
			SocialLogin: pgtype.Text{}, //later we will handle it
			ShowHideDetails: pgtype.Bool{
				Bool:  req.ShowHideDetails,
				Valid: true,
			},
			ExperienceSince: pgtype.Timestamptz{
				Time:  experiance,
				Valid: req.ExperienceSince != nil,
			},
			IsVerified: pgtype.Bool{
				Bool:  req.IsVerified,
				Valid: true,
			},
			CreatedAt:   time.Now().Round(time.Second),
			UpdatedAt:   time.Now().Round(time.Second),
			PhoneNumber: pgtype.Text{String: fmt.Sprintf("%v", phone), Valid: phone != 0},
			CountryCode: pgtype.Int8{Int64: code, Valid: code != 0},
		}, q)

		if userErr != nil {
			log.Println("testing err in create user", userErr)
			return userErr
		}

		profile, er := uc.repo.CreateProfile(c, sqlc.CreateProfileParams{
			FirstName:       req.FirstName,
			LastName:        req.LastName,
			AddressesID:     address.ID,
			ProfileImageUrl: pgtype.Text{String: profileImage, Valid: profileImage != ""},

			SecondaryNumber:    pgtype.Text{String: req.SecondaryPhone, Valid: req.SecondaryPhone != ""},
			WhatsappNumber:     pgtype.Text{String: req.WhatsappNumber, Valid: req.WhatsappNumber != ""},
			ShowWhatsappNumber: pgtype.Bool{Bool: req.ShowWhatsAppNumber, Valid: true},
			BotimNumber:        pgtype.Text{String: req.BotimNumber, Valid: req.BotimNumber != ""},
			ShowBotimNumber:    pgtype.Bool{Bool: req.ShowBotimNumber, Valid: true},
			TawasalNumber:      pgtype.Text{String: req.TawasalNumber, Valid: req.TawasalNumber != ""},
			ShowTawasalNumber:  pgtype.Bool{Bool: req.ShowTawasalNumber, Valid: true},
			Gender:             pgtype.Int8{Int64: req.Gender, Valid: req.Gender != 0},
			CreatedAt:          time.Now().Round(time.Second),
			UpdatedAt:          time.Now().Round(time.Second),
			RefNo:              utils.GenerateReferenceNumber(constants.PROFILE),
			CoverImageUrl:      pgtype.Text{String: coverImage, Valid: coverImage != ""},
			PassportNo:         pgtype.Text{String: req.PassportNo, Valid: req.PassportNo != ""},
			PassportImageUrl:   pgtype.Text{String: passportImage, Valid: passportImage != ""},
			PassportExpiryDate: passportExpieryDate,
			About:              pgtype.Text{String: req.About, Valid: req.About != ""},
			AboutArabic:        pgtype.Text{String: req.AboutArabic, Valid: req.AboutArabic != ""},
			UsersID:            user.ID,
		}, q)
		if er != nil {
			log.Println("create profile err :: ", er)
			// status = http.StatusInternalServerError
			return er
		}

		// this needs to be done ....
		if len(req.SpokenLanguages) == 0 {
			req.SpokenLanguages = []int64{}
		}

		// register languages and  nationality ....

		// var wg sync.WaitGroup
		// var errChan = make(chan error)
		for _, lang := range req.SpokenLanguages {
			// wg.Add(1)
			// go func(l int64, s sqlc.Querier) {
			// 	defer wg.Done()
			_, err := q.CreateProfileLanguage(c, sqlc.CreateProfileLanguageParams{
				ProfilesID:     profile.ID,
				AllLanguagesID: lang,
			})
			if err != nil {
				log.Println("testing while create profile language :", err)
				// errChan <- err
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
			}
			// 	}(lang, q)
			// }

			// go func() {
			// 	wg.Wait()
			// 	close(errChan)
			// }()

			// var allErr []error
			// for er := range errChan {
			// 	if er != nil {
			// 		allErr = append(allErr, er)
			// 	}
			// }

			// if len(allErr) > 0 {
			// 	return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, fmt.Errorf("error :%v", allErr).Error())
		}

		for _, nat := range req.Nationality {
			// wg.Add(1)
			// go func(n int64, s sqlc.Querier) {
			// 	defer wg.Done()
			_, err := q.CreateProfileNationalities(c, sqlc.CreateProfileNationalitiesParams{
				ProfilesID: profile.ID,
				CountryID:  nat,
			})
			if err != nil {
				log.Println("testing while create profile language :", err)
				// errChan <- err
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())

			}
			// }(nat, q)
		}

		socialErr := registerAllSocials(c, q, req, user.ID)
		if socialErr != nil {
			log.Println("testing social err", socialErr)
		}

		if req.UserTypeID == constants.CompanyUserUserTypes.Int64() {
			user.IsVerified = pgtype.Bool{Bool: true, Valid: true}
		}

		if req.UserTypeID == constants.CompanyAdminUserTypes.Int64() || req.UserTypeID == constants.AgentUserTypes.Int64() {

			//  company user
			companyUser, er = uc.repo.CreateCompanyUser(c, sqlc.CreateCompanyUserParams{
				UsersID:           user.ID,
				CompanyID:         req.CompanyID,
				CompanyDepartment: pgtype.Int8{Int64: req.DepartmentID, Valid: req.DepartmentID != 0},
				CompanyRoles:      pgtype.Int8{Int64: req.RoleID, Valid: req.RoleID != 0},
				UserRank:          1,
				IsVerified:        user.IsVerified,
				CreatedBy:         visitedUser.ID,
				CreatedAt:         time.Now().Round(time.Second),
				UpdatedAt:         time.Now().Round(time.Second),
				LeaderID: pgtype.Int8{
					Int64: req.LeaderID,
					Valid: req.LeaderID != 0,
				},
			}, q)
			if er != nil {
				log.Println("create company user err :: ", er)
				return er
			}

			// ? update active company for the user
			_, er := uc.repo.UpdateActiveCompany(c, sqlc.UpdateActiveCompanyParams{
				ActiveCompany: pgtype.Int8{Int64: req.CompanyID, Valid: req.CompanyID != 0},
				ID:            user.ID,
			}, q)
			if er != nil {
				log.Println("update active company err :: ", er)
				return er
			}

		}

		// storing licence license  for agent and freelancers
		if req.UserTypeID == constants.AgentUserTypes.Int64() {
			licenseFile, err := c.FormFile("brn_file")
			if err != nil {
				log.Println("testing brn file error:", err)
				// return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "brn file is missing")
			}
			log.Println("testing brn file err:", err)
			if licenseFile != nil {
				var er error
				brnFile, er = file_utils.UploadSingleFileToABS(c, licenseFile, COMPANY_USERS_PATH)
				if er != nil {
					log.Println("image uploading err :: ", er)
					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "[CreateCompanyUser] error while uploading brn file")
				}
			}

			var licenseIssueDate = pgtype.Timestamptz{}
			if req.BrnLicenseIssueDate != nil {
				licenseIssueDate.Time = *req.BrnLicenseIssueDate
				licenseIssueDate.Valid = true

			} else {
				licenseIssueDate.Valid = false
			}

			var licenseRegistrationDate = pgtype.Timestamptz{}
			if req.BrnLicenseRegistrationDate != nil {
				licenseRegistrationDate.Time = *req.BrnLicenseRegistrationDate
				licenseRegistrationDate.Valid = true
			} else {
				licenseRegistrationDate.Valid = false
			}

			var licenseExpiryDate = pgtype.Timestamptz{}
			if req.BrnLicenseExpiryDate != nil {
				licenseExpiryDate.Time = *req.BrnLicenseExpiryDate
				licenseExpiryDate.Valid = true
			} else {
				licenseExpiryDate.Valid = false
			}

			// brn file is required for agent and company user
			// license
			license, err := q.CreateLicense(c, sqlc.CreateLicenseParams{
				LicenseFileUrl: pgtype.Text{
					String: brnFile,
					Valid:  brnFile != "",
				}, // file
				LicenseNo:               req.BRNNo,
				LicenseIssueDate:        licenseIssueDate,
				LicenseRegistrationDate: licenseRegistrationDate,
				LicenseExpiryDate:       licenseExpiryDate,
				LicenseTypeID:           constants.BRNLicenseType.Int64(), //
				StateID:                 req.StateID,
				EntityTypeID:            constants.UserEntityType.Int64(),
				EntityID:                user.ID,
			})
			if err != nil {
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, fmt.Errorf("[company user] brn, license :%v", err).Error())
			}

			log.Println("testing brn license...", license)
			log.Println("testing companyVisitedUser")

			packageReq := domain.SetUserPackageReq{
				CompanyID: req.CompanyID,
				UserID:    companyUser.UsersID,
				Standard:  req.Standard,
				Feature:   req.Feature,
				Premium:   req.Premium,
				TopDeal:   req.TopDeal,
			}
			_, er := setUserPackage(c, q, packageReq, companyUser, visitedUser)
			if er != nil {
				return er
			}
		}

		if req.UserTypeID == constants.FreelancerUserTypes.Int64() || req.UserTypeID == constants.OwnerOrIndividualUserTypes.Int64() {
			nocImageFile, err := c.FormFile("noc_file")
			if nocImageFile != nil && err == nil {
				var er error
				nocImage, er = file_utils.UploadSingleFileToABS(c, nocImageFile, COMPANY_USERS_PATH)
				if er != nil {
					log.Println("image uploading err :: ", er)
					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "[CreateCompanyUser] error while uploading noc image")
				}

				// store the license ....

				license, err := q.CreateLicense(c, sqlc.CreateLicenseParams{
					LicenseFileUrl: pgtype.Text{
						String: nocImage,
						Valid:  nocImage != "",
					}, // file
					LicenseNo:               req.NocNo,
					LicenseIssueDate:        pgtype.Timestamptz{},
					LicenseRegistrationDate: pgtype.Timestamptz{},
					LicenseExpiryDate:       pgtype.Timestamptz{},
					LicenseTypeID:           constants.NOCLicenseType.Int64(), //
					StateID:                 req.StateID,
					EntityTypeID:            constants.UserEntityType.Int64(),
					EntityID:                user.ID,
				})
				if err != nil {
					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, fmt.Errorf("[company user] noc, license :%v", err).Error())
				}

				log.Println("testing  brn license...", license)

			}

			// if req.UserTypeID == constants.FreelancerUserTypes.Int64() || req.UserTypeID == constants.OwnerOrIndividualUserTypes.Int64() {
			banks, err := q.CreateBankAccountDetails(c, sqlc.CreateBankAccountDetailsParams{
				AccountName:   req.AccountName,
				AccountNumber: req.AccountNo,
				Iban:          req.IBANNo,
				CountriesID:   req.BankCountryID,
				CurrencyID:    req.CurrencyID,
				BankName:      req.BankName,
				BankBranch:    req.BankBranch,
				SwiftCode:     req.SwiftCode,
				CreatedAt:     time.Now(),
				EntityTypeID:  constants.UserEntityType.Int64(), // 9
				EntityID:      user.ID,
			})
			if err != nil {
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
			}

			log.Println("testing if banks has been created or not", banks)
			// }

			//
		}
		return nil
	})

	if errr != nil {
		log.Println("testing err", errr)

		// delete the image that are uploaded
		switch {
		case profileImage != "":
			utils.DeleteSingleFileFromABS(profileImage)
		case coverImage != "":
			utils.DeleteSingleFileFromABS(coverImage)
		case passportImage != "":
			utils.DeleteSingleFileFromABS(passportImage)
		case nocImage != "":
			utils.DeleteSingleFileFromABS(nocImage)
		case brnFile != "":
			utils.DeleteSingleFileFromABS(brnFile)

		}

		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(errr.ErrorCode, errr.Error())
	}

	return utils.Ternary[any](companyUser == nil, user, companyUser), nil
}

func (uc *companyUserUseCase) SetUserPackage(c *gin.Context, req domain.SetUserPackageReq) (any, *exceptions.Exception) {

	authPayload, ok := c.MustGet(middleware.AuthorizationPayloadKey).(*security.Payload)
	if !ok {
		log.Println("testing auth payload not ok")
		// return nil, exceptions.GetExceptionByErrorCode(exce)
	}
	visitedUser, err := uc.repo.GetUserByName(c, authPayload.Username)
	if err != nil {
		return nil, err
	}

	// get company user
	companyUser, _ := uc.repo.GetCompanyUserByUserId(c, sqlc.GetCompanyUserByUserIdParams{
		CompanyID: req.CompanyID,
		UserID:    req.UserID,
	})

	sub, err := setUserPackage(c, uc.store, req, companyUser, visitedUser) // cmpuser , user
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	return sub, nil
}

func (uc *companyUserUseCase) GetUserPackage(c *gin.Context, req domain.GetUserPackageReq) (any, *exceptions.Exception) {

	// Subscriptions
	var standard, feature, premium, topdeal int64
	subcriptions, errr := uc.store.GetAgentProductByUserID(c, req.UserID)
	if errr != nil {
		log.Printf("Error fetching subscriptions: %v", errr)
	}
	for _, sub := range subcriptions {
		log.Println("testing subscriptions ", strings.EqualFold(sub.Product, "featured"))
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

	return SubscriptionOutput{
		Standard: format{
			Label:        "standard",
			NoOfProducts: standard,
		},
		Feature: format{
			Label:        "featured",
			NoOfProducts: feature,
		},
		Premium: format{
			Label:        "premium",
			NoOfProducts: premium,
		},
		TopDeal: format{
			Label:        "top deals",
			NoOfProducts: topdeal,
		},
	}, nil
}

type SubscriptionOutput struct {
	Standard format `json:"1"`
	Feature  format `json:"2"`
	Premium  format `json:"3"`
	TopDeal  format `json:"4"`
}

type format struct {
	Label        string `json:"label"`
	NoOfProducts int64  `json:"no_of_products"`
}
