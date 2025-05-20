package redis

import (
	"aqary_admin/config"
	"context"
	"fmt"
	"log"
	"strings"
	"sync"
	"time"

	"github.com/RediSearch/redisearch-go/v2/redisearch"
	"github.com/redis/go-redis/v9"
)

// RedisClient wraps the Redis client and RediSearch client
type RedisClient struct {
	client     *redis.Client
	search     *redisearch.Client
	addr       string
	password   string
	db         int
	mu         sync.Mutex
	ctx        context.Context
	cancelFunc context.CancelFunc
}

// NewRedisClient creates a new Redis client with search capabilities
func NewRedisClient() (*RedisClient, error) {
	ctx, cancel := context.WithCancel(context.Background())

	host := config.AppConfig.RedisHost
	db := config.AppConfig.RedisDB
	password := config.AppConfig.RedisPassword

	rc := &RedisClient{
		addr:       host,
		password:   password,
		db:         db,
		ctx:        ctx,
		cancelFunc: cancel,
	}

	err := rc.connect()
	if err != nil {
		cancel()
		return nil, err
	}

	go rc.keepAlive()

	log.Printf("Successfully connected to Redis: %s", host)

	return rc, nil
}

func (rc *RedisClient) connect() error {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	client := redis.NewClient(&redis.Options{
		Addr:     rc.addr,
		Password: rc.password,
		DB:       rc.db,
		PoolSize: 10, // Adjust this value based on your needs
	})

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	_, err := client.Ping(ctx).Result()
	if err != nil {
		return fmt.Errorf("failed to connect to Redis: %v", err)
	}

	rc.client = client
	// rc.search = redisearch.NewClient(client.Options().Addr, "myIndex")

	return nil
}

func (rc *RedisClient) keepAlive() {
	ticker := time.NewTicker(30 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-ticker.C:
			if err := rc.ping(); err != nil {
				fmt.Printf("Ping failed, attempting to reconnect: %v\n", err)
				if err := rc.connect(); err != nil {
					fmt.Printf("Reconnection failed: %v\n", err)
				} else {
					fmt.Println("Reconnection successful")
				}
			}
		case <-rc.ctx.Done():
			return
		}
	}
}

func (rc *RedisClient) ping() error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	return rc.client.Ping(ctx).Err()
}

// CreateIndex creates a full-text search index
func (rc *RedisClient) CreateIndex(schema *redisearch.Schema) error {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	if rc.search == nil {
		return fmt.Errorf("RediSearch client is not initialized")
	}
	return rc.search.CreateIndex(schema)
}

func (rc *RedisClient) CreateIndexWithDefination(schema *redisearch.Schema, defination *redisearch.IndexDefinition) error {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	if rc.search == nil {
		return fmt.Errorf("RediSearch client is not initialized")
	}
	return rc.search.CreateIndexWithIndexDefinition(schema, defination)
}

// IndexDocument indexes a document for full-text search
func (rc *RedisClient) IndexDocument(doc redisearch.Document) error {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	if rc.search == nil {
		return fmt.Errorf("RediSearch client is not initialized")
	}
	return rc.search.Index(doc)
}

// / searchInIndex performs a search on a specific index
func (rc *RedisClient) SearchInIndex(indexName, queryStr string) ([]redisearch.Document, int, error) {
	query := redisearch.NewQuery(queryStr)
	rsWithIndex := redisearch.NewClient(rc.client.Options().Addr, indexName)
	return rsWithIndex.Search(query)
}

// Search performs a full-text search query
func (rc *RedisClient) Search(q *redisearch.Query) ([]redisearch.Document, int, error) {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	if rc.search == nil {
		return nil, 0, fmt.Errorf("RediSearch client is not initialized")
	}
	return rc.search.Search(q)
}

// Set sets a key-value pair in Redis
func (rc *RedisClient) Set(ctx context.Context, key string, value interface{}, expiration time.Duration) error {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	if rc.client == nil {
		return fmt.Errorf("Redis client is not initialized")
	}
	return rc.client.Set(ctx, key, value, expiration).Err()
}

func (rc *RedisClient) SetPermissions(ctx context.Context, key string, value []byte, expiration time.Duration) error {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	if rc.client == nil {
		return fmt.Errorf("Redis client is not initialized")
	}
	return rc.client.Set(ctx, key, value, expiration).Err()
}

// Get retrieves a value from Redis by key
func (rc *RedisClient) Get(ctx context.Context, key string) (string, error) {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	if rc.client == nil {
		return "", fmt.Errorf("Redis client is not initialized")
	}

	val, err := rc.client.Get(ctx, key).Result()

	if err == redis.Nil {
		return "", fmt.Errorf("no value for this key")
	}
	if err != nil {
		return "", fmt.Errorf("invalid key")
	}

	return val, nil
}

// Close closes the Redis client connection
func (rc *RedisClient) Close() error {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	rc.cancelFunc()

	if rc.client != nil {
		return rc.client.Close()
	}
	return nil
}

func (rc *RedisClient) SubscribeChannel(channel string) *redis.PubSub {
	pubsub := rc.client.PSubscribe(rc.ctx, channel)
	return pubsub
}

// HSet sets a field in a hash stored at key to value
func (rc *RedisClient) HSet(ctx context.Context, key, field string, value interface{}) error {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	if rc.client == nil {
		return fmt.Errorf("Redis client is not initialized")
	}
	return rc.client.HSet(ctx, key, field, value).Err()
}

// SetJSON stores a JSON object in Redis
func (rc *RedisClient) SetJSON(ctx context.Context, key string, value interface{}, expiration time.Duration) error {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	if rc.client == nil {
		return fmt.Errorf("Redis client is not initialized")
	}

	// Use JSON.SET command to store JSON data
	cmd := rc.client.Do(ctx, "JSON.SET", key, ".", value)
	if cmd.Err() != nil {
		return fmt.Errorf("failed to set JSON: %w", cmd.Err())
	}

	// Set expiration if provided
	if expiration > 0 {
		return rc.client.Expire(ctx, key, expiration).Err()
	}

	return nil
}

// buildKey constructs a key with the given folder and key
func (rc *RedisClient) buildKey(folder, key string) string {
	return fmt.Sprintf("%s:%s", folder, key)
}

// SetInFolder sets a key-value pair in a specific folder in Redis
func (rc *RedisClient) SetInFolder(ctx context.Context, folder, key string, value interface{}, expiration time.Duration) error {
	fullKey := rc.buildKey(folder, key)
	return rc.Set(ctx, fullKey, value, expiration)
}

// HSetInFolder sets a field in a hash stored at key in a specific folder
func (rc *RedisClient) HSetInFolder(ctx context.Context, folder, key, field string, value interface{}) error {
	fullKey := rc.buildKey(folder, key)
	return rc.HSet(ctx, fullKey, field, value)
}

// SetJSONInFolder marshals the given object to JSON and stores it in a specific folder in Redis
func (rc *RedisClient) SetJSONInFolder(ctx context.Context, folder, key string, value interface{}, expiration time.Duration) error {
	fullKey := rc.buildKey(folder, key)
	return rc.SetJSON(ctx, fullKey, value, expiration)
}

// GetKeysInFolder retrieves all keys in a specific folder
func (rc *RedisClient) GetKeysInFolder(ctx context.Context, folder string) ([]string, error) {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	if rc.client == nil {
		return nil, fmt.Errorf("Redis client is not initialized")
	}

	pattern := rc.buildKey(folder, "*")
	keys, _, err := rc.client.Scan(ctx, 0, pattern, 0).Result()
	if err != nil {
		return nil, fmt.Errorf("failed to scan keys: %w", err)
	}

	// Remove the folder prefix from the keys
	for i, key := range keys {
		keys[i] = strings.TrimPrefix(key, folder+":")
	}

	return keys, nil
}

// GetJSONFromFolder retrieves a JSON object from a specific folder in Redis and unmarshals it into the provided type
func (rc *RedisClient) GetJSONFromFolder(ctx context.Context, folder, key string) ([]byte, error) {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	if rc.client == nil {
		return nil, fmt.Errorf("redis client is not initialized")
	}

	fullKey := rc.buildKey(folder, key)
	cmd := rc.client.Do(ctx, "JSON.GET", fullKey)
	if cmd.Err() != nil {
		if cmd.Err() == redis.Nil {
			return nil, fmt.Errorf("failed to get Key: %w", cmd.Err()) // Key not found, return nil without error
		}
		return nil, fmt.Errorf("failed to get JSON: %w", cmd.Err())
	}

	result, err := cmd.Result()
	if err != nil {
		return nil, fmt.Errorf("failed to get result: %w", err)
	}

	jsonStr, ok := result.(string)
	if !ok {
		return nil, fmt.Errorf("unexpected result type: %T", result)
	}
	return []byte(jsonStr), nil
}

func (rc *RedisClient) DeleteJSONFromFolder(ctx context.Context, folder, key string) (*string, error) {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	if rc.client == nil {
		return nil, fmt.Errorf("redis client is not initialized")
	}

	fullKey := rc.buildKey(folder, key)
	cmd := rc.client.Do(ctx, "JSON.DEL", fullKey)
	if cmd.Err() != nil {
		if cmd.Err() == redis.Nil {
			return nil, fmt.Errorf("failed to get Key: %w", cmd.Err()) // Key not found, return nil without error
		}
		return nil, fmt.Errorf("failed to get JSON: %w", cmd.Err())
	}

	result, err := cmd.Result()
	fmt.Println(result, fullKey)
	if err != nil {
		return nil, fmt.Errorf("failed to get result: %w", err)
	}

	jsonStr, ok := result.(string)
	if !ok {
		return nil, fmt.Errorf("unexpected result type: %T", result)
	}
	return &jsonStr, nil
}

// Del remove a key-value pair in Redis
func (rc *RedisClient) Del(ctx context.Context, key string) error {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	if rc.client == nil {
		return fmt.Errorf("Redis client is not initialized")
	}
	return rc.client.Del(ctx, key).Err()
}

// ExpireAt sets expiry time for a key-value pair in Redis
func (rc *RedisClient) ExpireAt(ctx context.Context, key string, time time.Time) error {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	if rc.client == nil {
		return fmt.Errorf("Redis client is not initialized")
	}

	return rc.client.ExpireAt(ctx, key, time).Err()
}

// TTL check the expiry time for a key-value pair in Redis
func (rc *RedisClient) TTL(ctx context.Context, key string) (time.Duration, error) {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	if rc.client == nil {
		return 0, fmt.Errorf("Redis client is not initialized")
	}

	return rc.client.TTL(ctx, key).Result()
}

func (rc *RedisClient) SetRPushInFolder(ctx context.Context, folderName string, key string, value interface{}) (int64, error) {
	return rc.RPush(ctx, fmt.Sprintf("%v:%v", folderName, key), value)
}

func (rc *RedisClient) RPush(ctx context.Context, key string, value interface{}) (int64, error) {
	return rc.client.RPush(ctx, key, value).Result()
}

func (rc *RedisClient) CreateSectionPermissionIndexClient(schema *redisearch.Schema, indexDef *redisearch.IndexDefinition) {
	err := redisearch.NewClient(rc.client.Options().Addr, "idx:sectionPermissions").
		CreateIndexWithIndexDefinition(schema, indexDef)

	if err != nil {
		fmt.Println("error while creating index on permissions", err)
	}
}

func (rc *RedisClient) CreatePermissionIndexClient(schema *redisearch.Schema, indexDef *redisearch.IndexDefinition) {
	err := redisearch.NewClient(rc.client.Options().Addr, "idx:permissions").
		CreateIndexWithIndexDefinition(schema, indexDef)

	if err != nil {
		fmt.Println("error while creating index on permissions", err)
	}
}

func (rc *RedisClient) CreateSubSectionPermissionIndexClient(schema *redisearch.Schema, indexDef *redisearch.IndexDefinition) {
	err := redisearch.NewClient(rc.client.Options().Addr, "idx:subSectionPermissions").
		CreateIndexWithIndexDefinition(schema, indexDef)

	if err != nil {
		fmt.Println("error while creating index on sub section permissions", err)
	}
}

func (rc *RedisClient) DropIndex(index string) {
	client := redisearch.NewClient(rc.client.Options().Addr, index)

	err := client.DropIndex(true)

	if err != nil {
		fmt.Println("error while droping index", err)
	}
}

// GetAllJSONFromFolder retrieves all JSON objects from a specific folder in Redis and returns them as a map of keys to values.
func (rc *RedisClient) GetAllJSONFromFolder(ctx context.Context, folder string) (map[string][]byte, error) {
	rc.mu.Lock()
	defer rc.mu.Unlock()

	if rc.client == nil {
		return nil, fmt.Errorf("redis client is not initialized")
	}

	// Use SCAN to iterate over keys matching the folder pattern
	pattern := folder + "*"
	cursor := uint64(0)
	results := make(map[string][]byte)

	for {
		// Use the SCAN command to find keys
		keys, nextCursor, err := rc.client.Scan(ctx, cursor, pattern, 1000).Result()
		if err != nil {
			return nil, fmt.Errorf("failed to scan keys: %w", err)
		}
		cursor = nextCursor

		// Fetch the JSON data for each key
		for _, key := range keys {
			cmd := rc.client.Do(ctx, "JSON.GET", key)
			if cmd.Err() != nil {
				if cmd.Err() == redis.Nil {
					continue // Skip if the key doesn't exist
				}
				return nil, fmt.Errorf("failed to get JSON for key %s: %w", key, cmd.Err())
			}

			result, err := cmd.Result()
			if err != nil {
				return nil, fmt.Errorf("failed to get result for key %s: %w", key, err)
			}

			jsonStr, ok := result.(string)
			if !ok {
				return nil, fmt.Errorf("unexpected result type for key %s: %T", key, result)
			}

			results[key] = []byte(jsonStr)
		}

		// Break the loop if cursor is 0 (end of iteration)
		if cursor == 0 {
			break
		}
	}

	return results, nil
}

func (rc *RedisClient) FlushAll(ctx context.Context) {

	err := rc.client.FlushAll(ctx)

	if err != nil {
		fmt.Println("error while flushing all redis db", err)
	}
}

func (rc *RedisClient) SCard(ctx context.Context, redisKey string) (int64, error) {

	viewCount, err := rc.client.SCard(ctx, redisKey).Result()

	if err != nil {
		return 0, err
	}

	return viewCount, nil
}

// func (rc *RedisClient) Del2(ctx context.Context, redisKey string) error {
// 	_, err := rc.client.Del(ctx, redisKey).Result()

// 	return err
// }

func (rc *RedisClient) RPop(ctx context.Context, key string) (string, error) {
	return rc.client.RPop(ctx, key).Result()
}

func (rc *RedisClient) LPop(ctx context.Context, key string) (string, error) {
	return rc.client.LPop(ctx, key).Result()
}

func (rc *RedisClient) SAdd(redisKey string, ipAddress string) error {
	// Add the IP address to the Redis set for this property, with an expiration time of 24 hours
	log.Printf("Adding IP: %s to Redis set: %s", ipAddress, redisKey)
	err := rc.client.SAdd(rc.ctx, redisKey, ipAddress).Err()
	if err != nil {
		return fmt.Errorf("error while connecting to Redis: %v", err)
	}

	// Set an expiration time for the Redis key (e.g., 30 hours)
	_, err = rc.client.Expire(rc.ctx, redisKey, time.Hour*30).Result()
	if err != nil {
		return fmt.Errorf("error while setting Redis key expiration time: %v", err)
	}
	return nil
}

func (rc *RedisClient) Scan(ctx context.Context, pattern string, count int64) ([]string, error) {
	var (
		cursor uint64
		keys   []string
	)

	for {
		var scannedKeys []string
		var err error

		scannedKeys, cursor, err = rc.client.Scan(ctx, cursor, pattern, count).Result()
		if err != nil {
			return nil, err
		}

		keys = append(keys, scannedKeys...)

		if cursor == 0 {
			break
		}
	}

	return keys, nil
}
