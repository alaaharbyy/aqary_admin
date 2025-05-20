package companyuser_usecase

import (
	"encoding/json"
	"fmt"
	"log"
	"strconv"

	"aqary_admin/internal/delivery/rest/middleware"
	domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"

	// db "aqary_admin/pkg/db/user/company_user"

	db "aqary_admin/pkg/db/user"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/constants"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/fn"
	"aqary_admin/pkg/utils/security"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
)

type companyUserUseCase struct {
	repo  db.UserCompositeRepo
	store sqlc.Store
	pool  *pgxpool.Pool
}

// GetCompanyRemainingPackage implements CompanyUserUseCase.
func (uc *companyUserUseCase) GetCompanyRemainingPackage(c *gin.Context, req domain.GetCompanyRemainingPackageReq) (any, *exceptions.Exception) {
	authPayload, ok := c.MustGet(middleware.AuthorizationPayloadKey).(*security.Payload)
	if !ok {
		log.Println("testing auth payload not ok")
	}

	visitedUser, err := uc.repo.GetUserByName(c, authPayload.Username)
	if err != nil {
		return nil, err
	}

	var companyId int64
	if visitedUser.UserTypesID == constants.SuperAdminUserTypes.Int64() {
		if req.CompanyId == 0 {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.BadRequestErrorCode, "company_id is required")
		}

		companyId = req.CompanyId
	} else {
		companyId = visitedUser.ActiveCompany.Int64
	}

	result, err := uc.repo.GetRemainingCreditToAssignAgentByCompany(c, companyId)
	if err != nil {
		return nil, err
	}

	if len(result) == 0 {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.NoDataFoundErrorCode, "no data found")
	}

	return result, nil

}

// UpdateActiveCompany implements CompanyUserUseCase.
func (uc *companyUserUseCase) UpdateActiveCompany(c *gin.Context, req domain.UpdateActiveCompanyReq) (*string, *exceptions.Exception) {
	var status exceptions.ErrorCode

	authPayload, ok := c.MustGet(middleware.AuthorizationPayloadKey).(*security.Payload)
	if !ok {
		log.Println("testing auth payload not ok")
	}
	visitedUser, err := uc.repo.GetUserByName(c, authPayload.Username)
	if err != nil {
		log.Println("testing auth payload  not ok err ", err)
		return nil, err
	}

	trxErr := sqlc.ExecuteTx(c, uc.pool, func(q *sqlc.Queries) error {
		_, err := uc.repo.UpdateActiveCompany(c, sqlc.UpdateActiveCompanyParams{
			ID:            visitedUser.ID,
			ActiveCompany: pgtype.Int8{Int64: req.ActiveCompany, Valid: req.ActiveCompany != 0},
		}, q)
		if err != nil {
			status = err.ErrorCode
			return err
		}
		return nil
	})

	if trxErr != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(status, trxErr.Error())
	}

	successMsg := "Successfully updated!"
	return &successMsg, nil
}

func NewCompanyUserUseCase(repo db.UserCompositeRepo, store sqlc.Store, pool *pgxpool.Pool) CompanyUserUseCase {
	return &companyUserUseCase{
		repo:  repo,
		store: store,
		pool:  pool,
	}
}

func (uc *companyUserUseCase) GrandPermissionToCompanyAdmin(c *gin.Context, req domain.Request) (*sqlc.UserCompanyPermission, *exceptions.Exception) {

	userPerm, _ := uc.store.GetUserPermissionsByID(c, sqlc.GetUserPermissionsByIDParams{
		IsCompanyUser: req.CompanyID,
		CompanyID: pgtype.Int8{
			Int64: req.CompanyID,
			Valid: req.CompanyID != 0,
		},
		UserID: req.UserID,
	})

	// now collecting internal button permission for each

	var perm []domain.PermissionButton
	var uniquePermissionList []int64
	var uniqueSubSectionList []int64

	if req.Permissions != "" {
		jsonErr := json.Unmarshal([]byte(req.Permissions), &perm)
		if jsonErr != nil {
			fmt.Println("Error unmarshaling JSON:", jsonErr)
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, jsonErr.Error())
		}
	}

	for _, p := range perm {
		if p.ButtonID != 0 {
			uniqueSubSectionList = append(uniqueSubSectionList, int64(p.ID))
			if p.PermissionID != 0 {
				uniquePermissionList = append(uniquePermissionList, int64(p.PermissionID)) // permissons
			}
			if p.SecondaryID != 0 {
				uniqueSubSectionList = append(uniqueSubSectionList, int64(p.SecondaryID)) // permissons
			}

			if p.TertiaryID != 0 {
				uniqueSubSectionList = append(uniqueSubSectionList, int64(p.TertiaryID)) // permissons
			}

			if p.QuaternaryID != 0 {
				uniqueSubSectionList = append(uniqueSubSectionList, int64(p.QuaternaryID)) // permissons
			}
		} else {
			uniquePermissionList = append(uniquePermissionList, int64(p.ID)) // permissons
			if p.PermissionID != 0 {
				uniquePermissionList = append(uniquePermissionList, int64(p.PermissionID)) // permissons
			}
			if p.SecondaryID != 0 {
				uniqueSubSectionList = append(uniqueSubSectionList, int64(p.SecondaryID)) // permissons
			}

			if p.TertiaryID != 0 {
				uniqueSubSectionList = append(uniqueSubSectionList, int64(p.TertiaryID)) // permissons
			}

			if p.QuaternaryID != 0 {
				uniqueSubSectionList = append(uniqueSubSectionList, int64(p.QuaternaryID)) // permissons
			}
		}
	}

	var userPermissions sqlc.UserCompanyPermission
	var err error
	if userPerm.ID == 0 {
		userPermissions, err = uc.store.CreateUserPermission(c, sqlc.CreateUserPermissionParams{
			UserID: req.UserID,
			CompanyID: pgtype.Int8{
				Int64: req.CompanyID,
				Valid: req.CompanyID != 0,
			},
			PermissionsID: uniquePermissionList,
			SubSectionsID: uniqueSubSectionList,
		})
		if err != nil {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}
	} else {
		userPermissions, err = uc.store.UpdateUserPermissionsByID(c, sqlc.UpdateUserPermissionsByIDParams{
			PermissionID: uniquePermissionList,
			SubSectionID: uniqueSubSectionList,
			IsCompany:    req.CompanyID,
			CompanyID: pgtype.Int8{
				Int64: req.CompanyID,
				Valid: req.CompanyID != 0,
			},
			UserID: req.UserID,
		})
		if err != nil {
			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
		}
	}

	// remove data for the user permission from cache so it will get the updated permissions always
	utils.DeleteJSONFromFolder(c, "AllCompanyPermissions", strconv.FormatInt(req.UserID, 10))

	return &userPermissions, nil
}

// func (uc *companyUserUseCase) GetCurrentSubscriptionQuota(c *gin.Context, req domain.GetSingleUserReq) (any, *exceptions.Exception) {

// var companyId int64

// authPayload, ok := c.MustGet("authorization_payload").(*security.Payload)
// if !ok {
// 	log.Println("testing auth payload not ok")
// 	// return nil, exceptions.GetExceptionByErrorCode(exce)
// }
// visitedUser, err := uc.repo.GetUserByName(c, authPayload.Username)
// if err != nil {
// 	log.Println("testing auth payload  not ok err ", err)
// 	return nil, err
// }

// if req.CompanyID != 0 {
// 	companyId = req.CompanyID
// } else {
// 	// get the company id
// 	if visitedUser.UserTypesID != 1 { // then it has to be the company user
// 		// get the company id from
// 		companyVisitedUser, err := uc.store.GetCompanyUserByUserId(c, sqlc.GetCompanyUserByUserIdParams{
// 			CompanyID: req.CompanyID,
// 			UserID:    visitedUser.ID,
// 		})
// 		if err != nil {
// 			log.Println("error while getting company visited User:::11", err)
// 			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
// 		}
// 		companyId = companyVisitedUser.CompanyID

// 	} else {
// 		// then what
// 		companyVisitedUser, err := uc.store.GetSingleCompanyByUserId(c, visitedUser.ID)
// 		if err != nil {
// 			log.Println("error while getting company visited User:::", err)
// 			return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, err.Error())
// 		}
// 		companyId = companyVisitedUser.ID
// 	}

// }

// //  get the sub
// sub, er := uc.repo.GetCurrentSubscriptionQuota(c, companyId)

// if er != nil {
// 	return nil, er
// }
// return sub, nil
// }

func (uc *companyUserUseCase) GetUserTypeForCompanyUserPage(c *gin.Context) (any, *exceptions.Exception) {

	authPayload, ok := c.MustGet("authorization_payload").(*security.Payload)
	if !ok {
		log.Println("testing auth payload not ok")
		// handle error appropriately, e.g., return an exception
	}

	visitedUser, err := uc.repo.GetUserByName(c, authPayload.Username)
	if err != nil {
		log.Println("testing auth payload not ok err ", err)
		return nil, err
	}

	if visitedUser.UserTypesID == 6 {
		return &[]fn.CustomFormat{
			{
				ID:   constants.FreelancerUserTypes.Int64(),
				Name: constants.UserTypes.ConstantName(constants.FreelancerUserTypes.Int64()),
			},
			{
				ID:   constants.OwnerOrIndividualUserTypes.Int64(),
				Name: constants.UserTypes.ConstantName(constants.OwnerOrIndividualUserTypes.Int64()),
			},
		}, nil
	}

	return &[]fn.CustomFormat{
		{
			ID:   constants.CompanyAdminUserTypes.Int64(),
			Name: constants.UserTypes.ConstantName(constants.CompanyAdminUserTypes.Int64()),
		},
		{
			ID:   constants.AgentUserTypes.Int64(),
			Name: constants.UserTypes.ConstantName(constants.AgentUserTypes.Int64()),
		},
		{
			ID:   constants.CompanyUserUserTypes.Int64(),
			Name: constants.UserTypes.ConstantName(constants.AgentUserTypes.Int64()),
		},
	}, nil
}

func (uc *companyUserUseCase) GetVerifyContants(c *gin.Context) any {
	return []map[string]interface{}{
		{
			"label": "Verified",
			"value": true,
		},
		{
			"label": "Un Verified",
			"value": false,
		},
	}
}
