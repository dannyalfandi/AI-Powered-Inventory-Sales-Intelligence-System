package model

import "time"

// Inventory is the current stock level of one product (1-1, keyed by
// ProductID). Rows are created lazily on the first write; a product without
// a row has quantity 0 and the configured default threshold.
type Inventory struct {
	ProductID         uint  `gorm:"primaryKey;autoIncrement:false" json:"product_id"`
	Quantity          int64 `gorm:"not null;default:0;check:chk_inventories_quantity_non_negative,quantity >= 0" json:"quantity"`
	LowStockThreshold int64 `gorm:"not null;check:chk_inventories_threshold_non_negative,low_stock_threshold >= 0" json:"low_stock_threshold"`
	// IsLowStock is computed (quantity <= low_stock_threshold), not stored.
	IsLowStock bool `gorm:"-" json:"is_low_stock"`

	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`

	Product *Product `gorm:"constraint:OnUpdate:CASCADE,OnDelete:RESTRICT" json:"-"`
}

type MovementType string

const (
	MovementIn         MovementType = "IN"
	MovementOut        MovementType = "OUT"
	MovementAdjustment MovementType = "ADJUSTMENT"
)

// StockMovement is an immutable log entry for every stock change. Quantity is
// the amount moved for IN/OUT and the new stock level for ADJUSTMENT;
// QuantityBefore/QuantityAfter record the resulting balance.
type StockMovement struct {
	ID             uint         `gorm:"primaryKey;index:idx_stock_movements_product_id_id,priority:2" json:"id"`
	ProductID      uint         `gorm:"not null;index:idx_stock_movements_product_id_id,priority:1" json:"product_id"`
	Type           MovementType `gorm:"size:16;not null;check:chk_stock_movements_type,type IN ('IN','OUT','ADJUSTMENT')" json:"type"`
	Quantity       int64        `gorm:"not null;check:chk_stock_movements_quantity_non_negative,quantity >= 0" json:"quantity"`
	QuantityBefore int64        `gorm:"not null" json:"quantity_before"`
	QuantityAfter  int64        `gorm:"not null" json:"quantity_after"`
	Reason         string       `gorm:"type:text" json:"reason"`
	// SalesOrderID links movements made by an order status change (OUT on
	// CONFIRMED, IN on cancel); null for manual movements.
	SalesOrderID *uint     `gorm:"index" json:"sales_order_id,omitempty"`
	CreatedAt    time.Time `gorm:"index" json:"created_at"`

	Product    *Product    `gorm:"constraint:OnUpdate:CASCADE,OnDelete:RESTRICT" json:"-"`
	SalesOrder *SalesOrder `gorm:"constraint:OnUpdate:CASCADE,OnDelete:RESTRICT" json:"-"`
}

// UpdateInventoryInput changes inventory settings (not the quantity, which
// only changes through stock movements).
type UpdateInventoryInput struct {
	LowStockThreshold *int64 `json:"low_stock_threshold"`
}

type CreateStockMovementInput struct {
	Type     string `json:"type"`
	Quantity *int64 `json:"quantity"`
	Reason   string `json:"reason"`
}

type ListMovementsParams struct {
	Page     int
	PageSize int
}

type ListLowStockParams struct {
	Page     int
	PageSize int
}

// LowStockItem is one row of the low-stock report.
type LowStockItem struct {
	ProductID         uint   `json:"product_id"`
	SKU               string `json:"sku"`
	Name              string `json:"name"`
	Quantity          int64  `json:"quantity"`
	LowStockThreshold int64  `json:"low_stock_threshold"`
}
