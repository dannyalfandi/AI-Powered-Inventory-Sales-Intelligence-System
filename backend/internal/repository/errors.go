// Package repository implements data access with GORM. Repositories return
// the sentinel errors below instead of leaking gorm/driver errors upward.
package repository

import "errors"

var (
	ErrNotFound     = errors.New("record not found")
	ErrDuplicateKey = errors.New("duplicate key")
	// ErrInUse is a foreign-key violation: the row is still referenced.
	ErrInUse = errors.New("still referenced")
)
