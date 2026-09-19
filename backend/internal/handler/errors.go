// Package handler contains Gin HTTP handlers. Handlers only parse requests,
// call a service, and map results/errors to HTTP responses.
package handler

import (
	"errors"
	"log/slog"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/pkg/response"
)

// writeError maps service errors to HTTP status codes. Unknown errors are
// logged and returned as a generic 500 so internals don't leak to clients.
func writeError(c *gin.Context, err error) {
	var verr *service.ValidationError
	switch {
	case errors.As(err, &verr):
		response.Error(c, http.StatusUnprocessableEntity, "validation_failed", "request validation failed", verr.Fields)
	case errors.Is(err, service.ErrNotFound):
		response.Error(c, http.StatusNotFound, "not_found", err.Error(), nil)
	case errors.Is(err, service.ErrConflict):
		response.Error(c, http.StatusConflict, "conflict", err.Error(), nil)
	default:
		slog.ErrorContext(c.Request.Context(), "request failed",
			"method", c.Request.Method, "path", c.FullPath(), "error", err)
		response.Error(c, http.StatusInternalServerError, "internal_error", "internal server error", nil)
	}
}

// parseID reads a positive integer path parameter.
func parseID(c *gin.Context, name string) (uint, bool) {
	id, err := strconv.ParseUint(c.Param(name), 10, 64)
	if err != nil || id == 0 {
		response.Error(c, http.StatusBadRequest, "invalid_id", name+" must be a positive integer", nil)
		return 0, false
	}
	return uint(id), true
}
