package repository

import (
	"context"
	"errors"
	"fmt"
	"strings"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

type ProductRepository interface {
	Create(ctx context.Context, p *model.Product) error
	FindByID(ctx context.Context, id uint) (*model.Product, error)
	List(ctx context.Context, params model.ListProductsParams) ([]model.Product, int64, error)
	Update(ctx context.Context, p *model.Product) error
	Delete(ctx context.Context, id uint) error
}

type productRepository struct {
	db *gorm.DB
}

func NewProductRepository(db *gorm.DB) ProductRepository {
	return &productRepository{db: db}
}

// Create and Update omit associations: p.Category is only loaded for the
// response, and saving it would upsert the category or overwrite CategoryID.
func (r *productRepository) Create(ctx context.Context, p *model.Product) error {
	if err := r.db.WithContext(ctx).Omit(clause.Associations).Create(p).Error; err != nil {
		return fmt.Errorf("create product: %w", translate(err))
	}
	return nil
}

func (r *productRepository) FindByID(ctx context.Context, id uint) (*model.Product, error) {
	var p model.Product
	if err := r.db.WithContext(ctx).Preload("Category").First(&p, id).Error; err != nil {
		return nil, fmt.Errorf("find product %d: %w", id, translate(err))
	}
	return &p, nil
}

func (r *productRepository) List(ctx context.Context, params model.ListProductsParams) ([]model.Product, int64, error) {
	q := r.db.WithContext(ctx).Model(&model.Product{})
	if s := strings.TrimSpace(params.Search); s != "" {
		like := "%" + s + "%"
		q = q.Where("name ILIKE ? OR sku ILIKE ?", like, like)
	}

	var total int64
	if err := q.Count(&total).Error; err != nil {
		return nil, 0, fmt.Errorf("count products: %w", err)
	}

	var products []model.Product
	err := q.Preload("Category").
		Order("id DESC").
		Limit(params.PageSize).
		Offset((params.Page - 1) * params.PageSize).
		Find(&products).Error
	if err != nil {
		return nil, 0, fmt.Errorf("list products: %w", err)
	}
	return products, total, nil
}

func (r *productRepository) Update(ctx context.Context, p *model.Product) error {
	if err := r.db.WithContext(ctx).Omit(clause.Associations).Save(p).Error; err != nil {
		return fmt.Errorf("update product %d: %w", p.ID, translate(err))
	}
	return nil
}

func (r *productRepository) Delete(ctx context.Context, id uint) error {
	res := r.db.WithContext(ctx).Delete(&model.Product{}, id)
	if res.Error != nil {
		return fmt.Errorf("delete product %d: %w", id, res.Error)
	}
	if res.RowsAffected == 0 {
		return fmt.Errorf("delete product %d: %w", id, ErrNotFound)
	}
	return nil
}

// translate maps gorm errors to repository sentinel errors.
func translate(err error) error {
	switch {
	case errors.Is(err, gorm.ErrRecordNotFound):
		return ErrNotFound
	case errors.Is(err, gorm.ErrDuplicatedKey):
		return ErrDuplicateKey
	default:
		return err
	}
}
