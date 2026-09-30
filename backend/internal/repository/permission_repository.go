package repository

import (
	"context"
	"fmt"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/auth"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

type PermissionRepository interface {
	// SyncCatalog makes the permissions table match catalog exactly: new keys
	// are inserted, descriptions and groups updated, and keys that are no
	// longer in code deleted (their role links go with them, ON DELETE CASCADE).
	SyncCatalog(ctx context.Context, catalog []model.Permission) error
	// List returns every permission in catalog order.
	List(ctx context.Context) ([]model.Permission, error)
	// Authorize answers, in one query, whether userID is an active user and
	// whether their *current* role is a system role or grants permission.
	Authorize(ctx context.Context, userID uint, permission string) (model.AuthzState, error)
}

type permissionRepository struct {
	db *gorm.DB
}

func NewPermissionRepository(db *gorm.DB) PermissionRepository {
	return &permissionRepository{db: db}
}

func (r *permissionRepository) SyncCatalog(ctx context.Context, catalog []model.Permission) error {
	return r.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		keys := make([]string, len(catalog))
		for i := range catalog {
			keys[i] = catalog[i].Key
			row := model.Permission{
				Key: catalog[i].Key, Description: catalog[i].Description, ResourceGroup: catalog[i].ResourceGroup,
			}
			err := tx.Clauses(clause.OnConflict{
				Columns:   []clause.Column{{Name: "key"}},
				DoUpdates: clause.AssignmentColumns([]string{"description", "resource_group"}),
			}).Create(&row).Error
			if err != nil {
				return fmt.Errorf("upsert permission %q: %w", catalog[i].Key, err)
			}
		}
		if len(keys) > 0 {
			if err := tx.Where(`"key" NOT IN ?`, keys).Delete(&model.Permission{}).Error; err != nil {
				return fmt.Errorf("delete retired permissions: %w", err)
			}
		}
		return nil
	})
}

func (r *permissionRepository) List(ctx context.Context) ([]model.Permission, error) {
	var perms []model.Permission
	// Ids follow insertion order, which is catalog order on a fresh database.
	if err := r.db.WithContext(ctx).Order("id ASC").Find(&perms).Error; err != nil {
		return nil, fmt.Errorf("list permissions: %w", err)
	}
	return perms, nil
}

// authorizeSQL is the whole permission check. It reads the user's role from
// users.role_id rather than trusting the role in the token, and it filters
// on is_active/deleted_at, so a demotion or a deactivation applies on the
// very next request. Every lookup is by primary key or unique index.
const authorizeSQL = `
SELECT r.is_system AS is_system,
       EXISTS (
         SELECT 1
         FROM role_permissions rp
         JOIN permissions p ON p.id = rp.permission_id
         WHERE rp.role_id = r.id AND p."key" = ?
       ) AS has_permission
FROM users u
JOIN roles r ON r.id = u.role_id
WHERE u.id = ? AND u.is_active AND u.deleted_at IS NULL`

func (r *permissionRepository) Authorize(ctx context.Context, userID uint, permission string) (model.AuthzState, error) {
	var rows []struct {
		IsSystem      bool
		HasPermission bool
	}
	if err := r.db.WithContext(ctx).Raw(authorizeSQL, permission, userID).Scan(&rows).Error; err != nil {
		return model.AuthzState{}, fmt.Errorf("authorize user %d for %s: %w", userID, permission, err)
	}
	if len(rows) == 0 {
		return model.AuthzState{}, nil
	}
	return model.AuthzState{Found: true, IsSystem: rows[0].IsSystem, HasPermission: rows[0].HasPermission}, nil
}

// PermissionCatalog turns the code catalog (internal/auth) into rows for
// SyncCatalog, with the Indonesian description; the API translates it per
// request.
func PermissionCatalog() []model.Permission {
	rows := make([]model.Permission, len(auth.Catalog))
	for i, def := range auth.Catalog {
		rows[i] = model.Permission{Key: string(def.Key), ResourceGroup: def.Group, Description: def.Description(i18n.ID)}
	}
	return rows
}
