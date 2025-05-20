package middleware

import (
	"context"

	"aqary_admin/pkg/utils"
	"aqary_admin/pkg/utils/security"

	"errors"
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
)

var (
	authorizationHeaderKey  = "authorization"
	authorizationTypeBearer = "bearer"
	AuthorizationPayloadKey = "authorization_payload"
	TestUser                = "dreamer"
	AuthurizationHeader     = ""
	HeaderNotProvidedError  = "authorization header is not provided"
)

func AuthMiddleware(tokenMaker security.Maker) gin.HandlerFunc {
	return func(c *gin.Context) {
		AuthurizationHeader = c.GetHeader(authorizationHeaderKey)

		if len(AuthurizationHeader) == 0 {
			err := errors.New("authorization header is not provided")
			IncrementClientErrorCounter(err.Error())
			c.AbortWithStatusJSON(http.StatusInternalServerError, utils.ErrorResponse(err))
			return
		}
		fields := strings.Fields(AuthurizationHeader)
		if len(fields) < 2 {
			err := errors.New("invalid authurization header")
			IncrementClientErrorCounter(err.Error())
			c.AbortWithStatusJSON(http.StatusInternalServerError, utils.ErrorResponse(err))
			return
		}
		authorizationType := strings.ToLower(fields[0])
		if authorizationType != authorizationTypeBearer {
			err := fmt.Errorf("unsupported authorization type %s", authorizationType)
			IncrementClientErrorCounter(err.Error())
			c.AbortWithStatusJSON(http.StatusInternalServerError, utils.ErrorResponse(err))
			return
		}
		accessToken := fields[1]

		payload, err := tokenMaker.VerifyToken(accessToken)
		if err != nil {
			IncrementClientErrorCounter(err.Error())
			c.AbortWithStatusJSON(http.StatusInternalServerError, utils.ErrorResponse(err))
			return
		}
		c.Set(AuthorizationPayloadKey, payload)
		c.Next()
	}
}

func AuthMiddlewareForGraph(tokenMaker security.Maker) gin.HandlerFunc {
	return func(c *gin.Context) {
		AuthurizationHeader = c.GetHeader(authorizationHeaderKey)

		if len(AuthurizationHeader) == 0 {
			err := errors.New(HeaderNotProvidedError)
			IncrementClientErrorCounter(err.Error())
			c.Next()
		} else {
			fields := strings.Fields(AuthurizationHeader)
			if len(fields) != 0 {
				if len(fields) < 2 {
					err := errors.New("invalid authurization header")
					IncrementClientErrorCounter(err.Error())
				}
				authorizationType := strings.ToLower(fields[0])
				if authorizationType != authorizationTypeBearer {
					err := fmt.Errorf("unsupported authorization type %s", authorizationType)
					IncrementClientErrorCounter(err.Error())
				}

				accessToken := fields[1]
				payload, err := tokenMaker.VerifyToken(accessToken)
				if err != nil {
					IncrementClientErrorCounter(err.Error())
					c.AbortWithStatusJSON(http.StatusInternalServerError, utils.ErrorResponse(err))
					return
				}
				c.Set(AuthorizationPayloadKey, payload)
				c.Next()
			} else {
				c.Next()
			}

		}

	}
}

func TimeoutMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		//!
		ctx, cancel := context.WithTimeout(c.Request.Context(), 5*time.Second)
		defer cancel()
		c.Request = c.Request.WithContext(ctx)
		c.Next()
		if ctx.Err() != nil || ctx.Err() == context.DeadlineExceeded {
			c.AbortWithStatusJSON(http.StatusRequestTimeout, utils.ErrorResponse(ctx.Err()))
		}
	}
}

// ! for websocket

// var upgrader = websocket.Upgrader{
// 	ReadBufferSize:  1024,
// 	WriteBufferSize: 1024,
// 	CheckOrigin: func(r *http.Request) bool {
// 		// Implement proper origin checking for production
// 		return true
// 	},
// }

// const (
// 	AuthorizationHeaderKey  = "Authorization"
// 	AuthorizationTypeBearer = "Bearer"
// 	// AuthorizationPayloadKey = "authorization_payload"
// )

// func WebSocketAuthMiddleware(tokenMaker security.Maker) gin.HandlerFunc {
// 	return func(c *gin.Context) {
// 		defer func() {
// 			if r := recover(); r != nil {
// 				log.Printf("Panic in WebSocketAuthMiddleware: %v", r)
// 				c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
// 				c.Abort()
// 			}
// 		}()

// 		var token string

// 		// Check if it's a WebSocket upgrade request
// 		if websocket.IsWebSocketUpgrade(c.Request) {
// 			// For WebSocket, check for token in query params
// 			token = c.Query("token")
// 			if token == "" {
// 				// If not in query, check in header
// 				authHeader := c.GetHeader(AuthorizationHeaderKey)
// 				fields := strings.Fields(authHeader)
// 				if len(fields) == 2 && strings.ToLower(fields[0]) == strings.ToLower(AuthorizationTypeBearer) {
// 					token = fields[1]
// 				}
// 			}
// 		} else {
// 			// For regular HTTP requests, check Authorization header
// 			authHeader := c.GetHeader(AuthorizationHeaderKey)
// 			fields := strings.Fields(authHeader)
// 			if len(fields) == 2 && strings.ToLower(fields[0]) == strings.ToLower(AuthorizationTypeBearer) {
// 				token = fields[1]
// 			}
// 		}

// 		if token == "" {
// 			log.Println("Authorization token is missing")
// 			c.JSON(http.StatusUnauthorized, gin.H{"error": "authorization token is required"})
// 			c.Abort()
// 			return
// 		}

// 		// Verify the token
// 		payload, err := tokenMaker.VerifyToken(token)
// 		if err != nil {
// 			log.Printf("Token verification failed: %v", err)
// 			c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
// 			c.Abort()
// 			return
// 		}

// 		// Token is valid, set payload in context
// 		c.Set(AuthorizationPayloadKey, payload)

// 		// If it's a WebSocket request, upgrade the connection
// 		if websocket.IsWebSocketUpgrade(c.Request) {
// 			conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
// 			if err != nil {
// 				log.Printf("Failed to upgrade connection: %v", err)
// 				c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not upgrade connection"})
// 				c.Abort()
// 				return
// 			}

// 			// Store the WebSocket connection in the context
// 			c.Set("websocket_conn", conn)
// 		}

// 		c.Next()
// 	}
// }
