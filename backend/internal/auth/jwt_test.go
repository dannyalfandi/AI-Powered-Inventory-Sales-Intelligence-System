package auth

import (
	"strings"
	"testing"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

const testSecret = "0123456789abcdef0123456789abcdef"

func newTestTokens(t *testing.T, now time.Time) *Tokens {
	t.Helper()
	tokens, err := NewTokens(testSecret, 15*time.Minute, 168*time.Hour)
	require.NoError(t, err)
	return tokens.WithClock(func() time.Time { return now })
}

func TestNewTokens(t *testing.T) {
	tests := []struct {
		name       string
		secret     string
		access     time.Duration
		refresh    time.Duration
		wantErrMsg string
	}{
		{"valid", testSecret, 15 * time.Minute, time.Hour, ""},
		{"secret too short", "short", 15 * time.Minute, time.Hour, "at least 32 bytes"},
		{"zero access ttl", testSecret, 0, time.Hour, "must be positive"},
		{"negative refresh ttl", testSecret, time.Minute, -time.Hour, "must be positive"},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			_, err := NewTokens(tt.secret, tt.access, tt.refresh)
			if tt.wantErrMsg == "" {
				require.NoError(t, err)
				return
			}
			require.Error(t, err)
			assert.Contains(t, err.Error(), tt.wantErrMsg)
		})
	}
}

func TestTokens_IssueAndParse(t *testing.T) {
	now := time.Date(2026, 9, 26, 10, 0, 0, 0, time.UTC)
	tokens := newTestTokens(t, now)

	t.Run("access token round trip", func(t *testing.T) {
		issued, err := tokens.IssueAccess(7, 2)
		require.NoError(t, err)
		assert.Equal(t, now.Add(15*time.Minute), issued.ExpiresAt)

		claims, err := tokens.Parse(issued.Token, AccessToken)
		require.NoError(t, err)
		assert.Equal(t, uint(7), claims.UserID)
		assert.Equal(t, uint(2), claims.RoleID)
		assert.Equal(t, AccessToken, claims.Type)
		assert.NotEmpty(t, claims.ID, "every token carries a random jti")
	})

	t.Run("refresh token round trip, 7 days", func(t *testing.T) {
		issued, err := tokens.IssueRefresh(7, 2)
		require.NoError(t, err)
		assert.Equal(t, now.Add(168*time.Hour), issued.ExpiresAt)

		claims, err := tokens.Parse(issued.Token, RefreshToken)
		require.NoError(t, err)
		assert.Equal(t, RefreshToken, claims.Type)
	})

	t.Run("two tokens issued in the same instant differ", func(t *testing.T) {
		a, err := tokens.IssueRefresh(7, 2)
		require.NoError(t, err)
		b, err := tokens.IssueRefresh(7, 2)
		require.NoError(t, err)
		assert.NotEqual(t, a.Token, b.Token)
		assert.NotEqual(t, HashToken(a.Token), HashToken(b.Token))
	})
}

func TestTokens_ParseRejects(t *testing.T) {
	now := time.Date(2026, 9, 26, 10, 0, 0, 0, time.UTC)
	tokens := newTestTokens(t, now)

	access, err := tokens.IssueAccess(7, 2)
	require.NoError(t, err)
	refresh, err := tokens.IssueRefresh(7, 2)
	require.NoError(t, err)

	otherKey, err := NewTokens(strings.Repeat("x", 32), time.Minute, time.Hour)
	require.NoError(t, err)
	foreign, err := otherKey.WithClock(func() time.Time { return now }).IssueAccess(7, 2)
	require.NoError(t, err)

	unsigned, err := jwt.NewWithClaims(jwt.SigningMethodNone, Claims{
		UserID: 7, RoleID: 1, Type: AccessToken,
		RegisteredClaims: jwt.RegisteredClaims{ExpiresAt: jwt.NewNumericDate(now.Add(time.Hour))},
	}).SignedString(jwt.UnsafeAllowNoneSignatureType)
	require.NoError(t, err)

	noExpiry, err := jwt.NewWithClaims(jwt.SigningMethodHS256, Claims{UserID: 7, Type: AccessToken}).
		SignedString([]byte(testSecret))
	require.NoError(t, err)

	noUser, err := jwt.NewWithClaims(jwt.SigningMethodHS256, Claims{
		Type:             AccessToken,
		RegisteredClaims: jwt.RegisteredClaims{ExpiresAt: jwt.NewNumericDate(now.Add(time.Hour))},
	}).SignedString([]byte(testSecret))
	require.NoError(t, err)

	// Flip one character of the payload: the signature no longer matches.
	parts := strings.Split(access.Token, ".")
	payload := []byte(parts[1])
	payload[len(payload)/2] ^= 1
	tampered := parts[0] + "." + string(payload) + "." + parts[2]

	tests := []struct {
		name    string
		tokens  *Tokens
		token   string
		want    TokenType
		wantErr error
	}{
		{"expired access token", tokens.WithClock(func() time.Time { return now.Add(16 * time.Minute) }), access.Token, AccessToken, ErrTokenExpired},
		{"expired refresh token", tokens.WithClock(func() time.Time { return now.Add(169 * time.Hour) }), refresh.Token, RefreshToken, ErrTokenExpired},
		{"refresh token used as access token", tokens, refresh.Token, AccessToken, ErrTokenInvalid},
		{"access token used as refresh token", tokens, access.Token, RefreshToken, ErrTokenInvalid},
		{"signed with another secret", tokens, foreign.Token, AccessToken, ErrTokenInvalid},
		{"alg none", tokens, unsigned, AccessToken, ErrTokenInvalid},
		{"tampered payload", tokens, tampered, AccessToken, ErrTokenInvalid},
		{"no exp claim", tokens, noExpiry, AccessToken, ErrTokenInvalid},
		{"no user id", tokens, noUser, AccessToken, ErrTokenInvalid},
		{"garbage", tokens, "not-a-jwt", AccessToken, ErrTokenInvalid},
		{"empty", tokens, "", AccessToken, ErrTokenInvalid},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			claims, err := tt.tokens.Parse(tt.token, tt.want)
			assert.Nil(t, claims)
			assert.ErrorIs(t, err, tt.wantErr)
		})
	}
}

func TestHashToken(t *testing.T) {
	h := HashToken("abc")
	assert.Len(t, h, 64, "hex SHA-256, fits the token_hash column")
	assert.Equal(t, h, HashToken("abc"), "deterministic, so the row can be looked up by it")
	assert.NotEqual(t, h, HashToken("abd"))
}
