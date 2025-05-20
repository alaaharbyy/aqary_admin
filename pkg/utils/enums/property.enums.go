package enums

import "fmt"

// PropertyCategory represents the type for property category
// This Value of PropertyCategory will store in properties.category column
type PropertyCategory int64

const (
	PropertyCategorySele PropertyCategory = iota + 1
	PropertyCategoryRent
	PropertyCategorySwap
	PropertyCategoryAuction
)

var propertyCategoryString = map[PropertyCategory]string{
	PropertyCategorySele:    "Sele",
	PropertyCategoryRent:    "Rent",
	PropertyCategorySwap:    "Swap",
	PropertyCategoryAuction: "Auction",
}

var propertyCategoryValues = map[string]PropertyCategory{
	"Sele":    PropertyCategorySele,
	"Rent":    PropertyCategoryRent,
	"Swap":    PropertyCategorySwap,
	"Auction": PropertyCategoryAuction,
}

func (pc PropertyCategory) String() string {
	return propertyCategoryString[pc]
}

func ParsePropertyCategory(s string) (PropertyCategory, error) {
	apt, ok := propertyCategoryValues[s]
	if !ok {
		return 0, fmt.Errorf("invalid property category: %s", s)
	}
	return apt, nil
}


// LifeStyle represents the type for life style
// This Value of LifeStyle will store in properties_facts.life_style column
type LifeStyle int64

const (
	StandardLifeStyle LifeStyle = iota + 1
	LuxuryLifeStyle
)

var lifeStyleString = map[LifeStyle]string{
	StandardLifeStyle:    "standard",
	LuxuryLifeStyle:    "luxury",
}

var lifeStyleValues = map[string]LifeStyle{
	"standard":    StandardLifeStyle,
	"luxury":    LuxuryLifeStyle,
}

func (ls LifeStyle) String() string {
	return lifeStyleString[ls]
}

func ParseLifeStyle(s string) (LifeStyle, error) {
	ls, ok := lifeStyleValues[s]
	if !ok {
		return 0, fmt.Errorf("invalid life style value: %s", s)
	}
	return ls, nil
}

