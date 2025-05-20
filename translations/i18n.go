package translations

import (
	"log"
	"os"
	"path/filepath"

	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"golang.org/x/text/language"
)

// Global variable to store the i18n bundle
var bundle *i18n.Bundle

// LoadTranslations initializes the i18n bundle with translation files
func LoadTranslations() {
	// Initialize the bundle with the default language (English)
	bundle = i18n.NewBundle(language.English)

	// Load translation files for supported languages
	loadLanguageFile("en")
	loadLanguageFile("ar")
}

// loadLanguageFile loads a language file into the i18n bundle
func loadLanguageFile(lang string) {
	root, err := os.Getwd()
	if err != nil {
		log.Fatalf("Error getting current directory: %v", err)
	}

	// Join the root path with the relative path to the translation files
	filePath := filepath.Join(root, "translations", "assets", lang+".json")

	_, err = os.Stat(filePath)
	if err != nil {
		log.Fatalf("Error loading language file %s: %v", lang, err)
	}

	// Load the message file for the given language
	if _, err := bundle.LoadMessageFile(filePath); err != nil {
		log.Fatalf("Error loading message file %s: %v", lang, err)
	}
}

// T function to get translation based on key and language
func T(ctx *gin.Context, key string, params ...map[string]interface{}) string {
	language, _ := ctx.Get("language")

	localizer := i18n.NewLocalizer(bundle, language.(string))
	translated, err := localizer.Localize(&i18n.LocalizeConfig{
		MessageID:    key,
		TemplateData: params,
	})
	if err != nil {
		log.Printf("Error translating key %s: %v", key, err)
	}
	return translated
}
