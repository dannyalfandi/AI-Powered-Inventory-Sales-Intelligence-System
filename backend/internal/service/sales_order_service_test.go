package service

import (
	"context"
	"fmt"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

// --- test doubles -----------------------------------------------------------

// orderStore is an in-memory stand-in for the database state touched by
// status changes. InTx runs the callback on a deep copy and only commits
// that copy when the callback succeeds — the same all-or-nothing contract as
// a real transaction — so tests can assert that failures leave no trace.
type orderStore struct {
	orders      map[uint]*model.SalesOrder
	inventories map[uint]*model.Inventory
	active      map[uint]bool
	movements   []model.StockMovement
}

func (s *orderStore) clone() *orderStore {
	c := &orderStore{
		orders:      map[uint]*model.SalesOrder{},
		inventories: map[uint]*model.Inventory{},
		active:      map[uint]bool{},
		movements:   append([]model.StockMovement(nil), s.movements...),
	}
	for id, o := range s.orders {
		cp := *o
		cp.Items = append([]model.SalesOrderItem(nil), o.Items...)
		c.orders[id] = &cp
	}
	for id, inv := range s.inventories {
		cp := *inv
		c.inventories[id] = &cp
	}
	for id, a := range s.active {
		c.active[id] = a
	}
	return c
}

// mockSalesOrderRepo: testify mock for the plain queries, orderStore for
// transactions and FindByID.
type mockSalesOrderRepo struct {
	mock.Mock
	store *orderStore
	// failMovementN makes the Nth CreateMovement call inside a transaction
	// fail (0 = never), to simulate a write error half way through.
	failMovementN int
	txCalls       int
}

func (m *mockSalesOrderRepo) Create(ctx context.Context, o *model.SalesOrder, day string) error {
	return m.Called(ctx, o, day).Error(0)
}

func (m *mockSalesOrderRepo) FindByID(_ context.Context, id uint) (*model.SalesOrder, error) {
	o, ok := m.store.orders[id]
	if !ok {
		return nil, fmt.Errorf("find sales order %d: %w", id, repository.ErrNotFound)
	}
	cp := *o
	return &cp, nil
}

func (m *mockSalesOrderRepo) List(ctx context.Context, params model.ListSalesOrdersParams) ([]model.SalesOrder, int64, error) {
	args := m.Called(ctx, params)
	orders, _ := args.Get(0).([]model.SalesOrder)
	return orders, args.Get(1).(int64), args.Error(2)
}

func (m *mockSalesOrderRepo) FindActiveProducts(ctx context.Context, ids []uint) (map[uint]model.Product, error) {
	args := m.Called(ctx, ids)
	products, _ := args.Get(0).(map[uint]model.Product)
	return products, args.Error(1)
}

func (m *mockSalesOrderRepo) InTx(_ context.Context, fn func(tx repository.SalesOrderTx) error) error {
	m.txCalls++
	work := m.store.clone()
	if err := fn(&fakeOrderTx{s: work, failMovementN: m.failMovementN}); err != nil {
		return err // rollback: work is discarded
	}
	*m.store = *work // commit
	return nil
}

type fakeOrderTx struct {
	s             *orderStore
	failMovementN int
	movementCalls int
}

func (t *fakeOrderTx) LockOrder(id uint) (*model.SalesOrder, error) {
	o, ok := t.s.orders[id]
	if !ok {
		return nil, fmt.Errorf("lock sales order %d: %w", id, repository.ErrNotFound)
	}
	return o, nil
}

func (t *fakeOrderTx) LockInventories(ids []uint, threshold int64) (map[uint]*model.Inventory, error) {
	out := map[uint]*model.Inventory{}
	for _, id := range ids {
		if _, ok := t.s.inventories[id]; !ok {
			t.s.inventories[id] = &model.Inventory{ProductID: id, LowStockThreshold: threshold}
		}
		out[id] = t.s.inventories[id]
	}
	return out, nil
}

func (t *fakeOrderTx) ActiveProductIDs(ids []uint) (map[uint]bool, error) {
	out := map[uint]bool{}
	for _, id := range ids {
		out[id] = t.s.active[id]
	}
	return out, nil
}

func (t *fakeOrderTx) SaveInventory(inv *model.Inventory) error {
	t.s.inventories[inv.ProductID] = inv
	return nil
}

func (t *fakeOrderTx) CreateMovement(mv *model.StockMovement) error {
	t.movementCalls++
	if t.movementCalls == t.failMovementN {
		return errDB
	}
	t.s.movements = append(t.s.movements, *mv)
	return nil
}

func (t *fakeOrderTx) SaveOrderStatus(o *model.SalesOrder) error {
	t.s.orders[o.ID] = o
	return nil
}

// --- fixtures ---------------------------------------------------------------

var jakarta = func() *time.Location {
	loc, err := time.LoadLocation("Asia/Jakarta")
	if err != nil {
		panic(err)
	}
	return loc
}()

// 2026-09-19 20:00 UTC is already 2026-09-20 03:00 in Jakarta.
var fixedNow = time.Date(2026, 9, 19, 20, 0, 0, 0, time.UTC)

func newTestOrderService(repo *mockSalesOrderRepo, customers *mockCustomerRepo) *salesOrderService {
	svc := NewSalesOrderService(repo, customers, 10, jakarta).(*salesOrderService)
	svc.now = func() time.Time { return fixedNow }
	return svc
}

// Order 1 (status given): product 10 × 3 and product 20 × 5; both products
// active with the given stock.
func storeWithOrder(status model.OrderStatus, stock10, stock20 int64) *orderStore {
	return &orderStore{
		orders: map[uint]*model.SalesOrder{1: {
			ID: 1, OrderNumber: "SO-20260920-0001", CustomerID: 7, Status: status, TotalAmount: 185000,
			Items: []model.SalesOrderItem{
				{ID: 1, SalesOrderID: 1, ProductID: 10, ProductSKU: "KOPI-1", Quantity: 3, UnitPrice: 45000, Subtotal: 135000},
				{ID: 2, SalesOrderID: 1, ProductID: 20, ProductSKU: "TEH-1", Quantity: 5, UnitPrice: 10000, Subtotal: 50000},
			},
		}},
		inventories: map[uint]*model.Inventory{
			10: {ProductID: 10, Quantity: stock10, LowStockThreshold: 5},
			20: {ProductID: 20, Quantity: stock20, LowStockThreshold: 5},
		},
		active: map[uint]bool{10: true, 20: true},
	}
}

func stockOf(s *orderStore, productID uint) int64 {
	if inv, ok := s.inventories[productID]; ok {
		return inv.Quantity
	}
	return 0
}

// --- Create -----------------------------------------------------------------

func TestSalesOrderService_Create(t *testing.T) {
	customer := &model.Customer{ID: 7, Name: "Budi"}
	products := map[uint]model.Product{
		10: {ID: 10, SKU: "KOPI-1", Name: "Kopi", Price: 45000},
		20: {ID: 20, SKU: "TEH-1", Name: "Teh", Price: 10000},
	}

	t.Run("snapshots prices, computes totals, starts PENDING, numbers by Jakarta date", func(t *testing.T) {
		repo, customers := &mockSalesOrderRepo{store: &orderStore{}}, &mockCustomerRepo{}
		customers.On("FindByID", mock.Anything, uint(7)).Return(customer, nil)
		repo.On("FindActiveProducts", mock.Anything, []uint{10, 20}).Return(products, nil)
		repo.On("Create", mock.Anything, mock.Anything, "20260920").Run(func(args mock.Arguments) {
			o := args.Get(1).(*model.SalesOrder)
			o.ID, o.OrderNumber = 1, model.FormatOrderNumber("20260920", 1)
		}).Return(nil)
		svc := newTestOrderService(repo, customers)

		o, err := svc.Create(context.Background(), model.CreateSalesOrderInput{
			CustomerID: 7,
			Notes:      "  kirim sore ",
			Items:      []model.CreateOrderItemInput{{ProductID: 10, Quantity: 3}, {ProductID: 20, Quantity: 5}},
		})

		require.NoError(t, err)
		assert.Equal(t, "SO-20260920-0001", o.OrderNumber)
		assert.Equal(t, model.OrderPending, o.Status)
		assert.Equal(t, "kirim sore", o.Notes)
		assert.Equal(t, int64(3*45000+5*10000), o.TotalAmount)
		require.Len(t, o.Items, 2)
		assert.Equal(t, model.SalesOrderItem{
			ProductID: 10, ProductSKU: "KOPI-1", ProductName: "Kopi", Quantity: 3, UnitPrice: 45000, Subtotal: 135000,
		}, o.Items[0])
		assert.Equal(t, customer, o.Customer)
		assert.Zero(t, repo.txCalls, "creating an order must not touch stock")
		repo.AssertExpectations(t)
	})

	tests := []struct {
		name        string
		input       model.CreateSalesOrderInput
		setup       func(r *mockSalesOrderRepo, c *mockCustomerRepo)
		wantInvalid []string
	}{
		{
			name:        "customer and items are required",
			input:       model.CreateSalesOrderInput{},
			wantInvalid: []string{"customer_id", "items"},
		},
		{
			name: "item rules: product required, no duplicates, positive quantity within the cap",
			input: model.CreateSalesOrderInput{CustomerID: 7, Items: []model.CreateOrderItemInput{
				{ProductID: 0, Quantity: 1},
				{ProductID: 10, Quantity: 0},
				{ProductID: 10, Quantity: 2},
				{ProductID: 20, Quantity: maxItemQuantity + 1},
			}},
			wantInvalid: []string{"items[0].product_id", "items[1].quantity", "items[2].product_id", "items[3].quantity"},
		},
		{
			name:  "unknown customer",
			input: model.CreateSalesOrderInput{CustomerID: 99, Items: []model.CreateOrderItemInput{{ProductID: 10, Quantity: 1}}},
			setup: func(_ *mockSalesOrderRepo, c *mockCustomerRepo) {
				c.On("FindByID", mock.Anything, uint(99)).Return(nil, repository.ErrNotFound)
			},
			wantInvalid: []string{"customer_id"},
		},
		{
			name: "unknown or soft-deleted product",
			input: model.CreateSalesOrderInput{CustomerID: 7, Items: []model.CreateOrderItemInput{
				{ProductID: 10, Quantity: 1}, {ProductID: 30, Quantity: 1},
			}},
			setup: func(r *mockSalesOrderRepo, c *mockCustomerRepo) {
				c.On("FindByID", mock.Anything, uint(7)).Return(customer, nil)
				r.On("FindActiveProducts", mock.Anything, []uint{10, 30}).Return(products, nil)
			},
			wantInvalid: []string{"items[1].product_id"},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo, customers := &mockSalesOrderRepo{store: &orderStore{}}, &mockCustomerRepo{}
			if tt.setup != nil {
				tt.setup(repo, customers)
			}
			svc := newTestOrderService(repo, customers)

			_, err := svc.Create(context.Background(), tt.input)

			assert.ElementsMatch(t, tt.wantInvalid, validationFields(t, err))
			repo.AssertNotCalled(t, "Create", mock.Anything, mock.Anything, mock.Anything)
			repo.AssertExpectations(t)
			customers.AssertExpectations(t)
		})
	}
}

// --- state machine ----------------------------------------------------------

func TestSalesOrderService_StateMachine(t *testing.T) {
	all := []model.OrderStatus{model.OrderPending, model.OrderConfirmed, model.OrderShipped, model.OrderCancelled}
	allowed := map[[2]model.OrderStatus]bool{
		{model.OrderPending, model.OrderConfirmed}:   true,
		{model.OrderPending, model.OrderCancelled}:   true,
		{model.OrderConfirmed, model.OrderShipped}:   true,
		{model.OrderConfirmed, model.OrderCancelled}: true,
	}

	for _, from := range all {
		for _, to := range all {
			t.Run(fmt.Sprintf("%s to %s", from, to), func(t *testing.T) {
				repo := &mockSalesOrderRepo{store: storeWithOrder(from, 100, 100)}
				svc := newTestOrderService(repo, &mockCustomerRepo{})

				got, err := svc.ChangeStatus(context.Background(), 1, model.UpdateOrderStatusInput{Status: string(to)})

				if allowed[[2]model.OrderStatus{from, to}] {
					require.NoError(t, err)
					assert.Equal(t, to, got.Status)
					return
				}
				assert.Equal(t, []string{"status"}, validationFields(t, err))
				assert.Equal(t, from, repo.store.orders[1].Status, "rejected transition must not change the order")
				assert.Empty(t, repo.store.movements)
			})
		}
	}
}

func TestSalesOrderService_ChangeStatus(t *testing.T) {
	ctx := context.Background()
	status := func(s model.OrderStatus) model.UpdateOrderStatusInput {
		return model.UpdateOrderStatusInput{Status: string(s)}
	}

	t.Run("CONFIRMED with enough stock deducts every item with linked OUT movements", func(t *testing.T) {
		repo := &mockSalesOrderRepo{store: storeWithOrder(model.OrderPending, 10, 5)}
		svc := newTestOrderService(repo, &mockCustomerRepo{})

		got, err := svc.ChangeStatus(ctx, 1, status(model.OrderConfirmed))

		require.NoError(t, err)
		assert.Equal(t, model.OrderConfirmed, got.Status)
		assert.Equal(t, fixedNow, *got.ConfirmedAt)
		assert.Equal(t, int64(7), stockOf(repo.store, 10))
		assert.Equal(t, int64(0), stockOf(repo.store, 20), "exactly the available stock may be used")
		require.Len(t, repo.store.movements, 2)
		for _, mv := range repo.store.movements {
			assert.Equal(t, model.MovementOut, mv.Type)
			require.NotNil(t, mv.SalesOrderID)
			assert.Equal(t, uint(1), *mv.SalesOrderID)
			assert.Contains(t, mv.Reason, "SO-20260920-0001")
		}
		assert.Equal(t, int64(10), repo.store.movements[0].QuantityBefore)
		assert.Equal(t, int64(7), repo.store.movements[0].QuantityAfter)
	})

	t.Run("CONFIRMED with one item short fails whole transition, reporting that item", func(t *testing.T) {
		repo := &mockSalesOrderRepo{store: storeWithOrder(model.OrderPending, 10, 4)}
		svc := newTestOrderService(repo, &mockCustomerRepo{})

		_, err := svc.ChangeStatus(ctx, 1, status(model.OrderConfirmed))

		var verr *ValidationError
		require.ErrorAs(t, err, &verr)
		require.Len(t, verr.Fields, 1)
		assert.Equal(t, "items[1].quantity", verr.Fields[0].Field)
		assert.Equal(t, "insufficient stock for product 20 (TEH-1): 4 available, 5 requested", verr.Fields[0].Message)
		// Nothing changed, not even the item that had enough stock.
		assert.Equal(t, int64(10), stockOf(repo.store, 10))
		assert.Equal(t, int64(4), stockOf(repo.store, 20))
		assert.Equal(t, model.OrderPending, repo.store.orders[1].Status)
		assert.Empty(t, repo.store.movements)
	})

	t.Run("CONFIRMED reports every short item at once", func(t *testing.T) {
		repo := &mockSalesOrderRepo{store: storeWithOrder(model.OrderPending, 1, 0)}
		svc := newTestOrderService(repo, &mockCustomerRepo{})

		_, err := svc.ChangeStatus(ctx, 1, status(model.OrderConfirmed))

		assert.ElementsMatch(t, []string{"items[0].quantity", "items[1].quantity"}, validationFields(t, err))
	})

	t.Run("CONFIRMED for a product without an inventory row counts it as 0 stock", func(t *testing.T) {
		store := storeWithOrder(model.OrderPending, 10, 10)
		delete(store.inventories, 20)
		repo := &mockSalesOrderRepo{store: store}
		svc := newTestOrderService(repo, &mockCustomerRepo{})

		_, err := svc.ChangeStatus(ctx, 1, status(model.OrderConfirmed))

		assert.Equal(t, []string{"items[1].quantity"}, validationFields(t, err))
		_, created := store.inventories[20]
		assert.False(t, created, "the rolled back transaction must not leave a new inventory row")
	})

	t.Run("CONFIRMED is rejected when a product was soft-deleted after ordering", func(t *testing.T) {
		store := storeWithOrder(model.OrderPending, 10, 10)
		store.active[10] = false
		repo := &mockSalesOrderRepo{store: store}
		svc := newTestOrderService(repo, &mockCustomerRepo{})

		_, err := svc.ChangeStatus(ctx, 1, status(model.OrderConfirmed))

		assert.Equal(t, []string{"items[0].product_id"}, validationFields(t, err))
		assert.Equal(t, int64(10), stockOf(store, 20))
	})

	t.Run("CONFIRMED rolls back fully when a write fails half way", func(t *testing.T) {
		repo := &mockSalesOrderRepo{store: storeWithOrder(model.OrderPending, 10, 10), failMovementN: 2}
		svc := newTestOrderService(repo, &mockCustomerRepo{})

		_, err := svc.ChangeStatus(ctx, 1, status(model.OrderConfirmed))

		assert.ErrorIs(t, err, errDB)
		assert.Equal(t, int64(10), stockOf(repo.store, 10), "first item's deduction must be rolled back too")
		assert.Equal(t, int64(10), stockOf(repo.store, 20))
		assert.Empty(t, repo.store.movements)
		assert.Equal(t, model.OrderPending, repo.store.orders[1].Status)
	})

	t.Run("CANCELLED from CONFIRMED returns the stock with linked IN movements", func(t *testing.T) {
		repo := &mockSalesOrderRepo{store: storeWithOrder(model.OrderPending, 10, 5)}
		svc := newTestOrderService(repo, &mockCustomerRepo{})
		_, err := svc.ChangeStatus(ctx, 1, status(model.OrderConfirmed))
		require.NoError(t, err)

		got, err := svc.ChangeStatus(ctx, 1, status(model.OrderCancelled))

		require.NoError(t, err)
		assert.Equal(t, model.OrderCancelled, got.Status)
		assert.NotNil(t, got.CancelledAt)
		assert.Equal(t, int64(10), stockOf(repo.store, 10))
		assert.Equal(t, int64(5), stockOf(repo.store, 20))
		require.Len(t, repo.store.movements, 4)
		for _, mv := range repo.store.movements[2:] {
			assert.Equal(t, model.MovementIn, mv.Type)
			assert.Contains(t, mv.Reason, "cancelled")
		}
	})

	t.Run("CANCELLED from CONFIRMED returns stock even for a product deleted meanwhile", func(t *testing.T) {
		store := storeWithOrder(model.OrderConfirmed, 7, 0)
		store.active[20] = false
		repo := &mockSalesOrderRepo{store: store}
		svc := newTestOrderService(repo, &mockCustomerRepo{})

		_, err := svc.ChangeStatus(ctx, 1, status(model.OrderCancelled))

		require.NoError(t, err)
		assert.Equal(t, int64(5), stockOf(store, 20))
	})

	t.Run("CANCELLED from PENDING leaves stock alone", func(t *testing.T) {
		repo := &mockSalesOrderRepo{store: storeWithOrder(model.OrderPending, 10, 5)}
		svc := newTestOrderService(repo, &mockCustomerRepo{})

		_, err := svc.ChangeStatus(ctx, 1, status(model.OrderCancelled))

		require.NoError(t, err)
		assert.Equal(t, int64(10), stockOf(repo.store, 10))
		assert.Empty(t, repo.store.movements)
	})

	t.Run("SHIPPED leaves stock alone and sets shipped_at", func(t *testing.T) {
		repo := &mockSalesOrderRepo{store: storeWithOrder(model.OrderConfirmed, 7, 0)}
		svc := newTestOrderService(repo, &mockCustomerRepo{})

		got, err := svc.ChangeStatus(ctx, 1, status(model.OrderShipped))

		require.NoError(t, err)
		assert.NotNil(t, got.ShippedAt)
		assert.Equal(t, int64(7), stockOf(repo.store, 10))
		assert.Empty(t, repo.store.movements)
	})

	t.Run("status is case-insensitive", func(t *testing.T) {
		repo := &mockSalesOrderRepo{store: storeWithOrder(model.OrderPending, 10, 10)}
		svc := newTestOrderService(repo, &mockCustomerRepo{})

		got, err := svc.ChangeStatus(ctx, 1, model.UpdateOrderStatusInput{Status: " cancelled "})

		require.NoError(t, err)
		assert.Equal(t, model.OrderCancelled, got.Status)
	})

	t.Run("unknown status is rejected without a transaction", func(t *testing.T) {
		repo := &mockSalesOrderRepo{store: storeWithOrder(model.OrderPending, 10, 10)}
		svc := newTestOrderService(repo, &mockCustomerRepo{})

		_, err := svc.ChangeStatus(ctx, 1, model.UpdateOrderStatusInput{Status: "DELIVERED"})

		assert.Equal(t, []string{"status"}, validationFields(t, err))
		assert.Zero(t, repo.txCalls)
	})

	t.Run("order not found", func(t *testing.T) {
		repo := &mockSalesOrderRepo{store: &orderStore{orders: map[uint]*model.SalesOrder{}}}
		svc := newTestOrderService(repo, &mockCustomerRepo{})

		_, err := svc.ChangeStatus(ctx, 42, status(model.OrderConfirmed))

		assert.ErrorIs(t, err, ErrNotFound)
	})
}

func TestSalesOrderService_List(t *testing.T) {
	t.Run("normalizes pagination and status filter", func(t *testing.T) {
		repo := &mockSalesOrderRepo{store: &orderStore{}}
		want := model.ListSalesOrdersParams{Page: 1, PageSize: DefaultPageSize, Status: model.OrderConfirmed, CustomerID: 7}
		repo.On("List", mock.Anything, want).Return([]model.SalesOrder{{ID: 1}}, int64(1), nil)
		svc := newTestOrderService(repo, &mockCustomerRepo{})

		_, _, used, err := svc.List(context.Background(), model.ListSalesOrdersParams{Status: "confirmed", CustomerID: 7})

		require.NoError(t, err)
		assert.Equal(t, want, used)
	})

	t.Run("unknown status filter", func(t *testing.T) {
		repo := &mockSalesOrderRepo{store: &orderStore{}}
		svc := newTestOrderService(repo, &mockCustomerRepo{})

		_, _, _, err := svc.List(context.Background(), model.ListSalesOrdersParams{Status: "LOST"})

		assert.Equal(t, []string{"status"}, validationFields(t, err))
	})
}
