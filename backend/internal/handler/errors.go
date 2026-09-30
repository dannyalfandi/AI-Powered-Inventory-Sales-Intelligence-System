// Package handler contains Gin HTTP handlers. Handlers only parse requests,
// call a service, and map results/errors to HTTP responses.
package handler

import (
	"errors"
	"log/slog"
	"net/http"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/pkg/response"
)

// writeError maps service errors to HTTP status codes. Unknown errors are
// logged and returned as a generic 500 so internals don't leak to clients.
//
// The sentences come from the catalog in the request's language; the codes
// ("validation_failed", "not_found", …) and the field names inside `details`
// never change, so clients can keep matching on those.
func writeError(c *gin.Context, err error) {
	ctx := c.Request.Context()

	var verr *service.ValidationError
	switch {
	case errors.As(err, &verr):
		response.Error(c, http.StatusUnprocessableEntity, "validation_failed",
			i18n.T(ctx, i18n.KeyValidationFailed), verr.Fields)
	case errors.Is(err, service.ErrNotFound):
		response.Error(c, http.StatusNotFound, "not_found", messageOf(err, service.ErrNotFound), nil)
	case errors.Is(err, service.ErrConflict):
		response.Error(c, http.StatusConflict, "conflict", messageOf(err, service.ErrConflict), nil)
	case errors.Is(err, service.ErrInvalidCredentials):
		unauthorized(c, "invalid_credentials", messageOf(err, service.ErrInvalidCredentials))
	case errors.Is(err, service.ErrTokenExpired):
		unauthorized(c, "token_expired", messageOf(err, service.ErrTokenExpired))
	case errors.Is(err, service.ErrUnauthorized):
		unauthorized(c, "unauthorized", messageOf(err, service.ErrUnauthorized))
	case errors.Is(err, service.ErrForbidden):
		response.Error(c, http.StatusForbidden, "forbidden", messageOf(err, service.ErrForbidden), nil)
	default:
		slog.ErrorContext(ctx, "request failed",
			"method", c.Request.Method, "path", c.FullPath(), "error", err)
		response.Error(c, http.StatusInternalServerError, "internal_error",
			i18n.T(ctx, i18n.KeyInternalError), nil)
	}
}

// unauthorized answers 401 with the WWW-Authenticate challenge RFC 6750
// asks for, so generic HTTP clients know a bearer token is expected.
func unauthorized(c *gin.Context, code, message string) {
	c.Header("WWW-Authenticate", `Bearer realm="api"`)
	response.Error(c, http.StatusUnauthorized, code, message, nil)
}

// messageOf strips the sentinel prefix ("not found: ", "conflict: ") that the
// service wrapped the translated message with, so the client reads the
// sentence on its own instead of an English label glued to it.
func messageOf(err error, sentinel error) string {
	message := err.Error()
	if stripped, ok := strings.CutPrefix(message, sentinel.Error()+": "); ok {
		return stripped
	}
	return message
}

// parseID reads a positive integer path parameter.
func parseID(c *gin.Context, name string) (uint, bool) {
	id, err := strconv.ParseUint(c.Param(name), 10, 64)
	if err != nil || id == 0 {
		response.Error(c, http.StatusBadRequest, "invalid_id",
			i18n.T(c.Request.Context(), i18n.KeyInvalidID, name), nil)
		return 0, false
	}
	return uint(id), true
}

// writeInvalidBody answers a request whose JSON could not be parsed. The
// parser's own message is not translatable (and not useful to an end user),
// so it goes to the log and the client gets the catalog sentence.
func writeInvalidBody(c *gin.Context, err error) {
	slog.DebugContext(c.Request.Context(), "invalid request body",
		"method", c.Request.Method, "path", c.FullPath(), "error", err)
	response.Error(c, http.StatusBadRequest, "invalid_body",
		i18n.T(c.Request.Context(), i18n.KeyInvalidBody), nil)
}
