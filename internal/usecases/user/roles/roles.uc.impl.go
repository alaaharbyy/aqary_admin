package roles_usecase

import (
	"encoding/json"
	"fmt"
	"log"
	"strconv"
	"strings"
	"sync"
	"time"

	"aqary_admin/internal/delivery/redis"
	"aqary_admin/internal/delivery/rest/middleware"
	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	permissions_usecase "aqary_admin/internal/usecases/user/permissions"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/security"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"go.uber.org/zap"
)

// PermissionButton represents a single permission with an optional button ID
type PermissionButton struct {
	ID       int  `json:"id"`
	ButtonID *int `json:"button_id,omitempty"`
}

func (uc *roleUseCase) CreateRole(ctx *gin.Context, req domain.CreateRoleRequest) (*domain.RoleOutput, *exceptions.Exception) {

	existingRole, err := uc.repo.GetRoleByRole(ctx, sqlc.GetRoleByRoleParams{
		Role: req.Role,
		DepartmentID: pgtype.Int8{
			Int64: req.DepartmentID,
			Valid: true,
		},
	})
	log.Println("testing role,", existingRole)
	if err == nil && strings.EqualFold(existingRole.Role, req.Role) {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.AlreadyExistCode, "Role already exists")
	}

	var createdRole sqlc.Role
	var permissionList []int64
	var subSectionList []int64
	var rolePermission sqlc.RolesPermission

	payload := ctx.MustGet(middleware.AuthorizationPayloadKey).((*security.Payload))
	visitedUser, err := uc.repo.GetUserByName(ctx, payload.Username)
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCode(exceptions.UserNotAuthorizedErrorCode)
	}
	userId := visitedUser.ID

	er := sqlc.ExecuteTxWithException(ctx, uc.pool, func(q sqlc.Querier) *exceptions.Exception {

		log.Println("testing role:", req.DepartmentID)
		var err error

		createdRole, err = q.CreateRole(ctx, sqlc.CreateRoleParams{
			Role: req.Role,
			DepartmentID: pgtype.Int8{
				Int64: req.DepartmentID,
				Valid: true,
			},
			CreatedAt: time.Now(),
			UpdatedAt: time.Now(),
		})
		if err != nil {
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}

		var perm []domain.PermissionButton

		log.Println("testing permissions", req.Permissions)
		if req.Permissions == "" {
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "permissions required")
		}
		jsonErr := json.Unmarshal([]byte(req.Permissions), &perm)
		if jsonErr != nil {
			fmt.Println("Error unmarshaling JSON:", jsonErr)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, jsonErr.Error())
		}

		// Print the unmarshaled data
		fmt.Printf("Unmarshaled data: %+v\n", perm)

		for _, p := range perm {
			if p.ButtonID != 0 {
				subSectionList = append(subSectionList, int64(p.ID)) //buttons

				if p.PermissionID != 0 {
					permissionList = append(permissionList, int64(p.PermissionID)) // permissons
				}
				if p.SecondaryID != 0 {
					subSectionList = append(subSectionList, int64(p.SecondaryID)) // permissons
				}

				if p.TertiaryID != 0 {
					subSectionList = append(subSectionList, int64(p.TertiaryID)) // permissons
				}

				if p.QuaternaryID != 0 {
					subSectionList = append(subSectionList, int64(p.QuaternaryID)) // permissons
				}
			} else {
				permissionList = append(permissionList, int64(p.ID)) // permissons
				if p.PermissionID != 0 {
					permissionList = append(permissionList, int64(p.PermissionID)) // permissons
				}
				if p.SecondaryID != 0 {
					subSectionList = append(subSectionList, int64(p.SecondaryID)) // permissons
				}

				if p.TertiaryID != 0 {
					subSectionList = append(subSectionList, int64(p.TertiaryID)) // permissons
				}

				if p.QuaternaryID != 0 {
					subSectionList = append(subSectionList, int64(p.QuaternaryID)) // permissons
				}

			}
		}

		// removing the duplicates from the list
		permissionList = utils.MakeUnique(permissionList)
		subSectionList = utils.MakeUnique(subSectionList)

		var errr error
		rolePermission, errr = q.CreateRolePermission(ctx, sqlc.CreateRolePermissionParams{
			RolesID:              createdRole.ID,
			PermissionsID:        permissionList,
			SubSectionPermission: subSectionList,
			CreatedAt:            time.Now(),
			UpdatedAt:            time.Now(),
		})

		if errr != nil {
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, errr.Error())
		}

		return nil
	})

	if er != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())
	}

	/// saving
	redisClient, errRedis := redis.NewRedisClient()
	if errRedis != nil {
		log.Fatal("Failed to connect", zap.Error(errRedis))
	}
	defer redisClient.Close()

	type sectionPermission struct {
		ID                  int64 `json:"id"`
		SectionPermissionId int64 `json:"section_permission_id"`
	}

	spermission := sectionPermission{}
	var sectionIds []int64
	var AllPermissions []int64

	for _, value := range permissionList {

		cachePermission, err := redisClient.GetJSONFromFolder(ctx, "permissions", fmt.Sprintf("%v", value))
		fmt.Println("ERROR:", err)
		if err != nil {
			continue
		}

		json.Unmarshal(cachePermission, &spermission)

		// json.Unmarshal(sectionPermission, &sectionsPermission)
		if utils.Contains(sectionIds, spermission.SectionPermissionId) {
			continue
		}
		sectionIds = append(sectionIds, spermission.SectionPermissionId)
		// sectionsPermissionList = append(sectionsPermissionList, sectionsPermission)

	}

	if len(sectionIds) == 0 {
		// get from database
		sections, errr := uc.repo.GetAllSectionPermissionFromPermissionIDs(ctx, userId, permissionList)
		if errr != nil {
			return nil, nil
		}

		for _, value := range sections {
			sectionIds = append(sectionIds, value.ID)
		}
	}

	AllPermissions = utils.MergeUnique(sectionIds, permissionList, subSectionList)

	// set in cache all
	dataToCache, errMarshel := json.Marshal(AllPermissions)
	if errMarshel != nil {
		fmt.Println(errMarshel, "failed to marshal")
	}

	// set the data in cache
	if len(AllPermissions) > 0 {
		errr := redisClient.SetJSONInFolder(ctx, "companyUserRoles", strconv.FormatInt(createdRole.ID, 10), dataToCache, 200*time.Hour)

		if errr != nil {
			fmt.Println(err, "failed to set in cache")
		}
	}

	return &domain.RoleOutput{
		Role:             createdRole.Role,
		DepartmentID:     createdRole.DepartmentID.Int64,
		Permissions:      rolePermission.PermissionsID,
		ButtonPermission: rolePermission.SubSectionPermission,
	}, nil
}

func (uc *roleUseCase) GetRole(ctx *gin.Context, id int64) (*response.RoleOutout, *exceptions.Exception) {

	log.Println("testing role ", id)
	role, err := uc.repo.GetRole(ctx, id)
	if err != nil {
		log.Println("testing role err", err)
		return nil, err
	}

	var userPermission []int64
	var userSubSectionId []int64

	// log.Println("testing role", role.Role, role.ID)
	rolePermissions, er := uc.store.GetRolePermissionByRole(ctx, role.ID)
	if er != nil {
		log.Println("testing role permission err:", er)
		// return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())
	}

	userPermission = rolePermissions.PermissionsID
	userSubSectionId = rolePermissions.SubSectionPermission

	// it will fetch all section in case of super admin else fetch only assign one
	// userId := utils.Ternary[int64](visitedUser.UserTypesID == constants.SuperAdminUserTypes.Int64(), 0, visitedUser.ID)
	userId := int64(1) //: zero mean ignore only for super admin
	sections, sectionErr := uc.repo.GetAllSectionPermissionFromPermissionIDs(ctx, userId, userPermission)
	if sectionErr != nil {
		return nil, sectionErr
	}

	// log.Println("testing section length", len(sections))
	var wg sync.WaitGroup
	sectionChan := make(chan response.CustomSectionPermission, len(sections))

	for _, section := range sections {
		wg.Add(1)
		go func(s sqlc.SectionPermissionMv) {
			defer wg.Done()
			log.Println("testing userSubSectionId", userSubSectionId)
			// false: to expend to till end
			customSection := permissions_usecase.ProcessSection(ctx, uc.repo, section, userId, userPermission, userSubSectionId, false, nil)
			sectionChan <- customSection
		}(section)
	}

	go func() {
		wg.Wait()
		close(sectionChan)
	}()

	var allSections []response.CustomSectionPermission
	for section := range sectionChan {
		allSections = append(allSections, section)
	}

	return &response.RoleOutout{
		Id:          role.ID,
		Role:        role.Role,
		Permissions: allSections,
	}, nil
}

func (uc *roleUseCase) GetAllRoles(ctx *gin.Context, req domain.GetAllRolesRequest) ([]sqlc.Role, int64, *exceptions.Exception) {
	roles, err := uc.repo.GetAllRole(ctx, sqlc.GetAllRoleParams{
		Limit:        req.PageSize,
		Offset:       (req.PageNo - 1) * req.PageSize,
		Search:       utils.AddPercent(req.Search),
		DepartmentID: pgtype.Int8{Int64: req.DepartmentID, Valid: req.DepartmentID != 0},
	})
	if err != nil {
		return nil, 0, err
	}

	var responseRoles []sqlc.Role
	for _, r := range roles {
		responseRoles = append(responseRoles, sqlc.Role{
			ID:   r.ID,
			Role: r.Role,
			DepartmentID: pgtype.Int8{
				Int64: r.DepartmentID.Int64,
				Valid: true,
			},
		})
	}

	count, err := uc.repo.GetCountAllRoles(ctx, req.DepartmentID)
	if err != nil {
		return nil, 0, err
	}

	return responseRoles, count, nil
}

func (uc *roleUseCase) GetAllRolesWithoutPagination(ctx *gin.Context, req domain.GetAllRolesRequest) ([]response.AllRolesOutput, int64, *exceptions.Exception) {
	roles, err := uc.repo.GetAllRoleWithRolePermissionChecked(ctx)
	if err != nil {
		return nil, 0, err
	}

	var responseRoles []response.AllRolesOutput
	for _, r := range roles {
		responseRoles = append(responseRoles, response.AllRolesOutput{
			ID:          r.ID,
			Name:        r.Role,
			IsRoleExist: r.Isavailableinrolespermissions.Bool,
		})
	}

	count, err := uc.repo.GetCountAllRoles(ctx, req.DepartmentID)
	if err != nil {
		return nil, 0, err
	}

	return responseRoles, count, nil
}

func (uc *roleUseCase) UpdateRole(ctx *gin.Context, id int64, req domain.UpdateRoleRequest) (*domain.RoleOutput, *exceptions.Exception) {
	// req.Role = utils.SanitizeString(req.Role)

	_, err := uc.repo.GetRole(ctx, id)
	if err != nil {
		return nil, err
	}

	var updatedRole sqlc.Role
	var permissionList []int64
	var subSectionList []int64
	var updatedPermission sqlc.RolesPermission
	er := sqlc.ExecuteTxWithException(ctx, uc.pool, func(q sqlc.Querier) *exceptions.Exception {

		var err error
		updatedRole, err = q.UpdateRole(ctx, sqlc.UpdateRoleParams{
			ID:   id,
			Role: req.Role,
			DepartmentID: pgtype.Int8{
				Int64: req.DepartmentID,
				Valid: req.DepartmentID != 0,
			},
			UpdatedAt: time.Now(),
		})
		if err != nil {
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}

		var perm []domain.PermissionButton

		log.Println("testing permissions", req.Permissions)
		jsonErr := json.Unmarshal([]byte(req.Permissions), &perm)
		if jsonErr != nil {
			fmt.Println("Error unmarshaling JSON:", jsonErr)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, jsonErr.Error())
		}

		// Print the unmarshaled data
		fmt.Printf("Unmarshaled data: %+v\n", perm)

		for _, p := range perm {
			if p.ButtonID != 0 {
				subSectionList = append(subSectionList, int64(p.ID))
				if p.PermissionID != 0 {
					permissionList = append(permissionList, int64(p.PermissionID)) // permissons
				}
				if p.SecondaryID != 0 {
					subSectionList = append(subSectionList, int64(p.SecondaryID)) // permissons
				}

				if p.TertiaryID != 0 {
					subSectionList = append(subSectionList, int64(p.TertiaryID)) // permissons
				}

				if p.QuaternaryID != 0 {
					subSectionList = append(subSectionList, int64(p.QuaternaryID)) // permissons
				}
			} else {
				permissionList = append(permissionList, int64(p.ID)) // permissons
				if p.PermissionID != 0 {
					permissionList = append(permissionList, int64(p.PermissionID)) // permissons
				}
				if p.SecondaryID != 0 {
					subSectionList = append(subSectionList, int64(p.SecondaryID)) // permissons
				}

				if p.TertiaryID != 0 {
					subSectionList = append(subSectionList, int64(p.TertiaryID)) // permissons
				}

				if p.QuaternaryID != 0 {
					subSectionList = append(subSectionList, int64(p.QuaternaryID)) // permissons
				}
			}
		}

		// removing the duplicates from the list
		permissionList = utils.MakeUnique(permissionList)
		subSectionList = utils.MakeUnique(subSectionList)

		updatedPermission, err = q.UpdateRolePermission(ctx, sqlc.UpdateRolePermissionParams{
			RolesID:              updatedRole.ID,
			PermissionsID:        permissionList,
			SubSectionPermission: subSectionList,
			UpdatedAt:            time.Now(),
		})
		if err != nil {
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}

		return nil
	})

	if er != nil {
		return nil, er
	}

	return &domain.RoleOutput{
		Role:             updatedRole.Role,
		DepartmentID:     updatedRole.DepartmentID.Int64,
		Permissions:      updatedPermission.PermissionsID,
		ButtonPermission: updatedPermission.SubSectionPermission,
	}, nil
}

func (uc *roleUseCase) DeleteRole(ctx *gin.Context, req domain.DeleteRoleRequest) *exceptions.Exception {
	role, err := uc.repo.GetRole(ctx, req.RoleID)
	if err != nil {
		return err
	}

	er := sqlc.ExecuteTxWithException(ctx, uc.pool, func(q sqlc.Querier) *exceptions.Exception {

		log.Println("testing delete id s", role.ID, req.RoleID, req.DepartmentID)
		err := q.DeleteRolePermission(ctx, role.ID)
		log.Println("testing err", err)
		if err != nil {
			log.Println("testing ...", err)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}

		errr := q.DeleteRole(ctx, sqlc.DeleteRoleParams{
			ID: req.RoleID,
			DepartmentID: pgtype.Int8{
				Int64: req.DepartmentID,
				Valid: req.DepartmentID != 0,
			},
		})
		log.Println("testing ... delete role:::", errr)
		if errr != nil {
			log.Println("testing ... delete role", errr)
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, errr.Error())
		}
		return nil
	})
	if er != nil {
		log.Println("testing ...delete api", er)
		return er
	}
	return nil
}
