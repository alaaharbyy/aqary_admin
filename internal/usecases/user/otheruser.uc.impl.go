package usecase

import (
	"log"

	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	db "aqary_admin/pkg/db/user"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
)

type OtheruserUseCase interface {
	GetAllOtherUser(ctx *gin.Context, req domain.GetAllUserRequest) ([]*response.AllUserOutput, int64, *exceptions.Exception)
	GetAllOtherUserByCountry(ctx *gin.Context, req domain.GetAllOtherUserByCountryRequest) ([]*response.AllUserOutput, int64, *exceptions.Exception)
}

type otherUserUseCase struct {
	repo db.UserCompositeRepo
}

func NewOtheruserUseCase(repo db.UserCompositeRepo) OtheruserUseCase {
	return &otherUserUseCase{
		repo: repo,
	}
}

func (uc *otherUserUseCase) GetAllOtherUser(ctx *gin.Context, req domain.GetAllUserRequest) ([]*response.AllUserOutput, int64, *exceptions.Exception) {
	users, err := uc.repo.GetAllOtherUser(ctx, sqlc.GetAllOtherUserParams{
		Limit:  req.PageSize,
		Offset: (req.PageNo - 1) * req.PageSize,
	})
	if err != nil {
		return nil, 0, err
	}

	var outputs []*response.AllUserOutput
	for _, user := range users {
		output, err := uc.buildUserOutput(ctx, &user)
		if err != nil {
			return nil, 0, err
		}
		outputs = append(outputs, output)
	}

	count, err := uc.repo.GetCountAllOtherUser(ctx)
	if err != nil {
		return nil, 0, err
	}

	return outputs, count, nil
}

func (uc *otherUserUseCase) GetAllOtherUserByCountry(ctx *gin.Context, req domain.GetAllOtherUserByCountryRequest) ([]*response.AllUserOutput, int64, *exceptions.Exception) {
	users, err := uc.repo.GetAllOtherUsersByCountryId(ctx, sqlc.GetAllOtherUsersByCountryIdParams{
		Limit:  req.PageSize,
		Offset: (req.PageNo - 1) * req.PageSize,
		ID:     req.Country,
	})
	if err != nil {
		return nil, 0, err
	}

	var outputs []*response.AllUserOutput
	for _, user := range users {
		output, err := uc.buildUserByCountryOutput(ctx, &user)
		if err != nil {
			return nil, 0, err
		}
		outputs = append(outputs, output)
	}

	count, err := uc.repo.GetCountAllOtherUserByCountry(ctx, req.Country)
	if err != nil {
		return nil, 0, err
	}

	return outputs, count, nil
}

func (uc *otherUserUseCase) buildUserOutput(ctx *gin.Context, user *sqlc.User) (*response.AllUserOutput, *exceptions.Exception) {
	var output response.AllUserOutput

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

	// // Fetch and set department information
	// if user.Department.Valid {
	// 	department, err := uc.repo.GetDepartment(ctx, int32(user.Department.Int64))
	// 	log.Println("testing department", department)
	// 	if err != nil {
	// 		log.Println(err)
	// 	}
	// 	output.Department = department.Title
	// }

	// Fetch and set role information
	if user.RolesID.Valid {
		// TODO: Need to fix this later
		// role, err := uc.repo.GetRole(ctx, user.RolesID.Int64)
		// if err != nil {
		// 	log.Println(err)
		// }
		// output.Role = role.Role
	}

	// Fetch and set address information
	address, err := uc.repo.GetAddress(ctx, int32(profile.AddressesID))
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

	return &output, nil
}

func (uc *otherUserUseCase) buildUserByCountryOutput(ctx *gin.Context, user *sqlc.GetAllOtherUsersByCountryIdRow) (*response.AllUserOutput, *exceptions.Exception) {
	var output response.AllUserOutput

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
		// role, err := uc.repo.GetRole(ctx, user.RolesID.Int64)
		// if err != nil {
		// 	log.Println(err)
		// }
		// output.Role = role.Role
	}

	// Fetch and set address information
	address, err := uc.repo.GetAddress(ctx, int32(profile.AddressesID))
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

	return &output, nil
}
