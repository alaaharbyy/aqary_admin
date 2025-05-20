package companyuser_usecase

import (
	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	// "errors"
	"log"
	"time"

	// permission "aqary_admin/old_repo/user/permissions"
	"fmt"

	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/constants"
	"aqary_admin/pkg/utils/exceptions"
	file_utils "aqary_admin/pkg/utils/file"
	"aqary_admin/pkg/utils/security"

	"github.com/gin-gonic/gin"
	// "github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"golang.org/x/crypto/bcrypt"
)

func (uc *companyUserUseCase) GetCountCompanyUsers(ctx *gin.Context) (*response.UserCountOutput, *exceptions.Exception) {
	activeUsers, err := uc.repo.GetCountCompanyUsersByStatuses(ctx, []int64{1, 2, 3, 4})
	if err != nil {
		return nil, err
	}

	inactiveUsers, err := uc.repo.GetCountCompanyUsersByStatuses(ctx, []int64{5, 6})
	if err != nil {
		return nil, err
	}

	totalUsers, err := uc.repo.GetCountCompanyUsersByStatuses(ctx, []int64{1, 2, 3, 4, 5, 6})
	if err != nil {
		return nil, err
	}

	return &response.UserCountOutput{
		TotalUsers:    totalUsers,
		ActiveUsers:   activeUsers,
		InActiveUsers: inactiveUsers,
	}, nil
}

func (uc *companyUserUseCase) ResetCompanyUserPassword(ctx *gin.Context, req domain.ResetReq) *exceptions.Exception {
	if len(req.Password) < 6 {
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "password must be minimum 6 characters")
	}

	companyUser, err := uc.repo.GetCompanyUser(ctx, int32(req.CompanyUserID))
	if err != nil {
		return err
	}

	encryptedPassword, errr := bcrypt.GenerateFromPassword([]byte(req.Password), 6)
	if errr != nil {
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "failed to encrypt password")
	}

	_, er := uc.repo.UpdateUserPassword(ctx, sqlc.UpdateUserPasswordParams{
		ID:       companyUser.UsersID,
		Password: string(encryptedPassword),
	})
	return er
}

// func (uc *companyUserUseCase) UpdateCompanyUserByStatus(ctx *gin.Context, req domain.UpdateUserByStatusReq) *exceptions.Exception {

// 	user, err := uc.repo.GetUserRegardlessOfStatus(ctx, req.ID)
// 	if err != nil {
// 		return err
// 	}

// 	// companyUser, errr := uc.store.GetCompanyUserByUserId(ctx, sqlc.GetCompanyUserByUserIdParams{
// 	// 	CompanyID: 0,
// 	// 	UserID:   user.ID,
// 	// })
// 	// if errr != nil {
// 	// 	// return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, errr.Error())
// 	// }

// 	// if user type is agent then block or unblock all property and unit versions listed by him
// 	if user.UserTypesID == constants.AgentUserTypes.Int64() {
// 		// start transaction for UpdateCompanyUserByStatus
// 		allErr := sqlc.ExecuteTxWithException(ctx, uc.pool, func(q sqlc.Querier) *exceptions.Exception {
// 			_, err2 := q.UpdateUserStatus(ctx, sqlc.UpdateUserStatusParams{
// 				ID:     user.ID,
// 				Status: req.Status,
// 			})

// 			if err2 != nil {
// 				if errors.Is(err2, pgx.ErrNoRows) {
// 					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "user not found")
// 				}

// 				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "issue encountered while changing the user status")
// 			}

// 			var status int64 = constants.DraftStatus.Int64()

// 			if req.Status == constants.DeletedStatus.Int64() {
// 				status = constants.BlockedStatus.Int64()
// 			}

// 			// block or unblock property versions status listed by this agent
// 			err = uc.repo.UpdatePropertyVersionsStatusForAgent(ctx, sqlc.UpdatePropertyVersionsStatusForAgentParams{
// 				Status:  status,
// 				AgentID: user.ID,
// 			}, q)

// 			if err != nil {
// 				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "issue encountered while changing statuses of property versions")
// 			}

// 			// block or unblock unit versions status listed by this agent
// 			err = uc.repo.UpdateUnitVersionsStatusForAgent(ctx, sqlc.UpdateUnitVersionsStatusForAgentParams{
// 				Status:  status,
// 				AgentID: user.ID,
// 			}, q)

// 			if err != nil {
// 				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "issue encountered while changing statuses of unit versions")
// 			}
// 			return nil

// 		})

// 		if allErr != nil {
// 			return allErr
// 		}

// 	} else {
// 		_, err = uc.repo.UpdateUserStatus(ctx, sqlc.UpdateUserStatusParams{
// 			ID:     user.ID,
// 			Status: req.Status,
// 		})
// 		if err != nil {
// 			return err
// 		}
// 	}

// 	return nil
// }

// including freelancer and owner also
func (uc *companyUserUseCase) UpdateCompanyUser(c *gin.Context, req domain.UpdateCompanyUserRequest) (any, *exceptions.Exception) {

	var newPassportImage, newCoverImage, brnFile, newProfileImage, nocImage string
	var profileImage, coverImage, passportImage pgtype.Text
	authPayload, ok := c.MustGet("authorization_payload").(*security.Payload)
	if !ok {
		log.Println("testing auth payload not ok")
		// return nil, exceptions.GetExceptionByErrorCode(exce)
	}
	visitedUser, err := uc.repo.GetUserByName(c, authPayload.Username)
	if err != nil {
		return nil, err
	}

	// get user and their profile
	existingUser, err := uc.repo.GetUserRegardlessOfStatus(c, req.ID)
	if err != nil {
		return nil, err
	}

	companyUser, err := uc.repo.GetCompanyUsersByUsersID(c, req.ID)
	if err != nil {
		return nil, err
	}

	existingProfile, _ := uc.repo.GetProfileByUserId(c, existingUser.ID)

	// for owner and for user freelancer it's not required ...
	switch {
	case req.RoleID == 0 && !(req.UserTypeID == 3 || req.UserTypeID == 4):
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "role id required")

	case req.DepartmentID == 0 && !(req.UserTypeID == 3 || req.UserTypeID == 4):
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "department id required")
	}

	var user *sqlc.User
	errr := sqlc.ExecuteTxWithException(c, uc.pool, func(q sqlc.Querier) *exceptions.Exception {
		currentAddress, _ := q.GetAddress(c, int32(existingProfile.AddressesID))

		var countryId pgtype.Int8
		if req.CountryID == 0 {
			countryId = currentAddress.CountriesID
		} else {
			countryId = pgtype.Int8{Int64: req.CountryID, Valid: req.CountryID != 0}
		}

		var stateId pgtype.Int8
		if req.StateID == nil {
			stateId = currentAddress.StatesID
		} else {
			stateId = pgtype.Int8{Int64: *req.StateID, Valid: *req.StateID != 0}
		}

		var cityId pgtype.Int8
		if req.CityID == nil {
			cityId = currentAddress.CitiesID
		} else {
			cityId = pgtype.Int8{Int64: *req.CityID, Valid: *req.CityID != 0}
		}

		var communityId pgtype.Int8
		if req.CommunityID == nil {
			communityId = currentAddress.CommunitiesID
		} else {
			communityId = pgtype.Int8{Int64: *req.CommunityID, Valid: *req.CommunityID != 0}
		}

		var subCommunityId pgtype.Int8
		if req.SubCommunityID == nil {
			subCommunityId = currentAddress.SubCommunitiesID
		} else {
			subCommunityId = pgtype.Int8{Int64: *req.SubCommunityID, Valid: *req.SubCommunityID != 0}
		}

		address, er := q.UpdateAddress(c, sqlc.UpdateAddressParams{
			ID:               existingProfile.AddressesID,
			CountriesID:      countryId,
			StatesID:         stateId,
			CitiesID:         cityId,
			CommunitiesID:    communityId,
			SubCommunitiesID: subCommunityId,
		})
		if er != nil {
			log.Println("create address err :: ", er)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())
		}

		file, err := c.FormFile("profile_image")
		if file != nil && err == nil {
			var er error
			newProfileImage, er = file_utils.UploadSingleFileToABS(c, file, COMPANY_USERS_PATH)
			if er != nil {
				log.Println("image uploading err :: ", er)
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "[UpdateCompanyUser] error while uploading image")
			}

			profileImage = pgtype.Text{String: newProfileImage, Valid: newProfileImage != ""}

		} else {
			profileImage = existingProfile.ProfileImageUrl
		}
		coverImageFile, err := c.FormFile("cover_image")
		if coverImageFile != nil && err == nil {
			var er error
			newCoverImage, er = file_utils.UploadSingleFileToABS(c, coverImageFile, COMPANY_USERS_PATH)
			if er != nil {
				log.Println("image uploading err :: ", er)
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "[UpdateCompanyUser] error while uploading cover image")
			}
			coverImage = pgtype.Text{String: newCoverImage, Valid: newCoverImage != ""}
		} else {
			coverImage = existingProfile.CoverImageUrl
		}

		passportImageFile, err := c.FormFile("passport_image")
		if passportImageFile != nil && err == nil {
			var er error
			newPassportImage, er = file_utils.UploadSingleFileToABS(c, passportImageFile, COMPANY_USERS_PATH)
			if er != nil {
				log.Println("image uploading err :: ", er)
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "[UpdateCompanyUser] error while uploading passport image")
			}

			passportImage = pgtype.Text{String: newPassportImage, Valid: newPassportImage != ""}
		} else {
			passportImage = existingProfile.PassportImageUrl
		}

		var passportExpieryDate pgtype.Timestamptz
		if req.PassportExpiryDate != nil {
			passportExpieryDate.Time = *req.PassportExpiryDate
			passportExpieryDate.Valid = true
		} else {
			passportExpieryDate.Valid = false
		}

		var gender pgtype.Int8
		if req.Gender == 0 {
			gender = existingProfile.Gender
		} else {
			gender = pgtype.Int8{Int64: req.Gender, Valid: req.Gender != 0}
		}

		if req.FirstName == "" {
			req.FirstName = existingProfile.FirstName
		}

		if req.LastName == "" {
			req.LastName = existingProfile.LastName
		}

		profile, er := q.UpdateProfileForCompanyUser(c, sqlc.UpdateProfileForCompanyUserParams{
			ID:                 existingUser.ProfilesID,
			FirstName:          req.FirstName,
			LastName:           req.LastName,
			AddressesID:        address.ID,
			ProfileImageUrl:    profileImage,
			SecondaryNumber:    pgtype.Text{String: req.SecondaryPhone, Valid: req.SecondaryPhone != ""},
			WhatsappNumber:     pgtype.Text{String: req.WhatsappNumber, Valid: req.WhatsappNumber != ""},
			ShowWhatsappNumber: pgtype.Bool{Bool: req.ShowWhatsAppNumber, Valid: true},
			BotimNumber:        pgtype.Text{String: req.BotimNumber, Valid: req.BotimNumber != ""},
			ShowBotimNumber:    pgtype.Bool{Bool: req.ShowBotimNumber, Valid: true},
			TawasalNumber:      pgtype.Text{String: req.TawasalNumber, Valid: req.TawasalNumber != ""},
			ShowTawasalNumber:  pgtype.Bool{Bool: req.ShowTawasalNumber, Valid: true},
			Gender:             gender,
			UpdatedAt:          time.Now().Round(time.Second),
			CoverImageUrl:      coverImage,
			PassportNo:         pgtype.Text{String: req.PassportNo, Valid: req.PassportNo != ""},
			PassportImageUrl:   passportImage,
			PassportExpiryDate: passportExpieryDate,
			About:              pgtype.Text{String: req.About, Valid: req.About != ""},
			AboutArabic:        pgtype.Text{String: req.AboutArabic, Valid: req.AboutArabic != ""},
		})
		if er != nil {
			log.Println("create profile err :: ", er)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())
		}

		// this needs to be done ....
		if len(req.SpokenLanguages) == 0 {
			req.SpokenLanguages = []int64{}
		}

		// register languages and  nationality ....
		// delete exisiting languages and  create new for update ....
		_, err1 := q.DeleteProfileLanguage(c, profile.ID)
		if err1 != nil {
			log.Println("testing while create profile language :", err1)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err1.Error())
		}

		for _, lang := range req.SpokenLanguages {

			_, err := q.CreateProfileLanguage(c, sqlc.CreateProfileLanguageParams{
				ProfilesID:     profile.ID,
				AllLanguagesID: lang,
			})
			if err != nil {
				log.Println("testing while create profile language :", err)
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
			}
		}
		// delete exisiting nationalities and  create new for update ....
		_, err2 := q.DeleteProfileNationalities(c, profile.ID)
		if err2 != nil {
			log.Println("testing while create profile nationalities :", err1)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err2.Error())
		}

		for _, nat := range req.Nationality {

			_, err := q.CreateProfileNationalities(c, sqlc.CreateProfileNationalitiesParams{
				ProfilesID: profile.ID,
				CountryID:  nat,
			})
			if err != nil {
				log.Println("testing while create profile language :", err)
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
			}
		}

		var experiance pgtype.Timestamptz
		if req.ExperienceSince != nil {
			experiance = pgtype.Timestamptz{Time: *req.ExperienceSince, Valid: !req.ExperienceSince.IsZero()}
		} else {
			experiance = existingUser.ExperienceSince
		}

		if req.Username == "" {
			req.Username = existingUser.Username
		}

		pcode, phone := utils.SplitAndParsePhoneNumber(req.PrimaryPhone)
		phoneNumber := fmt.Sprintf("%v", phone)
		user, err := q.UpdateUser(c, sqlc.UpdateUserParams{
			ID:              req.ID, // user id
			RolesID:         pgtype.Int8{Int64: req.RoleID, Valid: true},
			ShowHideDetails: pgtype.Bool{Bool: req.ShowHideDetails, Valid: true},
			ExperienceSince: experiance,
			UpdatedAt:       time.Now().Round(time.Second),
			PhoneNumber:     pgtype.Text{String: phoneNumber, Valid: phoneNumber != ""},
			Username:        req.Username,
			CountryCode:     pgtype.Int8{Int64: pcode, Valid: pcode != 0},
		})

		if err != nil {
			log.Println("testing err in create user", err)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}

		socialErr := updateAllSocials(c, q, req, user.ID)
		if socialErr != nil {
			log.Println("testing social err", socialErr)
		}

		log.Println("new user ", user.ID)
		if req.UserTypeID == constants.CompanyAdminUserTypes.Int64() || req.UserTypeID == constants.AgentUserTypes.Int64() {
			if req.LeaderID != 0 {
				companyUser, err = q.UpdateCompanyUserByUserID(c, sqlc.UpdateCompanyUserByUserIDParams{
					UsersID: user.ID,
					LeaderID: pgtype.Int8{
						Int64: req.LeaderID,
						Valid: req.LeaderID != 0,
					},
				})
				if err != nil {
					log.Println("update company user err :: ", err)
					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
				}
			}

		}
		////
		// storing licence license  for agent and freelancers
		// TODO: need to delete the older files also ....
		if req.UserTypeID == constants.AgentUserTypes.Int64() {

			brnExistingLicense, er := uc.repo.GetBrnLicenseByUserID(c, req.ID)
			if er != nil && er.ErrorCode != exceptions.NoDataFoundErrorCode {
				return er
			}

			licenseFile, err := c.FormFile("brn_file")
			if err != nil {
				log.Println("testing brn file error:", err)
				// return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "brn file is missing")
			}

			if licenseFile != nil {
				var er error
				brnFile, er = file_utils.UploadSingleFileToABS(c, licenseFile, COMPANY_USERS_PATH)
				if er != nil {
					log.Println("image uploading err :: ", er)
					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "[CreateCompanyUser] error while uploading brn file")
				}
			} else {
				brnFile = brnExistingLicense.LicenseFileUrl.String
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
				licenseExpiryDate = brnExistingLicense.LicenseExpiryDate
			}

			if req.BRNNo == "" {
				req.BRNNo = brnExistingLicense.LicenseNo
			}

			// license
			_, err = q.UpdateLicenseByEntityID(c, sqlc.UpdateLicenseByEntityIDParams{
				EntityID:                user.ID,
				LicenseFileUrl:          pgtype.Text{String: brnFile, Valid: brnFile != ""},
				LicenseNo:               req.BRNNo,
				LicenseIssueDate:        licenseIssueDate,
				LicenseRegistrationDate: licenseRegistrationDate,
				LicenseExpiryDate:       licenseExpiryDate,
				StateID:                 stateId.Int64,
			})
			if err != nil {
				log.Println("testing license err", fmt.Errorf("[UpdateLicenseByEntityID] brn, license :%v", err).Error())
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, fmt.Errorf("[company user] brn, license :%v", err).Error())
			}

			// need to update the agent
			er = updateAgent(c, q, req, companyUser, visitedUser)
			if er != nil {
				return er
			}
		}

		if req.UserTypeID == constants.FreelancerUserTypes.Int64() {
			nocImageFile, err := c.FormFile("noc_file")
			if nocImageFile != nil && err == nil {
				var er error
				nocImage, er = file_utils.UploadSingleFileToABS(c, nocImageFile, COMPANY_USERS_PATH)
				if er != nil {
					log.Println("image uploading err :: ", er)
					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "[CreateCompanyUser] error while uploading noc image")
				}

				// store the license ....

				license, err := q.UpdateLicenseByEntityID(c, sqlc.UpdateLicenseByEntityIDParams{
					LicenseFileUrl: pgtype.Text{
						String: nocImage,
						Valid:  nocImage != "",
					}, // file
					LicenseNo:               req.NocNo,
					LicenseIssueDate:        pgtype.Timestamptz{}, // there is no such thing in the UI
					LicenseRegistrationDate: pgtype.Timestamptz{}, //
					LicenseExpiryDate:       pgtype.Timestamptz{}, //
					StateID:                 stateId.Int64,
					EntityID:                user.ID,
				})
				if err != nil {
					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, fmt.Errorf("[company user] noc, license :%v", err).Error())
				}

				log.Println("testing  brn license...", license)
			}

			if req.UserTypeID == constants.FreelancerUserTypes.Int64() || req.UserTypeID == constants.OwnerOrIndividualUserTypes.Int64() {
				banks, err := q.UpdateBankAccountDetailsByEntityID(c, sqlc.UpdateBankAccountDetailsByEntityIDParams{
					EntityID:      user.ID,
					AccountName:   req.AccountName,
					AccountNumber: req.AccountName,
					Iban:          req.IBANNo,
					CountriesID:   req.BankCountryID,
					CurrencyID:    req.CurrencyID,
					BankName:      req.BankName,
					BankBranch:    req.BankBranch,
					SwiftCode:     req.SwiftCode,
					UpdatedAt:     time.Now(),
					UpdatedBy: pgtype.Int8{
						Int64: visitedUser.ID,
						Valid: true,
					},
				})
				if err != nil {
					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
				}

				log.Println("testing if banks has been created or not", banks)
			}

		}
		return nil
	})

	if errr != nil {
		log.Println("testing err", errr)

		// delete the image that are uploaded
		switch {
		case newProfileImage != "":
			utils.DeleteSingleFileFromABS(newProfileImage)
		case newCoverImage != "":
			utils.DeleteSingleFileFromABS(newCoverImage)
		case newPassportImage != "":
			utils.DeleteSingleFileFromABS(newPassportImage)
		case nocImage != "":
			utils.DeleteSingleFileFromABS(nocImage)
		case brnFile != "":
			utils.DeleteSingleFileFromABS(nocImage)
		}
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(errr.ErrorCode, errr.Error())
	}
	return utils.Ternary[any](companyUser.ID == 0, user, companyUser), nil
}
