package auth_usecase

import (
	"aqary_admin/pkg/utils"
	"errors"
	"fmt"
	"regexp"
	"time"
	"unicode"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

func ValidateEmail(email string) error {
	// Define a regular expression for validating an email
	const emailRegex = `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`

	re := regexp.MustCompile(emailRegex)
	if !re.MatchString(email) {
		return errors.New("invalid email address")
	}
	return nil
}

func VerifyPasswordCriteria(password string) error {

	if len(password) < 8 {
		return errors.New("password must be at least 8 characters long")
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
		return errors.New("password must contain at least one uppercase letter")
	}
	if !hasLower {
		return errors.New("password must contain at least one lowercase letter")
	}
	if !hasNumber {
		return errors.New("password must contain at least one number")
	}
	if !hasSpecial {
		return errors.New("password must contain at least one special character")
	}

	return nil
}

func generateOTP(c *gin.Context) int {
	return utils.RandomInteger(6)
}

func generateSecretKey(c *gin.Context) string {
	var secretKey string
	uuID, err := uuid.NewV7()

	if err != nil {
		secretKey = utils.RandomString(32)
	} else {
		secretKey = uuID.String()
	}

	return secretKey
}

func ValidateOTP(c *gin.Context, otpData OTPData) bool {

	return true
}

// Retry function with exponential backoff
func retry(attempts int, sleep time.Duration, fn func() error) error {
	for i := 0; i < attempts; i++ {
		if err := fn(); err != nil {
			if i == attempts-1 {
				return fmt.Errorf("failed after %d attempts: %w", attempts, err)
			}
			fmt.Printf("Attempt %d failed, retrying in %v..., Error: %s\n", i+1, sleep, err)
			time.Sleep(sleep)
			sleep *= 2 // Exponential backoff
		} else {
			return nil
		}
	}
	return errors.New("max retries reached")
}

func safeString(v interface{}) string {
	s, ok := v.(string)
	if ok {
		return s
	}
	return ""
}

func safeBool(v interface{}) bool {
	s, ok := v.(bool)
	if ok {
		return s
	}
	return false
}
