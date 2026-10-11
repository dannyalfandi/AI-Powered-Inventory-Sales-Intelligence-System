package repository

import (
	"context"
	"fmt"
	"strings"
	"time"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

// UserMutation changes a locked user in place. u.Role is loaded with its
// permission keys (empty for the system role). activeSuperAdmins is the
// number of active users holding a system role, counted while those rows
// are locked, so "don't remove the last Super Admin" holds even when two
// admins demote each other at the same moment. Return revokeSessions=true to
// revoke the user's refresh tokens in the same transaction (deactivation,
// password change). An error rolls everything back and is returned as is.
type UserMutation func(u *model.User, activeSuperAdmins int64) (revokeSessions bool, err error)

type UserRepository interface {
	Create(ctx context.Context, u *model.User) error
	// FindByID returns a non-deleted user with its Role.
	FindByID(ctx context.Context, id uint) (*model.User, error)
	// FindByEmail returns a non-deleted user with its Role. email must
	// already be lowercase.
	FindByEmail(ctx context.Context, email string) (*model.User, error)
	List(ctx context.Context, params model.ListUsersParams) ([]model.User, int64, error)
	// Mutate runs fn on the locked user and saves the result. See UserMutation.
	Mutate(ctx context.Context, id uint, fn UserMutation) (*model.User, error)
	// Delete runs fn on the locked user (to refuse), then deactivates it,
	// soft-deletes it and revokes its refresh tokens, in one transaction.
	Delete(ctx context.Context, id uint, fn UserMutation) error
}

type userRepository struct {
	db  *gorm.DB
	now func() time.Time
}

func NewUserRepository(db *gorm.DB) UserRepository {
	return &userRepository{db: db, now: time.Now}
}

func (r *userRepository) Create(ctx context.Context, u *model.User) error {
	if err := r.db.WithContext(ctx).Omit(clause.Associations).Create(u).Error; err != nil {
		return fmt.Errorf("create user: %w", translate(err))
	}
	return nil
}

func (r *userRepository) FindByID(ctx context.Context, id uint) (*model.User, error) {
	var u model.User
	if err := r.db.WithContext(ctx).Preload("Role").First(&u, id).Error; err != nil {
		return nil, fmt.Errorf("find user %d: %w", id, translate(err))
	}
	return &u, nil
}

// FindByEmail uses Find rather than First: an unknown email is routine at
// login, and First would make GORM log "record not found" with the SQL —
// the email address included — for every failed or probing attempt.
func (r *userRepository) FindByEmail(ctx context.Context, email string) (*model.User, error) {
	var users []model.User
	if err := r.db.WithContext(ctx).Preload("Role").Where("email = ?", email).Limit(1).Find(&users).Error; err != nil {
		return nil, fmt.Errorf("find user by email: %w", err)
	}
	if len(users) == 0 {
		return nil, fmt.Errorf("find user by email: %w", ErrNotFound)
	}
	return &users[0], nil
}

func (r *userRepository) List(ctx context.Context, params model.ListUsersParams) ([]model.User, int64, error) {
	q := r.db.WithContext(ctx).Model(&model.User{})
	if s := strings.TrimSpace(params.Search); s != "" {
		like := "%" + s + "%"
		q = q.Where("name ILIKE ? OR email ILIKE ?", like, like)
	}
	if params.RoleID != 0 {
		q = q.Where("role_id = ?", params.RoleID)
	}

	var total int64
	if err := q.Count(&total).Error; err != nil {
		return nil, 0, fmt.Errorf("count users: %w", err)
	}

	var users []model.User
	err := q.Preload("Role").
		Order("name ASC, id ASC").
		Limit(params.PageSize).
		Offset((params.Page - 1) * params.PageSize).
		Find(&users).Error
	if err != nil {
		return nil, 0, fmt.Errorf("list users: %w", err)
	}
	return users, total, nil
}

func (r *userRepository) Mutate(ctx context.Context, id uint, fn UserMutation) (*model.User, error) {
	var out *model.User
	err := r.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		u, admins, err := lockUser(tx, id)
		if err != nil {
			return err
		}
		revoke, err := fn(u, admins)
		if err != nil {
			return err
		}
		if err := tx.Omit(clause.Associations).Save(u).Error; err != nil {
			return fmt.Errorf("update user %d: %w", id, translate(err))
		}
		if revoke || !u.IsActive {
			if _, err := revokeUserTokens(tx, id, r.now()); err != nil {
				return err
			}
		}
		out = u
		return nil
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (r *userRepository) Delete(ctx context.Context, id uint, fn UserMutation) error {
	return r.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		u, admins, err := lockUser(tx, id)
		if err != nil {
			return err
		}
		if _, err := fn(u, admins); err != nil {
			return err
		}
		// Deactivated as well as soft-deleted: every query that forgets the
		// deleted_at filter still sees an account that can't act.
		if err := tx.Model(u).Update("is_active", false).Error; err != nil {
			return fmt.Errorf("deactivate user %d: %w", id, err)
		}
		if err := tx.Delete(u).Error; err != nil {
			return fmt.Errorf("delete user %d: %w", id, err)
		}
		_, err = revokeUserTokens(tx, id, r.now())
		return err
	})
}

// lockUser locks every active Super Admin (in id order, so two transactions
// always take the locks in the same order), then the target user, and
// returns the target with its role (permission keys filled) and the number
// of active Super Admins.
func lockUser(tx *gorm.DB, id uint) (*model.User, int64, error) {
	var adminIDs []uint
	err := tx.Raw(`
		SELECT u.id FROM users u
		JOIN roles r ON r.id = u.role_id
		WHERE r.is_system AND u.is_active AND u.deleted_at IS NULL
		ORDER BY u.id
		FOR UPDATE OF u`).Scan(&adminIDs).Error
	if err != nil {
		return nil, 0, fmt.Errorf("lock super admins: %w", err)
	}

	var u model.User
	if err := tx.Clauses(clause.Locking{Strength: "UPDATE"}).First(&u, id).Error; err != nil {
		return nil, 0, fmt.Errorf("lock user %d: %w", id, translate(err))
	}
	var role model.Role
	if err := tx.First(&role, u.RoleID).Error; err != nil {
		return nil, 0, fmt.Errorf("load role of user %d: %w", id, translate(err))
	}
	// The service compares the target's permissions with the caller's
	// (a non-Super-Admin may only touch users whose role they could grant).
	roles := []model.Role{role}
	if err := fillPermissionKeys(tx, roles); err != nil {
		return nil, 0, err
	}
	u.Role = &roles[0]
	return &u, int64(len(adminIDs)), nil
}

// revokeUserTokens revokes every live refresh token of the user, returning
// how many. Used on deactivation/deletion/password change (inside the user's
// transaction) and on refresh-token reuse.
func revokeUserTokens(tx *gorm.DB, userID uint, now time.Time) (int64, error) {
	res := tx.Model(&model.RefreshToken{}).
		Where("user_id = ? AND revoked_at IS NULL", userID).
		Update("revoked_at", now)
	if res.Error != nil {
		return 0, fmt.Errorf("revoke refresh tokens of user %d: %w", userID, res.Error)
	}
	return res.RowsAffected, nil
}
