package service

import (
	"context"
	"fmt"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

// grantScope is the one definition of "a subset of the caller's
// permissions": a Super Admin covers every permission, anyone else exactly
// the keys their own role holds right now.
//
// Without it, any permission that lets someone shape access (assigning
// permissions to a role, a role to a user, or resetting the password of a
// user) would be a way to reach permissions the caller doesn't hold. It is
// used by:
//
//   - RoleService.SetPermissions: every key given to a role;
//   - UserService.Create/Update: the role given to a user;
//   - UserService.Update/Delete: the role of the user being changed, so a
//     user manager can't reset a stronger account's password and log in as it.
type grantScope struct {
	all  bool
	held map[string]bool
}

// grantScopeOf loads what actor may hand out. actor comes from loadActor,
// whose Role has no permission keys, so a non-Super-Admin's role is read
// again with them.
func grantScopeOf(ctx context.Context, roles repository.RoleRepository, actor *model.User) (grantScope, error) {
	if isSuperAdmin(actor) {
		return grantScope{all: true}, nil
	}
	own, err := roles.FindByID(ctx, actor.RoleID)
	if err != nil {
		return grantScope{}, fmt.Errorf("load caller role %d: %w", actor.RoleID, err)
	}
	held := make(map[string]bool, len(own.Permissions))
	for _, k := range own.Permissions {
		held[k] = true
	}
	return grantScope{held: held}, nil
}

// firstMissing returns the first of keys the scope doesn't cover, or "" when
// it covers them all.
func (g grantScope) firstMissing(keys []string) string {
	if g.all {
		return ""
	}
	for _, k := range keys {
		if !g.held[k] {
			return k
		}
	}
	return ""
}

// firstMissingOf is firstMissing over a role's effective permissions: a
// system role holds every key, so only a Super Admin covers it.
func (g grantScope) firstMissingOf(role *model.Role) string {
	return g.firstMissing(effectivePermissions(role))
}
