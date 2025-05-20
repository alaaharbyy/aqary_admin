package auth_usecase

// Hold data to store in Redis
type OTPData struct {
	Otp      int   `json:"otp"`
	Attempts int   `json:"attempts"`
	UserID   int64 `json:"user_id"`
	ExpireAt int64 `json:"expire_at"`
}

// Hold data to store in Redis
type ForgotPasswordData struct {
	Email     string `json:"email"`
	Attempts  int    `json:"attempts"`
	ExpireAt  int64  `json:"expire_at"`
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
	UserID    int64  `json:"user_id"`
}
