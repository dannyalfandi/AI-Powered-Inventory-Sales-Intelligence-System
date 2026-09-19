package service

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

type mockProductRepo struct {
	mock.Mock
}

func (m *mockProductRepo) Create(ctx context.Context, p *model.Product) error {
	return m.Called(ctx, p).Error(0)
}

func (m *mockProductRepo) FindByID(ctx context.Context, id uint) (*model.Product, error) {
	args := m.Called(ctx, id)
	p, _ := args.Get(0).(*model.Product)
	return p, args.Error(1)
}

func (m *mockProductRepo) List(ctx context.Context, params model.ListProductsParams) ([]model.Product, int64, error) {
	args := m.Called(ctx, params)
	products, _ := args.Get(0).([]model.Product)
	return products, args.Get(1).(int64), args.Error(2)
}

func (m *mockProductRepo) Update(ctx context.Context, p *model.Product) error {
	return m.Called(ctx, p).Error(0)
}

func (m *mockProductRepo) Delete(ctx context.Context, id uint) error {
	return m.Called(ctx, id).Error(0)
}

var errDB = errors.New("connection refused")

func ptr[T any](v T) *T { return &v }

func validationFields(t *testing.T, err error) []string {
	t.Helper()
	var verr *ValidationError
	require.ErrorAs(t, err, &verr)
	fields := make([]string, len(verr.Fields))
	for i, f := range verr.Fields {
		fields[i] = f.Field
	}
	return fields
}

func TestProductService_Create(t *testing.T) {
	tests := []struct {
		name        string
		input       model.CreateProductInput
		setup       func(r *mockProductRepo)
		want        *model.Product
		wantErr     error
		wantInvalid []string
	}{
		{
			name:  "success trims input",
			input: model.CreateProductInput{SKU: "  SKU-001 ", Name: " Kopi Arabica ", Price: 45000},
			setup: func(r *mockProductRepo) {
				r.On("Create", mock.Anything, mock.MatchedBy(func(p *model.Product) bool {
					return p.SKU == "SKU-001" && p.Name == "Kopi Arabica"
				})).Run(func(args mock.Arguments) {
					args.Get(1).(*model.Product).ID = 1
				}).Return(nil)
			},
			want: &model.Product{ID: 1, SKU: "SKU-001", Name: "Kopi Arabica", Price: 45000},
		},
		{
			name:        "missing sku and name",
			input:       model.CreateProductInput{SKU: "  ", Price: 1000},
			wantInvalid: []string{"sku", "name"},
		},
		{
			name:        "negative price",
			input:       model.CreateProductInput{SKU: "SKU-1", Name: "Teh", Price: -1},
			wantInvalid: []string{"price"},
		},
		{
			name:        "sku too long",
			input:       model.CreateProductInput{SKU: strings.Repeat("X", maxSKULength+1), Name: "Teh"},
			wantInvalid: []string{"sku"},
		},
		{
			name:  "duplicate sku",
			input: model.CreateProductInput{SKU: "SKU-001", Name: "Kopi"},
			setup: func(r *mockProductRepo) {
				r.On("Create", mock.Anything, mock.Anything).
					Return(fmt.Errorf("create product: %w", repository.ErrDuplicateKey))
			},
			wantErr: ErrConflict,
		},
		{
			name:  "repository failure",
			input: model.CreateProductInput{SKU: "SKU-001", Name: "Kopi"},
			setup: func(r *mockProductRepo) {
				r.On("Create", mock.Anything, mock.Anything).Return(errDB)
			},
			wantErr: errDB,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockProductRepo{}
			if tt.setup != nil {
				tt.setup(repo)
			}
			svc := NewProductService(repo, &mockCategoryRepo{})

			got, err := svc.Create(context.Background(), tt.input)

			switch {
			case tt.wantInvalid != nil:
				assert.ElementsMatch(t, tt.wantInvalid, validationFields(t, err))
				repo.AssertNotCalled(t, "Create", mock.Anything, mock.Anything)
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

func TestProductService_GetByID(t *testing.T) {
	existing := &model.Product{ID: 7, SKU: "SKU-7", Name: "Gula"}

	tests := []struct {
		name    string
		setup   func(r *mockProductRepo)
		want    *model.Product
		wantErr error
	}{
		{
			name:  "found",
			setup: func(r *mockProductRepo) { r.On("FindByID", mock.Anything, uint(7)).Return(existing, nil) },
			want:  existing,
		},
		{
			name: "not found",
			setup: func(r *mockProductRepo) {
				r.On("FindByID", mock.Anything, uint(7)).Return(nil, repository.ErrNotFound)
			},
			wantErr: ErrNotFound,
		},
		{
			name:    "repository failure",
			setup:   func(r *mockProductRepo) { r.On("FindByID", mock.Anything, uint(7)).Return(nil, errDB) },
			wantErr: errDB,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockProductRepo{}
			tt.setup(repo)
			svc := NewProductService(repo, &mockCategoryRepo{})

			got, err := svc.GetByID(context.Background(), 7)

			if tt.wantErr != nil {
				assert.ErrorIs(t, err, tt.wantErr)
				assert.Nil(t, got)
			} else {
				require.NoError(t, err)
				assert.Equal(t, tt.want, got)
			}
			repo.AssertExpectations(t)
		})
	}
}

func TestProductService_List(t *testing.T) {
	products := []model.Product{{ID: 2, SKU: "B"}, {ID: 1, SKU: "A"}}

	tests := []struct {
		name       string
		params     model.ListProductsParams
		wantParams model.ListProductsParams
		repoErr    error
		wantErr    error
	}{
		{
			name:       "defaults applied",
			params:     model.ListProductsParams{},
			wantParams: model.ListProductsParams{Page: 1, PageSize: DefaultPageSize},
		},
		{
			name:       "page size clamped and search trimmed",
			params:     model.ListProductsParams{Page: 3, PageSize: 500, Search: "  kopi "},
			wantParams: model.ListProductsParams{Page: 3, PageSize: MaxPageSize, Search: "kopi"},
		},
		{
			name:       "repository failure",
			params:     model.ListProductsParams{Page: 1, PageSize: 10},
			wantParams: model.ListProductsParams{Page: 1, PageSize: 10},
			repoErr:    errDB,
			wantErr:    errDB,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockProductRepo{}
			if tt.repoErr != nil {
				repo.On("List", mock.Anything, tt.wantParams).Return(nil, int64(0), tt.repoErr)
			} else {
				repo.On("List", mock.Anything, tt.wantParams).Return(products, int64(42), nil)
			}
			svc := NewProductService(repo, &mockCategoryRepo{})

			got, total, used, err := svc.List(context.Background(), tt.params)

			assert.Equal(t, tt.wantParams, used)
			if tt.wantErr != nil {
				assert.ErrorIs(t, err, tt.wantErr)
			} else {
				require.NoError(t, err)
				assert.Equal(t, products, got)
				assert.Equal(t, int64(42), total)
			}
			repo.AssertExpectations(t)
		})
	}
}

func TestProductService_Update(t *testing.T) {
	newExisting := func() *model.Product {
		return &model.Product{ID: 5, SKU: "SKU-5", Name: "Beras", Description: "5kg", Price: 70000}
	}

	tests := []struct {
		name        string
		input       model.UpdateProductInput
		setup       func(r *mockProductRepo)
		want        *model.Product
		wantErr     error
		wantInvalid []string
	}{
		{
			name:  "partial update keeps other fields",
			input: model.UpdateProductInput{Price: ptr(int64(75000)), Name: ptr(" Beras Premium ")},
			setup: func(r *mockProductRepo) {
				r.On("FindByID", mock.Anything, uint(5)).Return(newExisting(), nil)
				r.On("Update", mock.Anything, mock.Anything).Return(nil)
			},
			want: &model.Product{ID: 5, SKU: "SKU-5", Name: "Beras Premium", Description: "5kg", Price: 75000},
		},
		{
			name:  "not found",
			input: model.UpdateProductInput{Price: ptr(int64(1))},
			setup: func(r *mockProductRepo) {
				r.On("FindByID", mock.Anything, uint(5)).Return(nil, repository.ErrNotFound)
			},
			wantErr: ErrNotFound,
		},
		{
			name:  "invalid update rejected before save",
			input: model.UpdateProductInput{Name: ptr(""), Price: ptr(int64(-5))},
			setup: func(r *mockProductRepo) {
				r.On("FindByID", mock.Anything, uint(5)).Return(newExisting(), nil)
			},
			wantInvalid: []string{"name", "price"},
		},
		{
			name:  "sku conflict",
			input: model.UpdateProductInput{SKU: ptr("SKU-TAKEN")},
			setup: func(r *mockProductRepo) {
				r.On("FindByID", mock.Anything, uint(5)).Return(newExisting(), nil)
				r.On("Update", mock.Anything, mock.Anything).Return(repository.ErrDuplicateKey)
			},
			wantErr: ErrConflict,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockProductRepo{}
			tt.setup(repo)
			svc := NewProductService(repo, &mockCategoryRepo{})

			got, err := svc.Update(context.Background(), 5, tt.input)

			switch {
			case tt.wantInvalid != nil:
				assert.ElementsMatch(t, tt.wantInvalid, validationFields(t, err))
				repo.AssertNotCalled(t, "Update", mock.Anything, mock.Anything)
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

func TestProductService_Delete(t *testing.T) {
	tests := []struct {
		name    string
		repoErr error
		wantErr error
	}{
		{name: "success"},
		{name: "not found", repoErr: repository.ErrNotFound, wantErr: ErrNotFound},
		{name: "repository failure", repoErr: errDB, wantErr: errDB},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockProductRepo{}
			repo.On("Delete", mock.Anything, uint(9)).Return(tt.repoErr)
			svc := NewProductService(repo, &mockCategoryRepo{})

			err := svc.Delete(context.Background(), 9)

			if tt.wantErr != nil {
				assert.ErrorIs(t, err, tt.wantErr)
			} else {
				assert.NoError(t, err)
			}
			repo.AssertExpectations(t)
		})
	}
}

func TestProductService_CreateWithCategory(t *testing.T) {
	minuman := &model.Category{ID: 3, Name: "Minuman"}

	tests := []struct {
		name         string
		categoryID   *uint
		setup        func(r *mockProductRepo, c *mockCategoryRepo)
		wantCategory *model.Category
		wantErr      error
		wantInvalid  []string
	}{
		{
			name:       "existing category is linked and returned",
			categoryID: ptr(uint(3)),
			setup: func(r *mockProductRepo, c *mockCategoryRepo) {
				c.On("FindByID", mock.Anything, uint(3)).Return(minuman, nil)
				r.On("Create", mock.Anything, mock.MatchedBy(func(p *model.Product) bool {
					return p.CategoryID != nil && *p.CategoryID == 3
				})).Return(nil)
			},
			wantCategory: minuman,
		},
		{
			name:       "zero means no category",
			categoryID: ptr(uint(0)),
			setup: func(r *mockProductRepo, _ *mockCategoryRepo) {
				r.On("Create", mock.Anything, mock.MatchedBy(func(p *model.Product) bool {
					return p.CategoryID == nil
				})).Return(nil)
			},
		},
		{
			name:       "unknown category is a validation error",
			categoryID: ptr(uint(99)),
			setup: func(_ *mockProductRepo, c *mockCategoryRepo) {
				c.On("FindByID", mock.Anything, uint(99)).Return(nil, repository.ErrNotFound)
			},
			wantInvalid: []string{"category_id"},
		},
		{
			name:       "category lookup failure",
			categoryID: ptr(uint(3)),
			setup: func(_ *mockProductRepo, c *mockCategoryRepo) {
				c.On("FindByID", mock.Anything, uint(3)).Return(nil, errDB)
			},
			wantErr: errDB,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo, cats := &mockProductRepo{}, &mockCategoryRepo{}
			tt.setup(repo, cats)
			svc := NewProductService(repo, cats)

			got, err := svc.Create(context.Background(), model.CreateProductInput{
				SKU: "SKU-1", Name: "Teh Botol", Price: 5000, CategoryID: tt.categoryID,
			})

			switch {
			case tt.wantInvalid != nil:
				assert.ElementsMatch(t, tt.wantInvalid, validationFields(t, err))
				repo.AssertNotCalled(t, "Create", mock.Anything, mock.Anything)
			case tt.wantErr != nil:
				assert.ErrorIs(t, err, tt.wantErr)
				assert.Nil(t, got)
			default:
				require.NoError(t, err)
				assert.Equal(t, tt.wantCategory, got.Category)
			}
			repo.AssertExpectations(t)
			cats.AssertExpectations(t)
		})
	}
}

func TestProductService_UpdateCategory(t *testing.T) {
	makanan := &model.Category{ID: 4, Name: "Makanan"}
	newExisting := func() *model.Product {
		return &model.Product{
			ID: 5, SKU: "SKU-5", Name: "Beras", Price: 70000,
			CategoryID: ptr(uint(3)), Category: &model.Category{ID: 3, Name: "Minuman"},
		}
	}

	tests := []struct {
		name           string
		input          model.UpdateProductInput
		setup          func(c *mockCategoryRepo)
		wantCategoryID *uint
		wantCategory   *model.Category
	}{
		{
			name:           "move to another category",
			input:          model.UpdateProductInput{CategoryID: ptr(uint(4))},
			setup:          func(c *mockCategoryRepo) { c.On("FindByID", mock.Anything, uint(4)).Return(makanan, nil) },
			wantCategoryID: ptr(uint(4)),
			wantCategory:   makanan,
		},
		{
			name:  "zero removes the category",
			input: model.UpdateProductInput{CategoryID: ptr(uint(0))},
		},
		{
			name:           "omitted category_id keeps the current one",
			input:          model.UpdateProductInput{Price: ptr(int64(1))},
			wantCategoryID: ptr(uint(3)),
			wantCategory:   &model.Category{ID: 3, Name: "Minuman"},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo, cats := &mockProductRepo{}, &mockCategoryRepo{}
			repo.On("FindByID", mock.Anything, uint(5)).Return(newExisting(), nil)
			repo.On("Update", mock.Anything, mock.Anything).Return(nil)
			if tt.setup != nil {
				tt.setup(cats)
			}
			svc := NewProductService(repo, cats)

			got, err := svc.Update(context.Background(), 5, tt.input)

			require.NoError(t, err)
			assert.Equal(t, tt.wantCategoryID, got.CategoryID)
			assert.Equal(t, tt.wantCategory, got.Category)
			repo.AssertExpectations(t)
			cats.AssertExpectations(t)
		})
	}
}
