package service

import (
	"context"
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/auth"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

const testJWTSecret = "0123456789abcdef0123456789abcdef"

type authFixture struct {
	svc      *authService
	users    *mockUserRepo
	roles    *mockRoleRepo
	perms    *mockPermissionRepo
	sessions *fakeSessions
	tokens   *auth.Tokens
	now      time.Time
}

func newAuthFixture(t *testing.T) *authFixture {
	t.Helper()
	now := time.Date(2026, 9, 26, 10, 0, 0, 0, time.UTC)
	tokens, err := auth.NewTokens(testJWTSecret, 15*time.Minute, 168*time.Hour)
	require.NoError(t, err)
	tokens = tokens.WithClock(func() time.Time { return now })

	f := &authFixture{
		users: &mockUserRepo{}, roles: &mockRoleRepo{}, perms: &mockPermissionRepo{},
		sessions: newFakeSessions(), tokens: tokens, now: now,
	}
	f.svc = NewAuthService(f.users, f.roles, f.perms, f.sessions, tokens).(*authService)
	f.svc.now = func() time.Time { return f.now }
	return f
}

// at moves both clocks (service and token issuer) to t.
func (f *authFixture) at(t time.Time) {
	f.now = t
	f.svc.tokens = f.tokens.WithClock(func() time.Time { return t })
}

// hashed is computed once: bcrypt at the default cost is slow on purpose.
var hashed = func() string {
	h, err := auth.HashPassword("rahasia123")
	if err != nil {
		panic(err)
	}
	return h
}()

func activeStaff() *model.User {
	return &model.User{
		ID: 7, Email: "staff@example.com", Name: "Staf", PasswordHash: hashed,
		RoleID: staffRole.ID, Role: staffRole, IsActive: true,
	}
}

func TestAuthService_Login(t *testing.T) {
	tests := []struct {
		name        string
		input       model.LoginInput
		setup       func(u *mockUserRepo)
		wantErr     error
		wantInvalid []string
	}{
		{
			name:  "success, email is normalized",
			input: model.LoginInput{Email: "  Staff@Example.COM ", Password: "rahasia123"},
			setup: func(u *mockUserRepo) {
				u.On("FindByEmail", mock.Anything, "staff@example.com").Return(activeStaff(), nil)
			},
		},
		{
			name:  "wrong password",
			input: model.LoginInput{Email: "staff@example.com", Password: "salah-salah"},
			setup: func(u *mockUserRepo) {
				u.On("FindByEmail", mock.Anything, "staff@example.com").Return(activeStaff(), nil)
			},
			wantErr: ErrInvalidCredentials,
		},
		{
			name:  "unknown email gets the same answer",
			input: model.LoginInput{Email: "nobody@example.com", Password: "rahasia123"},
			setup: func(u *mockUserRepo) {
				u.On("FindByEmail", mock.Anything, "nobody@example.com").Return(nil, repository.ErrNotFound)
			},
			wantErr: ErrInvalidCredentials,
		},
		{
			name:  "inactive account with the right password gets the same answer",
			input: model.LoginInput{Email: "staff@example.com", Password: "rahasia123"},
			setup: func(u *mockUserRepo) {
				inactive := activeStaff()
				inactive.IsActive = false
				u.On("FindByEmail", mock.Anything, "staff@example.com").Return(inactive, nil)
			},
			wantErr: ErrInvalidCredentials,
		},
		{
			name:        "missing fields",
			input:       model.LoginInput{Email: " "},
			wantInvalid: []string{"email", "password"},
		},
		{
			name:  "repository failure is not a credentials error",
			input: model.LoginInput{Email: "staff@example.com", Password: "rahasia123"},
			setup: func(u *mockUserRepo) {
				u.On("FindByEmail", mock.Anything, "staff@example.com").Return(nil, errors.New("db down"))
			},
			wantErr: errors.New("db down"),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			f := newAuthFixture(t)
			if tt.setup != nil {
				tt.setup(f.users)
			}

			pair, err := f.svc.Login(context.Background(), tt.input)

			switch {
			case len(tt.wantInvalid) > 0:
				assertInvalidFields(t, err, tt.wantInvalid...)
				return
			case tt.wantErr != nil:
				require.Error(t, err)
				if errors.Is(tt.wantErr, ErrInvalidCredentials) {
					assert.ErrorIs(t, err, ErrInvalidCredentials)
					assert.Contains(t, err.Error(), "email atau password salah")
				} else {
					assert.Contains(t, err.Error(), tt.wantErr.Error())
				}
				assert.Equal(t, 0, f.sessions.count(), "no session on a failed login")
				return
			}

			require.NoError(t, err)
			assert.Equal(t, "Bearer", pair.TokenType)
			assert.Equal(t, int64(900), pair.ExpiresIn)
			assert.Equal(t, &model.AuthUser{ID: 7, Email: "staff@example.com", Name: "Staf",
				Role: model.RoleRef{ID: 2, Name: "Staff"}}, pair.User)

			claims, err := f.tokens.Parse(pair.AccessToken, auth.AccessToken)
			require.NoError(t, err)
			assert.Equal(t, uint(7), claims.UserID)
			assert.Equal(t, uint(2), claims.RoleID)

			stored := f.sessions.get(pair.RefreshToken)
			require.NotNil(t, stored, "the refresh token's hash is stored")
			assert.Equal(t, f.now.Add(168*time.Hour), stored.ExpiresAt)
			assert.NotEqual(t, pair.RefreshToken, stored.TokenHash, "only the hash, never the token")
		})
	}
}

func (f *authFixture) login(t *testing.T) *model.TokenPair {
	t.Helper()
	f.users.On("FindByEmail", mock.Anything, "staff@example.com").Return(activeStaff(), nil).Maybe()
	pair, err := f.svc.Login(context.Background(), model.LoginInput{Email: "staff@example.com", Password: "rahasia123"})
	require.NoError(t, err)
	return pair
}

func TestAuthService_RefreshRotates(t *testing.T) {
	f := newAuthFixture(t)
	first := f.login(t)
	f.users.On("FindByID", mock.Anything, uint(7)).Return(activeStaff(), nil)

	f.at(f.now.Add(20 * time.Minute)) // the access token has expired by now
	second, err := f.svc.Refresh(context.Background(), model.RefreshInput{RefreshToken: first.RefreshToken})
	require.NoError(t, err)

	assert.NotEqual(t, first.RefreshToken, second.RefreshToken, "a new refresh token")
	assert.NotEqual(t, first.AccessToken, second.AccessToken, "a new access token")
	_, err = f.svc.tokens.Parse(second.AccessToken, auth.AccessToken)
	require.NoError(t, err, "the new access token is valid now")

	assert.NotNil(t, f.sessions.get(first.RefreshToken).RevokedAt, "the used token is revoked")
	assert.Nil(t, f.sessions.get(second.RefreshToken).RevokedAt, "the new token is live")

	t.Run("the chain continues: each new token works once", func(t *testing.T) {
		third, err := f.svc.Refresh(context.Background(), model.RefreshInput{RefreshToken: second.RefreshToken})
		require.NoError(t, err)
		assert.NotNil(t, f.sessions.get(second.RefreshToken).RevokedAt)
		assert.Nil(t, f.sessions.get(third.RefreshToken).RevokedAt)
		assert.Zero(t, f.sessions.revokeAllCalls, "normal use never triggers reuse detection")
	})
}

// Reuse detection: a revoked refresh token that comes back means it was
// copied, so every session of that user ends — and the caller can't tell.
func TestAuthService_RefreshReuseRevokesEverySession(t *testing.T) {
	f := newAuthFixture(t)
	f.users.On("FindByID", mock.Anything, uint(7)).Return(activeStaff(), nil)
	ctx := context.Background()

	phone := f.login(t)  // session 1
	laptop := f.login(t) // session 2, same user
	// Another user's session must survive: reuse is contained to one user.
	other := &model.RefreshToken{UserID: 99, TokenHash: "other-user", ExpiresAt: f.now.Add(time.Hour)}
	require.NoError(t, f.sessions.Create(ctx, other))

	// (a) First use: an ordinary, successful rotation.
	rotated, err := f.svc.Refresh(ctx, model.RefreshInput{RefreshToken: phone.RefreshToken})
	require.NoError(t, err, "a refresh token used once works as usual")
	assert.Zero(t, f.sessions.revokeAllCalls)

	// For comparison: what an ordinary failed refresh looks like.
	_, plainFailure := f.svc.Refresh(ctx, model.RefreshInput{RefreshToken: phone.AccessToken})
	require.Error(t, plainFailure)

	// (b) The same token again: reuse.
	_, err = f.svc.Refresh(ctx, model.RefreshInput{RefreshToken: phone.RefreshToken})

	t.Run("the reuse gets the ordinary 401, indistinguishable from any failed refresh", func(t *testing.T) {
		assert.ErrorIs(t, err, ErrUnauthorized)
		assert.Equal(t, plainFailure.Error(), err.Error(), "same sentinel, same message: nothing reveals the detection")
		var reuse *refreshReuseError
		assert.False(t, errors.As(err, &reuse), "the internal marker never leaves the service")
	})

	t.Run("every other session of that user is revoked", func(t *testing.T) {
		assert.Equal(t, 1, f.sessions.revokeAllCalls)
		assert.NotNil(t, f.sessions.get(laptop.RefreshToken).RevokedAt, "the laptop session")
		assert.NotNil(t, f.sessions.get(rotated.RefreshToken).RevokedAt, "the token the phone rotated to")

		_, err := f.svc.Refresh(ctx, model.RefreshInput{RefreshToken: laptop.RefreshToken})
		assert.ErrorIs(t, err, ErrUnauthorized, "the other session can't refresh any more")
		_, err = f.svc.Refresh(ctx, model.RefreshInput{RefreshToken: rotated.RefreshToken})
		assert.ErrorIs(t, err, ErrUnauthorized, "neither can the rotated one (the thief's, if it was the thief who refreshed)")
	})

	t.Run("other users are untouched", func(t *testing.T) {
		assert.Nil(t, f.sessions.getByHash("other-user").RevokedAt)
	})

	t.Run("the user can still log in with their password", func(t *testing.T) {
		fresh := f.login(t)
		_, err := f.svc.Refresh(ctx, model.RefreshInput{RefreshToken: fresh.RefreshToken})
		assert.NoError(t, err)
	})
}

// Only a revoked token counts as reuse. Other failed refreshes must not end
// the user's sessions, or anyone could log a user out everywhere by sending
// garbage.
func TestAuthService_RefreshFailuresThatAreNotReuse(t *testing.T) {
	tests := []struct {
		name    string
		prepare func(t *testing.T, f *authFixture) string
	}{
		{"garbage", func(*testing.T, *authFixture) string { return "not-a-token" }},
		{"an access token", func(t *testing.T, f *authFixture) string { return f.login(t).AccessToken }},
		{"signed but unknown to the database", func(t *testing.T, f *authFixture) string {
			issued, err := f.tokens.IssueRefresh(7, 2)
			require.NoError(t, err)
			return issued.Token
		}},
		{"expired", func(t *testing.T, f *authFixture) string {
			pair := f.login(t)
			f.at(f.now.Add(169 * time.Hour))
			return pair.RefreshToken
		}},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			f := newAuthFixture(t)
			live := f.login(t)
			token := tt.prepare(t, f)

			_, err := f.svc.Refresh(context.Background(), model.RefreshInput{RefreshToken: token})

			assert.ErrorIs(t, err, ErrUnauthorized)
			assert.Zero(t, f.sessions.revokeAllCalls)
			assert.Nil(t, f.sessions.get(live.RefreshToken).RevokedAt, "the user's live session survives")
		})
	}
}

func TestAuthService_RefreshRejects(t *testing.T) {
	tests := []struct {
		name    string
		prepare func(t *testing.T, f *authFixture) string // returns the token to refresh with
		wantErr error
		wantMsg string
	}{
		{
			name: "revoked by logout",
			prepare: func(t *testing.T, f *authFixture) string {
				pair := f.login(t)
				require.NoError(t, f.svc.Logout(context.Background(), model.RefreshInput{RefreshToken: pair.RefreshToken}))
				return pair.RefreshToken
			},
			wantErr: ErrUnauthorized, wantMsg: "dicabut",
		},
		{
			name: "expired JWT (7 days later)",
			prepare: func(t *testing.T, f *authFixture) string {
				pair := f.login(t)
				f.at(f.now.Add(169 * time.Hour))
				return pair.RefreshToken
			},
			wantErr: ErrUnauthorized, wantMsg: "kedaluwarsa",
		},
		{
			name: "an access token is not a refresh token",
			prepare: func(t *testing.T, f *authFixture) string {
				return f.login(t).AccessToken
			},
			wantErr: ErrUnauthorized, wantMsg: "tidak valid",
		},
		{
			name: "validly signed but unknown to the database",
			prepare: func(t *testing.T, f *authFixture) string {
				issued, err := f.tokens.IssueRefresh(7, 2)
				require.NoError(t, err)
				return issued.Token
			},
			wantErr: ErrUnauthorized, wantMsg: "tidak valid",
		},
		{
			name: "user deactivated since login",
			prepare: func(t *testing.T, f *authFixture) string {
				pair := f.login(t)
				inactive := activeStaff()
				inactive.IsActive = false
				f.users.On("FindByID", mock.Anything, uint(7)).Return(inactive, nil)
				return pair.RefreshToken
			},
			wantErr: ErrUnauthorized, wantMsg: "tidak aktif",
		},
		{
			name: "user deleted since login",
			prepare: func(t *testing.T, f *authFixture) string {
				pair := f.login(t)
				f.users.On("FindByID", mock.Anything, uint(7)).Return(nil, repository.ErrNotFound)
				return pair.RefreshToken
			},
			wantErr: ErrUnauthorized, wantMsg: "tidak aktif",
		},
		{
			name:    "garbage",
			prepare: func(*testing.T, *authFixture) string { return "not-a-token" },
			wantErr: ErrUnauthorized, wantMsg: "tidak valid",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			f := newAuthFixture(t)
			token := tt.prepare(t, f)
			before := f.sessions.count()

			pair, err := f.svc.Refresh(context.Background(), model.RefreshInput{RefreshToken: token})

			assert.Nil(t, pair)
			assert.ErrorIs(t, err, tt.wantErr)
			assert.Contains(t, err.Error(), tt.wantMsg)
			assert.Equal(t, before, f.sessions.count(), "a rejected refresh issues nothing")
		})
	}

	t.Run("missing token is a validation error", func(t *testing.T) {
		f := newAuthFixture(t)
		_, err := f.svc.Refresh(context.Background(), model.RefreshInput{})
		assertInvalidFields(t, err, "refresh_token")
	})
}

func TestAuthService_Logout(t *testing.T) {
	t.Run("revokes the refresh token, twice is fine", func(t *testing.T) {
		f := newAuthFixture(t)
		pair := f.login(t)
		require.NoError(t, f.svc.Logout(context.Background(), model.RefreshInput{RefreshToken: pair.RefreshToken}))
		assert.NotNil(t, f.sessions.get(pair.RefreshToken).RevokedAt)
		require.NoError(t, f.svc.Logout(context.Background(), model.RefreshInput{RefreshToken: pair.RefreshToken}))
	})

	t.Run("an expired refresh token logs out without error", func(t *testing.T) {
		f := newAuthFixture(t)
		pair := f.login(t)
		f.at(f.now.Add(200 * time.Hour))
		require.NoError(t, f.svc.Logout(context.Background(), model.RefreshInput{RefreshToken: pair.RefreshToken}))
	})

	t.Run("a forged token is refused", func(t *testing.T) {
		f := newAuthFixture(t)
		err := f.svc.Logout(context.Background(), model.RefreshInput{RefreshToken: "forged"})
		assert.ErrorIs(t, err, ErrUnauthorized)
	})
}

func TestAuthService_Authorize(t *testing.T) {
	tests := []struct {
		name    string
		state   model.AuthzState
		repoErr error
		wantErr error
		wantMsg string
	}{
		{name: "role grants the permission", state: model.AuthzState{Found: true, HasPermission: true}},
		{
			name:    "role lacks the permission",
			state:   model.AuthzState{Found: true},
			wantErr: ErrForbidden, wantMsg: "anda tidak punya izin products.delete",
		},
		{
			// The repository reports no link for the Super Admin role, and it
			// must not matter: the system role bypasses the check.
			name:  "super admin bypasses the check",
			state: model.AuthzState{Found: true, IsSystem: true, HasPermission: false},
		},
		{
			name:    "deactivated or deleted user",
			state:   model.AuthzState{Found: false},
			wantErr: ErrUnauthorized, wantMsg: "tidak aktif",
		},
		{
			name:    "database error is neither 401 nor 403",
			repoErr: errors.New("db down"),
			wantErr: errors.New("db down"),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			f := newAuthFixture(t)
			f.perms.On("Authorize", mock.Anything, uint(7), "products.delete").Return(tt.state, tt.repoErr).Once()

			err := f.svc.Authorize(context.Background(), 7, auth.ProductsDelete)

			f.perms.AssertExpectations(t)
			if tt.wantErr == nil {
				require.NoError(t, err)
				return
			}
			require.Error(t, err)
			if tt.repoErr != nil {
				assert.NotErrorIs(t, err, ErrForbidden)
				assert.NotErrorIs(t, err, ErrUnauthorized)
				return
			}
			assert.ErrorIs(t, err, tt.wantErr)
			assert.Contains(t, err.Error(), tt.wantMsg)
		})
	}

	t.Run("not cached: every call asks the database", func(t *testing.T) {
		f := newAuthFixture(t)
		f.perms.On("Authorize", mock.Anything, uint(7), "products.view").
			Return(model.AuthzState{Found: true, HasPermission: true}, nil).Once()
		f.perms.On("Authorize", mock.Anything, uint(7), "products.view").
			Return(model.AuthzState{Found: true, HasPermission: false}, nil).Once()

		require.NoError(t, f.svc.Authorize(context.Background(), 7, auth.ProductsView))
		// The permission was revoked in between: the very next call sees it.
		assert.ErrorIs(t, f.svc.Authorize(context.Background(), 7, auth.ProductsView), ErrForbidden)
		f.perms.AssertNumberOfCalls(t, "Authorize", 2)
	})

	t.Run("message in English", func(t *testing.T) {
		f := newAuthFixture(t)
		f.perms.On("Authorize", mock.Anything, uint(7), "users.view").Return(model.AuthzState{Found: true}, nil)
		err := f.svc.Authorize(i18n.WithLang(context.Background(), i18n.EN), 7, auth.UsersView)
		assert.Contains(t, err.Error(), "you do not have the users.view permission")
	})
}

func TestAuthService_Me(t *testing.T) {
	t.Run("staff: own permission list", func(t *testing.T) {
		f := newAuthFixture(t)
		f.users.On("FindByID", mock.Anything, uint(7)).Return(activeStaff(), nil)
		f.roles.On("FindByID", mock.Anything, uint(2)).Return(staffRole, nil)

		me, err := f.svc.Me(asUser(7))
		require.NoError(t, err)
		assert.Equal(t, "staff@example.com", me.Email)
		assert.Equal(t, model.RoleRef{ID: 2, Name: "Staff"}, me.Role)
		assert.Equal(t, []string{"products.view", "sales_orders.create"}, me.Permissions)
	})

	t.Run("super admin: every catalog permission", func(t *testing.T) {
		f := newAuthFixture(t)
		admin := &model.User{ID: 1, Email: "admin@example.com", RoleID: 1, Role: superAdminRole, IsActive: true}
		f.users.On("FindByID", mock.Anything, uint(1)).Return(admin, nil)
		f.roles.On("FindByID", mock.Anything, uint(1)).Return(superAdminRole, nil)

		me, err := f.svc.Me(asUser(1))
		require.NoError(t, err)
		assert.True(t, me.Role.IsSystem)
		assert.Equal(t, auth.AllKeys(), me.Permissions)
	})

	t.Run("no principal", func(t *testing.T) {
		f := newAuthFixture(t)
		_, err := f.svc.Me(context.Background())
		assert.ErrorIs(t, err, ErrUnauthorized)
	})

	t.Run("deactivated user", func(t *testing.T) {
		f := newAuthFixture(t)
		inactive := activeStaff()
		inactive.IsActive = false
		f.users.On("FindByID", mock.Anything, uint(7)).Return(inactive, nil)
		_, err := f.svc.Me(asUser(7))
		assert.ErrorIs(t, err, ErrUnauthorized)
	})
}

// assertInvalidFields checks err is a *ValidationError naming exactly fields.
func assertInvalidFields(t *testing.T, err error, fields ...string) {
	t.Helper()
	var verr *ValidationError
	require.ErrorAs(t, err, &verr)
	var got []string
	for _, f := range verr.Fields {
		got = append(got, f.Field)
	}
	assert.ElementsMatch(t, fields, got, "invalid fields: %s", strings.Join(got, ", "))
}
