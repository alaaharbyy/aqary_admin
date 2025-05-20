package enums

import "fmt"

// ActivityType represents the type for activityType
// This value will be used to categorize different activities
type ActivityType int64

// Enum values for ActivityType
const (
	TransactionsActivity ActivityType = iota + 1
	FileViewActivity
	PortalViewActivity
)

// activityTypeStrings maps ActivityType values to their string representations
var activityTypeStrings = map[ActivityType]string{
	TransactionsActivity: "Transactions",
	FileViewActivity:     "File View",
	PortalViewActivity:   "Portal View",
}

// activityTypeValues maps string representations to their ActivityType values
var activityTypeValues = map[string]ActivityType{
	"Transactions": TransactionsActivity,
	"File View":    FileViewActivity,
	"Portal View":  PortalViewActivity,
}

// String returns the string representation of the ActivityType
func (at ActivityType) String() string {
	return activityTypeStrings[at]
}

// ParseActivityType converts a string to an ActivityType value
func ParseActivityType(s string) (ActivityType, error) {
	at, ok := activityTypeValues[s]
	if !ok {
		return 0, fmt.Errorf("invalid activity type: %s", s)
	}
	return at, nil
}

//----------------------------------------------------------------------------------------------------------------

// FileCategory represents the type for file categories
// This value will be used to categorize different file types
type FileCategory int64

// Enum values for FileCategory
const (
	MediaFileCategory FileCategory = iota + 1
	PlansFileCategory
	DocumentsFileCategory
)

// fileCategoryStrings maps FileCategory values to their string representations
var fileCategoryStrings = map[FileCategory]string{
	MediaFileCategory:     "Media",
	PlansFileCategory:     "Plans",
	DocumentsFileCategory: "Documents",
}

// fileCategoryValues maps string representations to their FileCategory values
var fileCategoryValues = map[string]FileCategory{
	"Media":     MediaFileCategory,
	"Plans":     PlansFileCategory,
	"Documents": DocumentsFileCategory,
}

// String returns the string representation of the FileCategory
func (fc FileCategory) String() string {
	return fileCategoryStrings[fc]
}

// ParseFileCategory converts a string to a FileCategory value
func ParseFileCategory(s string) (FileCategory, error) {
	fc, ok := fileCategoryValues[s]
	if !ok {
		return 0, fmt.Errorf("invalid file category: %s", s)
	}
	return fc, nil
}
