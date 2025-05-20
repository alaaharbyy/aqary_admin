package config

import (
	"fmt"
	"log"
	"reflect"
	"strconv"
	"strings"

	"github.com/spf13/viper"
)

type Config struct {
	Name                      string `mapstructure:"NAME"`
	Port                      int    `mapstructure:"PORT"`
	Host                      string `mapstructure:"HOST"`
	AppEnv                    string `mapstructure:"ENVIRONMENT"`
	AppVersion                string `mapstructure:"APP_VERSION"`
	DockerDbAddress           string `mapstructure:"DOCKER_DB_ADDRESS"`
	AzureStorageConnStr       string `mapstructure:"AZURE_STORAGE_CONNECTION_STRING"`
	DbPassword                string `mapstructure:"DB_PASSWORD"`
	DbName                    string `mapstructure:"DB_NAME"`
	RedisHost                 string `mapstructure:"REDIS_HOST"`
	RedisDB                   int    `mapstructure:"REDIS_DB"`
	RedisPassword             string `mapstructure:"REDIS_PASSWORD"`
	HistoryAPIToken           string `mapstructure:"HISTORY_SERVICE_API_TOKEN"`
	GoogleClientId            string `mapstructure:"GOOGLE_CLIENT_ID"`
	RabbitMQAddress           string `mapstructure:"RABBITMQ_ADDRESS"`
	HistoryAPIPath            string `mapstructure:"HISTORY_REPO_BASE_URL"`
	CronPort                  int    `mapstructure:"CRON_PORT"`
	AppleTeamIDInvestment     string `mapstructure:"APPLE_TEAM_ID_INVESTMENT"`
	AppleClientIDInvestment   string `mapstructure:"APPLE_CLIENT_ID_INVESTMENT"`
	AppleKeyIDInvestment      string `mapstructure:"APPLE_KEY_ID_INVESTMENT"`
	ApplePrivateKeyInvestment string `mapstructure:"APPLE_PRIVATE_KEY_INVESTMENT"`

	AppleTeamIDFineHome     string `mapstructure:"APPLE_TEAM_ID_FINE_HOME"`
	AppleKeyIDFineHome      string `mapstructure:"APPLE_KEY_ID_FINE_HOME"`
	AppleClientIDFineHome   string `mapstructure:"APPLE_CLIENT_ID_FINE_HOME"`
	ApplePrivateKeyFineHome string `mapstructure:"APPLE_PRIVATE_KEY_FINE_HOME"`

	FACEBOOK_ClIENTID     string `mapstructure:"FACEBOOK_ClIENTID"`
	FACEBOOK_ClIENTSECRET string `mapstructure:"FACEBOOK_ClIENTSECRET"`
}

var AppConfig Config

func Initialize() {
	viper.SetConfigFile(".env")
	viper.AutomaticEnv()

	err := viper.ReadInConfig()
	if err != nil {
		log.Printf("Error reading config file: %s", err)
		log.Println("Using environment variables only")
	}

	// Set default values if not provided
	viper.SetDefault("NAME", "Aqary Backend")
	viper.SetDefault("PORT", 8080)
	viper.SetDefault("CRON_PORT", 8081)
	viper.SetDefault("HOST", "0.0.0.0")
	viper.SetDefault("ENVIRONMENT", "dev")
	viper.SetDefault("APP_VERSION", "0.0.1")

	// Handle PORT separately
	portValue := viper.GetString("PORT")
	if strings.Contains(portValue, ":") {
		parts := strings.Split(portValue, ":")
		if len(parts) == 2 {
			viper.Set("HOST", parts[0])
			portValue = parts[1]
		}
	}
	port, err := strconv.Atoi(portValue)
	if err != nil {
		log.Printf("Invalid PORT value: %s. Using default 8080", portValue)
		port = 8080
	}
	viper.Set("PORT", port)

	// Unmarshal config
	err = viper.Unmarshal(&AppConfig)
	if err != nil {
		panic(fmt.Errorf("fatal error when unmarshaling config: %s", err))
	}

	// Override config with environment variables
	t := reflect.TypeOf(AppConfig)
	for i := 0; i < t.NumField(); i++ {
		field := t.Field(i)
		envKey := field.Tag.Get("mapstructure")
		if envKey != "" && envKey != "PORT" { // Skip PORT as we've already handled it
			envVal := viper.GetString(envKey)
			if envVal != "" {
				viper.Set(envKey, envVal)
			}
		}
	}

	// Re-unmarshal to ensure all values are updated
	err = viper.Unmarshal(&AppConfig)
	if err != nil {
		panic(fmt.Errorf("fatal error when re-unmarshaling config: %s", err))
	}

	log.Printf("Configuration loaded. Environment: %s, Host: %s, Port: %d, Cron Port: %d", AppConfig.AppEnv, AppConfig.Host, AppConfig.Port, AppConfig.CronPort)
}
