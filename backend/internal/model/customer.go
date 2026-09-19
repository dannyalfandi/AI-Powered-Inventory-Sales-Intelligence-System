package model

import (
	"time"

	"gorm.io/gorm"
)

// Customer places sales orders. A customer can't be deleted while it has
// orders that are not cancelled (enforced in the service layer).
type Customer struct {
	ID   uint   `gorm:"primaryKey" json:"id"`
	Name string `gorm:"size:255;not null" json:"name"`
	// Email is optional (NULL when empty), stored lowercase, and unique among
	// active customers.
	Email   *string `gorm:"size:255;uniqueIndex:idx_customers_email_active,where:deleted_at IS NULL" json:"email"`
	Phone   string  `gorm:"size:32" json:"phone"`
	Address string  `gorm:"type:text" json:"address"`

	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}

type CreateCustomerInput struct {
	Name    string `json:"name"`
	Email   string `json:"email"`
	Phone   string `json:"phone"`
	Address string `json:"address"`
}

// UpdateCustomerInput is a partial update: nil fields are left unchanged.
// An empty email removes it.
type UpdateCustomerInput struct {
	Name    *string `json:"name"`
	Email   *string `json:"email"`
	Phone   *string `json:"phone"`
	Address *string `json:"address"`
}

type ListCustomersParams struct {
	Page     int
	PageSize int
	Search   string // matches name, email or phone, case-insensitive
}
