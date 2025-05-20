package websocket

import (
	"encoding/json"
	"log"
	"sync"
	"time"
)

type Notification struct {
	Type    string      `json:"type"`
	Title   string      `json:"title,omitempty"`
	Message string      `json:"message"`
	Data    interface{} `json:"data,omitempty"`
}

type Hub struct {
	clients    map[string]map[*Client]bool
	broadcast  chan []byte
	register   chan *Client
	unregister chan *Client
	mutex      sync.RWMutex
}

func (h *Hub) unregisterClientAsync(client *Client) {
	go func() {
		h.unregister <- client
	}()
}

func (h *Hub) sendMessageToClient(client *Client, message []byte) {
	select {
	case client.send <- message:
		// Message sent successfully
	case <-time.After(time.Second):
		// Timeout after 1 second
		log.Printf("Timeout sending message to client %s", client.userID)
		h.unregisterClientAsync(client)
	default:
		// Channel is full or closed
		h.unregisterClientAsync(client)
	}
}

func (h *Hub) SendNotificationToUser(userID string, notificationType string, message string) {
	if h == nil || h.clients == nil {
		log.Println("Hub or clients map is nil")
		return
	}

	notification := Notification{
		Type:    notificationType,
		Title:   notificationType,
		Message: message,
	}

	jsonNotification, err := json.Marshal(notification)
	if err != nil {
		log.Printf("Error marshalling notification: %v", err)
		return
	}

	h.mutex.RLock()
	clients, exists := h.clients[userID]
	h.mutex.RUnlock()

	if !exists {
		log.Printf("No clients found for user: %s", userID)
		return
	}

	// Create a copy of clients to avoid holding the lock while sending the notification
	// don't change this
	activeClients := make([]*Client, 0)
	for client := range clients {
		activeClients = append(activeClients, client)
	}

	for _, client := range activeClients {
		h.sendMessageToClient(client, jsonNotification)
	}
}

func (h *Hub) broadcastMessageToClient(client *Client, message []byte) {
	select {
	case client.send <- message:
		// Message sent successfully
	default:
		h.unregisterClientAsync(client)
	}
}

func (h *Hub) broadcastMessage(message []byte) {
	h.mutex.RLock()
	defer h.mutex.RUnlock()

	for _, clients := range h.clients {
		for client := range clients {
			h.broadcastMessageToClient(client, message)
		}
	}
}

func (h *Hub) Run() {
	for {
		select {
		case client := <-h.register:
			h.registerClient(client)
		case client := <-h.unregister:
			h.unregisterClient(client)
		case message := <-h.broadcast:
			h.broadcastMessage(message)
		}
	}
}

func (h *Hub) registerClient(client *Client) {
	h.mutex.Lock()
	defer h.mutex.Unlock()

	if _, ok := h.clients[client.userID]; !ok {
		h.clients[client.userID] = make(map[*Client]bool)
	}
	h.clients[client.userID][client] = true
	log.Printf("Client registered: %s, Total clients for user: %d",
		client.userID, len(h.clients[client.userID]))
}

func (h *Hub) unregisterClient(client *Client) {
	h.mutex.Lock()
	defer h.mutex.Unlock()

	if clients, ok := h.clients[client.userID]; ok {
		if _, exists := clients[client]; exists {
			delete(clients, client)
			close(client.send)

			if len(clients) == 0 {
				delete(h.clients, client.userID)
			}
			log.Printf("Client unregistered: %s, Remaining clients for user: %d",
				client.userID, len(clients))
		}
	}
}

func (h *Hub) BroadcastNotification(notification []byte) {
	select {
	case h.broadcast <- notification:
		// Successfully queued for broadcast
	case <-time.After(time.Second):
		log.Println("Broadcast channel is full or blocked...")
	}
}

func NewHub() *Hub {
	return &Hub{
		broadcast:  make(chan []byte, 100),
		register:   make(chan *Client, 100),
		unregister: make(chan *Client, 100),
		clients:    make(map[string]map[*Client]bool),
	}
}
