package service

import (
	"context"
	"errors"
	"fmt"
	"net/mail"
	"strings"
	"unicode/utf8"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/auth"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

const maxUserNameLength = 255

// UserService manages accounts. Every method acts on behalf of the caller in
// ctx (auth.PrincipalFrom), because some rules depend on who is asking:
//
//   - nobody can deactivate, delete or change the role of their own account
//     (the one way to lock yourself out, or to promote yourself);
//   - only a Super Admin can grant the Super Admin role or change a Super
//     Admin's account, so a custom "user manager" role can't take over;
//   - at least one active Super Admin always remains.
type UserService interface {
	Create(ctx context.Context, in model.CreateUserInput) (*model.User, error)
	GetByID(ctx context.Context, id uint) (*model.User, error)
	List(ctx context.Context, params model.ListUsersParams) ([]model.User, int64, model.ListUsersParams, error)
	Update(ctx context.Context, id uint, in model.UpdateUserInput) (*model.User, error)
	// Delete soft-deletes and deactivates the user and revokes its sessions.
	Delete(ctx context.Context, id uint) error
}

type userService struct {
	users repository.UserRepository
	roles repository.RoleRepository
}

func NewUserService(users repository.UserRepository, roles repository.RoleRepository) UserService {
	return &userService{users: users, roles: roles}
}

func (s *userService) Create(ctx context.Context, in model.CreateUserInput) (*model.User, error) {
	actor, err := loadActor(ctx, s.users)
	if err != nil {
		return nil, err
	}

	u := &model.User{
		Email:    normalizeUserEmail(in.Email),
		Name:     strings.TrimSpace(in.Name),
		RoleID:   in.RoleID,
		IsActive: in.IsActive == nil || *in.IsActive,
	}
	v := &ValidationError{}
	validateUserEmail(ctx, v, u.Email)
	validateUserName(ctx, v, u.Name)
	validatePassword(ctx, v, in.Password)
	role := s.resolveRole(ctx, v, in.RoleID)
	if err := v.errOrNil(); err != nil {
		return nil, err
	}
	if role.IsSystem && !isSuperAdmin(actor) {
		return nil, ruleError(ctx, ErrForbidden, i18n.KeySystemRoleRequiresSuperAdmin)
	}

	if u.PasswordHash, err = auth.HashPassword(in.Password); err != nil {
		return nil, err
	}
	if err := s.users.Create(ctx, u); err != nil {
		return nil, mapUserRepoError(ctx, err, 0)
	}
	u.Role = role
	return u, nil
}

func (s *userService) GetByID(ctx context.Context, id uint) (*model.User, error) {
	u, err := s.users.FindByID(ctx, id)
	if err != nil {
		return nil, mapUserRepoError(ctx, err, id)
	}
	return u, nil
}

func (s *userService) List(ctx context.Context, params model.ListUsersParams) ([]model.User, int64, model.ListUsersParams, error) {
	params.Page, params.PageSize = normalizePage(params.Page, params.PageSize)
	params.Search = strings.TrimSpace(params.Search)
	users, total, err := s.users.List(ctx, params)
	if err != nil {
		return nil, 0, params, fmt.Errorf("list users: %w", err)
	}
	return users, total, params, nil
}

func (s *userService) Update(ctx context.Context, id uint, in model.UpdateUserInput) (*model.User, error) {
	actor, err := loadActor(ctx, s.users)
	if err != nil {
		return nil, err
	}

	// Validate the request on its own before taking any lock.
	v := &ValidationError{}
	var email, name string
	if in.Email != nil {
		email = normalizeUserEmail(*in.Email)
		validateUserEmail(ctx, v, email)
	}
	if in.Name != nil {
		name = strings.TrimSpace(*in.Name)
		validateUserName(ctx, v, name)
	}
	if in.Password != nil {
		validatePassword(ctx, v, *in.Password)
	}
	var newRole *model.Role
	if in.RoleID != nil {
		newRole = s.resolveRole(ctx, v, *in.RoleID)
	}
	if err := v.errOrNil(); err != nil {
		return nil, err
	}
	var hash string
	if in.Password != nil {
		if hash, err = auth.HashPassword(*in.Password); err != nil {
			return nil, err
		}
	}

	self := actor.ID == id
	u, err := s.users.Mutate(ctx, id, func(u *model.User, activeSuperAdmins int64) (bool, error) {
		wasSuperAdmin := u.IsActive && u.Role.IsSystem
		if u.Role.IsSystem && !isSuperAdmin(actor) {
			return false, ruleError(ctx, ErrForbidden, i18n.KeySystemRoleRequiresSuperAdmin)
		}

		if newRole != nil && newRole.ID != u.RoleID {
			if self {
				return false, ruleError(ctx, ErrConflict, i18n.KeyCannotChangeOwnRole)
			}
			if newRole.IsSystem && !isSuperAdmin(actor) {
				return false, ruleError(ctx, ErrForbidden, i18n.KeySystemRoleRequiresSuperAdmin)
			}
			u.RoleID, u.Role = newRole.ID, newRole
		}
		if in.IsActive != nil && !*in.IsActive && self {
			return false, ruleError(ctx, ErrConflict, i18n.KeyCannotDeactivateSelf)
		}
		if in.IsActive != nil {
			u.IsActive = *in.IsActive
		}
		if in.Email != nil {
			u.Email = email
		}
		if in.Name != nil {
			u.Name = name
		}
		if in.Password != nil {
			u.PasswordHash = hash
		}

		stillSuperAdmin := u.IsActive && u.Role.IsSystem
		if wasSuperAdmin && !stillSuperAdmin && activeSuperAdmins <= 1 {
			return false, ruleError(ctx, ErrConflict, i18n.KeyLastSuperAdmin)
		}
		// A new password ends every existing session, like a deactivation.
		return in.Password != nil, nil
	})
	if err != nil {
		return nil, mapUserRepoError(ctx, err, id)
	}
	return u, nil
}

func (s *userService) Delete(ctx context.Context, id uint) error {
	actor, err := loadActor(ctx, s.users)
	if err != nil {
		return err
	}
	if actor.ID == id {
		return ruleError(ctx, ErrConflict, i18n.KeyCannotDeactivateSelf)
	}
	err = s.users.Delete(ctx, id, func(u *model.User, activeSuperAdmins int64) (bool, error) {
		if u.Role.IsSystem && !isSuperAdmin(actor) {
			return false, ruleError(ctx, ErrForbidden, i18n.KeySystemRoleRequiresSuperAdmin)
		}
		if u.IsActive && u.Role.IsSystem && activeSuperAdmins <= 1 {
			return false, ruleError(ctx, ErrConflict, i18n.KeyLastSuperAdmin)
		}
		return true, nil
	})
	if err != nil {
		return mapUserRepoError(ctx, err, id)
	}
	return nil
}

// resolveRole loads the role a request names, recording a field error on
// role_id if it is missing or unknown. It returns an empty role in that case
// so callers can keep collecting errors.
func (s *userService) resolveRole(ctx context.Context, v *ValidationError, id uint) *model.Role {
	if id == 0 {
		v.add(ctx, "role_id", i18n.KeyRequired)
		return &model.Role{}
	}
	role, err := s.roles.FindByID(ctx, id)
	if err != nil {
		// Any lookup failure reads as "no such role" to the client; a real
		// database outage surfaces on the next query anyway.
		v.add(ctx, "role_id", i18n.KeyDoesNotExist)
		return &model.Role{}
	}
	return role
}

// loadActor returns the caller of ctx with their current role. Services that
// act on behalf of someone require one; a missing principal means the route
// is not behind the auth middleware, which is a wiring bug, not a guest.
func loadActor(ctx context.Context, users repository.UserRepository) (*model.User, error) {
	p, ok := auth.PrincipalFrom(ctx)
	if !ok {
		return nil, ruleError(ctx, ErrUnauthorized, i18n.KeyAuthMissingToken)
	}
	u, err := users.FindByID(ctx, p.UserID)
	switch {
	case errors.Is(err, repository.ErrNotFound):
		return nil, ruleError(ctx, ErrUnauthorized, i18n.KeyAuthAccountDisabled)
	case err != nil:
		return nil, fmt.Errorf("load caller %d: %w", p.UserID, err)
	case !u.IsActive:
		return nil, ruleError(ctx, ErrUnauthorized, i18n.KeyAuthAccountDisabled)
	}
	return u, nil
}

func isSuperAdmin(u *model.User) bool {
	return u.Role != nil && u.Role.IsSystem
}

func normalizeUserEmail(email string) string {
	return strings.ToLower(strings.TrimSpace(email))
}

func validateUserEmail(ctx context.Context, v *ValidationError, email string) {
	switch addr, err := mail.ParseAddress(email); {
	case email == "":
		v.add(ctx, "email", i18n.KeyRequired)
	case len(email) > maxEmailLength:
		v.add(ctx, "email", i18n.KeyMaxChars, maxEmailLength)
	case err != nil || addr.Address != email:
		v.add(ctx, "email", i18n.KeyEmailInvalid)
	}
}

func validateUserName(ctx context.Context, v *ValidationError, name string) {
	switch {
	case name == "":
		v.add(ctx, "name", i18n.KeyRequired)
	case len(name) > maxUserNameLength:
		v.add(ctx, "name", i18n.KeyMaxChars, maxUserNameLength)
	}
}

func validatePassword(ctx context.Context, v *ValidationError, password string) {
	switch {
	case password == "":
		v.add(ctx, "password", i18n.KeyRequired)
	case utf8.RuneCountInString(password) < auth.MinPasswordLength:
		v.add(ctx, "password", i18n.KeyMinChars, auth.MinPasswordLength)
	case len(password) > auth.MaxPasswordBytes:
		v.add(ctx, "password", i18n.KeyMaxBytes, auth.MaxPasswordBytes)
	}
}

// mapUserRepoError reports a duplicate key as a conflict on the email, the
// only unique column besides the id.
func mapUserRepoError(ctx context.Context, err error, id uint) error {
	if errors.Is(err, repository.ErrDuplicateKey) {
		return ruleError(ctx, ErrConflict, i18n.KeyUserEmailTaken)
	}
	// Errors the mutation built itself already carry a service sentinel.
	var verr *ValidationError
	if errors.As(err, &verr) || errors.Is(err, ErrConflict) || errors.Is(err, ErrForbidden) || errors.Is(err, ErrUnauthorized) {
		return err
	}
	return mapRepoError(ctx, err, i18n.KeyEntityUser, id)
}
