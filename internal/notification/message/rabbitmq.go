package message

import (
	"aqary_admin/internal/notification/models"
	"encoding/json"
	"log"

	"github.com/wagslane/go-rabbitmq"
)

const (
	NotificationQueue = "notifications_queue"
	// notification types
	EmailNotificationType = "email"
	SmsNotificationType   = "sms"
	// providers
	EmailProvider             = "sendgrid"
	SmsProvider               = "twillio"
	RequestManagement         = "request_management"
	RequestManagementExchange = "request_management_exchange"
)

func CreateNotificationMessage(notification models.Notification) ([]byte, error) {
	return json.MarshalIndent(notification, "", " ")
}

func PublishMessage(conn *rabbitmq.Conn, exchange string, notification models.Notification, routingKeys []string) {
	messageBody, err := CreateNotificationMessage(notification)
	if err != nil {
		log.Println("RABBIT::Error creating message body:", err)
		return
	}

	publisher, err := rabbitmq.NewPublisher(
		conn,
	)
	if err != nil {
		log.Println("RABBIT::Error initializing publisher:", err)
		return
	}
	defer publisher.Close()

	err = publisher.Publish(
		messageBody,
		routingKeys,
		rabbitmq.WithPublishOptionsContentType("application/json"),
	)
	if err != nil {
		log.Println("RABBIT::Error publishing message:", err)
		return
	}
}
