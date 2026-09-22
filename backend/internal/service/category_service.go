package service

import (
	"context"
	"fmt"
	"strings"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

const maxCategoryNameLength = 100

type CategoryService interface {
	Create(ctx context.Context, in model.CreateCategoryInput) (*model.Category, error)
	GetByID(ctx context.Context, id uint) (*model.Category, error)
	List(ctx context.Context, params model.ListCategoriesParams) ([]model.Category, int64, model.ListCategoriesParams, error)
	Update(ctx context.Context, id uint, in model.UpdateCategoryInput) (*model.Category, error)
	Delete(ctx context.Context, id uint) error
}

type categoryService struct {
	repo repository.CategoryRepository
}

func NewCategoryService(repo repository.CategoryRepository) CategoryService {
	return &categoryService{repo: repo}
}

func (s *categoryService) Create(ctx context.Context, in model.CreateCategoryInput) (*model.Category, error) {
	c := &model.Category{
		Name:        strings.TrimSpace(in.Name),
		Description: strings.TrimSpace(in.Description),
	}
	if err := validateCategory(ctx, c); err != nil {
		return nil, err
	}

	if err := s.repo.Create(ctx, c); err != nil {
		return nil, mapRepoError(ctx, err, i18n.KeyEntityCategoryName, c.Name)
	}
	return c, nil
}

func (s *categoryService) GetByID(ctx context.Context, id uint) (*model.Category, error) {
	c, err := s.repo.FindByID(ctx, id)
	if err != nil {
		return nil, mapRepoError(ctx, err, i18n.KeyEntityCategory, id)
	}
	return c, nil
}

func (s *categoryService) List(ctx context.Context, params model.ListCategoriesParams) ([]model.Category, int64, model.ListCategoriesParams, error) {
	params.Page, params.PageSize = normalizePage(params.Page, params.PageSize)
	params.Search = strings.TrimSpace(params.Search)
	categories, total, err := s.repo.List(ctx, params)
	if err != nil {
		return nil, 0, params, fmt.Errorf("list categories: %w", err)
	}
	return categories, total, params, nil
}

func (s *categoryService) Update(ctx context.Context, id uint, in model.UpdateCategoryInput) (*model.Category, error) {
	c, err := s.repo.FindByID(ctx, id)
	if err != nil {
		return nil, mapRepoError(ctx, err, i18n.KeyEntityCategory, id)
	}

	if in.Name != nil {
		c.Name = strings.TrimSpace(*in.Name)
	}
	if in.Description != nil {
		c.Description = strings.TrimSpace(*in.Description)
	}
	if err := validateCategory(ctx, c); err != nil {
		return nil, err
	}

	if err := s.repo.Update(ctx, c); err != nil {
		return nil, mapRepoError(ctx, err, i18n.KeyEntityCategoryName, c.Name)
	}
	return c, nil
}

// Delete soft-deletes a category. It refuses (ErrConflict) while active
// products still use it; products are never deleted or unlinked implicitly.
func (s *categoryService) Delete(ctx context.Context, id uint) error {
	if _, err := s.repo.FindByID(ctx, id); err != nil {
		return mapRepoError(ctx, err, i18n.KeyEntityCategory, id)
	}

	n, err := s.repo.CountProducts(ctx, id)
	if err != nil {
		return fmt.Errorf("category %d: %w", id, err)
	}
	if n > 0 {
		return fmt.Errorf("%w: %s", ErrConflict, i18n.T(ctx, i18n.KeyCategoryInUse, id, n))
	}

	if err := s.repo.Delete(ctx, id); err != nil {
		return mapRepoError(ctx, err, i18n.KeyEntityCategory, id)
	}
	return nil
}

func validateCategory(ctx context.Context, c *model.Category) error {
	v := &ValidationError{}
	switch {
	case c.Name == "":
		v.add(ctx, "name", i18n.KeyRequired)
	case len(c.Name) > maxCategoryNameLength:
		v.add(ctx, "name", i18n.KeyMaxChars, maxCategoryNameLength)
	}
	return v.errOrNil()
}
