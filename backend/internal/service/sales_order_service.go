package service

import (
	"context"
	"errors"
	"fmt"
	"math"
	"strings"
	"time"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

const (
	maxOrderItems      = 100
	maxItemQuantity    = 1_000_000
	maxOrderNotesChars = 2000
)

// orderTransitions is the sales order state machine: the statuses an order
// may move to from each status. SHIPPED and CANCELLED are final.
//
//	PENDING ──► CONFIRMED ──► SHIPPED
//	   │            │
//	   └──► CANCELLED ◄──┘
//
// Stock effects: → CONFIRMED deducts every item (OUT); CONFIRMED → CANCELLED
// returns it (IN). PENDING → CANCELLED and → SHIPPED don't touch stock.
var orderTransitions = map[model.OrderStatus][]model.OrderStatus{
	model.OrderPending:   {model.OrderConfirmed, model.OrderCancelled},
	model.OrderConfirmed: {model.OrderShipped, model.OrderCancelled},
}

var orderStatuses = []model.OrderStatus{model.OrderPending, model.OrderConfirmed, model.OrderShipped, model.OrderCancelled}

type SalesOrderService interface {
	// Create validates the items, snapshots current product prices and
	// stores the order as PENDING. Stock is not touched.
	Create(ctx context.Context, in model.CreateSalesOrderInput) (*model.SalesOrder, error)
	GetByID(ctx context.Context, id uint) (*model.SalesOrder, error)
	List(ctx context.Context, params model.ListSalesOrdersParams) ([]model.SalesOrder, int64, model.ListSalesOrdersParams, error)
	// ChangeStatus runs one state machine transition and its stock effects in
	// a single transaction: all items succeed or nothing changes.
	ChangeStatus(ctx context.Context, id uint, in model.UpdateOrderStatusInput) (*model.SalesOrder, error)
}

type salesOrderService struct {
	repo             repository.SalesOrderRepository
	customers        repository.CustomerRepository
	defaultThreshold int64
	// loc is the time zone of the date in order numbers (SO-YYYYMMDD-NNNN).
	loc *time.Location
	now func() time.Time
}

func NewSalesOrderService(
	repo repository.SalesOrderRepository,
	customers repository.CustomerRepository,
	defaultThreshold int64,
	loc *time.Location,
) SalesOrderService {
	return &salesOrderService{
		repo:             repo,
		customers:        customers,
		defaultThreshold: defaultThreshold,
		loc:              loc,
		now:              time.Now,
	}
}

func (s *salesOrderService) Create(ctx context.Context, in model.CreateSalesOrderInput) (*model.SalesOrder, error) {
	notes := strings.TrimSpace(in.Notes)
	if err := validateOrderInput(in, notes); err != nil {
		return nil, err
	}

	customer, err := s.customers.FindByID(ctx, in.CustomerID)
	if errors.Is(err, repository.ErrNotFound) {
		return nil, &ValidationError{Fields: []FieldError{{Field: "customer_id", Message: "does not exist"}}}
	}
	if err != nil {
		return nil, fmt.Errorf("customer %d: %w", in.CustomerID, err)
	}

	ids := make([]uint, len(in.Items))
	for i, it := range in.Items {
		ids[i] = it.ProductID
	}
	products, err := s.repo.FindActiveProducts(ctx, ids)
	if err != nil {
		return nil, fmt.Errorf("sales order products: %w", err)
	}

	o := &model.SalesOrder{CustomerID: customer.ID, Status: model.OrderPending, Notes: notes}
	v := &ValidationError{}
	for i, it := range in.Items {
		field := fmt.Sprintf("items[%d]", i)
		p, ok := products[it.ProductID]
		if !ok {
			v.add(field+".product_id", fmt.Sprintf("product %d does not exist", it.ProductID))
			continue
		}
		// Price snapshot: later product price changes don't alter this order.
		if p.Price > 0 && it.Quantity > math.MaxInt64/p.Price {
			v.add(field+".quantity", "subtotal is too large")
			continue
		}
		subtotal := p.Price * it.Quantity
		if o.TotalAmount > math.MaxInt64-subtotal {
			v.add(field+".quantity", "order total is too large")
			continue
		}
		o.TotalAmount += subtotal
		o.Items = append(o.Items, model.SalesOrderItem{
			ProductID:   p.ID,
			ProductSKU:  p.SKU,
			ProductName: p.Name,
			Quantity:    it.Quantity,
			UnitPrice:   p.Price,
			Subtotal:    subtotal,
		})
	}
	if err := v.errOrNil(); err != nil {
		return nil, err
	}

	day := s.now().In(s.loc).Format("20060102")
	if err := s.repo.Create(ctx, o, day); err != nil {
		return nil, mapRepoError(err, "sales order")
	}
	o.Customer = customer
	return o, nil
}

func (s *salesOrderService) GetByID(ctx context.Context, id uint) (*model.SalesOrder, error) {
	o, err := s.repo.FindByID(ctx, id)
	if err != nil {
		return nil, mapRepoError(err, fmt.Sprintf("sales order %d", id))
	}
	return o, nil
}

func (s *salesOrderService) List(ctx context.Context, params model.ListSalesOrdersParams) ([]model.SalesOrder, int64, model.ListSalesOrdersParams, error) {
	params.Page, params.PageSize = normalizePage(params.Page, params.PageSize)
	if params.Status != "" {
		status, ok := parseOrderStatus(string(params.Status))
		if !ok {
			return nil, 0, params, &ValidationError{Fields: []FieldError{{Field: "status", Message: statusEnumMessage()}}}
		}
		params.Status = status
	}
	orders, total, err := s.repo.List(ctx, params)
	if err != nil {
		return nil, 0, params, fmt.Errorf("list sales orders: %w", err)
	}
	return orders, total, params, nil
}

func (s *salesOrderService) ChangeStatus(ctx context.Context, id uint, in model.UpdateOrderStatusInput) (*model.SalesOrder, error) {
	target, ok := parseOrderStatus(in.Status)
	if !ok {
		return nil, &ValidationError{Fields: []FieldError{{Field: "status", Message: statusEnumMessage()}}}
	}

	err := s.repo.InTx(ctx, func(tx repository.SalesOrderTx) error {
		// The order row lock serializes concurrent status changes of one order.
		o, err := tx.LockOrder(id)
		if err != nil {
			return err
		}
		from := o.Status
		if err := checkTransition(from, target); err != nil {
			return err
		}

		now := s.now()
		switch target {
		case model.OrderConfirmed:
			if err := s.deductStock(tx, o); err != nil {
				return err
			}
			o.ConfirmedAt = &now
		case model.OrderShipped:
			o.ShippedAt = &now
		case model.OrderCancelled:
			if from == model.OrderConfirmed {
				if err := s.returnStock(tx, o); err != nil {
					return err
				}
			}
			o.CancelledAt = &now
		}
		o.Status = target
		return tx.SaveOrderStatus(o)
	})
	if err != nil {
		var verr *ValidationError
		if errors.As(err, &verr) {
			return nil, verr
		}
		return nil, mapRepoError(err, fmt.Sprintf("sales order %d", id))
	}
	return s.GetByID(ctx, id)
}

// deductStock takes every item out of stock (one OUT movement each). It
// checks all items first and reports every problem at once; any problem
// fails the whole transition, and the transaction rolls back.
func (s *salesOrderService) deductStock(tx repository.SalesOrderTx, o *model.SalesOrder) error {
	ids := itemProductIDs(o.Items)
	active, err := tx.ActiveProductIDs(ids)
	if err != nil {
		return err
	}
	invs, err := tx.LockInventories(ids, s.defaultThreshold)
	if err != nil {
		return err
	}

	v := &ValidationError{}
	for i, it := range o.Items {
		field := fmt.Sprintf("items[%d]", i)
		if !active[it.ProductID] {
			v.add(field+".product_id", fmt.Sprintf("product %d (%s) is no longer available", it.ProductID, it.ProductSKU))
			continue
		}
		if have := invs[it.ProductID].Quantity; have < it.Quantity {
			v.add(field+".quantity", fmt.Sprintf("insufficient stock for product %d (%s): %d available, %d requested",
				it.ProductID, it.ProductSKU, have, it.Quantity))
		}
	}
	if err := v.errOrNil(); err != nil {
		return err
	}

	for _, it := range o.Items {
		if err := moveOrderStock(tx, o, it, invs[it.ProductID], model.MovementOut, "confirmed"); err != nil {
			return err
		}
	}
	return nil
}

// returnStock puts back what deductStock took (one IN movement per item),
// also for products that were soft-deleted in the meantime.
func (s *salesOrderService) returnStock(tx repository.SalesOrderTx, o *model.SalesOrder) error {
	invs, err := tx.LockInventories(itemProductIDs(o.Items), s.defaultThreshold)
	if err != nil {
		return err
	}
	for _, it := range o.Items {
		if err := moveOrderStock(tx, o, it, invs[it.ProductID], model.MovementIn, "cancelled"); err != nil {
			return err
		}
	}
	return nil
}

func moveOrderStock(tx repository.SalesOrderTx, o *model.SalesOrder, it model.SalesOrderItem, inv *model.Inventory, typ model.MovementType, event string) error {
	orderID := o.ID
	mv := &model.StockMovement{
		ProductID:    it.ProductID,
		Type:         typ,
		Quantity:     it.Quantity,
		Reason:       fmt.Sprintf("sales order %s %s", o.OrderNumber, event),
		SalesOrderID: &orderID,
	}
	if err := applyMovement(inv, mv); err != nil {
		return err
	}
	if err := tx.SaveInventory(inv); err != nil {
		return err
	}
	return tx.CreateMovement(mv)
}

// checkTransition enforces orderTransitions.
func checkTransition(from, to model.OrderStatus) error {
	allowed := orderTransitions[from]
	for _, s := range allowed {
		if s == to {
			return nil
		}
	}
	msg := fmt.Sprintf("an order that is %s can't change status anymore", from)
	if len(allowed) > 0 {
		names := make([]string, len(allowed))
		for i, s := range allowed {
			names[i] = string(s)
		}
		msg = fmt.Sprintf("can't change status from %s to %s; allowed: %s", from, to, strings.Join(names, ", "))
	}
	return &ValidationError{Fields: []FieldError{{Field: "status", Message: msg}}}
}

func validateOrderInput(in model.CreateSalesOrderInput, notes string) error {
	v := &ValidationError{}
	if in.CustomerID == 0 {
		v.add("customer_id", "is required")
	}
	switch {
	case len(in.Items) == 0:
		v.add("items", "must contain at least one item")
	case len(in.Items) > maxOrderItems:
		v.add("items", fmt.Sprintf("must contain at most %d items", maxOrderItems))
	}
	seen := make(map[uint]int, len(in.Items))
	for i, it := range in.Items {
		field := fmt.Sprintf("items[%d]", i)
		switch first, dup := seen[it.ProductID]; {
		case it.ProductID == 0:
			v.add(field+".product_id", "is required")
		case dup:
			v.add(field+".product_id", fmt.Sprintf("product %d is already in items[%d]; combine the quantities", it.ProductID, first))
		default:
			seen[it.ProductID] = i
		}
		switch {
		case it.Quantity <= 0:
			v.add(field+".quantity", "must be greater than 0")
		case it.Quantity > maxItemQuantity:
			v.add(field+".quantity", fmt.Sprintf("must be at most %d", maxItemQuantity))
		}
	}
	if len(notes) > maxOrderNotesChars {
		v.add("notes", fmt.Sprintf("must be at most %d characters", maxOrderNotesChars))
	}
	return v.errOrNil()
}

func parseOrderStatus(s string) (model.OrderStatus, bool) {
	status := model.OrderStatus(strings.ToUpper(strings.TrimSpace(s)))
	for _, known := range orderStatuses {
		if status == known {
			return status, true
		}
	}
	return "", false
}

func statusEnumMessage() string {
	return "must be one of PENDING, CONFIRMED, SHIPPED, CANCELLED"
}

func itemProductIDs(items []model.SalesOrderItem) []uint {
	ids := make([]uint, len(items))
	for i, it := range items {
		ids[i] = it.ProductID
	}
	return ids
}
