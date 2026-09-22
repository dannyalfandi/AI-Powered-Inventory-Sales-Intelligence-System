package service

import (
	"context"
	"fmt"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/client"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

// Every message a client can read is checked in both languages here, next to
// the rule that produces it. The other tests in this package assert field
// names and error kinds — the wording lives in one place, so a change to the
// catalog shows up as one failing test file instead of twenty.
//
// Each case runs the real service with a context carrying the language, so it
// also proves the language actually travels from the request to the message.

func idCtx() context.Context   { return i18n.WithLang(context.Background(), i18n.ID) }
func enCtx() context.Context   { return i18n.WithLang(context.Background(), i18n.EN) }
func bareCtx() context.Context { return context.Background() }

func TestProductMessagesAreTranslated(t *testing.T) {
	newService := func() (ProductService, *mockProductRepo) {
		repo := &mockProductRepo{}
		return NewProductService(repo, &mockCategoryRepo{}), repo
	}

	t.Run("validation", func(t *testing.T) {
		tests := []struct {
			name string
			ctx  context.Context
			want []FieldError
		}{
			{"indonesian", idCtx(), []FieldError{
				{Field: "sku", Message: "wajib diisi"},
				{Field: "name", Message: "wajib diisi"},
				{Field: "price", Message: "tidak boleh negatif"},
			}},
			{"english", enCtx(), []FieldError{
				{Field: "sku", Message: "is required"},
				{Field: "name", Message: "is required"},
				{Field: "price", Message: "must not be negative"},
			}},
			{"no language: indonesian, the default", bareCtx(), []FieldError{
				{Field: "sku", Message: "wajib diisi"},
				{Field: "name", Message: "wajib diisi"},
				{Field: "price", Message: "tidak boleh negatif"},
			}},
		}

		for _, tt := range tests {
			t.Run(tt.name, func(t *testing.T) {
				svc, _ := newService()

				_, err := svc.Create(tt.ctx, model.CreateProductInput{Price: -1})

				var verr *ValidationError
				require.ErrorAs(t, err, &verr)
				assert.Equal(t, tt.want, verr.Fields)
			})
		}
	})

	t.Run("duplicate sku", func(t *testing.T) {
		for _, tt := range []struct {
			lang context.Context
			want string
		}{
			{idCtx(), "produk dengan sku KOPI-001 sudah ada"},
			{enCtx(), "product sku KOPI-001 already exists"},
		} {
			svc, repo := newService()
			repo.On("Create", mock.Anything, mock.Anything).Return(repository.ErrDuplicateKey)

			_, err := svc.Create(tt.lang, model.CreateProductInput{SKU: "KOPI-001", Name: "Kopi", Price: 1000})

			require.ErrorIs(t, err, ErrConflict)
			assert.Contains(t, err.Error(), tt.want)
		}
	})

	t.Run("not found", func(t *testing.T) {
		for _, tt := range []struct {
			lang context.Context
			want string
		}{
			{idCtx(), "produk 7 tidak ditemukan"},
			{enCtx(), "product 7 not found"},
		} {
			svc, repo := newService()
			repo.On("FindByID", mock.Anything, uint(7)).Return((*model.Product)(nil), repository.ErrNotFound)

			_, err := svc.GetByID(tt.lang, 7)

			require.ErrorIs(t, err, ErrNotFound)
			assert.Contains(t, err.Error(), tt.want)
		}
	})
}

func TestCategoryMessagesAreTranslated(t *testing.T) {
	t.Run("still used by products", func(t *testing.T) {
		for _, tt := range []struct {
			lang context.Context
			want string
		}{
			{idCtx(), "kategori 9 masih dipakai oleh 3 produk"},
			{enCtx(), "category 9 is still used by 3 product(s)"},
		} {
			repo := &mockCategoryRepo{}
			repo.On("FindByID", mock.Anything, uint(9)).Return(&model.Category{ID: 9, Name: "Minuman"}, nil)
			repo.On("CountProducts", mock.Anything, uint(9)).Return(int64(3), nil)
			svc := NewCategoryService(repo)

			err := svc.Delete(tt.lang, 9)

			require.ErrorIs(t, err, ErrConflict)
			assert.Contains(t, err.Error(), tt.want)
		}
	})
}

func TestInventoryMessagesAreTranslated(t *testing.T) {
	t.Run("insufficient stock on an OUT movement", func(t *testing.T) {
		for _, tt := range []struct {
			lang context.Context
			want string
		}{
			{idCtx(), "stok tidak cukup: tersedia 4, diminta 10"},
			{enCtx(), "insufficient stock: 4 available, 10 requested"},
		} {
			inv := &model.Inventory{ProductID: 1, Quantity: 4, LowStockThreshold: 10}
			mv := &model.StockMovement{Type: model.MovementOut, Quantity: 10}

			err := applyMovement(tt.lang, inv, mv)

			var verr *ValidationError
			require.ErrorAs(t, err, &verr)
			assert.Equal(t, "quantity", verr.Fields[0].Field)
			assert.Equal(t, tt.want, verr.Fields[0].Message)
		}
	})

	t.Run("movement type enum", func(t *testing.T) {
		for _, tt := range []struct {
			lang context.Context
			want string
		}{
			{idCtx(), "harus salah satu dari IN, OUT, ADJUSTMENT"},
			{enCtx(), "must be one of IN, OUT, ADJUSTMENT"},
		} {
			_, err := newMovement(tt.lang, model.CreateStockMovementInput{Type: "SELL"})

			var verr *ValidationError
			require.ErrorAs(t, err, &verr)
			assert.Equal(t, tt.want, verr.Fields[0].Message)
		}
	})
}

func TestCustomerMessagesAreTranslated(t *testing.T) {
	t.Run("email already used", func(t *testing.T) {
		for _, tt := range []struct {
			lang context.Context
			want string
		}{
			{idCtx(), "email sudah dipakai pelanggan lain"},
			{enCtx(), "email is already used by another customer"},
		} {
			repo := &mockCustomerRepo{}
			repo.On("Create", mock.Anything, mock.Anything).Return(repository.ErrDuplicateKey)
			svc := NewCustomerService(repo)

			_, err := svc.Create(tt.lang, model.CreateCustomerInput{Name: "Budi", Email: "budi@example.com"})

			require.ErrorIs(t, err, ErrConflict)
			assert.Contains(t, err.Error(), tt.want)
		}
	})

	t.Run("still has orders", func(t *testing.T) {
		for _, tt := range []struct {
			lang context.Context
			want string
		}{
			{idCtx(), "pelanggan 9 masih punya 2 pesanan yang belum dibatalkan"},
			{enCtx(), "customer 9 still has 2 sales order(s) that are not cancelled"},
		} {
			repo := &mockCustomerRepo{}
			repo.On("FindByID", mock.Anything, uint(9)).Return(&model.Customer{ID: 9, Name: "Budi"}, nil)
			repo.On("CountActiveOrders", mock.Anything, uint(9)).Return(int64(2), nil)
			svc := NewCustomerService(repo)

			err := svc.Delete(tt.lang, 9)

			require.ErrorIs(t, err, ErrConflict)
			assert.Contains(t, err.Error(), tt.want)
		}
	})

	t.Run("invalid email and phone", func(t *testing.T) {
		for _, tt := range []struct {
			lang  context.Context
			email string
			phone string
		}{
			{idCtx(), "format email tidak valid", "harus 6-32 digit, boleh memakai +, spasi, tanda hubung atau kurung"},
			{enCtx(), "must be a valid email address", "must be 6-32 digits, optionally with +, spaces, dashes or parentheses"},
		} {
			svc := NewCustomerService(&mockCustomerRepo{})

			_, err := svc.Create(tt.lang, model.CreateCustomerInput{Name: "Budi", Email: "nope", Phone: "abc"})

			var verr *ValidationError
			require.ErrorAs(t, err, &verr)
			require.Len(t, verr.Fields, 2)
			assert.Equal(t, tt.email, verr.Fields[0].Message)
			assert.Equal(t, tt.phone, verr.Fields[1].Message)
		}
	})
}

func TestSalesOrderMessagesAreTranslated(t *testing.T) {
	t.Run("invalid status transition", func(t *testing.T) {
		for _, tt := range []struct {
			lang context.Context
			want string
		}{
			{idCtx(), "tidak bisa mengubah status dari PENDING ke SHIPPED; yang diizinkan: CONFIRMED, CANCELLED"},
			{enCtx(), "can't change status from PENDING to SHIPPED; allowed: CONFIRMED, CANCELLED"},
		} {
			err := checkTransition(tt.lang, model.OrderPending, model.OrderShipped)

			var verr *ValidationError
			require.ErrorAs(t, err, &verr)
			assert.Equal(t, "status", verr.Fields[0].Field)
			assert.Equal(t, tt.want, verr.Fields[0].Message)
		}
	})

	t.Run("a final status cannot change", func(t *testing.T) {
		for _, tt := range []struct {
			lang context.Context
			want string
		}{
			{idCtx(), "pesanan dengan status SHIPPED tidak bisa diubah lagi"},
			{enCtx(), "an order that is SHIPPED can't change status anymore"},
		} {
			err := checkTransition(tt.lang, model.OrderShipped, model.OrderCancelled)

			var verr *ValidationError
			require.ErrorAs(t, err, &verr)
			assert.Equal(t, tt.want, verr.Fields[0].Message)
		}
	})

	t.Run("duplicate item and empty order", func(t *testing.T) {
		for _, tt := range []struct {
			lang      context.Context
			duplicate string
			items     string
		}{
			{idCtx(), "produk 3 sudah ada di items[0]; gabungkan jumlahnya", "minimal berisi satu item"},
			{enCtx(), "product 3 is already in items[0]; combine the quantities", "must contain at least one item"},
		} {
			err := validateOrderInput(tt.lang, model.CreateSalesOrderInput{
				CustomerID: 1,
				Items: []model.CreateOrderItemInput{
					{ProductID: 3, Quantity: 1},
					{ProductID: 3, Quantity: 2},
				},
			}, "")
			var verr *ValidationError
			require.ErrorAs(t, err, &verr)
			assert.Equal(t, tt.duplicate, verr.Fields[0].Message)

			err = validateOrderInput(tt.lang, model.CreateSalesOrderInput{CustomerID: 1}, "")
			require.ErrorAs(t, err, &verr)
			assert.Equal(t, tt.items, verr.Fields[0].Message)
		}
	})
}

func TestAnalyticsMessagesAreTranslated(t *testing.T) {
	newService := func() *analyticsService {
		svc := NewAnalyticsService(&mockAnalyticsRepo{}, nil, nil, nil, 0, 0, jakarta).(*analyticsService)
		svc.now = func() time.Time { return analyticsNow }
		return svc
	}

	t.Run("date range validation", func(t *testing.T) {
		for _, tt := range []struct {
			lang   context.Context
			format string
			order  string
		}{
			{idCtx(), "harus tanggal dengan format YYYY-MM-DD", "harus sama dengan atau sebelum to"},
			{enCtx(), "must be a date in YYYY-MM-DD format", "must be on or before to"},
		} {
			_, err := newService().Summary(tt.lang, model.AnalyticsQuery{From: "20-09-2026"})
			var verr *ValidationError
			require.ErrorAs(t, err, &verr)
			assert.Equal(t, tt.format, verr.Fields[0].Message)

			_, err = newService().Summary(tt.lang, model.AnalyticsQuery{From: "2026-09-20", To: "2026-01-01"})
			require.ErrorAs(t, err, &verr)
			assert.Equal(t, tt.order, verr.Fields[0].Message)
		}
	})

	t.Run("granularity enum", func(t *testing.T) {
		for _, tt := range []struct {
			lang context.Context
			want string
		}{
			{idCtx(), "harus daily atau weekly"},
			{enCtx(), "must be daily or weekly"},
		} {
			_, err := newService().SalesTrend(tt.lang, model.AnalyticsQuery{}, "hourly")

			var verr *ValidationError
			require.ErrorAs(t, err, &verr)
			assert.Equal(t, tt.want, verr.Fields[0].Message)
		}
	})

	t.Run("the request language is forwarded to the ML service", func(t *testing.T) {
		for _, tt := range []struct {
			lang context.Context
			want string
		}{
			{idCtx(), "id"},
			{enCtx(), "en"},
			{bareCtx(), "id"},
		} {
			ml := &fakeML{}
			svc, _ := forecastService(t, ml, nil, 1)

			_, err := svc.Insights(tt.lang, model.AnalyticsQuery{}, 1)

			require.NoError(t, err)
			require.Len(t, ml.trend, 1)
			assert.Equal(t, tt.want, ml.trend[0].Lang,
				"the ML service must write its summary in the language the caller asked for")
		}
	})

	t.Run("the forecasting service is unavailable", func(t *testing.T) {
		for _, tt := range []struct {
			lang context.Context
			want string
		}{
			{idCtx(), "layanan forecasting sedang tidak tersedia"},
			{enCtx(), "forecasting service is currently unavailable"},
		} {
			down := &fakeML{failFor: func(uint) error {
				return fmt.Errorf("%w: connection refused", client.ErrUnavailable)
			}}
			svc, _ := forecastService(t, down, nil, 1)

			report, err := svc.Forecast(tt.lang, model.AnalyticsQuery{}, 1, 0)

			require.NoError(t, err)
			assert.False(t, report.Available)
			assert.Equal(t, tt.want, report.Products[0].Error)
		}
	})
}
