package auth

import (
	"errors"
	"fmt"
	"sync"

	"golang.org/x/crypto/bcrypt"
)

const (
	// MinPasswordLength is checked by the user service (in characters).
	MinPasswordLength = 8
	// MaxPasswordBytes is bcrypt's input limit. Longer input is rejected
	// rather than silently truncated, which would make everything after
	// byte 72 irrelevant to the password.
	MaxPasswordBytes = 72
)

// bcryptCost is a variable so tests can lower it; production uses the
// library default (10), roughly 50–100 ms per hash.
var bcryptCost = bcrypt.DefaultCost

// HashPassword returns the bcrypt hash of password.
func HashPassword(password string) (string, error) {
	if len(password) > MaxPasswordBytes {
		return "", fmt.Errorf("hash password: longer than %d bytes", MaxPasswordBytes)
	}
	hash, err := bcrypt.GenerateFromPassword([]byte(password), bcryptCost)
	if err != nil {
		return "", fmt.Errorf("hash password: %w", err)
	}
	return string(hash), nil
}

// CheckPassword reports whether password matches hash. A malformed hash is
// treated as a mismatch: the caller answers "invalid credentials" either way.
func CheckPassword(hash, password string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}

// dummyHash is compared against when a login names an unknown email, so an
// unknown email costs the same bcrypt time as a wrong password and response
// timing does not reveal which emails have an account.
// It uses the same cost as real hashes, and is built on first use rather than
// at package init so importing this package costs nothing.
var dummyHash = sync.OnceValue(func() []byte {
	h, err := bcrypt.GenerateFromPassword([]byte("timing-equaliser"), bcryptCost)
	if err != nil {
		panic(errors.Join(errors.New("auth: build dummy hash"), err))
	}
	return h
})

// SpendPasswordCheck runs one bcrypt comparison that always fails. See
// dummyHash.
func SpendPasswordCheck(password string) {
	_ = bcrypt.CompareHashAndPassword(dummyHash(), []byte(password))
}
