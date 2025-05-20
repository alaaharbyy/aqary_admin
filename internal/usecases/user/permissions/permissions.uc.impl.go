package permissions_usecase

import (
	// "aqary_admin/internal/domain/requests/permission"
	// "aqary_admin/internal/domain/responses/permission"

	"context"
	"encoding/json"
	"fmt"
	"log"
	"strconv"
	"sync"
	"time"

	"aqary_admin/internal/delivery/redis"
	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	db "aqary_admin/pkg/db/user"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/constants"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/security"

	"github.com/RediSearch/redisearch-go/v2/redisearch"
	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"go.uber.org/zap"
)

func (uc *permissionUseCase) CreatePermission(ctx *gin.Context, req domain.CreatePermissionRequest) (*sqlc.Permission, *exceptions.Exception) {

	oldPerm, _ := uc.repo.GetPermissionByTitle(ctx, req.Title)
	if oldPerm.ID != 0 {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "already  exist")
	}

	newPermission, err := uc.repo.CreatePermission(ctx, sqlc.CreatePermissionParams{
		Title:               req.Title,
		SubTitle:            pgtype.Text{String: req.SubTitle, Valid: req.SubTitle != ""},
		SectionPermissionID: req.SectionPermissionId,
		CreatedAt:           time.Now(),
		UpdatedAt:           time.Now(),
	}, nil)
	if err != nil {
		return nil, err
	}

	return newPermission, nil
}

func (uc *permissionUseCase) GetAllPermission(ctx *gin.Context, req domain.GetAllPermissionRequest) ([]response.CustomSectionPermission, int64, *exceptions.Exception) {

	sections, err := uc.repo.GetAllSectionPermissionMV(ctx, req.PageSize, (req.PageNo-1)*req.PageSize, req.Search)
	if err != nil {
		return nil, 0, err
	}

	var wg sync.WaitGroup
	sectionChan := make(chan response.CustomSectionPermission, len(sections))

	for _, section := range sections {
		wg.Add(1)
		go func(s sqlc.SectionPermissionMv) {
			defer wg.Done()
			sectionChan <- ProcessSection(ctx, uc.repo, s, 0, nil, nil, true, nil) // it will be for super admin so we can pass nil & zero
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

	count, err := uc.repo.GetCountAllSectionPermissionMV(ctx, req.Search)
	if err != nil {
		return nil, 0, err
	}

	return allSections, count, nil
}

// TODO: need to modified accordingly with filters
func (uc *permissionUseCase) GetAllPermissionWithoutPagination(ctx *gin.Context, req domain.GetAllPermissionWithoutPaginationRequest) ([]response.CustomSectionPermission, *exceptions.Exception) {
	var allSections []response.CustomSectionPermission
	payload := ctx.MustGet("authorization_payload").(*security.Payload)
	visitedUser, err := uc.repo.GetUserByName(ctx, payload.Username)
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, "user not found")
	}

	var userId int64
	var cacheKey string

	if req.CompanyMain {
		// get the company admin user
		company, err := uc.repo.GetCompany(ctx, int32(req.CompanyID))
		if err != nil {
			return []response.CustomSectionPermission{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}

		userId = company.UsersID
		cacheKey = "AllCompanyPermissions"
	} else {
		userId = visitedUser.ID
		cacheKey = "AllUserPermissions"
	}

	redisClient, er := redis.NewRedisClient()
	if er != nil {
		log.Fatal("Failed to connect", zap.Error(er))
	}
	defer redisClient.Close()

	visitedUserIdString := strconv.FormatInt(userId, 10)

	// log.Println("testing user ", visitedUser.UserTypesID, constants.SuperAdminUserTypes.Int64())

	// check in chache and return the response if exists
	cachePermissions, er := redisClient.GetJSONFromFolder(ctx, cacheKey, visitedUserIdString)
	if er != nil {
		log.Println("no data in cache")
	}

	if cachePermissions != nil {

		json.Unmarshal(cachePermissions, &allSections)
		if len(allSections) != 0 {
			return allSections, nil
		}
	}

	var userPermission []int64
	var userSubSectionId []int64

	if visitedUser.UserTypesID != constants.SuperAdminUserTypes.Int64() {

		/////////////////////////////////
		// getting the user permission
		permissions, er := uc.repo.GetUserCompanyPermissionByID(ctx, sqlc.GetUserCompanyPermissionsByIDParams{
			IsCompanyUser: req.CompanyID,
			CompanyID: pgtype.Int8{
				Int64: req.CompanyID,
				Valid: true,
			},
			UserID: userId,
		})

		if er != nil {
			return []response.CustomSectionPermission{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}

		// log.Println("testing user Permission", permissions)
		// userPermission = permissions.PermissionsID
		// userSubSectionId = permissions.SubSectionsID
		/////////////////////////////////////////  other example
		// getting the user permission
		// permissions, er := uc.repo.GetUserPermissionsTestByID(ctx, sqlc.GetUserPermissionsTestByIDParams{
		// 	IsCompanyUser: req.CompanyID,
		// 	CompanyID: pgtype.Int8{
		// 		Int64: req.CompanyID,
		// 		Valid: true,
		// 	},
		// 	UserID: visitedUser.ID,
		// })

		// if er != nil {
		// 	return []response.CustomSectionPermission{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		// }

		userPermission = permissions

		// getting the user permission
		subSectionIds, er := uc.repo.GetUserCompanySubSectionPermissionsByID(ctx, sqlc.GetUserCompanySubSectionPermissionsByIDParams{
			IsCompanyUser: req.CompanyID,
			CompanyID: pgtype.Int8{
				Int64: req.CompanyID,
				Valid: true,
			},
			UserID: userId,
		})

		if er != nil {
			return []response.CustomSectionPermission{}, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}
		userSubSectionId = subSectionIds
	}

	// it will fetch all section in case of super admin else fetch only assign one
	userId = utils.Ternary[int64](visitedUser.UserTypesID == constants.SuperAdminUserTypes.Int64(), 0, userId)

	sectionsPermission := sqlc.SectionPermissionMv{}
	var sectionsPermissionList []sqlc.SectionPermissionMv

	if len(userPermission) == 0 {

		cacheSectionPermission, err := redisClient.GetAllJSONFromFolder(ctx, "sectionPermissions")

		if err == nil {
			for _, v := range cacheSectionPermission {
				json.Unmarshal(v, &sectionsPermission)
				sectionsPermissionList = append(sectionsPermissionList, sectionsPermission)
			}
		}

	} else {
		// var userSectionIds []int64
		// get section ids in array from permission cache by getting permission cache with key
		type sectionPermission struct {
			ID                  int64 `json:"id"`
			SectionPermissionId int64 `json:"section_permission_id"`
		}

		spermission := sectionPermission{}
		var sectionIds []int64

		for _, value := range userPermission {

			cachePermission, err := redisClient.GetJSONFromFolder(ctx, "permissions", fmt.Sprintf("%v", value))
			fmt.Println("ERROR:", err)
			if err != nil {
				continue
			}

			json.Unmarshal(cachePermission, &spermission)

			sectionPermission, err := redisClient.GetJSONFromFolder(ctx, "sectionPermissions", fmt.Sprintf("%v", spermission.SectionPermissionId))
			if err != nil {
				continue
			}

			json.Unmarshal(sectionPermission, &sectionsPermission)
			if utils.Contains(sectionIds, spermission.SectionPermissionId) {
				continue
			}
			sectionIds = append(sectionIds, spermission.SectionPermissionId)
			sectionsPermissionList = append(sectionsPermissionList, sectionsPermission)

		}

	}

	if len(sectionsPermissionList) == 0 {
		sections, err := uc.repo.GetAllSectionPermissionFromPermissionIDs(ctx, userId, userPermission)
		if err != nil {
			return nil, err
		}
		sectionsPermissionList = sections
	}

	// log.Println("testing section length", len(sections))
	var wg sync.WaitGroup
	sectionChan := make(chan response.CustomSectionPermission, len(sectionsPermissionList))

	for _, section := range sectionsPermissionList {
		wg.Add(1)
		go func(s sqlc.SectionPermissionMv) {
			defer wg.Done()
			customSection := ProcessSection(ctx, uc.repo, section, userId, userPermission, userSubSectionId, false, redisClient) // false: to expend to till end
			sectionChan <- customSection
		}(section)
	}

	go func() {
		wg.Wait()
		close(sectionChan)
	}()

	for section := range sectionChan {
		allSections = append(allSections, section)
	}

	// set in cache all
	dataToCache, er := json.Marshal(allSections)
	if er != nil {
		fmt.Println(er, "failed to marshal")
	}

	// set the data in cache
	if len(allSections) > 0 {
		errr := redisClient.SetJSONInFolder(ctx, cacheKey, visitedUserIdString, dataToCache, 200*time.Hour)

		if errr != nil {
			fmt.Println(err, "failed to set in cache")
		}
	}
	return allSections, nil
}

func (uc *permissionUseCase) UpdatePermission(ctx *gin.Context, id int64, req domain.UpdatePermissionRequest) (*sqlc.Permission, *exceptions.Exception) {
	oldPermission, err := uc.repo.GetPermission(ctx, id)
	if err != nil {
		return nil, err
	}

	req.Title = utils.SanitizeString(req.Title)

	if req.Title == "" {
		req.Title = oldPermission.Title
	}
	if req.SubTitle == "" {
		req.SubTitle = oldPermission.SubTitle.String
	}
	if req.SectionPermissionId == 0 {
		req.SectionPermissionId = oldPermission.SectionPermissionID
	}

	updatedPermission, err := uc.repo.UpdatePermission(ctx, sqlc.UpdatePermissionParams{
		ID:                  oldPermission.ID,
		Title:               req.Title,
		SubTitle:            pgtype.Text{String: req.SubTitle, Valid: true},
		SectionPermissionID: req.SectionPermissionId,
		CreatedAt:           oldPermission.CreatedAt,
		UpdatedAt:           time.Now(),
	})
	if err != nil {
		return nil, err
	}

	return &sqlc.Permission{
		ID:                  updatedPermission.ID,
		Title:               updatedPermission.Title,
		SubTitle:            updatedPermission.SubTitle,
		SectionPermissionID: updatedPermission.SectionPermissionID,
	}, nil
}

func (uc *permissionUseCase) DeletePermission(ctx *gin.Context, id int64) *exceptions.Exception {
	_, err := uc.repo.GetPermission(ctx, id)
	if err != nil {
		return err
	}

	return uc.repo.DeletePermission(ctx, id)
}

func (uc *permissionUseCase) GetPermissionByRoleID(ctx *gin.Context, roleID int64) (*response.CustomRolePermission, *exceptions.Exception) {
	role, err := uc.repo.GetRole(ctx, roleID)
	if err != nil {
		return nil, err
	}

	rolePermission, err := uc.repo.GetRolePermissionByRole(ctx, role.ID)
	if err != nil {
		return nil, err
	}

	var wg sync.WaitGroup
	sectionChan := make(chan response.CustomSectionPermission)

	for _, permissionID := range rolePermission.PermissionsID {
		wg.Add(1)
		go func(id int64) {
			defer wg.Done()
			section := uc.processSectionForRole(ctx, id, rolePermission)
			if section != nil {
				sectionChan <- *section
			}
		}(permissionID)
	}

	go func() {
		wg.Wait()
		close(sectionChan)
	}()

	var allSections []response.CustomSectionPermission
	for section := range sectionChan {
		allSections = append(allSections, section)
	}

	return &response.CustomRolePermission{
		ID:                role.ID,
		Label:             role.Role,
		SectionPermission: allSections,
	}, nil
}

func (uc *permissionUseCase) GetAllPermissionBySectionPermission(ctx *gin.Context, sectionID int64) ([]response.PermissionOutput, *exceptions.Exception) {
	permissions, err := uc.repo.GetAllPermissionBySectionPermissionId(ctx, sectionID)
	if err != nil {
		return nil, err
	}

	var output []response.PermissionOutput
	for _, p := range permissions {
		output = append(output, response.PermissionOutput{
			ID:       p.ID,
			Title:    p.Title,
			SubTitle: p.SubTitle.String,
		})
	}

	return output, nil
}

// -----------------------------------------
func ProcessSection(ctx *gin.Context, repo db.UserCompositeRepo, section sqlc.SectionPermissionMv, userId int64, allPermissionId []int64, subSectionIds []int64, stopHere bool, redisClient *redis.RedisClient) response.CustomSectionPermission {
	// get all the permissions by section id and by all permissions ids
	var permissions []sqlc.PermissionsMv
	var total int
	var docs []redisearch.Document
	var redisSearchQuery string

	// get from cache permissions with section id and all permissions
	// prepare the query accordingly
	if len(allPermissionId) > 0 {
		// create quereis for all perission id's
		permissionsQuery := utils.CreateRedisQueryForPermissionIds(allPermissionId)
		redisSearchQuery = fmt.Sprintf("@section_permission_id:[%v %v] (%v)", section.ID, section.ID, permissionsQuery)

	} else {
		// fmt.Sprintf("getting permissions from cache for section: %v", section.ID)
		redisSearchQuery = fmt.Sprintf("@section_permission_id:[%v %v]", section.ID, section.ID)
	}

	if redisClient != nil {
		redisDocs, count, err := redisClient.SearchInIndex("idx:permissions", redisSearchQuery)
		if err != nil {
			log.Println("[cache ProcessSection] err:", err)
		}
		total = count
		docs = redisDocs

		if total > 0 {
			for _, doc := range docs {

				for _, singleDoc := range doc.Properties {
					var singlePermission sqlc.PermissionsMv
					err := json.Unmarshal([]byte(singleDoc.(string)), &singlePermission)
					if err != nil {
						log.Fatal("Error unmarshalling JSON:", err)
					}

					permissions = append(permissions, singlePermission)
				}

			}
		}
	}

	if len(permissions) == 0 {
		permissionsData, err := repo.GetAllForSuperUserPermissionBySectionPermissionIdMV(ctx, section.ID, userId, allPermissionId)
		if err != nil {
			log.Println("[processSection] err:", err)
		}

		permissions = permissionsData
	}

	var wg sync.WaitGroup
	permissionChan := make(chan response.CustomAlllPermission, len(permissions))

	for _, p := range permissions {
		wg.Add(1)
		go func(permission sqlc.PermissionsMv) {
			defer wg.Done()
			// log.Println("testing userSubSectionId", subSectionIds, ":::", stopHere)
			customPermission := ProcessPermission(ctx, repo, permission, userId, subSectionIds, stopHere, redisClient) // true: it stop the process here ...
			permissionChan <- customPermission
		}(p)
	}

	go func() {
		wg.Wait()
		close(permissionChan)
	}()

	var allPermissions []response.CustomAlllPermission
	for permission := range permissionChan {
		allPermissions = append(allPermissions, permission)
	}
	// log.Println("testing resoonse permission", allPermissions)
	return response.CustomSectionPermission{
		ID:               section.ID,
		Label:            section.Title,
		SubLabel:         section.SubTitle.String,
		Indicator:        section.Indicator,
		CustomPermission: allPermissions,
	}
}

func ProcessPermission(ctx *gin.Context, repo db.UserCompositeRepo, permission sqlc.PermissionsMv, userId int64, allSectionID []int64, shouldStop bool, redisClient *redis.RedisClient) response.CustomAlllPermission {

	var allSubSections []response.CustomSubSectionSecondaryPermission

	if !shouldStop {
		// get from cache first
		// prepare the query accordingly
		var subSections []sqlc.SubSectionMv
		var total int
		var docs []redisearch.Document
		var redisSearchQuery string

		if len(allSectionID) > 0 {
			// create quereis for all perission id's
			subsectionQuery := utils.CreateRedisQueryForSubSectionIds(allSectionID)
			redisSearchQuery = fmt.Sprintf("@permissions_id:[%v %v] @sub_section_button_id:[%v %v] (%v)", permission.ID, permission.ID, permission.ID, permission.ID, subsectionQuery)

		} else {
			// fmt.Sprintf("getting permissions from cache for section: %v", section.ID)
			redisSearchQuery = fmt.Sprintf("@permissions_id:[%v %v] @sub_section_button_id:[%v %v]", permission.ID, permission.ID, permission.ID, permission.ID)
		}

		if redisClient != nil {
			redisDocs, count, err := redisClient.SearchInIndex("idx:subSectionPermissions", redisSearchQuery)
			if err != nil {
				log.Println("[cache ProcessPermission] err:", err)
			}
			total = count
			docs = redisDocs

			if total > 0 {
				for _, doc := range docs {

					for _, singleDoc := range doc.Properties {
						var singlePermission sqlc.SubSectionMv
						err := json.Unmarshal([]byte(singleDoc.(string)), &singlePermission)
						if err != nil {
							log.Fatal("Error unmarshalling JSON:", err)
						}

						subSections = append(subSections, singlePermission)
					}

				}
			}
		}

		if len(subSections) == 0 {
			subSectionsPermission, err := repo.GetAllSubSectionByPermissionIDMV(ctx, sqlc.GetAllSubSectionByPermissionIDMVWithRelationParams{ //it's with relation
				IsSuperUser:   userId,
				SubSectionsID: allSectionID,
				PermissionsID: permission.ID,
			})
			if err != nil {
				log.Println("[processPermission] err:", err)
			}

			subSections = subSectionsPermission
		}

		// log.Println("testing should stop", subSections, "userId:", userId, "subSectionID:", allSectionID, "permissionID:", permission.ID)
		// media app...

		var wg sync.WaitGroup
		subSectionChan := make(chan response.CustomSubSectionSecondaryPermission, len(subSections))
		for _, ss := range subSections {
			wg.Add(1)
			go func(subSection sqlc.SubSectionMv) {
				defer wg.Done()
				if userId == 0 {
					customSubSection := ProcessSubSection(ctx, repo, subSection, permission.ID, userId, allSectionID, redisClient)
					subSectionChan <- customSubSection
				} else {
					if utils.ContainsInt(allSectionID, ss.ID) {
						customSubSection := ProcessSubSection(ctx, repo, subSection, permission.ID, userId, allSectionID, redisClient)
						subSectionChan <- customSubSection
					}
				}
			}(ss)
		}
		go func() {
			wg.Wait()
			close(subSectionChan)
		}()

		for subSection := range subSectionChan {
			allSubSections = append(allSubSections, subSection)
		}

	}

	return response.CustomAlllPermission{
		ID:                           permission.ID,
		Label:                        permission.Title,
		SubLabel:                     permission.SubTitle.String,
		Indicator:                    permission.Indicator,
		CustomAllSecondaryPermission: allSubSections,
	}
}

func ProcessSubSection(ctx *gin.Context, repo db.UserCompositeRepo, subSection sqlc.SubSectionMv, permissionID int64, userId int64, allSubSectionIds []int64, redisClient *redis.RedisClient) response.CustomSubSectionSecondaryPermission {

	// get permission from cache first
	var ternarySubSections []sqlc.SubSectionMv
	var total int
	var docs []redisearch.Document
	var redisSearchQuery string

	if len(allSubSectionIds) == 0 {
		subsectionQuery := utils.CreateRedisQueryForSubSectionIds(allSubSectionIds)
		redisSearchQuery = fmt.Sprintf("@sub_section_button_id:[%v %v] (%v)", subSection.ID, subSection.ID, subsectionQuery)
	} else {
		redisSearchQuery = fmt.Sprintf("@sub_section_button_id:[%v %v]", subSection.ID, subSection.ID)
	}

	if redisClient != nil {
		redisDocs, count, err := redisClient.SearchInIndex("idx:subSectionPermissions", redisSearchQuery)
		if err != nil {
			log.Println("[cache ProcessSubSection] err:", err)
		}
		total = count
		docs = redisDocs

		if total > 0 {
			for _, doc := range docs {

				for _, singleDoc := range doc.Properties {
					var singlePermission sqlc.SubSectionMv
					err := json.Unmarshal([]byte(singleDoc.(string)), &singlePermission)
					if err != nil {
						log.Fatal("Error unmarshalling JSON:", err)
					}

					ternarySubSections = append(ternarySubSections, singlePermission)
				}

			}
		}
	}

	if len(ternarySubSections) == 0 {
		ternarySubSectionsData, err := repo.GetAllSubSectionPermissionBySubSectionButtonIDMV(ctx, sqlc.GetAllSubSectionPermissionBySubSectionButtonIDMVParams{
			IsSuperUser:        userId,
			SubSectionID:       allSubSectionIds,
			SubSectionButtonID: subSection.ID,
		})
		if err != nil {
			log.Println("[processSubSection] err:", err)
		}
		ternarySubSections = ternarySubSectionsData
	}

	var wg sync.WaitGroup
	ternaryChan := make(chan response.CustomAllSecondarySubSectionPermission, len(ternarySubSections))
	for _, ts := range ternarySubSections {
		wg.Add(1)
		go func(ternary sqlc.SubSectionMv) {
			defer wg.Done()
			// customTernary := ProcessTernarySubSection(ctx, repo, ternary, permissionID, subSection.ID, userId, allSubSectionIds)
			// ternaryChan <- customTernary
			if userId == 0 {
				customTernary := ProcessTernarySubSection(ctx, repo, ternary, permissionID, subSection.ID, userId, allSubSectionIds, redisClient)
				ternaryChan <- customTernary
			} else {
				if utils.ContainsInt(allSubSectionIds, ts.ID) {
					customTernary := ProcessTernarySubSection(ctx, repo, ternary, permissionID, subSection.ID, userId, allSubSectionIds, redisClient)
					ternaryChan <- customTernary
				}
			}
		}(ts)
	}

	go func() {
		wg.Wait()
		close(ternaryChan)
	}()

	var allTernarySubSections []response.CustomAllSecondarySubSectionPermission
	for ternary := range ternaryChan {
		allTernarySubSections = append(allTernarySubSections, ternary)
	}

	return response.CustomSubSectionSecondaryPermission{
		ID:                            subSection.ID,
		Label:                         subSection.SubSectionName,
		SubLabel:                      subSection.SubSectionNameConstant,
		Indicator:                     subSection.Indicator,
		PermissionID:                  subSection.PermissionsID,
		PrimaryID:                     permissionID,
		SubSectionButtonID:            subSection.SubSectionButtonID,
		SubSectionButtonAction:        subSection.SubSectionButtonAction,
		CustomAllSubSectionPermission: allTernarySubSections,
	}
}

func ProcessTernarySubSection(ctx *gin.Context, repo db.UserCompositeRepo, ternary sqlc.SubSectionMv, permissionID, subSectionID int64, userId int64, allSubSectionIds []int64, redisClient *redis.RedisClient) response.CustomAllSecondarySubSectionPermission {

	// get permission from cache first
	var quaternarySubSections []sqlc.SubSectionMv
	var total int
	var docs []redisearch.Document
	var redisSearchQuery string

	if len(allSubSectionIds) == 0 {
		subsectionQuery := utils.CreateRedisQueryForSubSectionIds(allSubSectionIds)
		redisSearchQuery = fmt.Sprintf("@sub_section_button_id:[%v %v] (%v)", ternary.ID, ternary.ID, subsectionQuery)
	} else {
		redisSearchQuery = fmt.Sprintf("@sub_section_button_id:[%v %v]", ternary.ID, ternary.ID)
	}

	if redisClient != nil {
		redisDocs, count, err := redisClient.SearchInIndex("idx:subSectionPermissions", redisSearchQuery)
		if err != nil {
			log.Println("[cache ProcessTernarySubSection] err:", err)
		}
		total = count
		docs = redisDocs

		if total > 0 {
			for _, doc := range docs {

				for _, singleDoc := range doc.Properties {
					var singlePermission sqlc.SubSectionMv
					err := json.Unmarshal([]byte(singleDoc.(string)), &singlePermission)
					if err != nil {
						log.Fatal("Error unmarshalling JSON:", err)
					}

					quaternarySubSections = append(quaternarySubSections, singlePermission)
				}

			}
		}
	}

	if len(quaternarySubSections) == 0 {
		quaternarySubSectionsPermissions, err := repo.GetAllSubSectionPermissionBySubSectionButtonIDMV(ctx, sqlc.GetAllSubSectionPermissionBySubSectionButtonIDMVParams{
			IsSuperUser:        userId,
			SubSectionID:       allSubSectionIds,
			SubSectionButtonID: ternary.ID,
		})
		if err != nil {
			log.Println("[processTernarySubSection] err:", err)
		}

		quaternarySubSections = quaternarySubSectionsPermissions
	}

	var wg sync.WaitGroup
	quaternaryChan := make(chan response.CustomAllQuaternarySubSectionPermission, len(quaternarySubSections))

	for _, qs := range quaternarySubSections {
		wg.Add(1)
		go func(quaternary sqlc.SubSectionMv) {
			defer wg.Done()
			// customQuaternary := ProcessQuaternarySubSection(ctx, repo, quaternary, permissionID, subSectionID, ternary.ID, userId, allSubSectionIds)
			// quaternaryChan <- customQuaternary
			if userId == 0 {
				customQuaternary := ProcessQuaternarySubSection(ctx, repo, quaternary, permissionID, subSectionID, ternary.ID, userId, allSubSectionIds, redisClient)
				quaternaryChan <- customQuaternary
			} else {
				if utils.ContainsInt(allSubSectionIds, qs.ID) {
					customQuaternary := ProcessQuaternarySubSection(ctx, repo, quaternary, permissionID, subSectionID, ternary.ID, userId, allSubSectionIds, redisClient)
					quaternaryChan <- customQuaternary
				}
			}
		}(qs)
	}

	go func() {
		wg.Wait()
		close(quaternaryChan)
	}()

	var allQuaternarySubSections []response.CustomAllQuaternarySubSectionPermission
	for quaternary := range quaternaryChan {
		allQuaternarySubSections = append(allQuaternarySubSections, quaternary)
	}

	return response.CustomAllSecondarySubSectionPermission{
		ID:                     ternary.ID,
		Label:                  ternary.SubSectionName,
		SubLabel:               ternary.SubSectionNameConstant,
		Indicator:              ternary.Indicator,
		PermissionID:           ternary.PermissionsID,
		PrimaryID:              permissionID,
		SecondaryID:            subSectionID,
		SubSectionButtonID:     ternary.SubSectionButtonID,
		SubSectionButtonAction: ternary.SubSectionButtonAction,
		QuaternaryPermission:   allQuaternarySubSections,
	}
}

func ProcessQuaternarySubSection(ctx *gin.Context, repo db.UserCompositeRepo, quaternary sqlc.SubSectionMv, permissionID, subSectionID, ternaryID int64, userId int64, allSubSectionIds []int64, redisClient *redis.RedisClient) response.CustomAllQuaternarySubSectionPermission {

	// get permission from cache first
	var quinarySubSections []sqlc.SubSectionMv
	var total int
	var docs []redisearch.Document
	var redisSearchQuery string

	if len(allSubSectionIds) == 0 {
		subsectionQuery := utils.CreateRedisQueryForSubSectionIds(allSubSectionIds)
		redisSearchQuery = fmt.Sprintf("@sub_section_button_id:[%v %v] (%v)", quaternary.ID, quaternary.ID, subsectionQuery)
	} else {
		redisSearchQuery = fmt.Sprintf("@sub_section_button_id:[%v %v]", quaternary.ID, quaternary.ID)
	}

	if redisClient != nil {
		redisDocs, count, err := redisClient.SearchInIndex("idx:subSectionPermissions", redisSearchQuery)
		if err != nil {
			log.Println("[cache ProcessQuaternarySubSection] err:", err)
		}
		total = count
		docs = redisDocs

		if total > 0 {
			for _, doc := range docs {

				for _, singleDoc := range doc.Properties {
					var singlePermission sqlc.SubSectionMv
					err := json.Unmarshal([]byte(singleDoc.(string)), &singlePermission)
					if err != nil {
						log.Fatal("Error unmarshalling JSON:", err)
					}

					quinarySubSections = append(quinarySubSections, singlePermission)
				}

			}
		}
	}

	if len(quinarySubSections) == 0 {
		quinarySubSectionsPermissions, err := repo.GetAllSubSectionPermissionBySubSectionButtonIDMV(ctx, sqlc.GetAllSubSectionPermissionBySubSectionButtonIDMVParams{
			IsSuperUser:        userId,
			SubSectionID:       allSubSectionIds,
			SubSectionButtonID: quaternary.ID,
		})
		if err != nil {
			log.Println("[processQuaternarySubSection] err:", err)
		}

		quinarySubSections = quinarySubSectionsPermissions
	}

	var wg sync.WaitGroup
	quinaryChan := make(chan response.CustomAllQuinarySubSectionPermission, len(quinarySubSections))

	for _, qs := range quinarySubSections {
		wg.Add(1)
		go func(quinary sqlc.SubSectionMv) {
			defer wg.Done()

			// customQuinary := response.CustomAllQuinarySubSectionPermission{
			// 	ID:                     quinary.ID,
			// 	Label:                  quinary.SubSectionName,
			// 	SubLabel:               quinary.SubSectionNameConstant,
			// 	Indicator:              quinary.Indicator,
			// 	PermissionID:           quinary.PermissionsID,
			// 	PrimaryID:              permissionID,
			// 	SecondaryID:            subSectionID,
			// 	TernaryID:              ternaryID,
			// 	QuaternaryID:           quaternary.ID,
			// 	SubSectionButtonID:     quinary.SubSectionButtonID,
			// 	SubSectionButtonAction: quinary.SubSectionButtonAction,
			// }
			// quinaryChan <- customQuinary

			if userId == 0 {
				customQuinary := response.CustomAllQuinarySubSectionPermission{
					ID:                     quinary.ID,
					Label:                  quinary.SubSectionName,
					SubLabel:               quinary.SubSectionNameConstant,
					Indicator:              quinary.Indicator,
					PermissionID:           quinary.PermissionsID,
					PrimaryID:              permissionID,
					SecondaryID:            subSectionID,
					TernaryID:              ternaryID,
					QuaternaryID:           quaternary.ID,
					SubSectionButtonID:     quinary.SubSectionButtonID,
					SubSectionButtonAction: quinary.SubSectionButtonAction,
				}
				quinaryChan <- customQuinary
			} else {
				if utils.ContainsInt(allSubSectionIds, qs.ID) {
					customQuinary := response.CustomAllQuinarySubSectionPermission{
						ID:                     quinary.ID,
						Label:                  quinary.SubSectionName,
						SubLabel:               quinary.SubSectionNameConstant,
						Indicator:              quinary.Indicator,
						PermissionID:           quinary.PermissionsID,
						PrimaryID:              permissionID,
						SecondaryID:            subSectionID,
						TernaryID:              ternaryID,
						QuaternaryID:           quaternary.ID,
						SubSectionButtonID:     quinary.SubSectionButtonID,
						SubSectionButtonAction: quinary.SubSectionButtonAction,
					}
					quinaryChan <- customQuinary
				}
			}
		}(qs)
	}

	go func() {
		wg.Wait()
		close(quinaryChan)
	}()

	var allQuinarySubSections []response.CustomAllQuinarySubSectionPermission
	for quinary := range quinaryChan {
		allQuinarySubSections = append(allQuinarySubSections, quinary)
	}

	return response.CustomAllQuaternarySubSectionPermission{
		ID:                     quaternary.ID,
		Label:                  quaternary.SubSectionName,
		SubLabel:               quaternary.SubSectionNameConstant,
		Indicator:              quaternary.Indicator,
		PermissionID:           quaternary.PermissionsID,
		PrimaryID:              permissionID,
		SecondaryID:            subSectionID,
		TernaryID:              ternaryID,
		SubSectionButtonID:     quaternary.SubSectionButtonID,
		SubSectionButtonAction: quaternary.SubSectionButtonAction,
		QuinaryPermission:      allQuinarySubSections,
	}
}

// FindCommonPermissions takes two slices of permissions (represented as int64) and returns a new slice containing only the permissions that are common to both.
func FindCommonPermissions(list1, list2 []int64) []int64 {
	common := []int64{} // Initialize an empty slice for common permissions

	// Create a map to store the permissions of the first list for quick lookup
	permissionsMap := make(map[int64]bool)
	for _, perm := range list1 {
		permissionsMap[perm] = true
	}

	// Iterate over the second list and check if the permission exists in the map (first list)
	for _, perm := range list2 {
		if _, found := permissionsMap[perm]; found {
			// If found, add to the common permissions list
			common = append(common, perm)
		}
	}

	return common
}

// ---------------------------------------------------------------------------------	----------------------------------------------------------------

func (uc *permissionUseCase) processSectionForRole(ctx *gin.Context, permissionID int64, rolePermission sqlc.RolesPermission) *response.CustomSectionPermission {
	permission, err := uc.repo.GetPermission(ctx, permissionID)
	if err != nil {
		log.Println("[processSectionForRole GetPermission] err:", err)
		// return nil
	}

	section, err := uc.repo.GetSectionPermission(ctx, permission.SectionPermissionID)
	if err != nil {
		log.Println("[processSectionForRole GetSectionPermission] err:", err)
		// return nil
	}

	permissions, err := uc.repo.GetPermissionBySectionID(ctx, section.ID)
	if err != nil {
		log.Println("[GetPermissionBySectionID GetSectionPermission] err:", err)
		// return nil
	}

	var customPermissions []response.CustomAlllPermission
	for _, p := range permissions {
		if utils.ContainsInt(rolePermission.PermissionsID, p) {
			customPermission := uc.processPermissionForRole(ctx, p, rolePermission)
			// if len(customPermission.CustomAllSecondaryPermission) > 0 {
			customPermissions = append(customPermissions, customPermission)
			// }
		}
	}

	if len(customPermissions) == 0 {
		log.Println("[len 0] err:", err)
		return nil
	}

	return &response.CustomSectionPermission{
		ID:               section.ID,
		Label:            section.Title,
		SubLabel:         section.SubTitle.String,
		Indicator:        section.Indicator,
		CustomPermission: customPermissions,
	}
}

func (uc *permissionUseCase) processPermissionForRole(ctx *gin.Context, permissionID int64, rolePermission sqlc.RolesPermission) response.CustomAlllPermission {
	permission, err := uc.repo.GetPermission(ctx, permissionID)
	if err != nil {
		log.Println("[processPermissionForRole GetPermission] err:", err)
		// return response.CustomAlllPermission{}
	}

	subSections, err := uc.repo.GetAllSubSectionByPermissionID(ctx, permissionID)
	if err != nil {
		log.Println("[processPermissionForRole GetAllSubSectionByPermissionID] err:", err)
		// return response.CustomAlllPermission{}
	}

	var customSubSections []response.CustomSubSectionSecondaryPermission
	for _, ss := range subSections {
		if utils.ContainsInt(rolePermission.SubSectionPermission, ss.ID) {
			customSubSection := uc.processSubSectionForRole(ctx, ss, permissionID, rolePermission)
			// if len(customSubSection.CustomAllSubSectionPermission) > 0 {
			customSubSections = append(customSubSections, customSubSection)
			// }
		}
	}

	return response.CustomAlllPermission{
		ID:                           permission.ID,
		Label:                        permission.Title,
		SubLabel:                     permission.SubTitle.String,
		Indicator:                    permission.Indicator,
		CustomAllSecondaryPermission: customSubSections,
	}
}

func (uc *permissionUseCase) processSubSectionForRole(ctx *gin.Context, subSection sqlc.SubSection, permissionID int64, rolePermission sqlc.RolesPermission) response.CustomSubSectionSecondaryPermission {
	ternarySubSections, err := uc.repo.GetAllSubSectionPermissionBySubSectionButtonID(ctx, subSection.ID)
	if err != nil {
		log.Println("[processSubSectionForRole GetAllSubSectionPermissionBySubSectionButtonID] err:", err)
		// return response.CustomSubSectionSecondaryPermission{}
	}

	var customTernarySubSections []response.CustomAllSecondarySubSectionPermission
	for _, ts := range ternarySubSections {
		if utils.ContainsInt(rolePermission.SubSectionPermission, ts.ID) {
			customTernary := uc.processTernarySubSectionForRole(ctx, ts, permissionID, subSection.ID, rolePermission)
			// if len(customTernary.QuaternaryPermission) > 0 {
			customTernarySubSections = append(customTernarySubSections, customTernary)
			// }
		}
	}

	return response.CustomSubSectionSecondaryPermission{
		ID:                            subSection.ID,
		Label:                         subSection.SubSectionName,
		SubLabel:                      subSection.SubSectionNameConstant,
		Indicator:                     subSection.Indicator,
		PermissionID:                  subSection.PermissionsID,
		PrimaryID:                     permissionID,
		SubSectionButtonID:            subSection.SubSectionButtonID,
		SubSectionButtonAction:        subSection.SubSectionButtonAction,
		CustomAllSubSectionPermission: customTernarySubSections,
	}
}

func (uc *permissionUseCase) processTernarySubSectionForRole(ctx *gin.Context, ternary sqlc.SubSection, permissionID, subSectionID int64, rolePermission sqlc.RolesPermission) response.CustomAllSecondarySubSectionPermission {
	quaternarySubSections, err := uc.repo.GetAllSubSectionPermissionBySubSectionButtonID(ctx, ternary.ID)
	if err != nil {
		log.Println("[processTernarySubSectionForRole GetAllSubSectionPermissionBySubSectionButtonID] err:", err)
		// return response.CustomAllSecondarySubSectionPermission{}
	}

	var customQuaternarySubSections []response.CustomAllQuaternarySubSectionPermission
	for _, qs := range quaternarySubSections {
		if utils.ContainsInt(rolePermission.SubSectionPermission, qs.ID) {
			customQuaternary := uc.processQuaternarySubSectionForRole(ctx, qs, permissionID, subSectionID, ternary.ID, rolePermission)
			// if len(customQuaternary.QuinaryPermission) > 0 {
			customQuaternarySubSections = append(customQuaternarySubSections, customQuaternary)
			// }
		}
	}

	return response.CustomAllSecondarySubSectionPermission{
		ID:                     ternary.ID,
		Label:                  ternary.SubSectionName,
		SubLabel:               ternary.SubSectionNameConstant,
		Indicator:              ternary.Indicator,
		PermissionID:           ternary.PermissionsID,
		PrimaryID:              permissionID,
		SecondaryID:            subSectionID,
		SubSectionButtonID:     ternary.SubSectionButtonID,
		SubSectionButtonAction: ternary.SubSectionButtonAction,
		QuaternaryPermission:   customQuaternarySubSections,
	}
}

func (uc *permissionUseCase) processQuaternarySubSectionForRole(ctx *gin.Context, quaternary sqlc.SubSection, permissionID, subSectionID, ternaryID int64, rolePermission sqlc.RolesPermission) response.CustomAllQuaternarySubSectionPermission {
	quinarySubSections, err := uc.repo.GetAllSubSectionPermissionBySubSectionButtonID(ctx, quaternary.ID)
	if err != nil {
		log.Println("[processQuaternarySubSectionForRole GetAllSubSectionPermissionBySubSectionButtonID] err:", err)
		// return response.CustomAllQuaternarySubSectionPermission{}
	}

	var customQuinarySubSections []response.CustomAllQuinarySubSectionPermission
	for _, qs := range quinarySubSections {
		if utils.ContainsInt(rolePermission.SubSectionPermission, qs.ID) {
			customQuinary := response.CustomAllQuinarySubSectionPermission{
				ID:                     qs.ID,
				Label:                  qs.SubSectionName,
				SubLabel:               qs.SubSectionNameConstant,
				Indicator:              qs.Indicator,
				PermissionID:           qs.PermissionsID,
				PrimaryID:              permissionID,
				SecondaryID:            subSectionID,
				TernaryID:              ternaryID,
				QuaternaryID:           quaternary.ID,
				SubSectionButtonID:     qs.SubSectionButtonID,
				SubSectionButtonAction: qs.SubSectionButtonAction,
			}
			customQuinarySubSections = append(customQuinarySubSections, customQuinary)
		}
	}

	return response.CustomAllQuaternarySubSectionPermission{
		ID:                     quaternary.ID,
		Label:                  quaternary.SubSectionName,
		SubLabel:               quaternary.SubSectionNameConstant,
		Indicator:              quaternary.Indicator,
		PermissionID:           quaternary.PermissionsID,
		PrimaryID:              permissionID,
		SecondaryID:            subSectionID,
		TernaryID:              ternaryID,
		SubSectionButtonID:     quaternary.SubSectionButtonID,
		SubSectionButtonAction: quaternary.SubSectionButtonAction,
		QuinaryPermission:      customQuinarySubSections,
	}
}

func (uc *permissionUseCase) CachePermissions(ctx context.Context) (string, *exceptions.Exception) {
	var userPermission []int64

	// Get all sections and cache them
	sections, er := uc.repo.GetAllSectionPermissionFromPermissionIDs(ctx, 0, userPermission)
	if er != nil {
		return "error", er
	}

	permissions, err := uc.repo.GetAllPermissionsNoPagination(ctx)
	if err != nil {
		log.Println("[processSection.permissions] err:", err)
	}

	subSectionPermissions, errs := uc.repo.GetAllSubSectionPermissionsNoPagination(ctx)
	if errs != nil {
		log.Println("[processSection.subSectionPermissions] err:", errs)
	}

	errCache := utils.CachePermissions(ctx, sections, permissions, subSectionPermissions)
	if errCache != true {
		log.Println("error setting cache in Redis for permissions:", errCache)
		return "error", nil
	}

	return "success", nil
}

func (uc *permissionUseCase) CachePurgeAll(ctx context.Context) (string, *exceptions.Exception) {
	errCache := utils.CachePurgeAll(ctx)
	if errCache != true {
		log.Println("error setting cache in Redis for permissions:", errCache)
		return "error", nil
	}

	return "success", nil
}
