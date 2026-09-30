// Package service contains business logic. Services depend on repository
// interfaces and return the generic errors below, which handlers map to HTTP
// status codes. Wrap them with context, e.g. fmt.Errorf("%w: product 7", ErrNotFound).
package service

import (
	"context"
	"errors"
	"fmt"
	"strings"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
)

var (
	ErrNotFound = errors.New("not found")
	ErrConflict = errors.New("conflict")

	// Authentication and authorization. Each maps to its own response code,
	// because a client reacts to each differently:
	//
	//	ErrInvalidCredentials → 401 invalid_credentials (show "wrong email or password")
	//	ErrTokenExpired       → 401 token_expired       (refresh the access token, retry)
	//	ErrUnauthorized       → 401 unauthorized        (log in again)
	//	ErrForbidden          → 403 forbidden           (logged in, but not allowed)
	ErrInvalidCredentials = errors.New("invalid credentials")
	ErrTokenExpired       = errors.New("token expired")
	ErrUnauthorized       = errors.New("unauthorized")
	ErrForbidden          = errors.New("forbidden")
)

// ruleError wraps a sentinel with a translated sentence, the way every
// service error in this package is built: "%w: <message>". The handler strips
// the sentinel prefix before sending the message.
func ruleError(ctx context.Context, sentinel error, key i18n.Key, args ...any) error {
	return fmt.Errorf("%w: %s", sentinel, i18n.T(ctx, key, args...))
}

// FieldError describes one invalid input field.
type FieldError struct {
	Field   string `json:"field"`
	Message string `json:"message"`
}

// ValidationError collects every invalid field in a request.
type ValidationError struct {
	Fields []FieldError
}

func (e *ValidationError) Error() string {
	msgs := make([]string, len(e.Fields))
	for i, f := range e.Fields {
		msgs[i] = f.Field + ": " + f.Message
	}
	return "validation failed: " + strings.Join(msgs, "; ")
}

// add appends a field error, rendering its message in the language of ctx.
// Field names are never translated: clients match on them.
func (e *ValidationError) add(ctx context.Context, field string, key i18n.Key, args ...any) {
	e.Fields = append(e.Fields, FieldError{Field: field, Message: i18n.T(ctx, key, args...)})
}

// fieldError is the one-field shorthand of [ValidationError].
func fieldError(ctx context.Context, field string, key i18n.Key, args ...any) *ValidationError {
	v := &ValidationError{}
	v.add(ctx, field, key, args...)
	return v
}

// errOrNil returns e only if it has at least one field error.
func (e *ValidationError) errOrNil() error {
	if len(e.Fields) == 0 {
		return nil
	}
	return e
}
