package rabbitClient

import (
	"aqary_admin/config"
	"fmt"
	"log"

	"github.com/wagslane/go-rabbitmq"
)

func InitRabbitMQ() *rabbitmq.Conn {
	addr := config.AppConfig.RabbitMQAddress
	conn, err := rabbitmq.NewConn(
		addr,
	)
	if err != nil {
		fmt.Println("Error creating Rabbit connection")
		log.Fatal(err)
	}

	fmt.Println("----Rabbit is running on-----")
	return conn
}

func PublishMessage(conn *rabbitmq.Conn, exchange string, data []byte, routingKeys []string) {
	publisher, err := rabbitmq.NewPublisher(
		conn,
		rabbitmq.WithPublisherOptionsExchangeName(exchange),
		rabbitmq.WithPublisherOptionsExchangeDeclare,
	)
	if err != nil {
		log.Fatal(err)
	}
	defer publisher.Close()

	err = publisher.Publish(
		data,
		routingKeys,
		rabbitmq.WithPublishOptionsContentType("application/json"),
		rabbitmq.WithPublishOptionsExchange(exchange),
	)
	if err != nil {
		log.Println(err)
	}
}
