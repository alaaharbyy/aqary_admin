package routes

import (
	"aqary_admin/config"
	rabbitClient "aqary_admin/internal/delivery/rabbitmq"
	handler_aqary_investment "aqary_admin/internal/delivery/rest/handlers/aqary_investment"
	"aqary_admin/internal/delivery/rest/middleware"
	user_routes "aqary_admin/internal/delivery/routes/common/user_server"
	"aqary_admin/internal/delivery/websocket"
	"aqary_admin/translations"
	"context"
	"os"
	"os/signal"
	"syscall"

	// "aqary_admin/internal/delivery/routes"

	// graph_routes "aqary_admin/internal/delivery/routes/graph"

	// careers_routes "aqary_admin/internal/delivery/routes/dashboard/careers"

	"aqary_admin/internal/domain/sqlc/sqlc"
	usecase "aqary_admin/internal/usecases"

	"fmt"
	"log"
	"net/http"
	"time"

	httpclient "aqary_admin/pkg/http_client"
	"aqary_admin/pkg/utils/security"

	connect_db "aqary_admin/pkg/db"

	sentry "github.com/getsentry/sentry-go"
	sentrygin "github.com/getsentry/sentry-go/gin"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/newrelic/go-agent/v3/integrations/logcontext-v2/nrzap"
	"github.com/newrelic/go-agent/v3/integrations/nrgin"
	"github.com/newrelic/go-agent/v3/newrelic"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
	"github.com/wagslane/go-rabbitmq"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

var (
	aqaryInvestmentUseCase    usecase.AqaryInvestmentUseCase
	handlerAqaryInvestmentObj *handler_aqary_investment.AllHandler
)

func StartServer() {
	// Initialize New Relic
	app, err := newrelic.NewApplication(
		newrelic.ConfigAppName("Aqary-Backend"),
		newrelic.ConfigLicense("b21b7030691a639e64d777ccb94eab86FFFFNRAL"),
		newrelic.ConfigAppLogForwardingEnabled(true),
	)
	if err != nil {
		panic(fmt.Sprintf("failed to initialize New Relic: %v", err))
	}

	// Load the translations
	translations.LoadTranslations()

	// Create the base logger configuration
	encoderConfig := zap.NewProductionEncoderConfig()
	core := zapcore.NewCore(
		zapcore.NewJSONEncoder(encoderConfig),
		zapcore.AddSync(os.Stdout),
		zap.InfoLevel,
	)

	// Wrap the core with New Relic
	backgroundCore, err := nrzap.WrapBackgroundCore(core, app)
	if err != nil && err != nrzap.ErrNilApp {
		panic(fmt.Sprintf("failed to wrap zap core with New Relic: %v", err))
	}

	// Create the logger with the wrapped core
	logger := zap.New(backgroundCore)
	defer logger.Sync()

	pool, dbUrl, err := connect_db.ConnectToDb()

	if err != nil {
		logger.Fatal("failed to connect to database", zap.Error(err))
	}

	store, err := sqlc.NewStore(dbUrl, logger)
	if err != nil {
		logger.Fatal("failed to create store", zap.Error(err))
	}

	server, err := NewServer(store, pool)
	if err != nil {
		logger.Fatal("cannot create server", zap.Error(err))
	}

	// Use New Relic middleware
	server.Router.Use(nrgin.Middleware(app))

	url := ginSwagger.URL("/swagger/doc.json")
	server.Router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler, url))

	httpClient := httpclient.NewHTTPClient()

	initHandlers()

	// connect to rabbitmq server
	conn := rabbitClient.InitRabbitMQ()
	defer conn.Close()

	hub := websocket.NewHub()
	go hub.Run()

	websocket.SetupWebSocketRoutes(websocket.Server{
		Store:      store,
		TokenMaker: server.TokenMaker,
		Router:     server.Router,
		Hub:        hub,
	})

	SetUpRestHanlders(Server{
		Store:        server.Store,
		Pool:         server.Pool,
		TokenMaker:   server.TokenMaker,
		Router:       server.Router,
		Hub:          hub,
		RabbitClient: conn,
		HttpClient:   httpClient,
	})

	//setting up  graphQL APIs Handlers
	// routes.SetUpGraphqlHandlers(router, userUseCase)

	//setting up Rest APIs Handler
	SetUpAqaryInvestmentHandlers(server.Router, handlerAqaryInvestmentObj, server.TokenMaker)

	//starting server
	httpServer := http.Server{
		Addr:         fmt.Sprintf(":%d", config.AppConfig.Port),
		Handler:      server.Router,
		ReadTimeout:  time.Second * 30,
		WriteTimeout: time.Second * 30,
		IdleTimeout:  time.Second * 10,
	}
	// log.Printf("server is running on %d", config.AppConfig.Port)
	// err = httpServer.ListenAndServe()
	// if err != nil {
	// 	panic(fmt.Sprintf("failed to listen, err: %v", err))
	// }

	// Create a channel to listen for OS signals (SIGINT, SIGTERM)
	stop := make(chan os.Signal, 1)
	signal.Notify(stop, syscall.SIGINT, syscall.SIGTERM)

	// Channel to handle graceful shutdown
	done := make(chan bool)

	// Start the RabbitMQ consumer
	go rabbitClient.RunMainConsumer(conn, stop, done, store)

	// Run HTTP server in a goroutine
	go func() {
		log.Printf("Server is running on %d", config.AppConfig.Port)
		if err := httpServer.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("HTTP server ListenAndServe failed: %v", err)
		}
	}()

	// Block until the shutdown signal is received
	<-stop
	// log.Println("Shutdown signal received, shutting down...")

	// Graceful shutdown for RabbitMQ
	// log.Println("Gracefully shutting down RabbitMQ consumer...")
	<-done // Wait for the consumer to finish

	// Gracefully shut down the HTTP server
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := httpServer.Shutdown(ctx); err != nil {
		log.Fatalf("HTTP server shutdown failed: %v", err)
	}

	log.Println("Server gracefully stopped")

}

func initHandlers() {
	// log.Println("testing all use cases", allUseCases)
	handlerAqaryInvestmentObj = handler_aqary_investment.NewHandler(aqaryInvestmentUseCase)

}

type Server struct {
	Store         sqlc.Querier
	StoreWithPool sqlc.SQLStore
	Pool          *pgxpool.Pool
	TokenMaker    security.Maker
	Router        *gin.Engine
	Hub           *websocket.Hub
	RabbitClient  *rabbitmq.Conn
	HttpClient    httpclient.HTTPClient
}

func NewServer(store sqlc.Querier, pool *pgxpool.Pool) (*Server, error) {

	// 32 char symmetric key .....
	tokenMaker, err := security.NewPastoMaker("01234567890123456789012345678912")

	if err != nil {
		return nil, fmt.Errorf("cannot create security.%w", err)
	}

	// To initialize Sentry's handler, you need to initialize Sentry itself beforehand
	if err := sentry.Init(sentry.ClientOptions{
		Dsn:           "https://fdb00077c4012478b92f4ca29b57a1b1@o4507394895970304.ingest.de.sentry.io/4507395190816848",
		EnableTracing: true,
		// Set TracesSampleRate to 1.0 to capture 100%
		// of transactions for tracing.
		// We recommend adjusting this value in production,
		TracesSampleRate: 1.0,
	}); err != nil {
		fmt.Printf("Sentry initialization failed: %v\n", err)
	}

	router := gin.Default()

	// Once it's done, you can attach the handler as one of your middleware
	router.Use(sentrygin.New(sentrygin.Options{
		Repanic: true,
	}))
	gin.SetMode(gin.ReleaseMode)
	server := &Server{Store: store, Pool: pool, TokenMaker: tokenMaker, Router: router}
	server.Router = router

	// -----------------------------------------------------------------

	// ****************** cors **********************
	router.Use(cors.New(cors.Config{
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"},
		AllowHeaders:     []string{"Authorization", "Origin", "Content-Length", "Content-Type", "Accept-Language"},
		AllowCredentials: true,
		MaxAge:           12 * time.Second,
		AllowAllOrigins:  true,
	}))

	router.Use(middleware.SetDefaultLanguage())

	router.Use(middleware.PrometheusMiddleware())

	// ******************** metrics ********************
	router.GET("/metrics", gin.WrapH(promhttp.Handler()))

	// ***************** Setting Memory **************
	router.MaxMultipartMemory = 100 << 2
	// *************************************

	router.Static("upload", "/upload")
	// ************************* //
	// ! All our router will be lying here ....

	// ************************* //

	// *****************   Setting Up limiter   ***************
	rl := middleware.NewRateLimiter(50, 300) // 50 request per user per sercond, 100 burst per second.
	router.Use(rl.Limiter())
	// ***************************************

	// ************** All Server Controllers *********************  //

	// graph := graph_routes.NewGraphServer(server.Store, server.StoreWithPool, server.TokenMaker, server.Router, server.Pool)
	user := user_routes.NewUserServer(server.Store, server.Pool, server.TokenMaker, server.Router)
	// careers_routes := careers_routes.NewCareerServer(server.Store, server.Pool, server.TokenMaker, server.Router)

	// ***********************************************************  //

	// graph.GraphServer()
	user.UserRelatedRoutes()
	// careers_routes.SetupCareerHandlers()

	// **************  timeout middleware     *********************
	router.Use(middleware.TimeoutMiddleware())
	log.Println("testing total routes", len(server.Router.Routes()))

	// *************** server health ************************
	router.GET("/health", func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK, gin.H{"application": config.AppConfig.Name, "version": config.AppConfig.AppVersion, "status": "running"})
	})

	//! -----------------------------------------

	return server, nil
}
