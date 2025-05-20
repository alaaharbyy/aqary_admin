package middleware

import (
	"context"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
)

// TransactionMiddleware wraps each request in a transaction with a timeout
func TransactionMiddleware(pool *pgxpool.Pool, timeout time.Duration) gin.HandlerFunc {
	return func(c *gin.Context) {

		ctx, cancel := context.WithTimeout(c.Request.Context(), timeout)
		defer cancel()

		tx, err := pool.Begin(ctx)
		if err != nil {
			c.JSON(500, gin.H{"error": "Failed to start transaction"})
			c.Abort()
			return
		}

		// Added the  transaction to context to track later
		c.Set("tx", tx)

		defer func() {
			if ctx.Err() == context.DeadlineExceeded {
				tx.Rollback(ctx)
				c.JSON(500, gin.H{"error": "Transaction timed out"})
				c.Abort()
			} else if c.IsAborted() {
				tx.Rollback(ctx)
			} else {
				tx.Commit(ctx)
			}
		}()

		c.Next()
	}
}
