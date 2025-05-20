package permissions_usecase

import (
	"sync"
	"time"

	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

func (uc *permissionUseCase) CreateRolePermission(ctx *gin.Context, req domain.CreateRolePermissionRequest) (*sqlc.RolesPermission, *exceptions.Exception) {
	oldRolePermission, err := uc.repo.GetRolePermissionByRole(ctx, req.RolesId)
	if err == nil && oldRolePermission.ID != 0 {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "Role permission already exists")
	}

	role, err := uc.repo.GetRole(ctx, req.RolesId)
	if err != nil {
		return nil, err
	}

	if len(req.SubSectionId) == 0 {
		req.SubSectionId = uc.getAllSubSections(ctx, req.PermissionId)
	}

	uniquePermissionList := utils.MakeUnique(req.PermissionId)
	uniqueSubSectionList := utils.MakeUnique(req.SubSectionId)

	rolePermission, err := uc.repo.CreateRolePermission(ctx, sqlc.CreateRolePermissionParams{
		RolesID:              role.ID,
		PermissionsID:        uniquePermissionList,
		SubSectionPermission: uniqueSubSectionList,
		CreatedAt:            time.Now(),
		UpdatedAt:            time.Now(),
	})
	if err != nil {
		return nil, err
	}

	return &sqlc.RolesPermission{
		ID:                   rolePermission.ID,
		RolesID:              rolePermission.RolesID,
		PermissionsID:        rolePermission.PermissionsID,
		SubSectionPermission: rolePermission.SubSectionPermission,
	}, nil
}

func (uc *permissionUseCase) GetAllRolePermission(ctx *gin.Context, req domain.GetAllRolePermissionRequest) ([]response.CustomRolePermission, int64, *exceptions.Exception) {
	rolePermissions, err := uc.repo.GetAllRolePermission(ctx, sqlc.GetAllRolePermissionParams{
		Limit:  int32(req.PageSize),
		Offset: int32((req.PageNo - 1) * req.PageSize),
		Search: utils.AddPercent(req.Search),
	})
	if err != nil {
		return nil, 0, err
	}

	var customRolePermissions []response.CustomRolePermission
	var wg sync.WaitGroup
	resultChan := make(chan response.CustomRolePermission, len(rolePermissions))

	for _, rp := range rolePermissions {
		wg.Add(1)
		go func(rolePermission sqlc.GetAllRolePermissionRow) {
			defer wg.Done()
			role, err := uc.repo.GetRole(ctx, rolePermission.RolesID)
			if err != nil {
				return
			}
			resultChan <- response.CustomRolePermission{
				ID:                rolePermission.ID,
				Label:             role.Role,
				SectionPermission: []response.CustomSectionPermission{},
			}
		}(rp)
	}

	go func() {
		wg.Wait()
		close(resultChan)
	}()

	for result := range resultChan {
		customRolePermissions = append(customRolePermissions, result)
	}

	count, err := uc.repo.GetCountAllRolePermission(ctx, utils.AddPercent(req.Search))
	if err != nil {
		return nil, 0, err
	}

	return customRolePermissions, count, nil
}

func (uc *permissionUseCase) GetAllRolePermissionWithoutPagination(ctx *gin.Context) ([]response.CustomRolePermission, *exceptions.Exception) {
	rolePermissions, err := uc.repo.GetAllRolePermissionWithoutPagination(ctx)
	if err != nil {
		return nil, err
	}

	var customRolePermissions []response.CustomRolePermission
	var wg sync.WaitGroup
	resultChan := make(chan response.CustomRolePermission, len(rolePermissions))

	for _, rp := range rolePermissions {
		wg.Add(1)
		go func(rolePermission sqlc.RolesPermission) {
			defer wg.Done()
			role, err := uc.repo.GetRole(ctx, rolePermission.RolesID)
			if err != nil {
				return
			}
			resultChan <- response.CustomRolePermission{
				ID:                rolePermission.ID,
				Label:             role.Role,
				SectionPermission: []response.CustomSectionPermission{},
			}
		}(rp)
	}

	go func() {
		wg.Wait()
		close(resultChan)
	}()

	for result := range resultChan {
		customRolePermissions = append(customRolePermissions, result)
	}

	return customRolePermissions, nil
}

func (uc *permissionUseCase) UpdateRolePermission(ctx *gin.Context, id int64, req domain.UpdateRolePermissionRequest) (*sqlc.RolesPermission, *exceptions.Exception) {
	oldRolePermission, err := uc.repo.GetRolePermission(ctx, id)
	if err != nil {
		return nil, err
	}

	if len(req.SubSectionId) == 0 {
		req.SubSectionId = uc.getAllSubSections(ctx, req.PermissionId)
	}

	uniquePermissionList := utils.MakeUnique(req.PermissionId)
	uniqueSubSectionList := utils.MakeUnique(req.SubSectionId)

	updatedRolePermission, err := uc.repo.UpdateRolePermission(ctx, sqlc.UpdateRolePermissionParams{
		RolesID:              oldRolePermission.RolesID,
		PermissionsID:        uniquePermissionList,
		SubSectionPermission: uniqueSubSectionList,
		UpdatedAt:            time.Now(),
	})
	if err != nil {
		return nil, err
	}

	return &sqlc.RolesPermission{
		ID:                   updatedRolePermission.ID,
		RolesID:              updatedRolePermission.RolesID,
		PermissionsID:        updatedRolePermission.PermissionsID,
		SubSectionPermission: updatedRolePermission.SubSectionPermission,
	}, nil
}

func (uc *permissionUseCase) DeleteAllRolePermission(ctx *gin.Context, id int64) *exceptions.Exception {
	_, err := uc.repo.GetRolePermission(ctx, id)
	if err != nil {
		return err
	}

	return uc.repo.DeleteRolePermission(ctx, id)
}

func (uc *permissionUseCase) DeleteOneRolePermission(ctx *gin.Context, id int64, req domain.DeleteOneRolePermissionRequest) (*sqlc.RolesPermission, *exceptions.Exception) {
	oldRolePermission, err := uc.repo.GetRolePermission(ctx, id)
	if err != nil {
		return nil, err
	}

	if len(oldRolePermission.PermissionsID) == 1 {
		return nil, uc.repo.DeleteRolePermission(ctx, id)
	}

	updatedRolePermission, err := uc.repo.DeleteOnePermissionInRole(ctx, sqlc.DeleteOnePermissionInRoleParams{
		ID:      oldRolePermission.ID,
		Column2: req.PermissionId,
	})
	if err != nil {
		return nil, err
	}

	return &sqlc.RolesPermission{
		ID:                   updatedRolePermission.ID,
		RolesID:              updatedRolePermission.RolesID,
		PermissionsID:        updatedRolePermission.PermissionsID,
		SubSectionPermission: updatedRolePermission.SubSectionPermission,
	}, nil
}

// helpers

func (uc *permissionUseCase) getAllSubSections(ctx *gin.Context, permissionIds []int64) []int64 {
	var allSubSectionIds []int64
	var wg sync.WaitGroup
	subSectionChan := make(chan []int64, len(permissionIds))

	for _, permissionID := range permissionIds {
		wg.Add(1)
		go func(pid int64) {
			defer wg.Done()
			subSections, err := uc.repo.GetAllSubSectionByPermissionID(ctx, pid)
			if err != nil {
				return
			}
			var ids []int64
			for _, section := range subSections {
				ids = append(ids, section.ID)
			}
			subSectionChan <- ids
		}(permissionID)
	}

	go func() {
		wg.Wait()
		close(subSectionChan)
	}()

	for ids := range subSectionChan {
		allSubSectionIds = append(allSubSectionIds, ids...)
	}

	return utils.MakeUnique(allSubSectionIds)
}
