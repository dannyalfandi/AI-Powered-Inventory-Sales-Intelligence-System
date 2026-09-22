package service

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/client"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/i18n"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

// fakeML stands in for the Python service: per-product answers and errors,
// plus a counter, so the tests can check partial failure and caching.
type fakeML struct {
	// failFor decides the error for a product; nil means success.
	failFor func(productID uint) error
	// before runs inside every call, used to observe concurrency.
	before func()

	mu       sync.Mutex
	forecast []client.ForecastRequest
	trend    []client.TrendRequest
	calls    atomic.Int32
}

func (f *fakeML) ForecastDemand(_ context.Context, req client.ForecastRequest) (client.ForecastResponse, error) {
	f.calls.Add(1)
	if f.before != nil {
		f.before()
	}
	f.mu.Lock()
	f.forecast = append(f.forecast, req)
	f.mu.Unlock()

	if f.failFor != nil {
		if err := f.failFor(req.ProductID); err != nil {
			return client.ForecastResponse{}, err
		}
	}
	return client.ForecastResponse{
		ProductID: req.ProductID,
		Method:    "moving_average",
		Forecast: []model.ForecastPoint{
			{Date: model.NewDate(day("2026-09-21")), PredictedQuantity: 6.5},
		},
		WindowDays: 7,
	}, nil
}

func (f *fakeML) TrendInsight(_ context.Context, req client.TrendRequest) (client.TrendResponse, error) {
	f.calls.Add(1)
	if f.before != nil {
		f.before()
	}
	f.mu.Lock()
	f.trend = append(f.trend, req)
	f.mu.Unlock()

	if f.failFor != nil {
		if err := f.failFor(req.ProductID); err != nil {
			return client.TrendResponse{}, err
		}
	}
	return client.TrendResponse{
		Trend:         "increasing",
		ChangePercent: 32,
		Summary:       fmt.Sprintf("Penjualan produk %d naik 32,0%%", req.ProductID),
		WindowDays:    14,
	}, nil
}

func (m *mockAnalyticsRepo) ProductDailySales(ctx context.Context, r model.AnalyticsRange, ids []uint) (map[uint][]model.DailySales, error) {
	args := m.Called(ctx, r, ids)
	history, _ := args.Get(0).(map[uint][]model.DailySales)
	return history, args.Error(1)
}

func topProducts(ids ...uint) []model.TopProduct {
	products := make([]model.TopProduct, len(ids))
	for i, id := range ids {
		products[i] = model.TopProduct{
			ProductID: id, SKU: fmt.Sprintf("SKU-%d", id), Name: fmt.Sprintf("Produk %d", id),
			QuantitySold: int64(10 - i), Revenue: int64(1000 - i),
		}
	}
	return products
}

func salesHistory(ids ...uint) map[uint][]model.DailySales {
	history := map[uint][]model.DailySales{}
	for _, id := range ids {
		history[id] = []model.DailySales{
			{Date: model.NewDate(day("2026-09-18")), QuantitySold: 1},
			{Date: model.NewDate(day("2026-09-19")), QuantitySold: 2},
			{Date: model.NewDate(day("2026-09-20")), QuantitySold: 3},
		}
	}
	return history
}

// forecastService wires the fakes; the default range is the last 30 days.
func forecastService(t *testing.T, ml client.MLService, c Cache, ids ...uint) (*analyticsService, *mockAnalyticsRepo) {
	t.Helper()
	repo := &mockAnalyticsRepo{}
	repo.On("TopProducts", mock.Anything, mock.Anything, mock.Anything).Return(topProducts(ids...), nil).Maybe()
	repo.On("ProductDailySales", mock.Anything, mock.Anything, mock.Anything).Return(salesHistory(ids...), nil).Maybe()

	svc := NewAnalyticsService(repo, nil, ml, c, 5*time.Minute, 10*time.Minute, jakarta).(*analyticsService)
	svc.now = func() time.Time { return analyticsNow }
	return svc, repo
}

func TestForecast(t *testing.T) {
	t.Run("every product forecast, history and horizon passed through", func(t *testing.T) {
		ml := &fakeML{}
		svc, repo := forecastService(t, ml, nil, 1, 2, 3)

		report, err := svc.Forecast(context.Background(), model.AnalyticsQuery{}, 3, 0)

		require.NoError(t, err)
		assert.True(t, report.Available)
		assert.Equal(t, defaultHorizonDays, report.HorizonDays)
		require.Len(t, report.Products, 3)
		for i, item := range report.Products {
			assert.Empty(t, item.Error)
			assert.Equal(t, uint(i+1), item.ProductID)
			assert.Equal(t, fmt.Sprintf("Produk %d", i+1), item.ProductName)
			assert.Equal(t, fmt.Sprintf("SKU-%d", i+1), item.SKU)
			assert.Equal(t, "moving_average", item.Method)
			require.Len(t, item.Forecast, 1)
			assert.Equal(t, 6.5, item.Forecast[0].PredictedQuantity)
		}
		// The whole history goes to the ML service, one request per product.
		require.Len(t, ml.forecast, 3)
		assert.Len(t, ml.forecast[0].History, 3)
		assert.Equal(t, defaultHorizonDays, ml.forecast[0].HorizonDays)
		// One database round trip for all three products.
		repo.AssertNumberOfCalls(t, "ProductDailySales", 1)
	})

	t.Run("one failing product does not affect the others", func(t *testing.T) {
		ml := &fakeML{failFor: func(id uint) error {
			if id == 3 {
				return fmt.Errorf("%w: POST /forecast/demand: connection refused", client.ErrUnavailable)
			}
			return nil
		}}
		svc, _ := forecastService(t, ml, nil, 1, 2, 3, 4)

		report, err := svc.Forecast(context.Background(), model.AnalyticsQuery{}, 4, 7)

		require.NoError(t, err)
		assert.True(t, report.Available, "three of four worked, so forecasting is up")
		require.Len(t, report.Products, 4)
		for _, item := range report.Products {
			if item.ProductID == 3 {
				assert.Equal(t, i18n.Translate(i18n.KeyMLUnavailable, i18n.ID), item.Error)
				assert.Empty(t, item.Forecast)
				assert.Empty(t, item.Method)
				continue
			}
			assert.Empty(t, item.Error)
			assert.NotEmpty(t, item.Forecast)
		}
	})

	t.Run("ML service down: 200 with every product in error and available=false", func(t *testing.T) {
		ml := &fakeML{failFor: func(uint) error {
			return fmt.Errorf("%w: POST /forecast/demand: connection refused", client.ErrUnavailable)
		}}
		svc, _ := forecastService(t, ml, nil, 1, 2, 3)

		report, err := svc.Forecast(context.Background(), model.AnalyticsQuery{}, 3, 0)

		require.NoError(t, err, "an ML outage must never fail the request")
		assert.False(t, report.Available)
		require.Len(t, report.Products, 3)
		for _, item := range report.Products {
			assert.Equal(t, i18n.Translate(i18n.KeyMLUnavailable, i18n.ID), item.Error)
		}
	})

	t.Run("a rejected payload is reported as a per-product failure", func(t *testing.T) {
		ml := &fakeML{failFor: func(uint) error {
			return fmt.Errorf("%w: history too short", client.ErrInvalidRequest)
		}}
		svc, _ := forecastService(t, ml, nil, 1)

		report, err := svc.Forecast(context.Background(), model.AnalyticsQuery{}, 1, 0)

		require.NoError(t, err)
		assert.Equal(t, i18n.Translate(i18n.KeyMLFailed, i18n.ID), report.Products[0].Error)
		assert.False(t, report.Available)
	})

	t.Run("no sales in the range: an empty list, not an outage", func(t *testing.T) {
		ml := &fakeML{}
		svc, _ := forecastService(t, ml, nil)

		report, err := svc.Forecast(context.Background(), model.AnalyticsQuery{}, 10, 0)

		require.NoError(t, err)
		assert.True(t, report.Available)
		assert.Empty(t, report.Products)
		assert.Zero(t, ml.calls.Load())
	})

	t.Run("products are called in parallel, not one after another", func(t *testing.T) {
		const products = 4
		var running atomic.Int32
		var peak atomic.Int32
		barrier := make(chan struct{})
		ml := &fakeML{before: func() {
			current := running.Add(1)
			for {
				was := peak.Load()
				if current <= was || peak.CompareAndSwap(was, current) {
					break
				}
			}
			// Hold every call until all of them have arrived; with a
			// sequential implementation this would dead-lock and time out.
			if current == products {
				close(barrier)
			}
			<-barrier
			running.Add(-1)
		}}
		svc, _ := forecastService(t, ml, nil, 1, 2, 3, 4)

		done := make(chan struct{})
		go func() {
			_, err := svc.Forecast(context.Background(), model.AnalyticsQuery{}, products, 0)
			assert.NoError(t, err)
			close(done)
		}()

		select {
		case <-done:
			assert.EqualValues(t, products, peak.Load())
		case <-time.After(5 * time.Second):
			t.Fatal("forecast calls did not overlap: they are running sequentially")
		}
	})

	t.Run("the range must be long enough for the ML service to answer", func(t *testing.T) {
		ml := &fakeML{}
		svc, _ := forecastService(t, ml, nil, 1)

		_, err := svc.Forecast(context.Background(), model.AnalyticsQuery{From: "2026-09-19", To: "2026-09-20"}, 1, 0)

		var invalid *ValidationError
		require.ErrorAs(t, err, &invalid)
		assert.Equal(t, "from", invalid.Fields[0].Field)
		assert.Zero(t, ml.calls.Load(), "no point calling the ML service with a range it will reject")
	})

	t.Run("a database failure is still a real failure", func(t *testing.T) {
		repo := &mockAnalyticsRepo{}
		repo.On("TopProducts", mock.Anything, mock.Anything, mock.Anything).
			Return([]model.TopProduct(nil), errors.New("connection reset"))
		svc := NewAnalyticsService(repo, nil, &fakeML{}, nil, 0, 0, jakarta).(*analyticsService)
		svc.now = func() time.Time { return analyticsNow }

		_, err := svc.Forecast(context.Background(), model.AnalyticsQuery{}, 3, 0)

		assert.Error(t, err)
	})
}

func TestForecastCaching(t *testing.T) {
	t.Run("a complete report is served from the cache the second time", func(t *testing.T) {
		ml := &fakeML{}
		cache := newFakeCache()
		svc, _ := forecastService(t, ml, cache, 1, 2)

		first, err := svc.Forecast(context.Background(), model.AnalyticsQuery{}, 2, 0)
		require.NoError(t, err)
		second, err := svc.Forecast(context.Background(), model.AnalyticsQuery{}, 2, 0)
		require.NoError(t, err)

		// Compared as JSON: that is what clients see, and a cached date
		// legitimately comes back in a different time.Location.
		assert.JSONEq(t, marshal(t, first.Products), marshal(t, second.Products))
		assert.Equal(t, first.Range, second.Range, "the range survives the cache round trip")
		assert.EqualValues(t, 2, ml.calls.Load(), "the second request must not call the ML service again")
		assert.Equal(t, 10*time.Minute, cache.ttls[onlyKey(t, cache)])
	})

	t.Run("a report with failures is never cached", func(t *testing.T) {
		ml := &fakeML{failFor: func(id uint) error {
			if id == 2 {
				return fmt.Errorf("%w: connection refused", client.ErrUnavailable)
			}
			return nil
		}}
		cache := newFakeCache()
		svc, _ := forecastService(t, ml, cache, 1, 2)

		_, err := svc.Forecast(context.Background(), model.AnalyticsQuery{}, 2, 0)
		require.NoError(t, err)

		assert.Zero(t, cache.sets, "caching a degraded report would keep the dashboard broken after recovery")
	})

	t.Run("the horizon is part of the key", func(t *testing.T) {
		ml := &fakeML{}
		cache := newFakeCache()
		svc, _ := forecastService(t, ml, cache, 1)

		_, err := svc.Forecast(context.Background(), model.AnalyticsQuery{}, 1, 7)
		require.NoError(t, err)
		_, err = svc.Forecast(context.Background(), model.AnalyticsQuery{}, 1, 14)
		require.NoError(t, err)

		assert.EqualValues(t, 2, ml.calls.Load())
		assert.Len(t, cache.entries, 2)
	})
}

func TestInsights(t *testing.T) {
	t.Run("one sentence per product", func(t *testing.T) {
		ml := &fakeML{}
		svc, _ := forecastService(t, ml, nil, 1, 2)

		report, err := svc.Insights(context.Background(), model.AnalyticsQuery{}, 2)

		require.NoError(t, err)
		assert.True(t, report.Available)
		require.Len(t, report.Products, 2)
		assert.Equal(t, "increasing", report.Products[0].Trend)
		require.NotNil(t, report.Products[0].ChangePercent)
		assert.Equal(t, 32.0, *report.Products[0].ChangePercent)
		assert.Equal(t, "Penjualan produk 1 naik 32,0%", report.Products[0].Summary)
		assert.Len(t, ml.trend, 2)
	})

	t.Run("partial failure keeps the successful sentences", func(t *testing.T) {
		ml := &fakeML{failFor: func(id uint) error {
			if id == 1 {
				return fmt.Errorf("%w: connection refused", client.ErrUnavailable)
			}
			return nil
		}}
		svc, _ := forecastService(t, ml, nil, 1, 2)

		report, err := svc.Insights(context.Background(), model.AnalyticsQuery{}, 2)

		require.NoError(t, err)
		assert.True(t, report.Available)
		assert.Equal(t, i18n.Translate(i18n.KeyMLUnavailable, i18n.ID), report.Products[0].Error)
		assert.Nil(t, report.Products[0].ChangePercent, "a failed product has no number at all")
		assert.NotEmpty(t, report.Products[1].Summary)
	})

	t.Run("ML service down: available=false, no error", func(t *testing.T) {
		ml := &fakeML{failFor: func(uint) error {
			return fmt.Errorf("%w: connection refused", client.ErrUnavailable)
		}}
		svc, _ := forecastService(t, ml, nil, 1, 2)

		report, err := svc.Insights(context.Background(), model.AnalyticsQuery{}, 2)

		require.NoError(t, err)
		assert.False(t, report.Available)
		assert.Equal(t, i18n.Translate(i18n.KeyMLUnavailable, i18n.ID), report.Products[1].Error)
	})

	t.Run("a real 0% change is reported, not dropped", func(t *testing.T) {
		ml := &fakeML{}
		svc, _ := forecastService(t, ml, nil, 1)
		stable := &stableML{}
		svc.ml = stable

		report, err := svc.Insights(context.Background(), model.AnalyticsQuery{}, 1)

		require.NoError(t, err)
		require.NotNil(t, report.Products[0].ChangePercent)
		assert.Zero(t, *report.Products[0].ChangePercent)
		assert.Equal(t, "stable", report.Products[0].Trend)
	})
}

// stableML always answers "stable, 0%", the case a plain float field would
// make indistinguishable from "no result".
type stableML struct{ fakeML }

func (s *stableML) TrendInsight(context.Context, client.TrendRequest) (client.TrendResponse, error) {
	return client.TrendResponse{Trend: "stable", ChangePercent: 0, Summary: "Penjualan relatif stabil"}, nil
}

func onlyKey(t *testing.T, c *fakeCache) string {
	t.Helper()
	require.Len(t, c.entries, 1)
	for key := range c.entries {
		return key
	}
	return ""
}

func marshal(t *testing.T, value any) string {
	t.Helper()
	raw, err := json.Marshal(value)
	require.NoError(t, err)
	return string(raw)
}
