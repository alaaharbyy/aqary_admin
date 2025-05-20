package utils

import (
	"github.com/gin-gonic/gin"
)

//	ErrResponseSwagger represents the structure of error responses
//
// swagger:model
func ErrorResponse(err error) gin.H {
	return gin.H{"error": err.Error()}

}

func SuccessResponse(data interface{}) gin.H {
	return gin.H{"Message": "success", "data": data}
}

func SuccessResponseWithMain(data interface{}, is_main bool) gin.H {
	return gin.H{"Message": "success", "data": data, "is_main": is_main}
}


func SuccessResponseWithFactsCount(data interface{}, availableFactsCount interface{}) gin.H {
	return gin.H{"Message": "success", "available_fact_counts": availableFactsCount, "data": data}
}

func SuccessResponseWithPagenation(data interface{}, pagenation interface{}) gin.H {
	return gin.H{"Message": "success", "data": data, "Pagination": pagenation}
}

func SuccessResponseWithCount(data interface{}, count interface{}) gin.H {
	return gin.H{"Message": "success", "Total": count, "data": data}
}

func SuccessResponseWithCountAndIsMain(data interface{}, count interface{}, is_main bool) gin.H {
	return gin.H{"Message": "success", "Total": count, "data": data, "is_main": is_main}
}

func SuccessResponseWithCountWithFactsCount(data interface{}, count interface{}, availableFactsCount interface{}) gin.H {
	return gin.H{"Message": "success", "Total": count, "available_fact_counts": availableFactsCount, "data": data}
}

func SuccessResponseWithCountWithPermission(data interface{}, count interface{}, permission interface{}) gin.H {
	return gin.H{"Message": "success", "Total": count, "data": data, "privileges": permission}
}

func SuccessResponseWithPermission(data interface{}, permission interface{}) gin.H {
	return gin.H{"Message": "success", "data": data, "privileges": permission}
}

func SuccessResponseWithCountWithFactsCountWithPermission(data interface{}, count interface{}, availableFactsCount interface{}, permission interface{}) gin.H {
	return gin.H{"Message": "success", "Total": count, "available_fact_counts": availableFactsCount, "data": data, "privileges": permission}
}

func SuccessResponseWithFactsCountWithPermission(data interface{}, availableFactsCount interface{}, permission interface{}) gin.H {
	return gin.H{"Message": "success", "available_fact_counts": availableFactsCount, "data": data, "privileges": permission}
}
