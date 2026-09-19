// Package response defines the JSON envelope shared by every endpoint:
//
//	success: {"data": ..., "meta": {...}}
//	error:   {"error": {"code": "...", "message": "...", "details": [...]}}
package response

import "github.com/gin-gonic/gin"

type ErrorBody struct {
	Code    string `json:"code"`
	Message string `json:"message"`
	Details any    `json:"details,omitempty"`
}

type PageMeta struct {
	Page     int   `json:"page"`
	PageSize int   `json:"page_size"`
	Total    int64 `json:"total"`
}

func OK(c *gin.Context, status int, data any) {
	c.JSON(status, gin.H{"data": data})
}

func Paginated(c *gin.Context, status int, data any, meta PageMeta) {
	c.JSON(status, gin.H{"data": data, "meta": meta})
}

func Error(c *gin.Context, status int, code, message string, details any) {
	c.AbortWithStatusJSON(status, gin.H{"error": ErrorBody{Code: code, Message: message, Details: details}})
}
