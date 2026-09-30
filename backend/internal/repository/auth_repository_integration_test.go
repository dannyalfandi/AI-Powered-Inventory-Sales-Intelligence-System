package repository_test

// Integration tests for the access-control guardrails that live in the
// database layer: the lock that keeps "at least one active Super Admin" true
// under concurrency, and roles staying referenced by soft-deleted users.
// A mock can't prove either — the first is about Postgres row locks, the
// second about a foreign key — so these run against a real Postgres.
//
// Run:
//
//	TEST_DATABASE_URL="postgres://user:pass@localhost:5432/inventory_intel?sslmode=disable" \
//	  go test ./internal/repository -run Guardrail -v
//
// Unlike the analytics tests, these need two connections that really commit
// (a lock only matters between transactions), so they can't live inside one
// rolled-back transaction. Instead each test creates its own throwaway schema,
// migrates it, and drops it at the end: the database's own tables are never
// touched, and the seeded Super Admin in them can't skew the count.

import (
	"context"
	"errors"
	"fmt"
	"net/url"
	"os"
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

// isolatedDB returns a connection whose search_path is a fresh, migrated
// schema, dropped when the test ends.
func isolatedDB(t *testing.T) *gorm.DB {
	t.Helper()
	dsn := os.Getenv("TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("set TEST_DATABASE_URL to run the guardrail tests against a real Postgres")
	}
	cfg := &gorm.Config{Logger: logger.Default.LogMode(logger.Silent), TranslateError: true}

	admin, err := gorm.Open(postgres.Open(dsn), cfg)
	require.NoError(t, err)
	schema := fmt.Sprintf("itest_guardrail_%d", time.Now().UnixNano())
	require.NoError(t, admin.Exec("CREATE SCHEMA "+schema).Error)

	u, err := url.Parse(dsn)
	require.NoError(t, err)
	q := u.Query()
	q.Set("search_path", schema)
	u.RawQuery = q.Encode()
	db, err := gorm.Open(postgres.Open(u.String()), cfg)
	require.NoError(t, err)

	t.Cleanup(func() {
		if sqlDB, err := db.DB(); err == nil {
			_ = sqlDB.Close()
		}
		_ = admin.Exec("DROP SCHEMA " + schema + " CASCADE").Error
		if sqlDB, err := admin.DB(); err == nil {
			_ = sqlDB.Close()
		}
	})

	require.NoError(t, db.AutoMigrate(model.All()...))
	return db
}

var errLastSuperAdmin = errors.New("last super admin")

// demote is the rule the user service applies inside Mutate: an active Super
// Admin may lose the role only if another active one remains.
func demote(staffRoleID uint, saw *int64) repository.UserMutation {
	return func(u *model.User, activeSuperAdmins int64) (bool, error) {
		*saw = activeSuperAdmins
		if u.IsActive && u.Role.IsSystem && activeSuperAdmins <= 1 {
			return false, errLastSuperAdmin
		}
		u.RoleID, u.Role = staffRoleID, nil
		return false, nil
	}
}

func TestGuardrail_TwoSuperAdminsDemotingEachOther(t *testing.T) {
	db := isolatedDB(t)
	ctx := context.Background()

	sys := model.Role{Name: "Super Admin", IsSystem: true}
	staff := model.Role{Name: "Staff"}
	require.NoError(t, db.Create(&sys).Error)
	require.NoError(t, db.Create(&staff).Error)
	a := model.User{Email: "a@example.test", Name: "A", PasswordHash: "x", RoleID: sys.ID, IsActive: true}
	b := model.User{Email: "b@example.test", Name: "B", PasswordHash: "x", RoleID: sys.ID, IsActive: true}
	require.NoError(t, db.Omit("Role").Create(&a).Error)
	require.NoError(t, db.Omit("Role").Create(&b).Error)

	repo := repository.NewUserRepository(db)

	// A demotes B and is held inside the transaction — with the Super Admin
	// rows locked — until we release it.
	inFirst, release := make(chan struct{}), make(chan struct{})
	var firstSaw, secondSaw int64 = -1, -1
	var firstErr, secondErr error
	var wg sync.WaitGroup
	wg.Add(1)
	go func() {
		defer wg.Done()
		_, firstErr = repo.Mutate(ctx, b.ID, func(u *model.User, n int64) (bool, error) {
			close(inFirst)
			<-release
			return demote(staff.ID, &firstSaw)(u, n)
		})
	}()
	<-inFirst

	// Meanwhile B demotes A. Taken alone this is legal — there are two
	// Super Admins — so only the lock can stop it.
	secondRan := make(chan struct{})
	wg.Add(1)
	go func() {
		defer wg.Done()
		_, secondErr = repo.Mutate(ctx, a.ID, func(u *model.User, n int64) (bool, error) {
			close(secondRan)
			return demote(staff.ID, &secondSaw)(u, n)
		})
	}()

	blocked := true
	select {
	case <-secondRan:
		blocked = false
	case <-time.After(500 * time.Millisecond):
		// Still waiting on SELECT ... FOR UPDATE, as it should be.
	}
	// Release before any assertion can stop the test: a transaction left
	// open would keep its locks and make the schema cleanup wait forever.
	close(release)
	wg.Wait()
	require.True(t, blocked, "the second demotion ran while the first still held the Super Admin locks")

	require.NoError(t, firstErr, "the first demotion wins")
	assert.Equal(t, int64(2), firstSaw, "the first saw both Super Admins")
	assert.ErrorIs(t, secondErr, errLastSuperAdmin, "the second is refused")
	assert.Equal(t, int64(1), secondSaw,
		"the second counted only after the first committed, so it saw one Super Admin, not two")

	var remaining int64
	require.NoError(t, db.Model(&model.User{}).
		Joins("JOIN roles ON roles.id = users.role_id").
		Where("roles.is_system AND users.is_active").Count(&remaining).Error)
	assert.Equal(t, int64(1), remaining, "exactly one active Super Admin is left")

	var aNow model.User
	require.NoError(t, db.First(&aNow, a.ID).Error)
	assert.Equal(t, sys.ID, aNow.RoleID, "A kept the role: the refused change was rolled back")
}

func TestGuardrail_SuperAdminCountIgnoresInactiveAndDeleted(t *testing.T) {
	db := isolatedDB(t)
	sys := model.Role{Name: "Super Admin", IsSystem: true}
	staff := model.Role{Name: "Staff"}
	require.NoError(t, db.Create(&sys).Error)
	require.NoError(t, db.Create(&staff).Error)

	active := model.User{Email: "active@example.test", Name: "A", PasswordHash: "x", RoleID: sys.ID, IsActive: true}
	inactive := model.User{Email: "inactive@example.test", Name: "I", PasswordHash: "x", RoleID: sys.ID, IsActive: false}
	deleted := model.User{Email: "deleted@example.test", Name: "D", PasswordHash: "x", RoleID: sys.ID, IsActive: true}
	for _, u := range []*model.User{&active, &inactive, &deleted} {
		require.NoError(t, db.Omit("Role").Create(u).Error)
	}
	require.NoError(t, db.Delete(&deleted).Error)

	// Two more Super Admin rows exist, but neither can act: demoting the
	// active one must still be refused.
	var saw int64 = -1
	_, err := repository.NewUserRepository(db).Mutate(context.Background(), active.ID, demote(staff.ID, &saw))
	assert.ErrorIs(t, err, errLastSuperAdmin)
	assert.Equal(t, int64(1), saw)
}

func TestGuardrail_RoleOfSoftDeletedUserCantBeDeleted(t *testing.T) {
	db := isolatedDB(t)
	ctx := context.Background()
	roles := repository.NewRoleRepository(db)

	role := model.Role{Name: "Gudang"}
	require.NoError(t, roles.Create(ctx, &role))
	u := model.User{Email: "gone@example.test", Name: "Gone", PasswordHash: "x", RoleID: role.ID, IsActive: true}
	require.NoError(t, db.Omit("Role").Create(&u).Error)
	require.NoError(t, repository.NewUserRepository(db).Delete(ctx, u.ID,
		func(*model.User, int64) (bool, error) { return true, nil }))

	n, err := roles.CountUsers(ctx, role.ID)
	require.NoError(t, err)
	assert.Equal(t, int64(1), n, "a soft-deleted user still counts: it keeps role_id as history")

	// Even if the service's count were skipped, the foreign key refuses.
	err = roles.Delete(ctx, role.ID)
	assert.ErrorIs(t, err, repository.ErrInUse)
	_, err = roles.FindByID(ctx, role.ID)
	assert.NoError(t, err, "the role is still there")

	// Control: a role nobody ever had is deletable.
	empty := model.Role{Name: "Kosong"}
	require.NoError(t, roles.Create(ctx, &empty))
	n, err = roles.CountUsers(ctx, empty.ID)
	require.NoError(t, err)
	assert.Zero(t, n)
	assert.NoError(t, roles.Delete(ctx, empty.ID))
}

// Reuse detection ends every session of one user, and only that user's.
func TestGuardrail_RevokeAllForUser(t *testing.T) {
	db := isolatedDB(t)
	ctx := context.Background()

	role := model.Role{Name: "Staff"}
	require.NoError(t, db.Create(&role).Error)
	victim := model.User{Email: "victim@example.test", Name: "V", PasswordHash: "x", RoleID: role.ID, IsActive: true}
	bystander := model.User{Email: "bystander@example.test", Name: "B", PasswordHash: "x", RoleID: role.ID, IsActive: true}
	require.NoError(t, db.Omit("Role").Create(&victim).Error)
	require.NoError(t, db.Omit("Role").Create(&bystander).Error)

	tokens := repository.NewRefreshTokenRepository(db)
	exp := time.Now().Add(time.Hour)
	earlier := time.Date(2026, 1, 1, 0, 0, 0, 0, time.UTC)
	rows := []*model.RefreshToken{
		{UserID: victim.ID, TokenHash: "phone", ExpiresAt: exp},
		{UserID: victim.ID, TokenHash: "laptop", ExpiresAt: exp},
		{UserID: victim.ID, TokenHash: "old", ExpiresAt: exp, RevokedAt: &earlier},
		{UserID: bystander.ID, TokenHash: "bystander", ExpiresAt: exp},
	}
	for _, r := range rows {
		require.NoError(t, tokens.Create(ctx, r))
	}

	now := time.Date(2026, 9, 27, 10, 0, 0, 0, time.UTC)
	n, err := tokens.RevokeAllForUser(ctx, victim.ID, now)
	require.NoError(t, err)
	assert.Equal(t, int64(2), n, "the two live sessions of the victim")

	revokedAt := func(hash string) *time.Time {
		var r model.RefreshToken
		require.NoError(t, db.Where("token_hash = ?", hash).First(&r).Error)
		return r.RevokedAt
	}
	for _, hash := range []string{"phone", "laptop"} {
		if at := revokedAt(hash); assert.NotNil(t, at, hash) {
			assert.True(t, at.Equal(now), "%s revoked at the detection time", hash)
		}
	}
	if at := revokedAt("old"); assert.NotNil(t, at) {
		assert.True(t, at.Equal(earlier), "an already revoked token keeps its original revoked_at")
	}
	assert.Nil(t, revokedAt("bystander"), "another user's session is untouched")

	// Revoking again finds nothing left to revoke.
	n, err = tokens.RevokeAllForUser(ctx, victim.ID, now)
	require.NoError(t, err)
	assert.Zero(t, n)
}
