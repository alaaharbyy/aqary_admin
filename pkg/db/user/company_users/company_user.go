package companyusers_repo

import (
	"context"
	"log"

	"aqary_admin/internal/domain/sqlc/sqlc"
	auth_utils "aqary_admin/pkg/utils/auth"
	"aqary_admin/pkg/utils/exceptions"
	repoerror "aqary_admin/pkg/utils/repo_error"

	"github.com/gin-gonic/gin"
	// "aqary_admin/internal/domain/sqlc/sqlc"
	// "aqary_admin/pkg/utils/exceptions"
	// "log"
	// repoerror "aqary_admin/pkg/utils/repo_*exceptions.Exception"
	// "github.com/gin-gonic/gin"
	// "github.com/jackc/pgx/v5"
)

type CompanyUserRepo interface {
	GetCompanies(c *gin.Context, id int64, q sqlc.Querier) (*sqlc.Company, *exceptions.Exception)
	CreateCompanyUser(ctx *gin.Context, arg sqlc.CreateCompanyUserParams, q sqlc.Querier) (*sqlc.CompanyUser, *exceptions.Exception)

	CreateAddress(ctx *gin.Context, arg sqlc.CreateAddressParams, q sqlc.Querier) (*sqlc.Address, *exceptions.Exception)

	CreateUser(ctx *gin.Context, arg sqlc.CreateUserParams, q sqlc.Querier) (*sqlc.User, *exceptions.Exception)
	CreateBrokerBranchAgent(ctx *gin.Context, arg sqlc.CreateBrokerBranchAgentParams, q sqlc.Querier) (*sqlc.BrokerCompanyBranchesAgent, *exceptions.Exception)
	CreateBrokerAgent(ctx *gin.Context, arg sqlc.CreateBrokerAgentParams, q sqlc.Querier) (*sqlc.BrokerCompanyAgent, *exceptions.Exception)
	CreateAgentSubscriptionQuotaBranch(ctx *gin.Context, arg sqlc.CreateAgentSubscriptionQuotaBranchParams, q sqlc.Querier) (*sqlc.AgentSubscriptionQuotaBranch, *exceptions.Exception)
	CreateAgentSubscriptionQuota(ctx *gin.Context, arg sqlc.CreateAgentSubscriptionQuotaParams, q sqlc.Querier) (*sqlc.AgentSubscriptionQuotum, *exceptions.Exception)
	GetCompanyAdmin(ctx *gin.Context, arg sqlc.GetCompanyAdminParams) (int64, *exceptions.Exception)
	GetUserRegardlessOfStatus(ctx *gin.Context, id int64) (*sqlc.GetUserRegardlessOfStatusRow, *exceptions.Exception)

	GetAllCompanyUsers(ctx *gin.Context, arg sqlc.GetAllCompanyUsersParams) ([]sqlc.GetAllCompanyUsersRow, *exceptions.Exception)
	GetCountAllCompanyUsers(ctx *gin.Context, arg sqlc.GetCountAllCompanyUsersParams) (int64, *exceptions.Exception)
	GetAllFreelanceUsers(ctx *gin.Context, arg sqlc.GetAllFreelanceUsersParams) ([]sqlc.GetAllFreelanceUsersRow, *exceptions.Exception)
	CountAllFreelanceUsers(ctx *gin.Context, search string) (int64, *exceptions.Exception)
	GetAllOwnerUsers(ctx *gin.Context, arg sqlc.GetAllOwnerUsersParams) ([]sqlc.GetAllOwnerUsersRow, *exceptions.Exception)
	CountAllOwnerUsers(ctx *gin.Context, search string) (int64, *exceptions.Exception)

	GetCompanyUserByCompanyUserId(ctx *gin.Context, id int64) (sqlc.CompanyUser, *exceptions.Exception)
	GetCompanyUsersByUsersID(ctx *gin.Context, userID int64) (sqlc.CompanyUser, *exceptions.Exception)
	GetAllLanguagesByIds(ctx *gin.Context, ids []int64) ([]sqlc.AllLanguage, *exceptions.Exception)
	GetAllCititesByIds(ctx *gin.Context, ids []int64) ([]sqlc.City, *exceptions.Exception)
	GetCompanyUserBranchAgentAndQuotaByUserId(ctx *gin.Context, userID int64) (sqlc.GetCompanyUserBranchAgentAndQuotaByUserIdRow, *exceptions.Exception)
	GetCompanyUserAgentAndQuotaByUserId(ctx *gin.Context, userID int64) (sqlc.GetCompanyUserAgentAndQuotaByUserIdRow, *exceptions.Exception)

	GetAllCompanyUsersByStatus(ctx *gin.Context, arg sqlc.GetAllCompanyUsersByStatusParams) ([]sqlc.GetAllCompanyUsersByStatusRow, *exceptions.Exception)
	CountAllCompanyUsersByStatus(ctx *gin.Context, arg sqlc.CountAllCompanyUsersByStatusParams) (int64, *exceptions.Exception)

	GetCountCompanyUsersByStatuses(ctx *gin.Context, statuses []int64) (int64, *exceptions.Exception)
	GetCompanyUser(ctx *gin.Context, id int32) (sqlc.CompanyUser, *exceptions.Exception)
	GetCompany(ctx *gin.Context, id int32) (*sqlc.Company, *exceptions.Exception)

	UpdateBrokerBranchAgentStatus(ctx *gin.Context, userID int64, status int64) *exceptions.Exception
	UpdateBrokerAgentStatus(ctx *gin.Context, userID int64, status int64) *exceptions.Exception

	GetBrokerAgentByUserId(ctx *gin.Context, userID int64) (sqlc.BrokerCompanyAgent, *exceptions.Exception)
	GetBrokerBranchAgentByUserId(ctx *gin.Context, userID int64) (sqlc.BrokerCompanyBranchesAgent, *exceptions.Exception)
	UpdateBrokerAgent(ctx *gin.Context, arg sqlc.UpdateBrokerAgentParams) *exceptions.Exception
	UpdateBrokerBranchAgent(ctx *gin.Context, arg sqlc.UpdateBrokerBranchAgentParams) *exceptions.Exception
	UpdateAgentSubscriptionQuota(ctx *gin.Context, arg sqlc.UpdateAgentSubscriptionQuotaParams) *exceptions.Exception
	UpdateAgentSubscriptionQuotaBranch(ctx *gin.Context, arg sqlc.UpdateAgentSubscriptionQuotaBranchParams) *exceptions.Exception
	//  new ........
	// GetCurrentSubscriptionQuota(c *gin.Context, companyId int64) ([]sqlc.GetRemainingCompanyQuotaRow, *exceptions.Exception)
	GetUserBankAccountDetails(c *gin.Context, userId int64) (*sqlc.BankAccountDetail, *exceptions.Exception)
	UpdateUserVerification(c *gin.Context, args sqlc.VerifyUserParams) (*sqlc.User, *exceptions.Exception)

	GetBrnLicenseByUserID(c *gin.Context, userId int64) (*sqlc.License, *exceptions.Exception)
	//
	GetSubscriptionOrderPackageDetailByUserID(c *gin.Context, args sqlc.GetSubscriptionOrderPackageDetailByUserIDParams) ([]sqlc.GetSubscriptionOrderPackageDetailByUserIDRow, *exceptions.Exception)
	CreateSignUpUser(ctx *gin.Context, arg sqlc.CreateSignUpUserParams, q sqlc.Querier) (*sqlc.User, *exceptions.Exception)
	UpdateActiveCompany(ctx *gin.Context, arg sqlc.UpdateActiveCompanyParams, q sqlc.Querier) (*sqlc.User, *exceptions.Exception)
	CreatePlatformUser(ctx *gin.Context, arg sqlc.CreatePlatformUserParams, q sqlc.Querier) (*sqlc.PlatformUser, *exceptions.Exception)
	GetRemainingCreditToAssignAgentByCompany(ctx context.Context, companyID int64) ([]sqlc.GetRemainingCreditToAssignAgentByCompanyRow, *exceptions.Exception)
	GetCompanyUserByUserId(ctx context.Context, arg sqlc.GetCompanyUserByUserIdParams) (*sqlc.CompanyUser, *exceptions.Exception)
	VerifyCompanyUserByUserId(ctx context.Context, arg sqlc.VerifyCompanyUserByUserIdParams, q sqlc.Querier) *exceptions.Exception

	CreateCompanyUserExpertise(ctx *gin.Context, arg sqlc.CreateCompanyUserExpertiseParams, q sqlc.Querier) (int64, *exceptions.Exception)
	GetCompanyUserExpertise(ctx *gin.Context, arg sqlc.GetCompanyUserExpertiseParams, q sqlc.Querier) ([]sqlc.GetCompanyUserExpertiseRow, *exceptions.Exception)
	GetCompanyUserExpertiseCount(ctx *gin.Context, companyUserID int64, q sqlc.Querier) (int64, *exceptions.Exception)
	BulkDeleteCompanyUserExpertise(ctx *gin.Context, req sqlc.BulkDeleteCompanyUserExpertiseParams, q sqlc.Querier) *exceptions.Exception
	DeleteCompanyUserExpertise(ctx *gin.Context, id int64, q sqlc.Querier) *exceptions.Exception
	CheckExitingompanyUserExpertise(ctx context.Context, arg sqlc.CheckExitingompanyUserExpertiseParams, q sqlc.Querier) (int64, *exceptions.Exception)
	GetSingleCompanyUserExpertise(ctx context.Context, id int64, q sqlc.Querier) (*sqlc.GetSingleCompanyUserExpertiseRow, *exceptions.Exception)
}

type companyUserRepository struct {
	querier sqlc.Querier
}

// CheckExitingompanyUserExpertise implements CompanyUserRepo.
func (r *companyUserRepository) CheckExitingompanyUserExpertise(ctx context.Context, arg sqlc.CheckExitingompanyUserExpertiseParams, q sqlc.Querier) (int64, *exceptions.Exception) {

	if q == nil {
		q = r.querier
	}

	data, err := q.CheckExitingompanyUserExpertise(ctx, arg)

	if err != nil {
		return 0, repoerror.BuildRepoErr("settings", "CheckExitingompanyUserExpertise", err)
	}

	return data, nil
}

// GetSingleCompanyUserExpertise implements CompanyUserRepo.
func (r *companyUserRepository) GetSingleCompanyUserExpertise(ctx context.Context, id int64, q sqlc.Querier) (*sqlc.GetSingleCompanyUserExpertiseRow, *exceptions.Exception) {

	if q == nil {
		q = r.querier
	}

	data, err := q.GetSingleCompanyUserExpertise(ctx, id)

	if err != nil {
		return nil, repoerror.BuildRepoErr("settings", "GetSingleCompanyUserExpertise", err)
	}

	return &data, nil
}

// BulkDeleteCompanyUserExpertise implements CompanyUserRepo.
func (r *companyUserRepository) BulkDeleteCompanyUserExpertise(ctx *gin.Context, req sqlc.BulkDeleteCompanyUserExpertiseParams, q sqlc.Querier) *exceptions.Exception {
	if q == nil {
		q = r.querier
	}

	err := q.BulkDeleteCompanyUserExpertise(ctx, req)
	return repoerror.BuildRepoErr("company user", "BulkDeleteCompanyUserExpertise", err)
}

// DeleteCompanyUserExpertise implements CompanyUserRepo.
func (r *companyUserRepository) DeleteCompanyUserExpertise(ctx *gin.Context, id int64, q sqlc.Querier) *exceptions.Exception {
	if q == nil {
		q = r.querier
	}

	err := q.DeleteCompanyUserExpertise(ctx, id)
	return repoerror.BuildRepoErr("company user", "DeleteCompanyUserExpertise", err)
}

// CreateCompanyUserExpertise implements SettingsInterface.
func (s *companyUserRepository) CreateCompanyUserExpertise(ctx *gin.Context, arg sqlc.CreateCompanyUserExpertiseParams, q sqlc.Querier) (int64, *exceptions.Exception) {

	if q == nil {
		q = s.querier
	}

	data, err := q.CreateCompanyUserExpertise(ctx, arg)

	if err != nil {
		return 0, repoerror.BuildRepoErr("settings", "CreateCompanyUserExpertise", err)
	}

	return data, nil
}

// GetCompanyUserExpertise implements SettingsInterface.
func (s *companyUserRepository) GetCompanyUserExpertise(ctx *gin.Context, arg sqlc.GetCompanyUserExpertiseParams, q sqlc.Querier) ([]sqlc.GetCompanyUserExpertiseRow, *exceptions.Exception) {
	if q == nil {
		q = s.querier
	}

	data, err := q.GetCompanyUserExpertise(ctx, arg)

	if err != nil {
		return nil, repoerror.BuildRepoErr("settings", "GetCompanyUserExpertise", err)
	}

	return data, nil
}

// GetCompanyUserExpertiseCount implements SettingsInterface.
func (s *companyUserRepository) GetCompanyUserExpertiseCount(ctx *gin.Context, companyUserID int64, q sqlc.Querier) (int64, *exceptions.Exception) {
	if q == nil {
		q = s.querier
	}

	data, err := q.GetCompanyUserExpertiseCount(ctx, companyUserID)

	if err != nil {
		return 0, repoerror.BuildRepoErr("settings", "GetCompanyUserExpertiseCount", err)
	}

	return data, nil
}

// VerifyCompanyUserByUserId implements CompanyUserRepo.
func (r *companyUserRepository) VerifyCompanyUserByUserId(ctx context.Context, arg sqlc.VerifyCompanyUserByUserIdParams, q sqlc.Querier) *exceptions.Exception {
	if q == nil {
		q = r.querier
	}

	err := q.VerifyCompanyUserByUserId(ctx, arg)
	return repoerror.BuildRepoErr("company user", "VerifyCompanyUserByUserId", err)

}

// GetCompanyUserByUserId implements CompanyUserRepo.
func (r *companyUserRepository) GetCompanyUserByUserId(ctx context.Context, arg sqlc.GetCompanyUserByUserIdParams) (*sqlc.CompanyUser, *exceptions.Exception) {
	subs, err := r.querier.GetCompanyUserByUserId(ctx, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company user", "GetCompanyUserByUserId", err)
	}
	return &subs, nil
}

// GetRemainingCreditToAssignAgentByCompany implements CompanyUserRepo.
func (r *companyUserRepository) GetRemainingCreditToAssignAgentByCompany(ctx context.Context, companyID int64) ([]sqlc.GetRemainingCreditToAssignAgentByCompanyRow, *exceptions.Exception) {
	subs, err := r.querier.GetRemainingCreditToAssignAgentByCompany(ctx, companyID)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company user", "GetRemainingCreditToAssignAgentByCompany", err)
	}
	return subs, nil
}

// UpdateActiveCompany implements CompanyUserRepo.
func (r *companyUserRepository) UpdateActiveCompany(ctx *gin.Context, arg sqlc.UpdateActiveCompanyParams, q sqlc.Querier) (*sqlc.User, *exceptions.Exception) {
	r.querier, q = auth_utils.CheckAuthForTests(ctx, r.querier, q)

	user, err := q.UpdateActiveCompany(ctx, arg)
	if err != nil {
		er := repoerror.BuildRepoErr("company_user", "UpdateActiveCompany", err)
		return nil, er
	}
	return &user, nil
}

// CreateSignUpUser implements CompanyUserRepo.
func (r *companyUserRepository) CreateSignUpUser(ctx *gin.Context, arg sqlc.CreateSignUpUserParams, q sqlc.Querier) (*sqlc.User, *exceptions.Exception) {
	r.querier, q = auth_utils.CheckAuthForTests(ctx, r.querier, q)

	log.Println("testing args of create user ", arg)
	user, err := q.CreateSignUpUser(ctx, arg)
	if err != nil {
		er := repoerror.BuildRepoErr("company_user", "CreateSignUpUser", err)
		log.Println("[CreateSignUpUser]testing errr", er)
		return nil, er
	}
	return &user, nil
}

func (r *companyUserRepository) GetSubscriptionOrderPackageDetailByUserID(c *gin.Context, args sqlc.GetSubscriptionOrderPackageDetailByUserIDParams) ([]sqlc.GetSubscriptionOrderPackageDetailByUserIDRow, *exceptions.Exception) {

	subs, err := r.querier.GetSubscriptionOrderPackageDetailByUserID(c, args)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company user", "GetSubscriptionOrderPackageDetailByUserID", err)
	}
	return subs, nil
}

func (r *companyUserRepository) GetBrnLicenseByUserID(c *gin.Context, userId int64) (*sqlc.License, *exceptions.Exception) {
	lic, err := r.querier.GetBrnLicenseByUserID(c, userId)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company user", "GetBrnLicenseByUserID", err)
	}

	return &lic, nil
}

func (r *companyUserRepository) UpdateUserVerification(c *gin.Context, arg sqlc.VerifyUserParams) (*sqlc.User, *exceptions.Exception) {

	user, err := r.querier.VerifyUser(c, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company user", "UpdateUserVerification", err)
	}

	return &user, nil
}

func (r *companyUserRepository) GetUserBankAccountDetails(ctx *gin.Context, id int64) (*sqlc.BankAccountDetail, *exceptions.Exception) {
	bank, err := r.querier.GetUserBankAccountDetails(ctx, id)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company user", "GetUserBankAccountDetails", err)
	}

	return &bank, nil

}

// GetCompany implements CompanyUserRepo.
func (r *companyUserRepository) GetCompany(ctx *gin.Context, id int32) (*sqlc.Company, *exceptions.Exception) {
	comp, err := r.querier.GetCompany(ctx, int64(id))
	if err != nil {
		return nil, repoerror.BuildRepoErr("company user", "GetCompany", err)
	}

	return &comp, nil
}

// CountAllFreelanceUsers implements CompanyUserRepo.
func (r *companyUserRepository) CountAllFreelanceUsers(ctx *gin.Context, search string) (int64, *exceptions.Exception) {
	count, err := r.querier.CountAllFreelanceUsers(ctx, search)
	if err != nil {
		return 0, repoerror.BuildRepoErr("company user", "CountAllFreelanceUsers", err)
	}
	return count, nil
}

// CountAllOwnerUsers implements CompanyUserRepo.
func (r *companyUserRepository) CountAllOwnerUsers(ctx *gin.Context, search string) (int64, *exceptions.Exception) {
	count, err := r.querier.CountAllOwnerUsers(ctx, search)
	if err != nil {
		return 0, repoerror.BuildRepoErr("company user", "CountAllOwnerUsers", err)
	}
	return count, nil
}

// GetAllFreelanceUsers implements CompanyUserRepo.
func (r *companyUserRepository) GetAllFreelanceUsers(ctx *gin.Context, arg sqlc.GetAllFreelanceUsersParams) ([]sqlc.GetAllFreelanceUsersRow, *exceptions.Exception) {
	user, err := r.querier.GetAllFreelanceUsers(ctx, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company user", "GetAllFreelanceUsers", err)
	}
	return user, nil
}

// GetAllOwnerUsers implements CompanyUserRepo.
func (r *companyUserRepository) GetAllOwnerUsers(ctx *gin.Context, arg sqlc.GetAllOwnerUsersParams) ([]sqlc.GetAllOwnerUsersRow, *exceptions.Exception) {
	user, err := r.querier.GetAllOwnerUsers(ctx, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company user", "GetAllOwnerUsers", err)
	}
	return user, nil
}

// // GetCurrentSubscriptionQuota implements CompanyUserRepo.
// func (r *companyUserRepository) GetCurrentSubscriptionQuota(c *gin.Context, companyId int64) ([]sqlc.GetRemainingCompanyQuotaRow, *exceptions.Exception) {

// 	subs, err := r.querier.GetRemainingCompanyQuota(c, companyId)
// 	if err != nil {
// 		return nil, repoerror.BuildRepoErr("company user", "GetCurrentSubscriptionQuota", err)
// 	}
// 	return subs, nil
// }

// GetCompanies implements CompanyUserRepo.
func (r *companyUserRepository) GetCompanies(c *gin.Context, id int64, q sqlc.Querier) (*sqlc.Company, *exceptions.Exception) {
	if q == nil {
		q = r.querier
	}

	company, err := q.GetCompanies(c, id)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company_user", "GetCompanies", err)
	}
	return &company, nil
}

func NewCompanyUserRepository(querier sqlc.Querier) CompanyUserRepo {
	return &companyUserRepository{
		querier: querier,
	}
}

func (r *companyUserRepository) CreateCompanyUser(ctx *gin.Context, arg sqlc.CreateCompanyUserParams, q sqlc.Querier) (*sqlc.CompanyUser, *exceptions.Exception) {
	companyUser, err := q.CreateCompanyUser(ctx, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company_user", "CreateCompanyUser", err)
	}
	return &companyUser, nil
}

func (r *companyUserRepository) CreateAddress(ctx *gin.Context, arg sqlc.CreateAddressParams, q sqlc.Querier) (*sqlc.Address, *exceptions.Exception) {

	address, err := q.CreateAddress(ctx, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company_user", "CreateAddress", err)
	}
	return &address, nil
}

func (r *companyUserRepository) CreateUser(ctx *gin.Context, arg sqlc.CreateUserParams, q sqlc.Querier) (*sqlc.User, *exceptions.Exception) {

	r.querier, q = auth_utils.CheckAuthForTests(ctx, r.querier, q)

	log.Println("testing args of create user ", arg)
	user, err := q.CreateUser(ctx, arg)
	if err != nil {
		er := repoerror.BuildRepoErr("company_user", "CreateUser", err)
		log.Println("[CreateUser]testing errr", er)
		return nil, er
	}
	return &user, nil
}

func (r *companyUserRepository) CreateBrokerBranchAgent(ctx *gin.Context, arg sqlc.CreateBrokerBranchAgentParams, q sqlc.Querier) (*sqlc.BrokerCompanyBranchesAgent, *exceptions.Exception) {
	agent, err := q.CreateBrokerBranchAgent(ctx, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company_user", "CreateBrokerBranchAgent", err)
	}
	return &agent, nil
}

func (r *companyUserRepository) CreateBrokerAgent(ctx *gin.Context, arg sqlc.CreateBrokerAgentParams, q sqlc.Querier) (*sqlc.BrokerCompanyAgent, *exceptions.Exception) {
	agent, err := q.CreateBrokerAgent(ctx, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company_user", "CreateBrokerAgent", err)
	}
	return &agent, nil
}

func (r *companyUserRepository) CreateAgentSubscriptionQuotaBranch(ctx *gin.Context, arg sqlc.CreateAgentSubscriptionQuotaBranchParams, q sqlc.Querier) (*sqlc.AgentSubscriptionQuotaBranch, *exceptions.Exception) {
	quota, err := q.CreateAgentSubscriptionQuotaBranch(ctx, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company_user", "CreateAgentSubscriptionQuotaBranch", err)
	}
	return &quota, nil
}

func (r *companyUserRepository) CreateAgentSubscriptionQuota(ctx *gin.Context, arg sqlc.CreateAgentSubscriptionQuotaParams, q sqlc.Querier) (*sqlc.AgentSubscriptionQuotum, *exceptions.Exception) {
	quota, err := q.CreateAgentSubscriptionQuota(ctx, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company_user", "CreateAgentSubscriptionQuota", err)
	}
	return &quota, nil
}

func (r *companyUserRepository) GetCompanyAdmin(ctx *gin.Context, arg sqlc.GetCompanyAdminParams) (int64, *exceptions.Exception) {
	adminID, err := r.querier.GetCompanyAdmin(ctx, arg)
	if err != nil {
		return 0, repoerror.BuildRepoErr("company_user", "GetCompanyAdmin", err)
	}
	return adminID, nil
}

func (r *companyUserRepository) GetUserRegardlessOfStatus(ctx *gin.Context, id int64) (*sqlc.GetUserRegardlessOfStatusRow, *exceptions.Exception) {
	user, err := r.querier.GetUserRegardlessOfStatus(ctx, id)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company_user", "GetUserRegardlessOfStatus", err)
	}
	return &user, nil
}

func (r *companyUserRepository) GetAllCompanyUsers(ctx *gin.Context, arg sqlc.GetAllCompanyUsersParams) ([]sqlc.GetAllCompanyUsersRow, *exceptions.Exception) {
	users, err := r.querier.GetAllCompanyUsers(ctx, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company_user", "GetAllCompanyUsers", err)
	}
	return users, nil
}

func (r *companyUserRepository) GetCountAllCompanyUsers(ctx *gin.Context, arg sqlc.GetCountAllCompanyUsersParams) (int64, *exceptions.Exception) {
	count, err := r.querier.GetCountAllCompanyUsers(ctx, arg)
	if err != nil {
		return 0, repoerror.BuildRepoErr("company_user", "GetCountAllCompanyUsers", err)
	}
	return count, nil
}

func (r *companyUserRepository) GetCompanyUserByCompanyUserId(ctx *gin.Context, id int64) (sqlc.CompanyUser, *exceptions.Exception) {
	user, err := r.querier.GetCompanyUserByCompanyUserId(ctx, id)
	log.Println("testing user ,", user, "::", err)
	if err != nil {
		return sqlc.CompanyUser{}, repoerror.BuildRepoErr("company_user", "GetCompanyUserById", err)
	}
	return user, nil
}

func (r *companyUserRepository) GetCompanyUsersByUsersID(ctx *gin.Context, userID int64) (sqlc.CompanyUser, *exceptions.Exception) {
	users, err := r.querier.GetCompanyUsersByUsersID(ctx, userID)
	if err != nil {
		return sqlc.CompanyUser{}, repoerror.BuildRepoErr("company_user", "GetCompanyUsersByUsersID", err)
	}
	return users, nil
}

func (r *companyUserRepository) GetAllLanguagesByIds(ctx *gin.Context, ids []int64) ([]sqlc.AllLanguage, *exceptions.Exception) {
	languages, err := r.querier.GetAllLanguagesByIds(ctx, ids)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company_user", "GetAllLanguagesByIds", err)
	}
	return languages, nil
}

func (r *companyUserRepository) GetAllCititesByIds(ctx *gin.Context, ids []int64) ([]sqlc.City, *exceptions.Exception) {
	cities, err := r.querier.GetAllCititesByIds(ctx, ids)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company_user", "GetAllCititesByIds", err)
	}
	return cities, nil
}

func (r *companyUserRepository) GetCompanyUserBranchAgentAndQuotaByUserId(ctx *gin.Context, userID int64) (sqlc.GetCompanyUserBranchAgentAndQuotaByUserIdRow, *exceptions.Exception) {
	agent, err := r.querier.GetCompanyUserBranchAgentAndQuotaByUserId(ctx, userID)
	if err != nil {
		return sqlc.GetCompanyUserBranchAgentAndQuotaByUserIdRow{}, repoerror.BuildRepoErr("company_user", "GetCompanyUserBranchAgentAndQuotaByUserId", err)
	}
	return agent, nil
}

func (r *companyUserRepository) GetCompanyUserAgentAndQuotaByUserId(ctx *gin.Context, userID int64) (sqlc.GetCompanyUserAgentAndQuotaByUserIdRow, *exceptions.Exception) {
	agent, err := r.querier.GetCompanyUserAgentAndQuotaByUserId(ctx, userID)
	if err != nil {
		return sqlc.GetCompanyUserAgentAndQuotaByUserIdRow{}, repoerror.BuildRepoErr("company_user", "GetCompanyUserAgentAndQuotaByUserId", err)
	}
	return agent, nil
}

func (r *companyUserRepository) GetAllCompanyUsersByStatus(ctx *gin.Context, arg sqlc.GetAllCompanyUsersByStatusParams) ([]sqlc.GetAllCompanyUsersByStatusRow, *exceptions.Exception) {
	users, err := r.querier.GetAllCompanyUsersByStatus(ctx, arg)
	if err != nil {
		return nil, repoerror.BuildRepoErr("company_user", "GetAllCompanyUsersByStatus", err)
	}
	return users, nil
}

func (r *companyUserRepository) CountAllCompanyUsersByStatus(ctx *gin.Context, arg sqlc.CountAllCompanyUsersByStatusParams) (int64, *exceptions.Exception) {
	count, err := r.querier.CountAllCompanyUsersByStatus(ctx, arg)
	if err != nil {
		return 0, repoerror.BuildRepoErr("company_user", "CountAllCompanyUsersByStatus", err)
	}
	return count, nil
}

func (r *companyUserRepository) CreatePlatformUser(ctx *gin.Context, arg sqlc.CreatePlatformUserParams, q sqlc.Querier) (*sqlc.PlatformUser, *exceptions.Exception) {

	if q == nil {
		q = r.querier
	}
	user, err := q.CreatePlatformUser(ctx, arg)

	if err != nil {
		return nil, repoerror.BuildRepoErr("company_user", "CreatePlatformUser", err)
	}

	return &user, nil
}
