package out

import (
	"log"
	"net/http"
	"sync"

	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils"

	"github.com/gin-gonic/gin"
)

func FilterSubSectionPermission(c *gin.Context, store sqlc.Querier, visitedUser sqlc.User, section string) ([]CustomAllSubSectionPermission, error) {

	subSection, err := store.FetchbuttonPermissionForSubSectionsForUser(c, sqlc.FetchbuttonPermissionForSubSectionsForUserParams{
		UserID:            visitedUser.ID,
		SectionButtonName: utils.AddPercent(section),
	})

	log.Println("testing subSection ", subSection, section, "::", visitedUser.ID)

	if err != nil {
		return []CustomAllSubSectionPermission{}, err
	}

	subSectionChan := make(chan CustomAllSubSectionPermission)
	processedSubSection := make(chan []CustomAllSubSectionPermission, len(subSection))

	go func() {
		allSubSection := []CustomAllSubSectionPermission{}
		for section := range subSectionChan {
			if section.ID != 0 {
				allSubSection = append(allSubSection, section)
			}
		}
		processedSubSection <- allSubSection
	}()

	var wg sync.WaitGroup
	for i := range subSection {
		wg.Add(1)

		go func(i int) {
			defer wg.Done()
			section, _ := store.GetSubSection(c, (subSection[i].ID))
			subSectionChan <- CustomAllSubSectionPermission{
				ID:                     section.ID,
				Label:                  section.SubSectionName,
				SubLabel:               section.SubSectionNameConstant,
				Indicator:              section.Indicator,
				SubSectionButtonID:     section.SubSectionButtonID,
				SubSectionButtonAction: section.SubSectionButtonAction,
			}

		}(i)
	}

	go func() {
		wg.Wait()
		close(subSectionChan)
	}()

	return <-processedSubSection, nil
}

func CustomJsonOutPut(c *gin.Context, section string, store sqlc.Querier, visitedUser sqlc.User, output any, totalCount any) {
	if visitedUser.UserTypesID != 6 {
		customSubSectionPermissions, _ := FilterSubSectionPermission(c, store, visitedUser, section)
		c.JSON(http.StatusOK, utils.SuccessResponseWithCountWithPermission(output, totalCount, customSubSectionPermissions))
	} else {
		c.JSON(http.StatusOK, utils.SuccessResponseWithCountWithPermission(output, totalCount, true))
	}
}

func CustomJsonOutPutWithFacts(c *gin.Context, section string, store sqlc.Querier, visitedUser sqlc.User, output any, totalCount any, facts any) {
	if visitedUser.UserTypesID != 6 {
		customSubSectionPermissions, _ := FilterSubSectionPermission(c, store, visitedUser, section)
		c.JSON(http.StatusOK, utils.SuccessResponseWithCountWithFactsCountWithPermission(output, totalCount, facts, customSubSectionPermissions))
	} else {
		c.JSON(http.StatusOK, utils.SuccessResponseWithCountWithFactsCountWithPermission(output, totalCount, facts, true))
	}
}
