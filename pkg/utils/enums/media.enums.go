package enums

import "fmt"

// MediaType represents the type for media type
// this value will store in auction_media.media_type column
type MediaType int64

// Enum values for MediaType
const (
	Image MediaType = iota + 1
	Video
	Video360
	Panorama
)

// mediaTypeStrings maps MediaType values to their string representations
var mediaTypeStrings = map[MediaType]string{
	Image:    "Image",
	Video:    "Video",
	Video360: "360 Video",
	Panorama: "Panorama",
}

// mediaTypeValues maps string representations to their MediaType values
var mediaTypeValues = map[string]MediaType{
	"Image":     Image,
	"Video":     Video,
	"360 Video": Video360,
	"Panorama":  Panorama,
}

// String returns the string representation of the PlanTitle
func (mt MediaType) String() string {
	return mediaTypeStrings[mt]
}

// ParseMediaType converts a string to a MediaType value
func ParseMediaType(s string) (MediaType, error) {
	mt, ok := mediaTypeValues[s]
	if !ok {
		return 0, fmt.Errorf("invalid media type: %s", s)
	}
	return mt, nil
}

// GalleryType represents the type for gallery type
// this value will store in auction_media.gallery_type column
type GalleryType int64

// Enum values for GalleryType
const (
	Main GalleryType = iota + 1
	Cover
	Facilities
	Amenities
	Exterior
	Interior
	Brochure
)

// galleryTypeStrings maps GalleryType values to their string representations
var galleryTypeStrings = map[GalleryType]string{
	Main:       "Main",
	Cover:      "Cover",
	Facilities: "Facilities",
	Amenities:  "Amenities",
	Exterior:   "Exterior",
	Interior:   "Interior",
	Brochure:   "Brochure",
}

// galleryTypeValues maps string representations to their GalleryType values
var galleryTypeValues = map[string]GalleryType{
	"Main":       Main,
	"Cover":      Cover,
	"Facilities": Facilities,
	"Amenities":  Amenities,
	"Exterior":   Exterior,
	"Interior":   Interior,
	"Brochure":   Brochure,
}

// String returns the string representation of the GalleryType
func (gt GalleryType) String() string {
	return galleryTypeStrings[gt]
}

// ParseGalleryType converts a string to a GalleryType value
func ParseGalleryType(s string) (GalleryType, error) {
	gt, ok := galleryTypeValues[s]
	if !ok {
		return 0, fmt.Errorf("invalid gallery type: %s", s)
	}
	return gt, nil
}
