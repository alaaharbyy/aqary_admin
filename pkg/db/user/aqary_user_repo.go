package db

import (
	"errors"
	"fmt"
	"log"

	"aqary_admin/internal/delivery/rest/middleware"
	"aqary_admin/internal/domain/sqlc/sqlc"
	auth_utils "aqary_admin/pkg/utils/auth"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
)

type AqaryUserRepo interface {
	GetAqaryUser(ctx *gin.Context, id int64) (*sqlc.GetUserRegardlessOfStatusRow, *exceptions.Exception)
	GetAllAqaryUser(ctx *gin.Context, arg sqlc.GetAllAqaryUserParams) ([]sqlc.GetAllAqaryUserRow, *exceptions.Exception)
	GetCountAllAqaryUser(ctx *gin.Context, search string) (int64, *exceptions.Exception)
	GetAllAqaryUsersByCountryId(ctx *gin.Context, arg sqlc.GetAllAqaryUsersByCountryIdParams) ([]sqlc.GetAllAqaryUsersByCountryIdRow, *exceptions.Exception)
	GetCountAllAqaryUserByCountry(ctx *gin.Context, countryID int64) (int64, *exceptions.Exception)
	// UpdateUserStatus(ctx *gin.Context, arg sqlc.UpdateUserStatusParams) (*sqlc.User, *exceptions.Exception)
	GetAqaryDeletedUser(ctx *gin.Context, id int64) (*sqlc.User, *exceptions.Exception)
	GetAllAqaryDeletedUser(ctx *gin.Context, arg sqlc.GetAllAqaryDeletedUserParams) ([]sqlc.GetAllAqaryDeletedUserRow, *exceptions.Exception)
	GetCountAllAqaryDeletedUser(ctx *gin.Context, search string) (int64, *exceptions.Exception)
	GetAllAqaryDeletedUserWithoutPagination(ctx *gin.Context) ([]sqlc.User, *exceptions.Exception)
	UpdateUser(ctx *gin.Context, arg sqlc.UpdateUserParams, q sqlc.Querier) (*sqlc.User, *exceptions.Exception)
	// UpdateUserStatus(ctx *gin.Context, arg domain.UserUpdateStatusReq) (*sqlc.User, *exceptions.Exception)
	UpdateAddress(ctx *gin.Context, arg sqlc.UpdateAddressParams) (*sqlc.Address, *exceptions.Exception)

	GetAllRelatedIDFromSubSection(ctx *gin.Context, id int64) ([]int64, *exceptions.Exception)
	GetSubSection(ctx *gin.Context, id int64) (*sqlc.SubSection, *exceptions.Exception)
	GetSectionPermission(c *gin.Context, id int64) (sqlc.SectionPermission, *exceptions.Exception)
	GetPermissionByIdAndSectionPermissionId(c *gin.Context, args sqlc.GetPermissionByIdAndSectionPermissionIdParams) (sqlc.Permission, *exceptions.Exception)
}

type aqaryUserRepository struct {
	querier sqlc.Querier
}

// GetPermission implements AqaryUserRepo.
func (r *aqaryUserRepository) GetPermission(c *gin.Context, id int64) (sqlc.Permission, *exceptions.Exception) {
	permission, err := r.querier.GetPermission(c, id)
	if err != nil {
		return sqlc.Permission{}, buildAqaryUserErr("GetPermission", err)
	}
	return permission, nil
}

// GetPermissionByIdAndSectionPermissionId implements AqaryUserRepo.
func (r *aqaryUserRepository) GetPermissionByIdAndSectionPermissionId(c *gin.Context, args sqlc.GetPermissionByIdAndSectionPermissionIdParams) (sqlc.Permission, *exceptions.Exception) {
	permission, err := r.querier.GetPermissionByIdAndSectionPermissionId(c, args)
	if err != nil {
		return sqlc.Permission{}, buildAqaryUserErr("GetPermission", err)
	}
	return permission, nil
}

// GetSectionPermission implements AqaryUserRepo.
func (r *aqaryUserRepository) GetSectionPermission(c *gin.Context, id int64) (sqlc.SectionPermission, *exceptions.Exception) {
	sectionPermission, err := r.querier.GetSectionPermission(c, id)
	if err != nil {
		return sqlc.SectionPermission{}, buildAqaryUserErr("GetPermission", err)
	}
	return sectionPermission, nil
}

func (r *aqaryUserRepository) GetAqaryUser(ctx *gin.Context, id int64) (*sqlc.GetUserRegardlessOfStatusRow, *exceptions.Exception) {
	user, err := r.querier.GetUserRegardlessOfStatus(ctx, id)
	if err != nil {
		return nil, buildAqaryUserErr("GetAqaryUser", err)
	}
	return &user, nil
}

func (r *aqaryUserRepository) GetAllAqaryUser(ctx *gin.Context, arg sqlc.GetAllAqaryUserParams) ([]sqlc.GetAllAqaryUserRow, *exceptions.Exception) {
	users, err := r.querier.GetAllAqaryUser(ctx, arg)
	log.Println("testing get all aqary user ", arg, ":::", err)
	if err != nil {
		return nil, buildAqaryUserErr("GetAllAqaryUser", err)
	}
	return users, nil
}

func (r *aqaryUserRepository) GetCountAllAqaryUser(ctx *gin.Context, search string) (int64, *exceptions.Exception) {
	count, err := r.querier.GetCountAllAqaryUser(ctx, search)
	if err != nil {
		return 0, buildAqaryUserErr("GetCountAllAqaryUser", err)
	}
	return count, nil
}

func (r *aqaryUserRepository) GetAllAqaryUsersByCountryId(ctx *gin.Context, arg sqlc.GetAllAqaryUsersByCountryIdParams) ([]sqlc.GetAllAqaryUsersByCountryIdRow, *exceptions.Exception) {
	users, err := r.querier.GetAllAqaryUsersByCountryId(ctx, arg)
	if err != nil {
		return nil, buildAqaryUserErr("GetAllAqaryUsersByCountryId", err)
	}
	return users, nil
}

func (r *aqaryUserRepository) GetCountAllAqaryUserByCountry(ctx *gin.Context, countryID int64) (int64, *exceptions.Exception) {
	count, err := r.querier.GetCountAllAqaryUserByCountry(ctx, countryID)
	if err != nil {
		return 0, buildAqaryUserErr("GetCountAllAqaryUserByCountry", err)
	}
	return count, nil
}

func (r *aqaryUserRepository) GetAqaryDeletedUser(ctx *gin.Context, id int64) (*sqlc.User, *exceptions.Exception) {
	user, err := r.querier.GetAqaryDeletedUser(ctx, id)
	if err != nil {
		return nil, buildAqaryUserErr("GetAqaryDeletedUser", err)
	}
	return &user, nil
}

func (r *aqaryUserRepository) GetAllAqaryDeletedUser(ctx *gin.Context, arg sqlc.GetAllAqaryDeletedUserParams) ([]sqlc.GetAllAqaryDeletedUserRow, *exceptions.Exception) {
	users, err := r.querier.GetAllAqaryDeletedUser(ctx, arg)
	log.Println("testing users ", users, "::", arg, ":::", err)
	if err != nil {
		return nil, buildAqaryUserErr("GetAllAqaryDeletedUser", err)
	}
	return users, nil
}

func (r *aqaryUserRepository) GetCountAllAqaryDeletedUser(ctx *gin.Context, search string) (int64, *exceptions.Exception) {
	count, err := r.querier.GetCountAllAqaryDeletedUser(ctx, search)
	if err != nil {
		return 0, buildAqaryUserErr("GetCountAllAqaryDeletedUser", err)
	}
	return count, nil
}

func (r *aqaryUserRepository) GetAllAqaryDeletedUserWithoutPagination(ctx *gin.Context) ([]sqlc.User, *exceptions.Exception) {
	users, err := r.querier.GetAllAqaryDeletedUserWithoutPagination(ctx)
	if err != nil {
		return nil, buildAqaryUserErr("GetAllAqaryDeletedUserWithoutPagination", err)
	}
	return users, nil
}

func (r *aqaryUserRepository) UpdateUser(ctx *gin.Context, arg sqlc.UpdateUserParams, q sqlc.Querier) (*sqlc.User, *exceptions.Exception) {
	if q == nil {
		q = r.querier
	}
	r.querier, q = auth_utils.CheckAuthForTests(ctx, r.querier, q)
	user, err := q.UpdateUser(ctx, arg)
	if err != nil {
		return nil, buildAqaryUserErr("UpdateUser", err)
	}
	return &user, nil
}

func (r *aqaryUserRepository) UpdateAddress(ctx *gin.Context, arg sqlc.UpdateAddressParams) (*sqlc.Address, *exceptions.Exception) {
	address, err := r.querier.UpdateAddress(ctx, arg)
	if err != nil {
		return nil, buildAqaryUserErr("UpdateAddress", err)
	}
	return &address, nil
}

func (r *aqaryUserRepository) GetAllRelatedIDFromSubSection(ctx *gin.Context, id int64) ([]int64, *exceptions.Exception) {
	relatedIDs, err := r.querier.GetAllRelatedIDFromSubSection(ctx, id)
	if err != nil {
		return nil, buildAqaryUserErr("GetAllRelatedIDFromSubSection", err)
	}
	return relatedIDs, nil
}

func (r *aqaryUserRepository) GetSubSection(ctx *gin.Context, id int64) (*sqlc.SubSection, *exceptions.Exception) {
	subSection, err := r.querier.GetSubSection(ctx, id)
	if err != nil {
		return nil, buildAqaryUserErr("GetSubSection", err)
	}
	return &subSection, nil
}

func NewAqaryUserRepository(querier sqlc.Querier) AqaryUserRepo {
	return &aqaryUserRepository{
		querier: querier,
	}
}

func buildAqaryUserErr(name string, err error) *exceptions.Exception {
	if err != nil {
		log.Printf("[aqary_user.repo.%v] error:%v", name, err)
		if errors.Is(err, pgx.ErrNoRows) {
			log.Printf("[aqary_user.repo.%v] error:%v", name, err)
			return exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode)
		}
		middleware.IncrementServerErrorCounter(fmt.Errorf("[aqary_user.repo.%v] error:%v", name, err).Error())
		return exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}
	return nil
}
