package model

import (
	"time"

	"gorm.io/gorm"
)

// Category groups products. A category can't be deleted while active
// products still reference it (enforced in the service layer).
type Category struct {
	ID          uint   `gorm:"primaryKey" json:"id"`
	Name        string `gorm:"size:100;not null;uniqueIndex:idx_categories_name_active,where:deleted_at IS NULL" json:"name"`
	Description string `gorm:"type:text" json:"description"`

	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}

type CreateCategoryInput struct {
	Name        string `json:"name"`
	Description string `json:"description"`
}

// UpdateCategoryInput is a partial update: nil fields are left unchanged.
type UpdateCategoryInput struct {
	Name        *string `json:"name"`
	Description *string `json:"description"`
}

type ListCategoriesParams struct {
	Page     int
	PageSize int
	Search   string // matches name, case-insensitive
}
