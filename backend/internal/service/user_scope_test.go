package service

import (
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

// The privilege-escalation matrix: who may do what to a user of which role.
//
// Actors: a Super Admin, a user manager whose permissions cover Guest and
// Staff ("cukup"), and one holding only users.* ("kurang", covers Guest).
// Target roles, weakest first: Guest, Staff, Power (more than any manager),
// Super Admin. Actions:
//
//	create       POST   a new user with the target role
//	assign role  PATCH  role_id of a Guest user (in everyone's scope) to it
//	password     PATCH  password of a user who has the target role
//	deactivate   PATCH  is_active=false on that user
//	delete       DELETE that user
//
// Expected outcome per (actor, target role) — the same for all five actions,
// which is the point: there is no action that gets around the scope.
type outcome int

const (
	allowed      outcome = iota
	notInScope           // 403, the role has a permission the actor lacks
	needsSuperAd         // 403, the existing "only a Super Admin" rule
)

func TestUserService_PrivilegeMatrix(t *testing.T) {
	actors := []struct {
		name   string
		caller *model.User
		want   map[uint]outcome // target role id → outcome
	}{
		{"Super Admin", callerAdmin, map[uint]outcome{
			guestRole.ID: allowed, staffRole.ID: allowed, powerRole.ID: allowed, superAdminRole.ID: allowed}},
		{"user manager (cukup)", callerManager, map[uint]outcome{
			guestRole.ID: allowed, staffRole.ID: allowed, powerRole.ID: notInScope, superAdminRole.ID: needsSuperAd}},
		{"user manager (kurang)", callerWeakManager, map[uint]outcome{
			guestRole.ID: allowed, staffRole.ID: notInScope, powerRole.ID: notInScope, superAdminRole.ID: needsSuperAd}},
	}
	targets := []struct {
		role *model.Role
		user *model.User // an existing user with that role
	}{
		{guestRole, guestUser},
		{staffRole, staffUser},
		{powerRole, powerUser},
		{superAdminRole, otherAdmin},
	}
	pw := "baru-rahasia"
	off := false

	type action struct {
		name string
		// targetSide: the refusal is about the user being changed, not the
		// role being given — it has its own message.
		targetSide bool
		run        func(svc UserService, ctx context.Context, role *model.Role, target *model.User) error
	}
	actions := []action{
		{"create", false, func(svc UserService, ctx context.Context, role *model.Role, _ *model.User) error {
			_, err := svc.Create(ctx, model.CreateUserInput{Email: "baru@example.com", Password: "rahasia123", Name: "Baru", RoleID: role.ID})
			return err
		}},
		{"assign role", false, func(svc UserService, ctx context.Context, role *model.Role, _ *model.User) error {
			id := role.ID
			_, err := svc.Update(ctx, guestUser.ID, model.UpdateUserInput{RoleID: &id})
			return err
		}},
		{"reset password", true, func(svc UserService, ctx context.Context, _ *model.Role, target *model.User) error {
			_, err := svc.Update(ctx, target.ID, model.UpdateUserInput{Password: &pw})
			return err
		}},
		{"deactivate", true, func(svc UserService, ctx context.Context, _ *model.Role, target *model.User) error {
			_, err := svc.Update(ctx, target.ID, model.UpdateUserInput{IsActive: &off})
			return err
		}},
		{"delete", true, func(svc UserService, ctx context.Context, _ *model.Role, target *model.User) error {
			return svc.Delete(ctx, target.ID)
		}},
	}

	for _, a := range actors {
		for _, tg := range targets {
			for _, act := range actions {
				want := a.want[tg.role.ID]
				t.Run(a.name+"/"+act.name+"/"+tg.role.Name, func(t *testing.T) {
					svc, users, _ := newUserFixture()
					users.On("Create", mock.Anything, mock.Anything).Return(nil).Maybe()
					// Two active Super Admins, so the last-admin rule never
					// decides here.
					for _, u := range []*model.User{guestUser, tg.user} {
						users.On("Mutate", mock.Anything, u.ID).Return(copyUser(u), int64(2), nil).Maybe()
						users.On("Delete", mock.Anything, u.ID).Return(copyUser(u), int64(2), nil).Maybe()
					}

					err := act.run(svc, asUser(a.caller.ID), tg.role, tg.user)

					switch want {
					case allowed:
						require.NoError(t, err)
						return
					case needsSuperAd:
						require.ErrorIs(t, err, ErrForbidden)
						assert.Contains(t, err.Error(), "hanya Super Admin")
					case notInScope:
						require.ErrorIs(t, err, ErrForbidden)
						if act.targetSide {
							assert.Contains(t, err.Error(), `pengguna dengan role "`+tg.role.Name+`"`)
						} else {
							assert.Contains(t, err.Error(), `memberikan role "`+tg.role.Name+`"`)
						}
					}
					// A refusal changes nothing.
					users.AssertNotCalled(t, "Create", mock.Anything, mock.Anything)
					assert.Nil(t, users.saved, "nothing saved")
					assert.Empty(t, users.revoked, "no session revoked")
				})
			}
		}
	}
}

// Editing your own account follows the existing self rules, not the scope:
// your role is your scope, so it never refuses you on its own.
func TestUserService_SelfEditIgnoresScope(t *testing.T) {
	pw := "baru-rahasia"
	power := powerRole.ID
	tests := []struct {
		name    string
		caller  *model.User
		input   model.UpdateUserInput
		wantErr error
		wantMsg string
	}{
		{name: "manager (kurang) changes own name and password", caller: callerWeakManager,
			input: model.UpdateUserInput{Name: ptr("Saya"), Password: &pw}},
		{name: "manager (cukup) changes own password", caller: callerManager,
			input: model.UpdateUserInput{Password: &pw}},
		{name: "own role change is still 409, even to a stronger role", caller: callerManager,
			input: model.UpdateUserInput{RoleID: &power}, wantErr: ErrConflict, wantMsg: "role akun sendiri"},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			svc, users, _ := newUserFixture()
			users.On("Mutate", mock.Anything, tt.caller.ID).Return(copyUser(tt.caller), int64(1), nil)
			_, err := svc.Update(asUser(tt.caller.ID), tt.caller.ID, tt.input)
			if tt.wantErr == nil {
				require.NoError(t, err)
				return
			}
			require.ErrorIs(t, err, tt.wantErr)
			assert.Contains(t, err.Error(), tt.wantMsg)
		})
	}
}

// A change that stays in scope is refused if the user it touches isn't:
// moving a Power user down to Guest is still changing a Power account.
func TestUserService_ScopeChecksTheCurrentRoleToo(t *testing.T) {
	svc, users, _ := newUserFixture()
	users.On("Mutate", mock.Anything, powerUser.ID).Return(copyUser(powerUser), int64(1), nil)
	guest := guestRole.ID
	_, err := svc.Update(asUser(callerManager.ID), powerUser.ID, model.UpdateUserInput{RoleID: &guest})
	require.ErrorIs(t, err, ErrForbidden)
	assert.Contains(t, err.Error(), `pengguna dengan role "Power" karena role itu punya izin "products.delete"`)
	assert.Nil(t, users.saved)
}

func TestUserService_ScopeMessagesInEnglish(t *testing.T) {
	ctx := i18n.WithLang(asUser(callerWeakManager.ID), i18n.EN)

	svc, users, _ := newUserFixture()
	users.On("Create", mock.Anything, mock.Anything).Return(nil).Maybe()
	_, err := svc.Create(ctx, model.CreateUserInput{Email: "x@example.com", Password: "rahasia123", Name: "X", RoleID: staffRole.ID})
	assert.EqualError(t, err, `forbidden: you can't assign the "Staff" role because it has the "products.view" permission, which you don't hold yourself`)

	svc, users, _ = newUserFixture()
	users.On("Delete", mock.Anything, staffUser.ID).Return(copyUser(staffUser), int64(1), nil)
	err = svc.Delete(ctx, staffUser.ID)
	assert.EqualError(t, err, `forbidden: you can't change or delete a user with the "Staff" role because it has the "products.view" permission, which you don't hold yourself`)
}
