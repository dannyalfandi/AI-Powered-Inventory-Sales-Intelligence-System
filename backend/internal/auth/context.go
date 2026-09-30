package auth

import "context"

// Principal is the authenticated caller, as the access token describes it.
//
// RoleID is informational: it is what the role was when the token was
// issued. Authorization never trusts it — the permission check reads the
// user's current role from the database, so a role change or a deactivation
// applies on the very next request, not when the token expires.
type Principal struct {
	UserID uint
	RoleID uint
}

type principalKey struct{}

// WithPrincipal returns a context carrying p. The auth middleware sets it.
func WithPrincipal(ctx context.Context, p Principal) context.Context {
	return context.WithValue(ctx, principalKey{}, p)
}

// PrincipalFrom returns the caller of the current request, if authenticated.
func PrincipalFrom(ctx context.Context) (Principal, bool) {
	p, ok := ctx.Value(principalKey{}).(Principal)
	return p, ok && p.UserID != 0
}
