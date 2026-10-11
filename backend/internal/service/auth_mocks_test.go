package service

import (
	"context"
	"sync"
	"time"

	"github.com/stretchr/testify/mock"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/auth"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

// --- users ---------------------------------------------------------------------

type mockUserRepo struct {
	mock.Mock
	// revoked lists the users whose sessions a Mutate/Delete revoked.
	revoked []uint
	// saved is the last user a Mutate saved.
	saved *model.User
}

func (m *mockUserRepo) Create(ctx context.Context, u *model.User) error {
	return m.Called(ctx, u).Error(0)
}

func (m *mockUserRepo) FindByID(ctx context.Context, id uint) (*model.User, error) {
	args := m.Called(ctx, id)
	u, _ := args.Get(0).(*model.User)
	return u, args.Error(1)
}

func (m *mockUserRepo) FindByEmail(ctx context.Context, email string) (*model.User, error) {
	args := m.Called(ctx, email)
	u, _ := args.Get(0).(*model.User)
	return u, args.Error(1)
}

func (m *mockUserRepo) List(ctx context.Context, params model.ListUsersParams) ([]model.User, int64, error) {
	args := m.Called(ctx, params)
	users, _ := args.Get(0).([]model.User)
	return users, args.Get(1).(int64), args.Error(2)
}

// Mutate behaves like the real repository around fn: the mock's return values
// are the locked row and the Super Admin count, fn runs on a copy, and the
// copy is "saved" only if fn succeeds.
func (m *mockUserRepo) Mutate(ctx context.Context, id uint, fn repository.UserMutation) (*model.User, error) {
	args := m.Called(ctx, id)
	if err := args.Error(2); err != nil {
		return nil, err
	}
	u := copyUser(args.Get(0).(*model.User))
	revoke, err := fn(u, args.Get(1).(int64))
	if err != nil {
		return nil, err
	}
	if revoke || !u.IsActive {
		m.revoked = append(m.revoked, id)
	}
	m.saved = u
	return u, nil
}

func (m *mockUserRepo) Delete(ctx context.Context, id uint, fn repository.UserMutation) error {
	args := m.Called(ctx, id)
	if err := args.Error(2); err != nil {
		return err
	}
	u := copyUser(args.Get(0).(*model.User))
	if _, err := fn(u, args.Get(1).(int64)); err != nil {
		return err
	}
	m.revoked = append(m.revoked, id)
	return nil
}

func copyUser(u *model.User) *model.User {
	c := *u
	if u.Role != nil {
		r := *u.Role
		c.Role = &r
	}
	return &c
}

// --- roles ---------------------------------------------------------------------

type mockRoleRepo struct {
	mock.Mock
}

func (m *mockRoleRepo) Create(ctx context.Context, r *model.Role) error {
	return m.Called(ctx, r).Error(0)
}

func (m *mockRoleRepo) FindByID(ctx context.Context, id uint) (*model.Role, error) {
	args := m.Called(ctx, id)
	r, _ := args.Get(0).(*model.Role)
	if r != nil {
		c := *r // callers mutate the role they get
		c.Permissions = append([]string(nil), r.Permissions...)
		return &c, args.Error(1)
	}
	return nil, args.Error(1)
}

func (m *mockRoleRepo) List(ctx context.Context, params model.ListRolesParams) ([]model.Role, int64, error) {
	args := m.Called(ctx, params)
	roles, _ := args.Get(0).([]model.Role)
	return roles, args.Get(1).(int64), args.Error(2)
}

func (m *mockRoleRepo) Update(ctx context.Context, r *model.Role) error {
	return m.Called(ctx, r).Error(0)
}

func (m *mockRoleRepo) Delete(ctx context.Context, id uint) error {
	return m.Called(ctx, id).Error(0)
}

func (m *mockRoleRepo) ReplacePermissions(ctx context.Context, id uint, keys []string) error {
	return m.Called(ctx, id, keys).Error(0)
}

// --- permissions -----------------------------------------------------------------

type mockPermissionRepo struct {
	mock.Mock
}

func (m *mockPermissionRepo) SyncCatalog(ctx context.Context, catalog []model.Permission) error {
	return m.Called(ctx, catalog).Error(0)
}

func (m *mockPermissionRepo) List(ctx context.Context) ([]model.Permission, error) {
	args := m.Called(ctx)
	perms, _ := args.Get(0).([]model.Permission)
	return perms, args.Error(1)
}

func (m *mockPermissionRepo) Authorize(ctx context.Context, userID uint, permission string) (model.AuthzState, error) {
	args := m.Called(ctx, userID, permission)
	return args.Get(0).(model.AuthzState), args.Error(1)
}

// --- refresh tokens (stateful fake) -----------------------------------------------

// fakeSessions is an in-memory refresh token store with the repository's
// semantics, so rotation and revocation can be tested as behaviour (the old
// token stops working, the new one works) rather than as call sequences.
type fakeSessions struct {
	mu     sync.Mutex
	byHash map[string]*model.RefreshToken
	nextID uint
	// revokeAllCalls counts RevokeAllForUser calls (reuse detection).
	revokeAllCalls int
}

func newFakeSessions() *fakeSessions {
	return &fakeSessions{byHash: map[string]*model.RefreshToken{}}
}

func (f *fakeSessions) Create(_ context.Context, t *model.RefreshToken) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.nextID++
	t.ID = f.nextID
	c := *t
	f.byHash[t.TokenHash] = &c
	return nil
}

func (f *fakeSessions) Rotate(_ context.Context, hash string, now time.Time, fn repository.RotateFunc) error {
	f.mu.Lock() // the fake's stand-in for SELECT ... FOR UPDATE
	defer f.mu.Unlock()
	old, ok := f.byHash[hash]
	if !ok {
		return repository.ErrNotFound
	}
	c := *old
	next, err := fn(&c)
	if err != nil {
		return err
	}
	old.RevokedAt = &now
	f.nextID++
	next.ID = f.nextID
	n := *next
	f.byHash[next.TokenHash] = &n
	return nil
}

func (f *fakeSessions) Revoke(_ context.Context, hash string, now time.Time) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	if t, ok := f.byHash[hash]; ok && t.RevokedAt == nil {
		t.RevokedAt = &now
	}
	return nil
}

func (f *fakeSessions) RevokeAllForUser(_ context.Context, userID uint, now time.Time) (int64, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.revokeAllCalls++
	var n int64
	for _, t := range f.byHash {
		if t.UserID == userID && t.RevokedAt == nil {
			t.RevokedAt = &now
			n++
		}
	}
	return n, nil
}

func (f *fakeSessions) get(token string) *model.RefreshToken {
	return f.getByHash(auth.HashToken(token))
}

func (f *fakeSessions) getByHash(hash string) *model.RefreshToken {
	f.mu.Lock()
	defer f.mu.Unlock()
	return f.byHash[hash]
}

func (f *fakeSessions) count() int {
	f.mu.Lock()
	defer f.mu.Unlock()
	return len(f.byHash)
}

// --- fixtures ----------------------------------------------------------------------

var (
	superAdminRole = &model.Role{ID: 1, Name: "Super Admin", IsSystem: true}
	staffRole      = &model.Role{ID: 2, Name: "Staff", Permissions: []string{"products.view", "sales_orders.create"}}
)

// asUser is a request context authenticated as userID.
func asUser(userID uint) context.Context {
	return auth.WithPrincipal(context.Background(), auth.Principal{UserID: userID})
}
