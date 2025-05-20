package db

import (
	"aqary_admin/config"
	"context"
	"fmt"
	"log"
	"path"
	"runtime"

	"github.com/golang-migrate/migrate/v4"
	_ "github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/jackc/pgx/v5/pgxpool"
)

// ConnectToDb establishes a connection to the database and returns both the pool and the URL
func ConnectToDb() (*pgxpool.Pool, string, error) {
	dbURL := config.AppConfig.DockerDbAddress

	fmt.Println(dbURL)
	pool, err := pgxpool.New(context.Background(), dbURL)
	if err != nil {
		return nil, "", fmt.Errorf("failed to connect to database: %w", err)
	}

	// Check if the connection is alive
	err = pool.Ping(context.Background())
	if err != nil {
		return nil, "", fmt.Errorf("failed to connect to database: %w", err)
	}

	log.Printf("Successfully connected to database: %s", dbURL)
	return pool, dbURL, nil
}

// Migrate runs database migrations
func Migrate() error {
	_, b, _, _ := runtime.Caller(0)
	migrationPath := fmt.Sprintf("file://%s/migrations", path.Dir(b))

	m, err := migrate.New(migrationPath, config.AppConfig.DockerDbAddress)
	if err != nil {
		return fmt.Errorf("error creating the migrate instance: %w", err)
	}

	if err := m.Up(); err != nil && err != migrate.ErrNoChange {
		return fmt.Errorf("error running migrations: %w", err)
	}

	log.Println("Migration completed successfully")
	return nil
}
