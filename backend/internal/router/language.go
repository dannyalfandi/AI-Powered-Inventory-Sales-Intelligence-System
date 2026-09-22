package router

import (
	"github.com/gin-gonic/gin"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
)

// language resolves Accept-Language once per request and puts the result in
// the request context, where handlers and services read it with i18n.T.
//
// The response carries Content-Language so a client can see which language it
// actually got — a request asking for French gets Indonesian, not an error.
func language() gin.HandlerFunc {
	return func(c *gin.Context) {
		lang := i18n.Parse(c.GetHeader("Accept-Language"))
		c.Request = c.Request.WithContext(i18n.WithLang(c.Request.Context(), lang))
		c.Header("Content-Language", string(lang))
		c.Next()
	}
}
