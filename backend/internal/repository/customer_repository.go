package repository

import (
	"context"
	"fmt"
	"strings"

	"gorm.io/gorm"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

type CustomerRepository interface {
	Create(ctx context.Context, c *model.Customer) error
	FindByID(ctx context.Context, id uint) (*model.Customer, error)
	List(ctx context.Context, params model.ListCustomersParams) ([]model.Customer, int64, error)
	Update(ctx context.Context, c *model.Customer) error
	Delete(ctx context.Context, id uint) error
	// CountActiveOrders counts the customer's sales orders that are not CANCELLED.
	CountActiveOrders(ctx context.Context, id uint) (int64, error)
}

type customerRepository struct {
	db *gorm.DB
}

func NewCustomerRepository(db *gorm.DB) CustomerRepository {
	return &customerRepository{db: db}
}

func (r *customerRepository) Create(ctx context.Context, c *model.Customer) error {
	if err := r.db.WithContext(ctx).Create(c).Error; err != nil {
		return fmt.Errorf("create customer: %w", translate(err))
	}
	return nil
}

func (r *customerRepository) FindByID(ctx context.Context, id uint) (*model.Customer, error) {
	var c model.Customer
	if err := r.db.WithContext(ctx).First(&c, id).Error; err != nil {
		return nil, fmt.Errorf("find customer %d: %w", id, translate(err))
	}
	return &c, nil
}

func (r *customerRepository) List(ctx context.Context, params model.ListCustomersParams) ([]model.Customer, int64, error) {
	q := r.db.WithContext(ctx).Model(&model.Customer{})
	if s := strings.TrimSpace(params.Search); s != "" {
		like := "%" + s + "%"
		q = q.Where("name ILIKE ? OR email ILIKE ? OR phone ILIKE ?", like, like, like)
	}

	var total int64
	if err := q.Count(&total).Error; err != nil {
		return nil, 0, fmt.Errorf("count customers: %w", err)
	}

	var customers []model.Customer
	err := q.Order("name ASC, id ASC").
		Limit(params.PageSize).
		Offset((params.Page - 1) * params.PageSize).
		Find(&customers).Error
	if err != nil {
		return nil, 0, fmt.Errorf("list customers: %w", err)
	}
	return customers, total, nil
}

func (r *customerRepository) Update(ctx context.Context, c *model.Customer) error {
	if err := r.db.WithContext(ctx).Save(c).Error; err != nil {
		return fmt.Errorf("update customer %d: %w", c.ID, translate(err))
	}
	return nil
}

func (r *customerRepository) Delete(ctx context.Context, id uint) error {
	res := r.db.WithContext(ctx).Delete(&model.Customer{}, id)
	if res.Error != nil {
		return fmt.Errorf("delete customer %d: %w", id, res.Error)
	}
	if res.RowsAffected == 0 {
		return fmt.Errorf("delete customer %d: %w", id, ErrNotFound)
	}
	return nil
}

func (r *customerRepository) CountActiveOrders(ctx context.Context, id uint) (int64, error) {
	var n int64
	err := r.db.WithContext(ctx).Model(&model.SalesOrder{}).
		Where("customer_id = ? AND status <> ?", id, model.OrderCancelled).
		Count(&n).Error
	if err != nil {
		return 0, fmt.Errorf("count active orders of customer %d: %w", id, err)
	}
	return n, nil
}
