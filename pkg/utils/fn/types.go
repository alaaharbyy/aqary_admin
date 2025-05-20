package fn

type QualityScoreReq struct {
	ID          int64
	IsProperty  bool   // @ is property or unit
	Key         int64  // @ 1=>project properties,  2 => freelancer property , 3 => broker agent property ,4 => owner property
	IsBranch    bool   // @ is_branch is for both property & for unit also
	Category    string // @ sale,rent or exchange
	Title       string
	Description string
	AddressesID int64
}

type QualityBoardResponse struct {
	TitleQuality       int `json:"title_quality"`
	DescriptionQuality int `json:"description_quality"`
	AddressQuality     int `json:"address_quality"`
	MediaQuality       int `json:"media_quality"`
}
type Address struct {
	CountryID     int64
	StateID       int64
	CityID        int64
	CommunityID   int64
	SubCommunitID int64
	Lat           string
	Lng           string
}

// fixing some stuff
type CreateSectionPermissionRequest struct {
	Title    string `form:"title" binding:"required"`
	SubTitle string `form:"sub_title"`
}

type GetAllSectionPermissionRequest struct {
	PageNo   int32 `form:"page_no"`
	PageSize int32 `form:"page_size"`
}

type UpdateSectionPermissionRequest struct {
	Title    string `form:"title"`
	SubTitle string `form:"sub_title"`
}

type CreatePermissionRequest struct {
	Title               string `form:"title" binding:"required"`
	SubTitle            string `form:"sub_title"`
	SectionPermistionId int64  `form:"section_permission_id" binding:"required"`
}

type CustomAllSectionPermission struct {
	ID               int64                 `json:"id"`
	Label            string                `json:"label"`
	SubLabel         string                `json:"sub_label"`
	Indicator        int64                 `json:"indicator"`
	CustomPermission []CustomAllPermission `json:"permissions"`
}

type CustomAllPermission struct {
	ID                           int64                           `json:"id"`
	Label                        string                          `json:"label"`
	SubLabel                     string                          `json:"sub_label"`
	Indicator                    int64                           `json:"indicator"`
	CustomAllSecondaryPermission []CustomAllSubSectionPermission `json:"secondary_permission"`
}

type CustomAllSubSectionPermission struct {
	ID                     int64  `json:"id"`
	Label                  string `json:"label"`
	SubLabel               string `json:"sub_label"`
	Indicator              int64  `json:"indicator"`
	SubSectionButtonID     int64  `json:"sub_section_button_id"`
	SubSectionButtonAction string `json:"sub_section_button_action"`
}

type CustomAllSubSectionSecondaryPermission struct {
	ID                            int64                           `json:"id"`
	Label                         string                          `json:"label"`
	SubLabel                      string                          `json:"sub_label"`
	Indicator                     int64                           `json:"indicator"`
	SubSectionButtonID            int64                           `json:"sub_section_button_id"`
	SubSectionButtonAction        string                          `json:"sub_section_button_action"`
	CustomAllSubSectionPermission []CustomAllSubSectionPermission `json:"tertiary_permission"`
}

// CustomAllSecondarySubSectionPermission

type CustomAllPermission2 struct {
	ID                           int64                           `json:"id"`
	Label                        string                          `json:"label"`
	SubLabel                     string                          `json:"sub_label"`
	CustomAllSecondaryPermission []CustomAllSubSectionPermission `json:"secondary_permission"`
}

type GetAllPermissionRequest struct {
	PageNo   int32 `form:"page_no" binding:"required"`
	PageSize int32 `form:"page_size" binding:"required"`
}

type UpdatePermissionRequest struct {
	Title               string `form:"title"`
	SubTitle            string `form:"sub_title"`
	SectionPermissionId int64  `form:"section_permission_id"`
}

type CreateRolePermissionRequest struct {
	RolesId      int64   `form:"roles_id" binding:"required"`
	PermissionId []int64 `form:"permissions_id[]"`
	SubSectionId []int64 `form:"subsection_id[]"`
}

type CustomRolePermission struct {
	ID                int64                     `json:"id"`
	Label             string                    `json:"label"`
	SectionPermission []CustomSectionPermission `json:"section_permissions"`
}

type CustomSectionPermissions struct {
	ID               int64               `json:"id"`
	Label            string              `json:"label"`
	SubLabel         string              `json:"sub_label"`
	CustomPermission []CustomPermissions `json:"permissions"`
}

type CustomPermissions struct {
	ID       int64  `json:"id"`
	Label    string `json:"label"`
	SubLabel string `json:"sub_label"`
}

type GetAllRolePermissionRequest struct {
	PageNo   int32 `form:"page_no" binding:"required"`
	PageSize int32 `form:"page_size" binding:"required"`
}

type UpdateRolePermissionRequest struct {
	RolesId      int64   `form:"roles_id"`
	PermissionId []int64 `form:"permissions_id[]"`
	SubSectionId []int64 `form:"subsection_id[]"`
}

type DeleteOneRolePermissionRequest struct {
	PermissionId int64 `form:"permissions_id" binding:"required"`
}

// ! sub section permission

type CreateSubSectionPermissionRequest struct {
	SubSectionName         string `form:"title" binding:"required"`
	SubSectionNameConstant string `form:"sub_title"`
	PermissionsID          int64  `form:"permissions_id" binding:"required"`
	Indicator              int64  `form:"indicator"`
	SubSectionButtonID     int64  `form:"sub_section_button_id"`
	SubSectionButtonAction string `form:"sub_section_button_action"`
}

type UpdateSubSectionPermissionRequest struct {
	SubSectionName         string `form:"title"`
	SubSectionNameConstant string `form:"sub_title"`
	PermissionsID          int64  `form:"permissions_id"`
	Indicator              *int64 `form:"indicator"`
	SubSectionButtonID     int64  `form:"sub_section_button_id"`
	SubSectionButtonAction string `form:"sub_section_button_action"`
}

/// make it inline everything...

type CustomSectionPermission struct {
	ID               int64                  `json:"id"`
	Label            string                 `json:"label"`
	SubLabel         string                 `json:"sub_label"`
	Indicator        int64                  `json:"indicator"`
	CustomPermission []CustomAlllPermission `json:"permissions"`
}

type CustomAlllPermission struct {
	ID                           int64                                 `json:"id"`
	Label                        string                                `json:"label"`
	SubLabel                     string                                `json:"sub_label"`
	Indicator                    int64                                 `json:"indicator"`
	CustomAllSecondaryPermission []CustomSubSectionSecondaryPermission `json:"secondary_permission"`
}

type CustomSubSectionSecondaryPermission struct {
	ID                            int64                                    `json:"id"`
	Label                         string                                   `json:"label"`
	SubLabel                      string                                   `json:"sub_label"`
	Indicator                     int64                                    `json:"indicator"`
	PermissionID                  int64                                    `json:"permission_id"`
	PrimaryID                     int64                                    `json:"primary_id"`
	SubSectionButtonID            int64                                    `json:"sub_section_button_id"`
	SubSectionButtonAction        string                                   `json:"sub_section_button_action"`
	CustomAllSubSectionPermission []CustomAllSecondarySubSectionPermission `json:"tertiary_permission"`
}

// for Ternary permission
type CustomAllSecondarySubSectionPermission struct {
	ID                     int64                                     `json:"id"`
	Label                  string                                    `json:"label"`
	SubLabel               string                                    `json:"sub_label"`
	Indicator              int64                                     `json:"indicator"`
	PermissionID           int64                                     `json:"permission_id"`
	PrimaryID              int64                                     `json:"primary_id"`
	SecondaryID            int64                                     `json:"secondary_id"`
	SubSectionButtonID     int64                                     `json:"sub_section_button_id"`
	SubSectionButtonAction string                                    `json:"sub_section_button_action"`
	QuaternaryPermission   []CustomAllQuaternarySubSectionPermission `json:"quaternary_permission"`
}

type CustomAllQuaternarySubSectionPermission struct {
	ID                     int64                                  `json:"id"`
	Label                  string                                 `json:"label"`
	SubLabel               string                                 `json:"sub_label"`
	Indicator              int64                                  `json:"indicator"`
	PermissionID           int64                                  `json:"permission_id"`
	PrimaryID              int64                                  `json:"primary_id"`
	SecondaryID            int64                                  `json:"secondary_id"`
	TernaryID              int64                                  `json:"tertiary_id"`
	SubSectionButtonID     int64                                  `json:"sub_section_button_id"`
	SubSectionButtonAction string                                 `json:"sub_section_button_action"`
	QuinaryPermission      []CustomAllQuinarySubSectionPermission `json:"quinary_permission"`
}

type CustomAllQuinarySubSectionPermission struct {
	ID                     int64  `json:"id"`
	Label                  string `json:"label"`
	SubLabel               string `json:"sub_label"`
	Indicator              int64  `json:"indicator"`
	PermissionID           int64  `json:"permission_id"`
	PrimaryID              int64  `json:"primary_id"`
	SecondaryID            int64  `json:"secondary_id"`
	TernaryID              int64  `json:"tertiary_id"`
	QuaternaryID           int64  `json:"quaternary_id"`
	SubSectionButtonID     int64  `json:"sub_section_button_id"`
	SubSectionButtonAction string `json:"sub_section_button_action"`
}

func ContainSectionId(list []CustomSectionPermissions, target int64) bool {
	for _, item := range list {
		if item.ID == target {
			return true
		}
	}
	return false
}
