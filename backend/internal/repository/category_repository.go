package repository

import (
	"context"
	"fmt"
	"strings"

	"gorm.io/gorm"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

type CategoryRepository interface {
	Create(ctx context.Context, c *model.Category) error
	FindByID(ctx context.Context, id uint) (*model.Category, error)
	List(ctx context.Context, params model.ListCategoriesParams) ([]model.Category, int64, error)
	Update(ctx context.Context, c *model.Category) error
	Delete(ctx context.Context, id uint) error
	// CountProducts counts active (not soft-deleted) products in the category.
	CountProducts(ctx context.Context, id uint) (int64, error)
}

type categoryRepository struct {
	db *gorm.DB
}

func NewCategoryRepository(db *gorm.DB) CategoryRepository {
	return &categoryRepository{db: db}
}

func (r *categoryRepository) Create(ctx context.Context, c *model.Category) error {
	if err := r.db.WithContext(ctx).Create(c).Error; err != nil {
		return fmt.Errorf("create category: %w", translate(err))
	}
	return nil
}

func (r *categoryRepository) FindByID(ctx context.Context, id uint) (*model.Category, error) {
	var c model.Category
	if err := r.db.WithContext(ctx).First(&c, id).Error; err != nil {
		return nil, fmt.Errorf("find category %d: %w", id, translate(err))
	}
	return &c, nil
}

func (r *categoryRepository) List(ctx context.Context, params model.ListCategoriesParams) ([]model.Category, int64, error) {
	q := r.db.WithContext(ctx).Model(&model.Category{})
	if s := strings.TrimSpace(params.Search); s != "" {
		q = q.Where("name ILIKE ?", "%"+s+"%")
	}

	var total int64
	if err := q.Count(&total).Error; err != nil {
		return nil, 0, fmt.Errorf("count categories: %w", err)
	}

	var categories []model.Category
	err := q.Order("name ASC, id ASC").
		Limit(params.PageSize).
		Offset((params.Page - 1) * params.PageSize).
		Find(&categories).Error
	if err != nil {
		return nil, 0, fmt.Errorf("list categories: %w", err)
	}
	return categories, total, nil
}

func (r *categoryRepository) Update(ctx context.Context, c *model.Category) error {
	if err := r.db.WithContext(ctx).Save(c).Error; err != nil {
		return fmt.Errorf("update category %d: %w", c.ID, translate(err))
	}
	return nil
}

func (r *categoryRepository) Delete(ctx context.Context, id uint) error {
	res := r.db.WithContext(ctx).Delete(&model.Category{}, id)
	if res.Error != nil {
		return fmt.Errorf("delete category %d: %w", id, res.Error)
	}
	if res.RowsAffected == 0 {
		return fmt.Errorf("delete category %d: %w", id, ErrNotFound)
	}
	return nil
}

func (r *categoryRepository) CountProducts(ctx context.Context, id uint) (int64, error) {
	var n int64
	err := r.db.WithContext(ctx).Model(&model.Product{}).Where("category_id = ?", id).Count(&n).Error
	if err != nil {
		return 0, fmt.Errorf("count products in category %d: %w", id, err)
	}
	return n, nil
}
