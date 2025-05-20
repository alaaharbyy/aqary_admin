package db

import (
	"context"
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

type PendingUserRepo interface {
	GetAllCompanyPendingUser(ctx context.Context, args sqlc.GetAllCompanyPendingUserParams) ([]*sqlc.User, *exceptions.Exception)
	GetCountAllPendingUser(ctx context.Context) (*int64, *exceptions.Exception)
	GetPendingUser(ctx context.Context, id int64) (*sqlc.User, *exceptions.Exception)
	UpdateUserStatus(ctx context.Context, args sqlc.UpdateUserStatusParams) (*sqlc.User, *exceptions.Exception)
	// ------
	// GetProfile(ctx *gin.Context, id int64) (sqlc.Profile, *exceptions.Exception)
	GetACompanyByUserID(ctx *gin.Context, userID int64) (sqlc.GetACompanyByUserIDRow, *exceptions.Exception)
	GetDepartment(ctx *gin.Context, arg sqlc.GetDepartmentParams) (sqlc.Department, *exceptions.Exception)
	GetRole(ctx *gin.Context, id int64) (sqlc.Role, *exceptions.Exception)
	GetAddress(ctx *gin.Context, id int32) (sqlc.Address, *exceptions.Exception)
	GetLocationByAddressId(ctx *gin.Context, id int32) (*string, *exceptions.Exception)
	// GetLocationByAddress(ctx *gin.Context, addressID int64) (*sqlc.GetLocationByAddressRow, *exceptions.Exception)
	GetLocationByAddressID(ctx *gin.Context, addressID int64) (*sqlc.GetLocationByAddressIDRow, *exceptions.Exception)

	GetCountry(ctx *gin.Context, id int32) (sqlc.Country, *exceptions.Exception)
	GetState(ctx *gin.Context, id int32) (sqlc.State, *exceptions.Exception)
	GetCity(ctx *gin.Context, id int32) (sqlc.City, *exceptions.Exception)
	GetCommunity(ctx *gin.Context, id int32) (sqlc.Community, *exceptions.Exception)
	GetSubCommunity(ctx *gin.Context, id int32) (sqlc.SubCommunity, *exceptions.Exception)
	// UpdatePropertyVersionsStatusForAgent(ctx *gin.Context, arg sqlc.UpdatePropertyVersionsStatusForAgentParams, q sqlc.Querier) *exceptions.Exception
	UpdateUnitVersionsStatusForAgent(ctx *gin.Context, arg sqlc.UpdateUnitVersionsStatusForAgentParams, q sqlc.Querier) *exceptions.Exception
}

type pendingRepository struct {
	querier sqlc.Querier
}

// // UpdatePropertyVersionsStatusForAgent implements PendingUserRepo.
// func (r *pendingRepository) UpdatePropertyVersionsStatusForAgent(ctx *gin.Context, arg sqlc.UpdatePropertyVersionsStatusForAgentParams, q sqlc.Querier) *exceptions.Exception {

// 	if q == nil {
// 		q = r.querier
// 	}

// 	err := q.UpdatePropertyVersionsStatusForAgent(ctx, arg)

// 	if err != nil {
// 		return repoerror.BuildRepoErr("Pending User ", "UpdatePropertyVersionsStatusForAgent", err)
// 	}

// 	return nil
// }

// UpdateUnitVersionsStatusForAgent implements PendingUserRepo.
func (r *pendingRepository) UpdateUnitVersionsStatusForAgent(ctx *gin.Context, arg sqlc.UpdateUnitVersionsStatusForAgentParams, q sqlc.Querier) *exceptions.Exception {

	if q == nil {
		q = r.querier
	}

	err := q.UpdateUnitVersionsStatusForAgent(ctx, arg)

	if err != nil {
		return repoerror.BuildRepoErr("Pending User ", "UpdateUnitVersionsStatusForAgent", err)
	}

	return nil
}

// GetGlobalPropertyByID implements PendingUserRepo.
func (r *pendingRepository) GetGlobalPropertyByID(ctx *gin.Context, id int64) (*sqlc.Property, *exceptions.Exception) {

	property, err := r.querier.GetGlobalPropertyByID(ctx, id)

	if err != nil {
		return nil, repoerror.BuildRepoErr("Pending User ", "GetGlobalPropertyByID", err)
	}
	return &property, nil
}

// GetLocationByAddressId implements PendingUserRepo.
func (r *pendingRepository) GetLocationByAddressId(ctx *gin.Context, id int32) (*string, *exceptions.Exception) {

	add, err := r.querier.GetLocationByAddressId(ctx, int64(id))
	if err != nil {
		return nil, repoerror.BuildRepoErr("Pending User ", "GetLocationByAddressId", err)
	}

	return &add, nil
}

// GetLocationByAddressId implements PendingUserRepo.
func (r *pendingRepository) GetLocationByAddressID(ctx *gin.Context, addressID int64) (*sqlc.GetLocationByAddressIDRow, *exceptions.Exception) {

	add, err := r.querier.GetLocationByAddressID(ctx, int64(addressID))
	if err != nil {
		return nil, repoerror.BuildRepoErr("Pending User ", "GetLocationByAddressId", err)
	}

	return &add, nil
}

func NewPendingRepository(querier sqlc.Querier) PendingUserRepo {
	return &pendingRepository{
		querier: querier,
	}
}

func (r *pendingRepository) GetAllCompanyPendingUser(ctx context.Context, args sqlc.GetAllCompanyPendingUserParams) ([]*sqlc.User, *exceptions.Exception) {
	allUsers := []*sqlc.User{}
	users, err := r.querier.GetAllCompanyPendingUser(ctx, args)
	for _, u := range users {
		allUsers = append(allUsers, &u)
	}
	return allUsers, buildPendingUserErr("GetAllCompanyPendingUser", err)
}

func (r *pendingRepository) GetCountAllPendingUser(ctx context.Context) (*int64, *exceptions.Exception) {
	count, err := r.querier.GetCountAllPendingUser(ctx)
	if err != nil {
		return nil, buildPendingUserErr("GetCountAllPendingUser", err)
	}
	return &count, nil
}

func (r *pendingRepository) GetPendingUser(ctx context.Context, id int64) (*sqlc.User, *exceptions.Exception) {
	user, err := r.querier.GetPendingUser(ctx, id)
	return &user, buildPendingUserErr("GetPendingUser", err)
}

func (r *pendingRepository) UpdateUserStatus(ctx context.Context, args sqlc.UpdateUserStatusParams) (*sqlc.User, *exceptions.Exception) {
	user, err := r.querier.UpdateUserStatus(ctx, args)
	return &user, buildPendingUserErr("UpdateUserStatus", err)
}

func (r *pendingRepository) GetACompanyByUserID(ctx *gin.Context, userID int64) (sqlc.GetACompanyByUserIDRow, *exceptions.Exception) {
	companyUser, err := r.querier.GetACompanyByUserID(ctx, userID)
	if err != nil {
		return sqlc.GetACompanyByUserIDRow{}, buildPendingUserErr("GetACompanyByUserID", err)
	}
	return companyUser, nil
}

func (r *pendingRepository) GetDepartment(ctx *gin.Context, arg sqlc.GetDepartmentParams) (sqlc.Department, *exceptions.Exception) {

	department, err := r.querier.GetDepartment(ctx, arg)
	if err != nil {
		return sqlc.Department{}, buildPendingUserErr("GetDepartment", err)
	}
	return department, nil
}

func (r *pendingRepository) GetRole(ctx *gin.Context, id int64) (sqlc.Role, *exceptions.Exception) {
	role, err := r.querier.GetRole(ctx, id)

	if err != nil {
		return sqlc.Role{}, buildPendingUserErr("GetRole", err)
	}
	return role, nil
}

func (r *pendingRepository) GetAddress(ctx *gin.Context, id int32) (sqlc.Address, *exceptions.Exception) {
	address, err := r.querier.GetAddress(ctx, id)
	if err != nil {
		return sqlc.Address{}, buildPendingUserErr("GetAddress", err)
	}
	return address, nil
}

func (r *pendingRepository) GetCountry(ctx *gin.Context, id int32) (sqlc.Country, *exceptions.Exception) {
	country, err := r.querier.GetCountry(ctx, id)
	if err != nil {
		return sqlc.Country{}, buildPendingUserErr("GetCountry", err)
	}
	return country, nil
}

func (r *pendingRepository) GetState(ctx *gin.Context, id int32) (sqlc.State, *exceptions.Exception) {
	state, err := r.querier.GetState(ctx, id)
	if err != nil {
		return sqlc.State{}, buildPendingUserErr("GetState", err)
	}
	return state, nil
}

func (r *pendingRepository) GetCity(ctx *gin.Context, id int32) (sqlc.City, *exceptions.Exception) {
	city, err := r.querier.GetCity(ctx, int64(id))
	if err != nil {
		return sqlc.City{}, buildPendingUserErr("GetCity", err)
	}
	return city.City, nil
}

func (r *pendingRepository) GetCommunity(ctx *gin.Context, id int32) (sqlc.Community, *exceptions.Exception) {
	community, err := r.querier.GetCommunity(ctx, id)
	if err != nil {
		return sqlc.Community{}, buildPendingUserErr("GetCommunity", err)
	}
	return community, nil
}

func (r *pendingRepository) GetSubCommunity(ctx *gin.Context, id int32) (sqlc.SubCommunity, *exceptions.Exception) {
	subCommunity, err := r.querier.GetSubCommunity(ctx, id)
	if err != nil {
		return sqlc.SubCommunity{}, buildPendingUserErr("GetSubCommunity", err)
	}
	return subCommunity, nil
}

func buildPendingUserErr(name string, err error) *exceptions.Exception {
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			log.Printf("[pending_user.repo.%v] error:%v", name, err)
			return exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode)
		}
		middleware.IncrementServerErrorCounter(fmt.Errorf("[pending_user.repo.%v] error:%v", name, err).Error())
		return exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}
	return nil
}
