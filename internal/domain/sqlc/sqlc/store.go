package sqlc

import (
	"aqary_admin/pkg/utils/exceptions"
	"context"
	"fmt"
	"log"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"go.uber.org/zap"
)

// Store interface defines the contract for database operations
type Store interface {
	Querier
}

type SQLStore struct {
	*Queries
	connPool *pgxpool.Pool
	logger   *zap.Logger
}

// NewStore creates a new Store instance
func NewStore(databaseURL string, logger *zap.Logger) (Store, error) {
	config, err := pgxpool.ParseConfig(databaseURL)
	if err != nil {
		return nil, fmt.Errorf("parsing database URL: %w", err)
	}

	// Optimize connection pool settings
	config.MaxConns = 100
	config.MaxConnLifetime = time.Hour
	config.MaxConnIdleTime = 30 * time.Minute
	config.ConnConfig.ConnectTimeout = 5 * time.Second

	// // Set up logging
	// config.ConnConfig.Tracer = &tracerLogger{
	// 	logger: logger,
	// }

	pool, err := pgxpool.NewWithConfig(context.Background(), config)
	if err != nil {
		return nil, fmt.Errorf("creating connection pool: %w", err)
	}

	return &SQLStore{
		Queries:  New(pool),
		connPool: pool,
		logger:   logger,
	}, nil
}

// tracerLogger implements pgx.QueryTracer interface
type tracerLogger struct {
	logger *zap.Logger
}

func (tl *tracerLogger) TraceQueryStart(ctx context.Context, conn *pgx.Conn, data pgx.TraceQueryStartData) context.Context {
	tl.logger.Info("Query started",
		zap.String("query", data.SQL),
		zap.Any("args", data.Args),
	)
	return ctx
}

func (tl *tracerLogger) TraceQueryEnd(ctx context.Context, conn *pgx.Conn, data pgx.TraceQueryEndData) {
	if data.Err != nil {
		tl.logger.Error("Query failed",
			zap.Error(data.Err),
		)
	} else {
		tl.logger.Info("Query completed",
			zap.Int64("rows_affected", data.CommandTag.RowsAffected()),
		)
	}
}

// ExecuteTx executes a function within a database transaction
// func ExecuteTx(c *gin.Context, pool *pgxpool.Pool, fn func(q *Queries) error) error {
// 	ctx := c.Request.Context()
// 	tx, err := pool.Begin(ctx)
// 	if err != nil {
// 		return fmt.Errorf("beginning transaction: %w", err)
// 	}

// 	q := New(tx)

// 	err = fn(q)
// 	if err != nil {
// 		if rbErr := tx.Rollback(ctx); rbErr != nil {
// 			return fmt.Errorf("tx err: %v, rb err: %v", err, rbErr)
// 		}
// 		return err
// 	}

// 	return tx.Commit(ctx)
// }

func ExecuteTx(ctx context.Context, pool *pgxpool.Pool, fn func(q *Queries) error) error {
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	errChan := make(chan error, 1)
	go func() {
		errChan <- ExecuteTxWithTimeout(ctx, pool, fn)
	}()

	select {
	case err := <-errChan:
		return err
	case <-ctx.Done():
		return fmt.Errorf("transaction timed out after %v: %v", 3*time.Second, ctx.Err())
	}
}

func ExecuteTxWithTimeout(ctx context.Context, pool *pgxpool.Pool, fn func(q *Queries) error) error {

	tx, err := pool.Begin(ctx)
	if err != nil {
		return fmt.Errorf("beginning transaction: %w", err)
	}

	q := New(tx)

	err = fn(q)
	if err != nil {
		if rbErr := tx.Rollback(ctx); rbErr != nil {
			return fmt.Errorf("tx err: %v, rb err: %v", err, rbErr)
		}
		return err
	}

	return tx.Commit(ctx)
}

func New2(db DBTX) Querier {
	return &Queries{db: db}
}

// func ExecTx2(c context.Context, pool *pgxpool.Pool, fn func(Querier) error) error {
// 	tx, err := pool.Begin(c)
// 	if err != nil {
// 		return err
// 	}

// 	q := New2(tx)
// 	err = fn(q)
// 	if err != nil {
// 		if rbErr := tx.Rollback(c); rbErr != nil {
// 			return fmt.Errorf("tx err: %v, rb err: %v", err, rbErr)
// 		}
// 		return err
// 	}

// 	return tx.Commit(c)
// }

func ExecTx2(ctx context.Context, pool *pgxpool.Pool, fn func(Querier) error) error {
	ctx, cancel := context.WithTimeout(ctx, 3*time.Second)
	defer cancel()

	errChan := make(chan error, 1)
	go func() {
		errChan <- ExecTx2WithTimeout(ctx, pool, fn)
	}()

	select {
	case err := <-errChan:
		return err
	case <-ctx.Done():
		return fmt.Errorf("transaction timed out after %v: %v", 3*time.Second, ctx.Err())
	}
}

func ExecTx2WithTimeout(ctx context.Context, pool *pgxpool.Pool, fn func(Querier) error) error {
	tx, err := pool.Begin(ctx)
	if err != nil {
		return err
	}

	q := New2(tx)
	err = fn(q)
	if err != nil {
		if rbErr := tx.Rollback(ctx); rbErr != nil {
			return fmt.Errorf("tx err: %v, rb err: %v", err, rbErr)
		}
		return err
	}

	return tx.Commit(ctx)
}

func ExecuteTxWithException(c context.Context, pool *pgxpool.Pool, fn func(q Querier) *exceptions.Exception) *exceptions.Exception {
	ctx, cancel := context.WithTimeout(c, 3*time.Second)
	defer cancel()

	errChan := make(chan *exceptions.Exception, 1)
	go func() {
		errChan <- ExecuteTxWithExceptionWithTimeout(ctx, pool, fn)
	}()

	select {
	case err := <-errChan:
		return err
	case <-ctx.Done():

		return exceptions.GetExceptionByErrorCodeWithCustomMessage(
			exceptions.SomethingWentWrongErrorCode,
			fmt.Errorf("transaction timed out after %v: %v", 3*time.Second, ctx.Err()).Error(),
		)
	}
}

// ExecuteTxWithException executes a function within a database transaction and handles custom exceptions
func ExecuteTxWithExceptionWithTimeout(ctx context.Context, pool *pgxpool.Pool, fn func(q Querier) *exceptions.Exception) *exceptions.Exception {

	tx, err := pool.Begin(ctx)
	if err != nil {
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(
			exceptions.SomethingWentWrongErrorCode,
			fmt.Sprintf("beginning transaction: %v", err),
		)
	}

	q := New(tx)

	exc := fn(q)
	if exc != nil {
		if rbErr := tx.Rollback(ctx); rbErr != nil {
			return exceptions.GetExceptionByErrorCodeWithCustomMessage(
				exceptions.SomethingWentWrongErrorCode,
				fmt.Sprintf("tx err: %v, rb err: %v", exc, rbErr),
			)
		}
		return exc
	}

	if err := tx.Commit(ctx); err != nil {
		log.Println("testing transactions err", err)
		return exceptions.GetExceptionByErrorCodeWithCustomMessage(
			exceptions.SomethingWentWrongErrorCode,
			fmt.Sprintf("committing transaction: %v", err),
		)
	}

	return nil
}
