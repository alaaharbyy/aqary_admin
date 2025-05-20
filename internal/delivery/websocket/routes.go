package websocket

import (
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/pkg/utils/security"
	"encoding/json"

	"github.com/gin-gonic/gin"
)

type Server struct {
	Store      sqlc.Querier
	TokenMaker security.Maker
	Router     *gin.Engine
	Hub        *Hub
}

func SetupWebSocketRoutes(server Server) {

	server.Router.GET("/ws", WebSocketHandler(server))

	server.Router.POST("/broadcast", func(c *gin.Context) {
		var message struct {
			Content string `json:"content" binding:"required"`
		}
		if err := c.ShouldBindJSON(&message); err != nil {
			c.JSON(400, gin.H{"error": err.Error()})
			return
		}
		notification := Notification{
			Type:    "broadcast",
			Message: message.Content,
		}
		jsonNotification, err := json.Marshal(notification)
		if err != nil {
			c.JSON(500, gin.H{"error": "Failed to create notification"})
			return
		}
		server.Hub.BroadcastNotification(jsonNotification)
	})
}
