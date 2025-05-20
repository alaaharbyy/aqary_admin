package companyuser_usecase

import (
	domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/constants"
	"aqary_admin/pkg/utils/exceptions"
	"log"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
)

// // TODO: need to make sure it consume the free one first
// func handleAgent(c *gin.Context, q sqlc.Querier, req domain.CreateUserReq, companyUser *sqlc.CompanyUser, visitedUser sqlc.User) *exceptions.Exception {

// 	var standard, feature, premium, topdeal pgtype.Int8
// 	if req.Standard != nil {
// 		standard.Int64 = *req.Standard
// 		standard.Valid = true
// 	} else {
// 		standard.Valid = false
// 	}

// 	if req.Feature != nil {
// 		feature.Int64 = *req.Feature
// 		feature.Valid = true
// 	} else {
// 		feature.Valid = false

// 	}

// 	if req.Premium != nil {
// 		premium.Int64 = *req.Premium
// 		premium.Valid = true
// 	} else {
// 		premium.Valid = false
// 	}

// 	if req.TopDeal != nil {
// 		topdeal.Int64 = *req.TopDeal
// 		topdeal.Valid = true
// 	} else {
// 		topdeal.Valid = false
// 	}

// 	subscriptions, err := q.GetRemainingCreditToAssignAgentByCompany(c, utils.Ternary[int64](visitedUser.ActiveCompany.Int64 != 0, visitedUser.ActiveCompany.Int64, companyUser.CompanyID))
// 	if err != nil {
// 		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
// 	}

// 	for _, sub := range subscriptions {

// 		switch {
// 		case standard.Valid && strings.EqualFold(sub.Product, "standard"):
// 			if !standard.Valid {
// 				continue
// 			}
// 			if standard.Int64 > sub.Remaining {
// 				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "you cannot give more products then available")
// 			}

// 			if sub.Remaining > 0 {
// 				_, err := q.CreateAgentProducts(c, sqlc.CreateAgentProductsParams{
// 					CompanyUserID: companyUser.ID, //
// 					Product:       sub.ProductID,  // product id
// 					NoOfProducts:  int32(standard.Int64),
// 					CreatedBy:     visitedUser.ID,
// 					CreatedAt:     time.Now(),
// 					UpdatedAt:     time.Now(),
// 				})
// 				if err != nil {
// 					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error())
// 				}

// 			}
// 		case feature.Valid && strings.EqualFold(sub.Product, "featured"):
// 			if !feature.Valid {
// 				continue
// 			}

// 			if feature.Int64 > sub.Remaining {
// 				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "you cannot give more standard products then available")
// 			}

// 			if sub.Remaining > 0 {
// 				args := sqlc.CreateAgentProductsParams{
// 					CompanyUserID: companyUser.ID, //
// 					Product:       sub.ProductID,  // product id
// 					NoOfProducts:  int32(feature.Int64),
// 					CreatedBy:     visitedUser.ID,
// 					CreatedAt:     time.Now(),
// 					UpdatedAt:     time.Now(),
// 				}
// 				_, err := q.CreateAgentProducts(c, args)
// 				if err != nil {
// 					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error())
// 				}

// 			}
// 		case premium.Valid && strings.EqualFold(sub.Product, "premium"):

// 			if !premium.Valid {
// 				continue
// 			}
// 			if premium.Int64 > sub.Remaining {
// 				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "you cannot give more  premium products then available")
// 			}

// 			if sub.Remaining > 0 {
// 				_, err := q.CreateAgentProducts(c, sqlc.CreateAgentProductsParams{
// 					CompanyUserID: companyUser.ID, //
// 					Product:       sub.ProductID,  // product id
// 					NoOfProducts:  int32(premium.Int64),
// 					CreatedBy:     visitedUser.ID,
// 					CreatedAt:     time.Now(),
// 					UpdatedAt:     time.Now(),
// 				})
// 				if err != nil {
// 					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error())
// 				}

// 			}
// 		case topdeal.Valid && strings.EqualFold(sub.Product, "top deals"):
// 			if !topdeal.Valid {
// 				continue
// 			}
// 			if topdeal.Int64 > sub.Remaining {
// 				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "you cannot give more products then available")
// 			}

// 			if sub.Remaining > 0 {
// 				_, err := q.CreateAgentProducts(c, sqlc.CreateAgentProductsParams{
// 					CompanyUserID: companyUser.ID, //
// 					Product:       sub.ProductID,  // product id
// 					NoOfProducts:  int32(topdeal.Int64),
// 					CreatedBy:     visitedUser.ID,
// 					CreatedAt:     time.Now(),
// 					UpdatedAt:     time.Now(),
// 				})
// 				if err != nil {
// 					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error())
// 				}

// 			}

// 		}
// 	}

// 	return nil
// }

// TODO: need to make sure it consume the free one first
func updateAgent(c *gin.Context, q sqlc.Querier, req domain.UpdateCompanyUserRequest, companyUser sqlc.CompanyUser, visitedUser sqlc.User) *exceptions.Exception {

	var standard, feature, premium, topdeal pgtype.Int8
	if req.Standard != nil {
		standard.Int64 = *req.Standard
		standard.Valid = true
	} else {
		standard.Valid = false
	}

	if req.Feature != nil {
		feature.Int64 = *req.Feature
		feature.Valid = true
	} else {
		feature.Valid = false

	}

	if req.Premium != nil {
		premium.Int64 = *req.Premium
		premium.Valid = true
	} else {
		premium.Valid = false
	}

	if req.TopDeal != nil {
		topdeal.Int64 = *req.TopDeal
		topdeal.Valid = true
	} else {
		topdeal.Valid = false
	}

	if topdeal.Int64 < 0 || premium.Int64 < 0 || feature.Int64 < 0 || standard.Int64 < 0 {
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "product value should not be less than 0")
	}

	subscriptions, err := q.GetRemainingCreditToAssignAgentByCompany(c, utils.Ternary[int64](visitedUser.ActiveCompany.Int64 != 0, visitedUser.ActiveCompany.Int64, companyUser.CompanyID))
	if err != nil {
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	for _, sub := range subscriptions {
		switch {
		case standard.Valid && strings.EqualFold(sub.Product, "standard"):
			if !standard.Valid {
				continue
			}

			assigned, _ := q.GetAssignCreditByAgentIdAndProduct(c, sqlc.GetAssignCreditByAgentIdAndProductParams{
				CompanyUserID: companyUser.ID,
				ID:            sub.ProductID,
			})
			remaining := int64(assigned) + sub.Remaining

			if standard.Int64 > remaining {
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "you cannot give more products then available")
			}

			if standard.Int64 > 0 {

				_, err := q.UpdateAgentProductsByCompUserID(c, sqlc.UpdateAgentProductsByCompUserIDParams{
					CompanyUserID: companyUser.ID,
					NoOfProducts:  int32(standard.Int64),
					ProductID:     sub.ProductID,
				})
				if err != nil && err != pgx.ErrNoRows {
					log.Println("error is here...standard..", err, companyUser.ID, standard.Int64, sub.ProductID)
					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error())
				}
				if err == pgx.ErrNoRows {
					_, err := setUserPackage(c, q, domain.SetUserPackageReq{
						CompanyID: req.CompanyID,
						UserID:    req.ID,
						Standard:  &standard.Int64,
					}, &companyUser, visitedUser)
					if err != nil {
						return err
					}
				}

			}
		case feature.Valid && strings.EqualFold(sub.Product, "featured"):
			if !feature.Valid {
				continue
			}

			assigned, _ := q.GetAssignCreditByAgentIdAndProduct(c, sqlc.GetAssignCreditByAgentIdAndProductParams{
				CompanyUserID: companyUser.ID,
				ID:            sub.ProductID,
			})
			remaining := int64(assigned) + sub.Remaining

			if feature.Int64 > remaining {
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "you cannot give more standard products then available")
			}

			if feature.Int64 > 0 {
				args := sqlc.UpdateAgentProductsByCompUserIDParams{
					CompanyUserID: companyUser.ID,
					NoOfProducts:  int32(feature.Int64),
					ProductID:     sub.ProductID,
				}
				_, err := q.UpdateAgentProductsByCompUserID(c, args)
				if err != nil && err != pgx.ErrNoRows {
					log.Println("error is here...featured..", err)
					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error())
				}
				if err == pgx.ErrNoRows {
					_, err := setUserPackage(c, q, domain.SetUserPackageReq{
						CompanyID: req.CompanyID,
						UserID:    req.ID,
						Feature:   &feature.Int64,
					}, &companyUser, visitedUser)
					if err != nil {
						return err
					}
				}

			}
		case premium.Valid && strings.EqualFold(sub.Product, "premium"):

			if !premium.Valid {
				continue
			}

			assigned, _ := q.GetAssignCreditByAgentIdAndProduct(c, sqlc.GetAssignCreditByAgentIdAndProductParams{
				CompanyUserID: companyUser.ID,
				ID:            sub.ProductID,
			})
			remaining := int64(assigned) + sub.Remaining

			if premium.Int64 > remaining {
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "you cannot give more  premium products then available")
			}

			if premium.Int64 > 0 {
				_, err := q.UpdateAgentProductsByCompUserID(c, sqlc.UpdateAgentProductsByCompUserIDParams{
					CompanyUserID: companyUser.ID,
					NoOfProducts:  int32(premium.Int64),
					ProductID:     sub.ProductID,
				})
				if err != nil && err != pgx.ErrNoRows {
					log.Println("error is here...premium..", err)
					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error())
				}
				if err == pgx.ErrNoRows {
					_, err := setUserPackage(c, q, domain.SetUserPackageReq{
						CompanyID: req.CompanyID,
						UserID:    req.ID,
						Premium:   &premium.Int64,
					}, &companyUser, visitedUser)
					if err != nil {
						return err
					}
				}
			}
		case topdeal.Valid && strings.EqualFold(sub.Product, "top deals"):
			if !topdeal.Valid {
				continue
			}

			assigned, _ := q.GetAssignCreditByAgentIdAndProduct(c, sqlc.GetAssignCreditByAgentIdAndProductParams{
				CompanyUserID: companyUser.ID,
				ID:            sub.ProductID,
			})
			remaining := int64(assigned) + sub.Remaining

			if topdeal.Int64 > remaining {
				return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "you cannot give more products then available")
			}

			if topdeal.Int64 > 0 {
				_, err := q.UpdateAgentProductsByCompUserID(c, sqlc.UpdateAgentProductsByCompUserIDParams{
					CompanyUserID: companyUser.ID,
					NoOfProducts:  int32(topdeal.Int64),
					ProductID:     sub.ProductID,
				})
				if err != nil && err != pgx.ErrNoRows {
					log.Println("error is here...top deals..", err)
					return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error())
				}
				if err == pgx.ErrNoRows {
					_, err := setUserPackage(c, q, domain.SetUserPackageReq{
						CompanyID: req.CompanyID,
						UserID:    req.ID,
						TopDeal:   &topdeal.Int64,
					}, &companyUser, visitedUser)
					if err != nil {
						return err
					}
				}

			}

		}
	}

	return nil
}

func setUserPackage(c *gin.Context, q sqlc.Querier, req domain.SetUserPackageReq, companyUser *sqlc.CompanyUser, visitedUser sqlc.User) (SubscriptionOutput, *exceptions.Exception) {

	var standard, feature, premium, topdeal pgtype.Int8
	if req.Standard != nil {
		standard.Int64 = *req.Standard
		standard.Valid = true
	} else {
		standard.Valid = false
	}

	if req.Feature != nil {
		feature.Int64 = *req.Feature
		feature.Valid = true
	} else {
		feature.Valid = false

	}

	if req.Premium != nil {
		premium.Int64 = *req.Premium
		premium.Valid = true
	} else {
		premium.Valid = false
	}

	if req.TopDeal != nil {
		topdeal.Int64 = *req.TopDeal
		topdeal.Valid = true
	} else {
		topdeal.Valid = false
	}

	if topdeal.Int64 < 0 || premium.Int64 < 0 || feature.Int64 < 0 || standard.Int64 < 0 {
		return SubscriptionOutput{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "product value should not be less than 0")
	}

	subscriptions, err := q.GetRemainingCreditToAssignAgentByCompany(c, utils.Ternary[int64](visitedUser.ActiveCompany.Int64 != 0, visitedUser.ActiveCompany.Int64, companyUser.CompanyID))
	if err != nil {
		return SubscriptionOutput{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	for _, sub := range subscriptions {

		switch {
		case standard.Valid && strings.EqualFold(sub.Product, "standard"):
			if !standard.Valid {
				continue
			}

			if standard.Int64 > sub.Remaining {
				return SubscriptionOutput{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "you cannot give more products then available")
			}

			if sub.Remaining > 0 {
				_, err := q.CreateAgentProducts(c, sqlc.CreateAgentProductsParams{
					CompanyUserID: companyUser.ID, //
					Product:       sub.ProductID,  // product id
					NoOfProducts:  int32(standard.Int64),
					CreatedBy:     visitedUser.ID,
					CreatedAt:     time.Now(),
					UpdatedAt:     time.Now(),
				})
				if err != nil {
					return SubscriptionOutput{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error())
				}

			}
		case feature.Valid && strings.EqualFold(sub.Product, "featured"):
			if !feature.Valid {
				continue
			}

			if feature.Int64 > sub.Remaining {
				return SubscriptionOutput{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "you cannot give more standard products then available")
			}

			if sub.Remaining > 0 {
				args := sqlc.CreateAgentProductsParams{
					CompanyUserID: companyUser.ID, //
					Product:       sub.ProductID,  // product id
					NoOfProducts:  int32(feature.Int64),
					CreatedBy:     visitedUser.ID,
					CreatedAt:     time.Now(),
					UpdatedAt:     time.Now(),
				}
				_, err := q.CreateAgentProducts(c, args)
				if err != nil {
					return SubscriptionOutput{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error())
				}

			}
		case premium.Valid && strings.EqualFold(sub.Product, "premium"):

			if !premium.Valid {
				continue
			}

			if premium.Int64 > sub.Remaining {
				return SubscriptionOutput{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "you cannot give more  premium products then available")
			}

			if sub.Remaining > 0 {
				_, err := q.CreateAgentProducts(c, sqlc.CreateAgentProductsParams{
					CompanyUserID: companyUser.ID, //
					Product:       sub.ProductID,  // product id
					NoOfProducts:  int32(premium.Int64),
					CreatedBy:     visitedUser.ID,
					CreatedAt:     time.Now(),
					UpdatedAt:     time.Now(),
				})
				if err != nil {
					return SubscriptionOutput{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error())
				}

			}
		case topdeal.Valid && strings.EqualFold(sub.Product, "top deals"):
			if !topdeal.Valid {
				continue
			}

			if topdeal.Int64 > sub.Remaining {
				return SubscriptionOutput{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "you cannot give more products then available")
			}

			if sub.Remaining > 0 {
				_, err := q.CreateAgentProducts(c, sqlc.CreateAgentProductsParams{
					CompanyUserID: companyUser.ID, //
					Product:       sub.ProductID,  // product id
					NoOfProducts:  int32(topdeal.Int64),
					CreatedBy:     visitedUser.ID,
					CreatedAt:     time.Now(),
					UpdatedAt:     time.Now(),
				})
				if err != nil {
					return SubscriptionOutput{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, err.Error())
				}

			}

		}
	}

	return SubscriptionOutput{
		Standard: format{
			Label:        "standard",
			NoOfProducts: standard.Int64,
		},
		Feature: format{
			Label:        "featured",
			NoOfProducts: feature.Int64,
		},
		Premium: format{
			Label:        "premium",
			NoOfProducts: premium.Int64,
		},
		TopDeal: format{
			Label:        "top deals",
			NoOfProducts: topdeal.Int64,
		},
	}, nil
}

func registerAllSocials(c *gin.Context, q sqlc.Querier, req domain.CreateUserReq, userId int64) error {

	if req.Facebook != "" {
		_, err := q.CreateSocialMediaProfile(c, sqlc.CreateSocialMediaProfileParams{
			SocialMediaName: "facebook",
			SocialMediaUrl:  req.Facebook,
			EntityTypeID:    constants.UserEntityType.Int64(),
			EntityID:        userId,
		})
		if err != nil {
			return err
		}

	}

	if req.LinkedIn != "" {
		_, err := q.CreateSocialMediaProfile(c, sqlc.CreateSocialMediaProfileParams{
			SocialMediaName: "linkedin",
			SocialMediaUrl:  req.LinkedIn,
			EntityTypeID:    constants.UserEntityType.Int64(),
			EntityID:        userId,
		})
		if err != nil {
			return err
		}

	}

	if req.Twitter != "" {
		_, err := q.CreateSocialMediaProfile(c, sqlc.CreateSocialMediaProfileParams{
			SocialMediaName: "twitter",
			SocialMediaUrl:  req.Twitter,
			EntityTypeID:    constants.UserEntityType.Int64(),
			EntityID:        userId,
		})
		if err != nil {
			return err
		}

	}

	return nil
}

func updateAllSocials(c *gin.Context, q sqlc.Querier, req domain.UpdateCompanyUserRequest, userId int64) error {

	if req.Facebook != "" {
		_, err := q.UpdateSocialMediaProfile(c, sqlc.UpdateSocialMediaProfileParams{
			EntityID:       userId,
			Lower:          req.Facebook,
			SocialMediaUrl: req.Facebook,
		})
		if err != nil {
			return err
		}

	}

	if req.LinkedIn != "" {
		_, err := q.UpdateSocialMediaProfile(c, sqlc.UpdateSocialMediaProfileParams{
			EntityID:       userId,
			Lower:          req.LinkedIn,
			SocialMediaUrl: req.LinkedIn,
		})
		if err != nil {
			return err
		}

	}

	if req.Twitter != "" {
		_, err := q.UpdateSocialMediaProfile(c, sqlc.UpdateSocialMediaProfileParams{
			EntityID:       userId,
			Lower:          req.Twitter,
			SocialMediaUrl: req.Twitter,
		})
		if err != nil {
			return err
		}

	}

	return nil
}

// Helper functions for each specific type
func safeDepartmentID(d sqlc.Department) int64 {
	if d.ID == 0 { // Assuming 0 is the zero value for ID
		return 0
	}
	return d.ID
}

func safeDepartmentName(d sqlc.Department) string {
	return d.Department
}

func safeRoleID(r sqlc.Role) int64 {
	if r.ID == 0 {
		return 0
	}
	return r.ID
}

func safeRoleName(r sqlc.Role) string {
	return r.Role
}

func safeBRNLicenseNo(b sqlc.License) string {
	if b.ID == 0 {
		return ""
	}
	return b.LicenseNo
}

func safeBRNLicenseExpiryDate(b sqlc.License) pgtype.Timestamptz {
	if b.ID == 0 {
		return pgtype.Timestamptz{Valid: false}
	}
	return b.LicenseExpiryDate
}

func safeBRNLicenseIssueDate(b sqlc.License) time.Time {
	if b.ID == 0 {
		return time.Time{}
	}
	return b.LicenseIssueDate.Time
}

func safeBRNLicenseRegistrationDate(b sqlc.License) time.Time {
	if b.ID == 0 {
		return time.Time{}
	}
	return b.LicenseRegistrationDate.Time
}

func safeNOCLicenseNo(n sqlc.License) string {
	if n.ID == 0 {
		return ""
	}
	return n.LicenseNo
}

func safeNOCLicenseFileURL(n sqlc.License) string {
	if n.ID == 0 {
		return ""
	}
	return n.LicenseFileUrl.String
}

func safeBankAccountNumber(b *sqlc.BankAccountDetail) string {
	if b == nil {
		return ""
	}
	return b.AccountNumber
}

func safeBankAccountName(b *sqlc.BankAccountDetail) string {
	if b == nil {
		return ""
	}
	return b.AccountName
}

func safeBankIBAN(b *sqlc.BankAccountDetail) string {
	if b == nil {
		return ""
	}
	return b.Iban
}

func safeBankName(b *sqlc.BankAccountDetail) string {
	if b == nil {
		return ""
	}
	return b.BankName
}

func safeBankBranch(b *sqlc.BankAccountDetail) string {
	if b == nil {
		return ""
	}
	return b.BankBranch
}

func safeBankSwiftCode(b *sqlc.BankAccountDetail) string {
	if b == nil {
		return ""
	}
	return b.SwiftCode
}
