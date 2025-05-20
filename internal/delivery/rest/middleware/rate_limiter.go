package middleware

import (
	"net/http"
	"sync"

	"github.com/gin-gonic/gin"
	"golang.org/x/time/rate"
)

// RateLimiter contains IP-based rate limiters to control access frequency.
type RateLimiter struct {
	ipLimiters map[string]*rate.Limiter // Map to associate each IP with its rate limiter
	mu         sync.RWMutex             // Mutex for safe concurrent access to ipLimiters
	r          rate.Limit               // Rate (requests per second) to allow for each IP
	b          int                      // Burst size allowing bursts of traffic
}

// NewRateLimiter creates and returns a new RateLimiter instance.
// Parameters 'r' and 'b' define the maximum requests per second and burst size, respectively.
func NewRateLimiter(r rate.Limit, b int) *RateLimiter {
	return &RateLimiter{
		ipLimiters: make(map[string]*rate.Limiter), // Initialize the map for IP to rate limiter mapping
		r:          r,                              // Set the rate (requests per second)
		b:          b,                              // Set the burst size
	}
}

// GetLimiter retrieves the rate limiter for a specific IP address.
// If a limiter does not exist for the IP, it creates a new one with the settings from RateLimiter.
func (rl *RateLimiter) GetLimiter(ip string) *rate.Limiter {
	rl.mu.Lock() // Ensure thread-safe access to ipLimiters map
	defer rl.mu.Unlock()

	limiter, exists := rl.ipLimiters[ip] // Retrieve the limiter for the IP if it exists
	if !exists {
		limiter = rate.NewLimiter(rl.r, rl.b) // Create a new limiter if not present
		rl.ipLimiters[ip] = limiter           // Add the new limiter to the map
	}

	return limiter // Return the rate limiter for the IP
}

// Limiter acts as a middleware function that limits requests based on IP address.
func (rl *RateLimiter) Limiter() gin.HandlerFunc {
	return func(c *gin.Context) {
		ip := c.ClientIP()           // Retrieve the client's IP address
		limiter := rl.GetLimiter(ip) // Get the limiter for the client's IP

		if !limiter.Allow() { // Check if request is allowed under the rate limit
			c.AbortWithStatusJSON(http.StatusTooManyRequests, gin.H{
				"error": "too many requests",
			}) // Abort the request with a 429 Too Many Requests status code
			return
		}

		c.Next() // Continue to the next middleware/handler if the request is allowed
	}
}
