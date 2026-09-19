package repository

import (
	"context"
	"fmt"
	"sort"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

type SalesOrderRepository interface {
	// Create assigns the next order number of day (YYYYMMDD) and inserts the
	// order and its items in one transaction. The per-day counter is part of
	// that transaction, so numbers are unique and a failed insert leaves no gap.
	Create(ctx context.Context, o *model.SalesOrder, day string) error
	// FindByID returns the order with its items and customer (even if the
	// customer was soft-deleted later).
	FindByID(ctx context.Context, id uint) (*model.SalesOrder, error)
	// List returns orders (with customer, without items), newest first.
	List(ctx context.Context, params model.ListSalesOrdersParams) ([]model.SalesOrder, int64, error)
	// FindActiveProducts returns the products with the given ids that exist
	// and are not soft-deleted, keyed by id.
	FindActiveProducts(ctx context.Context, ids []uint) (map[uint]model.Product, error)
	// InTx runs fn in one database transaction: committed if fn returns nil,
	// rolled back otherwise (fn's error is returned as is).
	InTx(ctx context.Context, fn func(tx SalesOrderTx) error) error
}

// SalesOrderTx are the operations available inside InTx. Locks are held
// until the transaction ends.
type SalesOrderTx interface {
	// LockOrder loads the order with its items (ordered by item id) and locks
	// the order row. Returns ErrNotFound if it doesn't exist.
	LockOrder(id uint) (*model.SalesOrder, error)
	// LockInventories locks the inventory rows of productIDs, creating
	// missing rows (quantity 0, defaultThreshold). Rows are locked in
	// ascending product id order so concurrent orders can't deadlock.
	LockInventories(productIDs []uint, defaultThreshold int64) (map[uint]*model.Inventory, error)
	// ActiveProductIDs reports which of ids are products that are not soft-deleted.
	ActiveProductIDs(ids []uint) (map[uint]bool, error)
	SaveInventory(inv *model.Inventory) error
	CreateMovement(mv *model.StockMovement) error
	// SaveOrderStatus persists the order's status and status timestamps.
	SaveOrderStatus(o *model.SalesOrder) error
}

type salesOrderRepository struct {
	db *gorm.DB
}

func NewSalesOrderRepository(db *gorm.DB) SalesOrderRepository {
	return &salesOrderRepository{db: db}
}

func (r *salesOrderRepository) Create(ctx context.Context, o *model.SalesOrder, day string) error {
	err := r.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var seq int64
		err := tx.Raw(`INSERT INTO sales_order_counters (day, last_value) VALUES (?, 1)
			ON CONFLICT (day) DO UPDATE SET last_value = sales_order_counters.last_value + 1
			RETURNING last_value`, day).Scan(&seq).Error
		if err != nil {
			return fmt.Errorf("next order number: %w", err)
		}
		o.OrderNumber = model.FormatOrderNumber(day, seq)

		if err := tx.Omit(clause.Associations).Create(o).Error; err != nil {
			return fmt.Errorf("insert order: %w", err)
		}
		for i := range o.Items {
			o.Items[i].SalesOrderID = o.ID
		}
		if err := tx.Omit(clause.Associations).Create(&o.Items).Error; err != nil {
			return fmt.Errorf("insert order items: %w", err)
		}
		return nil
	})
	if err != nil {
		return fmt.Errorf("create sales order: %w", translate(err))
	}
	return nil
}

func (r *salesOrderRepository) FindByID(ctx context.Context, id uint) (*model.SalesOrder, error) {
	var o model.SalesOrder
	err := r.db.WithContext(ctx).
		Preload("Items", func(db *gorm.DB) *gorm.DB { return db.Order("id ASC") }).
		Preload("Customer", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		First(&o, id).Error
	if err != nil {
		return nil, fmt.Errorf("find sales order %d: %w", id, translate(err))
	}
	return &o, nil
}

func (r *salesOrderRepository) List(ctx context.Context, params model.ListSalesOrdersParams) ([]model.SalesOrder, int64, error) {
	q := r.db.WithContext(ctx).Model(&model.SalesOrder{})
	if params.Status != "" {
		q = q.Where("status = ?", params.Status)
	}
	if params.CustomerID != 0 {
		q = q.Where("customer_id = ?", params.CustomerID)
	}

	var total int64
	if err := q.Count(&total).Error; err != nil {
		return nil, 0, fmt.Errorf("count sales orders: %w", err)
	}

	var orders []model.SalesOrder
	err := q.Preload("Customer", func(db *gorm.DB) *gorm.DB { return db.Unscoped() }).
		Order("id DESC").
		Limit(params.PageSize).
		Offset((params.Page - 1) * params.PageSize).
		Find(&orders).Error
	if err != nil {
		return nil, 0, fmt.Errorf("list sales orders: %w", err)
	}
	return orders, total, nil
}

func (r *salesOrderRepository) FindActiveProducts(ctx context.Context, ids []uint) (map[uint]model.Product, error) {
	var products []model.Product
	if err := r.db.WithContext(ctx).Where("id IN ?", ids).Find(&products).Error; err != nil {
		return nil, fmt.Errorf("find products: %w", err)
	}
	byID := make(map[uint]model.Product, len(products))
	for _, p := range products {
		byID[p.ID] = p
	}
	return byID, nil
}

func (r *salesOrderRepository) InTx(ctx context.Context, fn func(tx SalesOrderTx) error) error {
	return r.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		return fn(&salesOrderTx{tx: tx})
	})
}

type salesOrderTx struct {
	tx *gorm.DB
}

func (t *salesOrderTx) LockOrder(id uint) (*model.SalesOrder, error) {
	var o model.SalesOrder
	err := t.tx.Clauses(clause.Locking{Strength: clause.LockingStrengthUpdate}).First(&o, id).Error
	if err != nil {
		return nil, fmt.Errorf("lock sales order %d: %w", id, translate(err))
	}
	if err := t.tx.Where("sales_order_id = ?", id).Order("id ASC").Find(&o.Items).Error; err != nil {
		return nil, fmt.Errorf("load items of sales order %d: %w", id, err)
	}
	return &o, nil
}

func (t *salesOrderTx) LockInventories(productIDs []uint, defaultThreshold int64) (map[uint]*model.Inventory, error) {
	ids := append([]uint(nil), productIDs...)
	sort.Slice(ids, func(i, j int) bool { return ids[i] < ids[j] })

	locked := make(map[uint]*model.Inventory, len(ids))
	for _, id := range ids {
		if _, done := locked[id]; done {
			continue
		}
		inv, err := lockInventoryRow(t.tx, id, defaultThreshold)
		if err != nil {
			return nil, err
		}
		locked[id] = inv
	}
	return locked, nil
}

func (t *salesOrderTx) ActiveProductIDs(ids []uint) (map[uint]bool, error) {
	var found []uint
	if err := t.tx.Model(&model.Product{}).Where("id IN ?", ids).Pluck("id", &found).Error; err != nil {
		return nil, fmt.Errorf("check products: %w", err)
	}
	active := make(map[uint]bool, len(found))
	for _, id := range found {
		active[id] = true
	}
	return active, nil
}

func (t *salesOrderTx) SaveInventory(inv *model.Inventory) error {
	if err := t.tx.Omit(clause.Associations).Save(inv).Error; err != nil {
		return fmt.Errorf("save inventory of product %d: %w", inv.ProductID, err)
	}
	return nil
}

func (t *salesOrderTx) CreateMovement(mv *model.StockMovement) error {
	if err := t.tx.Omit(clause.Associations).Create(mv).Error; err != nil {
		return fmt.Errorf("create stock movement for product %d: %w", mv.ProductID, err)
	}
	return nil
}

func (t *salesOrderTx) SaveOrderStatus(o *model.SalesOrder) error {
	err := t.tx.Model(o).Select("Status", "ConfirmedAt", "ShippedAt", "CancelledAt", "UpdatedAt").Updates(o).Error
	if err != nil {
		return fmt.Errorf("save status of sales order %d: %w", o.ID, err)
	}
	return nil
}
