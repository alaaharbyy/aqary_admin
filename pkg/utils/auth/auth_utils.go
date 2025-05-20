package auth_utils

import (
	"aqary_admin/internal/domain/sqlc/sqlc"

	"context"

	// utils "aqary_admin/pkg/utils"
	utils "aqary_admin/pkg/utils"

	"github.com/gin-gonic/gin"
)

// second store is server.SQLStore and first store sqlc.Querier
// func CheckAuthForTests(c *gin.Context, secondStore sqlc.Querier, firstStore sqlc.Querier) (sqlc.Querier, sqlc.Querier) {
// 	log.Println("testing store ")
// 	if len(middleware.AuthurizationHeader) != 0 {
// 		if os.Getenv("ENVIRONMENT") == "DEV" || os.Getenv("ENVIRONMENT") == "TEST" {
// 			authPayload := c.MustGet(middleware.AuthorizationPayloadKey).(*security.Payload)
// 			if authPayload.Username == middleware.TestUser {
// 				firstStore = secondStore
// 			}
// 		}
// 	}
// 	return secondStore, firstStore
// }

// // second store is server.SQLStore and first store sqlc.Querier
// func CheckAuthForTests(c *gin.Context, secondStore sqlc.Querier, firstStore sqlc.Querier) (sqlc.Querier, sqlc.Querier) {

// 	if firstStore == nil {
// 		return secondStore, secondStore
// 	}

// 	log.Println("testing , ", secondStore, "::;", firstStore)
// 	if utils.IS_TEST_MODE {
// 		// If running tests, use sqlc.Querier
// 		firstStore = secondStore
// 	}
// 	return secondStore, firstStore
// }

// second store is server.SQLStore and first store sqlc.Querier
func CheckAuthForTests(c context.Context, secondStore sqlc.Querier, firstStore sqlc.Querier) (sqlc.Querier, sqlc.Querier) {

	if firstStore == nil {
		return secondStore, secondStore
	}

	if utils.IS_TEST_MODE {
		// If running tests, use sqlc.Querier
		firstStore = secondStore
	}
	return secondStore, firstStore
}

func GinContextToContextMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx := context.WithValue(c.Request.Context(), `GinContextKey`, c)
		c.Request = c.Request.WithContext(ctx)
		c.Next()
	}
}
