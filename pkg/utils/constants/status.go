package constants

// @ the following are constants for status
const (
	REPOSTED = 7
	CLOSED   = 8
)

var StatusNames = map[int]string{
	REPOSTED: "REPOSTED",
	CLOSED:   "CLOSED",
}

const (
	APPLIED        = 1
	SHORTLISTED    = 2
	FINALINTERVIEW = 3
	PASSED         = 4
	FAILED         = 5
	ONBOARDING     = 7
)

var ApplicantionStatusNames = [...]string{
	"APPLIED",
	"SHORTLISTED",
	"FINALINTERVIEW",
	"PASSED",
	"FAILED",
	"DELETED",
	"ONBOARDING",
}

const (
	REQUESTED = 1
	ONGOING   = 2
	CANCELLED = 4
	REJECTED  = 5
)

var ServiceReqStatusNames = [...]string{
	"REQUESTED",
	"ONGOING",
	"CLOSED",
	"CANCELLED",
	"REJECTED",
	"DELETED",
}
