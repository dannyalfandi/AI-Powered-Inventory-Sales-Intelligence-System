package auth

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"golang.org/x/crypto/bcrypt"
)

func TestMain(m *testing.M) {
	// Hashing at the production cost would make these tests slow for no
	// extra coverage.
	bcryptCost = bcrypt.MinCost
	m.Run()
}

func TestHashPassword(t *testing.T) {
	hash, err := HashPassword("rahasia123")
	require.NoError(t, err)

	assert.NotEqual(t, "rahasia123", hash, "the password itself is never stored")
	assert.True(t, strings.HasPrefix(hash, "$2"), "bcrypt hash")

	other, err := HashPassword("rahasia123")
	require.NoError(t, err)
	assert.NotEqual(t, hash, other, "salted: the same password hashes differently")
}

func TestHashPassword_TooLong(t *testing.T) {
	_, err := HashPassword(strings.Repeat("a", MaxPasswordBytes+1))
	require.Error(t, err, "bcrypt would silently ignore everything after byte 72")

	_, err = HashPassword(strings.Repeat("a", MaxPasswordBytes))
	require.NoError(t, err)
}

func TestCheckPassword(t *testing.T) {
	hash, err := HashPassword("rahasia123")
	require.NoError(t, err)

	tests := []struct {
		name     string
		hash     string
		password string
		want     bool
	}{
		{"correct password", hash, "rahasia123", true},
		{"wrong password", hash, "rahasia124", false},
		{"case matters", hash, "RAHASIA123", false},
		{"empty password", hash, "", false},
		{"malformed hash is a mismatch, not a panic", "not-a-hash", "rahasia123", false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			assert.Equal(t, tt.want, CheckPassword(tt.hash, tt.password))
		})
	}
}

func TestSpendPasswordCheck(t *testing.T) {
	// Only has to run without panicking; its point is the time it takes.
	SpendPasswordCheck("anything")
}
