package validater

import (
	"regexp"

	"github.com/asaskevich/govalidator"
)

func init() {
	// Register phone validator
	govalidator.CustomTypeTagMap.Set("phone", govalidator.CustomTypeValidator(func(i interface{}, context interface{}) bool {
		switch v := i.(type) {
		case string:
			// Check if the string consists of only digits and has the desired length
			if len(v) >= 10 && len(v) <= 15 {
				for _, char := range v {
					if char < '0' || char > '9' {
						return false
					}
				}
				return true
			}
			return false
		default:
			return false
		}
	}))

	// Register positive integer and float validator
	govalidator.CustomTypeTagMap.Set("positive", govalidator.CustomTypeValidator(func(i interface{}, context interface{}) bool {
		switch v := i.(type) {
		case int:
			return v > 0
		case int32:
			return v > 0
		case int64:
			return v > 0
		case uint:
			return v > 0
		case uint32:
			return v > 0
		case uint64:
			return v > 0
		case float32:
			return v > 0
		case float64:
			return v > 0
		default:
			return false
		}
	}))

	// Define the regex pattern for alphanumeric and special characters
	const validStringPattern = `^[a-zA-Z0-9 $&_.\/,]+$`

	// Register a custom validator for strings that only allows alphanumeric and specified special characters
	govalidator.CustomTypeTagMap.Set("alphaNumSpecial", govalidator.CustomTypeValidator(func(i interface{}, context interface{}) bool {
		str, ok := i.(string)
		if !ok {
			return false
		}
		matched, err := regexp.MatchString(validStringPattern, str)
		if err != nil {
			return false
		}
		return matched
	}))

	// Register a custom validator to check if a slice is not empty and contains only positive integers
	govalidator.CustomTypeTagMap.Set("positiveNonEmptySlice", govalidator.CustomTypeValidator(func(i interface{}, context interface{}) bool {
		switch v := i.(type) {
		case []int64:
			if len(v) == 0 {
				return false
			}
			for _, n := range v {
				if n <= 0 {
					return false
				}
			}
			return true
		default:
			return false
		}
	}))
}
