// Package service contains business logic. Services depend on repository
// interfaces and return the generic errors below, which handlers map to HTTP
// status codes. Wrap them with context, e.g. fmt.Errorf("%w: product 7", ErrNotFound).
package service

import (
	"context"
	"errors"
	"strings"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
)

var (
	ErrNotFound = errors.New("not found")
	ErrConflict = errors.New("conflict")
)

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
