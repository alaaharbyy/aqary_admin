package response

type CreateSectionPermissionRequest struct {
	Title    string `form:"title" binding:"required"`
	SubTitle string `form:"sub_title"`
}

type GetAllSectionPermissionRequest struct {
	PageNo   int32  `form:"page_no"`
	PageSize int32  `form:"page_size"`
	Search   string `form:"search"`
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
	PageNo   int32  `form:"page_no" binding:"required"`
	PageSize int32  `form:"page_size" binding:"required"`
	Search   string `form:"search"`
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

type PermissionOutput struct {
	ID       int64  `json:"id"`        // ID is used to store the unique identifier of a permission.
	Title    string `json:"label"`     // Title is used to store the title of a permission.
	SubTitle string `json:"sub_label"` // SubTitle is used to store the subtitle of a permission.
}

type SectionPermission struct {
	ID       int64  `json:"id"`
	Title    string `json:"title"`
	SubTitle string `json:"sub_title"`
}

type SubSectionPermissionOutput struct {
	ID                     int64  `json:"id"`
	Title                  string `json:"label"`
	SubTitle               string `json:"sub_label"`
	Indicator              int64  `json:"indicator"`
	SubSectionButtonID     int64  `json:"sub_section_button_id"`
	SubSectionButtonAction string `json:"sub_section_button_action"`
	IsItEnd                bool   `json:"is_it_end"`
}

// Response models
type Role struct {
	ID   int64  `json:"id"`
	Role string `json:"role"`
}

type AllRolesOutput struct {
	ID          int64  `json:"id"`
	Name        string `json:"label"`
	IsRoleExist bool   `json:"is_role_exist"`
}

// containAllSectionId checks if a slice of CustomSectionPermission contains a target ID.
func ContainAllSectionId(list []CustomSectionPermission, target int64) bool {
	for _, item := range list {
		if item.ID == target {
			return true
		}
	}
	return false
}

// containPermissionId checks if a slice of CustomAllPermission contains a target ID.
func containPermissionId(list []CustomAllPermission, target int64) bool {
	for _, item := range list {
		if item.ID == target {
			return true
		}
	}
	return false
}

// containQuaternaryId checks if a slice of CustomAllQuaternarySubSectionPermission contains a target ID.
func ContainQuaternaryId(list []CustomAllQuaternarySubSectionPermission, target int64) bool {
	for _, item := range list {
		if item.ID == target {
			return true
		}
	}
	return false
}
