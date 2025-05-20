package constants

const (
	X_USER_ID           = "x-user-id"
	API_SUCCESS_CODE    = "00000"
	API_SUCCESS_MESSAGE = "Success"

	//LOCAL_COUNTRY_ID id for local country
	LOCAL_COUNTRY_ID int64 = 1

	//TESTING_USER_ID this is only for testing auth token
	TESTING_USER_ID = "1"

	//TESTING_COMPANY_ID this is only for testing auth token
	TESTING_COMPANY_ID = "1"

	//AUCTION_VERIFY_STATUS verify status of auction  //FIXME: it should be dynamic
	AUCTION_VERIFY_STATUS = true

	//AUCTION_TITLE_MAX_LENGTH max charector length to calculate Title Score
	AUCTION_TITLE_MAX_LENGTH = 60
	//AUCTION_TITLE_MIN_LENGTH min charector length to calculate Title Score
	AUCTION_TITLE_MIN_LENGTH = 40

	//AUCTION_DESCRIPTION_MAX_LENGTH maximum charector length to calculate Description score
	AUCTION_DESCRIPTION_MAX_LENGTH = 2000
	//AUCTION_DESCRIPTION_MIN_LENGTH minimum charector length to calculate Description score
	AUCTION_DESCRIPTION_MIN_LENGTH = 750

	MAX_PROPERTY_TITLE_LENGTH = 100

	//MAX_MEDIA_COUNT maximum media count to calculate Media score
	MAX_MEDIA_COUNT = 30

	DEFAULT_SUBSCRIPTION_STATUS = "Premium"

	//AUCTION_ACTIVITY_SECTION_ID is section_id for auctions changes [Activity tables #auctions]
	AUCTION_ACTIVITY_SECTION_ID = 15
)

// contant messages
const (
	AUCTION_PLAN_DOC_ADDED   = "New plan document added in Auction"
	AUCTION_PLAN_DOC_DELETED = "Plan document deleted from Auction"

	AUCTION_DOCUMENT_ADDED   = "New document added in Auction"
	AUCTION_DOCUMENT_DELETED = "Document deleted from Auction"

	AUCTION_MEDIA_FILE_ADDED   = "New media file added in auction"
	AUCTION_MEDIA_FILE_DELETED = "Media file deleted form auction"

	PARTNER_LOGO_ADDED  = "Partner logo added"
	PARTNER_LOGO_REMOVE = "Partner logo removed"
)
