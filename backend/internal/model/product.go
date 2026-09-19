package model

import (
	"time"

	"gorm.io/gorm"
)

// Product is a sellable item. Price is stored in the smallest currency unit
// (whole Rupiah) as an integer to avoid floating-point rounding errors.
type Product struct {
	ID          uint   `gorm:"primaryKey" json:"id"`
	SKU         string `gorm:"size:64;not null;uniqueIndex:idx_products_sku_active,where:deleted_at IS NULL" json:"sku"`
	Name        string `gorm:"size:255;not null" json:"name"`
	Description string `gorm:"type:text" json:"description"`
	Price       int64  `gorm:"not null;default:0" json:"price"`
	// CategoryID is optional: a product may not have a category yet.
	CategoryID *uint     `gorm:"index" json:"category_id"`
	Category   *Category `gorm:"constraint:OnUpdate:CASCADE,OnDelete:RESTRICT" json:"category,omitempty"`

	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
	// Soft delete: sales history keeps referencing deleted products.
	DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}

type CreateProductInput struct {
	SKU         string `json:"sku"`
	Name        string `json:"name"`
	Description string `json:"description"`
	Price       int64  `json:"price"`
	CategoryID  *uint  `json:"category_id"` // nil or 0: no category
}

// UpdateProductInput is a partial update: nil fields are left unchanged.
// CategoryID 0 removes the product's category.
type UpdateProductInput struct {
	SKU         *string `json:"sku"`
	Name        *string `json:"name"`
	Description *string `json:"description"`
	Price       *int64  `json:"price"`
	CategoryID  *uint   `json:"category_id"`
}

type ListProductsParams struct {
	Page     int
	PageSize int
	Search   string // matches name or SKU, case-insensitive
}
