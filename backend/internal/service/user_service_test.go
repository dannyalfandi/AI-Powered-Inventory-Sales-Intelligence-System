package service

import (
	"context"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/auth"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

// Callers used across the user tests: a Super Admin (id 1) and a
// non-system "user manager" (id 5) who holds users.* but is not a Super Admin.
var (
	userManagerRole = &model.Role{ID: 3, Name: "User Manager", Permissions: []string{"users.view", "users.create", "users.update", "users.delete"}}
	callerAdmin     = &model.User{ID: 1, Email: "admin@example.com", RoleID: 1, Role: superAdminRole, IsActive: true}
	callerManager   = &model.User{ID: 5, Email: "manager@example.com", RoleID: 3, Role: userManagerRole, IsActive: true}
	otherAdmin      = &model.User{ID: 2, Email: "admin2@example.com", RoleID: 1, Role: superAdminRole, IsActive: true}
	staffUser       = &model.User{ID: 7, Email: "staff@example.com", RoleID: 2, Role: staffRole, IsActive: true}
)

func newUserFixture() (UserService, *mockUserRepo, *mockRoleRepo) {
	users, roles := &mockUserRepo{}, &mockRoleRepo{}
	users.On("FindByID", mock.Anything, callerAdmin.ID).Return(copyUser(callerAdmin), nil).Maybe()
	users.On("FindByID", mock.Anything, callerManager.ID).Return(copyUser(callerManager), nil).Maybe()
	roles.On("FindByID", mock.Anything, superAdminRole.ID).Return(superAdminRole, nil).Maybe()
	roles.On("FindByID", mock.Anything, staffRole.ID).Return(staffRole, nil).Maybe()
	roles.On("FindByID", mock.Anything, uint(99)).Return(nil, repository.ErrNotFound).Maybe()
	return NewUserService(users, roles), users, roles
}

func TestUserService_Create(t *testing.T) {
	yes, no := true, false
	tests := []struct {
		name        string
		caller      uint
		input       model.CreateUserInput
		setup       func(u *mockUserRepo)
		wantActive  bool
		wantErr     error
		wantInvalid []string
	}{
		{
			name:   "success: email lowercased, password hashed, active by default",
			caller: callerAdmin.ID,
			input:  model.CreateUserInput{Email: " Budi@Example.COM ", Password: "rahasia123", Name: " Budi ", RoleID: 2},
			setup: func(u *mockUserRepo) {
				u.On("Create", mock.Anything, mock.MatchedBy(func(x *model.User) bool {
					return x.Email == "budi@example.com" && x.Name == "Budi" && x.RoleID == 2 && x.IsActive &&
						auth.CheckPassword(x.PasswordHash, "rahasia123")
				})).Return(nil)
			},
			wantActive: true,
		},
		{
			name:   "created inactive when asked",
			caller: callerAdmin.ID,
			input:  model.CreateUserInput{Email: "budi@example.com", Password: "rahasia123", Name: "Budi", RoleID: 2, IsActive: &no},
			setup: func(u *mockUserRepo) {
				u.On("Create", mock.Anything, mock.MatchedBy(func(x *model.User) bool { return !x.IsActive })).Return(nil)
			},
		},
		{
			name:   "explicitly active",
			caller: callerAdmin.ID,
			input:  model.CreateUserInput{Email: "budi@example.com", Password: "rahasia123", Name: "Budi", RoleID: 2, IsActive: &yes},
			setup: func(u *mockUserRepo) {
				u.On("Create", mock.Anything, mock.Anything).Return(nil)
			},
			wantActive: true,
		},
		{
			name:        "every field invalid at once",
			caller:      callerAdmin.ID,
			input:       model.CreateUserInput{Email: "not-an-email", Password: "short", Name: " "},
			wantInvalid: []string{"email", "password", "name", "role_id"},
		},
		{
			name:        "unknown role",
			caller:      callerAdmin.ID,
			input:       model.CreateUserInput{Email: "budi@example.com", Password: "rahasia123", Name: "Budi", RoleID: 99},
			wantInvalid: []string{"role_id"},
		},
		{
			name:        "password over bcrypt's 72 bytes",
			caller:      callerAdmin.ID,
			input:       model.CreateUserInput{Email: "budi@example.com", Password: strings.Repeat("x", 73), Name: "Budi", RoleID: 2},
			wantInvalid: []string{"password"},
		},
		{
			name:   "duplicate email",
			caller: callerAdmin.ID,
			input:  model.CreateUserInput{Email: "staff@example.com", Password: "rahasia123", Name: "X", RoleID: 2},
			setup: func(u *mockUserRepo) {
				u.On("Create", mock.Anything, mock.Anything).Return(repository.ErrDuplicateKey)
			},
			wantErr: ErrConflict,
		},
		{
			name:    "a non-super-admin can't create a Super Admin",
			caller:  callerManager.ID,
			input:   model.CreateUserInput{Email: "boss@example.com", Password: "rahasia123", Name: "Boss", RoleID: 1},
			wantErr: ErrForbidden,
		},
		{
			name:   "a super admin can",
			caller: callerAdmin.ID,
			input:  model.CreateUserInput{Email: "boss@example.com", Password: "rahasia123", Name: "Boss", RoleID: 1},
			setup: func(u *mockUserRepo) {
				u.On("Create", mock.Anything, mock.Anything).Return(nil)
			},
			wantActive: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			svc, users, _ := newUserFixture()
			if tt.setup != nil {
				tt.setup(users)
			}

			got, err := svc.Create(asUser(tt.caller), tt.input)

			switch {
			case len(tt.wantInvalid) > 0:
				assertInvalidFields(t, err, tt.wantInvalid...)
				users.AssertNotCalled(t, "Create", mock.Anything, mock.Anything)
			case tt.wantErr != nil:
				assert.ErrorIs(t, err, tt.wantErr)
			default:
				require.NoError(t, err)
				assert.Equal(t, tt.wantActive, got.IsActive)
				require.NotNil(t, got.Role, "the response carries the role")
				assert.Equal(t, tt.input.RoleID, got.Role.ID)
				users.AssertExpectations(t)
			}
		})
	}

	t.Run("no principal in context", func(t *testing.T) {
		svc, _, _ := newUserFixture()
		_, err := svc.Create(context.Background(), model.CreateUserInput{})
		assert.ErrorIs(t, err, ErrUnauthorized)
	})
}

func TestUserService_Update(t *testing.T) {
	pw := "baru-rahasia"
	role := func(id uint) *uint { return &id }
	flag := func(b bool) *bool { return &b }

	tests := []struct {
		name        string
		caller      uint
		target      *model.User
		admins      int64 // active Super Admins counted under lock
		input       model.UpdateUserInput
		wantErr     error
		wantMsg     string
		wantInvalid []string
		check       func(t *testing.T, got *model.User, users *mockUserRepo)
	}{
		{
			name: "rename and change role", caller: callerAdmin.ID, target: staffUser, admins: 2,
			input: model.UpdateUserInput{Name: ptr(" Staf Gudang "), RoleID: role(1)},
			check: func(t *testing.T, got *model.User, users *mockUserRepo) {
				assert.Equal(t, "Staf Gudang", got.Name)
				assert.Equal(t, uint(1), got.RoleID)
				assert.True(t, got.Role.IsSystem)
				assert.Empty(t, users.revoked, "no session revoked for a rename")
			},
		},
		{
			name: "new password revokes every session", caller: callerAdmin.ID, target: staffUser, admins: 1,
			input: model.UpdateUserInput{Password: &pw},
			check: func(t *testing.T, got *model.User, users *mockUserRepo) {
				assert.True(t, auth.CheckPassword(got.PasswordHash, pw))
				assert.Equal(t, []uint{7}, users.revoked)
			},
		},
		{
			name: "deactivation revokes every session", caller: callerAdmin.ID, target: staffUser, admins: 1,
			input: model.UpdateUserInput{IsActive: flag(false)},
			check: func(t *testing.T, got *model.User, users *mockUserRepo) {
				assert.False(t, got.IsActive)
				assert.Equal(t, []uint{7}, users.revoked)
			},
		},
		{
			name: "can't deactivate yourself", caller: callerAdmin.ID, target: callerAdmin, admins: 2,
			input:   model.UpdateUserInput{IsActive: flag(false)},
			wantErr: ErrConflict, wantMsg: "akun sendiri",
		},
		{
			name: "can't change your own role", caller: callerAdmin.ID, target: callerAdmin, admins: 2,
			input:   model.UpdateUserInput{RoleID: role(2)},
			wantErr: ErrConflict, wantMsg: "role akun sendiri",
		},
		{
			name: "setting your own role to what it already is is fine", caller: callerAdmin.ID, target: callerAdmin, admins: 1,
			input: model.UpdateUserInput{RoleID: role(1), Name: ptr("Admin Utama")},
			check: func(t *testing.T, got *model.User, _ *mockUserRepo) {
				assert.Equal(t, "Admin Utama", got.Name)
			},
		},
		{
			name: "can't demote the last active Super Admin", caller: callerAdmin.ID, target: otherAdmin, admins: 1,
			input:   model.UpdateUserInput{RoleID: role(2)},
			wantErr: ErrConflict, wantMsg: "minimal satu Super Admin",
		},
		{
			name: "can't deactivate the last active Super Admin", caller: callerAdmin.ID, target: otherAdmin, admins: 1,
			input:   model.UpdateUserInput{IsActive: flag(false)},
			wantErr: ErrConflict, wantMsg: "minimal satu Super Admin",
		},
		{
			name: "demoting one of two Super Admins is fine", caller: callerAdmin.ID, target: otherAdmin, admins: 2,
			input: model.UpdateUserInput{RoleID: role(2)},
			check: func(t *testing.T, got *model.User, _ *mockUserRepo) {
				assert.Equal(t, uint(2), got.RoleID)
			},
		},
		{
			name: "a user manager can't promote to Super Admin", caller: callerManager.ID, target: staffUser, admins: 1,
			input:   model.UpdateUserInput{RoleID: role(1)},
			wantErr: ErrForbidden, wantMsg: "hanya Super Admin",
		},
		{
			name: "a user manager can't touch a Super Admin account", caller: callerManager.ID, target: otherAdmin, admins: 2,
			input:   model.UpdateUserInput{Password: &pw},
			wantErr: ErrForbidden, wantMsg: "hanya Super Admin",
		},
		{
			name: "a user manager can edit a staff account", caller: callerManager.ID, target: staffUser, admins: 1,
			input: model.UpdateUserInput{Name: ptr("Staf Baru")},
			check: func(t *testing.T, got *model.User, _ *mockUserRepo) {
				assert.Equal(t, "Staf Baru", got.Name)
			},
		},
		{
			name: "invalid fields are reported before any lock", caller: callerAdmin.ID, target: staffUser,
			input:       model.UpdateUserInput{Email: ptr("nope"), Password: ptr("short"), RoleID: role(99)},
			wantInvalid: []string{"email", "password", "role_id"},
		},
		{
			name: "unknown user", caller: callerAdmin.ID, target: nil,
			input:   model.UpdateUserInput{Name: ptr("X")},
			wantErr: ErrNotFound,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			svc, users, _ := newUserFixture()
			if tt.target != nil {
				users.On("Mutate", mock.Anything, tt.target.ID).Return(copyUser(tt.target), tt.admins, nil).Maybe()
			} else {
				users.On("Mutate", mock.Anything, uint(404)).Return(nil, int64(0), repository.ErrNotFound)
			}
			id := uint(404)
			if tt.target != nil {
				id = tt.target.ID
			}

			got, err := svc.Update(asUser(tt.caller), id, tt.input)

			switch {
			case len(tt.wantInvalid) > 0:
				assertInvalidFields(t, err, tt.wantInvalid...)
				users.AssertNotCalled(t, "Mutate", mock.Anything, mock.Anything)
			case tt.wantErr != nil:
				assert.ErrorIs(t, err, tt.wantErr)
				assert.Contains(t, err.Error(), tt.wantMsg)
				assert.Nil(t, users.saved, "a refused change saves nothing")
			default:
				require.NoError(t, err)
				tt.check(t, got, users)
			}
		})
	}
}

func TestUserService_Delete(t *testing.T) {
	tests := []struct {
		name    string
		caller  uint
		target  *model.User
		admins  int64
		wantErr error
	}{
		{name: "delete a staff account", caller: callerAdmin.ID, target: staffUser, admins: 1},
		{name: "can't delete yourself", caller: callerAdmin.ID, target: callerAdmin, admins: 2, wantErr: ErrConflict},
		{name: "can't delete the last active Super Admin", caller: callerAdmin.ID, target: otherAdmin, admins: 1, wantErr: ErrConflict},
		{name: "one of two Super Admins can go", caller: callerAdmin.ID, target: otherAdmin, admins: 2},
		{name: "a user manager can't delete a Super Admin", caller: callerManager.ID, target: otherAdmin, admins: 2, wantErr: ErrForbidden},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			svc, users, _ := newUserFixture()
			users.On("Delete", mock.Anything, tt.target.ID).Return(copyUser(tt.target), tt.admins, nil).Maybe()

			err := svc.Delete(asUser(tt.caller), tt.target.ID)

			if tt.wantErr != nil {
				assert.ErrorIs(t, err, tt.wantErr)
				assert.Empty(t, users.revoked)
				return
			}
			require.NoError(t, err)
			assert.Equal(t, []uint{tt.target.ID}, users.revoked, "a deleted user's sessions are revoked")
		})
	}

	t.Run("unknown user", func(t *testing.T) {
		svc, users, _ := newUserFixture()
		users.On("Delete", mock.Anything, uint(404)).Return(nil, int64(0), repository.ErrNotFound)
		assert.ErrorIs(t, svc.Delete(asUser(callerAdmin.ID), 404), ErrNotFound)
	})
}

func TestUserService_List(t *testing.T) {
	svc, users, _ := newUserFixture()
	users.On("List", mock.Anything, model.ListUsersParams{Page: 1, PageSize: DefaultPageSize, Search: "budi", RoleID: 2}).
		Return([]model.User{*staffUser}, int64(1), nil)

	got, total, used, err := svc.List(context.Background(), model.ListUsersParams{Search: "  budi ", RoleID: 2})
	require.NoError(t, err)
	assert.Len(t, got, 1)
	assert.Equal(t, int64(1), total)
	assert.Equal(t, 1, used.Page)
}
