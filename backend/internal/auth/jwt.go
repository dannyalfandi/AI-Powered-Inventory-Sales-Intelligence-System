package auth

import (
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
	"errors"
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

var (
	// ErrTokenExpired means the token was valid but its exp has passed.
	ErrTokenExpired = errors.New("token expired")
	// ErrTokenInvalid covers everything else: bad signature, wrong
	// algorithm, malformed, wrong token type, missing claims.
	ErrTokenInvalid = errors.New("token invalid")
)

// MinSecretLength is the shortest JWT_SECRET accepted (bytes). HS256 is only
// as strong as its key, and 32 bytes matches the hash size.
const MinSecretLength = 32

// TokenType separates access tokens from refresh tokens. Both are signed with
// the same key, so without it a refresh token (7 days) would be accepted as
// an access token (15 minutes) and the short lifetime would mean nothing.
type TokenType string

const (
	AccessToken  TokenType = "access"
	RefreshToken TokenType = "refresh"
)

// Claims is the JWT payload. It is kept minimal on purpose — user id, role id,
// type and expiry — because anything in a token is frozen until it expires.
// Permissions are never put here: they are read from the database on every
// request, so a change to a role applies immediately.
type Claims struct {
	UserID uint      `json:"uid"`
	RoleID uint      `json:"rid"`
	Type   TokenType `json:"typ"`
	jwt.RegisteredClaims
}

// Tokens issues and parses signed tokens (HS256).
type Tokens struct {
	secret     []byte
	accessTTL  time.Duration
	refreshTTL time.Duration
	now        func() time.Time
}

// NewTokens builds a Tokens. secret must be at least [MinSecretLength] bytes
// (config.Load enforces it; this is the last line of defence).
func NewTokens(secret string, accessTTL, refreshTTL time.Duration) (*Tokens, error) {
	if len(secret) < MinSecretLength {
		return nil, fmt.Errorf("jwt secret must be at least %d bytes, got %d", MinSecretLength, len(secret))
	}
	if accessTTL <= 0 || refreshTTL <= 0 {
		return nil, fmt.Errorf("token lifetimes must be positive (access %s, refresh %s)", accessTTL, refreshTTL)
	}
	return &Tokens{secret: []byte(secret), accessTTL: accessTTL, refreshTTL: refreshTTL, now: time.Now}, nil
}

// WithClock returns a copy that reads the time from now. For tests.
func (t *Tokens) WithClock(now func() time.Time) *Tokens {
	c := *t
	c.now = now
	return &c
}

// Issued is a freshly signed token.
type Issued struct {
	Token     string
	ExpiresAt time.Time
}

// IssueAccess signs a short-lived access token.
func (t *Tokens) IssueAccess(userID, roleID uint) (Issued, error) {
	return t.issue(userID, roleID, AccessToken, t.accessTTL)
}

// IssueRefresh signs a long-lived refresh token. The caller must store its
// [HashToken] — a refresh token is only honoured while its hash is in the
// database and not revoked.
func (t *Tokens) IssueRefresh(userID, roleID uint) (Issued, error) {
	return t.issue(userID, roleID, RefreshToken, t.refreshTTL)
}

// AccessTTL is the lifetime of an access token, reported to clients as
// expires_in.
func (t *Tokens) AccessTTL() time.Duration { return t.accessTTL }

func (t *Tokens) issue(userID, roleID uint, typ TokenType, ttl time.Duration) (Issued, error) {
	// A random id makes every token unique, even two issued for the same
	// user within the same second — otherwise a rotated refresh token could
	// come out byte-identical to the one it replaces.
	jti, err := randomID()
	if err != nil {
		return Issued{}, err
	}
	now := t.now()
	exp := now.Add(ttl)
	claims := Claims{
		UserID: userID,
		RoleID: roleID,
		Type:   typ,
		RegisteredClaims: jwt.RegisteredClaims{
			ID:        jti,
			IssuedAt:  jwt.NewNumericDate(now),
			ExpiresAt: jwt.NewNumericDate(exp),
		},
	}
	signed, err := jwt.NewWithClaims(jwt.SigningMethodHS256, claims).SignedString(t.secret)
	if err != nil {
		return Issued{}, fmt.Errorf("sign %s token: %w", typ, err)
	}
	return Issued{Token: signed, ExpiresAt: exp}, nil
}

// Parse verifies the signature, the algorithm, the expiry and the token
// type. It returns [ErrTokenExpired] or [ErrTokenInvalid] (wrapped).
func (t *Tokens) Parse(token string, want TokenType) (*Claims, error) {
	claims := &Claims{}
	_, err := jwt.ParseWithClaims(token, claims,
		func(*jwt.Token) (any, error) { return t.secret, nil },
		// Pinning the method rejects "alg":"none" and key-confusion tricks.
		jwt.WithValidMethods([]string{jwt.SigningMethodHS256.Alg()}),
		jwt.WithExpirationRequired(),
		jwt.WithIssuedAt(),
		jwt.WithTimeFunc(t.now),
	)
	switch {
	case errors.Is(err, jwt.ErrTokenExpired):
		return nil, fmt.Errorf("%w: %v", ErrTokenExpired, err)
	case err != nil:
		return nil, fmt.Errorf("%w: %v", ErrTokenInvalid, err)
	case claims.Type != want:
		return nil, fmt.Errorf("%w: expected a %s token, got %q", ErrTokenInvalid, want, claims.Type)
	case claims.UserID == 0:
		return nil, fmt.Errorf("%w: missing user id", ErrTokenInvalid)
	}
	return claims, nil
}

// HashToken is what the database stores instead of a refresh token.
//
// SHA-256 rather than bcrypt: the input is a signed token with 128 random
// bits in it, so there is nothing to brute-force, and a deterministic hash is
// what lets the refresh endpoint find the row by it (bcrypt salts would force
// a scan over every token of every user).
func HashToken(token string) string {
	sum := sha256.Sum256([]byte(token))
	return hex.EncodeToString(sum[:])
}

func randomID() (string, error) {
	b := make([]byte, 16)
	if _, err := rand.Read(b); err != nil {
		return "", fmt.Errorf("generate token id: %w", err)
	}
	return base64.RawURLEncoding.EncodeToString(b), nil
}
