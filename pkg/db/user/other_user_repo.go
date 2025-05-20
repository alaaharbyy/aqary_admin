package db

import (
	"context"

	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils/exceptions"
	repoerror "aqary_admin/pkg/utils/repo_error"
)

type OtherUserRepo interface {
	GetAllOtherUser(ctx context.Context, args sqlc.GetAllOtherUserParams) ([]sqlc.User, *exceptions.Exception)
	GetCountAllOtherUser(ctx context.Context) (int64, *exceptions.Exception)
	GetAllOtherUsersByCountryId(ctx context.Context, args sqlc.GetAllOtherUsersByCountryIdParams) ([]sqlc.GetAllOtherUsersByCountryIdRow, *exceptions.Exception)
	GetCountAllOtherUserByCountry(ctx context.Context, countryID int64) (int64, *exceptions.Exception)
}

type otherUserRepository struct {
	querier sqlc.Querier
}

func NewOtherotherUserRepository(querier sqlc.Querier) OtherUserRepo {
	return &otherUserRepository{
		querier: querier,
	}
}

func (r *otherUserRepository) GetAllOtherUser(ctx context.Context, args sqlc.GetAllOtherUserParams) ([]sqlc.User, *exceptions.Exception) {
	users, err := r.querier.GetAllOtherUser(ctx, args)
	return users, repoerror.BuildRepoErr("other_user", "GetAllOtherUser", err)
}

func (r *otherUserRepository) GetCountAllOtherUser(ctx context.Context) (int64, *exceptions.Exception) {
	count, err := r.querier.GetCountAllOtherUser(ctx)

	return count, repoerror.BuildRepoErr("other_user", "GetCountAllOtherUser", err)
}

func (r *otherUserRepository) GetAllOtherUsersByCountryId(ctx context.Context, args sqlc.GetAllOtherUsersByCountryIdParams) ([]sqlc.GetAllOtherUsersByCountryIdRow, *exceptions.Exception) {
	users, err := r.querier.GetAllOtherUsersByCountryId(ctx, args)
	return users, repoerror.BuildRepoErr("other_user", "GetAllOtherUsersByCountryId", err)
}

func (r *otherUserRepository) GetCountAllOtherUserByCountry(ctx context.Context, countryID int64) (int64, *exceptions.Exception) {
	count, err := r.querier.GetCountAllOtherUserByCountry(ctx, countryID)
	return count, repoerror.BuildRepoErr("other_user", "GetCountAllOtherUserByCountry", err)
}
