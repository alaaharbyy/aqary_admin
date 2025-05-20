package usecase

import (
	"strings"

	db "aqary_admin/pkg/db/user"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/security"

	Domain "aqary_admin/internal/domain/requests/user"
	"aqary_admin/internal/domain/sqlc/sqlc"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
)

type CheckEmailUseCase interface {
	CheckEmail(ctx *gin.Context, email string) (bool, *exceptions.Exception)
	CheckUsername(ctx *gin.Context, username string) (bool, *exceptions.Exception)
	CheckPhone(ctx *gin.Context, req Domain.CheckMobileRequest) (bool, *exceptions.Exception)
}

type checkEmailUseCase struct {
	repo       db.CheckEmailRepo
	pool       *pgxpool.Pool
	tokenMaker security.Maker
}

func NewCheckEmailUseCase(repo db.CheckEmailRepo, pool *pgxpool.Pool, token security.Maker) CheckEmailUseCase {
	return &checkEmailUseCase{
		repo:       repo,
		pool:       pool,
		tokenMaker: token,
	}
}
func (uc *checkEmailUseCase) CheckEmail(ctx *gin.Context, email string) (bool, *exceptions.Exception) {
	user, err := uc.repo.GetUserByEmail(ctx, email)
	if err != nil {
		return false, err
	}

	return strings.EqualFold(user.Email, email), nil
}

func (uc *checkEmailUseCase) CheckUsername(ctx *gin.Context, username string) (bool, *exceptions.Exception) {
	user, err := uc.repo.GetUserByName(ctx, username)
	if err != nil {
		return false, err
	}

	return strings.EqualFold(user.Username, username), nil
}

func (uc *checkEmailUseCase) CheckPhone(ctx *gin.Context, req Domain.CheckMobileRequest) (bool, *exceptions.Exception) {

	user, err := uc.repo.GetUserByPhoneVerified(ctx, sqlc.GetUserByPhoneVerifiedParams{
		PhoneNumber: pgtype.Text{String: req.Phone, Valid: true},
		CountryCode: pgtype.Int8{Int64: req.CountryCode, Valid: true},
	})
	if err != nil {
		return false, err
	}

	return strings.EqualFold(user.PhoneNumber.String, req.Phone), nil
}
