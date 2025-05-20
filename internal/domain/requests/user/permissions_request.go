package domain

type CreateRolePermissionRequest struct {
	RolesId      int64   `form:"roles_id" binding:"required"`
	PermissionId []int64 `form:"permissions_id[]" binding:"required"`
	SubSectionId []int64 `form:"sub_section_id[]"`
}

type GetAllRolePermissionRequest struct {
	PageNo   int64  `form:"page_no" binding:"required,min=1"`
	PageSize int64  `form:"page_size" binding:"required,min=1,max=100"`
	Search   string `form:"search"`
}

type UpdateRolePermissionRequest struct {
	PermissionId []int64 `form:"permissions_id[]" binding:"required"`
	SubSectionId []int64 `form:"sub_section_id[]"`
}

type DeleteOneRolePermissionRequest struct {
	PermissionId int64 `form:"permissions_id" binding:"required"`
}

type CreateSectionPermissionRequest struct {
	Title    string `form:"title" binding:"required"`
	SubTitle string `form:"sub_title"`
}

// GetAllSectionPermissionRequest represents the request structure for fetching section permissions with pagination
type GetAllSectionPermissionRequest struct {
	PageNo   int64  `form:"page_no" binding:"required,min=1"`
	PageSize int64  `form:"page_size" binding:"required,min=1,max=100"`
	Search   string `form:"search"`
}

// UpdateSectionPermissionRequest represents the request structure for updating a section permission
type UpdateSectionPermissionRequest struct {
	Title    string `form:"title"`
	SubTitle string `form:"sub_title"`
}

type CreateSubSectionPermissionRequest struct {
	SubSectionName         string `form:"title" binding:"required"`
	SubSectionNameConstant string `form:"sub_title" binding:"required"`
	PermissionsID          int64  `form:"permissions_id" binding:"required"`
	Indicator              int64  `form:"indicator"`
	SubSectionButtonID     int64  `form:"sub_section_button_id"`
	SubSectionButtonAction string `form:"sub_section_button_action"`
}

type GetAllPermissionRequest struct {
	PageNo    int64  `form:"page_no" binding:"required,min=1"`
	PageSize  int64  `form:"page_size" binding:"required,min=1,max=100"`
	Search    string `form:"search"`
	CompanyID int64  `form:"company_id"`
}

type GetAllPermissionWithoutPaginationRequest struct {
	Search      string `form:"search"`
	CompanyID   int64  `form:"company_id"`
	CompanyMain bool   `form:"company_main"`
}

type UpdateSubSectionPermissionRequest struct {
	SubSectionName         string `form:"title"`
	SubSectionNameConstant string `form:"sub_title"`
	PermissionsID          int64  `form:"permissions_id"`
	Indicator              *int64 `form:"indicator"`
	SubSectionButtonID     int64  `form:"sub_section_button_id"`
	SubSectionButtonAction string `form:"sub_section_button_action"`
}

type CreateRoleRequest struct {
	Role         string `form:"role" binding:"required"`
	DepartmentID int64  `form:"department_id" binding:"required"`
	Permissions  string `form:"permissions"`
}

type RoleOutput struct {
	Role             string  `json:"role"`
	DepartmentID     int64   `json:"department_id"`
	Permissions      []int64 `json:"permissions"`
	ButtonPermission []int64 `json:"button_permissions"`
}

type PermissionButton struct {
	ID           int `json:"id"`
	ButtonID     int `json:"button_id"`
	PermissionID int `json:"permission_id"`
	SecondaryID  int `json:"secondary_id"`
	TertiaryID   int `json:"tertiary_id"`
	QuaternaryID int `json:"quaternary_id"`
}

type DeleteRoleRequest struct {
	RoleID       int64 `form:"role_id" binding:"required"`
	DepartmentID int64 `form:"department_id"`
}

type GetAllRolesRequest struct {
	PageSize     int32  `form:"page_size" binding:"required,min=1,max=100"`
	PageNo       int32  `form:"page_no" binding:"required,min=1"`
	DepartmentID int64  `form:"department_id" binding:"required"`
	Search       string `form:"search"`
}

type UpdateRoleRequest struct {
	Role         string `form:"role"`
	DepartmentID int64  `form:"department_id" binding:"required"`
	Permissions  string `form:"permissions"`
}
