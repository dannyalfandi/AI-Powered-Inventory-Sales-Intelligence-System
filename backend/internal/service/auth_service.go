package service

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"strings"
	"time"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/auth"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

// Authorizer decides whether a user may use a permission. The
// RequirePermission middleware calls it on every protected request.
type Authorizer interface {
	// Authorize returns nil when allowed, ErrForbidden when the user's role
	// lacks the permission, and ErrUnauthorized when the user can't act at
	// all (deleted or deactivated since the token was issued).
	Authorize(ctx context.Context, userID uint, permission auth.Permission) error
}

type AuthService interface {
	Authorizer
	Login(ctx context.Context, in model.LoginInput) (*model.TokenPair, error)
	// Refresh exchanges a refresh token for a new pair and revokes the old
	// refresh token (rotation): each refresh token works exactly once.
	Refresh(ctx context.Context, in model.RefreshInput) (*model.TokenPair, error)
	// Logout revokes the refresh token. The access token stays valid until it
	// expires (at most JWT_ACCESS_TTL); the client discards it.
	Logout(ctx context.Context, in model.RefreshInput) error
	// Me describes the caller of ctx with the permissions they hold now.
	Me(ctx context.Context) (*model.Me, error)
}

type authService struct {
	users    repository.UserRepository
	roles    repository.RoleRepository
	perms    repository.PermissionRepository
	sessions repository.RefreshTokenRepository
	tokens   *auth.Tokens
	now      func() time.Time
}

func NewAuthService(
	users repository.UserRepository,
	roles repository.RoleRepository,
	perms repository.PermissionRepository,
	sessions repository.RefreshTokenRepository,
	tokens *auth.Tokens,
) AuthService {
	return &authService{users: users, roles: roles, perms: perms, sessions: sessions, tokens: tokens, now: time.Now}
}

func (s *authService) Login(ctx context.Context, in model.LoginInput) (*model.TokenPair, error) {
	email := strings.ToLower(strings.TrimSpace(in.Email))
	v := &ValidationError{}
	if email == "" {
		v.add(ctx, "email", i18n.KeyRequired)
	}
	if in.Password == "" {
		v.add(ctx, "password", i18n.KeyRequired)
	}
	if err := v.errOrNil(); err != nil {
		return nil, err
	}

	u, err := s.users.FindByEmail(ctx, email)
	switch {
	case errors.Is(err, repository.ErrNotFound):
		// Same bcrypt cost as a real check, so timing doesn't reveal
		// whether the email has an account.
		auth.SpendPasswordCheck(in.Password)
		return nil, ruleError(ctx, ErrInvalidCredentials, i18n.KeyAuthInvalidCredentials)
	case err != nil:
		return nil, fmt.Errorf("login: %w", err)
	}
	// An inactive account gets the same answer as a wrong password: the
	// login endpoint must not tell a stranger which accounts exist.
	if !auth.CheckPassword(u.PasswordHash, in.Password) || !u.IsActive {
		return nil, ruleError(ctx, ErrInvalidCredentials, i18n.KeyAuthInvalidCredentials)
	}

	pair, record, err := s.newPair(u)
	if err != nil {
		return nil, err
	}
	if err := s.sessions.Create(ctx, record); err != nil {
		return nil, fmt.Errorf("login: store refresh token: %w", err)
	}
	pair.User = authUser(u)
	return pair, nil
}

func (s *authService) Refresh(ctx context.Context, in model.RefreshInput) (*model.TokenPair, error) {
	token := strings.TrimSpace(in.RefreshToken)
	if token == "" {
		return nil, fieldError(ctx, "refresh_token", i18n.KeyRequired)
	}
	claims, err := s.tokens.Parse(token, auth.RefreshToken)
	switch {
	case errors.Is(err, auth.ErrTokenExpired):
		return nil, ruleError(ctx, ErrUnauthorized, i18n.KeyAuthRefreshExpired)
	case err != nil:
		return nil, ruleError(ctx, ErrUnauthorized, i18n.KeyAuthRefreshInvalid)
	}

	now := s.now()
	var pair *model.TokenPair
	err = s.sessions.Rotate(ctx, auth.HashToken(token), now, func(old *model.RefreshToken) (*model.RefreshToken, error) {
		switch {
		case old.UserID != claims.UserID:
			return nil, ruleError(ctx, ErrUnauthorized, i18n.KeyAuthRefreshInvalid)
		case old.RevokedAt != nil:
			// Validly signed, known to us, and already revoked: someone is
			// presenting a token that was rotated away or logged out. See
			// handleReuse. Returning an error also rolls this transaction
			// back, which is why the revocation happens outside it.
			return nil, &refreshReuseError{userID: old.UserID}
		case !old.ExpiresAt.After(now):
			return nil, ruleError(ctx, ErrUnauthorized, i18n.KeyAuthRefreshExpired)
		}
		u, err := s.activeUser(ctx, old.UserID)
		if err != nil {
			return nil, err
		}
		// The new pair carries the user's current role, not the old token's.
		next, record, err := s.newPair(u)
		if err != nil {
			return nil, err
		}
		next.User = authUser(u)
		pair = next
		return record, nil
	})
	var reuse *refreshReuseError
	switch {
	case errors.As(err, &reuse):
		return nil, s.handleReuse(ctx, reuse.userID, now)
	case errors.Is(err, repository.ErrNotFound):
		// Signed by us but unknown to the database: issued before a
		// cleanup, or forged with a leaked secret. Either way, no.
		return nil, ruleError(ctx, ErrUnauthorized, i18n.KeyAuthRefreshInvalid)
	case err != nil:
		return nil, err
	}
	return pair, nil
}

// refreshReuseError marks a refresh with a token that was already revoked.
// It never leaves this file: handleReuse turns it into the ordinary 401.
type refreshReuseError struct{ userID uint }

func (e *refreshReuseError) Error() string {
	return fmt.Sprintf("refresh token reuse by user %d", e.userID)
}

// handleReuse is refresh-token reuse detection. Every refresh token works
// exactly once, so a revoked one coming back means two parties hold it —
// the user and whoever copied it — and there is no telling which one is
// asking. The only safe answer is to end every session of that user: the
// thief's (whichever token it rotated to) and the user's own, who logs in
// again with their password.
//
// The response is the same 401, with the same code and message, as any other
// failed refresh, so the caller can't tell the reuse was noticed. The
// detection is only visible in the server log.
//
// Trade-off: a client that retries a refresh whose response it never got
// (network drop) also looks like reuse and logs the user out everywhere.
// Clients must send one refresh at a time and never retry one blindly.
func (s *authService) handleReuse(ctx context.Context, userID uint, now time.Time) error {
	n, err := s.sessions.RevokeAllForUser(ctx, userID, now)
	if err != nil {
		// Not the ordinary 401: a failed revocation must be visible, not
		// hidden behind "please log in again".
		return fmt.Errorf("refresh token reuse by user %d: revoke sessions: %w", userID, err)
	}
	slog.WarnContext(ctx, "refresh token reuse detected; revoked every session of the user",
		"user_id", userID, "sessions_revoked", n)
	return ruleError(ctx, ErrUnauthorized, i18n.KeyAuthRefreshInvalid)
}

func (s *authService) Logout(ctx context.Context, in model.RefreshInput) error {
	token := strings.TrimSpace(in.RefreshToken)
	if token == "" {
		return fieldError(ctx, "refresh_token", i18n.KeyRequired)
	}
	_, err := s.tokens.Parse(token, auth.RefreshToken)
	switch {
	case errors.Is(err, auth.ErrTokenExpired):
		// Already useless; logging out of an expired session succeeds.
		return nil
	case err != nil:
		return ruleError(ctx, ErrUnauthorized, i18n.KeyAuthRefreshInvalid)
	}
	if err := s.sessions.Revoke(ctx, auth.HashToken(token), s.now()); err != nil {
		return fmt.Errorf("logout: %w", err)
	}
	return nil
}

func (s *authService) Me(ctx context.Context) (*model.Me, error) {
	p, ok := auth.PrincipalFrom(ctx)
	if !ok {
		return nil, ruleError(ctx, ErrUnauthorized, i18n.KeyAuthMissingToken)
	}
	u, err := s.activeUser(ctx, p.UserID)
	if err != nil {
		return nil, err
	}
	role, err := s.roles.FindByID(ctx, u.RoleID)
	if err != nil {
		return nil, fmt.Errorf("me: load role %d: %w", u.RoleID, err)
	}
	return &model.Me{
		ID: u.ID, Email: u.Email, Name: u.Name, IsActive: u.IsActive,
		Role:        model.RoleRef{ID: role.ID, Name: role.Name, IsSystem: role.IsSystem},
		Permissions: effectivePermissions(role),
	}, nil
}

// Authorize is deliberately not cached. A cache would make "revoke this
// permission" or "deactivate this user" take effect only when the entry
// expires; for an access-control decision, being right on the next request is
// worth one indexed query per request. See permissionRepository.Authorize.
func (s *authService) Authorize(ctx context.Context, userID uint, permission auth.Permission) error {
	state, err := s.perms.Authorize(ctx, userID, string(permission))
	switch {
	case err != nil:
		return fmt.Errorf("authorize: %w", err)
	case !state.Found:
		return ruleError(ctx, ErrUnauthorized, i18n.KeyAuthAccountDisabled)
	case state.IsSystem:
		return nil // Super Admin: every permission, no lookup needed
	case !state.HasPermission:
		return ruleError(ctx, ErrForbidden, i18n.KeyAuthForbidden, permission)
	}
	return nil
}

// activeUser loads a user that may still act: not deleted, not deactivated.
func (s *authService) activeUser(ctx context.Context, id uint) (*model.User, error) {
	u, err := s.users.FindByID(ctx, id)
	switch {
	case errors.Is(err, repository.ErrNotFound):
		return nil, ruleError(ctx, ErrUnauthorized, i18n.KeyAuthAccountDisabled)
	case err != nil:
		return nil, fmt.Errorf("load user %d: %w", id, err)
	case !u.IsActive:
		return nil, ruleError(ctx, ErrUnauthorized, i18n.KeyAuthAccountDisabled)
	}
	return u, nil
}

// newPair signs an access and a refresh token for u and returns the refresh
// token's database record (hash only) for the caller to store.
func (s *authService) newPair(u *model.User) (*model.TokenPair, *model.RefreshToken, error) {
	access, err := s.tokens.IssueAccess(u.ID, u.RoleID)
	if err != nil {
		return nil, nil, err
	}
	refresh, err := s.tokens.IssueRefresh(u.ID, u.RoleID)
	if err != nil {
		return nil, nil, err
	}
	pair := &model.TokenPair{
		AccessToken:  access.Token,
		RefreshToken: refresh.Token,
		TokenType:    "Bearer",
		ExpiresIn:    int64(s.tokens.AccessTTL() / time.Second),
	}
	record := &model.RefreshToken{UserID: u.ID, TokenHash: auth.HashToken(refresh.Token), ExpiresAt: refresh.ExpiresAt}
	return pair, record, nil
}

func authUser(u *model.User) *model.AuthUser {
	out := &model.AuthUser{ID: u.ID, Email: u.Email, Name: u.Name}
	if u.Role != nil {
		out.Role = model.RoleRef{ID: u.Role.ID, Name: u.Role.Name, IsSystem: u.Role.IsSystem}
	}
	return out
}

// effectivePermissions is what a role can actually do: every catalog key for
// a system role (it bypasses the check), its own list otherwise.
func effectivePermissions(role *model.Role) []string {
	if role.IsSystem {
		return auth.AllKeys()
	}
	if role.Permissions == nil {
		return []string{}
	}
	return role.Permissions
}
