package db

import (
	"errors"
	"fmt"
	"log"

	"aqary_admin/internal/delivery/rest/middleware"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils/exceptions"
	repoerror "aqary_admin/pkg/utils/repo_error"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
)

type CheckEmailRepo interface {
	GetUserByEmail(ctx *gin.Context, email string) (sqlc.User, *exceptions.Exception)
	GetUserByName(ctx *gin.Context, username string) (sqlc.User, *exceptions.Exception)
	GetUserByPhoneVerified(ctx *gin.Context, arg sqlc.GetUserByPhoneVerifiedParams) (sqlc.User, *exceptions.Exception)
	GetUserByEmailRegardlessSuperAdmin(ctx *gin.Context, arg sqlc.GetUserByEmailRegardlessParams) (sqlc.PlatformUser, *exceptions.Exception)
	GetPlatformUserByEmail(ctx *gin.Context, email string) (sqlc.PlatformUser, *exceptions.Exception)
	GetPlatformUserByEmailAndCompanyID(ctx *gin.Context, arg sqlc.GetPlatformUserByEmailAndCompanyIDParams) (sqlc.PlatformUser, *exceptions.Exception)
}

type checkEmailRepository struct {
	querier sqlc.Querier
}

func (r *checkEmailRepository) GetPlatformUserByEmailAndCompanyID(ctx *gin.Context, arg sqlc.GetPlatformUserByEmailAndCompanyIDParams) (sqlc.PlatformUser, *exceptions.Exception) {

	user, err := r.querier.GetPlatformUserByEmailAndCompanyID(ctx, arg)

	if err != nil {
		return sqlc.PlatformUser{}, buildCheckEmailErr("GetPlatformUserByEmailAndCompanyID", err)
	}

	return user, nil
}

// GetUserByEmailRegardlessSuperAdmin implements CheckEmailRepo.
func (r *checkEmailRepository) GetUserByEmailRegardlessSuperAdmin(ctx *gin.Context, arg sqlc.GetUserByEmailRegardlessParams) (sqlc.PlatformUser, *exceptions.Exception) {

	user, err := r.querier.GetUserByEmailRegardless(ctx, arg)
	if err != nil {
		return sqlc.PlatformUser{}, buildCheckEmailErr("GetUserByEmailRegardlessSuperAdmin", err)
	}
	return user, nil
}

func NewCheckEmailRepository(querier sqlc.Querier) CheckEmailRepo {
	return &checkEmailRepository{
		querier: querier,
	}
}

func (r *checkEmailRepository) GetUserByEmail(ctx *gin.Context, email string) (sqlc.User, *exceptions.Exception) {
	user, err := r.querier.GetUserByEmail(ctx, email)
	if err != nil {
		return sqlc.User{}, buildCheckEmailErr("GetUserByEmail", err)
	}
	return user, nil
}

func (r *checkEmailRepository) GetUserByPhoneVerified(ctx *gin.Context, arg sqlc.GetUserByPhoneVerifiedParams) (sqlc.User, *exceptions.Exception) {

	user, err := r.querier.GetUserByPhoneVerified(ctx, arg)
	if err != nil {
		return sqlc.User{}, buildCheckEmailErr("GetUserByPhoneVerified", err)
	}
	return user, nil
}

func (r *checkEmailRepository) GetUserByName(ctx *gin.Context, username string) (sqlc.User, *exceptions.Exception) {
	user, err := r.querier.GetUserByName(ctx, username)
	log.Println("testing error ", err, ":::", user)
	if err != nil {
		return sqlc.User{}, repoerror.BuildRepoErr("CheckEmailRepo", "GetUserByName", err)
	}
	return user, nil
}

func (r *checkEmailRepository) GetPlatformUserByEmail(ctx *gin.Context, email string) (sqlc.PlatformUser, *exceptions.Exception) {
	user, err := r.querier.GetPlatformUserByEmail(ctx, email)
	if err != nil {
		return sqlc.PlatformUser{}, buildCheckEmailErr("GetPlatformUserByEmail", err)
	}
	return user, nil
}

func buildCheckEmailErr(name string, err error) *exceptions.Exception {
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			log.Printf("[check_email.repo.%v] error:%v", name, err)
			return exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode)
		}
		middleware.IncrementServerErrorCounter(fmt.Errorf("[check_email.repo.%v] error:%v", name, err).Error())
		return exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}
	return nil
}
