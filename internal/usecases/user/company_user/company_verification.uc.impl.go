package companyuser_usecase

import (
	"aqary_admin/internal/delivery/rest/middleware"
	domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/constants"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/fn"
	"aqary_admin/pkg/utils/security"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
)

func (uc *companyUserUseCase) UserLicenseVerification(c *gin.Context, req domain.CreateUserLicenseVerficiationReq) (*string, *exceptions.Exception) {

	authPayload, _ := c.MustGet(middleware.AuthorizationPayloadKey).(*security.Payload)
	_, err := uc.repo.GetUserByName(c, authPayload.Username)
	if err != nil {
		return nil, err
	}

	license, err := uc.repo.GetUserLicenseByID(c, req.LisenceID)
	if err != nil {
		return nil, err
	}

	if license == nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "no license found")
	}

	// if request for approve
	if req.VerificationType == 1 {

		if !license.LicenseFileUrl.Valid || license.LicenseFileUrl.String == "" {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "license file is missing, upload & retry for verification.")
		}

		if license.LicenseNo == "" {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "license number is missing, update & retry for verification.")
		}

		if !license.LicenseExpiryDate.Valid || license.LicenseExpiryDate.Time.IsZero() {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "license expiry date is missing, update & retry for verification.")
		}

		if license.LicenseExpiryDate.Time.UTC().Before(time.Now().Round(time.Second).UTC()) {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "license is expired, cannot be process for verification.")
		}

	}

	err = uc.repo.VerifyCompanyUserByUserId(c, sqlc.VerifyCompanyUserByUserIdParams{
		UsersID:    license.EntityID,
		IsVerified: pgtype.Bool{Bool: req.VerificationType == 1, Valid: true},
	}, nil)

	if err != nil {
		return nil, err
	}

	// TODO :: send notification to company admin here for both scenarios(approve & reject(with reason))

	successMsg := ""
	if req.VerificationType == 1 {
		successMsg = "verified sucessfully"
	} else {
		successMsg = "rejected sucessfully"
	}

	return &successMsg, nil
}

func (uc *companyUserUseCase) GetUserLicenses(c *gin.Context, userID int64) ([]domain.UserLicenseOutput, *exceptions.Exception) {

	authPayload, _ := c.MustGet(middleware.AuthorizationPayloadKey).(*security.Payload)
	_, err := uc.repo.GetUserByName(c, authPayload.Username)
	if err != nil {
		return nil, err
	}

	var licenses []domain.UserLicenseOutput
	brnLicense, err := uc.repo.GetBrnLicenseByUserID(c, userID)

	if err != nil {
		return nil, err
	}

	if brnLicense == nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "license not found")
	}

	licenses = append(licenses, domain.UserLicenseOutput{
		ID:                      brnLicense.ID,
		LicenseFileUrl:          brnLicense.LicenseFileUrl.String,
		LicenseNo:               brnLicense.LicenseNo,
		LicenseIssueDate:        brnLicense.LicenseIssueDate.Time.String(),
		LicenseRegistrationDate: brnLicense.LicenseRegistrationDate.Time.String(),
		LicenseExpiryDate:       brnLicense.LicenseExpiryDate.Time,
		LicenseTypeID: fn.CustomFormat{
			ID:   brnLicense.LicenseTypeID,
			Name: constants.LicenseType.ConstantName(brnLicense.LicenseTypeID),
		}, // brn id lable
		StateID:      brnLicense.StateID,
		EntityTypeID: brnLicense.EntityTypeID,
		EntityID:     brnLicense.EntityID,
		// VerificationStatus: int64(userLicense.Verification),
	})

	return licenses, nil
}

func (uc *companyUserUseCase) SetTeamLeader(c *gin.Context, req domain.SetTeamLeaderReq) (any, *exceptions.Exception) {

	companyUser, err := uc.store.GetCompanyUserByUserId(c, sqlc.GetCompanyUserByUserIdParams{
		CompanyID: 0, // todo: need to be fetched from db for the loggedin  current company || by default it will be zero
		UserID:    req.UserID,
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "user not found")
		}
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	updateUser, err := uc.store.UpdateCompanyUser(c, sqlc.UpdateCompanyUserParams{
		ID:        companyUser.ID,
		UsersID:   companyUser.UsersID,
		CompanyID: companyUser.CompanyID,
		LeaderID: pgtype.Int8{
			Int64: req.LeaderID,
			Valid: true,
		},
	})
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
	}

	return updateUser, nil
}

func (uc *companyUserUseCase) GetSubscriptionOrderPackageDetailByUserID(c *gin.Context, req domain.GetSubscriptionOrderPackageDetailByUserIDReq) (any, *exceptions.Exception) {

	var allOutput []domain.SubscriptionPackageDetailOutput
	var freeAllOutput []domain.FreeSubscriptionPackageDetailOutput

	if req.UserType == constants.FreelancerUserTypes.Int64() {
		req.UserType = constants.FreelancerSubscriberType.Int64()
	}

	subs, err := uc.repo.GetSubscriptionOrderPackageDetailByUserID(c, sqlc.GetSubscriptionOrderPackageDetailByUserIDParams{
		SubscriptionType: req.UserType,
		Free:             utils.Ternary[int64](req.Type == 1, 0, 1),
		Paid:             utils.Ternary[int64](req.Type == 2, 0, 1),
		SubscriberID:     req.UserID,
	})

	if err != nil {
		return nil, err
	}

	if len(subs) == 0 {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "No Subscriptions found")
	}

	var allIds []int64
	var output domain.SubscriptionPackageDetailOutput
	var freeOutput domain.FreeSubscriptionPackageDetailOutput
	var totalUnits int64

	for _, sub := range subs {

		totalUnits += sub.NoOfProducts
		output.TotalUnits = totalUnits

		if req.Type == 1 { // paid

			if utils.ContainsInt(allIds, sub.OrderID) {
				if strings.EqualFold(sub.Product, "Standard") {
					allOutput[len(allOutput)-1].Standard = domain.Subscriptions{
						Quantity: sub.NoOfProducts,
						Price:    fmt.Sprintf("%v", sub.OriginalPricePerUnit),
						Discount: int64(sub.ProductDiscount),
					}
				}

				if strings.EqualFold(sub.Product, "Featured") {
					allOutput[len(allOutput)-1].Feature = domain.Subscriptions{
						Quantity: sub.NoOfProducts,
						Price:    fmt.Sprintf("%v", sub.OriginalPricePerUnit),
						Discount: int64(sub.ProductDiscount),
					}
				}

				if strings.EqualFold(sub.Product, "Premium") {
					allOutput[len(allOutput)-1].Premium = domain.Subscriptions{
						Quantity: sub.NoOfProducts,
						Price:    fmt.Sprintf("%v", sub.OriginalPricePerUnit),
						Discount: int64(sub.ProductDiscount),
					}
				}

				if strings.EqualFold(sub.Product, "Top Deals") {
					allOutput[len(allOutput)-1].TopDeal = domain.Subscriptions{
						Quantity: sub.NoOfProducts,
						Price:    fmt.Sprintf("%v", sub.OriginalPricePerUnit),
						Discount: int64(sub.ProductDiscount),
					}
				}
				// also update the totalNoProducts

				allOutput[len(allOutput)-1].TotalUnits = totalUnits
			} else {

				if strings.EqualFold(sub.Product, "Standard") {
					output.Standard = domain.Subscriptions{
						Quantity: sub.NoOfProducts,
						Price:    fmt.Sprintf("%v", sub.OriginalPricePerUnit),
						Discount: int64(sub.ProductDiscount),
					}
				}

				if strings.EqualFold(sub.Product, "Featured") {
					output.Feature = domain.Subscriptions{
						Quantity: sub.NoOfProducts,
						Price:    fmt.Sprintf("%v", sub.OriginalPricePerUnit),
						Discount: int64(sub.ProductDiscount),
					}
				}

				if strings.EqualFold(sub.Product, "Premium") {
					output.Premium = domain.Subscriptions{
						Quantity: sub.NoOfProducts,
						Price:    fmt.Sprintf("%v", sub.OriginalPricePerUnit),
						Discount: int64(sub.ProductDiscount),
					}
				}

				if strings.EqualFold(sub.Product, "Top Deals") {
					output.TopDeal = domain.Subscriptions{
						Quantity: sub.NoOfProducts,
						Price:    fmt.Sprintf("%v", sub.OriginalPricePerUnit),
						Discount: int64(sub.ProductDiscount),
					}
				}
				output.StartDate = sub.StartDate.Time
				output.EndDate = sub.EndDate.Time
				output.Amount = fmt.Sprintf("%v", sub.TotalAmount)
				output.Duration = DurationToPaymentPlan(Subscription{
					StartDate: sub.StartDate.Time,
					EndDate:   sub.EndDate.Time,
				})
				output.Status = fn.CustomFormat{
					ID:   sub.Status,
					Name: constants.Statuses.ConstantName(sub.Status),
				}

				allOutput = append(allOutput, output)
				allIds = append(allIds, sub.OrderID)
			}

		} else if req.Type == 2 { // free

			if utils.ContainsInt(allIds, sub.OrderID) {
				if strings.EqualFold(sub.Product, "Standard") {
					freeAllOutput[len(freeAllOutput)-1].Standard = domain.FreeSubscriptions{
						Quantity:  sub.NoOfProducts,
						StartDate: sub.StartDate.Time,
						EndDate:   sub.EndDate.Time,
					}
				}

				if strings.EqualFold(sub.Product, "Featured") {
					freeAllOutput[len(allOutput)-1].Feature = domain.FreeSubscriptions{
						Quantity:  sub.NoOfProducts,
						StartDate: sub.StartDate.Time,
						EndDate:   sub.EndDate.Time,
					}

				}

				if strings.EqualFold(sub.Product, "Premium") {
					freeAllOutput[len(freeAllOutput)-1].Premium = domain.FreeSubscriptions{
						Quantity: sub.NoOfProducts, StartDate: sub.StartDate.Time,
						EndDate: sub.EndDate.Time,
					}
				}

				if strings.EqualFold(sub.Product, "Top Deals") {
					freeAllOutput[len(freeAllOutput)-1].TopDeal = domain.FreeSubscriptions{
						Quantity: sub.NoOfProducts, StartDate: sub.StartDate.Time,
						EndDate: sub.EndDate.Time,
					}
				}
				// also update the totalNoProducts

				freeAllOutput[len(freeAllOutput)-1].TotalUnits = totalUnits
			} else {

				if strings.EqualFold(sub.Product, "Standard") {
					freeOutput.Standard = domain.FreeSubscriptions{
						Quantity:  sub.NoOfProducts,
						StartDate: sub.StartDate.Time,
						EndDate:   sub.EndDate.Time,
					}
				}

				if strings.EqualFold(sub.Product, "Featured") {
					freeOutput.Feature = domain.FreeSubscriptions{
						Quantity:  sub.NoOfProducts,
						StartDate: sub.StartDate.Time,
						EndDate:   sub.EndDate.Time,
					}
				}

				if strings.EqualFold(sub.Product, "Premium") {
					freeOutput.Premium = domain.FreeSubscriptions{
						Quantity:  sub.NoOfProducts,
						StartDate: sub.StartDate.Time,
						EndDate:   sub.EndDate.Time,
					}
				}

				if strings.EqualFold(sub.Product, "Top Deals") {
					freeOutput.TopDeal = domain.FreeSubscriptions{
						Quantity:  sub.NoOfProducts,
						StartDate: sub.StartDate.Time,
						EndDate:   sub.EndDate.Time,
					}
				}
				freeOutput.StartDate = sub.StartDate.Time
				freeOutput.EndDate = sub.EndDate.Time
				freeOutput.Amount = fmt.Sprintf("%v", sub.TotalAmount)
				freeOutput.Duration = DurationToPaymentPlan(Subscription{
					StartDate: sub.StartDate.Time,
					EndDate:   sub.EndDate.Time,
				})
				freeOutput.Status = fn.CustomFormat{
					ID:   sub.Status,
					Name: constants.Statuses.ConstantName(sub.Status),
				}

				freeAllOutput = append(freeAllOutput, freeOutput)
				allIds = append(allIds, sub.OrderID)
			}

		}

	}

	return utils.Ternary[any](req.Type == 1, allOutput, freeAllOutput), nil
}

type Subscription struct {
	StartDate time.Time
	EndDate   time.Time
}

func DurationToPaymentPlan(sub Subscription) string {
	duration := sub.EndDate.Sub(sub.StartDate)

	switch {
	case duration <= 31*24*time.Hour:
		return fmt.Sprintf("%v", constants.MonthlyPaymentPlan.Name())
	case duration <= 93*24*time.Hour:
		return fmt.Sprintf("%v", constants.QuartelyPaymentPlan.Name())
	case duration <= 186*24*time.Hour:
		return fmt.Sprintf("%v", constants.BiAnnualPaymentPlan.Name())
	default:
		return fmt.Sprintf("%v", constants.YearlyPaymentPlan.Name())
	}
}
