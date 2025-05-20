package enums

import "fmt"

// PlanTitle represents the type for plan titles
// This value will store in auction_plan.title column
type PlanTitle int64

// Enum values for PlanTitle
const (
	MasterPlan PlanTitle = iota + 1
	SitePlan
	MunicipalityPlan
)

// planTitleStrings maps PlanTitle values to their string representations
var planTitleStrings = map[PlanTitle]string{
	MasterPlan:       "Master Plan",
	SitePlan:         "Site Plan",
	MunicipalityPlan: "Municipality Plan",
}

// planTitleValues maps string representations to their PlanTitle values
var planTitleValues = map[string]PlanTitle{
	"Master Plan":       MasterPlan,
	"Site Plan":         SitePlan,
	"Municipality Plan": MunicipalityPlan,
}

// String returns the string representation of the PlanTitle
func (p PlanTitle) String() string {
	return planTitleStrings[p]
}

// ParsePlanTitle converts a string to a PlanTitle value
func ParsePlanTitle(s string) (PlanTitle, error) {
	p, ok := planTitleValues[s]
	if !ok {
		return 0, fmt.Errorf("invalid plan title: %s", s)
	}
	return p, nil
}
