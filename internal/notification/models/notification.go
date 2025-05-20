package models

type Notification struct {
	Type          string            `json:"type"`           // "email" or "sms"
	Provider      string            `json:"provider"`       // "twilio" or "nexmo"
	Recipient     string            `json:"recipient"`      // Email address or phone number
	RecipientName string            `json:"recipient_name"` // Email address or phone number
	Subject       string            `json:"subject" `       // Email subject
	Body          string            `json:"body"`           //Email or sms body for sending direct message
	Payload       map[string]string `json:"payload"`        // Custom data (for email templates if required)
	TemplateId    string            `json:"template_id"`    // for email templates
}
