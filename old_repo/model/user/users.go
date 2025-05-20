package user

type User struct {
	ID           int64
	Username     string
	Password     string
	Status       int8
	RoleID       int64
	DepartmentID int64
	ProfileID    int64
	UserTypeID   int64
}

type UserType struct {
	ID   int64  `json:"id"`
	Type string `json:"user_type"`
}

type Profile struct {
	ID               int64  `json:"id"`
	FirstName        string `json:"first_name"`
	LastName         string `json:"last_name"`
	SubCommunitiesID int64  `json:"sub_communities_id"`
	LocationsID      int64  `json:"locations_id"`
	Email            string `json:"email"`
	ProfileImageUrl  string `json:"profile_image_url"`
	PhoneNumber      string `json:"phone_number"`
	CompanyNumber    string `json:"company_number"`
	WhatsappNumber   string `json:"whatsapp_number"`
	Gender           int64  `json:"gender"`
}

type Role struct {
	ID   int64
	Role string
	Code string
}
