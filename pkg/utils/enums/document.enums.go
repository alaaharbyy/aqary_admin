package enums

import "fmt"

// This value will store in auction_documents.document_type column
type DocumentType int64

const (
	AuctionDocuments DocumentType = iota + 1
	TenancyContract
	IncomeStatement
	OwnershipTitle
)

// documentTypeStrings maps DocumentType values to their string representations
var documentTypeStrings = map[DocumentType]string{
	AuctionDocuments: "Auction Documents",
	TenancyContract:  "Tenancy Contract",
	IncomeStatement:  "Income Statement",
	OwnershipTitle:   "Ownership Title",
}

// documentTypeValues maps string representations to their DocumentType values
var documentTypeValues = map[string]DocumentType{
	"Auction Documents": AuctionDocuments,
	"Tenancy Contract":  TenancyContract,
	"Income Statement":  IncomeStatement,
	"Ownership Title":   OwnershipTitle,
}

// String returns the string representation of the DocumentType
func (dt DocumentType) String() string {
	return documentTypeStrings[dt]
}

// ParsePlanTitle converts a string to a DocumentType value
func ParseDocumentType(s string) (DocumentType, error) {
	dt, ok := documentTypeValues[s]
	if !ok {
		return 0, fmt.Errorf("invalid document type: %s", s)
	}
	return dt, nil
}
