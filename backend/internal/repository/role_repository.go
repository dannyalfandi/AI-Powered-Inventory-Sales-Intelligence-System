package repository

import (
	"context"
	"fmt"
	"strings"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

type RoleRepository interface {
	Create(ctx context.Context, r *model.Role) error
	// FindByID returns the role with Permissions filled from role_permissions
	// and UserCount computed (see roleColumnsWithUserCount).
	FindByID(ctx context.Context, id uint) (*model.Role, error)
	// List returns roles with Permissions and UserCount filled. The counts
	// come from the same query as the roles, never one query per role.
	List(ctx context.Context, params model.ListRolesParams) ([]model.Role, int64, error)
	Update(ctx context.Context, r *model.Role) error
	// Delete removes the role and its permission links. Returns ErrInUse if a
	// user still references it (users.role_id is ON DELETE RESTRICT).
	Delete(ctx context.Context, id uint) error
	// ReplacePermissions sets the role's permissions to exactly keys, in one
	// transaction that holds a lock on the role row, so two concurrent
	// replacements can't interleave into a mix of both lists.
	ReplacePermissions(ctx context.Context, id uint, keys []string) error
}

// roleColumnsWithUserCount selects a role plus its user_count in one
// statement. It is the only definition of user_count: every users row that
// references the role, soft-deleted ones included (raw SQL, so GORM adds no
// deleted_at filter). Deleted users keep role_id as history, and
// users.role_id is ON DELETE RESTRICT, so exactly these rows make Postgres
// refuse to delete the role; the service's 409 reads this same number.
// The correlated subquery is answered from the index on users.role_id.
const roleColumnsWithUserCount = `roles.*, (SELECT COUNT(*) FROM users u WHERE u.role_id = roles.id) AS user_count`

type roleRepository struct {
	db *gorm.DB
}

func NewRoleRepository(db *gorm.DB) RoleRepository {
	return &roleRepository{db: db}
}

func (r *roleRepository) Create(ctx context.Context, role *model.Role) error {
	if err := r.db.WithContext(ctx).Create(role).Error; err != nil {
		return fmt.Errorf("create role: %w", translate(err))
	}
	return nil
}

func (r *roleRepository) FindByID(ctx context.Context, id uint) (*model.Role, error) {
	var role model.Role
	if err := r.db.WithContext(ctx).Select(roleColumnsWithUserCount).First(&role, id).Error; err != nil {
		return nil, fmt.Errorf("find role %d: %w", id, translate(err))
	}
	roles := []model.Role{role}
	if err := fillPermissionKeys(r.db.WithContext(ctx), roles); err != nil {
		return nil, err
	}
	return &roles[0], nil
}

func (r *roleRepository) List(ctx context.Context, params model.ListRolesParams) ([]model.Role, int64, error) {
	q := r.db.WithContext(ctx).Model(&model.Role{})
	if s := strings.TrimSpace(params.Search); s != "" {
		q = q.Where("name ILIKE ?", "%"+s+"%")
	}

	var total int64
	if err := q.Count(&total).Error; err != nil {
		return nil, 0, fmt.Errorf("count roles: %w", err)
	}

	var roles []model.Role
	err := q.Select(roleColumnsWithUserCount).
		Order("is_system DESC, name ASC, id ASC").
		Limit(params.PageSize).
		Offset((params.Page - 1) * params.PageSize).
		Find(&roles).Error
	if err != nil {
		return nil, 0, fmt.Errorf("list roles: %w", err)
	}
	if err := fillPermissionKeys(r.db.WithContext(ctx), roles); err != nil {
		return nil, 0, err
	}
	return roles, total, nil
}

func (r *roleRepository) Update(ctx context.Context, role *model.Role) error {
	if err := r.db.WithContext(ctx).Omit(clause.Associations).Save(role).Error; err != nil {
		return fmt.Errorf("update role %d: %w", role.ID, translate(err))
	}
	return nil
}

func (r *roleRepository) Delete(ctx context.Context, id uint) error {
	return r.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		if err := tx.Where("role_id = ?", id).Delete(&model.RolePermission{}).Error; err != nil {
			return fmt.Errorf("delete permissions of role %d: %w", id, err)
		}
		res := tx.Delete(&model.Role{}, id)
		if res.Error != nil {
			return fmt.Errorf("delete role %d: %w", id, translate(res.Error))
		}
		if res.RowsAffected == 0 {
			return fmt.Errorf("delete role %d: %w", id, ErrNotFound)
		}
		return nil
	})
}

func (r *roleRepository) ReplacePermissions(ctx context.Context, id uint, keys []string) error {
	return r.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var role model.Role
		if err := tx.Clauses(clause.Locking{Strength: "UPDATE"}).First(&role, id).Error; err != nil {
			return fmt.Errorf("lock role %d: %w", id, translate(err))
		}

		var ids []uint
		if len(keys) > 0 {
			if err := tx.Model(&model.Permission{}).Where(`"key" IN ?`, keys).Pluck("id", &ids).Error; err != nil {
				return fmt.Errorf("resolve permission keys: %w", err)
			}
			// The service only passes catalog keys; a shortfall means the
			// permissions table is behind the code (cmd/migrate not run).
			if len(ids) != len(keys) {
				return fmt.Errorf("resolve permission keys: %d of %d found; run `go run ./cmd/migrate` to sync the catalog",
					len(ids), len(keys))
			}
		}

		if err := tx.Where("role_id = ?", id).Delete(&model.RolePermission{}).Error; err != nil {
			return fmt.Errorf("clear permissions of role %d: %w", id, err)
		}
		if len(ids) > 0 {
			links := make([]model.RolePermission, len(ids))
			for i, pid := range ids {
				links[i] = model.RolePermission{RoleID: id, PermissionID: pid}
			}
			if err := tx.Omit(clause.Associations).Create(&links).Error; err != nil {
				return fmt.Errorf("insert permissions of role %d: %w", id, err)
			}
		}
		// Touch updated_at so clients can see the role changed.
		if err := tx.Model(&role).Update("updated_at", gorm.Expr("NOW()")).Error; err != nil {
			return fmt.Errorf("touch role %d: %w", id, err)
		}
		return nil
	})
}

// fillPermissionKeys loads the permission keys of every role in one query.
func fillPermissionKeys(db *gorm.DB, roles []model.Role) error {
	if len(roles) == 0 {
		return nil
	}
	ids := make([]uint, len(roles))
	for i := range roles {
		ids[i] = roles[i].ID
		roles[i].Permissions = []string{}
	}
	var links []struct {
		RoleID uint
		Key    string
	}
	err := db.Table("role_permissions rp").
		Select(`rp.role_id AS role_id, p."key" AS key`).
		Joins("JOIN permissions p ON p.id = rp.permission_id").
		Where("rp.role_id IN ?", ids).
		Order("p.id ASC").
		Scan(&links).Error
	if err != nil {
		return fmt.Errorf("load role permissions: %w", err)
	}
	byRole := make(map[uint]int, len(roles))
	for i := range roles {
		byRole[roles[i].ID] = i
	}
	for _, l := range links {
		i := byRole[l.RoleID]
		roles[i].Permissions = append(roles[i].Permissions, l.Key)
	}
	return nil
}
