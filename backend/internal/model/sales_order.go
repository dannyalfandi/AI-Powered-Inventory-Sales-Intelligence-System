package model

import (
	"fmt"
	"time"
)

type OrderStatus string

const (
	OrderPending   OrderStatus = "PENDING"
	OrderConfirmed OrderStatus = "CONFIRMED"
	OrderShipped   OrderStatus = "SHIPPED"
	OrderCancelled OrderStatus = "CANCELLED"
)

// SalesOrder is a customer order. Items are fixed once the order is created;
// only the status changes (see service.orderTransitions). Stock is deducted on
// CONFIRMED and returned when a CONFIRMED order is CANCELLED.
type SalesOrder struct {
	ID          uint        `gorm:"primaryKey" json:"id"`
	OrderNumber string      `gorm:"size:32;not null;uniqueIndex" json:"order_number"`
	CustomerID  uint        `gorm:"not null;index" json:"customer_id"`
	Status      OrderStatus `gorm:"size:16;not null;index;check:chk_sales_orders_status,status IN ('PENDING','CONFIRMED','SHIPPED','CANCELLED')" json:"status"`
	// TotalAmount is the sum of item subtotals, in whole Rupiah.
	TotalAmount int64  `gorm:"not null;check:chk_sales_orders_total_non_negative,total_amount >= 0" json:"total_amount"`
	Notes       string `gorm:"type:text" json:"notes"`

	// Set when the order enters that status; null otherwise.
	ConfirmedAt *time.Time `json:"confirmed_at"`
	ShippedAt   *time.Time `json:"shipped_at"`
	CancelledAt *time.Time `json:"cancelled_at"`

	CreatedAt time.Time `gorm:"index" json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`

	Customer *Customer        `gorm:"constraint:OnUpdate:CASCADE,OnDelete:RESTRICT" json:"customer,omitempty"`
	Items    []SalesOrderItem `gorm:"constraint:OnUpdate:CASCADE,OnDelete:RESTRICT" json:"items,omitempty"`
}

// SalesOrderItem is one order line. UnitPrice (and the product SKU/name) are
// snapshots taken when the order was created, so later product changes don't
// rewrite order history.
type SalesOrderItem struct {
	ID           uint   `gorm:"primaryKey" json:"id"`
	SalesOrderID uint   `gorm:"not null;index" json:"sales_order_id"`
	ProductID    uint   `gorm:"not null;index" json:"product_id"`
	ProductSKU   string `gorm:"size:64;not null" json:"product_sku"`
	ProductName  string `gorm:"size:255;not null" json:"product_name"`
	Quantity     int64  `gorm:"not null;check:chk_sales_order_items_quantity_positive,quantity > 0" json:"quantity"`
	UnitPrice    int64  `gorm:"not null;check:chk_sales_order_items_unit_price_non_negative,unit_price >= 0" json:"unit_price"`
	Subtotal     int64  `gorm:"not null;check:chk_sales_order_items_subtotal_non_negative,subtotal >= 0" json:"subtotal"`

	Product *Product `gorm:"constraint:OnUpdate:CASCADE,OnDelete:RESTRICT" json:"-"`
}

// SalesOrderCounter holds the last order sequence number per day, used to
// generate order numbers without races (upserted inside the order's transaction).
type SalesOrderCounter struct {
	Day       string `gorm:"primaryKey;size:8"` // YYYYMMDD
	LastValue int64  `gorm:"not null"`
}

// FormatOrderNumber builds e.g. "SO-20260920-0001" (widens past 9999).
func FormatOrderNumber(day string, seq int64) string {
	return fmt.Sprintf("SO-%s-%04d", day, seq)
}

type CreateSalesOrderInput struct {
	CustomerID uint                   `json:"customer_id"`
	Items      []CreateOrderItemInput `json:"items"`
	Notes      string                 `json:"notes"`
}

type CreateOrderItemInput struct {
	ProductID uint  `json:"product_id"`
	Quantity  int64 `json:"quantity"`
}

type UpdateOrderStatusInput struct {
	Status string `json:"status"`
}

type ListSalesOrdersParams struct {
	Page       int
	PageSize   int
	Status     OrderStatus // empty = any
	CustomerID uint        // 0 = any
}
