package service

import (
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/auth"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

// roleManagerRole may edit roles but is not a Super Admin.
var roleManagerRole = &model.Role{ID: 4, Name: "Role Manager",
	Permissions: []string{"roles.view", "roles.assign_permissions", "products.view", "products.create"}}

func newRoleFixture() (RoleService, *mockRoleRepo, *mockPermissionRepo, *mockUserRepo) {
	roles, perms, users := &mockRoleRepo{}, &mockPermissionRepo{}, &mockUserRepo{}
	users.On("FindByID", mock.Anything, callerAdmin.ID).Return(copyUser(callerAdmin), nil).Maybe()
	users.On("FindByID", mock.Anything, uint(6)).
		Return(&model.User{ID: 6, RoleID: 4, Role: roleManagerRole, IsActive: true}, nil).Maybe()
	roles.On("FindByID", mock.Anything, superAdminRole.ID).Return(superAdminRole, nil).Maybe()
	roles.On("FindByID", mock.Anything, staffRole.ID).Return(staffRole, nil).Maybe()
	roles.On("FindByID", mock.Anything, roleManagerRole.ID).Return(roleManagerRole, nil).Maybe()
	roles.On("FindByID", mock.Anything, uint(99)).Return(nil, repository.ErrNotFound).Maybe()
	return NewRoleService(roles, perms, users), roles, perms, users
}

func TestRoleService_Create(t *testing.T) {
	tests := []struct {
		name        string
		input       model.CreateRoleInput
		repoErr     error
		wantErr     error
		wantInvalid []string
	}{
		{name: "success", input: model.CreateRoleInput{Name: " Gudang ", Description: " Staf gudang "}},
		{name: "missing name", input: model.CreateRoleInput{Name: "  "}, wantInvalid: []string{"name"}},
		{name: "name too long", input: model.CreateRoleInput{Name: string(make([]byte, 101))}, wantInvalid: []string{"name"}},
		{name: "duplicate name", input: model.CreateRoleInput{Name: "Staff"}, repoErr: repository.ErrDuplicateKey, wantErr: ErrConflict},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			svc, roles, _, _ := newRoleFixture()
			roles.On("Create", mock.Anything, mock.MatchedBy(func(r *model.Role) bool {
				return !r.IsSystem // never a system role through the API
			})).Return(tt.repoErr).Maybe()

			got, err := svc.Create(context.Background(), tt.input)

			switch {
			case len(tt.wantInvalid) > 0:
				assertInvalidFields(t, err, tt.wantInvalid...)
			case tt.wantErr != nil:
				assert.ErrorIs(t, err, tt.wantErr)
			default:
				require.NoError(t, err)
				assert.Equal(t, "Gudang", got.Name)
				assert.Equal(t, "Staf gudang", got.Description)
				assert.Equal(t, []string{}, got.Permissions, "a new role starts with no permission")
			}
		})
	}
}

func TestRoleService_SystemRoleIsLocked(t *testing.T) {
	t.Run("can't be renamed", func(t *testing.T) {
		svc, _, _, _ := newRoleFixture()
		_, err := svc.Update(context.Background(), 1, model.UpdateRoleInput{Name: ptr("Boss")})
		assert.ErrorIs(t, err, ErrConflict)
		assert.Contains(t, err.Error(), `role sistem "Super Admin"`)
	})

	t.Run("its description can change", func(t *testing.T) {
		svc, roles, _, _ := newRoleFixture()
		roles.On("Update", mock.Anything, mock.Anything).Return(nil)
		got, err := svc.Update(context.Background(), 1,
			model.UpdateRoleInput{Name: ptr("Super Admin"), Description: ptr("Akses penuh")})
		require.NoError(t, err)
		assert.Equal(t, "Akses penuh", got.Description)
		assert.Equal(t, auth.AllKeys(), got.Permissions, "a system role reports every permission")
	})

	t.Run("can't be deleted", func(t *testing.T) {
		svc, roles, _, _ := newRoleFixture()
		assert.ErrorIs(t, svc.Delete(context.Background(), 1), ErrConflict)
		roles.AssertNotCalled(t, "Delete", mock.Anything, mock.Anything)
	})

	t.Run("can't be given a permission list", func(t *testing.T) {
		svc, roles, _, _ := newRoleFixture()
		_, err := svc.SetPermissions(asUser(callerAdmin.ID), 1,
			model.SetRolePermissionsInput{PermissionKeys: []string{"products.view"}})
		assert.ErrorIs(t, err, ErrConflict)
		roles.AssertNotCalled(t, "ReplacePermissions", mock.Anything, mock.Anything, mock.Anything)
	})
}

func TestRoleService_Delete(t *testing.T) {
	tests := []struct {
		name    string
		users   int64
		repoErr error
		wantErr error
		wantMsg string
	}{
		{name: "unused role"},
		{name: "role in use", users: 3, wantErr: ErrConflict, wantMsg: "masih terhubung dengan 3 pengguna"},
		{name: "a user got the role in between (FK violation)", repoErr: repository.ErrInUse, wantErr: ErrConflict},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			svc, roles, _, _ := newRoleFixture()
			roles.On("CountUsers", mock.Anything, uint(2)).Return(tt.users, nil)
			roles.On("Delete", mock.Anything, uint(2)).Return(tt.repoErr).Maybe()

			err := svc.Delete(context.Background(), 2)

			if tt.wantErr == nil {
				require.NoError(t, err)
				return
			}
			assert.ErrorIs(t, err, tt.wantErr)
			assert.Contains(t, err.Error(), tt.wantMsg)
		})
	}

	t.Run("unknown role", func(t *testing.T) {
		svc, _, _, _ := newRoleFixture()
		assert.ErrorIs(t, svc.Delete(context.Background(), 99), ErrNotFound)
	})
}

func TestRoleService_SetPermissions(t *testing.T) {
	tests := []struct {
		name        string
		caller      uint
		keys        []string
		wantKeys    []string // what reaches the repository
		wantErr     error
		wantMsg     string
		wantInvalid []string
	}{
		{
			name: "replace, de-duplicated, order kept", caller: callerAdmin.ID,
			keys:     []string{"sales_orders.view", " products.view ", "sales_orders.view"},
			wantKeys: []string{"sales_orders.view", "products.view"},
		},
		{
			name: "empty list clears every permission", caller: callerAdmin.ID,
			keys: []string{}, wantKeys: []string{},
		},
		{
			name: "null list clears too", caller: callerAdmin.ID,
			keys: nil, wantKeys: []string{},
		},
		{
			name: "unknown keys are reported by index", caller: callerAdmin.ID,
			keys:        []string{"products.view", "products.explode", "admin"},
			wantInvalid: []string{"permission_keys[1]", "permission_keys[2]"},
		},
		{
			name: "a non-super-admin can grant what they hold", caller: 6,
			keys: []string{"products.view", "products.create"}, wantKeys: []string{"products.view", "products.create"},
		},
		{
			name: "but not what they don't", caller: 6,
			keys:    []string{"products.view", "users.delete"},
			wantErr: ErrForbidden, wantMsg: `"users.delete"`,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			svc, roles, _, _ := newRoleFixture()
			if tt.wantKeys != nil {
				roles.On("ReplacePermissions", mock.Anything, uint(2), tt.wantKeys).Return(nil).Once()
			}

			got, err := svc.SetPermissions(asUser(tt.caller), 2, model.SetRolePermissionsInput{PermissionKeys: tt.keys})

			switch {
			case len(tt.wantInvalid) > 0:
				assertInvalidFields(t, err, tt.wantInvalid...)
				roles.AssertNotCalled(t, "ReplacePermissions", mock.Anything, mock.Anything, mock.Anything)
			case tt.wantErr != nil:
				assert.ErrorIs(t, err, tt.wantErr)
				assert.Contains(t, err.Error(), tt.wantMsg)
				roles.AssertNotCalled(t, "ReplacePermissions", mock.Anything, mock.Anything, mock.Anything)
			default:
				require.NoError(t, err)
				assert.Equal(t, uint(2), got.ID)
				roles.AssertExpectations(t)
			}
		})
	}

	t.Run("unknown role", func(t *testing.T) {
		svc, _, _, _ := newRoleFixture()
		_, err := svc.SetPermissions(asUser(callerAdmin.ID), 99, model.SetRolePermissionsInput{PermissionKeys: []string{"products.view"}})
		assert.ErrorIs(t, err, ErrNotFound)
	})
}

func TestRoleService_ListPermissions(t *testing.T) {
	svc, _, perms, _ := newRoleFixture()
	perms.On("List", mock.Anything).Return([]model.Permission{
		{ID: 1, Key: "products.view", ResourceGroup: "products", Description: "Melihat daftar dan detail produk"},
	}, nil)

	got, err := svc.ListPermissions(i18n.WithLang(context.Background(), i18n.EN))
	require.NoError(t, err)
	assert.Equal(t, "View the product list and details", got[0].Description, "described in the request's language")
	assert.Equal(t, "products", got[0].ResourceGroup)
}
