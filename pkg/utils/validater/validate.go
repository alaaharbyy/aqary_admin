package validater

import (
	"aqary_admin/internal/domain/dto"
	"aqary_admin/pkg/utils/constants"
	"fmt"
	"time"

	"github.com/asaskevich/govalidator"
)

func ValidateAuctionPayload(payload *dto.AuctionInputsDto) error {
	// Validate the structure using govalidator
	if err := ValidateModel(payload); err != nil {
		return err
	}

	// Validate the Auction Title length
	minTitle, maxTitle, titleLen := constants.AUCTION_TITLE_MIN_LENGTH, constants.AUCTION_TITLE_MAX_LENGTH, len(payload.AuctionTitle)
	if titleLen < minTitle || titleLen > maxTitle {
		return fmt.Errorf("auction title length should be between %d and %d characters", minTitle, maxTitle)
	}

	// Validate the Description length
	minDescription, maxDescription, descriptionLen := constants.AUCTION_DESCRIPTION_MIN_LENGTH, constants.AUCTION_DESCRIPTION_MAX_LENGTH, len(payload.PropertyInfo.Description)
	descriptionArLen := len(payload.PropertyInfo.DescriptionAr)
	if descriptionLen < minDescription || descriptionLen > maxDescription {
		return fmt.Errorf("description length should be between %d and %d characters", minDescription, maxDescription)
	}

	// Validate the Arabic Description length
	if descriptionArLen > maxDescription {
		return fmt.Errorf("arabic description length should be less than or equal to %d characters", maxDescription)
	}

	// Validate the Property Title length
	if payload.PropertyInfo.PropertyTitle != "" && len(payload.PropertyInfo.PropertyTitle) > constants.MAX_PROPERTY_TITLE_LENGTH {
		return fmt.Errorf("property title length should be less than or equal to %d characters", constants.MAX_PROPERTY_TITLE_LENGTH)
	}

	// Validate the Arabic Property Title length
	if payload.PropertyInfo.PropertyTitleArabic != "" && len(payload.PropertyInfo.PropertyTitleArabic) > constants.MAX_PROPERTY_TITLE_LENGTH {
		return fmt.Errorf("arabic property title length should be less than or equal to %d characters", constants.MAX_PROPERTY_TITLE_LENGTH)
	}

	// Validate that the Start Date is greater than or equal to now
	if payload.StartDate.Before(time.Now()) {
		return fmt.Errorf("auction start date should be greater than or equal to the current time")
	}

	// Validate that the End Date is greater than or equal to the Start Date
	if payload.EndDate.Before(payload.StartDate) {
		return fmt.Errorf("auction end date should be greater than or equal to the start date")
	}

	// Validate that the Pre-Bid Start Date is greater than or equal to now
	if !payload.PrebidStartDate.IsZero() && payload.PrebidStartDate.Before(time.Now()) {
		return fmt.Errorf("auction pre-bid start date should be greater than or equal to the current time")
	}

	// Validate Contract Info
	if payload.PropertyInfo.TenentContract != nil {
		// Validate that the End Date is greater than or equal to the Start Date
		if payload.PropertyInfo.TenentContract.ContractEndDate.Before(payload.PropertyInfo.TenentContract.ContractStartDate) {
			return fmt.Errorf("tenent contract end date should be greater than or equal to the start date")
		}
	}

	return nil
}

// ValidateModel validates the struct using govalidator
func ValidateModel(req interface{}) error {
	_, err := govalidator.ValidateStruct(req)
	if err != nil {
		return err
	}
	return nil
}
