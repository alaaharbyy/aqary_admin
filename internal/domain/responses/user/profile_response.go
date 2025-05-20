package response

type Profile struct {
	ID              int64   `json:"id"`
	FirstName       string  `json:"first_name"`
	LastName        string  `json:"last_name"`
	AddressID       int64   `json:"addresses_id"`
	ProfileImageUrl string  `json:"profile_image_url"`
	PhoneNumber     string  `json:"phone_number"`
	CompanyNumber   string  `json:"company_number"`
	WhatsappNumber  string  `json:"whatsapp_number"`
	Gender          int64   `json:"gender"`
	LanguageIDs     []int64 `json:"all_languages_id"`
}
