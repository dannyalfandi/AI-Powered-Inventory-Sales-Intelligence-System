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

type mockCategoryRepo struct {
	mock.Mock
}

func (m *mockCategoryRepo) Create(ctx context.Context, c *model.Category) error {
	return m.Called(ctx, c).Error(0)
}

func (m *mockCategoryRepo) FindByID(ctx context.Context, id uint) (*model.Category, error) {
	args := m.Called(ctx, id)
	c, _ := args.Get(0).(*model.Category)
	return c, args.Error(1)
}

func (m *mockCategoryRepo) List(ctx context.Context, params model.ListCategoriesParams) ([]model.Category, int64, error) {
	args := m.Called(ctx, params)
	categories, _ := args.Get(0).([]model.Category)
	return categories, args.Get(1).(int64), args.Error(2)
}

func (m *mockCategoryRepo) Update(ctx context.Context, c *model.Category) error {
	return m.Called(ctx, c).Error(0)
}

func (m *mockCategoryRepo) Delete(ctx context.Context, id uint) error {
	return m.Called(ctx, id).Error(0)
}

func (m *mockCategoryRepo) CountProducts(ctx context.Context, id uint) (int64, error) {
	args := m.Called(ctx, id)
	return args.Get(0).(int64), args.Error(1)
}

func TestCategoryService_Create(t *testing.T) {
	tests := []struct {
		name        string
		input       model.CreateCategoryInput
		setup       func(r *mockCategoryRepo)
		want        *model.Category
		wantErr     error
		wantInvalid []string
	}{
		{
			name:  "success trims input",
			input: model.CreateCategoryInput{Name: "  Minuman ", Description: " Kopi, teh "},
			setup: func(r *mockCategoryRepo) {
				r.On("Create", mock.Anything, mock.MatchedBy(func(c *model.Category) bool {
					return c.Name == "Minuman" && c.Description == "Kopi, teh"
				})).Run(func(args mock.Arguments) {
					args.Get(1).(*model.Category).ID = 1
				}).Return(nil)
			},
			want: &model.Category{ID: 1, Name: "Minuman", Description: "Kopi, teh"},
		},
		{
			name:  "description is optional",
			input: model.CreateCategoryInput{Name: "Makanan"},
			setup: func(r *mockCategoryRepo) {
				r.On("Create", mock.Anything, mock.Anything).Return(nil)
			},
			want: &model.Category{Name: "Makanan"},
		},
		{
			name:        "missing name",
			input:       model.CreateCategoryInput{Name: "   "},
			wantInvalid: []string{"name"},
		},
		{
			name:        "name too long",
			input:       model.CreateCategoryInput{Name: strings.Repeat("X", maxCategoryNameLength+1)},
			wantInvalid: []string{"name"},
		},
		{
			name:  "duplicate name",
			input: model.CreateCategoryInput{Name: "Minuman"},
			setup: func(r *mockCategoryRepo) {
				r.On("Create", mock.Anything, mock.Anything).
					Return(fmt.Errorf("create category: %w", repository.ErrDuplicateKey))
			},
			wantErr: ErrConflict,
		},
		{
			name:  "repository failure",
			input: model.CreateCategoryInput{Name: "Minuman"},
			setup: func(r *mockCategoryRepo) {
				r.On("Create", mock.Anything, mock.Anything).Return(errDB)
			},
			wantErr: errDB,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockCategoryRepo{}
			if tt.setup != nil {
				tt.setup(repo)
			}
			svc := NewCategoryService(repo)

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

func TestCategoryService_GetByID(t *testing.T) {
	existing := &model.Category{ID: 7, Name: "Minuman"}

	tests := []struct {
		name    string
		repoCat *model.Category
		repoErr error
		wantErr error
	}{
		{name: "found", repoCat: existing},
		{name: "not found", repoErr: repository.ErrNotFound, wantErr: ErrNotFound},
		{name: "repository failure", repoErr: errDB, wantErr: errDB},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockCategoryRepo{}
			repo.On("FindByID", mock.Anything, uint(7)).Return(tt.repoCat, tt.repoErr)
			svc := NewCategoryService(repo)

			got, err := svc.GetByID(context.Background(), 7)

			if tt.wantErr != nil {
				assert.ErrorIs(t, err, tt.wantErr)
				assert.Nil(t, got)
			} else {
				require.NoError(t, err)
				assert.Equal(t, existing, got)
			}
			repo.AssertExpectations(t)
		})
	}
}

func TestCategoryService_List(t *testing.T) {
	categories := []model.Category{{ID: 1, Name: "Makanan"}, {ID: 2, Name: "Minuman"}}

	tests := []struct {
		name       string
		params     model.ListCategoriesParams
		wantParams model.ListCategoriesParams
		repoErr    error
	}{
		{
			name:       "defaults applied",
			wantParams: model.ListCategoriesParams{Page: 1, PageSize: DefaultPageSize},
		},
		{
			name:       "page size clamped and search trimmed",
			params:     model.ListCategoriesParams{Page: 2, PageSize: 1000, Search: " minum  "},
			wantParams: model.ListCategoriesParams{Page: 2, PageSize: MaxPageSize, Search: "minum"},
		},
		{
			name:       "repository failure",
			params:     model.ListCategoriesParams{Page: 1, PageSize: 5},
			wantParams: model.ListCategoriesParams{Page: 1, PageSize: 5},
			repoErr:    errDB,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockCategoryRepo{}
			if tt.repoErr != nil {
				repo.On("List", mock.Anything, tt.wantParams).Return(nil, int64(0), tt.repoErr)
			} else {
				repo.On("List", mock.Anything, tt.wantParams).Return(categories, int64(2), nil)
			}
			svc := NewCategoryService(repo)

			got, total, used, err := svc.List(context.Background(), tt.params)

			assert.Equal(t, tt.wantParams, used)
			if tt.repoErr != nil {
				assert.ErrorIs(t, err, tt.repoErr)
			} else {
				require.NoError(t, err)
				assert.Equal(t, categories, got)
				assert.Equal(t, int64(2), total)
			}
			repo.AssertExpectations(t)
		})
	}
}

func TestCategoryService_Update(t *testing.T) {
	newExisting := func() *model.Category {
		return &model.Category{ID: 5, Name: "Minuman", Description: "Kopi, teh"}
	}

	tests := []struct {
		name        string
		input       model.UpdateCategoryInput
		setup       func(r *mockCategoryRepo)
		want        *model.Category
		wantErr     error
		wantInvalid []string
	}{
		{
			name:  "partial update keeps other fields",
			input: model.UpdateCategoryInput{Name: ptr(" Minuman Dingin ")},
			setup: func(r *mockCategoryRepo) {
				r.On("FindByID", mock.Anything, uint(5)).Return(newExisting(), nil)
				r.On("Update", mock.Anything, mock.Anything).Return(nil)
			},
			want: &model.Category{ID: 5, Name: "Minuman Dingin", Description: "Kopi, teh"},
		},
		{
			name:  "description can be cleared",
			input: model.UpdateCategoryInput{Description: ptr("")},
			setup: func(r *mockCategoryRepo) {
				r.On("FindByID", mock.Anything, uint(5)).Return(newExisting(), nil)
				r.On("Update", mock.Anything, mock.Anything).Return(nil)
			},
			want: &model.Category{ID: 5, Name: "Minuman"},
		},
		{
			name:  "not found",
			input: model.UpdateCategoryInput{Name: ptr("X")},
			setup: func(r *mockCategoryRepo) {
				r.On("FindByID", mock.Anything, uint(5)).Return(nil, repository.ErrNotFound)
			},
			wantErr: ErrNotFound,
		},
		{
			name:  "empty name rejected before save",
			input: model.UpdateCategoryInput{Name: ptr("  ")},
			setup: func(r *mockCategoryRepo) {
				r.On("FindByID", mock.Anything, uint(5)).Return(newExisting(), nil)
			},
			wantInvalid: []string{"name"},
		},
		{
			name:  "name conflict",
			input: model.UpdateCategoryInput{Name: ptr("Makanan")},
			setup: func(r *mockCategoryRepo) {
				r.On("FindByID", mock.Anything, uint(5)).Return(newExisting(), nil)
				r.On("Update", mock.Anything, mock.Anything).Return(repository.ErrDuplicateKey)
			},
			wantErr: ErrConflict,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockCategoryRepo{}
			tt.setup(repo)
			svc := NewCategoryService(repo)

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

func TestCategoryService_Delete(t *testing.T) {
	existing := &model.Category{ID: 9, Name: "Minuman"}

	tests := []struct {
		name         string
		setup        func(r *mockCategoryRepo)
		wantErr      error
		deleteCalled bool
	}{
		{
			name: "unused category is deleted",
			setup: func(r *mockCategoryRepo) {
				r.On("FindByID", mock.Anything, uint(9)).Return(existing, nil)
				r.On("CountProducts", mock.Anything, uint(9)).Return(int64(0), nil)
				r.On("Delete", mock.Anything, uint(9)).Return(nil)
			},
			deleteCalled: true,
		},
		{
			name: "category still used by products is rejected",
			setup: func(r *mockCategoryRepo) {
				r.On("FindByID", mock.Anything, uint(9)).Return(existing, nil)
				r.On("CountProducts", mock.Anything, uint(9)).Return(int64(3), nil)
			},
			wantErr: ErrConflict,
		},
		{
			name: "not found",
			setup: func(r *mockCategoryRepo) {
				r.On("FindByID", mock.Anything, uint(9)).Return(nil, repository.ErrNotFound)
			},
			wantErr: ErrNotFound,
		},
		{
			name: "count failure is not treated as unused",
			setup: func(r *mockCategoryRepo) {
				r.On("FindByID", mock.Anything, uint(9)).Return(existing, nil)
				r.On("CountProducts", mock.Anything, uint(9)).Return(int64(0), errDB)
			},
			wantErr: errDB,
		},
		{
			name: "deleted concurrently",
			setup: func(r *mockCategoryRepo) {
				r.On("FindByID", mock.Anything, uint(9)).Return(existing, nil)
				r.On("CountProducts", mock.Anything, uint(9)).Return(int64(0), nil)
				r.On("Delete", mock.Anything, uint(9)).Return(repository.ErrNotFound)
			},
			wantErr:      ErrNotFound,
			deleteCalled: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockCategoryRepo{}
			tt.setup(repo)
			svc := NewCategoryService(repo)

			err := svc.Delete(context.Background(), 9)

			if tt.wantErr != nil {
				assert.ErrorIs(t, err, tt.wantErr)
			} else {
				assert.NoError(t, err)
			}
			if !tt.deleteCalled {
				repo.AssertNotCalled(t, "Delete", mock.Anything, mock.Anything)
			}
			repo.AssertExpectations(t)
		})
	}
}
