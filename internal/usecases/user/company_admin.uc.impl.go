package usecase

import (
	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"

	// permission "aqary_admin/old_repo/user/permissions"
	"log"
	"sort"
	"sync"

	db "aqary_admin/pkg/db/user"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/fn"
	"aqary_admin/pkg/utils/security"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
)

type CompanyAdminUseCase interface {
	AddCompanyAdminPermission(ctx *gin.Context, req domain.AddCompanyAdminPermissionRequest) (*sqlc.UserCompanyPermission, *exceptions.Exception)
	GetSingleUser(ctx *gin.Context, id int64, req domain.GetSingleUserReq) (*response.UserOutput, *exceptions.Exception)
}

type companyAdminUseCase struct {
	repo       db.UserCompositeRepo
	pool       *pgxpool.Pool
	tokenMaker security.Maker
}

func NewCompanyAdminUseCase(repo db.UserCompositeRepo, pool *pgxpool.Pool, token security.Maker) CompanyAdminUseCase {
	return &companyAdminUseCase{
		repo:       repo,
		pool:       pool,
		tokenMaker: token,
	}
}

func (uc *companyAdminUseCase) AddCompanyAdminPermission(ctx *gin.Context, req domain.AddCompanyAdminPermissionRequest) (*sqlc.UserCompanyPermission, *exceptions.Exception) {
	userId, err := uc.repo.GetUserIDFromCompanies(ctx, sqlc.GetUserIDFromCompaniesParams{
		ID:          req.Id,
		CompanyType: req.CompanyType,
	})
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}

	user, err := uc.repo.GetUser(ctx, userId)
	if err != nil {
		return nil, err
	}

	updatedUser, err := uc.repo.UpdateUserPermission(ctx, sqlc.UpdateUserPermissionParams{
		UserID:        user.ID,
		PermissionsID: req.Permissions,
		SubSectionsID: []int64{},
	})
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}

	return updatedUser, nil
}

func (uc *companyAdminUseCase) GetSingleUser(ctx *gin.Context, id int64, req domain.GetSingleUserReq) (*response.UserOutput, *exceptions.Exception) {

	user, er := uc.repo.GetUser(ctx, id)
	if er != nil {
		return nil, er
	}

	var output response.UserOutput
	output.ID = user.ID

	profile, _ := uc.repo.GetProfileByUserId(ctx, user.ID)
	// department, _ := uc.repo.GetDepartment(ctx, int32(user.Department.Int64))
	// role, _ := uc.repo.GetRole(ctx, user.RolesID.Int64,)
	address, _ := uc.repo.GetAddress(ctx, int32(profile.AddressesID))
	country, _ := uc.repo.GetCountry(ctx, int32(address.CountriesID.Int64))
	state, _ := uc.repo.GetState(ctx, int32(address.StatesID.Int64))
	city, _ := uc.repo.GetCity(ctx, int32(address.CitiesID.Int64))
	community, _ := uc.repo.GetCommunity(ctx, int32(address.CommunitiesID.Int64))
	subCommunity, _ := uc.repo.GetSubCommunity(ctx, int32(address.SubCommunitiesID.Int64))

	output.Username = user.Username
	output.FirstName = profile.FirstName
	output.LastName = profile.LastName
	output.Email = user.Email
	output.Phone = user.PhoneNumber.String
	output.UserTypeId = user.UserTypesID
	// output.Department = fn.CustomFormat{
	// 	ID:   department.ID,
	// 	Name: department.Title,
	// }

	// TODO: Need to fix this later
	// output.Role = fn.CustomFormat{
	// 	ID:   role.ID,
	// 	Name: role.Role,
	// }
	output.Country = fn.CustomFormat{
		ID:   country.ID,
		Name: country.Country,
	}
	output.State = fn.CustomFormat{
		ID:   state.ID,
		Name: state.State,
	}
	output.City = fn.CustomFormat{
		ID:   city.ID,
		Name: city.City,
	}

	output.Community = fn.CustomFormat{
		ID:   community.ID,
		Name: community.Community,
	}

	output.SubCommunity = fn.CustomFormat{
		ID:   subCommunity.ID,
		Name: subCommunity.SubCommunity,
	}

	//! testing new permissions

	// Fetch all section permissions without pagination.
	sections, er := uc.repo.GetAllSectionPermissionWithoutPagination(ctx)
	// If an error occurs during the fetch, respond with an internal server error and the error details.
	if er != nil {
		return nil, er
	}

	log.Println("testing section length", len(sections))

	// Initialize channels for managing section permissions and their asynchronous processing.
	sectionChan := make(chan response.CustomSectionPermission)
	processedSectionsChan := make(chan []response.CustomSectionPermission) // Channel to hold processed section permissions.

	// Initialize channels for managing quaternary sub-section permissions and their asynchronous processing.
	quaternaryPermissionChan := make(chan response.CustomAllQuaternarySubSectionPermission)
	processedQuaternaryPermissionChan := make(chan []response.CustomAllQuaternarySubSectionPermission)

	// Goroutine to collect all section permissions and send them through the processedSectionsChan.
	go func() {
		var allSection []response.CustomSectionPermission
		for s := range sectionChan {
			allSection = append(allSection, s)
		}
		sort.Slice(allSection, func(i, j int) bool {
			return allSection[i].ID < allSection[j].ID
		})
		processedSectionsChan <- allSection
	}()

	// Goroutine to collect all quaternary sub-section permissions and send them through the processedQuaternaryPermissionChan.
	go func() {
		var allQuaternary []response.CustomAllQuaternarySubSectionPermission
		for q := range quaternaryPermissionChan {
			allQuaternary = append(allQuaternary, q)
		}
		processedQuaternaryPermissionChan <- allQuaternary
	}()

	// getting the user pernmission
	userPerm, err := uc.repo.GetUserPermissionByID(ctx, sqlc.GetUserPermissionsByIDParams{
		IsCompanyUser: req.CompanyID,
		CompanyID: pgtype.Int8{
			Int64: req.CompanyID,
			Valid: true,
		},
		UserID: user.ID,
	})
	if err != nil {
		return nil, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())
	}

	var wg sync.WaitGroup // WaitGroup to manage the synchronization of goroutines processing the sections.
	// Iterate over each section fetched earlier.
	for _, section := range sections {

		wg.Add(1)                            // Increment the WaitGroup counter.
		go func(sp sqlc.SectionPermission) { // Launch a goroutine for each section.
			defer wg.Done() // Ensure the WaitGroup counter is decremented once the goroutine completes.
			// GetAllForSuperUserPermissionBySectionPermissionId
			ap, err := uc.repo.GetAllForSuperUserPermissionBySectionPermissionId(ctx, sp.ID)
			if err != nil {
				// middleware.IncrementErrorCounterWithoutEffect(fmt.Errorf("").Error())
				log.Println("testing error", err)
			}

			var permissionWg sync.WaitGroup                                        // WaitGroup for permissions within the current section.
			permissionResults := make(chan response.CustomAlllPermission, len(ap)) // Channel for processed permissions.

			permissionID := []int64{}
			for _, p := range ap {
				permissionID = append(permissionID, p.ID)
			}

			allowedPermission := utils.FindCommonPermissions(permissionID, userPerm.PermissionsID)
			for _, p := range utils.Ternary[[]int64](user.UserTypesID == 6, permissionID, allowedPermission) {
				permissionWg.Add(1) // Increment the permissions WaitGroup counter.
				go func(id int64) { // Launch a goroutine for each response.
					defer permissionWg.Done() // Decrement the permissions WaitGroup counter once complete.

					// Fetch all sub-sections for the current response.
					subSections, _ := uc.repo.GetAllSubSectionByPermissionID(ctx, id)
					log.Println("testing allowedPermission sub Section", subSections)

					var subSectionWg sync.WaitGroup                                                                // WaitGroup for sub-sections within the current response.
					subSectionResults := make(chan response.CustomSubSectionSecondaryPermission, len(subSections)) // Channel for processed sub-sections.

					allSubSectionIds := []int64{}
					for _, sub := range subSections {
						allSubSectionIds = append(allSubSectionIds, sub.ID)
					}
					allowedSubSection := utils.FindCommonPermissions(allSubSectionIds, userPerm.SubSectionsID)
					for _, subSection := range utils.Ternary[[]int64](user.UserTypesID == 6, allSubSectionIds, allowedSubSection) {
						subSectionWg.Add(1) // Increment the sub-sections WaitGroup counter.

						go func(subSection sqlc.SubSection) { // Launch a goroutine for each sub-section.
							defer subSectionWg.Done() // Decrement the sub-sections WaitGroup counter once complete.

							// Fetch all Ternary sub-section permissions for the current sub-section.
							TernarySubSections, _ := uc.repo.GetAllSubSectionPermissionBySubSectionButtonID(ctx, subSection.ID)
							var TernaryWg sync.WaitGroup                                                                                    // WaitGroup for Ternary sub-sections.
							TernarySubSectionResults := make(chan response.CustomAllSecondarySubSectionPermission, len(TernarySubSections)) // Channel for processed Ternary sub-sections.

							allTernarySubSectionIds := []int64{}
							for _, sub := range TernarySubSections {
								allTernarySubSectionIds = append(allTernarySubSectionIds, sub.ID)
							}
							allowedTernarySubSection := utils.FindCommonPermissions(allTernarySubSectionIds, userPerm.SubSectionsID)

							for _, TernaryPermission := range utils.Ternary[[]int64](user.UserTypesID == 6, permissionID, allowedTernarySubSection) {
								TernaryWg.Add(1)             // Increment the Ternary sub-sections WaitGroup counter.
								go func(t sqlc.SubSection) { // Launch a goroutine for each Ternary sub-section.
									defer TernaryWg.Done() // Decrement the Ternary sub-sections WaitGroup counter once complete.

									// Fetch all quaternary sub-section permissions for the current Ternary sub-section.
									quaternaryPermissions, _ := uc.repo.GetAllSubSectionPermissionBySubSectionButtonID(ctx, t.ID)
									var quaternaryWg sync.WaitGroup                                                                                       // WaitGroup for quaternary sub-sections.
									quaternaryPermissionResult := make(chan response.CustomAllQuaternarySubSectionPermission, len(quaternaryPermissions)) // Channel for processed quaternary sub-sections.

									allQuaternarySubSectionIds := []int64{}
									for _, sub := range quaternaryPermissions {
										allQuaternarySubSectionIds = append(allQuaternarySubSectionIds, sub.ID)
									}

									allowedQuaternarySubSection := utils.FindCommonPermissions(allQuaternarySubSectionIds, userPerm.SubSectionsID)

									for _, quaternary := range utils.Ternary[[]int64](user.UserTypesID == 6, permissionID, allowedQuaternarySubSection) {
										quaternaryWg.Add(1)          // Increment the quaternary sub-sections WaitGroup counter.
										go func(q sqlc.SubSection) { // Launch a goroutine for each quaternary sub-section.
											defer quaternaryWg.Done() // Decrement the quaternary sub-sections WaitGroup counter once complete.

											// Fetch all quinary sub-section permissions for the current quaternary sub-section.
											quinaryPermission, _ := uc.repo.GetAllSubSectionPermissionBySubSectionButtonID(ctx, q.ID)
											var quinaryPermissionWg sync.WaitGroup                                                                      // WaitGroup for quinary sub-sections.
											quinaryPermissionResult := make(chan response.CustomAllQuinarySubSectionPermission, len(quinaryPermission)) // Channel for processed quinary sub-sections.

											allQuinarySubSectionIds := []int64{}
											for _, sub := range quinaryPermission {
												allQuinarySubSectionIds = append(allQuinarySubSectionIds, sub.ID)
											}

											allowedQuinarySubSection := utils.FindCommonPermissions(allQuinarySubSectionIds, userPerm.SubSectionsID)
											for _, quinaryPermissionids := range utils.Ternary[[]int64](user.UserTypesID == 6, permissionID, allowedQuinarySubSection) {
												quinaryPermissionWg.Add(1)         // Increment the quinary sub-sections WaitGroup counter.
												go func(quinary sqlc.SubSection) { // Launch a goroutine for each quinary sub-section.
													defer quinaryPermissionWg.Done() // Decrement the quinary sub-sections WaitGroup counter once complete.

													// Process and send each quinary permission through the quinaryPermissionResult channel.
													processedQuinary := response.CustomAllQuinarySubSectionPermission{
														ID:                     quinary.ID,
														Label:                  quinary.SubSectionName,
														SubLabel:               quinary.SubSectionNameConstant,
														Indicator:              quinary.Indicator,
														PermissionID:           quinary.PermissionsID,
														PrimaryID:              id,
														SecondaryID:            subSection.ID,
														TernaryID:              t.ID,
														QuaternaryID:           q.ID,
														SubSectionButtonID:     quinary.SubSectionButtonID,
														SubSectionButtonAction: quinary.SubSectionButtonAction,
													}

													quinaryPermissionResult <- processedQuinary
												}(FindByID(quinaryPermission, quinaryPermissionids))
											}

											// Close the quinaryPermissionResult channel once all quinary permissions are processed.
											go func() {
												quinaryPermissionWg.Wait()
												close(quinaryPermissionResult)
											}()

											// Collect all processed quinary permissions.
											var allQuinaryPermission []response.CustomAllQuinarySubSectionPermission
											for quinary := range quinaryPermissionResult {
												allQuinaryPermission = append(allQuinaryPermission, quinary)
											}

											// Process and send the current quaternary permission through the quaternaryPermissionResult channel.
											processedQuaternary := response.CustomAllQuaternarySubSectionPermission{
												ID:                     q.ID,
												Label:                  q.SubSectionName,
												SubLabel:               q.SubSectionNameConstant,
												Indicator:              q.Indicator,
												PermissionID:           q.PermissionsID,
												PrimaryID:              id,
												SecondaryID:            subSection.ID,
												TernaryID:              t.ID,
												SubSectionButtonID:     q.SubSectionButtonID,
												SubSectionButtonAction: q.SubSectionButtonAction,
												QuinaryPermission:      allQuinaryPermission,
											}

											quaternaryPermissionResult <- processedQuaternary
										}(FindByID(quaternaryPermissions, quaternary))
									}

									// Close the quaternaryPermissionResult channel once all quaternary permissions are processed.
									go func() {
										quaternaryWg.Wait()
										close(quaternaryPermissionResult)
									}()

									// Collect all processed quaternary permissions and send them to the quaternaryPermissionChan.
									var allQuaternaryPermission []response.CustomAllQuaternarySubSectionPermission
									for quater := range quaternaryPermissionResult {
										allQuaternaryPermission = append(allQuaternaryPermission, quater)
										quaternaryPermissionChan <- quater
									}

									// Process and send the current Ternary sub-section through the TernarySubSectionResults channel.
									processedTernary := response.CustomAllSecondarySubSectionPermission{
										ID:                     t.ID,
										Label:                  t.SubSectionName,
										SubLabel:               t.SubSectionNameConstant,
										Indicator:              t.Indicator,
										PermissionID:           t.PermissionsID,
										PrimaryID:              id,
										SecondaryID:            subSection.ID,
										SubSectionButtonID:     t.SubSectionButtonID,
										SubSectionButtonAction: t.SubSectionButtonAction,
										QuaternaryPermission:   allQuaternaryPermission,
									}

									if processedTernary.ID != 0 {
										TernarySubSectionResults <- processedTernary
									}
								}(FindByID(TernarySubSections, TernaryPermission))
							}

							// Close the TernarySubSectionResults channel once all Ternary sub-sections are processed.
							go func() {
								TernaryWg.Wait()
								close(TernarySubSectionResults)
							}()

							// Collect all processed Ternary sub-sections.
							var allTernarySubSections = []response.CustomAllSecondarySubSectionPermission{}
							for Ternary := range TernarySubSectionResults {

								allTernarySubSections = append(allTernarySubSections, Ternary)
							}

							// Process and send the current sub-section through the subSectionResults channel.
							processedSubSection := response.CustomSubSectionSecondaryPermission{
								ID:                            subSection.ID,
								Label:                         subSection.SubSectionName,
								SubLabel:                      subSection.SubSectionNameConstant,
								Indicator:                     subSection.Indicator,
								PermissionID:                  subSection.PermissionsID,
								PrimaryID:                     id,
								SubSectionButtonID:            subSection.SubSectionButtonID,
								SubSectionButtonAction:        subSection.SubSectionButtonAction,
								CustomAllSubSectionPermission: allTernarySubSections,
							}
							if processedSubSection.ID != 0 {
								subSectionResults <- processedSubSection
							}
						}(FindByID(subSections, subSection))
					}

					// Close the subSectionResults channel once all sub-sections are processed.
					go func() {
						subSectionWg.Wait()
						close(subSectionResults)
					}()

					// Collect all processed sub-section permissions for the current response.
					var allSubSection = []response.CustomSubSectionSecondaryPermission{}
					for subSec := range subSectionResults {
						allSubSection = append(allSubSection, subSec)
					}

					// now getting further permission detail's
					p, _ := uc.repo.GetPermission(ctx, id)

					// Process and send the current permission through the permissionResults channel.
					permissionResults <- response.CustomAlllPermission{
						ID:                           p.ID,
						Label:                        p.Title,
						SubLabel:                     p.SubTitle.String,
						Indicator:                    p.Indicator,
						CustomAllSecondaryPermission: allSubSection,
					}
					// permissionResults <- processedPermission

				}(p)
			}

			// Close the permissionResults channel once all permissions have been processed.
			go func() {
				permissionWg.Wait()
				close(permissionResults)
			}()

			// Collect all processed permissions for the current section.
			var allPermissions []response.CustomAlllPermission
			for perm := range permissionResults {
				sort.Slice(allPermissions, func(i, j int) bool {
					return allPermissions[i].ID < allPermissions[j].ID
				})
				allPermissions = append(allPermissions, perm)
			}

			// Send the fully processed section, including all its permissions, to the sectionChan.
			if len(allPermissions) != 0 {
				sectionChan <- response.CustomSectionPermission{
					ID:               sp.ID,
					Label:            sp.Title,
					SubLabel:         sp.SubTitle.String,
					Indicator:        sp.Indicator,
					CustomPermission: allPermissions,
				}
			}

		}(section)
	}

	// Close the sectionChan and quaternaryPermissionChan once all sections have been processed.
	go func() {
		wg.Wait()
		close(sectionChan)
		close(quaternaryPermissionChan)
	}()

	output.Permission = <-processedSectionsChan
	return &output, nil
}

func FindByID(structs []sqlc.SubSection, id int64) sqlc.SubSection {
	for _, s := range structs {
		if s.ID == id {
			return s
		}
	}
	return sqlc.SubSection{}
}
