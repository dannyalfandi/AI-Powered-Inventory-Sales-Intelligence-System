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
	DefaultPageSize = 20
	MaxPageSize     = 100

	maxSKULength  = 64
	maxNameLength = 255
)

type ProductService interface {
	Create(ctx context.Context, in model.CreateProductInput) (*model.Product, error)
	GetByID(ctx context.Context, id uint) (*model.Product, error)
	List(ctx context.Context, params model.ListProductsParams) ([]model.Product, int64, model.ListProductsParams, error)
	Update(ctx context.Context, id uint, in model.UpdateProductInput) (*model.Product, error)
	Delete(ctx context.Context, id uint) error
}

type productService struct {
	repo       repository.ProductRepository
	categories repository.CategoryRepository
}

func NewProductService(repo repository.ProductRepository, categories repository.CategoryRepository) ProductService {
	return &productService{repo: repo, categories: categories}
}

func (s *productService) Create(ctx context.Context, in model.CreateProductInput) (*model.Product, error) {
	p := &model.Product{
		SKU:         strings.TrimSpace(in.SKU),
		Name:        strings.TrimSpace(in.Name),
		Description: strings.TrimSpace(in.Description),
		Price:       in.Price,
	}
	if err := validateProduct(ctx, p); err != nil {
		return nil, err
	}
	if in.CategoryID != nil {
		if err := s.setCategory(ctx, p, *in.CategoryID); err != nil {
			return nil, err
		}
	}

	if err := s.repo.Create(ctx, p); err != nil {
		return nil, mapRepoError(ctx, err, i18n.KeyEntityProductSKU, p.SKU)
	}
	return p, nil
}

func (s *productService) GetByID(ctx context.Context, id uint) (*model.Product, error) {
	p, err := s.repo.FindByID(ctx, id)
	if err != nil {
		return nil, mapRepoError(ctx, err, i18n.KeyEntityProduct, id)
	}
	return p, nil
}

// List normalizes pagination and returns the params actually used, so the
// handler can echo them back in the response meta.
func (s *productService) List(ctx context.Context, params model.ListProductsParams) ([]model.Product, int64, model.ListProductsParams, error) {
	params = normalizePagination(params)
	products, total, err := s.repo.List(ctx, params)
	if err != nil {
		return nil, 0, params, fmt.Errorf("list products: %w", err)
	}
	return products, total, params, nil
}

func (s *productService) Update(ctx context.Context, id uint, in model.UpdateProductInput) (*model.Product, error) {
	p, err := s.repo.FindByID(ctx, id)
	if err != nil {
		return nil, mapRepoError(ctx, err, i18n.KeyEntityProduct, id)
	}

	if in.SKU != nil {
		p.SKU = strings.TrimSpace(*in.SKU)
	}
	if in.Name != nil {
		p.Name = strings.TrimSpace(*in.Name)
	}
	if in.Description != nil {
		p.Description = strings.TrimSpace(*in.Description)
	}
	if in.Price != nil {
		p.Price = *in.Price
	}
	if err := validateProduct(ctx, p); err != nil {
		return nil, err
	}
	if in.CategoryID != nil {
		if err := s.setCategory(ctx, p, *in.CategoryID); err != nil {
			return nil, err
		}
	}

	if err := s.repo.Update(ctx, p); err != nil {
		return nil, mapRepoError(ctx, err, i18n.KeyEntityProduct, id)
	}
	return p, nil
}

func (s *productService) Delete(ctx context.Context, id uint) error {
	if err := s.repo.Delete(ctx, id); err != nil {
		return mapRepoError(ctx, err, i18n.KeyEntityProduct, id)
	}
	return nil
}

// setCategory assigns category id to p (0 clears it). The category must exist
// and not be soft-deleted, which the foreign key alone can't guarantee.
func (s *productService) setCategory(ctx context.Context, p *model.Product, id uint) error {
	if id == 0 {
		p.CategoryID, p.Category = nil, nil
		return nil
	}
	c, err := s.categories.FindByID(ctx, id)
	if errors.Is(err, repository.ErrNotFound) {
		return fieldError(ctx, "category_id", i18n.KeyDoesNotExist)
	}
	if err != nil {
		return fmt.Errorf("category %d: %w", id, err)
	}
	p.CategoryID, p.Category = &c.ID, c
	return nil
}

func validateProduct(ctx context.Context, p *model.Product) error {
	v := &ValidationError{}
	switch {
	case p.SKU == "":
		v.add(ctx, "sku", i18n.KeyRequired)
	case len(p.SKU) > maxSKULength:
		v.add(ctx, "sku", i18n.KeyMaxChars, maxSKULength)
	}
	switch {
	case p.Name == "":
		v.add(ctx, "name", i18n.KeyRequired)
	case len(p.Name) > maxNameLength:
		v.add(ctx, "name", i18n.KeyMaxChars, maxNameLength)
	}
	if p.Price < 0 {
		v.add(ctx, "price", i18n.KeyNotNegative)
	}
	return v.errOrNil()
}

func normalizePagination(p model.ListProductsParams) model.ListProductsParams {
	p.Page, p.PageSize = normalizePage(p.Page, p.PageSize)
	p.Search = strings.TrimSpace(p.Search)
	return p
}

// normalizePage applies the default page and clamps the page size.
func normalizePage(page, pageSize int) (int, int) {
	if page < 1 {
		page = 1
	}
	if pageSize < 1 {
		pageSize = DefaultPageSize
	}
	if pageSize > MaxPageSize {
		pageSize = MaxPageSize
	}
	return page, pageSize
}

// mapRepoError converts repository sentinel errors into service errors,
// naming what the error is about in the request's language.
//
// The subject is a catalog entry too ("product %d" / "produk %d"), so the
// whole sentence is translated rather than a template with an English noun
// pasted into it. The sentinel prefix the handler strips stays English: it is
// a program-facing marker, not part of the message.
func mapRepoError(ctx context.Context, err error, entity i18n.Key, ref any) error {
	subject := i18n.T(ctx, entity, ref)
	switch {
	case errors.Is(err, repository.ErrNotFound):
		return fmt.Errorf("%w: %s", ErrNotFound, i18n.T(ctx, i18n.KeyNotFound, subject))
	case errors.Is(err, repository.ErrDuplicateKey):
		return fmt.Errorf("%w: %s", ErrConflict, i18n.T(ctx, i18n.KeyAlreadyExists, subject))
	default:
		return fmt.Errorf("%s: %w", subject, err)
	}
}
