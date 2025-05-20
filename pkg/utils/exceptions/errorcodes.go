package exceptions

import "net/http"

type ErrorCode string
type ErrorMessage string

const (
	SomethingWentWrongErrorCode ErrorCode = "00SWR"
	BadRequestErrorCode         ErrorCode = "000BR"
	UserNotAuthorizedErrorCode  ErrorCode = "00UNA"
	InvalidCredentialsErrorCode ErrorCode = "00ILC"
	PermissionDeniedErrorCode   ErrorCode = "000PD"
	NoDataFoundErrorCode        ErrorCode = "00UNF"
	// EmailAlreadyExistErrorCode          ErrorCode = "00EAE"
	CannotGiveEmailAndUsernameErrorCode ErrorCode = "CGEAU"
	CompanyNotVerifiedErrorCode         ErrorCode = "CNVEC"
	AlreadyExistCode                    ErrorCode = "000AE"
	UniqueConstraintViolationErrorCode  ErrorCode = "00UCV"
	// Add specific error codes for username and email uniqueness
	UsernameAlreadyExistsErrorCode ErrorCode = "00UAE"
	EmailAlreadyExistsErrorCode    ErrorCode = "00EAE"

	// auction
	EmailAlreadyExistErrorCode     ErrorCode = "00EAE"
	DuplicatePlanTitleErrorCode    ErrorCode = "0PTAE"
	DuplicateDocumentTypeErrorCode ErrorCode = "0DTAP"
	InvalidAuctionTypeErrorCode    ErrorCode = "00IAT"
	InvalidPlatformTypeErrorCode   ErrorCode = "00IPT"
	ActivityTypeNotFountErrorCode  ErrorCode = "0ATNF"
	AuctionCanNotUpdateErrorCode   ErrorCode = "0ACNU"
	DuplicateAuctionTitleErrorCode ErrorCode = "00DAT"
	MediaNotFoundErorrCode         ErrorCode = "0MUNF"
	PlanDocumentNotFoundErrorCode  ErrorCode = "0PUNF"
	DocumentNotFoundErrorCode      ErrorCode = "0DUNF"
)

const (
	somethingWentWrong           ErrorMessage = "something went wrong"
	badRequestMessage            ErrorMessage = "bad request"
	userNotAuthorizedMessage     ErrorMessage = "user not authorized,please login"
	invalidCredentialsMessage    ErrorMessage = "invalid login credentials"
	permissionDeniedErrormessage ErrorMessage = "permission denied for this action"
	noDataFoundErrormessage      ErrorMessage = "no data found"
	// emailAlreadyExistErrorMessage       ErrorMessage = "one account already exist with this email, please try with another one"
	cannotGiveEmailAndUsernameErrorCode ErrorMessage = "cannot give email and username"
	companyNotVerifiedErrorCode         ErrorMessage = "your company is not verified"
	alreadyExistCode                    ErrorMessage = "already exist"
	uniqueConstraintViolationMessage    ErrorMessage = "a unique constraint was violated"
	usernameAlreadyExistsMessage        ErrorMessage = "username already exists"
	emailAlreadyExistsMessage           ErrorMessage = "email already exists"
	invalidPlatformTypeErrorMessage     ErrorMessage = "invalid platform type, it should be 1 or 2 of Platform Type"

	// auction from another company

	emailAlreadyExistErrorMessage        ErrorMessage = "one account already exist with this email, please try with another one"
	DuplicateAuctionTitleErrorMessage    ErrorMessage = "One auction already exist with the same auction title, Please create a diffrent title"
	duplicatePlanTitleErrorMessage       ErrorMessage = "A Plan with this plan title is already exist"
	duplicateDocumentTypeErrorMessage    ErrorMessage = "A Document with this document type is already exist"
	AuctionTypeRequiredErrorMessage      ErrorMessage = "Invalid request, please pass a valid auctionType"
	AuctionIdRequiredForListErrorMessage ErrorMessage = "Invalid request, please pass a valid auctionId"
	InvalidAuctionTypeErrorMessage       ErrorMessage = "Invalid auctionType value, it should be ID of Auction Type"
	ActivityTypeRequiredErrorMessage     ErrorMessage = "Invalid request, please pass a valid activityType"
	ActivityTypeNotFountErrorMessage     ErrorMessage = "Invalid activity type, no activity found for provided activity type"
	AuctionCanNotUpdateErrorMessage      ErrorMessage = "Auction can update only when it is in draft state"
	MediaNotFoundErorrMessage            ErrorMessage = "This media url is not exist in Media"
	PlanDocumentNotFoundErrorMessage     ErrorMessage = "This plan url is not exist in Plan"
	DocumentNotFoundErrorMessage         ErrorMessage = "This document is not exist in Document"
)

var (
	errorCodeErrorMessageMapping = map[ErrorCode]ErrorMessage{
		SomethingWentWrongErrorCode: somethingWentWrong,
		BadRequestErrorCode:         badRequestMessage,
		UserNotAuthorizedErrorCode:  userNotAuthorizedMessage,
		InvalidCredentialsErrorCode: invalidCredentialsMessage,
		PermissionDeniedErrorCode:   permissionDeniedErrormessage,
		NoDataFoundErrorCode:        noDataFoundErrormessage,
		// EmailAlreadyExistErrorCode:          emailAlreadyExistErrorMessage,
		CannotGiveEmailAndUsernameErrorCode: cannotGiveEmailAndUsernameErrorCode,
		CompanyNotVerifiedErrorCode:         companyNotVerifiedErrorCode,
		AlreadyExistCode:                    alreadyExistCode,
		UniqueConstraintViolationErrorCode:  uniqueConstraintViolationMessage,
		UsernameAlreadyExistsErrorCode:      usernameAlreadyExistsMessage,
		EmailAlreadyExistsErrorCode:         emailAlreadyExistsMessage,
		// auction
		DuplicatePlanTitleErrorCode:    duplicatePlanTitleErrorMessage,
		DuplicateDocumentTypeErrorCode: duplicateDocumentTypeErrorMessage,
		InvalidAuctionTypeErrorCode:    InvalidAuctionTypeErrorMessage,
		ActivityTypeNotFountErrorCode:  ActivityTypeNotFountErrorMessage,
		AuctionCanNotUpdateErrorCode:   AuctionCanNotUpdateErrorMessage,
		DuplicateAuctionTitleErrorCode: DuplicateAuctionTitleErrorMessage,
		MediaNotFoundErorrCode:         MediaNotFoundErorrMessage,
		PlanDocumentNotFoundErrorCode:  PlanDocumentNotFoundErrorMessage,
		DocumentNotFoundErrorCode:      DocumentNotFoundErrorMessage,
		InvalidPlatformTypeErrorCode:   invalidPlatformTypeErrorMessage,
	}
)

var (
	errorCodeHttpCodeMapping = map[ErrorCode]int{
		SomethingWentWrongErrorCode: http.StatusInternalServerError,
		BadRequestErrorCode:         http.StatusBadRequest,
		UserNotAuthorizedErrorCode:  http.StatusUnauthorized,
		InvalidCredentialsErrorCode: http.StatusUnauthorized,
		PermissionDeniedErrorCode:   http.StatusUnauthorized,
		NoDataFoundErrorCode:        http.StatusNotFound,
		// EmailAlreadyExistErrorCode:          http.StatusAlreadyReported,
		CannotGiveEmailAndUsernameErrorCode: http.StatusBadRequest,
		CompanyNotVerifiedErrorCode:         http.StatusAccepted,
		AlreadyExistCode:                    http.StatusConflict,
		UniqueConstraintViolationErrorCode:  http.StatusConflict,
		UsernameAlreadyExistsErrorCode:      http.StatusConflict,
		EmailAlreadyExistsErrorCode:         http.StatusConflict,
		// auction
		DuplicatePlanTitleErrorCode:    http.StatusBadRequest,
		DuplicateDocumentTypeErrorCode: http.StatusBadRequest,
		InvalidAuctionTypeErrorCode:    http.StatusBadRequest,
		ActivityTypeNotFountErrorCode:  http.StatusNotFound,
		AuctionCanNotUpdateErrorCode:   http.StatusBadRequest,
		DuplicateAuctionTitleErrorCode: http.StatusBadRequest,
		MediaNotFoundErorrCode:         http.StatusNotFound,
		PlanDocumentNotFoundErrorCode:  http.StatusNotFound,
		DocumentNotFoundErrorCode:      http.StatusNotFound,
		InvalidPlatformTypeErrorCode:   http.StatusBadRequest,
	}

	ConstraintErrorMap = map[string]ErrorCode{
		"uc_users_username": UsernameAlreadyExistsErrorCode,
		"uc_users_email":    EmailAlreadyExistsErrorCode,

		// Add more mappings as needed
	}
)

func (c ErrorCode) String() string {
	return string(c)
}

func (c ErrorCode) GetErrorMessage() ErrorMessage {
	if errMsg, ok := errorCodeErrorMessageMapping[c]; ok {
		return errMsg
	}

	return somethingWentWrong
}

func (m ErrorMessage) String() string {
	return string(m)
}
