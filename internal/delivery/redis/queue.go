package redis

import (
	"aqary_admin/config"
	"context"
	"encoding/json"
	"fmt"
	"time"
	// "notify/models"
)

type Notification struct {
	Type     string `bson:"type"`
	Provider string `bson:"provider"`
	Payload  string `bson:"payload"`
}

type History struct {
	Data       string    `bson:"data" json:"data"`
	EntityID   int64     `bson:"entity_id" json:"entity_id"`
	Company    int64     `bson:"company_id" json:"company_id"`
	UserID     int64     `bson:"user_id" json:"user_id"`
	UserName   string    `bson:"user_name" json:"user_name"`
	EntityName string    `bson:"entity_name" json:"entity_name"`
	ModuleName string    `bson:"module_name" json:"module_name"`
	Action     string    `bson:"action" json:"action"`
	EntityType int64     `bson:"entity_type" json:"entity_type"`
	CreatedAt  time.Time `bson:"created_at" json:"created_at"`
}

type GetHistoryByEntityTypeRequest struct {
	EntityType int `json:"entity_type" bson:"entity_type"`
	Page       int `json:"page" bson:"page"`
	PageSize   int `json:"page_size" bson:"page_size"`
}

type RespHistory struct {
	// ID         primitive.ObjectID     `bson:"id,omitempty"`
	EntityID   int64     `json:"entity_id" bson:"entity_id"`
	CompanyID  int64     `json:"company_id" bson:"company_id"`
	UserID     int64     `json:"user_id" bson:"user_id"`
	UserName   string    `json:"user_name" bson:"user_name"`
	EntityName string    `json:"entity_name" bson:"entity_name"`
	ModuleName string    `json:"module_name" bson:"module_name"`
	Action     string    `json:"action" bson:"action"`
	Data       any       `json:"data" bson:"data"`
	CreatedAt  time.Time `json:"created_at" bson:"created_at"`
}

// var ctx = context.Background()

func EnqueueNotification(ctx context.Context, client *RedisClient, notificationType string, notification Notification) error {
	// Enqueue the notification in Redis based on type
	data, _ := json.Marshal(notification)
	return client.client.RPush(ctx, "queue:"+notificationType, data).Err()
}

func EnqueueHistory(ctx context.Context, client *RedisClient, history History) error {
	// Enqueue the notification in Redis based on type
	// client := redis.NewClient(&redis.Options{Addr: "localhost:6379"})
	fmt.Println("history", history)
	data, _ := json.Marshal(history)
	return client.client.RPush(ctx, "history_queue:list:"+config.AppConfig.HistoryAPIToken, data).Err()
}
