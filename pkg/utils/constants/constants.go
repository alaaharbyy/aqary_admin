package constants

import (
	"fmt"
	"slices"
	"strings"
)

type TYPE string
type NAME string
type CODE string

type Constant struct {
	Type TYPE
	Code CODE
	Name NAME
}

const (
	UserTypes                  TYPE = "00000USRTYP" // * any modification in this type of constants needs to be done in database also
	CompanyTypes               TYPE = "00000COMTYP" // * any modification in this type of constants needs to be done in database also
	BannerDirection            TYPE = "00000BNRDRC"
	BannerPosition             TYPE = "00000BNRPOS"
	BannerCriteriaName         TYPE = "00000CRTNME"
	BannerCriteriaType         TYPE = "00000CRTTYP"
	Ranks                      TYPE = "00000COMRNK"
	Statuses                   TYPE = "0000000STAT"
	CompletionStatus           TYPE = "000COMLSTAT"
	Plan                       TYPE = "0000000PLAN"
	LifeStyle                  TYPE = "0000LIFESTY"
	OwnerShip                  TYPE = "00000OWNSHP"
	Furnishing                 TYPE = "00000FURNSH"
	Properties                 TYPE = "0000000PROP"
	MediaType                  TYPE = "0000MDIATYP"
	PropertyCategory           TYPE = "0000PROPCAT"
	Section                    TYPE = "00000000SEC"
	LikeReaction               TYPE = "0000LIKREAC"
	RentType                   TYPE = "00000RNTTYP"
	SortBy                     TYPE = "00000SORTBY"
	LeadAndContacts            TYPE = "0000LEDCONT"
	ContactType                TYPE = "0000CONTTYP"
	LeadType                   TYPE = "00000LEDTYP"
	LeadPurpose                TYPE = "0000LEDPURP"
	ResidentialStatus          TYPE = "000RESDSTAT"
	AppointmentRequestStatus   TYPE = "00APREQSTAT"
	AppointmentStatus          TYPE = "00000APSTAT"
	AppointmentType            TYPE = "000000APTYP"
	AppointmentTypes           TYPE = "000001APTYP"
	AppointmentApps            TYPE = "000000APP"
	CallActivityTypes          TYPE = "00CALACTTYP"
	CallActivityStatus         TYPE = "0CALACTSTAT"
	UnitOfMeasure              TYPE = "00000UNTMER"
	ProjectUnitCategories      TYPE = "00PROUNTCAT"
	FinancialProviderType      TYPE = "00000FINPRV"
	GalleryType                TYPE = "0000GALLTYP"
	PublishType                TYPE = "PUBLISHTYPE"
	ShareType                  TYPE = "00SHARETYPE"
	VATStatus                  TYPE = "0000VATSTAT"
	OpenhouseAppointment       TYPE = "00000OPNHOS"
	OpenhouseTimeslot          TYPE = "00000OPNTIM"
	SubscriberStatus           TYPE = "00000SUBSTS"
	Gender                     TYPE = "00000GENDER"
	EntityType                 TYPE = "0ENTITYTYPE" // * any modification in this type of constants needs to be done in database also
	PropertyTypeUsage          TYPE = "00TYPEUSAGE"
	LicenseType                TYPE = "0LICENSETYP" // * any modification in this type of constants needs to be done in database also
	LicenseFields              TYPE = "0LICENSEFLD"
	SocialMedia                TYPE = "00SOCIALMED"
	SocialConnectionStatus     TYPE = "0SOCIALCONN"
	SubscriberType             TYPE = "0SUBSCRIBER"
	PaymentPlan                TYPE = "PAYMENTPLAN"
	PageType                   TYPE = "PAGETYPE"
	PaymentMethod              TYPE = "PAYMENTMTHD"
	CompanyUserType            TYPE = "CMPUSERTYPE"
	SocialLoginType            TYPE = "SOCIALLOGIN"
	Career                     TYPE = "0000CAREER"
	SubscriptionStatus         TYPE = "00SUBSCRIPTION"
	SubscriptionPaymentStatus  TYPE = "SUBSCRIPTIONPAYMENT"
	SubscriberVerificationType TYPE = "SUBSCRVERIFYTYP"
	Category                   TYPE = "CATEGORY"
	ApprovalStatus             TYPE = "APPROVALSTATUS"
	FacilityAmenityType        TYPE = "FACILITYAMENITYTYPE"
	SettingsStatus             TYPE = "SETTINGSSTATUS"
	PlatformUserStatus         TYPE = "PLATFORMUSERSTATUS"
	PlatformType               TYPE = "PLATFORMTYPE"
	BannerPackage              TYPE = "BANNERPACKAGE"
	BannerPlanType             TYPE = "BANNERPLANTYPE"
	BannerPlatform             TYPE = "BANNERPLATFORM"
)

const (
	// AffordableLifeStyle          CODE = "000AFFDLS"
	StandardLifeStyle CODE = "00STANDLS"
	LuxuryLifeStyle   CODE = "00LUXRYLS"
	// UltraLuxuryLifeStyle         CODE = "0ULUXRYLS"
	StandardRank                 CODE = "00STANDRK"
	FeaturedRank                 CODE = "000FTRDRK"
	PremiumRank                  CODE = "0000PRMRK"
	TopDealsRank                 CODE = "00TDEALRK"
	CompanyAdminUserTypes        CODE = "00COMADMN"
	AgentUserTypes               CODE = "00000AGNT"
	OwnerOrIndividualUserTypes   CODE = "00OWNRIND"
	FreelancerUserTypes          CODE = "000FRLNCR"
	AqaryUserUserTypes           CODE = "00AQRYUSR"
	SuperAdminUserTypes          CODE = "00SPRADMN"
	CompanyUserUserTypes         CODE = "000COMUSR"
	BrokerCompanyCompanyTypes    CODE = "000BRKCOM"
	DeveloperCompanyCompanyTypes CODE = "000DVPCOM"
	ServiceCompanyCompanyTypes   CODE = "000SRVCOM"
	ProductCompanyCompanyTypes   CODE = "000PRDCOM"

	LeftBannerDirection        CODE = "000LFTBNR"
	TopLeftBannerDirection     CODE = "000TLFBNR"
	RightBannerDirection       CODE = "000RHTBNR"
	TopRightBannerDirection    CODE = "000TRTBNR"
	TopBannerDirection         CODE = "000TOPBNR"
	BottomBannerDirection      CODE = "000BTMBNR"
	BottomLeftBannerDirection  CODE = "000BLFBNR"
	BottomRightBannerDirection CODE = "000BRTBNR"
	CenterBannerDirection      CODE = "000CNTBNR"

	VerticalBannerPosition   CODE = "000VRTBNR"
	HorizontalBannerPosition CODE = "000HRTBNR"

	HomePageBannerCriteriaName                CODE = "PGEBNRNME"
	DeveloperCompanyListingBannerCriteriaName CODE = "DVCBNRNME"
	TeamListingBannerCriteriaName             CODE = "TEMBNRNME"
	UnitBannerCriteriaName                    CODE = "UNTBNRNME"
	PropertyBannerCriteriaName                CODE = "PRLBNRNME"
	BlogBannerCriteriaName                    CODE = "BLGBNRNME"
	AgricultureBannerCriteriaName             CODE = "ACTBNRNME"
	CommunityGuideBannerCriteriaName          CODE = "CGDBNRNME"

	PageBannerCriteriaType    CODE = "000PGEBNR"
	SectionBannerCriteriaType CODE = "000SCTBNR"
	// TypeBannerCriteriaType             CODE = "000TYPBNR"
	// CommunityBannerCriteriaType        CODE = "000CMTBNR"
	// NetworkCompaniesBannerCriteriaType CODE = "000NTCBNR"

	HomePageType           CODE = "PGTYPHOME"
	ContactsPageType       CODE = "PGTYPCONTACTS"
	AboutUsPageType        CODE = "PGTYPABOUT"
	GalleryPageType        CODE = "PGTYPGALLERY"
	MapPageType            CODE = "PGTYPMAP"
	UnitPageType           CODE = "PGTYPUNIT"
	LuxuryUnitPageType     CODE = "PGTYPLUXUNIT"
	PropertyPageType       CODE = "PGTYPPROPERTY"
	LuxuryPropertyPageType CODE = "PGTYPLUXPROP"
	AreaGuidePageType      CODE = "PGTYPAREAGUIDE"
	ServicesPageType       CODE = "PGTYPESERVICES"

	DraftStatus        CODE = "0DRFTSTAT"
	AvailableStatus    CODE = "0AVALSTAT"
	SoldStatus         CODE = "0SOLDSTAT"
	RentedStatus       CODE = "0RNTDSTAT"
	BlockedStatus      CODE = "0BLOCSTAT"
	DeletedStatus      CODE = "00DELSTAT"
	UnderProcessStatus CODE = "0UNDERPRO"
	UnderOfferStatus   CODE = "0UNDEROFR"
	ComingSoonStatus   CODE = "0CMENGSON"

	OffPlanCompletionStatus                             CODE = "00OFFPLAN"
	ReadyCompletionStatus                               CODE = "00000REDY"
	TowerStructurePlan                                  CODE = "000TWRSTR"
	MasterPlan                                          CODE = "0000MASTR"
	FloorPlan                                           CODE = "000000FLR"
	SitePlan                                            CODE = "000000SIT"
	FreeholdOwnerShip                                   CODE = "000FREHLD"
	GccCititzenOwnerShip                                CODE = "000GCCCTZ"
	LeaseHoldOwnerShip                                  CODE = "000LESHLD"
	LocalCitizenOwnerShip                               CODE = "000LCLCTZ"
	UsufructOwnerShip                                   CODE = "0USUFRUCT"
	OtherOwnerShip                                      CODE = "00000OTHR"
	FreezoneOwnerShip                                   CODE = "00000FREZN"
	NonFurnished                                        CODE = "000NONFUR"
	SemiFurnished                                       CODE = "000SEMFUR"
	FullyFurnished                                      CODE = "000FULFUR"
	ProjectProperty                                     CODE = "000PRJPRO"
	FreelancerProperty                                  CODE = "000FRLPRO"
	BrokerProperty                                      CODE = "000BRKPRO"
	OwnerProperty                                       CODE = "000ONRPRO"
	ImageMediaType                                      CODE = "000000IMG"
	Tour360MediaType                                    CODE = "000TUR360"
	Video360MediaType                                   CODE = "000VID360"
	VideoMediaType                                      CODE = "000000VID"
	PdfMediaType                                        CODE = "00000PDF"
	FreelancerPropertyCategory                          CODE = "000FRLCAT"
	BrokerPropertyCategory                              CODE = "000BRKCAT"
	OwnerPropertyCategory                               CODE = "000ONRCAT"
	SaleSection                                         CODE = "00000SALE"
	RentSection                                         CODE = "00000RENT"
	SwapSection                                         CODE = "00000SWAP"
	PropertyHubSection                                  CODE = "000PROHUB"
	IndustrialSection                                   CODE = "00INDSTRL"
	AgricultureSection                                  CODE = "0000AGRTR"
	LikesReaction                                       CODE = "000000LIK"
	FavouritesReaction                                  CODE = "000000FAV"
	StarReaction                                        CODE = "000000STR"
	CelebrateReaction                                   CODE = "0000CLBRT"
	DealReaction                                        CODE = "00DEALHND"
	UnlikeReaction                                      CODE = "0000UNLIK"
	YearlyRentType                                      CODE = "00000YRLY"
	QuarterRentType                                     CODE = "0000QTRLY"
	MonthlyRentType                                     CODE = "0000MNTLY"
	WeeklyRentType                                      CODE = "0000WEKLY"
	DailyRentType                                       CODE = "00000DELY"
	NewestSortBy                                        CODE = "0000NEWST"
	MinPriceSortBy                                      CODE = "000MINPRC"
	MaxPriceSortBy                                      CODE = "000MAXPRC"
	MinBedroomSortBy                                    CODE = "000MINBED"
	MaxBedroomSortBy                                    CODE = "000MAXBED"
	IndividualLeadAndContacts                           CODE = "000INDVDL"
	CompanyLeadAndContacts                              CODE = "00000COMP"
	OwnerContactType                                    CODE = "00000OWNR"
	BuyerContactType                                    CODE = "000000BYR"
	SellerContactType                                   CODE = "00000SELR"
	SalesLeadType                                       CODE = "000SALTYP"
	LeasingLeadType                                     CODE = "000LESTYP"
	EndUserLeadPurpose                                  CODE = "000ENDUSR"
	InvestorLeadPurpose                                 CODE = "000INVSTR"
	RtoLeadPurpose                                      CODE = "000000RTO"
	ResidentResidentialStatus                           CODE = "00000RESD"
	NonResidentResidentialStatus                        CODE = "00NONRESD"
	DraftAppointmentRequestStatus                       CODE = "00000DRFT"
	SubmittedAppointmentRequestStatus                   CODE = "000SUBMTD"
	RejectedAppointmentRequestStatus                    CODE = "0000REJCT"
	CancelledAppointmentRequestStatus                   CODE = "0CANCLDAR"
	BookedAppointmentRequestStatus                      CODE = "00000BOKD"
	BookedAppointmentStatus                             CODE = "000000BKD"
	RescheduledAppointmentStatus                        CODE = "000RESCDL"
	CancelledAppointmentStatus                          CODE = "0CANCLDAS"
	NoAnswerAppointmentStatus                           CODE = "0000NOANS"
	NoConfirmationAppointmentStatus                     CODE = "00NOCNFRM"
	RejectedAppointmentStatus                           CODE = "0000REJTD"
	OcularVisitAppointmentType                          CODE = "00OCLRVST"
	LiveMeetingAppointmentType                          CODE = "000LIVMET"
	RequestVerificationCallActivityTypes                CODE = "000REQVER"
	FollowUpCallActivityTypes                           CODE = "0000FOLUP"
	CallingAgentCallActivityTypes                       CODE = "0CALNGAGT"
	CallingClientCallActivityTypes                      CODE = "0CALNGCLT"
	CallingOwnerCallActivityTypes                       CODE = "0CALNGOWN"
	ConfirmingOwnerForUnitAvailabilityCallActivityTypes CODE = "0000COFUA"
	ConfirmingAttendanceWithAgentCallActivityTypes      CODE = "00000CAWA"
	ConfirmingAttendanceWithClientCallActivityTypes     CODE = "00000CAWC"
	NoAnswerCallActivityStatus                          CODE = "000NOANSR"
	CallRejectedCallActivityStatus                      CODE = "000CALREJ"
	LineBusyCallActivityStatus                          CODE = "000LINBSY"
	OutOfCoverageAreaCallActivityStatus                 CODE = "00000OOCA"
	Inch                                                CODE = "00000INCH"
	SquareFeet                                          CODE = "00000SQFT"
	SquareMeter                                         CODE = "000000SQM"
	SaleProjectUnitCategories                           CODE = "0SALEPROJ"
	RentProjectUnitCategories                           CODE = "0RENTPROJ"
	Bank                                                CODE = "000BNKFIN"
	FinancialInstitution                                CODE = "00FININST"
	MainGalleryType                                     CODE = "000MANGAL"
	CoverGalleryType                                    CODE = "000CVRGAL"
	FacilitiesGalleryType                               CODE = "000FACGAL"
	AmenitiesGalleryType                                CODE = "000AMNGAL"
	ExteriorGalleryType                                 CODE = "000EXTGAL"
	InteriorGalleryType                                 CODE = "000INTGAL"
	BrochureGalleryType                                 CODE = "000BROGAL"
	WebPortalsPublishType                               CODE = "00WBPLPUB"
	SocialMediaPublishType                              CODE = "00SLMAPUB"
	SocialHubPublishType                                CODE = "00SHUBPUB"
	InternalShareType                                   CODE = "INTLSHARE"
	ExternalShareType                                   CODE = "EXTLSHARE"
	ActiveVATStatus                                     CODE = "000ACTIVE"
	NonActiveVATStatus                                  CODE = "NONACTIVE"
	PendingVATStatus                                    CODE = "00PENDING"
	RequestedOpenhouseAppointment                       CODE = "REQOPNAPP"
	BookedOpenhouseAppointment                          CODE = "BOKOPNAPP"
	ClosedOpenhouseAppointment                          CODE = "CLOOPNAPP"
	RescheduledOpenhouseAppointment                     CODE = "SCHOPNAPP"
	DeletedOpenhouseAppointment                         CODE = "DELOPNAPP"
	RejectedOpenhouseAppointment                        CODE = "REJOPNAPP"
	AvailableOpenhouseTimeslot                          CODE = "0AVLOPNTS"
	NotAvailableOpenhouseTimeslot                       CODE = "NAVLOPNTM"

	ApprovedSubscriberStatus             CODE = "APPROVSUBSTA"
	PendingLegallySubscriberStatus       CODE = "PENLEGSUBSTA"
	PendingFinanciallySubscriberStatus   CODE = "PENFNSUBSTA"
	RejectedLegallySubscriberStatus      CODE = "REJLEGSUBSTA"
	RejectedFinanciallySubscriberStatus  CODE = "REJFINSUBSTA"
	PendingSubscriptionSubscriberStatus  CODE = "PENSUBSUBSTA"
	PendingFinalContractSubscriberStatus CODE = "PENFINALCONTSUBSTA"

	MaleGender                       CODE = "00000MALE"
	FemaleGender                     CODE = "000FEMALE"
	ProjectEntityType                CODE = "00PROJECT"
	CompanyProfileEntityType         CODE = "COMPROFIL"
	CompanyProfileProjectEntityType  CODE = "COMPRFPRO"
	CompanyProfilePhaseEntityType    CODE = "COMPRFPHA"
	PhaseEntityType                  CODE = "0000PHASE"
	PropertyEntityType               CODE = "0PROPERTY"
	ExhibitionsEntityType            CODE = "EXHIBITIONS"
	UnitEntityType                   CODE = "00000UNIT"
	CompanyEntityType                CODE = "00COMPANY"
	ProfileEntityType                CODE = "00PROFILE"
	FreelancerEntityType             CODE = "FREELANCER"
	UserEntityType                   CODE = "000000USER"
	HolidayEntityType                CODE = "000HOLIDAY"
	ServiceEntityType                CODE = "000SERVICE"
	OpenhouseEntityType              CODE = "0OPENHOUSE"
	ScheduleViewEntityType           CODE = "0OSCHDVIEW"
	UnitVersionsEntityType           CODE = "00UNITVERS"
	PropertyVersionsEntityType       CODE = "00PROPVERS"
	PublishEntityType                CODE = "00PUBLISH"
	CompanyActivityEntityType        CODE = "COMPACTIVITY"
	CommunityGuideEntityType         CODE = "COMMGUIDE"
	BannerEntityType                 CODE = "BANNERS"
	ReservationRequestsEntityType    CODE = "ReservationRequests"
	CompanyActivityDetailsEntityType CODE = "CompanyActivityDetails"
	ResidentialPropertyType          CODE = "TYPRESIDE"
	AppoinmentOnlineType             CODE = "APPONTY"
	AppoinmentOfflineType            CODE = "APPOFFTY"
	GmeetAppType                     CODE = "GMEETAPPT"
	ZoomAppType                      CODE = "ZOOMAPPT"
	SkypeAppType                     CODE = "SKYAPPT"
	TeamsAppType                     CODE = "TEMAPPT"
	CommercialPropertyType           CODE = "TYPCOMMER"
	AgriculturalPropertyType         CODE = "TYPAGRICUL"
	IndustrialPropertyType           CODE = "TYPINDUSTR"
	CommercialLicenseType            CODE = "0COMERCIAL"
	ReraLicenseType                  CODE = "000000RERA"
	ORNLicenseType                   CODE = "0000000ORN"
	ExtraLicenseType                 CODE = "00000EXTRA"
	BRNLicenseType                   CODE = "0000000BRN"
	NOCLicenseType                   CODE = "0000000NOC"
	TrakheesPermitNoLicenseFields    CODE = "00TRAKHEES" // commercial license field only for dubai
	DCCINoLicenseFields              CODE = "0000DCCINO" // commercial license field only for dubai
	RegisterNoLicenseFields          CODE = "00REGISTER" // commercial license field only for dubai
	FacebookSocialMedia              CODE = "00FACEBOOK"
	InstagramSocialMedia             CODE = "0INSTAGRAM"
	LinkedInSocialMedia              CODE = "00LINKEDIN"
	TwitterSocialMedia               CODE = "000TWITTER"
	YoutubeSocialMedia               CODE = "000YOUTUBE"
	OtherSocialMedia                 CODE = "00000OTHER"
	RequestedSocialConnectionStatus  CODE = "0REQSOCIAL"
	AcceptedSocialConnectionStatus   CODE = "0ACPSOCIAL"
	RejectedSocialConnectionStatus   CODE = "0REJSOCIAL"
	BlockedSocialConnectionStatus    CODE = "0BLOSOCIAL"
	CompanySubscriberType            CODE = "000COMPANY"
	FreelancerSubscriberType         CODE = "0FRELANCER"
	OwnerSubscriberType              CODE = "00000OWNER"
	MonthlyPaymentPlan               CODE = "000MONTHLY"
	QuartelyPaymentPlan              CODE = "00QUARTRLY"
	BiAnnualPaymentPlan              CODE = "00BIANNUAL"
	YearlyPaymentPlan                CODE = "0000YEARLY"
	CashPaymentMethod                CODE = "000CASHPAY"
	ChequePaymentMethod              CODE = "000CHEQPAY"
	BankTransferPaymentMethod        CODE = "000BANKPAY"

	UserActiveCode   CODE = "USRTYPEACTV"
	UserDeActiveCode CODE = "USRTPDEACTV"

	UAEPassSocialLoginType  CODE = "0000UAEPASS"
	GoogleSocialLoginType   CODE = "00000GOOGLE"
	FacebookSocialLoginType CODE = "000FACEBOOK"
	AppleSocialLoginType    CODE = "000000APPLE"

	CareerFullTimeEmploymentType CODE = "CAREMPTFULT"
	CareerPartTimeEmploymentType CODE = "CAREMPTPRTT"

	CareerRemoteEmploymentMode CODE = "CAREMOTEMPMODE"
	CareerOnSiteEmploymentMode CODE = "CARONSITEMPMODE"
	CareerHybridEmploymentMode CODE = "CARHYBEMPMODE"

	JobStyleContract          CODE = "JOBSTLCONT"
	JobStyleVolunteer         CODE = "JOBSTLVOLT"
	JobStyleInternshipStudent CODE = "JOBSTLINSTU"
	JobStyleTemporary         CODE = "JOBSTLTEMP"
	JobStylePerminant         CODE = "JOBSTLPERM"

	CareerLevelJunior CODE = "CARLEVJUN"
	CareerLevelSenior CODE = "CARLEVSEN"
	CareerLevelExpert CODE = "CARLEVEXP"
	CareerLevelAny    CODE = "CARLEVANY"

	CareerStatusPublished CODE = "CARPUBLISHED"
	CareerStatusDeleted   CODE = "CARDELETED"

	CareerStatusExpired  CODE = "CAREXPIRED"
	CareerStatusReposted CODE = "CARDREPOSTED"
	CareerStatusClosed   CODE = "CARCLOSED"

	CareerEducationalLevelSecondary   CODE = "EDULVLSEC"
	CareerEducationalLevelDiploma     CODE = "EDULVLDIPL"
	CareerEducationalLevelUniversity  CODE = "EDULVLUNI"
	CareerEducationalLevelMasters     CODE = "EDULVLMAST"
	CareerEducationalLevelPhD         CODE = "EDULVLPHD"
	CareerEducationalLevelAny         CODE = "EDULVLANY"
	DraftSubscriptionStatus           CODE = "DRAFTSUBSCRIPTION"
	ActiveSubscriptionStatus          CODE = "ACTIVESUBSCRIPTION"
	InActiveSubscriptionStatus        CODE = "INACTIVESUBSCRIPTION"
	ExpireSubscriptionStatus          CODE = "EXPIRESUBSCRIPTION"
	PaidSubscriptionPaymentStatus     CODE = "000000PAID"
	UnPaidSubscriptionPaymentStatus   CODE = "000000UNPAID"
	LegalSubscriberVerificationType   CODE = "LEGALSUBTYPE"
	FinanceSubscriberVerificationType CODE = "FINANSUBTYPE"

	SaleCategory    CODE = "SALECATEGORY"
	RentCategory    CODE = "RENTCATEGORY"
	SwapCategory    CODE = "SWAPCATEGORY"
	BookingCategory CODE = "BOOKCATEGORY"

	ApprovalStatusPending    CODE = "PENDING"
	ApprovalStatusProcessing CODE = "PROCESSING"
	ApprovalStatusApproved   CODE = "APPROVED"
	ApprovalStatusRejected   CODE = "REJECTED"

	// FacilityAmenityType
	FacilityType CODE = "0FACILITYTYP"
	AmenityType  CODE = "00AMENITYTYP"

	InActiveSettingsStatus CODE = "INACTIVESETTINGSTATUS"
	ActiveSettingsStatus   CODE = "ACTIVESETTINGSTATUS"
	DeleteSettingsStatus   CODE = "DELETESETTINGSTATUS"

	ActivePlatformUserStatus CODE = "ACTIVEPLATFORMUSERSTATUS"
	DeletePlatformUserStatus CODE = "DELETEPLATFOMRUSERSTATUS"

	DashboardPlatformType CODE = "DASHBOARDPLATFORMTYPE"
	WebsitePlatformType   CODE = "WEBSITEPLATFORMTYPE"

	BasicBannerPackage    CODE = "BASICBANNERPACKAGE"
	StandardBannerPackage CODE = "STANDARDBANNERPACKAGE"
	AdvanceBannerPackage  CODE = "ADVANCEBANNERPACKAGE"

	BannerPlanTypeCPM CODE = "BANNERPLANTYPECPM"
	BannerPlanTypeCPC CODE = "BANNERPLANCPC"

	BannerMobilePlatform  CODE = "BANNERMOBILEPLATFORM"
	BannerWebsitePlatform CODE = "BANNERWEBSITEPLATFORM"
)

var (
	mapNameWithCode = map[CODE]NAME{
		// AffordableLifeStyle:          "Affordable",
		StandardLifeStyle: "Standard",
		LuxuryLifeStyle:   "Luxury",
		// UltraLuxuryLifeStyle:         "Ultra Luxury",
		StandardRank:                 "Standard",
		FeaturedRank:                 "Featured",
		PremiumRank:                  "Premium",
		TopDealsRank:                 "Top Deals",
		CompanyAdminUserTypes:        "Company Admin",
		AgentUserTypes:               "Agent",
		OwnerOrIndividualUserTypes:   "Owner/Individual",
		FreelancerUserTypes:          "Freelancer",
		AqaryUserUserTypes:           "Aqary User",
		SuperAdminUserTypes:          "Super Admin",
		CompanyUserUserTypes:         "Company User",
		BrokerCompanyCompanyTypes:    "Broker Company",
		DeveloperCompanyCompanyTypes: "Developer Company",
		ServiceCompanyCompanyTypes:   "Services Company",
		ProductCompanyCompanyTypes:   "Product Company",

		LeftBannerDirection:        "Left Banner Direction",
		TopLeftBannerDirection:     "Top Left Banner Direction",
		RightBannerDirection:       "Right Banner Direction",
		TopRightBannerDirection:    "Top Right Banner Direction",
		TopBannerDirection:         "Top Banner Direction",
		BottomBannerDirection:      "Bottom Banner Direction",
		BottomLeftBannerDirection:  "Bottom Left Banner Direction",
		BottomRightBannerDirection: "Bottom Right Banner Direction",
		CenterBannerDirection:      "Center Banner Direction",

		VerticalBannerPosition:   "Vertical Banner Position",
		HorizontalBannerPosition: "Horizontal Banner Position",

		HomePageBannerCriteriaName:                "HomePage Banner Criteria Name",
		DeveloperCompanyListingBannerCriteriaName: "Developer Company Listing Banner Criteria Name",
		TeamListingBannerCriteriaName:             "Team Listing Banner Criteria Name",
		UnitBannerCriteriaName:                    "Unit Banner Criteria Name",
		PropertyBannerCriteriaName:                "Property Banner Criteria Name",
		BlogBannerCriteriaName:                    "Blog Banner Criteria Name",
		AgricultureBannerCriteriaName:             "Agriculture Banner Criteria Name",
		CommunityGuideBannerCriteriaName:          "CommunityGuide Banner Criteria Name",

		PageBannerCriteriaType:    "Page Banner Criteria Type",
		SectionBannerCriteriaType: "Section Banner Criteria Type",
		// TypeBannerCriteriaType:             "Type Banner Criteria Type",
		// CommunityBannerCriteriaType:        "Community Banner Criteria Type",
		// NetworkCompaniesBannerCriteriaType: "Network Companies Banner Criteria Type",

		HomePageType:           "Home",
		ContactsPageType:       "Contacts",
		AboutUsPageType:        "About Us",
		GalleryPageType:        "Gallery",
		MapPageType:            "Map",
		UnitPageType:           "Unit",
		LuxuryUnitPageType:     "Luxury Unit",
		PropertyPageType:       "Property",
		LuxuryPropertyPageType: "Luxury Property",
		AreaGuidePageType:      "Area Guide",
		ServicesPageType:       "Services",

		DraftStatus:        "Draft",
		AvailableStatus:    "Available",
		SoldStatus:         "Sold",
		RentedStatus:       "Rented",
		BlockedStatus:      "Blocked",
		DeletedStatus:      "Deleted",
		UnderProcessStatus: "Under Process",
		UnderOfferStatus:   "Under Offer",
		ComingSoonStatus:   "Coming Soon",

		OffPlanCompletionStatus:              "Off Plan",
		ReadyCompletionStatus:                "Ready",
		TowerStructurePlan:                   "Tower Structure",
		MasterPlan:                           "Master Plan",
		FloorPlan:                            "Floor Plan",
		SitePlan:                             "Site Plan",
		FreeholdOwnerShip:                    "Freehold",
		GccCititzenOwnerShip:                 "GCC Citizen",
		LeaseHoldOwnerShip:                   "Leasehold",
		LocalCitizenOwnerShip:                "Local Citizen",
		UsufructOwnerShip:                    "USUFRUCT",
		OtherOwnerShip:                       "Other",
		FreezoneOwnerShip:                    "Freezone",
		NonFurnished:                         "Non Furnished",
		SemiFurnished:                        "Semi Furnished",
		FullyFurnished:                       "Fully Furnished",
		ProjectProperty:                      "Project Property",
		FreelancerProperty:                   "Freelancer Property",
		BrokerProperty:                       "Broker Property",
		OwnerProperty:                        "Owner Property",
		ImageMediaType:                       "Image",
		Tour360MediaType:                     "360 Tour",
		VideoMediaType:                       "Video",
		Video360MediaType:                    "360 Video",
		PdfMediaType:                         "PDF",
		FreelancerPropertyCategory:           "Freelancer",
		BrokerPropertyCategory:               "Broker",
		OwnerPropertyCategory:                "Owner",
		SaleSection:                          "Sale",
		RentSection:                          "Rent",
		SwapSection:                          "Swap",
		PropertyHubSection:                   "Property Hub",
		IndustrialSection:                    "Industrial",
		AgricultureSection:                   "Agriculture",
		LikesReaction:                        "Likes (Thumbs Up)",
		FavouritesReaction:                   "Favourites (Heart)",
		StarReaction:                         "Star",
		CelebrateReaction:                    "Celebrate (Confetti)",
		DealReaction:                         "Deal (Handshake)",
		UnlikeReaction:                       "Unlike (Thumbs Down)",
		YearlyRentType:                       "Yearly",
		QuarterRentType:                      "Quarter",
		MonthlyRentType:                      "Monthly",
		WeeklyRentType:                       "Weekly",
		DailyRentType:                        "Daily",
		NewestSortBy:                         "Newest",
		MinPriceSortBy:                       "Min Price",
		MaxPriceSortBy:                       "Max Price",
		MinBedroomSortBy:                     "Min Bedroom",
		MaxBedroomSortBy:                     "Max Bedroom",
		IndividualLeadAndContacts:            "Individual",
		CompanyLeadAndContacts:               "Company",
		OwnerContactType:                     "Owner",
		BuyerContactType:                     "Buyer",
		SellerContactType:                    "Seller",
		SalesLeadType:                        "Sales",
		LeasingLeadType:                      "Leasing",
		EndUserLeadPurpose:                   "End-User",
		InvestorLeadPurpose:                  "Investor",
		RtoLeadPurpose:                       "RTO",
		ResidentResidentialStatus:            "Resident",
		NonResidentResidentialStatus:         "Non-Resident",
		DraftAppointmentRequestStatus:        "Draft",
		SubmittedAppointmentRequestStatus:    "Submitted",
		RejectedAppointmentRequestStatus:     "Rejected",
		CancelledAppointmentRequestStatus:    "Cancelled",
		BookedAppointmentRequestStatus:       "Booked",
		BookedAppointmentStatus:              "Booked",
		RescheduledAppointmentStatus:         "Rescheduled",
		CancelledAppointmentStatus:           "Cancelled",
		NoAnswerAppointmentStatus:            "No Answer",
		NoConfirmationAppointmentStatus:      "No Confirmation",
		RejectedAppointmentStatus:            "Rejected",
		OcularVisitAppointmentType:           "Ocular Visit",
		LiveMeetingAppointmentType:           "Live Meeting",
		RequestVerificationCallActivityTypes: "Request Verification",
		FollowUpCallActivityTypes:            "Follow-Up",
		CallingAgentCallActivityTypes:        "Calling Agent",
		CallingClientCallActivityTypes:       "Calling Client",
		CallingOwnerCallActivityTypes:        "Calling Owner",
		ConfirmingOwnerForUnitAvailabilityCallActivityTypes: "Confirming Owner for Unit Availability",
		ConfirmingAttendanceWithAgentCallActivityTypes:      "Confirming Attendance with Agent",
		ConfirmingAttendanceWithClientCallActivityTypes:     "Confirming Attendance with Client",
		NoAnswerCallActivityStatus:                          "No Answer",
		CallRejectedCallActivityStatus:                      "Call Rejected",
		LineBusyCallActivityStatus:                          "Line Busy",
		OutOfCoverageAreaCallActivityStatus:                 "Out of Coverage Area",
		Inch:                                                "inch",
		SquareFeet:                                          "sqft",
		SquareMeter:                                         "sqm",
		SaleProjectUnitCategories:                           "sale",
		RentProjectUnitCategories:                           "rent",
		Bank:                                                "Bank",
		FinancialInstitution:                                "Financial Institution",
		MainGalleryType:                                     "Main",
		CoverGalleryType:                                    "Cover",
		FacilitiesGalleryType:                               "Facilities",
		AmenitiesGalleryType:                                "Amenities",
		ExteriorGalleryType:                                 "Exterior",
		InteriorGalleryType:                                 "Interior",
		BrochureGalleryType:                                 "Brochure",
		WebPortalsPublishType:                               "Web Portals",
		SocialMediaPublishType:                              "Social Media",
		SocialHubPublishType:                                "Social Hub",
		InternalShareType:                                   "Internal Share",
		ExternalShareType:                                   "External Share",
		ActiveVATStatus:                                     "Active",
		NonActiveVATStatus:                                  "Non-Active",
		PendingVATStatus:                                    "Pending",
		RequestedOpenhouseAppointment:                       "Requested",
		BookedOpenhouseAppointment:                          "Booked",
		ClosedOpenhouseAppointment:                          "Closed",
		RescheduledOpenhouseAppointment:                     "Rescheduled",
		DeletedOpenhouseAppointment:                         "Deleted",
		RejectedOpenhouseAppointment:                        "Rejected",
		AvailableOpenhouseTimeslot:                          "Available",
		NotAvailableOpenhouseTimeslot:                       "Not Available",

		PendingLegallySubscriberStatus:       "Pending Legally",
		PendingFinanciallySubscriberStatus:   "Pending Financially",
		RejectedLegallySubscriberStatus:      "Rejected Legally",
		RejectedFinanciallySubscriberStatus:  "Rejected Financially",
		PendingSubscriptionSubscriberStatus:  "Pending Subscription",
		PendingFinalContractSubscriberStatus: "Pending Final Contract",
		ApprovedSubscriberStatus:             "Approved",

		MaleGender:                       "Male",
		FemaleGender:                     "Female",
		ProjectEntityType:                "Project",
		CompanyProfileEntityType:         "Company Profile",
		CompanyProfileProjectEntityType:  "Company Profile Project",
		CompanyProfilePhaseEntityType:    "Company Profile Phase",
		PhaseEntityType:                  "Phase",
		PropertyEntityType:               "Property",
		ExhibitionsEntityType:            "Exhibitions",
		UnitEntityType:                   "Unit",
		CompanyEntityType:                "Company",
		ProfileEntityType:                "Profile",
		FreelancerEntityType:             "Freelancer",
		UserEntityType:                   "User",
		HolidayEntityType:                "Holiday",
		ServiceEntityType:                "Service",
		OpenhouseEntityType:              "Open House",
		ScheduleViewEntityType:           "Schedule View",
		UnitVersionsEntityType:           "Unit Versions",
		PropertyVersionsEntityType:       "Property Versions",
		PublishEntityType:                "Publish",
		CompanyActivityEntityType:        "Company Activity",
		CommunityGuideEntityType:         "Community Guidelines",
		BannerEntityType:                 "Banner",
		ReservationRequestsEntityType:    "ReservationRequest",
		CompanyActivityDetailsEntityType: "CompanyActivityDetails",

		ResidentialPropertyType:  "Residential",
		CommercialPropertyType:   "Commercial",
		AgriculturalPropertyType: "Agricultural",
		IndustrialPropertyType:   "Industrial",
		CommercialLicenseType:    "Commercial License",
		ReraLicenseType:          "Rera Number",
		ORNLicenseType:           "ORN License",
		ExtraLicenseType:         "Extra License",
		BRNLicenseType:           "BRN License",
		NOCLicenseType:           "NOC License",

		AppoinmentOnlineType:  "online Appoinment",
		AppoinmentOfflineType: "offline Appoinment",

		GmeetAppType: "Gmeet App",
		ZoomAppType:  "Zoom App",
		SkypeAppType: "Skype App",
		TeamsAppType: "Teams App",

		TrakheesPermitNoLicenseFields: "Trakhees Permit No",
		DCCINoLicenseFields:           "DCCI No",
		RegisterNoLicenseFields:       "Register No",

		FacebookSocialMedia:             "Facebook",
		InstagramSocialMedia:            "Instagram",
		LinkedInSocialMedia:             "LinkedIn",
		TwitterSocialMedia:              "Twitter",
		YoutubeSocialMedia:              "Youtube",
		OtherSocialMedia:                "Other",
		RequestedSocialConnectionStatus: "Requested",
		AcceptedSocialConnectionStatus:  "Accepted",
		RejectedSocialConnectionStatus:  "Rejected",
		BlockedSocialConnectionStatus:   "Blocked",
		CompanySubscriberType:           "Company",
		FreelancerSubscriberType:        "Freelancer",
		OwnerSubscriberType:             "Owner",

		MonthlyPaymentPlan:  "Monthly",
		QuartelyPaymentPlan: "Quarterly",
		BiAnnualPaymentPlan: "Bi-Annual",
		YearlyPaymentPlan:   "Yearly",

		CashPaymentMethod:         "Cash",
		ChequePaymentMethod:       "Cheque",
		BankTransferPaymentMethod: "Bank Transfer",

		UserActiveCode:   "Active",
		UserDeActiveCode: "InActive",

		UAEPassSocialLoginType:  "UAEPass",
		GoogleSocialLoginType:   "Google",
		FacebookSocialLoginType: "Facebook",
		AppleSocialLoginType:    "Apple",

		CareerFullTimeEmploymentType: "Full Time Employment",
		CareerPartTimeEmploymentType: "Part Time Employment",

		CareerRemoteEmploymentMode: "Remote Employment Mode",
		CareerOnSiteEmploymentMode: "On-Site Employment Mode",
		CareerHybridEmploymentMode: "Hybrid Employment Mode",

		JobStyleContract:          "Contract Job Style",
		JobStyleVolunteer:         "Volunteer Job Style",
		JobStyleInternshipStudent: "Internship/Student Job Style",
		JobStyleTemporary:         "Temporary Job Style",
		JobStylePerminant:         "Perminant Job Style",

		CareerLevelJunior: "Career Level Junior",
		CareerLevelSenior: "Career Level Senior",
		CareerLevelExpert: "Career Level Expert",
		CareerLevelAny:    "Career Level Any",

		CareerStatusPublished: "Career Status Published",
		CareerStatusDeleted:   "Career Status Deleted",
		CareerStatusExpired:   "Career Status Expired",
		CareerStatusReposted:  "Career Status Reposted",
		CareerStatusClosed:    "Career Status Closed",

		CareerEducationalLevelSecondary:  "Career Educational Level Secondary",
		CareerEducationalLevelDiploma:    "Career Educational Level Diploma",
		CareerEducationalLevelUniversity: "Career Educational Level Bachelor's",
		CareerEducationalLevelMasters:    "Career Educational Level Masters",
		CareerEducationalLevelPhD:        "Career Educational Level PhD",
		CareerEducationalLevelAny:        "Career Educational Level Any",

		DraftSubscriptionStatus:    "Draft",
		ActiveSubscriptionStatus:   "Active",
		InActiveSubscriptionStatus: "In-Active",
		ExpireSubscriptionStatus:   "Expired",

		PaidSubscriptionPaymentStatus:   "Paid",
		UnPaidSubscriptionPaymentStatus: "Un-Paid",

		LegalSubscriberVerificationType:   "Legal",
		FinanceSubscriberVerificationType: "Finance",

		SaleCategory:    "Sale",
		RentCategory:    "Rent",
		SwapCategory:    "Swap",
		BookingCategory: "Booking",

		ApprovalStatusPending:    "Pending",
		ApprovalStatusProcessing: "Processing",
		ApprovalStatusApproved:   "Approved",
		ApprovalStatusRejected:   "Rejected",

		FacilityType: "Facility",
		AmenityType:  "Amenity",

		InActiveSettingsStatus: "In-Active",
		ActiveSettingsStatus:   "Active",
		DeleteSettingsStatus:   "Deleted",

		ActivePlatformUserStatus: "Active",
		DeletePlatformUserStatus: "Deleted",

		DashboardPlatformType: "Dashboard",
		WebsitePlatformType:   "website",

		BasicBannerPackage:    "Basic",
		StandardBannerPackage: "Standard",
		AdvanceBannerPackage:  "Advance",

		BannerPlanTypeCPM: "CPM",
		BannerPlanTypeCPC: "CPC",

		BannerMobilePlatform:  "Mobile",
		BannerWebsitePlatform: "Website",
	}
)

var (
	mapConstantWithCode = map[CODE]int{
		// AffordableLifeStyle:          1,
		StandardLifeStyle: 2,
		LuxuryLifeStyle:   3,
		// UltraLuxuryLifeStyle:         4,
		StandardRank:                 1,
		FeaturedRank:                 2,
		PremiumRank:                  3,
		TopDealsRank:                 4,
		CompanyAdminUserTypes:        1,
		AgentUserTypes:               2,
		OwnerOrIndividualUserTypes:   3,
		FreelancerUserTypes:          4,
		AqaryUserUserTypes:           5,
		SuperAdminUserTypes:          6,
		CompanyUserUserTypes:         7,
		BrokerCompanyCompanyTypes:    1,
		DeveloperCompanyCompanyTypes: 2,
		ServiceCompanyCompanyTypes:   3,
		ProductCompanyCompanyTypes:   4,

		LeftBannerDirection:        1,
		TopLeftBannerDirection:     2,
		RightBannerDirection:       3,
		TopRightBannerDirection:    4,
		TopBannerDirection:         5,
		BottomBannerDirection:      6,
		BottomLeftBannerDirection:  7,
		BottomRightBannerDirection: 8,
		CenterBannerDirection:      9,

		VerticalBannerPosition:   1,
		HorizontalBannerPosition: 2,

		HomePageBannerCriteriaName:                1,
		DeveloperCompanyListingBannerCriteriaName: 1,
		TeamListingBannerCriteriaName:             2,
		UnitBannerCriteriaName:                    3,
		PropertyBannerCriteriaName:                4,
		BlogBannerCriteriaName:                    5,
		AgricultureBannerCriteriaName:             6,
		CommunityGuideBannerCriteriaName:          7,

		PageBannerCriteriaType:    1,
		SectionBannerCriteriaType: 2,
		// TypeBannerCriteriaType:             3,
		// CommunityBannerCriteriaType:        4,
		// NetworkCompaniesBannerCriteriaType: 5,

		HomePageType:           1,
		ContactsPageType:       2,
		AboutUsPageType:        3,
		GalleryPageType:        4,
		MapPageType:            5,
		UnitPageType:           6,
		LuxuryUnitPageType:     7,
		PropertyPageType:       8,
		LuxuryPropertyPageType: 9,
		AreaGuidePageType:      10,
		ServicesPageType:       11,

		DraftStatus:        1,
		AvailableStatus:    2,
		SoldStatus:         3,
		RentedStatus:       4,
		BlockedStatus:      5,
		DeletedStatus:      6,
		UnderProcessStatus: 7,
		UnderOfferStatus:   8,
		ComingSoonStatus:   9,

		OffPlanCompletionStatus:              4,
		ReadyCompletionStatus:                5,
		TowerStructurePlan:                   1,
		MasterPlan:                           2,
		FloorPlan:                            3,
		SitePlan:                             4,
		FreeholdOwnerShip:                    1,
		GccCititzenOwnerShip:                 2,
		LeaseHoldOwnerShip:                   3,
		LocalCitizenOwnerShip:                4,
		UsufructOwnerShip:                    5,
		OtherOwnerShip:                       6,
		FreezoneOwnerShip:                    7,
		NonFurnished:                         1,
		SemiFurnished:                        2,
		FullyFurnished:                       3,
		ProjectProperty:                      1,
		FreelancerProperty:                   2,
		BrokerProperty:                       3,
		OwnerProperty:                        4,
		ImageMediaType:                       1,
		Tour360MediaType:                     2,
		VideoMediaType:                       3,
		Video360MediaType:                    4,
		PdfMediaType:                         5,
		FreelancerPropertyCategory:           1,
		BrokerPropertyCategory:               2,
		OwnerPropertyCategory:                3,
		SaleSection:                          1,
		RentSection:                          2,
		SwapSection:                          3,
		PropertyHubSection:                   4,
		IndustrialSection:                    5,
		AgricultureSection:                   6,
		LikesReaction:                        1,
		FavouritesReaction:                   2,
		StarReaction:                         3,
		CelebrateReaction:                    4,
		DealReaction:                         5,
		UnlikeReaction:                       6,
		YearlyRentType:                       1,
		QuarterRentType:                      2,
		MonthlyRentType:                      3,
		WeeklyRentType:                       4,
		DailyRentType:                        5,
		NewestSortBy:                         1,
		MinPriceSortBy:                       2,
		MaxPriceSortBy:                       3,
		MinBedroomSortBy:                     4,
		MaxBedroomSortBy:                     5,
		IndividualLeadAndContacts:            1,
		CompanyLeadAndContacts:               2,
		OwnerContactType:                     1,
		BuyerContactType:                     2,
		SellerContactType:                    3,
		SalesLeadType:                        1,
		LeasingLeadType:                      2,
		EndUserLeadPurpose:                   1,
		InvestorLeadPurpose:                  2,
		RtoLeadPurpose:                       3,
		ResidentResidentialStatus:            1,
		NonResidentResidentialStatus:         2,
		DraftAppointmentRequestStatus:        1,
		SubmittedAppointmentRequestStatus:    2,
		RejectedAppointmentRequestStatus:     3,
		CancelledAppointmentRequestStatus:    4,
		BookedAppointmentRequestStatus:       5,
		BookedAppointmentStatus:              1,
		RescheduledAppointmentStatus:         2,
		CancelledAppointmentStatus:           3,
		NoAnswerAppointmentStatus:            4,
		NoConfirmationAppointmentStatus:      5,
		RejectedAppointmentStatus:            6,
		OcularVisitAppointmentType:           1,
		LiveMeetingAppointmentType:           2,
		RequestVerificationCallActivityTypes: 1,
		FollowUpCallActivityTypes:            2,
		CallingAgentCallActivityTypes:        3,
		CallingClientCallActivityTypes:       4,
		CallingOwnerCallActivityTypes:        5,
		ConfirmingOwnerForUnitAvailabilityCallActivityTypes: 6,
		ConfirmingAttendanceWithAgentCallActivityTypes:      7,
		ConfirmingAttendanceWithClientCallActivityTypes:     8,
		NoAnswerCallActivityStatus:                          1,
		CallRejectedCallActivityStatus:                      2,
		LineBusyCallActivityStatus:                          3,
		OutOfCoverageAreaCallActivityStatus:                 4,
		Inch:                                                1,
		SquareFeet:                                          2,
		SquareMeter:                                         3,
		SaleProjectUnitCategories:                           1,
		RentProjectUnitCategories:                           2,
		Bank:                                                1,
		FinancialInstitution:                                2,
		MainGalleryType:                                     1,
		CoverGalleryType:                                    2,
		FacilitiesGalleryType:                               3,
		AmenitiesGalleryType:                                4,
		ExteriorGalleryType:                                 5,
		InteriorGalleryType:                                 6,
		BrochureGalleryType:                                 7,
		WebPortalsPublishType:                               1,
		SocialMediaPublishType:                              2,
		SocialHubPublishType:                                3,
		InternalShareType:                                   1,
		ExternalShareType:                                   2,
		ActiveVATStatus:                                     1,
		NonActiveVATStatus:                                  2,
		PendingVATStatus:                                    3,

		RequestedOpenhouseAppointment:   1,
		BookedOpenhouseAppointment:      2,
		ClosedOpenhouseAppointment:      3,
		RescheduledOpenhouseAppointment: 4,
		DeletedOpenhouseAppointment:     5,
		RejectedOpenhouseAppointment:    6,

		AvailableOpenhouseTimeslot:    1,
		NotAvailableOpenhouseTimeslot: 2,

		PendingLegallySubscriberStatus:       1,
		PendingFinanciallySubscriberStatus:   2,
		RejectedLegallySubscriberStatus:      3,
		RejectedFinanciallySubscriberStatus:  4,
		PendingSubscriptionSubscriberStatus:  7,
		ApprovedSubscriberStatus:             8,
		PendingFinalContractSubscriberStatus: 9,

		MaleGender:                       1,
		FemaleGender:                     2,
		ProjectEntityType:                1,
		PhaseEntityType:                  2,
		PropertyEntityType:               3,
		ExhibitionsEntityType:            4,
		UnitEntityType:                   5,
		CompanyEntityType:                6,
		ProfileEntityType:                7,
		FreelancerEntityType:             8,
		UserEntityType:                   9,
		HolidayEntityType:                10,
		ServiceEntityType:                11,
		OpenhouseEntityType:              12,
		ScheduleViewEntityType:           13,
		UnitVersionsEntityType:           14,
		PropertyVersionsEntityType:       15,
		PublishEntityType:                16,
		CompanyActivityEntityType:        17,
		CompanyProfileEntityType:         18,
		CompanyProfileProjectEntityType:  19,
		CompanyProfilePhaseEntityType:    20,
		CommunityGuideEntityType:         21,
		BannerEntityType:                 22,
		ReservationRequestsEntityType:    23,
		CompanyActivityDetailsEntityType: 24,

		ResidentialPropertyType:  1,
		CommercialPropertyType:   2,
		AgriculturalPropertyType: 3,
		IndustrialPropertyType:   4,

		AppoinmentOnlineType:  1,
		AppoinmentOfflineType: 2,

		GmeetAppType: 1,
		ZoomAppType:  2,
		SkypeAppType: 3,
		TeamsAppType: 4,

		CommercialLicenseType: 1,
		ReraLicenseType:       2,
		ORNLicenseType:        3,
		ExtraLicenseType:      4,
		BRNLicenseType:        5,
		NOCLicenseType:        6,

		TrakheesPermitNoLicenseFields: 1,
		DCCINoLicenseFields:           2,
		RegisterNoLicenseFields:       3,

		FacebookSocialMedia:  1,
		InstagramSocialMedia: 2,
		LinkedInSocialMedia:  3,
		TwitterSocialMedia:   4,
		YoutubeSocialMedia:   5,
		OtherSocialMedia:     6,

		RequestedSocialConnectionStatus: 1,
		AcceptedSocialConnectionStatus:  2,
		RejectedSocialConnectionStatus:  3,
		BlockedSocialConnectionStatus:   4,

		CompanySubscriberType:    1,
		FreelancerSubscriberType: 2,
		OwnerSubscriberType:      3,

		MonthlyPaymentPlan:  1,
		QuartelyPaymentPlan: 2,
		BiAnnualPaymentPlan: 3,
		YearlyPaymentPlan:   4,

		CashPaymentMethod:         1,
		ChequePaymentMethod:       2,
		BankTransferPaymentMethod: 3,

		UserDeActiveCode: 1,
		UserActiveCode:   2,

		UAEPassSocialLoginType:  1,
		GoogleSocialLoginType:   2,
		FacebookSocialLoginType: 3,
		AppleSocialLoginType:    4,

		CareerFullTimeEmploymentType: 1,
		CareerPartTimeEmploymentType: 2,

		CareerRemoteEmploymentMode: 1,
		CareerOnSiteEmploymentMode: 2,
		CareerHybridEmploymentMode: 3,

		JobStyleContract:          1,
		JobStyleVolunteer:         2,
		JobStyleInternshipStudent: 3,
		JobStyleTemporary:         4,
		JobStylePerminant:         5,

		CareerEducationalLevelSecondary:  1,
		CareerEducationalLevelDiploma:    2,
		CareerEducationalLevelUniversity: 3,
		CareerEducationalLevelMasters:    4,
		CareerEducationalLevelPhD:        5,
		CareerEducationalLevelAny:        6,

		CareerLevelJunior: 1,
		CareerLevelSenior: 2,
		CareerLevelExpert: 3,
		CareerLevelAny:    4,

		CareerStatusPublished: 1,
		CareerStatusDeleted:   2,
		CareerStatusExpired:   3,
		CareerStatusReposted:  4,
		CareerStatusClosed:    5,

		DraftSubscriptionStatus:    1,
		ActiveSubscriptionStatus:   2,
		InActiveSubscriptionStatus: 3,
		ExpireSubscriptionStatus:   4,

		UnPaidSubscriptionPaymentStatus: 1,
		PaidSubscriptionPaymentStatus:   2,

		LegalSubscriberVerificationType:   1,
		FinanceSubscriberVerificationType: 2,

		SaleCategory:    1,
		RentCategory:    2,
		SwapCategory:    3,
		BookingCategory: 5,

		ApprovalStatusPending:    1,
		ApprovalStatusProcessing: 2,
		ApprovalStatusApproved:   3,
		ApprovalStatusRejected:   4,

		FacilityType: 1,
		AmenityType:  2,

		InActiveSettingsStatus: 1,
		ActiveSettingsStatus:   2,
		DeleteSettingsStatus:   6,

		ActivePlatformUserStatus: 2,
		DeletePlatformUserStatus: 6,

		DashboardPlatformType: 1,
		WebsitePlatformType:   2,

		BasicBannerPackage:    1,
		StandardBannerPackage: 2,
		AdvanceBannerPackage:  3,

		BannerPlanTypeCPM: 1,
		BannerPlanTypeCPC: 2,

		BannerMobilePlatform:  1,
		BannerWebsitePlatform: 2,
	}
)

var (
	mapWithType = map[TYPE][]CODE{
		CompanyUserType: {
			UserActiveCode,
			UserDeActiveCode,
		},
		UserTypes: {
			CompanyAdminUserTypes,
			AgentUserTypes,
			OwnerOrIndividualUserTypes,
			FreelancerUserTypes,
			AqaryUserUserTypes,
			SuperAdminUserTypes,
			CompanyUserUserTypes,
		},
		CompanyTypes: {
			BrokerCompanyCompanyTypes,
			DeveloperCompanyCompanyTypes,
			ServiceCompanyCompanyTypes,
			ProductCompanyCompanyTypes,
		},
		BannerDirection: {
			LeftBannerDirection,
			TopLeftBannerDirection,
			RightBannerDirection,
			TopRightBannerDirection,
			TopBannerDirection,
			BottomBannerDirection,
			BottomLeftBannerDirection,
			BottomRightBannerDirection,
			CenterBannerDirection,
		},
		BannerPosition: {
			VerticalBannerPosition,
			HorizontalBannerPosition,
		},
		BannerCriteriaType: {
			PageBannerCriteriaType,
			SectionBannerCriteriaType,
			// TypeBannerCriteriaType,
			// CommunityBannerCriteriaType,
			// NetworkCompaniesBannerCriteriaType,
		},
		Ranks: {
			StandardRank,
			FeaturedRank,
			PremiumRank,
			TopDealsRank,
		},
		Statuses: {
			DraftStatus,
			AvailableStatus,
			SoldStatus,
			RentedStatus,
			BlockedStatus,
			DeletedStatus,
			UnderProcessStatus,
			UnderOfferStatus,
			ComingSoonStatus,
		},
		CompletionStatus: {
			OffPlanCompletionStatus,
			ReadyCompletionStatus,
		},
		Plan: {
			TowerStructurePlan,
			MasterPlan,
			FloorPlan,
			SitePlan,
		},
		LifeStyle: {
			// AffordableLifeStyle,
			StandardLifeStyle,
			LuxuryLifeStyle,
			// UltraLuxuryLifeStyle,
		},
		OwnerShip: {
			FreeholdOwnerShip,
			GccCititzenOwnerShip,
			LeaseHoldOwnerShip,
			LocalCitizenOwnerShip,
			UsufructOwnerShip,
			OtherOwnerShip,
			FreezoneOwnerShip,
		},
		Furnishing: {
			NonFurnished,
			SemiFurnished,
			FullyFurnished,
		},
		Properties: {
			ProjectProperty,
			FreelancerProperty,
			BrokerProperty,
			OwnerProperty,
		},
		MediaType: {
			ImageMediaType,
			Tour360MediaType,
			VideoMediaType,
			Video360MediaType,
			PdfMediaType,
		},
		PropertyCategory: {
			FreelancerPropertyCategory,
			BrokerPropertyCategory,
			OwnerPropertyCategory,
		},
		Section: {
			SaleSection,
			RentSection,
			SwapSection,
			PropertyHubSection,
			IndustrialSection,
			AgricultureSection,
		},
		LikeReaction: {
			LikesReaction,
			FavouritesReaction,
			StarReaction,
			CelebrateReaction,
			DealReaction,
			UnlikeReaction,
		},
		RentType: {
			YearlyRentType,
			QuarterRentType,
			MonthlyRentType,
			WeeklyRentType,
			DailyRentType,
		},
		SortBy: {
			NewestSortBy,
			MinPriceSortBy,
			MaxPriceSortBy,
			MinBedroomSortBy,
			MaxBedroomSortBy,
		},
		LeadAndContacts: {
			IndividualLeadAndContacts,
			CompanyLeadAndContacts,
		},
		ContactType: {
			OwnerContactType,
			BuyerContactType,
			SellerContactType,
		},
		LeadType: {
			SalesLeadType,
			LeasingLeadType,
		},
		LeadPurpose: {
			EndUserLeadPurpose,
			InvestorLeadPurpose,
			RtoLeadPurpose,
		},
		ResidentialStatus: {
			ResidentResidentialStatus,
			NonResidentResidentialStatus,
		},
		AppointmentRequestStatus: {
			DraftAppointmentRequestStatus,
			SubmittedAppointmentRequestStatus,
			RejectedAppointmentRequestStatus,
			CancelledAppointmentRequestStatus,
			BookedAppointmentRequestStatus,
		},
		AppointmentStatus: {
			BookedAppointmentStatus,
			RescheduledAppointmentStatus,
			CancelledAppointmentStatus,
			NoAnswerAppointmentStatus,
			NoConfirmationAppointmentStatus,
			RejectedAppointmentStatus,
		},
		AppointmentType: {
			OcularVisitAppointmentType,
			LiveMeetingAppointmentType,
		},
		CallActivityTypes: {
			RequestVerificationCallActivityTypes,
			FollowUpCallActivityTypes,
			CallingAgentCallActivityTypes,
			CallingClientCallActivityTypes,
			CallingOwnerCallActivityTypes,
			ConfirmingOwnerForUnitAvailabilityCallActivityTypes,
			ConfirmingAttendanceWithAgentCallActivityTypes,
			ConfirmingAttendanceWithClientCallActivityTypes,
		},
		CallActivityStatus: {
			NoAnswerCallActivityStatus,
			CallRejectedCallActivityStatus,
			LineBusyCallActivityStatus,
			OutOfCoverageAreaCallActivityStatus,
		},
		UnitOfMeasure: {
			Inch,
			SquareFeet,
			SquareMeter,
		},
		ProjectUnitCategories: {
			SaleProjectUnitCategories,
			RentProjectUnitCategories,
		},
		FinancialProviderType: {
			Bank,
			FinancialInstitution,
		},
		GalleryType: {
			MainGalleryType,
			CoverGalleryType,
			FacilitiesGalleryType,
			AmenitiesGalleryType,
			ExteriorGalleryType,
			InteriorGalleryType,
			BrochureGalleryType,
		},
		PublishType: {
			WebPortalsPublishType,
			SocialMediaPublishType,
			SocialHubPublishType,
		},
		ShareType: {
			InternalShareType,
			ExternalShareType,
		},
		VATStatus: {
			ActiveVATStatus,
			NonActiveVATStatus,
			PendingVATStatus,
		},
		OpenhouseAppointment: {
			RequestedOpenhouseAppointment,
			BookedOpenhouseAppointment,
			ClosedOpenhouseAppointment,
			RescheduledOpenhouseAppointment,
			DeletedOpenhouseAppointment,
			RejectedOpenhouseAppointment,
		},
		OpenhouseTimeslot: {
			AvailableOpenhouseTimeslot,
			NotAvailableOpenhouseTimeslot,
		},
		SubscriberStatus: {
			ApprovedSubscriberStatus,
			PendingLegallySubscriberStatus,
			PendingFinanciallySubscriberStatus,
			RejectedLegallySubscriberStatus,
			RejectedFinanciallySubscriberStatus,
			PendingSubscriptionSubscriberStatus,
			PendingFinalContractSubscriberStatus,
		},
		Gender: {
			MaleGender,
			FemaleGender,
		},
		EntityType: {
			ProjectEntityType,
			PhaseEntityType,
			PropertyEntityType,
			ExhibitionsEntityType,
			UnitEntityType,
			CompanyEntityType,
			ProfileEntityType,
			FreelancerEntityType,
			UserEntityType,
			HolidayEntityType,
			ServiceEntityType,
			OpenhouseEntityType,
			ScheduleViewEntityType,
			UnitVersionsEntityType,
			PropertyVersionsEntityType,
			PublishEntityType,
			CompanyActivityEntityType,
			CompanyProfileProjectEntityType,
			CompanyProfileEntityType,
			CompanyProfilePhaseEntityType,
			CommunityGuideEntityType,
			BannerEntityType,
			ReservationRequestsEntityType,
			CompanyActivityDetailsEntityType,
		},
		AppointmentTypes: {
			AppoinmentOfflineType,
			AppoinmentOnlineType,
		},
		AppointmentApps: {
			GmeetAppType,
			ZoomAppType,
			SkypeAppType,
			TeamsAppType,
		},
		PropertyTypeUsage: {
			ResidentialPropertyType,
			CommercialPropertyType,
			AgriculturalPropertyType,
			IndustrialPropertyType,
		},
		LicenseType: {
			CommercialLicenseType,
			ReraLicenseType,
			ORNLicenseType,
			ExtraLicenseType,
			BRNLicenseType,
			NOCLicenseType,
		},
		LicenseFields: {
			TrakheesPermitNoLicenseFields,
			DCCINoLicenseFields,
			RegisterNoLicenseFields,
		},
		SocialMedia: {
			FacebookSocialMedia,
			InstagramSocialMedia,
			LinkedInSocialMedia,
			TwitterSocialMedia,
			YoutubeSocialMedia,
			OtherSocialMedia,
		},
		SocialConnectionStatus: {
			RequestedSocialConnectionStatus,
			AcceptedSocialConnectionStatus,
			RejectedSocialConnectionStatus,
			BlockedSocialConnectionStatus,
		},
		SubscriberType: {
			CompanySubscriberType,
			FreelancerSubscriberType,
			OwnerSubscriberType,
		},
		PaymentPlan: {
			MonthlyPaymentPlan,
			QuartelyPaymentPlan,
			BiAnnualPaymentPlan,
			YearlyPaymentPlan,
		},
		PageType: {
			HomePageType,
			ContactsPageType,
			AboutUsPageType,
			GalleryPageType,
			MapPageType,
			UnitPageType,
			LuxuryUnitPageType,
			PropertyPageType,
			LuxuryPropertyPageType,
			AreaGuidePageType,
			ServicesPageType,
		},
		PaymentMethod: {
			CashPaymentMethod,
			ChequePaymentMethod,
			BankTransferPaymentMethod,
		},
		SocialLoginType: {
			UAEPassSocialLoginType,
			GoogleSocialLoginType,
			FacebookSocialLoginType,
			AppleSocialLoginType,
		},
		Career: {
			CareerFullTimeEmploymentType,
			CareerPartTimeEmploymentType,

			CareerRemoteEmploymentMode,
			CareerOnSiteEmploymentMode,
			CareerHybridEmploymentMode,

			JobStyleContract,
			JobStyleVolunteer,
			JobStyleInternshipStudent,
			JobStyleTemporary,
			JobStylePerminant,

			CareerLevelJunior,
			CareerLevelSenior,
			CareerLevelExpert,
			CareerLevelAny,

			CareerStatusPublished,
			CareerStatusDeleted,
			CareerStatusExpired,
			CareerStatusReposted,
			CareerStatusClosed,

			CareerEducationalLevelSecondary,
			CareerEducationalLevelDiploma,
			CareerEducationalLevelUniversity,
			CareerEducationalLevelMasters,
			CareerEducationalLevelPhD,
			CareerEducationalLevelAny,
		},
		SubscriptionStatus: {
			DraftSubscriptionStatus,
			ActiveSubscriptionStatus,
			InActiveSubscriptionStatus,
			ExpireSubscriptionStatus,
		},
		SubscriptionPaymentStatus: {
			UnPaidSubscriptionPaymentStatus,
			PaidSubscriptionPaymentStatus,
		},

		SubscriberVerificationType: {
			LegalSubscriberVerificationType,
			FinanceSubscriberVerificationType,
		},
		Category: {
			SaleCategory,
			RentCategory,
			SwapCategory,
			BookingCategory,
		},
		ApprovalStatus: {
			ApprovalStatusPending,
			ApprovalStatusProcessing,
			ApprovalStatusApproved,
			ApprovalStatusRejected,
		},

		FacilityAmenityType: {
			FacilityType,
			AmenityType,
		},
		SettingsStatus: {
			InActiveSettingsStatus,
			ActiveSettingsStatus,
			DeleteSettingsStatus,
		},

		PlatformUserStatus: {
			ActivePlatformUserStatus,
			DeletePlatformUserStatus,
		},

		PlatformType: {
			DashboardPlatformType,
			WebsitePlatformType,
		},

		BannerPackage: {
			BasicBannerPackage,
			StandardBannerPackage,
			AdvanceBannerPackage,
		},

		BannerPlanType: {
			BannerPlanTypeCPM,
			BannerPlanTypeCPC,
		},

		BannerPlatform: {
			BannerMobilePlatform,
			BannerWebsitePlatform,
		},
	}
)

func GetConstantsByType(t TYPE) []Constant {
	allConstant := []Constant{}

	for _, c := range mapWithType[t] {
		allConstant = append(allConstant, Constant{
			Name: mapNameWithCode[c],
			Type: t,
			Code: c,
		})
	}

	return allConstant
}

func (c CODE) Int64() int64 {
	return int64(mapConstantWithCode[c])
}

func (c CODE) Int32() int32 {
	return int32(mapConstantWithCode[c])
}

func (c CODE) Int() int {
	return int(mapConstantWithCode[c])
}

func (n NAME) String() string {
	return string(n)
}

func (c CODE) Name() string {
	return string(mapNameWithCode[c])
}

// return constant name for code
func (t TYPE) ConstantName(i int64) string {
	for _, c := range mapWithType[t] {
		if c.Int64() == i {
			return mapNameWithCode[c].String()
		}
	}
	return ""
}

func (t TYPE) CompanyUserConstantName(i int64) string {
	for _, c := range mapWithType[t] {
		if c.Int64() == i {
			return mapNameWithCode[c].String()
		}
	}
	return ""
}

func (t TYPE) ConstantId(s string) int64 {
	for _, c := range mapWithType[t] {
		if strings.EqualFold(c.Name(), s) {
			return c.Int64()
		}
	}
	return 0
}

func toLower(s string) string {
	return strings.ToLower(s)
}

func (t TYPE) ConstantCode(i int64) CODE {
	for _, c := range mapWithType[t] {
		if c.Int64() == i {
			return c
		}
	}
	return ""
}

func (t TYPE) Contains(i int64) bool {
	for _, c := range mapWithType[t] {
		if c.Int64() == i {
			return true
		}
	}
	return false
}

// to check if the status is valid for update or not
func IsStatusValidForUpdate(currentStatus int64, newStatus int64) (msg string, valid bool) {
	current := Statuses.ConstantName(currentStatus)
	updated := Statuses.ConstantName(newStatus)

	switch current {
	case DraftStatus.Name(): // Draft/Pending can be move to Any Status
		msg = fmt.Sprintf("status can be update from %v to %v", current, updated)
		return msg, true

	case AvailableStatus.Name(): // Available can be move to Draft/Pending, Sold Or Blocked
		if slices.Contains([]CODE{DraftStatus, SoldStatus, BlockedStatus}, Statuses.ConstantCode(newStatus)) {
			msg = fmt.Sprintf("status can be update from %v to %v", current, updated)
			return msg, true
		}
		msg = fmt.Sprintf("status cannot be update from %v to %v", current, updated)
		return msg, false

	case SoldStatus.Name(): // Sold can be move to Draft/Pending, Available Or Blocked
		if slices.Contains([]CODE{DraftStatus, AvailableStatus, BlockedStatus}, Statuses.ConstantCode(newStatus)) {
			msg = fmt.Sprintf("status can be update from %v to %v", current, updated)
			return msg, true
		}
		msg = fmt.Sprintf("status cannot be update from %v to %v", current, updated)
		return msg, false

	case RentedStatus.Name(): // Rented can be move to Draft/Pending, Available Or Blocked
		if slices.Contains([]CODE{DraftStatus, AvailableStatus, BlockedStatus}, Statuses.ConstantCode(newStatus)) {
			msg = fmt.Sprintf("status can be update from %v to %v", current, updated)
			return msg, true
		}
		msg = fmt.Sprintf("status cannot be update from %v to %v", current, updated)
		return msg, false

	case BlockedStatus.Name(): // Blocked can be move to Draft/Pending, Available, Sold Or Rent
		if slices.Contains([]CODE{DraftStatus, AvailableStatus, SoldStatus, RentedStatus}, Statuses.ConstantCode(newStatus)) {
			msg = fmt.Sprintf("status can be update from %v to %v", current, updated)
			return msg, true
		}
		msg = fmt.Sprintf("status cannot be update from %v to %v", current, updated)
		return msg, false

	case DeletedStatus.Name(): // Deleted can be move to Draft/Pending only
		if Statuses.ConstantCode(newStatus) == DraftStatus {
			msg = fmt.Sprintf("status can be update from %v to %v", current, updated)
			return msg, true
		}
		msg = fmt.Sprintf("status cannot be update from %v to %v", current, updated)
		return msg, false
	// case UnderProcessStatus.Name():

	default:
		msg = fmt.Sprintf("status cannot be update from %v to %v", current, updated)
		return msg, false
	}

}
