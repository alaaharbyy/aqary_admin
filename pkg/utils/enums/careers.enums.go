package enums

import "fmt"

// CareerLevel represents the type for CareerLevel
// This value will be used to categorize different career level
type CareerLevel int64

// Enum values for CareerLevel
const (
	Managerial CareerLevel = iota + 1
	Internship
	FreshGraduate
	EntryLevel
	IntermediateExperience
	MidLevel
	JuniorExecutive
	SeniorLevel
	Any
)

var careerLevelStrings = map[CareerLevel]string{
	Managerial:             "Managerial",
	Internship:             "Internship",
	FreshGraduate:          "Fresh Graduate",
	EntryLevel:             "Entry Level",
	IntermediateExperience: "Intermediate-Experience",
	MidLevel:               "Mid-Level",
	JuniorExecutive:        "Junior Executive",
	SeniorLevel:            "Senior Level",
	Any:                    "Any",
}

var careerLevelValues = map[string]CareerLevel{
	"Managerial":              Managerial,
	"Internship":              Internship,
	"Fresh Graduate":          FreshGraduate,
	"Entry Level":             EntryLevel,
	"Intermediate-Experience": IntermediateExperience,
	"Mid-Level":               MidLevel,
	"Junior Executive":        JuniorExecutive,
	"Senior Level":            SeniorLevel,
	"Any":                     Any,
}

func (at CareerLevel) String() string {
	return careerLevelStrings[at]
}

func ParseCareerLevel(s string) (CareerLevel, error) {
	at, ok := careerLevelValues[s]
	if !ok {
		return 0, fmt.Errorf("invalid career level: %s", s)
	}
	return at, nil
}
