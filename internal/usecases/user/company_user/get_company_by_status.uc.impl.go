package companyuser_usecase

import (
	"aqary_admin/internal/delivery/redis"
	"aqary_admin/internal/delivery/rest/middleware"
	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	permissions_usecase "aqary_admin/internal/usecases/user/permissions"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/constants"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/security"
	"encoding/json"
	"fmt"
	"log"
	"strconv"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"go.uber.org/zap"
)

func (uc *companyUserUseCase) GetCompanyUsersByStatus(c *gin.Context, req domain.GetUsersByStatusReq) ([]response.GetUsersByStatusResponse, int64, *exceptions.Exception) {

	payload := c.MustGet(middleware.AuthorizationPayloadKey).((*security.Payload))
	visitedUser, err := uc.repo.GetUserByName(c, payload.Username)
	if err != nil {
		return nil, 0, err
	}
	users, err := uc.repo.GetAllCompanyUsersByStatus(c, sqlc.GetAllCompanyUsersByStatusParams{
		Limit:     req.PageSize,
		Offset:    (req.PageNo - 1) * req.PageSize,
		Status:    req.Status,
		CompanyID: visitedUser.ActiveCompany.Int64,
		Search:    utils.AddPercent(req.Search),
	})
	log.Println("testing err first", err)
	if err != nil {
		return nil, 0, err
	}

	var output []response.GetUsersByStatusResponse
	for _, user := range users {

		output = append(output, response.GetUsersByStatusResponse{
			ID:          user.UsersID,
			CompanyName: user.CompanyName,
			AgentName:   user.FirstName.String + " " + user.LastName.String,
			Phone:       user.PhoneNumber.String,
			Email:       user.Email.String,
			// Designation:  user.Designation,
			UserType:     constants.UserTypes.ConstantName(user.UserTypesID.Int64),
			ProfileImage: user.ProfileImageUrl.String,
		})
	}

	totalCount, err := uc.repo.CountAllCompanyUsersByStatus(c, sqlc.CountAllCompanyUsersByStatusParams{
		Status:    req.Status,
		CompanyID: visitedUser.ActiveCompany.Int64,
		Search:    utils.AddPercent(req.Search),
	})
	log.Println("testing err", err)
	if err != nil {
		return nil, 0, err
	}

	if len(output) == 0 {
		return nil, 0, exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode)
	}

	return output, totalCount, nil
}

func (uc *companyUserUseCase) UpdateUserVerification(c *gin.Context, req domain.UpdateUserVerificationReq) (*sqlc.User, *exceptions.Exception) {

	user, err := uc.repo.GetUserRegardlessOfStatus(c, req.UserID)
	if err != nil {
		log.Println("testing err user ", err, "::", req.UserID)
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(err.ErrorCode, fmt.Errorf("error while getting user:%v", err).Error())
	}

	updatedUser, err := uc.repo.UpdateUserVerification(c, sqlc.VerifyUserParams{
		ID: user.ID,
		IsVerified: pgtype.Bool{
			Bool:  req.IsVerfied,
			Valid: true,
		},
	})

	if err != nil {
		log.Println("testing err update user  ", err, "::", req.UserID)
		return nil, err
	}

	return updatedUser, nil
}

func (uc *companyUserUseCase) GetCompanyUserPermission(c *gin.Context, req domain.Request) (any, *exceptions.Exception) {
	var allSections []response.CustomSectionPermission
	userPerm, _ := uc.store.GetUserPermissionsByID(c, sqlc.GetUserPermissionsByIDParams{
		IsCompanyUser: req.CompanyID,
		CompanyID: pgtype.Int8{
			Int64: req.CompanyID,
			Valid: req.CompanyID != 0,
		},
		UserID: req.UserID,
	})

	userIdString := strconv.FormatInt(req.UserID, 10)

	redisClient, er := redis.NewRedisClient()
	if er != nil {
		log.Fatal("Failed to connect", zap.Error(er))
	}
	defer redisClient.Close()

	// check in chache and return the response if exists
	cachePermissions, er := redisClient.GetJSONFromFolder(c, "AllCompanyPermissions", userIdString)
	if er != nil {
		log.Println("no data in cache")
	}

	if cachePermissions != nil {
		json.Unmarshal(cachePermissions, &allSections)
		if len(allSections) > 0 {
			return allSections, nil
		}
	}

	sectionsPermission := sqlc.SectionPermissionMv{}
	var sectionsPermissionList []sqlc.SectionPermissionMv

	// var userSectionIds []int64
	// get section ids in array from permission cache by getting permission cache with key
	type sectionPermission struct {
		ID                  int64 `json:"id"`
		SectionPermissionId int64 `json:"section_permission_id"`
	}

	spermission := sectionPermission{}

	var sectionIds []int64

	for _, value := range userPerm.PermissionsID {

		cachePermission, _ := redisClient.GetJSONFromFolder(c, "permissions", fmt.Sprintf("%v", value))
		if len(cachePermission) == 0 {
			continue
		}

		json.Unmarshal(cachePermission, &spermission)

		if utils.Contains(sectionIds, spermission.SectionPermissionId) {
			continue
		}

		sectionIds = append(sectionIds, spermission.SectionPermissionId)

		sectionPermission, _ := redisClient.GetJSONFromFolder(c, "sectionPermissions", fmt.Sprintf("%v", spermission.SectionPermissionId))
		if len(sectionPermission) == 0 {
			continue
		}
		json.Unmarshal(sectionPermission, &sectionsPermission)

		sectionsPermissionList = append(sectionsPermissionList, sectionsPermission)

	}

	// it will fetch all section in case of super admin else fetch only assign one
	// userId := utils.Ternary[int64](visitedUser.UserTypesID == constants.SuperAdminUserTypes.Int64(), 0, visitedUser.ID)

	if len(sectionsPermissionList) == 0 {
		sections, er := uc.repo.GetAllSectionPermissionFromPermissionIDs(c, req.UserID, userPerm.PermissionsID)
		if er != nil {
			return nil, er
		}
		sectionsPermissionList = sections
	}

	var wg sync.WaitGroup
	sectionChan := make(chan response.CustomSectionPermission, len(sectionsPermissionList))

	for _, section := range sectionsPermissionList {
		wg.Add(1)
		go func(s sqlc.SectionPermissionMv) {
			defer wg.Done()
			customSection := permissions_usecase.ProcessSection(c, uc.repo, section, req.UserID, userPerm.PermissionsID, userPerm.SubSectionsID, false, redisClient) // false: to expend to till end
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
		errr := redisClient.SetJSONInFolder(c, "AllCompanyPermissions", userIdString, dataToCache, 200*time.Hour)

		if errr != nil {
			fmt.Println(errr, "failed to set in cache")
		}
	}

	return allSections, nil
}
