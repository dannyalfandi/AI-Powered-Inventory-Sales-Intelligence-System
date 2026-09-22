package service

import (
	"context"
	"errors"
	"fmt"
	"strings"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

const (
	// maxMovementQuantity caps a single movement so balances can't overflow.
	maxMovementQuantity = 1_000_000_000
	maxReasonLength     = 500
)

type InventoryService interface {
	Get(ctx context.Context, productID uint) (*model.Inventory, error)
	Update(ctx context.Context, productID uint, in model.UpdateInventoryInput) (*model.Inventory, error)
	// RecordMovement applies a stock movement and logs it atomically.
	RecordMovement(ctx context.Context, productID uint, in model.CreateStockMovementInput) (*model.StockMovement, *model.Inventory, error)
	ListMovements(ctx context.Context, productID uint, params model.ListMovementsParams) ([]model.StockMovement, int64, model.ListMovementsParams, error)
	ListLowStock(ctx context.Context, params model.ListLowStockParams) ([]model.LowStockItem, int64, model.ListLowStockParams, error)
}

type inventoryService struct {
	repo             repository.InventoryRepository
	products         repository.ProductRepository
	defaultThreshold int64
}

// NewInventoryService creates the service. defaultThreshold is the
// low-stock threshold for products whose inventory row doesn't exist yet.
func NewInventoryService(repo repository.InventoryRepository, products repository.ProductRepository, defaultThreshold int64) InventoryService {
	return &inventoryService{repo: repo, products: products, defaultThreshold: defaultThreshold}
}

func (s *inventoryService) Get(ctx context.Context, productID uint) (*model.Inventory, error) {
	// Checked first so soft-deleted products are reported as not found.
	if _, err := s.products.FindByID(ctx, productID); err != nil {
		return nil, mapRepoError(ctx, err, i18n.KeyEntityProduct, productID)
	}

	inv, err := s.repo.FindByProductID(ctx, productID)
	switch {
	case errors.Is(err, repository.ErrNotFound):
		inv = &model.Inventory{ProductID: productID, LowStockThreshold: s.defaultThreshold}
	case err != nil:
		return nil, fmt.Errorf("inventory of product %d: %w", productID, err)
	}
	setLowStock(inv)
	return inv, nil
}

func (s *inventoryService) Update(ctx context.Context, productID uint, in model.UpdateInventoryInput) (*model.Inventory, error) {
	v := &ValidationError{}
	switch {
	case in.LowStockThreshold == nil:
		v.add(ctx, "low_stock_threshold", i18n.KeyRequired)
	case *in.LowStockThreshold < 0:
		v.add(ctx, "low_stock_threshold", i18n.KeyNotNegative)
	}
	if err := v.errOrNil(); err != nil {
		return nil, err
	}

	inv, _, err := s.repo.Mutate(ctx, productID, s.defaultThreshold, func(inv *model.Inventory) (*model.StockMovement, error) {
		inv.LowStockThreshold = *in.LowStockThreshold
		return nil, nil
	})
	if err != nil {
		return nil, mapRepoError(ctx, err, i18n.KeyEntityProduct, productID)
	}
	setLowStock(inv)
	return inv, nil
}

func (s *inventoryService) RecordMovement(ctx context.Context, productID uint, in model.CreateStockMovementInput) (*model.StockMovement, *model.Inventory, error) {
	mv, err := newMovement(ctx, in)
	if err != nil {
		return nil, nil, err
	}

	inv, saved, err := s.repo.Mutate(ctx, productID, s.defaultThreshold, func(inv *model.Inventory) (*model.StockMovement, error) {
		if err := applyMovement(ctx, inv, mv); err != nil {
			return nil, err
		}
		return mv, nil
	})
	if err != nil {
		var verr *ValidationError
		if errors.As(err, &verr) {
			return nil, nil, verr
		}
		return nil, nil, mapRepoError(ctx, err, i18n.KeyEntityProduct, productID)
	}
	setLowStock(inv)
	return saved, inv, nil
}

func (s *inventoryService) ListMovements(ctx context.Context, productID uint, params model.ListMovementsParams) ([]model.StockMovement, int64, model.ListMovementsParams, error) {
	params.Page, params.PageSize = normalizePage(params.Page, params.PageSize)
	if _, err := s.products.FindByID(ctx, productID); err != nil {
		return nil, 0, params, mapRepoError(ctx, err, i18n.KeyEntityProduct, productID)
	}

	movements, total, err := s.repo.ListMovements(ctx, productID, params)
	if err != nil {
		return nil, 0, params, fmt.Errorf("list stock movements of product %d: %w", productID, err)
	}
	return movements, total, params, nil
}

func (s *inventoryService) ListLowStock(ctx context.Context, params model.ListLowStockParams) ([]model.LowStockItem, int64, model.ListLowStockParams, error) {
	params.Page, params.PageSize = normalizePage(params.Page, params.PageSize)
	items, total, err := s.repo.ListLowStock(ctx, s.defaultThreshold, params)
	if err != nil {
		return nil, 0, params, fmt.Errorf("list low-stock products: %w", err)
	}
	return items, total, params, nil
}

// newMovement validates the request shape (independent of current stock).
func newMovement(ctx context.Context, in model.CreateStockMovementInput) (*model.StockMovement, error) {
	mv := &model.StockMovement{
		Type:   model.MovementType(strings.ToUpper(strings.TrimSpace(in.Type))),
		Reason: strings.TrimSpace(in.Reason),
	}

	v := &ValidationError{}
	switch mv.Type {
	case model.MovementIn, model.MovementOut, model.MovementAdjustment:
	case "":
		v.add(ctx, "type", i18n.KeyRequired)
	default:
		v.add(ctx, "type", i18n.KeyMovementTypeEnum)
	}

	switch {
	case in.Quantity == nil:
		v.add(ctx, "quantity", i18n.KeyRequired)
	case *in.Quantity < 0:
		v.add(ctx, "quantity", i18n.KeyNotNegative)
	case *in.Quantity == 0 && mv.Type != model.MovementAdjustment:
		v.add(ctx, "quantity", i18n.KeyGreaterThanZero)
	case *in.Quantity > maxMovementQuantity:
		v.add(ctx, "quantity", i18n.KeyMaxValue, maxMovementQuantity)
	default:
		mv.Quantity = *in.Quantity
	}

	if len(mv.Reason) > maxReasonLength {
		v.add(ctx, "reason", i18n.KeyMaxChars, maxReasonLength)
	}
	if err := v.errOrNil(); err != nil {
		return nil, err
	}
	return mv, nil
}

// applyMovement updates inv.Quantity for mv and records the balance on mv.
// Stock never goes negative: an OUT larger than the stock is rejected.
func applyMovement(ctx context.Context, inv *model.Inventory, mv *model.StockMovement) error {
	before := inv.Quantity
	var after int64
	switch mv.Type {
	case model.MovementIn:
		after = before + mv.Quantity
	case model.MovementOut:
		if mv.Quantity > before {
			return fieldError(ctx, "quantity", i18n.KeyInsufficientStock, before, mv.Quantity)
		}
		after = before - mv.Quantity
	case model.MovementAdjustment:
		after = mv.Quantity
	default:
		return fmt.Errorf("unknown movement type %q", mv.Type)
	}

	inv.Quantity = after
	mv.QuantityBefore, mv.QuantityAfter = before, after
	return nil
}

func setLowStock(inv *model.Inventory) {
	inv.IsLowStock = inv.Quantity <= inv.LowStockThreshold
}
