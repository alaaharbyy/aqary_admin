package constants

import "time"

const (
	MIN_SUBSCRIPTION_ORDER_DURATION = 3 * 30 * 24 * time.Hour  // Approximate 3 months
	MAX_SUBSCRIPTION_ORDER_DURATION = 3 * 365 * 24 * time.Hour // Approximate 3 years

	MIN_NO_OF_PAYMENTS = 1
	MAX_NO_OF_PAYMENTS = 36
)
