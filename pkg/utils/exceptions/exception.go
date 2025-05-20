package exceptions

import (
	"net/http"
)

type Exception struct {
	ErrorCode    ErrorCode
	ErrorMessage ErrorMessage
	HttpCode     int
}

func GetExceptionByErrorCode(code ErrorCode) *Exception {
	e := &Exception{
		ErrorCode:    code,
		ErrorMessage: "",
		HttpCode:     http.StatusInternalServerError,
	}

	if msg, ok := errorCodeErrorMessageMapping[code]; ok {
		e.ErrorMessage = msg
	}

	if httpCode, ok := errorCodeHttpCodeMapping[code]; ok {
		e.HttpCode = httpCode
	}

	return e
}

func GetExceptionByErrorCodeWithCustomMessage(code ErrorCode, message string) *Exception {
	e := GetExceptionByErrorCode(code)
	e.ErrorMessage = ErrorMessage(message)
	return e
}

// func GetExceptionByCodeWithCustomMessage(code int, message string) *Exception {
// 	// e := GetExceptionByErrorCode(code)
// 	// e.ErrorMessage = ErrorMessage(message)
// 	return &Exception{
// 		ErrorCode:   c.ErrorCode(),
// 		ErrorMessage: message,
// 		HttpCode:     1,
// 	}
// }

func (e *Exception) Error() string {
	if e != nil {
		return string(e.ErrorMessage)
	}
	return ""
}

func (e *Exception) GetErrorCode() string {
	return e.ErrorCode.String()
}

func Is(e *Exception, c ErrorCode) bool {
	return e.ErrorCode == c
}
