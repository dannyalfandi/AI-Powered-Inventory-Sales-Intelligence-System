package service

import (
	"context"
	"fmt"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

const testDefaultThreshold = int64(10)

type mockInventoryRepo struct {
	mock.Mock
}

func (m *mockInventoryRepo) FindByProductID(ctx context.Context, productID uint) (*model.Inventory, error) {
	args := m.Called(ctx, productID)
	inv, _ := args.Get(0).(*model.Inventory)
	return inv, args.Error(1)
}

// Mutate behaves like the real repository: it hands the locked row
// (args[0]) to fn and returns fn's error wrapped, or the row and movement.
func (m *mockInventoryRepo) Mutate(ctx context.Context, productID uint, defaultThreshold int64, fn repository.InventoryMutation) (*model.Inventory, *model.StockMovement, error) {
	args := m.Called(ctx, productID, defaultThreshold)
	if err := args.Error(1); err != nil {
		return nil, nil, err
	}
	inv := args.Get(0).(*model.Inventory)
	mv, err := fn(inv)
	if err != nil {
		return nil, nil, fmt.Errorf("update inventory of product %d: %w", productID, err)
	}
	if mv != nil {
		mv.ProductID = productID
	}
	return inv, mv, nil
}

func (m *mockInventoryRepo) ListMovements(ctx context.Context, productID uint, params model.ListMovementsParams) ([]model.StockMovement, int64, error) {
	args := m.Called(ctx, productID, params)
	movements, _ := args.Get(0).([]model.StockMovement)
	return movements, args.Get(1).(int64), args.Error(2)
}

func (m *mockInventoryRepo) ListLowStock(ctx context.Context, defaultThreshold int64, params model.ListLowStockParams) ([]model.LowStockItem, int64, error) {
	args := m.Called(ctx, defaultThreshold, params)
	items, _ := args.Get(0).([]model.LowStockItem)
	return items, args.Get(1).(int64), args.Error(2)
}

func newInventoryService(inv *mockInventoryRepo, products *mockProductRepo) InventoryService {
	return NewInventoryService(inv, products, testDefaultThreshold)
}

func TestInventoryService_RecordMovement(t *testing.T) {
	stock := func(qty int64) *model.Inventory {
		return &model.Inventory{ProductID: 1, Quantity: qty, LowStockThreshold: 5}
	}

	tests := []struct {
		name        string
		input       model.CreateStockMovementInput
		current     *model.Inventory // locked row handed to the mutation; nil = Mutate not called
		repoErr     error
		wantQty     int64
		wantBefore  int64
		wantLow     bool
		wantErr     error
		wantInvalid []string
	}{
		{
			name:       "IN adds to stock",
			input:      model.CreateStockMovementInput{Type: "IN", Quantity: ptr(int64(5)), Reason: " restock "},
			current:    stock(10),
			wantQty:    15,
			wantBefore: 10,
		},
		{
			name:       "OUT subtracts from stock",
			input:      model.CreateStockMovementInput{Type: "OUT", Quantity: ptr(int64(4))},
			current:    stock(10),
			wantQty:    6,
			wantBefore: 10,
		},
		{
			name:       "OUT may empty the stock exactly",
			input:      model.CreateStockMovementInput{Type: "OUT", Quantity: ptr(int64(10))},
			current:    stock(10),
			wantQty:    0,
			wantBefore: 10,
			wantLow:    true,
		},
		{
			name:        "OUT larger than stock is rejected",
			input:       model.CreateStockMovementInput{Type: "OUT", Quantity: ptr(int64(11))},
			current:     stock(10),
			wantInvalid: []string{"quantity"},
		},
		{
			name:        "OUT on a product without stock is rejected",
			input:       model.CreateStockMovementInput{Type: "OUT", Quantity: ptr(int64(1))},
			current:     stock(0),
			wantInvalid: []string{"quantity"},
		},
		{
			name:       "ADJUSTMENT sets the stock level",
			input:      model.CreateStockMovementInput{Type: "ADJUSTMENT", Quantity: ptr(int64(3)), Reason: "stock opname"},
			current:    stock(10),
			wantQty:    3,
			wantBefore: 10,
			wantLow:    true,
		},
		{
			name:       "ADJUSTMENT to zero is allowed",
			input:      model.CreateStockMovementInput{Type: "ADJUSTMENT", Quantity: ptr(int64(0))},
			current:    stock(7),
			wantQty:    0,
			wantBefore: 7,
			wantLow:    true,
		},
		{
			name:       "type is case-insensitive",
			input:      model.CreateStockMovementInput{Type: " in ", Quantity: ptr(int64(1))},
			current:    stock(0),
			wantQty:    1,
			wantBefore: 0,
			wantLow:    true,
		},
		{
			name:        "unknown type",
			input:       model.CreateStockMovementInput{Type: "TRANSFER", Quantity: ptr(int64(1))},
			wantInvalid: []string{"type"},
		},
		{
			name:        "missing type and quantity",
			input:       model.CreateStockMovementInput{},
			wantInvalid: []string{"type", "quantity"},
		},
		{
			name:        "negative quantity",
			input:       model.CreateStockMovementInput{Type: "ADJUSTMENT", Quantity: ptr(int64(-1))},
			wantInvalid: []string{"quantity"},
		},
		{
			name:        "zero IN is rejected",
			input:       model.CreateStockMovementInput{Type: "IN", Quantity: ptr(int64(0))},
			wantInvalid: []string{"quantity"},
		},
		{
			name:        "quantity above the cap",
			input:       model.CreateStockMovementInput{Type: "IN", Quantity: ptr(int64(maxMovementQuantity + 1))},
			wantInvalid: []string{"quantity"},
		},
		{
			name:        "reason too long",
			input:       model.CreateStockMovementInput{Type: "IN", Quantity: ptr(int64(1)), Reason: strings.Repeat("x", maxReasonLength+1)},
			wantInvalid: []string{"reason"},
		},
		{
			name:    "product not found",
			input:   model.CreateStockMovementInput{Type: "IN", Quantity: ptr(int64(1))},
			repoErr: fmt.Errorf("update inventory of product 1: %w", repository.ErrNotFound),
			wantErr: ErrNotFound,
		},
		{
			name:    "repository failure",
			input:   model.CreateStockMovementInput{Type: "IN", Quantity: ptr(int64(1))},
			repoErr: errDB,
			wantErr: errDB,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo, products := &mockInventoryRepo{}, &mockProductRepo{}
			switch {
			case tt.repoErr != nil:
				repo.On("Mutate", mock.Anything, uint(1), testDefaultThreshold).Return(nil, tt.repoErr)
			case tt.current != nil:
				repo.On("Mutate", mock.Anything, uint(1), testDefaultThreshold).Return(tt.current, nil)
			}
			svc := newInventoryService(repo, products)

			mv, inv, err := svc.RecordMovement(context.Background(), 1, tt.input)

			switch {
			case tt.wantInvalid != nil:
				assert.ElementsMatch(t, tt.wantInvalid, validationFields(t, err))
				assert.Nil(t, mv)
				assert.Nil(t, inv)
				if tt.current == nil {
					repo.AssertNotCalled(t, "Mutate", mock.Anything, mock.Anything, mock.Anything)
				}
			case tt.wantErr != nil:
				assert.ErrorIs(t, err, tt.wantErr)
				assert.Nil(t, mv)
			default:
				require.NoError(t, err)
				assert.Equal(t, tt.wantQty, inv.Quantity)
				assert.Equal(t, tt.wantLow, inv.IsLowStock)
				assert.Equal(t, uint(1), mv.ProductID)
				assert.Equal(t, strings.ToUpper(strings.TrimSpace(tt.input.Type)), string(mv.Type))
				assert.Equal(t, *tt.input.Quantity, mv.Quantity)
				assert.Equal(t, tt.wantBefore, mv.QuantityBefore)
				assert.Equal(t, tt.wantQty, mv.QuantityAfter)
				assert.Equal(t, strings.TrimSpace(tt.input.Reason), mv.Reason)
			}
			repo.AssertExpectations(t)
		})
	}
}

func TestInventoryService_Get(t *testing.T) {
	product := &model.Product{ID: 1, SKU: "SKU-1", Name: "Kopi"}

	tests := []struct {
		name  string
		setup func(r *mockInventoryRepo, p *mockProductRepo)
		want  *model.Inventory
		// wantErr is checked with errors.Is.
		wantErr error
	}{
		{
			name: "existing row",
			setup: func(r *mockInventoryRepo, p *mockProductRepo) {
				p.On("FindByID", mock.Anything, uint(1)).Return(product, nil)
				r.On("FindByProductID", mock.Anything, uint(1)).
					Return(&model.Inventory{ProductID: 1, Quantity: 50, LowStockThreshold: 20}, nil)
			},
			want: &model.Inventory{ProductID: 1, Quantity: 50, LowStockThreshold: 20, IsLowStock: false},
		},
		{
			name: "no row yet: zero stock with the default threshold",
			setup: func(r *mockInventoryRepo, p *mockProductRepo) {
				p.On("FindByID", mock.Anything, uint(1)).Return(product, nil)
				r.On("FindByProductID", mock.Anything, uint(1)).Return(nil, repository.ErrNotFound)
			},
			want: &model.Inventory{ProductID: 1, Quantity: 0, LowStockThreshold: testDefaultThreshold, IsLowStock: true},
		},
		{
			name: "quantity equal to threshold is low stock",
			setup: func(r *mockInventoryRepo, p *mockProductRepo) {
				p.On("FindByID", mock.Anything, uint(1)).Return(product, nil)
				r.On("FindByProductID", mock.Anything, uint(1)).
					Return(&model.Inventory{ProductID: 1, Quantity: 5, LowStockThreshold: 5}, nil)
			},
			want: &model.Inventory{ProductID: 1, Quantity: 5, LowStockThreshold: 5, IsLowStock: true},
		},
		{
			name: "product not found",
			setup: func(_ *mockInventoryRepo, p *mockProductRepo) {
				p.On("FindByID", mock.Anything, uint(1)).Return(nil, repository.ErrNotFound)
			},
			wantErr: ErrNotFound,
		},
		{
			name: "inventory lookup failure",
			setup: func(r *mockInventoryRepo, p *mockProductRepo) {
				p.On("FindByID", mock.Anything, uint(1)).Return(product, nil)
				r.On("FindByProductID", mock.Anything, uint(1)).Return(nil, errDB)
			},
			wantErr: errDB,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo, products := &mockInventoryRepo{}, &mockProductRepo{}
			tt.setup(repo, products)
			svc := newInventoryService(repo, products)

			got, err := svc.Get(context.Background(), 1)

			if tt.wantErr != nil {
				assert.ErrorIs(t, err, tt.wantErr)
				assert.Nil(t, got)
			} else {
				require.NoError(t, err)
				assert.Equal(t, tt.want, got)
			}
			repo.AssertExpectations(t)
			products.AssertExpectations(t)
		})
	}
}

func TestInventoryService_Update(t *testing.T) {
	tests := []struct {
		name        string
		input       model.UpdateInventoryInput
		current     *model.Inventory
		repoErr     error
		want        *model.Inventory
		wantErr     error
		wantInvalid []string
	}{
		{
			name:    "threshold changed and low-stock flag recomputed",
			input:   model.UpdateInventoryInput{LowStockThreshold: ptr(int64(30))},
			current: &model.Inventory{ProductID: 1, Quantity: 25, LowStockThreshold: 10},
			want:    &model.Inventory{ProductID: 1, Quantity: 25, LowStockThreshold: 30, IsLowStock: true},
		},
		{
			name:        "threshold required",
			input:       model.UpdateInventoryInput{},
			wantInvalid: []string{"low_stock_threshold"},
		},
		{
			name:        "negative threshold",
			input:       model.UpdateInventoryInput{LowStockThreshold: ptr(int64(-1))},
			wantInvalid: []string{"low_stock_threshold"},
		},
		{
			name:    "product not found",
			input:   model.UpdateInventoryInput{LowStockThreshold: ptr(int64(3))},
			repoErr: repository.ErrNotFound,
			wantErr: ErrNotFound,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockInventoryRepo{}
			switch {
			case tt.repoErr != nil:
				repo.On("Mutate", mock.Anything, uint(1), testDefaultThreshold).Return(nil, tt.repoErr)
			case tt.current != nil:
				repo.On("Mutate", mock.Anything, uint(1), testDefaultThreshold).Return(tt.current, nil)
			}
			svc := newInventoryService(repo, &mockProductRepo{})

			got, err := svc.Update(context.Background(), 1, tt.input)

			switch {
			case tt.wantInvalid != nil:
				assert.ElementsMatch(t, tt.wantInvalid, validationFields(t, err))
				repo.AssertNotCalled(t, "Mutate", mock.Anything, mock.Anything, mock.Anything)
			case tt.wantErr != nil:
				assert.ErrorIs(t, err, tt.wantErr)
				assert.Nil(t, got)
			default:
				require.NoError(t, err)
				assert.Equal(t, tt.want, got)
			}
			repo.AssertExpectations(t)
		})
	}
}

func TestInventoryService_ListMovements(t *testing.T) {
	movements := []model.StockMovement{{ID: 2, ProductID: 1, Type: model.MovementOut}, {ID: 1, ProductID: 1, Type: model.MovementIn}}

	t.Run("pagination normalized", func(t *testing.T) {
		repo, products := &mockInventoryRepo{}, &mockProductRepo{}
		products.On("FindByID", mock.Anything, uint(1)).Return(&model.Product{ID: 1}, nil)
		want := model.ListMovementsParams{Page: 1, PageSize: MaxPageSize}
		repo.On("ListMovements", mock.Anything, uint(1), want).Return(movements, int64(2), nil)
		svc := newInventoryService(repo, products)

		got, total, used, err := svc.ListMovements(context.Background(), 1, model.ListMovementsParams{Page: -3, PageSize: 999})

		require.NoError(t, err)
		assert.Equal(t, want, used)
		assert.Equal(t, movements, got)
		assert.Equal(t, int64(2), total)
		repo.AssertExpectations(t)
	})

	t.Run("product not found", func(t *testing.T) {
		repo, products := &mockInventoryRepo{}, &mockProductRepo{}
		products.On("FindByID", mock.Anything, uint(1)).Return(nil, repository.ErrNotFound)
		svc := newInventoryService(repo, products)

		_, _, _, err := svc.ListMovements(context.Background(), 1, model.ListMovementsParams{})

		assert.ErrorIs(t, err, ErrNotFound)
		repo.AssertNotCalled(t, "ListMovements", mock.Anything, mock.Anything, mock.Anything)
	})
}

func TestInventoryService_ListLowStock(t *testing.T) {
	items := []model.LowStockItem{{ProductID: 3, SKU: "SKU-3", Quantity: 0, LowStockThreshold: 10}}

	tests := []struct {
		name    string
		repoErr error
	}{
		{name: "uses the default threshold"},
		{name: "repository failure", repoErr: errDB},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockInventoryRepo{}
			want := model.ListLowStockParams{Page: 1, PageSize: DefaultPageSize}
			if tt.repoErr != nil {
				repo.On("ListLowStock", mock.Anything, testDefaultThreshold, want).Return(nil, int64(0), tt.repoErr)
			} else {
				repo.On("ListLowStock", mock.Anything, testDefaultThreshold, want).Return(items, int64(1), nil)
			}
			svc := newInventoryService(repo, &mockProductRepo{})

			got, total, used, err := svc.ListLowStock(context.Background(), model.ListLowStockParams{})

			assert.Equal(t, want, used)
			if tt.repoErr != nil {
				assert.ErrorIs(t, err, tt.repoErr)
			} else {
				require.NoError(t, err)
				assert.Equal(t, items, got)
				assert.Equal(t, int64(1), total)
			}
			repo.AssertExpectations(t)
		})
	}
}
