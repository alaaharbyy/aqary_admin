package helper

import (
	"net/http"
	"strconv"

	"aqary_admin/internal/domain/dto"
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/exceptions"
	"aqary_admin/pkg/utils/out"

	"github.com/gin-gonic/gin"
)

type ApiResponse struct {
	Error string `json:"error" example:"any error message"`
}

func SendApiResponseV1(c *gin.Context, err *exceptions.Exception, data interface{}) {

	if err.Error() == "" {
		err = nil
	}

	switch {
	case err == nil:
		c.JSON(http.StatusOK, utils.SuccessResponse(data))
	default:
		c.JSON(err.HttpCode, utils.ErrorResponse(err))
	}

}

func SendApiResponseWithMain(c *gin.Context, err *exceptions.Exception, data interface{}, is_main bool) {

	if err.Error() == "" {
		err = nil
	}

	switch {
	case err == nil:
		c.JSON(http.StatusOK, utils.SuccessResponseWithMain(data, is_main))
	default:
		c.JSON(err.HttpCode, utils.ErrorResponse(err))
	}

}

func SendApiResponseWithCountV1(c *gin.Context, err *exceptions.Exception, data interface{}, count interface{}) {

	if err != nil {

		c.JSON(err.HttpCode, utils.ErrorResponse(err))
		return

	}

	c.JSON(http.StatusOK, utils.SuccessResponseWithCount(data, count))
}

func SendApiResponseWithCountAndMain(c *gin.Context, err *exceptions.Exception, data interface{}, count interface{}, is_main bool) {

	if err != nil {

		c.JSON(err.HttpCode, utils.ErrorResponse(err))
		return

	}

	c.JSON(http.StatusOK, utils.SuccessResponseWithCountAndIsMain(data, count, is_main))
}

func SendApiResponseWithAvailableFactsV1(c *gin.Context, err *exceptions.Exception, data interface{}, availableFacts interface{}) {

	// log.Println("testing errm, ", err, "::", stat)

	if err != nil {

		c.JSON(err.HttpCode, utils.ErrorResponse(err))
		return

	}

	c.JSON(http.StatusOK, utils.SuccessResponseWithFactsCount(data, availableFacts))
}

func SendApiResponseWithCountWithPermissionV1(c *gin.Context, err *exceptions.Exception, data interface{}, count interface{}, permission interface{}) {

	if err.Error() == "" {
		err = nil
	}

	switch {
	case err == nil:
		c.JSON(http.StatusOK, utils.SuccessResponseWithCountWithPermission(data, count, permission))
	default:
		c.JSON(err.HttpCode, utils.ErrorResponse(err)) // TODO need error response with permission also for not found error
	}

}

func SendApiResponseWithCountWithPermissionV1andMain(c *gin.Context, err *exceptions.Exception, data interface{}, count interface{}, is_main bool, permission interface{}) {

	if err.Error() == "" {
		err = nil
	}

	switch {
	case err == nil:
		c.JSON(http.StatusOK, utils.SuccessResponseWithCountWithPermission(data, count, permission))
	default:
		c.JSON(err.HttpCode, utils.ErrorResponse(err)) // TODO need error response with permission also for not found error
	}

}

func SendApiResponseWithPermissionV1(c *gin.Context, err *exceptions.Exception, data interface{}, permission interface{}) {

	if err.Error() == "" {
		err = nil
	}

	switch {
	case err == nil:
		c.JSON(http.StatusOK, utils.SuccessResponseWithPermission(data, permission))
	default:
		c.JSON(err.HttpCode, utils.ErrorResponse(err)) // TODO need error response with permission also for not found error
	}

}
func ConvertIntergerToPointer(i int) *int {
	return &i
}

const (
	DefaultPage      = 1
	DefaultPageLimit = 10
)

func ReadListParams(ctx *gin.Context) dto.ListParams {
	pageStr := ctx.Query("page")
	limitStr := ctx.Query("limit")
	search := ctx.Query("search")
	// Convert page and limit to integers with default values
	page, err := strconv.Atoi(pageStr)
	if err != nil || page <= 0 {
		page = DefaultPage
	}

	limit, err := strconv.Atoi(limitStr)
	if err != nil || limit <= 0 {
		limit = DefaultPageLimit
	}

	return dto.ListParams{
		Page:   int32(page),
		Limit:  int32(limit),
		Search: search,
	}
}

// func CustomJsonOutPut(c *gin.Context, section string, store sqlc.Querier, visitedUser sqlc.User, output any, totalCount any) {
// 	if visitedUser.UserTypesID != 6 {
// 		customSubSectionPermissions, _ := FilterSubSectionPermission(c, store, visitedUser, section)
// 		c.JSON(http.StatusOK, utils.SuccessResponseWithCountWithPermission(output, totalCount, customSubSectionPermissions))
// 	} else {
// 		c.JSON(http.StatusOK, utils.SuccessResponseWithCountWithPermission(output, totalCount, true))
// 	}
// }

func CustomJsonOutPutWithFacts(c *gin.Context, section string, store sqlc.Querier, visitedUser sqlc.User, output any, totalCount any, facts any) {
	if visitedUser.UserTypesID != 6 {
		// customSubSectionPermissions, _ := out.FilterSubSectionPermission(c, store, visitedUser, section)
		var customSubSectionPermissions []out.CustomAllSubSectionPermission
		c.JSON(http.StatusOK, utils.SuccessResponseWithCountWithFactsCountWithPermission(output, totalCount, facts, customSubSectionPermissions))
	} else {
		c.JSON(http.StatusOK, utils.SuccessResponseWithCountWithFactsCountWithPermission(output, totalCount, facts, true))
	}
}
