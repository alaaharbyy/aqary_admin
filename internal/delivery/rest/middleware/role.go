package middleware

import (
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils/security"

	"errors"
	"net/http"

	"aqary_admin/pkg/utils"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
)

func CheckPermission(store sqlc.Querier, permissionList []string) gin.HandlerFunc {
	return func(c *gin.Context) {
		authPayload := c.MustGet(AuthorizationPayloadKey).(*security.Payload)

		user, err := store.GetUserByName(c, authPayload.Username)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				c.JSON(http.StatusNotFound, utils.ErrorResponse(errors.New("no user found")))
				return
			}
			c.JSON(http.StatusUnauthorized, utils.ErrorResponse(errors.New("not authorized")))
			c.Abort()
			return
		}

		//! it's a super user
		if user.UserTypesID == 6 {
			c.Next()
			return
		}

		// TODO: need to handle  the company id also...

		// for _, permission := range user.PermissionsID {
		// 	p, _ := store.GetPermission(c, permission)
		// 	for i := range permissionList {
		// 		if strings.Contains(p.Title, permissionList[i]) {
		// 			c.Next()
		// 			return
		// 		}
		// 	}
		// }

		c.Abort()
		c.JSON(http.StatusUnauthorized, gin.H{"error": "not authorized"})
	}
}

// func PermissionMiddleware(store sqlc.Querier) gin.HandlerFunc {
// 	return func(c *gin.Context) {
// 		// userID, _ := c.Get("userID") // Assume user authentication is done
// 		// get the use from token
// 		userPerms, err := GetUserPermissions(db, userID.(int64))
// 		if err != nil {
// 			c.AbortWithStatus(http.StatusInternalServerError)
// 			return
// 		}
// 		path := strings.Split(c.Request.URL.Path, "/")
// 		currentNode := userPerms

// 		for _, segment := range path[1:] { // Skip the first empty segment
// 			found := false
// 			for _, child := range currentNode.Children {
// 				if child.Title == segment {
// 					currentNode = child
// 					found = true
// 					break
// 				}
// 			}
// 			if !found {
// 				c.AbortWithStatus(http.StatusForbidden)
// 				return
// 			}
// 		}
// 		// Check button permission if applicable
// 		if action := c.Query("action"); action != "" {
// 			if !currentNode.Buttons[action] {
// 				c.AbortWithStatus(http.StatusForbidden)
// 				return
// 			}
// 		}
// 		c.Next()
// 	}
// }
