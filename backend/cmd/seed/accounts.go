package main

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"os"
	"strings"
	"unicode/utf8"

	"gorm.io/gorm"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/auth"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

const (
	superAdminRoleName = "Super Admin"
	staffRoleName      = "Staff"

	defaultAdminEmail    = "admin@example.com"
	defaultAdminPassword = "admin12345"

	// The demo Staff account is fixed: it exists to show, in a demo, what a
	// restricted user sees. Change or delete it on anything real.
	staffEmail    = "staff@example.com"
	staffPassword = "staff12345"
)

// staffPermissions is the Staff role as first seeded: read everything, take
// and move sales orders; no deletes, no stock or catalogue edits, no user or
// role management. It is only applied when the role is created, so changes
// made through the API survive a re-seed.
var staffPermissions = []auth.Permission{
	auth.ProductsView,
	auth.CategoriesView,
	auth.InventoryView,
	auth.CustomersView,
	auth.SalesOrdersView,
	auth.SalesOrdersCreate,
	auth.SalesOrdersConfirm,
	auth.SalesOrdersShip,
	auth.SalesOrdersCancel,
	auth.AnalyticsView,
	auth.AnalyticsForecast,
	auth.AnalyticsInsights,
}

// accounts creates the access-control baseline: the permission catalog, the
// Super Admin and Staff roles, one Super Admin and one Staff user. Every step
// finds its row first, so running it again changes nothing — in particular it
// never resets a password that was changed after the first run.
func accounts(ctx context.Context, db *gorm.DB) error {
	perms := repository.NewPermissionRepository(db)
	roles := repository.NewRoleRepository(db)
	users := repository.NewUserRepository(db)

	if err := perms.SyncCatalog(ctx, repository.PermissionCatalog()); err != nil {
		return fmt.Errorf("sync permission catalog: %w", err)
	}

	admin, _, err := ensureRole(ctx, db, roles, superAdminRoleName,
		"Akses penuh ke seluruh sistem, termasuk pengguna dan role. Tidak bisa dihapus.", true, nil)
	if err != nil {
		return err
	}
	staff, created, err := ensureRole(ctx, db, roles, staffRoleName,
		"Staf operasional: melihat semua data, membuat dan memproses pesanan.", false, staffPermissions)
	if err != nil {
		return err
	}
	if !created {
		slog.Info("role exists, permissions left as they are", "role", staffRoleName)
	}

	adminEmail := strings.ToLower(strings.TrimSpace(os.Getenv("SEED_ADMIN_EMAIL")))
	adminPassword := os.Getenv("SEED_ADMIN_PASSWORD")
	usingDefaults := adminEmail == "" || adminPassword == ""
	if adminEmail == "" {
		adminEmail = defaultAdminEmail
	}
	if adminPassword == "" {
		adminPassword = defaultAdminPassword
	}
	if n := utf8.RuneCountInString(adminPassword); n < auth.MinPasswordLength || len(adminPassword) > auth.MaxPasswordBytes {
		return fmt.Errorf("SEED_ADMIN_PASSWORD must be %d–%d characters", auth.MinPasswordLength, auth.MaxPasswordBytes)
	}

	adminCreated, err := ensureUser(ctx, users, adminEmail, "Super Admin", adminPassword, admin.ID)
	if err != nil {
		return err
	}
	if adminCreated && usingDefaults {
		slog.Warn("created the Super Admin with a DEFAULT credential — change its password before anyone else can reach this API",
			"email", adminEmail, "password", adminPassword,
			"hint", "set SEED_ADMIN_EMAIL / SEED_ADMIN_PASSWORD, or PATCH /api/v1/users/:id with a new password")
	}

	if _, err := ensureUser(ctx, users, staffEmail, "Staf Demo", staffPassword, staff.ID); err != nil {
		return err
	}
	slog.Info("accounts ready",
		"super_admin", adminEmail, "staff", staffEmail+" / "+staffPassword,
		"staff_permissions", len(staffPermissions))
	return nil
}

// ensureRole finds the role by name or creates it (with permissions, if
// given). An existing role is made to match isSystem, so a database seeded
// before is_system existed still ends up with a real Super Admin role.
func ensureRole(ctx context.Context, db *gorm.DB, roles repository.RoleRepository,
	name, description string, isSystem bool, permissions []auth.Permission,
) (*model.Role, bool, error) {
	existing, err := findOne[model.Role](ctx, db, "name = ?", name)
	if err != nil {
		return nil, false, fmt.Errorf("look up role %q: %w", name, err)
	}
	if existing != nil {
		if existing.IsSystem != isSystem {
			existing.IsSystem = isSystem
			if err := roles.Update(ctx, existing); err != nil {
				return nil, false, fmt.Errorf("update role %q: %w", name, err)
			}
		}
		return existing, false, nil
	}

	role := &model.Role{Name: name, Description: description, IsSystem: isSystem}
	if err := roles.Create(ctx, role); err != nil {
		return nil, false, fmt.Errorf("create role %q: %w", name, err)
	}
	if len(permissions) > 0 {
		keys := make([]string, len(permissions))
		for i, p := range permissions {
			keys[i] = string(p)
		}
		if err := roles.ReplacePermissions(ctx, role.ID, keys); err != nil {
			return nil, false, fmt.Errorf("set permissions of role %q: %w", name, err)
		}
	}
	slog.Info("role created", "role", name, "system", isSystem, "permissions", len(permissions))
	return role, true, nil
}

// ensureUser creates the user unless an account with that email exists.
func ensureUser(ctx context.Context, users repository.UserRepository, email, name, password string, roleID uint) (bool, error) {
	_, err := users.FindByEmail(ctx, email)
	switch {
	case err == nil:
		slog.Info("user exists, left unchanged", "email", email)
		return false, nil
	case !errors.Is(err, repository.ErrNotFound):
		return false, fmt.Errorf("look up user %q: %w", email, err)
	}

	hash, err := auth.HashPassword(password)
	if err != nil {
		return false, err
	}
	u := &model.User{Email: email, Name: name, PasswordHash: hash, RoleID: roleID, IsActive: true}
	if err := users.Create(ctx, u); err != nil {
		return false, fmt.Errorf("create user %q: %w", email, err)
	}
	slog.Info("user created", "email", email, "role_id", roleID)
	return true, nil
}
