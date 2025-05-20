package permissions_usecase

import (
	"log"
	"runtime"
	"strings"
	"sync"
	"time"

	domain "aqary_admin/internal/domain/requests/user"
	response "aqary_admin/internal/domain/responses/user"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/gin-gonic/gin"
	"golang.org/x/sync/semaphore"
)

func (uc *permissionUseCase) CreateSubSectionPermission(ctx *gin.Context, req domain.CreateSubSectionPermissionRequest) ([]*sqlc.SubSection, *exceptions.Exception) {

	subSectionNames := strings.Split(req.SubSectionName, ",")

	var output []*sqlc.SubSection
	// Iterate through the slice and insert each title into the database
	for _, subSectionName := range subSectionNames {
		// Trim spaces (if any) around the title
		subSectionName = strings.TrimSpace(subSectionName)
		slug := utils.CreateSlug(subSectionName)

		subSection, err := uc.repo.CreateSubSection(ctx, sqlc.CreateSubSectionParams{
			SubSectionName:         subSectionName,
			SubSectionNameConstant: slug,
			PermissionsID:          req.PermissionsID,
			Indicator:              req.Indicator,
			SubSectionButtonID:     req.SubSectionButtonID,
			SubSectionButtonAction: req.SubSectionButtonAction,
			CreatedAt:              time.Now(),
		})
		if err != nil {
			return nil, err
		}

		output = append(output, &subSection)

	}

	return output, nil
}

func (uc *permissionUseCase) GetAllSubSectionPermissionByPermission(ctx *gin.Context, permissionID int64) ([]response.SubSectionPermissionOutput, *exceptions.Exception) {
	subSections, err := uc.repo.GetAllSubSectionPermissionBySubSectionButtonID(ctx, permissionID)
	if err != nil {
		return nil, err
	}

	var output []response.SubSectionPermissionOutput
	for _, ss := range subSections {
		otherIds, _ := uc.repo.GetAllRelatedIDFromSubSection(ctx, ss.ID)
		output = append(output, response.SubSectionPermissionOutput{
			ID:                     ss.ID,
			Title:                  ss.SubSectionName,
			SubTitle:               ss.SubSectionNameConstant,
			Indicator:              ss.Indicator,
			SubSectionButtonID:     ss.SubSectionButtonID,
			SubSectionButtonAction: ss.SubSectionButtonAction,
			IsItEnd:                len(otherIds) == 0,
		})
	}
	return output, nil
}

func (uc *permissionUseCase) GetAllSubSectionPermission(ctx *gin.Context, req domain.GetAllPermissionRequest) ([]response.CustomAlllPermission, int64, *exceptions.Exception) {

	permissions, err := uc.repo.GetAllPermission(ctx, sqlc.GetAllPermissionParams{
		Limit:  int32(req.PageSize),
		Offset: int32((req.PageNo - 1) * req.PageSize),
	})
	if err != nil {
		return nil, 0, err
	}

	var customPermissions []response.CustomAlllPermission
	for _, p := range permissions {
		customPermission, err := uc.processPermissionForSub(ctx, p)
		if err != nil {
			return nil, 0, err
		}
		customPermissions = append(customPermissions, customPermission)
	}

	count, err := uc.repo.GetCountAllPermissionSectionIds(ctx)
	if err != nil {
		return nil, 0, err
	}

	return customPermissions, count, nil
}

func (uc *permissionUseCase) GetAllSubSectionPermissionWithoutPagination(ctx *gin.Context) ([]response.CustomAlllPermission, int64, *exceptions.Exception) {
	// subSections, err := uc.repo.GetAllIDANDPermissionsFromSubSectionPermissionWithoutPagination(ctx)
	// if err != nil {
	// 	return nil, 0, err
	// }

	// log.Println("total count of the sub section permissions", len(subSections))

	// var customPermissions []response.CustomAlllPermission
	// for _, ss := range subSections {
	// 	permission, err := uc.repo.GetPermission(ctx, ss.PermissionsID)
	// 	if err != nil {
	// 		log.Println("[GetPermission] err:", err)
	// 		// return nil, 0, err
	// 	}
	// 	customPermission, err := uc.processPermissionForSub(ctx, permission)
	// 	if err != nil {
	// 		log.Println("[processPermissionForSub] err:", err)
	// 		// return nil, 0, err
	// 	}
	// 	customPermissions = append(customPermissions, customPermission)
	// }

	// count, err := uc.repo.CountAllSubSection(ctx)
	// if err != nil {
	// 	return nil, 0, err
	// }

	subSections, err := uc.repo.GetAllIDANDPermissionsFromSubSectionPermissionWithoutPagination(ctx)
	if err != nil {
		return nil, 0, err
	}

	log.Println("total count of the sub section permissions", len(subSections))

	// Create a buffered channel to hold the results
	results := make(chan response.CustomAlllPermission, len(subSections))

	// Create a WaitGroup to wait for all goroutines to finish
	var wg sync.WaitGroup

	// Create a semaphore to limit the number of concurrent goroutines
	maxWorkers := runtime.GOMAXPROCS(2) // Use the number of CPUs as the max number of workers
	sem := semaphore.NewWeighted(int64(maxWorkers))

	// Fan out
	for _, ss := range subSections {
		wg.Add(1)
		go func(ss sqlc.GetAllIDANDPermissionsFromSubSectionPermissionWithoutPaginationRow) {
			defer wg.Done()

			// Acquire semaphore
			if err := sem.Acquire(ctx, 1); err != nil {
				log.Printf("Failed to acquire semaphore: %v", err)
				return
			}
			defer sem.Release(1)

			permission, err := uc.repo.GetPermission(ctx, ss.PermissionsID)
			if err != nil {
				log.Printf("[GetPermission] err: %v", err)
				return
			}

			customPermission, err := uc.processPermissionForSub(ctx, permission)
			if err != nil {
				log.Printf("[processPermissionForSub] err: %v", err)
				return
			}

			results <- customPermission
		}(ss)
	}

	// Close the results channel when all goroutines are done
	go func() {
		wg.Wait()
		close(results)
	}()

	// Fan in
	var customPermissions []response.CustomAlllPermission
	for customPermission := range results {
		customPermissions = append(customPermissions, customPermission)
	}

	count, err := uc.repo.CountAllSubSection(ctx)
	if err != nil {
		return nil, 0, err
	}

	return customPermissions, count, nil
}

func (uc *permissionUseCase) UpdateSubSectionPermission(ctx *gin.Context, id int64, req domain.UpdateSubSectionPermissionRequest) (*sqlc.SubSection, *exceptions.Exception) {
	subSection, err := uc.repo.GetSubSection(ctx, id)
	if err != nil {
		return nil, err
	}

	if req.SubSectionName == "" {
		req.SubSectionName = subSection.SubSectionName
	}
	if req.SubSectionNameConstant == "" {
		req.SubSectionNameConstant = subSection.SubSectionNameConstant
	}
	if req.PermissionsID == 0 {
		req.PermissionsID = subSection.PermissionsID
	}
	if req.Indicator == nil {
		req.Indicator = &subSection.Indicator
	}
	if req.SubSectionButtonID == 0 {
		req.SubSectionButtonID = subSection.SubSectionButtonID
	}
	if req.SubSectionButtonAction == "" {
		req.SubSectionButtonAction = subSection.SubSectionButtonAction
	}

	updatedSubSection, err := uc.repo.UpdateSubSection(ctx, sqlc.UpdateSubSectionParams{
		ID:                     id,
		SubSectionName:         req.SubSectionName,
		SubSectionNameConstant: req.SubSectionNameConstant,
		PermissionsID:          req.PermissionsID,
		Indicator:              *req.Indicator,
		SubSectionButtonID:     req.SubSectionButtonID,
		SubSectionButtonAction: req.SubSectionButtonAction,
		UpdatedAt:              time.Now(),
	})
	if err != nil {
		return nil, err
	}

	return &sqlc.SubSection{
		ID:                     updatedSubSection.ID,
		SubSectionName:         updatedSubSection.SubSectionName,
		SubSectionNameConstant: updatedSubSection.SubSectionNameConstant,
		PermissionsID:          updatedSubSection.PermissionsID,
		Indicator:              updatedSubSection.Indicator,
		SubSectionButtonID:     updatedSubSection.SubSectionButtonID,
		SubSectionButtonAction: updatedSubSection.SubSectionButtonAction,
	}, nil
}

func (uc *permissionUseCase) DeleteSubSectionPermission(ctx *gin.Context, id int64) *exceptions.Exception {
	subSection, err := uc.repo.GetSubSection(ctx, id)
	if err != nil {
		return err
	}

	nestedSubSections, err := uc.repo.GetAllRelatedIDFromSubSection(ctx, subSection.ID)
	if err != nil {
		return err
	}

	if err := uc.repo.DeleteAllSubSection(ctx, nestedSubSections); err != nil {
		return err
	}

	if err := uc.repo.DeleteSubSection(ctx, subSection.ID); err != nil {
		return err
	}

	return nil
}

func (uc *permissionUseCase) GetAllQuinarySubSectionPermissionWithoutPermission(ctx *gin.Context, req domain.GetAllPermissionRequest) ([]response.CustomAllQuaternarySubSectionPermission, int64, *exceptions.Exception) {

	// Fetch all section permissions without pagination.
	sections, er := uc.store.GetAllSectionPermissionWithoutPaginationMV(ctx, utils.AddPercent(req.Search))
	// If an error occurs during the fetch, respond with an internal server error and the error details.
	if er != nil {
		return []response.CustomAllQuaternarySubSectionPermission{}, 0, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())

	}

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

	var wg sync.WaitGroup // WaitGroup to manage the synchronization of goroutines processing the sections.
	start := (req.PageNo - 1) * req.PageSize
	end := start + req.PageSize
	total := 0

	log.Println("testing start and end ", start, end)

	// Iterate over each section fetched earlier.
	for _, section := range sections {

		wg.Add(1)                              // Increment the WaitGroup counter.
		go func(sp sqlc.SectionPermissionMv) { // Launch a goroutine for each section.
			defer wg.Done() // Ensure the WaitGroup counter is decremented once the goroutine completes.

			// Fetch all permissions for the current section.
			permissions, _ := uc.store.GetAllForSuperUserPermissionBySectionPermissionIdMV(ctx, sqlc.GetAllForSuperUserPermissionBySectionPermissionIdMVParams{
				Issuperuserid:       0,
				Permission:          []int64{},
				SectionPermissionID: sp.ID,
			})
			var permissionWg sync.WaitGroup                                                 // WaitGroup for permissions within the current section.
			permissionResults := make(chan response.CustomAlllPermission, len(permissions)) // Channel for processed permissions.

			for _, p := range permissions {
				permissionWg.Add(1)             // Increment the permissions WaitGroup counter.
				go func(p sqlc.PermissionsMv) { // Launch a goroutine for each permission.
					defer permissionWg.Done() // Decrement the permissions WaitGroup counter once complete.

					// Fetch all sub-sections for the current permission.
					subSections, _ := uc.store.GetAllSubSectionByPermissionIDMV(ctx, p.ID)
					var subSectionWg sync.WaitGroup                                                                // WaitGroup for sub-sections within the current permission.
					subSectionResults := make(chan response.CustomSubSectionSecondaryPermission, len(subSections)) // Channel for processed sub-sections.

					for _, subSection := range subSections {
						subSectionWg.Add(1)                     // Increment the sub-sections WaitGroup counter.
						go func(subSection sqlc.SubSectionMv) { // Launch a goroutine for each sub-section.
							defer subSectionWg.Done() // Decrement the sub-sections WaitGroup counter once complete.

							// Fetch all Ternary sub-section permissions for the current sub-section.
							TernarySubSections, _ := uc.store.GetAllSubSectionPermissionBySubSectionButtonID(ctx, subSection.ID)
							var TernaryWg sync.WaitGroup                                                                                    // WaitGroup for Ternary sub-sections.
							TernarySubSectionResults := make(chan response.CustomAllSecondarySubSectionPermission, len(TernarySubSections)) // Channel for processed Ternary sub-sections.

							for _, TernaryPermission := range TernarySubSections {
								TernaryWg.Add(1)             // Increment the Ternary sub-sections WaitGroup counter.
								go func(t sqlc.SubSection) { // Launch a goroutine for each Ternary sub-section.
									defer TernaryWg.Done() // Decrement the Ternary sub-sections WaitGroup counter once complete.
									// Fetch all quaternary sub-section permissions for the current Ternary sub-section.
									quaternaryPermissions, _ := uc.store.GetAllSubSectionPermissionBySubSectionButtonID(ctx, t.ID)
									var quaternaryWg sync.WaitGroup                                                                                       // WaitGroup for quaternary sub-sections.
									quaternaryPermissionResult := make(chan response.CustomAllQuaternarySubSectionPermission, len(quaternaryPermissions)) // Channel for processed quaternary sub-sections.

									for _, quaternary := range quaternaryPermissions {
										quaternaryWg.Add(1)          // Increment the quaternary sub-sections WaitGroup counter.
										go func(q sqlc.SubSection) { // Launch a goroutine for each quaternary sub-section.
											defer quaternaryWg.Done() // Decrement the quaternary sub-sections WaitGroup counter once complete.

											// Fetch all quinary sub-section permissions for the current quaternary sub-section.
											quinaryPermission, _ := uc.store.GetAllSubSectionPermissionBySubSectionButtonID(ctx, q.ID)
											var quinaryPermissionWg sync.WaitGroup                                                                      // WaitGroup for quinary sub-sections.
											quinaryPermissionResult := make(chan response.CustomAllQuinarySubSectionPermission, len(quinaryPermission)) // Channel for processed quinary sub-sections.

											for _, quinaryPermission := range quinaryPermission {
												quinaryPermissionWg.Add(1)         // Increment the quinary sub-sections WaitGroup counter.
												go func(quinary sqlc.SubSection) { // Launch a goroutine for each quinary sub-section.
													defer quinaryPermissionWg.Done() // Decrement the quinary sub-sections WaitGroup counter once complete.

													// Process and send each quinary permission through the quinaryPermissionResult channel.
													processedQuinary := response.CustomAllQuinarySubSectionPermission{
														ID:                     quinary.ID,
														Label:                  quinary.SubSectionName,
														SubLabel:               quinary.SubSectionNameConstant,
														Indicator:              quinary.Indicator,
														SubSectionButtonID:     quinary.SubSectionButtonID,
														SubSectionButtonAction: quinary.SubSectionButtonAction,
													}

													quinaryPermissionResult <- processedQuinary
												}(quinaryPermission)
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
												SubSectionButtonID:     q.SubSectionButtonID,
												SubSectionButtonAction: q.SubSectionButtonAction,
												QuinaryPermission:      allQuinaryPermission,
											}

											quaternaryPermissionResult <- processedQuaternary
										}(quaternary)
									}

									// Close the quaternaryPermissionResult channel once all quaternary permissions are processed.
									go func() {
										quaternaryWg.Wait()
										close(quaternaryPermissionResult)
									}()

									// Collect all processed quaternary permissions and send them to the quaternaryPermissionChan.
									var allQuaternaryPermission []response.CustomAllQuaternarySubSectionPermission
									for quater := range quaternaryPermissionResult {
										total++
										if total > int(start) && total <= int(end) {
											if end > int64(len(allQuaternaryPermission)) {
												allQuaternaryPermission = append(allQuaternaryPermission, quater)
												quaternaryPermissionChan <- quater
											}
										}
									}

									// Process and send the current Ternary sub-section through the TernarySubSectionResults channel.
									processedTernary := response.CustomAllSecondarySubSectionPermission{
										ID:                     t.ID,
										Label:                  t.SubSectionName,
										SubLabel:               t.SubSectionNameConstant,
										Indicator:              t.Indicator,
										SubSectionButtonID:     t.SubSectionButtonID,
										SubSectionButtonAction: t.SubSectionButtonAction,
										QuaternaryPermission:   allQuaternaryPermission,
									}

									TernarySubSectionResults <- processedTernary
								}(TernaryPermission)
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
								SubSectionButtonID:            subSection.SubSectionButtonID,
								SubSectionButtonAction:        subSection.SubSectionButtonAction,
								CustomAllSubSectionPermission: allTernarySubSections,
							}
							subSectionResults <- processedSubSection
						}(subSection)
					}

					// Close the subSectionResults channel once all sub-sections are processed.
					go func() {
						subSectionWg.Wait()
						close(subSectionResults)
					}()

					// Collect all processed sub-section permissions for the current permission.
					var allSubSection = []response.CustomSubSectionSecondaryPermission{}
					for subSec := range subSectionResults {
						allSubSection = append(allSubSection, subSec)
					}

					// Process and send the current permission through the permissionResults channel.
					processedPermission := response.CustomAlllPermission{
						ID:                           p.ID,
						Label:                        p.Title,
						SubLabel:                     p.SubTitle.String,
						Indicator:                    p.Indicator,
						CustomAllSecondaryPermission: allSubSection,
					}
					permissionResults <- processedPermission

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
				allPermissions = append(allPermissions, perm)
			}

			// Send the fully processed section, including all its permissions, to the sectionChan.
			sectionChan <- response.CustomSectionPermission{
				ID:               sp.ID,
				Label:            sp.Title,
				SubLabel:         sp.SubTitle.String,
				Indicator:        sp.Indicator,
				CustomPermission: allPermissions,
			}

		}(section)
	}

	// Close the sectionChan and quaternaryPermissionChan once all sections have been processed.
	go func() {
		wg.Wait()
		close(sectionChan)
		close(quaternaryPermissionChan)
	}()

	// Respond with the fully processed sections once all asynchronous processing is complete.
	// c.JSON(http.StatusOK, utils.SuccessResponseWithCount(<-processedQuaternaryPermissionChan, total))
	return <-processedQuaternaryPermissionChan, int64(total), nil
}

func (uc *permissionUseCase) GetAllNestedSubSectionPermissionWithoutPermissionByID(ctx *gin.Context, id int64) ([]sqlc.SubSection, *exceptions.Exception) {
	subSections, err := uc.repo.GetAllNestedSubSectionPermissonByButtonID(ctx, id)
	if err != nil {
		log.Println("[GetAllNestedSubSectionPermissonByButtonID] err", err)
		// return nil, err
	}

	log.Println("")

	var result []sqlc.SubSection
	for _, ss := range subSections {
		result = append(result, sqlc.SubSection{
			ID:                     ss.ID,
			SubSectionName:         ss.SubSectionName,
			SubSectionNameConstant: ss.SubSectionNameConstant,
			PermissionsID:          ss.PermissionsID,
			Indicator:              ss.Indicator,
			SubSectionButtonID:     ss.SubSectionButtonID,
			SubSectionButtonAction: ss.SubSectionButtonAction,
		})
	}

	return result, nil
}

func (uc *permissionUseCase) GetAllTertiarySubSectionPermissionWithoutPermission(ctx *gin.Context, req domain.GetAllPermissionRequest) ([]response.CustomSubSectionSecondaryPermission, int64, *exceptions.Exception) {

	subSection, er := uc.store.GetAllSectionPermissionWithoutPaginationMV(ctx, utils.AddPercent(req.Search))
	if er != nil {
		return []response.CustomSubSectionSecondaryPermission{}, 0, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())
	}

	log.Println("testing subSections", len(subSection))

	customSectionPermission := response.CustomSectionPermission{}
	customSectionPermissions := make([]response.CustomSectionPermission, 0)

	customTernaryPermission := response.CustomAllSecondarySubSectionPermission{}
	customTernaryPermissions := make([]response.CustomAllSecondarySubSectionPermission, 0)

	customAllSecondaryPermission := response.CustomSubSectionSecondaryPermission{}
	customAllSecondaryPermissions := []response.CustomSubSectionSecondaryPermission{}
	containTertairyIds := []int64{}
	containSecondaryIds := []int64{}
	// start := (req.PageNo - 1) * req.PageSize
	// end := start + req.PageSize
	start := (req.PageNo - 1) * req.PageSize
	end := start + req.PageSize
	total := 0

	for i := range subSection {

		//! section permission
		customSectionPermission.ID = subSection[i].ID
		customSectionPermission.Label = subSection[i].Title
		customSectionPermission.SubLabel = subSection[i].SubTitle.String
		customSectionPermission.Indicator = subSection[i].Indicator

		//! permissions ..
		customAllPermission := response.CustomAlllPermission{}
		customAllPermissions := []response.CustomAlllPermission{}

		permission, _ := uc.store.GetAllForSuperUserPermissionBySectionPermissionIdMV(ctx, sqlc.GetAllForSuperUserPermissionBySectionPermissionIdMVParams{
			Issuperuserid:       0,
			Permission:          []int64{},
			SectionPermissionID: subSection[i].ID,
		})

		if len(permission) != 0 {
			for p := range permission {

				customAllPermission.ID = permission[p].ID
				customAllPermission.Label = permission[p].Title
				customAllPermission.SubLabel = permission[p].SubTitle.String
				customAllPermission.Indicator = permission[p].Indicator
				//  ! secondary permissions ...
				secondaryPermission, _ := uc.store.GetAllSubSectionByPermissionIDMV(ctx, permission[p].ID)
				if len(secondaryPermission) != 0 {
					for s := range secondaryPermission {
						total++
						if utils.ContainsInt(containSecondaryIds, secondaryPermission[s].ID) {
							// ! skip
						} else {
							if total > int(start) && total <= int(end) {
								if end > int64(len(customAllSecondaryPermissions)) {
									customAllSecondaryPermission.ID = secondaryPermission[s].ID
									customAllSecondaryPermission.Label = secondaryPermission[s].SubSectionName
									customAllSecondaryPermission.SubLabel = secondaryPermission[s].SubSectionNameConstant
									customAllSecondaryPermission.Indicator = secondaryPermission[s].Indicator
									customAllSecondaryPermission.SubSectionButtonID = secondaryPermission[s].SubSectionButtonID
									customAllSecondaryPermission.SubSectionButtonAction = secondaryPermission[s].SubSectionButtonAction
									// ! Ternary permission ....
									tertairyPermission, _ := uc.store.GetAllSubSectionPermissionBySubSectionButtonIDMV(ctx, sqlc.GetAllSubSectionPermissionBySubSectionButtonIDMVParams{
										IsSuperUser:        0,
										SubSectionID:       []int64{},
										SubSectionButtonID: secondaryPermission[s].ID,
									})
									if len(tertairyPermission) != 0 {
										for t := range tertairyPermission {

											if utils.ContainsInt(containTertairyIds, tertairyPermission[t].ID) {
												// ! skip
											} else {
												customTernaryPermission.ID = tertairyPermission[t].ID
												customTernaryPermission.Label = tertairyPermission[t].SubSectionName
												customTernaryPermission.SubLabel = tertairyPermission[t].SubSectionNameConstant
												customTernaryPermission.Indicator = tertairyPermission[t].Indicator
												customTernaryPermission.SubSectionButtonID = tertairyPermission[t].SubSectionButtonID
												customTernaryPermission.SubSectionButtonAction = tertairyPermission[t].SubSectionButtonAction

												customTernaryPermissions = append(customTernaryPermissions, customTernaryPermission)
												containTertairyIds = append(containTertairyIds, customTernaryPermission.ID)
											}
										}
									}
									// if customAllSecondaryPermission.ID != 0 {
									// pagination here ...
									// if end > int32(len(customAllSecondaryPermissions)) {
									// end = int32(len(customAllSecondaryPermissions))
									// if len(customTernaryPermissions) != 0 {
									customAllSecondaryPermission.CustomAllSubSectionPermission = customTernaryPermissions
									customAllSecondaryPermissions = append(customAllSecondaryPermissions, customAllSecondaryPermission)
									containSecondaryIds = append(containSecondaryIds, customAllSecondaryPermission.ID)
									// }
									// }
									customTernaryPermissions = []response.CustomAllSecondarySubSectionPermission{}
									// } else {
									// 	customAllSecondaryPermission.CustomAllSubSectionPermission = []CustomAllSecondarySubSectionPermission{}
									// }
								}

							}

						}

					}

				}

				if customAllPermission.ID != 0 {
					customAllPermission.CustomAllSecondaryPermission = customAllSecondaryPermissions
					customAllPermissions = append(customAllPermissions, customAllPermission)
				} else {
					customAllPermission.CustomAllSecondaryPermission = []response.CustomSubSectionSecondaryPermission{}
				}
			}
		}
		if customSectionPermission.ID != 0 {
			customSectionPermission.CustomPermission = customAllPermissions
			customSectionPermissions = append(customSectionPermissions, customSectionPermission)
		} else {
			customSectionPermission = response.CustomSectionPermission{}
			customSectionPermissions = []response.CustomSectionPermission{}
		}

	}
	return customAllSecondaryPermissions, int64(total), nil
}

func (uc *permissionUseCase) GetAllQuaternarySubSectionPermissionWithoutPermission(ctx *gin.Context, req domain.GetAllPermissionRequest) ([]response.CustomAllSecondarySubSectionPermission, int64, *exceptions.Exception) {

	subSection, er := uc.store.GetAllSectionPermissionWithoutPaginationMV(ctx, utils.AddPercent(req.Search))
	if er != nil {
		return []response.CustomAllSecondarySubSectionPermission{}, 0, exceptions.GetExceptionByErrorCodeWithCustomMessage(exceptions.SomethingWentWrongErrorCode, er.Error())

	}

	customSectionPermission := response.CustomSectionPermission{}
	customSectionPermissions := make([]response.CustomSectionPermission, 0)

	customQuaternaryPermission := response.CustomAllQuaternarySubSectionPermission{}
	customQuaternaryPermissions := make([]response.CustomAllQuaternarySubSectionPermission, 0)

	customTernaryPermission := response.CustomAllSecondarySubSectionPermission{}
	customTernaryPermissions := make([]response.CustomAllSecondarySubSectionPermission, 0)

	containTernaryIds := []int64{}
	start := (req.PageNo - 1) * req.PageSize
	end := start + req.PageSize
	total := 0

	for i := range subSection {

		//! section permission
		if !response.ContainAllSectionId(customSectionPermissions, subSection[i].ID) {
			customSectionPermission.ID = subSection[i].ID
			customSectionPermission.Label = subSection[i].Title
			customSectionPermission.SubLabel = subSection[i].SubTitle.String
			customSectionPermission.Indicator = subSection[i].Indicator

			//! permissions ..
			customAllPermission := response.CustomAlllPermission{}
			// customAllPermissions := []CustomAlllPermission{}

			permission, _ := uc.store.GetAllForSuperUserPermissionBySectionPermissionIdMV(ctx, sqlc.GetAllForSuperUserPermissionBySectionPermissionIdMVParams{
				Issuperuserid:       0,
				Permission:          []int64{},
				SectionPermissionID: subSection[i].ID,
			})

			if len(permission) != 0 {
				for p := range permission {
					customAllPermission.ID = permission[p].ID
					customAllPermission.Label = permission[p].Title
					customAllPermission.SubLabel = permission[p].SubTitle.String
					customAllPermission.Indicator = permission[p].Indicator

					//  ! secondary permissions ...
					customAllSecondaryPermission := response.CustomSubSectionSecondaryPermission{}
					customAllSecondaryPermissions := []response.CustomSubSectionSecondaryPermission{}

					secondaryPermission, _ := uc.store.GetAllSubSectionByPermissionID(ctx, permission[p].ID)
					if len(secondaryPermission) != 0 {
						for s := range secondaryPermission {
							customAllSecondaryPermission.ID = secondaryPermission[s].ID
							customAllSecondaryPermission.Label = secondaryPermission[s].SubSectionName
							customAllSecondaryPermission.SubLabel = secondaryPermission[s].SubSectionNameConstant
							customAllSecondaryPermission.Indicator = secondaryPermission[s].Indicator
							customAllSecondaryPermission.SubSectionButtonID = secondaryPermission[s].SubSectionButtonID
							customAllSecondaryPermission.SubSectionButtonAction = secondaryPermission[s].SubSectionButtonAction

							// ! Ternary permission ....
							tertairyPermission, _ := uc.store.GetAllSubSectionPermissionBySubSectionButtonID(ctx, secondaryPermission[s].ID)
							if len(tertairyPermission) != 0 {
								for t := range tertairyPermission {
									total++
									if utils.ContainsInt(containTernaryIds, tertairyPermission[t].ID) {
									} else {

										if total > int(start) && total <= int(end) {
											if end > int64(len(customAllSecondaryPermissions)) {

												customTernaryPermission.ID = tertairyPermission[t].ID
												customTernaryPermission.Label = tertairyPermission[t].SubSectionName
												customTernaryPermission.SubLabel = tertairyPermission[t].SubSectionNameConstant
												customTernaryPermission.Indicator = tertairyPermission[t].Indicator
												customTernaryPermission.SubSectionButtonID = tertairyPermission[t].SubSectionButtonID
												customTernaryPermission.SubSectionButtonAction = tertairyPermission[t].SubSectionButtonAction
												// ! quaternary permission .....

												quaternaryPermission, _ := uc.store.GetAllSubSectionPermissionBySubSectionButtonIDMV(ctx, sqlc.GetAllSubSectionPermissionBySubSectionButtonIDMVParams{
													IsSuperUser:        0,
													SubSectionID:       []int64{},
													SubSectionButtonID: tertairyPermission[t].ID,
												})
												if len(quaternaryPermission) != 0 {
													for q := range quaternaryPermission {

														// ! checking if contain

														if !response.ContainQuaternaryId(customQuaternaryPermissions, quaternaryPermission[q].ID) {
															customQuaternaryPermission.ID = quaternaryPermission[q].ID
															customQuaternaryPermission.Label = quaternaryPermission[q].SubSectionName
															customQuaternaryPermission.SubLabel = quaternaryPermission[q].SubSectionNameConstant
															customQuaternaryPermission.Indicator = quaternaryPermission[q].Indicator
															customQuaternaryPermission.SubSectionButtonID = quaternaryPermission[q].SubSectionButtonID
															customQuaternaryPermission.SubSectionButtonAction = quaternaryPermission[q].SubSectionButtonAction

															if customQuaternaryPermission.ID != 0 {
																customQuaternaryPermissions = append(customQuaternaryPermissions, customQuaternaryPermission)
															} else {
																customQuaternaryPermissions = []response.CustomAllQuaternarySubSectionPermission{}
															}
														}

													}
												}

												customTernaryPermission.QuaternaryPermission = customQuaternaryPermissions
												customTernaryPermissions = append(customTernaryPermissions, customTernaryPermission)
												containTernaryIds = append(containTernaryIds, customTernaryPermission.ID)
												customQuaternaryPermissions = []response.CustomAllQuaternarySubSectionPermission{}

												customQuaternaryPermission = response.CustomAllQuaternarySubSectionPermission{}
											}
										}

									}
								}
							}

						}

					}

				}
			}

		}

	}

	return customTernaryPermissions, int64(total), nil
}

// for  permission
func (uc *permissionUseCase) processPermissionForSub(ctx *gin.Context, p sqlc.Permission) (response.CustomAlllPermission, *exceptions.Exception) {
	subSections, err := uc.repo.GetAllSubSectionByPermissionID(ctx, p.ID)
	if err != nil {
		log.Println("[GetAllSubSectionByPermissionID] err", err)
		// return response.CustomAlllPermission{}, err
	}

	var customSubSections []response.CustomSubSectionSecondaryPermission
	for _, ss := range subSections {
		customSubSection, err := uc.processSubSectionForSub(ctx, ss)
		if err != nil {
			log.Println("[processSubSectionForSub] err", err)
			// return response.CustomAlllPermission{}, err
		}
		if customSubSection.ID != 0 {
			customSubSections = append(customSubSections, customSubSection)
		}
	}

	return response.CustomAlllPermission{
		ID:                           p.ID,
		Label:                        p.Title,
		SubLabel:                     p.SubTitle.String,
		Indicator:                    p.Indicator,
		CustomAllSecondaryPermission: customSubSections,
	}, nil
}

// for secondary permission
func (uc *permissionUseCase) processSubSectionForSub(ctx *gin.Context, ss sqlc.SubSection) (response.CustomSubSectionSecondaryPermission, *exceptions.Exception) {

	return response.CustomSubSectionSecondaryPermission{
		ID:                            ss.ID,
		Label:                         ss.SubSectionName,
		SubLabel:                      ss.SubSectionNameConstant,
		Indicator:                     ss.Indicator,
		PermissionID:                  ss.PermissionsID,
		SubSectionButtonID:            ss.SubSectionButtonID,
		SubSectionButtonAction:        ss.SubSectionButtonAction,
		CustomAllSubSectionPermission: nil,
	}, nil
}

func (uc *permissionUseCase) processSectionForQuinary(ctx *gin.Context, s sqlc.SectionPermissionMv, wg *sync.WaitGroup, quaternaryChan chan<- response.CustomAllQuaternarySubSectionPermission, start, end *int64, total *int) {
	permissions, err := uc.repo.GetAllForSuperUserPermissionBySectionPermissionIdMV(ctx, s.ID, 0, nil) // it will be for super admin so we can pass nil & zero
	if err != nil {
		log.Println("[GetAllForSuperUserPermissionBySectionPermissionIdMV] err", err)
		// return
	}

	for _, p := range permissions {
		subSections, err := uc.repo.GetAllSubSectionByPermissionIDMV(ctx, sqlc.GetAllSubSectionByPermissionIDMVWithRelationParams{
			IsSuperUser:   0,
			SubSectionsID: []int64{},
			PermissionsID: p.ID,
		})
		if err != nil {
			continue
		}

		for _, ss := range subSections {
			ternarySubSections, err := uc.repo.GetAllSubSectionPermissionBySubSectionButtonIDMV(ctx, sqlc.GetAllSubSectionPermissionBySubSectionButtonIDMVParams{
				IsSuperUser:        0,
				SubSectionButtonID: ss.ID,
			})
			if err != nil {
				continue
			}

			for _, ts := range ternarySubSections {
				quaternarySubSections, err := uc.repo.GetAllSubSectionPermissionBySubSectionButtonIDMV(ctx, sqlc.GetAllSubSectionPermissionBySubSectionButtonIDMVParams{
					IsSuperUser:        0,
					SubSectionButtonID: ts.ID,
				})
				if err != nil {
					continue
				}

				for _, qs := range quaternarySubSections {
					*total++
					if int64(*total) > *start && int64(*total) <= *end {
						quinarySubSections, err := uc.repo.GetAllSubSectionPermissionBySubSectionButtonIDMV(ctx, sqlc.GetAllSubSectionPermissionBySubSectionButtonIDMVParams{
							IsSuperUser:        0,
							SubSectionButtonID: qs.ID,
						})
						if err != nil {
							continue
						}

						var customQuinarySubSections []response.CustomAllQuinarySubSectionPermission
						for _, qns := range quinarySubSections {
							customQuinary := response.CustomAllQuinarySubSectionPermission{
								ID:                     qns.ID,
								Label:                  qns.SubSectionName,
								SubLabel:               qns.SubSectionNameConstant,
								Indicator:              qns.Indicator,
								PermissionID:           qns.PermissionsID,
								PrimaryID:              p.ID,
								SecondaryID:            ss.ID,
								TernaryID:              ts.ID,
								QuaternaryID:           qs.ID,
								SubSectionButtonID:     qns.SubSectionButtonID,
								SubSectionButtonAction: qns.SubSectionButtonAction,
							}
							customQuinarySubSections = append(customQuinarySubSections, customQuinary)
						}

						quaternaryChan <- response.CustomAllQuaternarySubSectionPermission{
							ID:                     qs.ID,
							Label:                  qs.SubSectionName,
							SubLabel:               qs.SubSectionNameConstant,
							Indicator:              qs.Indicator,
							PermissionID:           qs.PermissionsID,
							PrimaryID:              p.ID,
							SecondaryID:            ss.ID,
							TernaryID:              ts.ID,
							SubSectionButtonID:     qs.SubSectionButtonID,
							SubSectionButtonAction: qs.SubSectionButtonAction,
							QuinaryPermission:      customQuinarySubSections,
						}
					}
				}
			}
		}
	}
}
