package model

import (
	"time"

	"gorm.io/gorm"
)

// Role is a named set of permissions. A user has exactly one role — a
// deliberate simplification; multi-role would turn role_id into a join table
// and the permission check into a union, without changing the catalog.
//
// IsSystem marks the Super Admin role: it passes every permission check
// without consulting role_permissions, and it can't be deleted, renamed or
// given a permission list.
type Role struct {
	ID          uint   `gorm:"primaryKey" json:"id"`
	Name        string `gorm:"size:100;not null;uniqueIndex" json:"name"`
	Description string `gorm:"type:text" json:"description"`
	IsSystem    bool   `gorm:"not null;default:false" json:"is_system"`
	// UserCount is how many users reference the role, soft-deleted users
	// included — the same number that makes DELETE /roles/:id answer 409.
	// Deleted users keep role_id as history and users.role_id is ON DELETE
	// RESTRICT, so the database itself refuses to delete a role while any
	// user row (deleted or not) points at it; counting fewer would show 0
	// for a role that can't be deleted. Computed by the repository in the
	// same query that loads the role (read-only, no column).
	//
	// A pointer so that it can be absent: every role endpoint sets it (0
	// included), but a role embedded in a user (GET /users) is loaded without
	// the count and must not claim "user_count": 0.
	UserCount *int64 `gorm:"->;-:migration" json:"user_count,omitempty"`

	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`

	// Permissions are the role's permission keys, filled by the service
	// (never stored on this table). A system role reports every key.
	Permissions []string `gorm:"-" json:"permissions"`
}

// Permission is one entry of the fixed catalog in internal/auth. Rows are
// synced from code by cmd/migrate; there is no endpoint that creates them.
type Permission struct {
	ID            uint   `gorm:"primaryKey" json:"id"`
	Key           string `gorm:"size:100;not null;uniqueIndex" json:"key"`
	Description   string `gorm:"type:text" json:"description"`
	ResourceGroup string `gorm:"size:50;not null;index" json:"resource_group"`
}

// RolePermission links a role to a permission (many-to-many).
type RolePermission struct {
	RoleID       uint `gorm:"primaryKey"`
	PermissionID uint `gorm:"primaryKey;index"`

	Role       *Role       `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	Permission *Permission `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
}

// User is someone who can log in. Email is stored lowercase and is unique
// among users that aren't deleted. A deleted user is also deactivated, and
// keeps its role_id for history — which is why the role stays undeletable
// (OnDelete:RESTRICT below) and why Role.UserCount counts deleted users.
type User struct {
	ID           uint   `gorm:"primaryKey" json:"id"`
	Email        string `gorm:"size:255;not null;uniqueIndex:idx_users_email_active,where:deleted_at IS NULL" json:"email"`
	PasswordHash string `gorm:"size:100;not null" json:"-"`
	Name         string `gorm:"size:255;not null" json:"name"`
	RoleID       uint   `gorm:"not null;index" json:"role_id"`
	Role         *Role  `gorm:"constraint:OnUpdate:CASCADE,OnDelete:RESTRICT" json:"role,omitempty"`
	// No `default:true` tag: GORM skips zero values on insert when a column
	// has a default, so creating an inactive user would silently activate it.
	IsActive bool `gorm:"not null" json:"is_active"`

	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}

// RefreshToken is the server-side record of an issued refresh token. Only
// the SHA-256 of the token is stored, so a database leak does not leak
// usable tokens. A token is usable while it is not revoked and not expired;
// every refresh revokes the token it used (rotation).
type RefreshToken struct {
	ID        uint       `gorm:"primaryKey"`
	UserID    uint       `gorm:"not null;index"`
	User      *User      `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	TokenHash string     `gorm:"size:64;not null;uniqueIndex"`
	ExpiresAt time.Time  `gorm:"not null"`
	RevokedAt *time.Time `gorm:"index"`
	CreatedAt time.Time
}

// --- auth inputs / outputs ---------------------------------------------------

type LoginInput struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type RefreshInput struct {
	RefreshToken string `json:"refresh_token"`
}

// RoleRef is the short form of a role inside a user.
type RoleRef struct {
	ID       uint   `json:"id"`
	Name     string `json:"name"`
	IsSystem bool   `json:"is_system"`
}

// AuthUser is the user as the login response describes it.
type AuthUser struct {
	ID    uint    `json:"id"`
	Email string  `json:"email"`
	Name  string  `json:"name"`
	Role  RoleRef `json:"role"`
}

// TokenPair is what login and refresh return.
type TokenPair struct {
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
	TokenType    string `json:"token_type"`
	// ExpiresIn is the access token lifetime in seconds.
	ExpiresIn int64     `json:"expires_in"`
	User      *AuthUser `json:"user,omitempty"`
}

// Me is GET /auth/me: the caller, their role and the permission keys they
// hold right now. A client renders its UI from Permissions.
type Me struct {
	ID          uint     `json:"id"`
	Email       string   `json:"email"`
	Name        string   `json:"name"`
	IsActive    bool     `json:"is_active"`
	Role        RoleRef  `json:"role"`
	Permissions []string `json:"permissions"`
}

// --- users -------------------------------------------------------------------

type CreateUserInput struct {
	Email    string `json:"email"`
	Password string `json:"password"`
	Name     string `json:"name"`
	RoleID   uint   `json:"role_id"`
	// IsActive defaults to true when omitted.
	IsActive *bool `json:"is_active"`
}

// UpdateUserInput is a partial update: nil fields are left unchanged.
type UpdateUserInput struct {
	Email    *string `json:"email"`
	Password *string `json:"password"`
	Name     *string `json:"name"`
	RoleID   *uint   `json:"role_id"`
	IsActive *bool   `json:"is_active"`
}

type ListUsersParams struct {
	Page     int
	PageSize int
	Search   string // matches name or email, case-insensitive
	RoleID   uint   // 0 = any role
}

// --- roles -------------------------------------------------------------------

type CreateRoleInput struct {
	Name        string `json:"name"`
	Description string `json:"description"`
}

// UpdateRoleInput is a partial update: nil fields are left unchanged.
type UpdateRoleInput struct {
	Name        *string `json:"name"`
	Description *string `json:"description"`
}

// SetRolePermissionsInput replaces a role's permission list.
type SetRolePermissionsInput struct {
	PermissionKeys []string `json:"permission_keys"`
}

type ListRolesParams struct {
	Page     int
	PageSize int
	Search   string // matches name, case-insensitive
}

// AuthzState is what one authorization query returns: whether the user can
// act at all, and whether their role grants the permission asked about.
type AuthzState struct {
	// Found is false when the user doesn't exist, is deleted or inactive.
	Found         bool
	IsSystem      bool
	HasPermission bool
}
