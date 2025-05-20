package usecase

import (
	db "aqary_admin/pkg/db/user"
	"aqary_admin/pkg/utils/security"

	"aqary_admin/internal/domain/sqlc/sqlc"
	agent_usecase "aqary_admin/internal/usecases/user/agent"

	auth_usecase "aqary_admin/internal/usecases/user/auth"
	companyuser_usecase "aqary_admin/internal/usecases/user/company_user"
	department_usecase "aqary_admin/internal/usecases/user/department"
	permissions_usecase "aqary_admin/internal/usecases/user/permissions"

	role_usecase "aqary_admin/internal/usecases/user/roles"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/wagslane/go-rabbitmq"
)

type UserCompositeUseCaseImpl struct {
	agent_usecase.UserAgentUseCase
	department_usecase.DepartmentUseCase
	AqaryUserUseCase
	CheckEmailUseCase
	OtheruserUseCase
	CompanyAdminUseCase
	PendingUserUseCase
	ProfileUseCase
	UserUseCase
	role_usecase.RoleUseCase
	auth_usecase.AuthUseCase
	companyuser_usecase.CompanyUserUseCase
	permissions_usecase.PermissionUseCase
}

type UserCompositeUseCase interface {
	agent_usecase.UserAgentUseCase
	department_usecase.DepartmentUseCase
	AqaryUserUseCase
	CheckEmailUseCase
	CompanyAdminUseCase
	OtheruserUseCase
	PendingUserUseCase
	ProfileUseCase
	UserUseCase
	role_usecase.RoleUseCase
	auth_usecase.AuthUseCase
	companyuser_usecase.CompanyUserUseCase
	permissions_usecase.PermissionUseCase
}

func NewUserCompositeUseCaseModule(repo db.UserCompositeRepo, store sqlc.Store, pool *pgxpool.Pool, token security.Maker, rabbitClient *rabbitmq.Conn) UserCompositeUseCase {
	return UserCompositeUseCaseImpl{
		UserAgentUseCase:    agent_usecase.NewAgentUseCase(repo),
		DepartmentUseCase:   department_usecase.NewDepartmentUseCase(repo),
		AqaryUserUseCase:    NewAqaryUserUseCase(repo, store),
		CheckEmailUseCase:   NewCheckEmailUseCase(repo, pool, token),
		OtheruserUseCase:    NewOtheruserUseCase(repo),
		CompanyAdminUseCase: NewCompanyAdminUseCase(repo, pool, token),
		PendingUserUseCase:  NewPendingUserUseCase(repo, pool, token),
		ProfileUseCase:      NewProfileUseCase(repo, pool, token),
		UserUseCase:         NewUserUseCase(repo, pool, token),
		RoleUseCase:         role_usecase.NewRoleUseCase(repo, store, pool),
		AuthUseCase:         auth_usecase.NewAuthUseCase(repo, store, pool, token, rabbitClient),
		CompanyUserUseCase:  companyuser_usecase.NewCompanyUserUseCase(repo, store, pool),
		PermissionUseCase:   permissions_usecase.NewPermissionUseCase(repo, store),
	}
}
