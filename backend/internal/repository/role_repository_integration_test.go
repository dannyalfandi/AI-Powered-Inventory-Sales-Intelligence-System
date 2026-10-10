package repository_test

// Integration tests for user_count on roles. Which users count (soft-deleted
// ones included, inactive ones included) and that the counts come from one
// aggregated query — not one per role — are properties of the SQL, so they
// run against a real Postgres.
//
// Run:
//
//	TEST_DATABASE_URL="postgres://user:pass@localhost:5435/inventory_intel?sslmode=disable" \
//	  go test ./internal/repository -run RoleRepository -v
//
// Without TEST_DATABASE_URL the tests skip. Everything is written inside one
// transaction that is always rolled back, so the database keeps its data.

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

// sqlRecorder is a GORM logger that keeps every statement GORM executes.
type sqlRecorder struct {
	mu   sync.Mutex
	stmt []string
}

func (r *sqlRecorder) LogMode(logger.LogLevel) logger.Interface { return r }
func (r *sqlRecorder) Info(context.Context, string, ...any)     {}
func (r *sqlRecorder) Warn(context.Context, string, ...any)     {}
func (r *sqlRecorder) Error(context.Context, string, ...any)    {}
func (r *sqlRecorder) Trace(_ context.Context, _ time.Time, fc func() (string, int64), _ error) {
	sql, _ := fc()
	r.mu.Lock()
	r.stmt = append(r.stmt, sql)
	r.mu.Unlock()
}

func (r *sqlRecorder) take() []string {
	r.mu.Lock()
	defer r.mu.Unlock()
	out := r.stmt
	r.stmt = nil
	return out
}

type userCountFixture struct {
	tag                   string // unique per run, in every role name
	empty, mixed, ghosted model.Role
}

// setupRoleCounts seeds, inside a rolled-back transaction:
//
//	empty   no user ever
//	mixed   one active, one inactive and one soft-deleted user → 3
//	ghosted only a soft-deleted user                          → 1
//
// and returns a repository on that transaction whose statements rec records.
func setupRoleCounts(t *testing.T) (repository.RoleRepository, *sqlRecorder, userCountFixture) {
	t.Helper()
	dsn := os.Getenv("TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("set TEST_DATABASE_URL to run role SQL tests against a real Postgres")
	}
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{Logger: logger.Default.LogMode(logger.Silent), TranslateError: true})
	require.NoError(t, err)
	sqlDB, err := db.DB()
	require.NoError(t, err)
	t.Cleanup(func() { _ = sqlDB.Close() })

	tx := db.Begin()
	require.NoError(t, tx.Error)
	t.Cleanup(func() { tx.Rollback() })

	f := userCountFixture{tag: fmt.Sprintf("ITUC%d", time.Now().UnixNano())}
	f.empty = model.Role{Name: f.tag + " Empty"}
	f.mixed = model.Role{Name: f.tag + " Mixed"}
	f.ghosted = model.Role{Name: f.tag + " Ghosted"}
	for _, r := range []*model.Role{&f.empty, &f.mixed, &f.ghosted} {
		require.NoError(t, tx.Create(r).Error)
	}

	user := func(name string, roleID uint, active, deleted bool) {
		u := model.User{Email: strings.ToLower(name+"."+f.tag) + "@example.test", Name: name, PasswordHash: "x", RoleID: roleID, IsActive: active}
		require.NoError(t, tx.Omit("Role").Create(&u).Error)
		if deleted {
			require.NoError(t, tx.Delete(&u).Error) // soft delete: role_id stays
		}
	}
	user("active", f.mixed.ID, true, false)
	user("inactive", f.mixed.ID, false, false)
	user("deleted", f.mixed.ID, false, true)
	user("ghost", f.ghosted.ID, false, true)

	rec := &sqlRecorder{}
	return repository.NewRoleRepository(tx.Session(&gorm.Session{Logger: rec})), rec, f
}

func TestRoleRepository_UserCount(t *testing.T) {
	roles, _, f := setupRoleCounts(t)
	ctx := context.Background()

	tests := []struct {
		name string
		role model.Role
		want int64
	}{
		{"role without users", f.empty, 0},
		{"active + inactive + soft-deleted all count", f.mixed, 3},
		{"only a soft-deleted user still counts", f.ghosted, 1},
	}
	listed, total, err := roles.List(ctx, model.ListRolesParams{Page: 1, PageSize: 20, Search: f.tag})
	require.NoError(t, err)
	require.Equal(t, int64(3), total)
	byID := map[uint]int64{}
	for _, r := range listed {
		require.NotNil(t, r.UserCount, r.Name)
		byID[r.ID] = *r.UserCount
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := roles.FindByID(ctx, tt.role.ID)
			require.NoError(t, err)
			require.NotNil(t, got.UserCount)
			assert.Equal(t, tt.want, *got.UserCount, "FindByID")
			assert.Equal(t, tt.want, byID[tt.role.ID], "List")
		})
	}

	// The definition is the database's: exactly the roles with a non-zero
	// count are the ones the foreign key refuses to delete.
	t.Run("user_count > 0 ⇔ the database refuses the delete", func(t *testing.T) {
		for _, r := range []model.Role{f.mixed, f.ghosted} {
			assert.ErrorIs(t, roles.Delete(ctx, r.ID), repository.ErrInUse, r.Name)
		}
		assert.NoError(t, roles.Delete(ctx, f.empty.ID))
	})
}

// One page of roles costs the same statements whether it holds one role or
// many: the count comes from a subquery inside the role SELECT.
func TestRoleRepository_UserCountIsOneAggregatedQuery(t *testing.T) {
	roles, rec, f := setupRoleCounts(t)
	ctx := context.Background()

	run := func(search string) ([]model.Role, []string) {
		rec.take()
		got, _, err := roles.List(ctx, model.ListRolesParams{Page: 1, PageSize: 20, Search: search})
		require.NoError(t, err)
		return got, rec.take()
	}

	one, oneSQL := run(f.tag + " Mixed")
	three, threeSQL := run(f.tag)
	require.Len(t, one, 1)
	require.Len(t, three, 3)

	// COUNT(*) for the total, the page with its counts, the permission keys.
	assert.Len(t, oneSQL, 3, "statements for 1 role:\n%s", strings.Join(oneSQL, "\n"))
	assert.Len(t, threeSQL, len(oneSQL), "3 roles cost the same statements as 1:\n%s", strings.Join(threeSQL, "\n"))

	usersQueries := 0
	for _, s := range threeSQL {
		if strings.Contains(s, "FROM users") {
			usersQueries++
			assert.Contains(t, s, `FROM "roles"`, "users are only read inside the role SELECT")
			assert.Contains(t, s, "AS user_count")
			assert.NotContains(t, s, "deleted_at", "soft-deleted users are counted")
		}
	}
	assert.Equal(t, 1, usersQueries, "exactly one statement reads users")
	t.Logf("list SQL: %s", threeSQL[1])

	rec.take()
	_, err := roles.FindByID(ctx, f.mixed.ID)
	require.NoError(t, err)
	got := rec.take()
	assert.Len(t, got, 2, "FindByID: the role with its count, then its permissions")
	assert.Contains(t, got[0], "AS user_count")
	t.Logf("detail SQL: %s", got[0])
}

// The user service compares the locked target's permissions with the
// caller's, so Mutate and Delete must hand over the role with its keys —
// otherwise every role would look empty and pass the check.
func TestRoleRepository_LockedUserCarriesRolePermissions(t *testing.T) {
	dsn := os.Getenv("TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("set TEST_DATABASE_URL to run role SQL tests against a real Postgres")
	}
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{Logger: logger.Default.LogMode(logger.Silent), TranslateError: true})
	require.NoError(t, err)
	sqlDB, err := db.DB()
	require.NoError(t, err)
	t.Cleanup(func() { _ = sqlDB.Close() })
	tx := db.Begin()
	require.NoError(t, tx.Error)
	t.Cleanup(func() { tx.Rollback() })
	ctx := context.Background()

	tag := fmt.Sprintf("ITLK%d", time.Now().UnixNano())
	roles := repository.NewRoleRepository(tx)
	role := model.Role{Name: tag + " Power"}
	require.NoError(t, roles.Create(ctx, &role))
	require.NoError(t, roles.ReplacePermissions(ctx, role.ID, []string{"products.view", "products.delete"}))
	u := model.User{Email: strings.ToLower(tag) + "@example.test", Name: "Target", PasswordHash: "x", RoleID: role.ID, IsActive: true}
	require.NoError(t, tx.Omit("Role").Create(&u).Error)

	users := repository.NewUserRepository(tx)
	var seen []string
	_, err = users.Mutate(ctx, u.ID, func(locked *model.User, _ int64) (bool, error) {
		seen = append([]string(nil), locked.Role.Permissions...)
		return false, nil
	})
	require.NoError(t, err)
	assert.ElementsMatch(t, []string{"products.view", "products.delete"}, seen, "Mutate")

	seen = nil
	err = users.Delete(ctx, u.ID, func(locked *model.User, _ int64) (bool, error) {
		seen = append([]string(nil), locked.Role.Permissions...)
		return false, fmt.Errorf("refuse") // keep the user; only the callback matters
	})
	require.EqualError(t, err, "refuse")
	assert.ElementsMatch(t, []string{"products.view", "products.delete"}, seen, "Delete")
}

// user_count is a role-endpoint field. The user repository hands out roles
// for embedding in users (GET /users/:id, GET /users, login, and the locked
// user of an update) and must never fill it: those queries load the role
// without the count subquery.
func TestUserRepository_EmbeddedRoleHasNoUserCount(t *testing.T) {
	dsn := os.Getenv("TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("set TEST_DATABASE_URL to run role SQL tests against a real Postgres")
	}
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{Logger: logger.Default.LogMode(logger.Silent), TranslateError: true})
	require.NoError(t, err)
	sqlDB, err := db.DB()
	require.NoError(t, err)
	t.Cleanup(func() { _ = sqlDB.Close() })
	tx := db.Begin()
	require.NoError(t, tx.Error)
	t.Cleanup(func() { tx.Rollback() })
	ctx := context.Background()

	tag := fmt.Sprintf("ITEM%d", time.Now().UnixNano())
	roles := repository.NewRoleRepository(tx)
	role := model.Role{Name: tag + " Gudang"}
	require.NoError(t, roles.Create(ctx, &role))
	require.NoError(t, roles.ReplacePermissions(ctx, role.ID, []string{"products.view"}))
	email := strings.ToLower(tag) + "@example.test"
	u := model.User{Email: email, Name: "Embedded", PasswordHash: "x", RoleID: role.ID, IsActive: true}
	require.NoError(t, tx.Omit("Role").Create(&u).Error)

	users := repository.NewUserRepository(tx)
	byID, err := users.FindByID(ctx, u.ID)
	require.NoError(t, err)
	byEmail, err := users.FindByEmail(ctx, email)
	require.NoError(t, err)
	listed, _, err := users.List(ctx, model.ListUsersParams{Page: 1, PageSize: 20, Search: email})
	require.NoError(t, err)
	require.Len(t, listed, 1)
	locked, err := users.Mutate(ctx, u.ID, func(*model.User, int64) (bool, error) { return false, nil })
	require.NoError(t, err)

	for name, got := range map[string]*model.User{
		"FindByID (GET /users/:id)": byID,
		"FindByEmail (login)":       byEmail,
		"List (GET /users)":         &listed[0],
		"Mutate (PATCH /users/:id)": locked,
	} {
		t.Run(name, func(t *testing.T) {
			require.NotNil(t, got.Role)
			assert.Equal(t, role.ID, got.Role.ID)
			assert.Nil(t, got.Role.UserCount)
			b, err := json.Marshal(got)
			require.NoError(t, err)
			assert.NotContains(t, string(b), "user_count")
		})
	}
	// Control: the role endpoints do count (1 user).
	viaRoles, err := roles.FindByID(ctx, role.ID)
	require.NoError(t, err)
	require.NotNil(t, viaRoles.UserCount)
	assert.Equal(t, int64(1), *viaRoles.UserCount)
}
