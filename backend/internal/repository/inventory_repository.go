package repository

import (
	"context"
	"fmt"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

// InventoryMutation changes a locked inventory row in place. It may return a
// movement to record in the same transaction, or nil to record none.
// Returning an error rolls the transaction back and is passed through as is.
type InventoryMutation func(inv *model.Inventory) (*model.StockMovement, error)

type InventoryRepository interface {
	// FindByProductID returns ErrNotFound if the product has no inventory row yet.
	FindByProductID(ctx context.Context, productID uint) (*model.Inventory, error)
	// Mutate runs fn on the product's inventory row inside a transaction,
	// holding a row lock (SELECT ... FOR UPDATE), then saves the row and the
	// returned movement. The row is created with defaultThreshold if missing.
	// Returns ErrNotFound if the product doesn't exist.
	Mutate(ctx context.Context, productID uint, defaultThreshold int64, fn InventoryMutation) (*model.Inventory, *model.StockMovement, error)
	ListMovements(ctx context.Context, productID uint, params model.ListMovementsParams) ([]model.StockMovement, int64, error)
	// ListLowStock lists active products whose quantity <= threshold. Products
	// without an inventory row count as quantity 0 with defaultThreshold.
	ListLowStock(ctx context.Context, defaultThreshold int64, params model.ListLowStockParams) ([]model.LowStockItem, int64, error)
}

type inventoryRepository struct {
	db *gorm.DB
}

func NewInventoryRepository(db *gorm.DB) InventoryRepository {
	return &inventoryRepository{db: db}
}

func (r *inventoryRepository) FindByProductID(ctx context.Context, productID uint) (*model.Inventory, error) {
	var inv model.Inventory
	if err := r.db.WithContext(ctx).First(&inv, "product_id = ?", productID).Error; err != nil {
		return nil, fmt.Errorf("find inventory of product %d: %w", productID, translate(err))
	}
	return &inv, nil
}

func (r *inventoryRepository) Mutate(ctx context.Context, productID uint, defaultThreshold int64, fn InventoryMutation) (*model.Inventory, *model.StockMovement, error) {
	var (
		inv model.Inventory
		mv  *model.StockMovement
	)
	err := r.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var n int64
		if err := tx.Model(&model.Product{}).Where("id = ?", productID).Count(&n).Error; err != nil {
			return fmt.Errorf("check product: %w", err)
		}
		if n == 0 {
			return ErrNotFound
		}

		locked, err := lockInventoryRow(tx, productID, defaultThreshold)
		if err != nil {
			return err
		}
		inv = *locked

		if mv, err = fn(&inv); err != nil {
			return err
		}

		if err := tx.Omit(clause.Associations).Save(&inv).Error; err != nil {
			return fmt.Errorf("save inventory: %w", err)
		}
		if mv != nil {
			mv.ProductID = productID
			if err := tx.Omit(clause.Associations).Create(mv).Error; err != nil {
				return fmt.Errorf("create stock movement: %w", err)
			}
		}
		return nil
	})
	if err != nil {
		return nil, nil, fmt.Errorf("update inventory of product %d: %w", productID, translate(err))
	}
	return &inv, mv, nil
}

func (r *inventoryRepository) ListMovements(ctx context.Context, productID uint, params model.ListMovementsParams) ([]model.StockMovement, int64, error) {
	q := r.db.WithContext(ctx).Model(&model.StockMovement{}).Where("product_id = ?", productID)

	var total int64
	if err := q.Count(&total).Error; err != nil {
		return nil, 0, fmt.Errorf("count stock movements: %w", err)
	}

	var movements []model.StockMovement
	err := q.Order("id DESC").
		Limit(params.PageSize).
		Offset((params.Page - 1) * params.PageSize).
		Find(&movements).Error
	if err != nil {
		return nil, 0, fmt.Errorf("list stock movements: %w", err)
	}
	return movements, total, nil
}

func (r *inventoryRepository) ListLowStock(ctx context.Context, defaultThreshold int64, params model.ListLowStockParams) ([]model.LowStockItem, int64, error) {
	base := func() *gorm.DB {
		return r.db.WithContext(ctx).
			Table("products AS p").
			Joins("LEFT JOIN inventories AS i ON i.product_id = p.id").
			Where("p.deleted_at IS NULL").
			Where("COALESCE(i.quantity, 0) <= COALESCE(i.low_stock_threshold, ?)", defaultThreshold)
	}

	var total int64
	if err := base().Count(&total).Error; err != nil {
		return nil, 0, fmt.Errorf("count low-stock products: %w", err)
	}

	var items []model.LowStockItem
	err := base().
		Select("p.id AS product_id, p.sku, p.name, "+
			"COALESCE(i.quantity, 0) AS quantity, "+
			"COALESCE(i.low_stock_threshold, ?) AS low_stock_threshold", defaultThreshold).
		Order("quantity ASC, p.id ASC").
		Limit(params.PageSize).
		Offset((params.Page - 1) * params.PageSize).
		Scan(&items).Error
	if err != nil {
		return nil, 0, fmt.Errorf("list low-stock products: %w", err)
	}
	return items, total, nil
}

// lockInventoryRow returns the product's inventory row locked with
// SELECT ... FOR UPDATE until tx ends, creating it first (quantity 0,
// defaultThreshold) if the product has none. Shared by stock movements and
// sales order status changes so both serialize on the same row.
func lockInventoryRow(tx *gorm.DB, productID uint, defaultThreshold int64) (*model.Inventory, error) {
	seed := model.Inventory{ProductID: productID, LowStockThreshold: defaultThreshold}
	if err := tx.Omit(clause.Associations).
		Clauses(clause.OnConflict{DoNothing: true}).
		Create(&seed).Error; err != nil {
		return nil, fmt.Errorf("create inventory row of product %d: %w", productID, err)
	}
	var inv model.Inventory
	if err := tx.Clauses(clause.Locking{Strength: clause.LockingStrengthUpdate}).
		First(&inv, "product_id = ?", productID).Error; err != nil {
		return nil, fmt.Errorf("lock inventory row of product %d: %w", productID, err)
	}
	return &inv, nil
}
