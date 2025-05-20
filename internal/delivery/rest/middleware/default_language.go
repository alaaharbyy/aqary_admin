package middleware

import "github.com/gin-gonic/gin"

func SetDefaultLanguage() gin.HandlerFunc {
	return func(c *gin.Context) {
		// Get the Accept-Language header, defaulting to "en" if not present
		lang := c.GetHeader("Accept-Language")
		if lang == "" {
			lang = "en" // Default language
		}

		// Optionally, you can add more logic here to validate and parse languages
		// For example, handling "en-US" or "en-GB" and falling back to "en".

		// Set the language in the request context
		c.Set("language", lang)

		// Continue to the next handler
		c.Next()
	}
}
