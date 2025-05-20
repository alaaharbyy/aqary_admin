package out

type CustomAllSecondaryPermission struct {
	ID                 int64                        `json:"id"`
	Label              string                       `json:"label"`
	SubLabel           string                       `json:"sub_label"`
	TertairyPermission []CustomAllTernaryPermission `json:"Ternary_permission"`
}

type CustomAllTernaryPermission struct {
	ID       int64  `json:"id"`
	Label    string `json:"label"`
	SubLabel string `json:"sub_label"`
}

type CustomSectionPermission struct {
	ID               int64                 `json:"id"`
	Label            string                `json:"label"`
	SubLabel         string                `json:"sub_label"`
	CustomPermission []CustomAllPermission `json:"permissions"`
}

type CustomAllPermission struct {
	ID                           int64                           `json:"id"`
	Label                        string                          `json:"label"`
	SubLabel                     string                          `json:"sub_label"`
	CustomAllSecondaryPermission []CustomAllSubSectionPermission `json:"secondary_permissions"`
}

type CustomAllSubSectionPermission struct {
	ID                     int64  `json:"id"`
	Label                  string `json:"label"`
	SubLabel               string `json:"sub_label"`
	Indicator              int64  `form:"indicator"`
	SubSectionButtonID     int64  `form:"sub_section_button_id"`
	SubSectionButtonAction string `form:"sub_section_button_action"`
}
