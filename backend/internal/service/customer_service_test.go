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

type mockCustomerRepo struct {
	mock.Mock
}

func (m *mockCustomerRepo) Create(ctx context.Context, c *model.Customer) error {
	return m.Called(ctx, c).Error(0)
}

func (m *mockCustomerRepo) FindByID(ctx context.Context, id uint) (*model.Customer, error) {
	args := m.Called(ctx, id)
	c, _ := args.Get(0).(*model.Customer)
	return c, args.Error(1)
}

func (m *mockCustomerRepo) List(ctx context.Context, params model.ListCustomersParams) ([]model.Customer, int64, error) {
	args := m.Called(ctx, params)
	customers, _ := args.Get(0).([]model.Customer)
	return customers, args.Get(1).(int64), args.Error(2)
}

func (m *mockCustomerRepo) Update(ctx context.Context, c *model.Customer) error {
	return m.Called(ctx, c).Error(0)
}

func (m *mockCustomerRepo) Delete(ctx context.Context, id uint) error {
	return m.Called(ctx, id).Error(0)
}

func (m *mockCustomerRepo) CountActiveOrders(ctx context.Context, id uint) (int64, error) {
	args := m.Called(ctx, id)
	return args.Get(0).(int64), args.Error(1)
}

func TestCustomerService_Create(t *testing.T) {
	tests := []struct {
		name        string
		input       model.CreateCustomerInput
		setup       func(r *mockCustomerRepo)
		want        *model.Customer
		wantErr     error
		wantInvalid []string
	}{
		{
			name: "trims input and lowercases email",
			input: model.CreateCustomerInput{
				Name: " Budi Santoso ", Email: " Budi@Example.COM ", Phone: " +62 812-3456-7890 ", Address: " Jl. Merdeka 1 ",
			},
			setup: func(r *mockCustomerRepo) { r.On("Create", mock.Anything, mock.Anything).Return(nil) },
			want: &model.Customer{
				Name: "Budi Santoso", Email: ptr("budi@example.com"), Phone: "+62 812-3456-7890", Address: "Jl. Merdeka 1",
			},
		},
		{
			name:  "only name is required; empty email is stored as NULL",
			input: model.CreateCustomerInput{Name: "Siti", Email: "   "},
			setup: func(r *mockCustomerRepo) { r.On("Create", mock.Anything, mock.Anything).Return(nil) },
			want:  &model.Customer{Name: "Siti"},
		},
		{
			name:        "missing name",
			input:       model.CreateCustomerInput{Name: " "},
			wantInvalid: []string{"name"},
		},
		{
			name:        "invalid email",
			input:       model.CreateCustomerInput{Name: "A", Email: "not-an-email"},
			wantInvalid: []string{"email"},
		},
		{
			name:        "email with display name is rejected",
			input:       model.CreateCustomerInput{Name: "A", Email: "Budi <budi@example.com>"},
			wantInvalid: []string{"email"},
		},
		{
			name:        "invalid phone",
			input:       model.CreateCustomerInput{Name: "A", Phone: "call me"},
			wantInvalid: []string{"phone"},
		},
		{
			name:        "address too long",
			input:       model.CreateCustomerInput{Name: "A", Address: strings.Repeat("x", maxAddressLength+1)},
			wantInvalid: []string{"address"},
		},
		{
			name:  "duplicate email",
			input: model.CreateCustomerInput{Name: "A", Email: "a@b.id"},
			setup: func(r *mockCustomerRepo) {
				r.On("Create", mock.Anything, mock.Anything).
					Return(fmt.Errorf("create customer: %w", repository.ErrDuplicateKey))
			},
			wantErr: ErrConflict,
		},
		{
			name:    "repository failure",
			input:   model.CreateCustomerInput{Name: "A"},
			setup:   func(r *mockCustomerRepo) { r.On("Create", mock.Anything, mock.Anything).Return(errDB) },
			wantErr: errDB,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockCustomerRepo{}
			if tt.setup != nil {
				tt.setup(repo)
			}
			svc := NewCustomerService(repo)

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

func TestCustomerService_Update(t *testing.T) {
	newExisting := func() *model.Customer {
		return &model.Customer{ID: 5, Name: "Budi", Email: ptr("budi@example.com"), Phone: "0812345678"}
	}

	tests := []struct {
		name        string
		input       model.UpdateCustomerInput
		setup       func(r *mockCustomerRepo)
		want        *model.Customer
		wantErr     error
		wantInvalid []string
	}{
		{
			name:  "partial update keeps other fields",
			input: model.UpdateCustomerInput{Address: ptr(" Bandung ")},
			setup: func(r *mockCustomerRepo) {
				r.On("FindByID", mock.Anything, uint(5)).Return(newExisting(), nil)
				r.On("Update", mock.Anything, mock.Anything).Return(nil)
			},
			want: &model.Customer{ID: 5, Name: "Budi", Email: ptr("budi@example.com"), Phone: "0812345678", Address: "Bandung"},
		},
		{
			name:  "empty email removes it",
			input: model.UpdateCustomerInput{Email: ptr("")},
			setup: func(r *mockCustomerRepo) {
				r.On("FindByID", mock.Anything, uint(5)).Return(newExisting(), nil)
				r.On("Update", mock.Anything, mock.Anything).Return(nil)
			},
			want: &model.Customer{ID: 5, Name: "Budi", Phone: "0812345678"},
		},
		{
			name:  "invalid values rejected before save",
			input: model.UpdateCustomerInput{Name: ptr(""), Email: ptr("x@")},
			setup: func(r *mockCustomerRepo) {
				r.On("FindByID", mock.Anything, uint(5)).Return(newExisting(), nil)
			},
			wantInvalid: []string{"name", "email"},
		},
		{
			name:  "email taken by another customer",
			input: model.UpdateCustomerInput{Email: ptr("siti@example.com")},
			setup: func(r *mockCustomerRepo) {
				r.On("FindByID", mock.Anything, uint(5)).Return(newExisting(), nil)
				r.On("Update", mock.Anything, mock.Anything).Return(repository.ErrDuplicateKey)
			},
			wantErr: ErrConflict,
		},
		{
			name:  "not found",
			input: model.UpdateCustomerInput{Name: ptr("X")},
			setup: func(r *mockCustomerRepo) {
				r.On("FindByID", mock.Anything, uint(5)).Return(nil, repository.ErrNotFound)
			},
			wantErr: ErrNotFound,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockCustomerRepo{}
			tt.setup(repo)
			svc := NewCustomerService(repo)

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

func TestCustomerService_Delete(t *testing.T) {
	existing := &model.Customer{ID: 9, Name: "Budi"}

	tests := []struct {
		name         string
		setup        func(r *mockCustomerRepo)
		wantErr      error
		deleteCalled bool
	}{
		{
			name: "customer without active orders is deleted",
			setup: func(r *mockCustomerRepo) {
				r.On("FindByID", mock.Anything, uint(9)).Return(existing, nil)
				r.On("CountActiveOrders", mock.Anything, uint(9)).Return(int64(0), nil)
				r.On("Delete", mock.Anything, uint(9)).Return(nil)
			},
			deleteCalled: true,
		},
		{
			name: "customer with orders that are not cancelled is rejected",
			setup: func(r *mockCustomerRepo) {
				r.On("FindByID", mock.Anything, uint(9)).Return(existing, nil)
				r.On("CountActiveOrders", mock.Anything, uint(9)).Return(int64(2), nil)
			},
			wantErr: ErrConflict,
		},
		{
			name: "not found",
			setup: func(r *mockCustomerRepo) {
				r.On("FindByID", mock.Anything, uint(9)).Return(nil, repository.ErrNotFound)
			},
			wantErr: ErrNotFound,
		},
		{
			name: "count failure is not treated as no orders",
			setup: func(r *mockCustomerRepo) {
				r.On("FindByID", mock.Anything, uint(9)).Return(existing, nil)
				r.On("CountActiveOrders", mock.Anything, uint(9)).Return(int64(0), errDB)
			},
			wantErr: errDB,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockCustomerRepo{}
			tt.setup(repo)
			svc := NewCustomerService(repo)

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

func TestCustomerService_GetAndList(t *testing.T) {
	t.Run("get not found", func(t *testing.T) {
		repo := &mockCustomerRepo{}
		repo.On("FindByID", mock.Anything, uint(3)).Return(nil, repository.ErrNotFound)

		_, err := NewCustomerService(repo).GetByID(context.Background(), 3)

		assert.ErrorIs(t, err, ErrNotFound)
	})

	t.Run("list normalizes pagination and search", func(t *testing.T) {
		repo := &mockCustomerRepo{}
		want := model.ListCustomersParams{Page: 1, PageSize: MaxPageSize, Search: "budi"}
		repo.On("List", mock.Anything, want).Return([]model.Customer{{ID: 1}}, int64(1), nil)

		got, total, used, err := NewCustomerService(repo).List(context.Background(),
			model.ListCustomersParams{Page: 0, PageSize: 999, Search: " budi "})

		require.NoError(t, err)
		assert.Equal(t, want, used)
		assert.Len(t, got, 1)
		assert.Equal(t, int64(1), total)
	})
}
