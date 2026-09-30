package service

import (
	"context"
	"errors"
	"fmt"
	"strconv"
	"strings"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/auth"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

const maxRoleNameLength = 100

// RoleService manages roles and their permission lists. The permission
// catalog itself is fixed in code (internal/auth); this service only
// arranges existing keys into roles.
type RoleService interface {
	Create(ctx context.Context, in model.CreateRoleInput) (*model.Role, error)
	GetByID(ctx context.Context, id uint) (*model.Role, error)
	List(ctx context.Context, params model.ListRolesParams) ([]model.Role, int64, model.ListRolesParams, error)
	Update(ctx context.Context, id uint, in model.UpdateRoleInput) (*model.Role, error)
	Delete(ctx context.Context, id uint) error
	// SetPermissions replaces the role's permissions with exactly the given
	// keys (not an append). An empty list removes every permission.
	SetPermissions(ctx context.Context, id uint, in model.SetRolePermissionsInput) (*model.Role, error)
	// ListPermissions returns the whole catalog, descriptions in the
	// request's language.
	ListPermissions(ctx context.Context) ([]model.Permission, error)
}

type roleService struct {
	roles repository.RoleRepository
	perms repository.PermissionRepository
	users repository.UserRepository
}

func NewRoleService(roles repository.RoleRepository, perms repository.PermissionRepository, users repository.UserRepository) RoleService {
	return &roleService{roles: roles, perms: perms, users: users}
}

func (s *roleService) Create(ctx context.Context, in model.CreateRoleInput) (*model.Role, error) {
	r := &model.Role{
		Name:        strings.TrimSpace(in.Name),
		Description: strings.TrimSpace(in.Description),
		// Roles created through the API are never system roles: there is
		// exactly one Super Admin role, and the seeder makes it.
		IsSystem: false,
	}
	if err := validateRole(ctx, r); err != nil {
		return nil, err
	}
	if err := s.roles.Create(ctx, r); err != nil {
		return nil, mapRepoError(ctx, err, i18n.KeyEntityRoleName, r.Name)
	}
	r.Permissions = []string{}
	return r, nil
}

func (s *roleService) GetByID(ctx context.Context, id uint) (*model.Role, error) {
	r, err := s.roles.FindByID(ctx, id)
	if err != nil {
		return nil, mapRepoError(ctx, err, i18n.KeyEntityRole, id)
	}
	r.Permissions = effectivePermissions(r)
	return r, nil
}

func (s *roleService) List(ctx context.Context, params model.ListRolesParams) ([]model.Role, int64, model.ListRolesParams, error) {
	params.Page, params.PageSize = normalizePage(params.Page, params.PageSize)
	params.Search = strings.TrimSpace(params.Search)
	roles, total, err := s.roles.List(ctx, params)
	if err != nil {
		return nil, 0, params, fmt.Errorf("list roles: %w", err)
	}
	for i := range roles {
		roles[i].Permissions = effectivePermissions(&roles[i])
	}
	return roles, total, params, nil
}

func (s *roleService) Update(ctx context.Context, id uint, in model.UpdateRoleInput) (*model.Role, error) {
	r, err := s.roles.FindByID(ctx, id)
	if err != nil {
		return nil, mapRepoError(ctx, err, i18n.KeyEntityRole, id)
	}
	if in.Name != nil {
		name := strings.TrimSpace(*in.Name)
		// The Super Admin role keeps its name: clients and people alike
		// recognise it by that name. Its description may still change.
		if r.IsSystem && name != r.Name {
			return nil, ruleError(ctx, ErrConflict, i18n.KeySystemRoleLocked, r.Name)
		}
		r.Name = name
	}
	if in.Description != nil {
		r.Description = strings.TrimSpace(*in.Description)
	}
	if err := validateRole(ctx, r); err != nil {
		return nil, err
	}
	if err := s.roles.Update(ctx, r); err != nil {
		return nil, mapRepoError(ctx, err, i18n.KeyEntityRoleName, r.Name)
	}
	r.Permissions = effectivePermissions(r)
	return r, nil
}

// Delete removes a role. It refuses (ErrConflict) for the system role and for
// a role any user still has — users are never reassigned implicitly.
func (s *roleService) Delete(ctx context.Context, id uint) error {
	r, err := s.roles.FindByID(ctx, id)
	if err != nil {
		return mapRepoError(ctx, err, i18n.KeyEntityRole, id)
	}
	if r.IsSystem {
		return ruleError(ctx, ErrConflict, i18n.KeySystemRoleLocked, r.Name)
	}
	n, err := s.roles.CountUsers(ctx, id)
	if err != nil {
		return fmt.Errorf("role %d: %w", id, err)
	}
	if n > 0 {
		return ruleError(ctx, ErrConflict, i18n.KeyRoleInUse, id, n)
	}
	switch err := s.roles.Delete(ctx, id); {
	case errors.Is(err, repository.ErrInUse):
		// A user was given this role between the count and the delete.
		return ruleError(ctx, ErrConflict, i18n.KeyRoleInUse, id, 1)
	case err != nil:
		return mapRepoError(ctx, err, i18n.KeyEntityRole, id)
	}
	return nil
}

func (s *roleService) SetPermissions(ctx context.Context, id uint, in model.SetRolePermissionsInput) (*model.Role, error) {
	actor, err := loadActor(ctx, s.users)
	if err != nil {
		return nil, err
	}

	keys, err := validatePermissionKeys(ctx, in.PermissionKeys)
	if err != nil {
		return nil, err
	}

	r, err := s.roles.FindByID(ctx, id)
	if err != nil {
		return nil, mapRepoError(ctx, err, i18n.KeyEntityRole, id)
	}
	if r.IsSystem {
		return nil, ruleError(ctx, ErrConflict, i18n.KeySystemRoleLocked, r.Name)
	}

	// Someone who may edit roles but is not a Super Admin can only hand out
	// what they hold themselves; otherwise roles.assign_permissions would be
	// a way to grant yourself (via a role you then get) anything at all.
	if !isSuperAdmin(actor) {
		own, err := s.roles.FindByID(ctx, actor.RoleID)
		if err != nil {
			return nil, fmt.Errorf("load caller role %d: %w", actor.RoleID, err)
		}
		held := make(map[string]bool, len(own.Permissions))
		for _, k := range own.Permissions {
			held[k] = true
		}
		for _, k := range keys {
			if !held[k] {
				return nil, ruleError(ctx, ErrForbidden, i18n.KeyPermissionNotHeld, k)
			}
		}
	}

	if err := s.roles.ReplacePermissions(ctx, id, keys); err != nil {
		return nil, mapRepoError(ctx, err, i18n.KeyEntityRole, id)
	}
	return s.GetByID(ctx, id)
}

func (s *roleService) ListPermissions(ctx context.Context) ([]model.Permission, error) {
	perms, err := s.perms.List(ctx)
	if err != nil {
		return nil, err
	}
	lang := i18n.FromContext(ctx)
	for i := range perms {
		perms[i].Description = i18n.Translate(i18n.PermissionDescription(perms[i].Key), lang)
	}
	return perms, nil
}

// validatePermissionKeys checks every key against the catalog and returns
// them de-duplicated, in the order given. Unknown keys are reported per
// index, like order items: permission_keys[2].
func validatePermissionKeys(ctx context.Context, keys []string) ([]string, error) {
	v := &ValidationError{}
	out := make([]string, 0, len(keys))
	seen := make(map[string]bool, len(keys))
	for i, raw := range keys {
		k := strings.TrimSpace(raw)
		if !auth.Known(k) {
			v.add(ctx, "permission_keys["+strconv.Itoa(i)+"]", i18n.KeyPermissionUnknown, k)
			continue
		}
		if !seen[k] {
			seen[k] = true
			out = append(out, k)
		}
	}
	if err := v.errOrNil(); err != nil {
		return nil, err
	}
	return out, nil
}

func validateRole(ctx context.Context, r *model.Role) error {
	v := &ValidationError{}
	switch {
	case r.Name == "":
		v.add(ctx, "name", i18n.KeyRequired)
	case len(r.Name) > maxRoleNameLength:
		v.add(ctx, "name", i18n.KeyMaxChars, maxRoleNameLength)
	}
	return v.errOrNil()
}
