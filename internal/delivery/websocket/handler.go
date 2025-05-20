package websocket

import (
	"fmt"
	"log"
	"net/http"
	"sync"

	"github.com/gin-gonic/gin"
)

func WebSocketHandler(server Server) gin.HandlerFunc {

	return func(c *gin.Context) {
		token := c.Query("token")

		payload, err := server.TokenMaker.VerifyToken(token)
		if err != nil {
			log.Printf("Token verification failed: %v", err)
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
			return
		}

		conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
		if err != nil {
			log.Printf("Failed to upgrade connection: %v", err)
			return
		}

		visitedUser, err := server.Store.GetUserByName(c, payload.Username)
		if err != nil {
			log.Printf("Error getting user: %v", err)
			conn.Close()
			return
		}
		client := &Client{
			hub:    server.Hub,
			conn:   conn,
			send:   make(chan []byte, 256),
			userID: fmt.Sprint(visitedUser.ID),
		}

		defer func() {
			server.Hub.unregister <- client
			conn.Close()
		}()
		client.hub.register <- client
		log.Printf("New client registered with user ID: %s", client.userID)

		var wg sync.WaitGroup
		wg.Add(2)

		go func() {
			defer wg.Done()
			client.writePump()
		}()

		go func() {
			defer wg.Done()
			client.readPump()
		}()

		log.Printf("WebSocket connection fully established for user ID: %s", client.userID)

		wg.Wait()

		log.Printf("WebSocket connection closed for user ID: %s", client.userID)
	}

}
