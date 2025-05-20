package middleware

import (
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
)

var (
	HTTPRequestsTotal = prometheus.NewCounterVec(
		prometheus.CounterOpts{
			Name: "http_requests_total",
			Help: "Total number of HTTP requests",
		},
		[]string{"method", "endpoint", "status_code"},
	)
	HTTPRequestDuration = prometheus.NewHistogramVec(
		prometheus.HistogramOpts{
			Name: "http_request_duration_seconds",
			Help: "Duration of HTTP requests",
		},
		[]string{"method", "endpoint", "status_code"},
	)
)

// Client-side metrics
var (
	outboundRequestsTotal = promauto.NewCounterVec(
		prometheus.CounterOpts{
			Name: "outbound_http_requests_total",
			Help: "Total number of outbound HTTP requests made from the client.",
		},
		[]string{"method", "host", "status_code"},
	)
	outboundRequestDuration = promauto.NewHistogramVec(
		prometheus.HistogramOpts{
			Name: "outbound_http_request_duration_seconds",
			Help: "Duration of outbound HTTP requests made from the client.",
		},
		[]string{"method", "host"},
	)
)

// Defining a new counter vector for error tracking
var (
	errorCounter = promauto.NewCounterVec(
		prometheus.CounterOpts{
			Name: "client_error",
			Help: "Total number of errors occurred in the application",
		},
		[]string{"type"}, // Label to differentiate error types
	)
)

// Defining a new counter vector for error tracking which has no effect on api status or doesn't needed.
var (
	errorWithNoEffect = promauto.NewCounterVec(
		prometheus.CounterOpts{
			Name: "error_with_no_effect",
			Help: "Total number of errors occurred in the application",
		},
		[]string{"type_without_effect"}, // Label to differentiate error types
	)
)

// Defining a new counter vector for error tracking which has panic on api status or doesn't needed or 500.
var (
	errorWithPanic = promauto.NewCounterVec(
		prometheus.CounterOpts{
			Name: "server_error",
			Help: "Total number of errors occurred in the application",
		},
		[]string{"type_without_effect"}, // Label to differentiate error types
	)
)

func init() {
	prometheus.MustRegister(HTTPRequestsTotal, HTTPRequestDuration)
}

func PrometheusMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		startTime := time.Now()
		c.Next() // Process request

		duration := time.Since(startTime)
		status := c.Writer.Status()
		endpoint := c.FullPath() // or c.Request.URL.Path for raw path

		HTTPRequestsTotal.WithLabelValues(c.Request.Method, endpoint, fmt.Sprintf("%d", status)).Inc()
		HTTPRequestDuration.WithLabelValues(c.Request.Method, endpoint, fmt.Sprintf("%d", status)).Observe(duration.Seconds())

	}
}

type InstrumentedTransport struct {
	Base http.RoundTripper
}

func (it *InstrumentedTransport) RoundTrip(r *http.Request) (*http.Response, error) {
	startTime := time.Now()
	resp, err := it.Base.RoundTrip(r) // Make the request
	duration := time.Since(startTime)

	if resp != nil {
		// Client-side metrics
		outboundRequestsTotal.WithLabelValues(r.Method, r.URL.Host, http.StatusText(resp.StatusCode)).Inc()
		outboundRequestDuration.WithLabelValues(r.Method, r.URL.Host).Observe(duration.Seconds())
	}
	return resp, err
}

func NewInstrumentedClient() *http.Client {
	return &http.Client{
		Transport: &InstrumentedTransport{
			Base: http.DefaultTransport,
		},
	}
}

// IncrementErrorCounter increments the error counter for a given error type
func IncrementClientErrorCounter(errorType string) {
	errorCounter.With(prometheus.Labels{"type": errorType}).Inc()
}

// IncrementErrorCounter increments the error counter with no effect for a given error type
func IncrementErrorCounterWithoutEffect(errorType string) {
	errorWithNoEffect.With(prometheus.Labels{"type_without_effect": errorType}).Inc()
}

// IncrementErrorCounter increments the error counter with no effect for a given error type
func IncrementServerErrorCounter(errorType string) {
	errorWithPanic.With(prometheus.Labels{"type_without_effect": errorType}).Inc()
}
