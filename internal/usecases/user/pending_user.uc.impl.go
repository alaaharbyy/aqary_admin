package usecase

import (
	"log"

	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	db "aqary_admin/pkg/db/user"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/security"

	domain "aqary_admin/internal/domain/requests/user"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
)

type PendingUserUseCase interface {
	GetAllPendingUser(ctx *gin.Context, req domain.GetAllUserRequest) ([]*response.AllPendingUserOutput, *int64, *exceptions.Exception)
	DeletePendingUser(ctx *gin.Context, id int64) (*sqlc.User, *exceptions.Exception)
}

type pendingUserUseCase struct {
	repo       db.UserCompositeRepo
	pool       *pgxpool.Pool
	tokenMaker security.Maker
}

func NewPendingUserUseCase(repo db.UserCompositeRepo, pool *pgxpool.Pool, token security.Maker) PendingUserUseCase {
	return &pendingUserUseCase{
		repo:       repo,
		pool:       pool,
		tokenMaker: token,
	}
}

func (uc *pendingUserUseCase) GetAllPendingUser(ctx *gin.Context, req domain.GetAllUserRequest) ([]*response.AllPendingUserOutput, *int64, *exceptions.Exception) {

	users, err := uc.repo.GetAllCompanyPendingUser(ctx, sqlc.GetAllCompanyPendingUserParams{
		Limit:  req.PageSize,
		Offset: (req.PageNo - 1) * req.PageSize,
	})
	if err != nil {
		return nil, nil, err
	}

	var outputs []*response.AllPendingUserOutput
	for _, user := range users {
		output, err := uc.buildPendingUserOutput(ctx, user)
		if err != nil {
			return nil, nil, err
		}
		outputs = append(outputs, output)
	}

	count, err := uc.repo.GetCountAllPendingUser(ctx)
	if err != nil {
		return nil, nil, err
	}

	return outputs, count, nil
}

func (uc *pendingUserUseCase) DeletePendingUser(ctx *gin.Context, id int64) (*sqlc.User, *exceptions.Exception) {
	user, err := uc.repo.GetPendingUser(ctx, id)
	if err != nil {
		return nil, err
	}

	updatedUser, err := uc.repo.UpdateUserStatus(ctx, sqlc.UpdateUserStatusParams{
		ID:     user.ID,
		Status: 6,
	})
	if err != nil {
		return nil, err
	}

	return updatedUser, nil
}

func (uc *pendingUserUseCase) buildPendingUserOutput(ctx *gin.Context, user *sqlc.User) (*response.AllPendingUserOutput, *exceptions.Exception) {
	var output response.AllPendingUserOutput

	// Set basic user information
	output.ID = user.ID
	output.Username = user.Username
	output.Email = user.Email

	// Fetch and set profile information
	profile, err := uc.repo.GetProfileByUserId(ctx, user.ID)
	if err != nil {
		return nil, err
	}
	output.Phone = user.PhoneNumber.String

	// Fetch and set company information
	companyUser, err := uc.repo.GetACompanyByUserID(ctx, user.ID)
	if err != nil {
		log.Println("skip err ", err)
		log.Println(err)
	}
	output.CompanyID = companyUser.CompanyID
	output.CompanyType = companyUser.CompanyType.Int64
	output.IsBranch = companyUser.IsBranch.Bool

	// // Fetch and set department information
	// if user.Department.Valid {
	// 	department, err := uc.repo.GetDepartment(ctx, int32(user.Department.Int64))
	// 	if err != nil {
	// 		log.Println(err)
	// 	}
	// 	output.Department = department.Title
	// }

	// Fetch and set role information
	if user.RolesID.Valid {
		// TODO: Need to fix this later
		// role, err := uc.repo.GetRole(ctx, user.RolesID.Int64, user.DepartmentID)
		// if err != nil {
		// 	log.Println(err)
		// }
		// output.Role = role.Role
	}

	// Fetch and set address information
	address, err := uc.repo.GetAddress(ctx, int32(profile.AddressesID))
	// address, err := uc.repo.GetAddress(ctx, int32(profile.AddressesID))
	if err != nil {
		log.Println(err)
	}

	// Fetch and set country information
	if address.CountriesID.Valid {
		country, err := uc.repo.GetCountry(ctx, int32(address.CountriesID.Int64))
		if err != nil {
			log.Println(err)
		}
		output.Country = country.Country
	}

	// Fetch and set state information
	if address.StatesID.Valid {
		state, err := uc.repo.GetState(ctx, int32(address.StatesID.Int64))
		if err != nil {
			log.Println(err)
		}
		output.State = state.State
	}

	// Fetch and set city information
	if address.CitiesID.Valid {
		city, err := uc.repo.GetCity(ctx, int32(address.CitiesID.Int64))
		if err != nil {
			log.Println(err)
		}
		output.City = city.City
	}

	// Fetch and set community information
	if address.CommunitiesID.Valid {
		community, err := uc.repo.GetCommunity(ctx, int32(address.CommunitiesID.Int64))
		if err != nil {
			log.Println(err)
		}
		output.Community = community.Community
	}

	// Fetch and set sub-community information
	if address.SubCommunitiesID.Valid {
		subCommunity, err := uc.repo.GetSubCommunity(ctx, int32(address.SubCommunitiesID.Int64))
		if err != nil {
			log.Println(err)
		}
		output.SubCommunity = subCommunity.SubCommunity
	}

	// Set verification status
	output.VerificationStatus = "VERIFIED PHASE-1"

	return &output, nil
}
