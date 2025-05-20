package rabbitClient

import (
	"aqary_admin/internal/domain/sqlc/sqlc"
	"aqary_admin/internal/notification/message"
	"aqary_admin/pkg/utils"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"

	"github.com/wagslane/go-rabbitmq"
)

type requestFlow struct {
	RequestID int64 `json:"Request_id"`
	Step      int64 `json:"Step"`
}

func RunMainConsumer(conn *rabbitmq.Conn, stop <-chan os.Signal, done chan<- bool, store sqlc.Querier) {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	consumer, err := rabbitmq.NewConsumer(
		conn,
		message.RequestManagementExchange,
		rabbitmq.WithConsumerOptionsRoutingKey(message.RequestManagement),
		rabbitmq.WithConsumerOptionsExchangeName(message.RequestManagementExchange),
		rabbitmq.WithConsumerOptionsExchangeDeclare,
	)
	if err != nil {
		log.Fatal(err)
	}

	// Wait for a signal to shut down
	go func() {
		sig := <-stop
		fmt.Println("Received signal:", sig)
		log.Println("Shutting down RabbitMQ consumer...")
		consumer.CloseWithContext(ctx)
		done <- true
	}()

	// block main thread - wait for shutdown signal
	err = consumer.Run(func(d rabbitmq.Delivery) rabbitmq.Action {
		log.Printf("consumed: %v", string(d.Body))
		var request requestFlow
		err2 := json.Unmarshal(d.Body, &request)
		log.Printf("err2: %v", err2)

		err3 := utils.ProcessRequestCameFromQueue(request.RequestID, request.Step, store)
		log.Printf("err3: %v", err3)

		// rabbitmq.Ack, rabbitmq.NackDiscard, rabbitmq.NackRequeue
		return rabbitmq.Ack
	})
	if err != nil {
		log.Fatal(err)
	}
}

//	request_approval "aqary_admin/internal/usecases/request_approval"
