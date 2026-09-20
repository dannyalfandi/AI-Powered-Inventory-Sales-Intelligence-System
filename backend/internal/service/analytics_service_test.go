package service

import (
	"context"
	"encoding/json"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

type mockAnalyticsRepo struct {
	mock.Mock
}

func (m *mockAnalyticsRepo) Summary(ctx context.Context, r model.AnalyticsRange) (model.SalesSummary, error) {
	args := m.Called(ctx, r)
	return args.Get(0).(model.SalesSummary), args.Error(1)
}

func (m *mockAnalyticsRepo) SalesTrend(ctx context.Context, r model.AnalyticsRange, g model.TrendGranularity) ([]model.SalesTrendPoint, error) {
	args := m.Called(ctx, r, g)
	points, _ := args.Get(0).([]model.SalesTrendPoint)
	return points, args.Error(1)
}

func (m *mockAnalyticsRepo) TopProducts(ctx context.Context, r model.AnalyticsRange, limit int) ([]model.TopProduct, error) {
	args := m.Called(ctx, r, limit)
	products, _ := args.Get(0).([]model.TopProduct)
	return products, args.Error(1)
}

func (m *mockAnalyticsRepo) CategoryBreakdown(ctx context.Context, r model.AnalyticsRange) ([]model.CategoryRevenue, error) {
	args := m.Called(ctx, r)
	rows, _ := args.Get(0).([]model.CategoryRevenue)
	return rows, args.Error(1)
}

// mockInventoryService stands in for the real inventory service, so the
// alert count is verified to go through it (not a second copy of the rule).
type mockInventoryService struct {
	mock.Mock
	InventoryService
}

func (m *mockInventoryService) ListLowStock(ctx context.Context, params model.ListLowStockParams) ([]model.LowStockItem, int64, model.ListLowStockParams, error) {
	args := m.Called(ctx, params)
	items, _ := args.Get(0).([]model.LowStockItem)
	return items, args.Get(1).(int64), params, args.Error(3)
}

// fakeCache records what the service reads and writes.
type fakeCache struct {
	entries map[string][]byte
	ttls    map[string]time.Duration
	gets    int
	sets    int
}

func newFakeCache() *fakeCache {
	return &fakeCache{entries: map[string][]byte{}, ttls: map[string]time.Duration{}}
}

func (c *fakeCache) Get(_ context.Context, key string) ([]byte, bool) {
	c.gets++
	v, ok := c.entries[key]
	return v, ok
}

func (c *fakeCache) Set(_ context.Context, key string, value []byte, ttl time.Duration) {
	c.sets++
	c.entries[key] = value
	c.ttls[key] = ttl
}

var analyticsNow = time.Date(2026, 9, 20, 10, 0, 0, 0, time.UTC)

func newAnalyticsService(repo *mockAnalyticsRepo, inv InventoryService, c Cache) *analyticsService {
	svc := NewAnalyticsService(repo, inv, c, 5*time.Minute, jakarta).(*analyticsService)
	svc.now = func() time.Time { return analyticsNow }
	return svc
}

func day(s string) time.Time {
	t, err := time.ParseInLocation(model.DateFormat, s, jakarta)
	if err != nil {
		panic(err)
	}
	return t
}

// rangeOf builds the range the service is expected to pass to the repository.
func rangeOf(from, to string) model.AnalyticsRange {
	return model.AnalyticsRange{
		From:  model.NewDate(day(from)),
		To:    model.NewDate(day(to)),
		Start: day(from),
		End:   day(to).AddDate(0, 0, 1),
	}
}

func TestAnalyticsService_DateRange(t *testing.T) {
	tests := []struct {
		name        string
		query       model.AnalyticsQuery
		wantRange   model.AnalyticsRange
		wantInvalid []string
	}{
		{
			// "now" is 2026-09-20 10:00 UTC = 17:00 in Jakarta, still the 20th.
			name:      "no dates: last 30 days ending today",
			query:     model.AnalyticsQuery{},
			wantRange: rangeOf("2026-08-22", "2026-09-20"),
		},
		{
			name:      "only from: to defaults to today",
			query:     model.AnalyticsQuery{From: "2026-09-01"},
			wantRange: rangeOf("2026-09-01", "2026-09-20"),
		},
		{
			name:      "only to: 30 days ending there",
			query:     model.AnalyticsQuery{To: "2026-01-31"},
			wantRange: rangeOf("2026-01-02", "2026-01-31"),
		},
		{
			name:      "both dates, whitespace trimmed; single day is allowed",
			query:     model.AnalyticsQuery{From: " 2026-09-20 ", To: "2026-09-20"},
			wantRange: rangeOf("2026-09-20", "2026-09-20"),
		},
		{
			name:      "exactly the maximum range",
			query:     model.AnalyticsQuery{From: "2025-09-20", To: "2026-09-20"},
			wantRange: rangeOf("2025-09-20", "2026-09-20"),
		},
		{
			name:        "bad formats are reported per field",
			query:       model.AnalyticsQuery{From: "20-09-2026", To: "yesterday"},
			wantInvalid: []string{"from", "to"},
		},
		{
			name:        "from after to",
			query:       model.AnalyticsQuery{From: "2026-09-21", To: "2026-09-20"},
			wantInvalid: []string{"from"},
		},
		{
			name:        "range longer than a year",
			query:       model.AnalyticsQuery{From: "2025-09-19", To: "2026-09-20"},
			wantInvalid: []string{"to"},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockAnalyticsRepo{}
			if tt.wantInvalid == nil {
				repo.On("Summary", mock.Anything, tt.wantRange).Return(model.SalesSummary{Range: tt.wantRange}, nil)
			}
			svc := newAnalyticsService(repo, &mockInventoryService{}, nil)

			summary, err := svc.Summary(context.Background(), tt.query)

			if tt.wantInvalid != nil {
				assert.ElementsMatch(t, tt.wantInvalid, validationFields(t, err))
				repo.AssertNotCalled(t, "Summary", mock.Anything, mock.Anything)
				return
			}
			require.NoError(t, err)
			assert.Equal(t, tt.wantRange.From.Format(model.DateFormat), summary.Range.From.Format(model.DateFormat))
			// End is exclusive: the whole "to" day is included.
			assert.Equal(t, tt.wantRange.End, summary.Range.End)
			repo.AssertExpectations(t)
		})
	}
}

func TestAnalyticsService_Summary(t *testing.T) {
	rng := rangeOf("2026-09-01", "2026-09-20")
	query := model.AnalyticsQuery{From: "2026-09-01", To: "2026-09-20"}

	t.Run("average order value is revenue / orders, rounded", func(t *testing.T) {
		cases := []struct {
			revenue, orders, want int64
		}{
			{revenue: 300000, orders: 3, want: 100000},
			{revenue: 1001, orders: 3, want: 334}, // 333.67 rounds up
			{revenue: 1000, orders: 3, want: 333}, // 333.33 rounds down
			{revenue: 0, orders: 0, want: 0},      // no orders: no division
		}
		for _, c := range cases {
			repo := &mockAnalyticsRepo{}
			repo.On("Summary", mock.Anything, rng).
				Return(model.SalesSummary{Range: rng, TotalRevenue: c.revenue, TotalOrders: c.orders}, nil)
			svc := newAnalyticsService(repo, &mockInventoryService{}, nil)

			summary, err := svc.Summary(context.Background(), query)

			require.NoError(t, err)
			assert.Equal(t, c.want, summary.AverageOrderValue)
		}
	})

	t.Run("second call is served from cache", func(t *testing.T) {
		repo := &mockAnalyticsRepo{}
		repo.On("Summary", mock.Anything, rng).
			Return(model.SalesSummary{Range: rng, TotalRevenue: 500, TotalOrders: 2, TotalItemsSold: 7}, nil).Once()
		cache := newFakeCache()
		svc := newAnalyticsService(repo, &mockInventoryService{}, cache)

		first, err := svc.Summary(context.Background(), query)
		require.NoError(t, err)
		second, err := svc.Summary(context.Background(), query)
		require.NoError(t, err)

		assert.Equal(t, first, second, "cached payload must round-trip, dates included")
		assert.Equal(t, int64(250), second.AverageOrderValue)
		assert.Equal(t, 1, cache.sets)
		repo.AssertNumberOfCalls(t, "Summary", 1)
		assert.Equal(t, 5*time.Minute, cache.ttls["analytics:v1:summary:2026-09-01:2026-09-20"])
	})

	t.Run("a different range is a different cache key", func(t *testing.T) {
		other := rangeOf("2026-09-02", "2026-09-20")
		repo := &mockAnalyticsRepo{}
		repo.On("Summary", mock.Anything, rng).Return(model.SalesSummary{Range: rng, TotalRevenue: 1}, nil).Once()
		repo.On("Summary", mock.Anything, other).Return(model.SalesSummary{Range: other, TotalRevenue: 2}, nil).Once()
		cache := newFakeCache()
		svc := newAnalyticsService(repo, &mockInventoryService{}, cache)

		_, err := svc.Summary(context.Background(), query)
		require.NoError(t, err)
		second, err := svc.Summary(context.Background(), model.AnalyticsQuery{From: "2026-09-02", To: "2026-09-20"})

		require.NoError(t, err)
		assert.Equal(t, int64(2), second.TotalRevenue)
		assert.Len(t, cache.entries, 2)
	})

	t.Run("unreadable cache entry falls back to the database", func(t *testing.T) {
		repo := &mockAnalyticsRepo{}
		repo.On("Summary", mock.Anything, rng).Return(model.SalesSummary{Range: rng, TotalRevenue: 9}, nil).Once()
		cache := newFakeCache()
		cache.entries["analytics:v1:summary:2026-09-01:2026-09-20"] = []byte("{not json")
		svc := newAnalyticsService(repo, &mockInventoryService{}, cache)

		summary, err := svc.Summary(context.Background(), query)

		require.NoError(t, err)
		assert.Equal(t, int64(9), summary.TotalRevenue)
	})

	t.Run("works without a cache", func(t *testing.T) {
		repo := &mockAnalyticsRepo{}
		repo.On("Summary", mock.Anything, rng).Return(model.SalesSummary{Range: rng, TotalRevenue: 7, TotalOrders: 1}, nil).Twice()
		svc := newAnalyticsService(repo, &mockInventoryService{}, nil)

		for range 2 {
			summary, err := svc.Summary(context.Background(), query)
			require.NoError(t, err)
			assert.Equal(t, int64(7), summary.TotalRevenue)
		}
	})
}

func TestAnalyticsService_SalesTrend(t *testing.T) {
	rng := rangeOf("2026-09-01", "2026-09-20")
	query := model.AnalyticsQuery{From: "2026-09-01", To: "2026-09-20"}
	points := []model.SalesTrendPoint{
		{PeriodStart: model.NewDate(day("2026-09-01")), PeriodEnd: model.NewDate(day("2026-09-01")), Revenue: 100, Orders: 1},
	}

	t.Run("granularity", func(t *testing.T) {
		cases := []struct {
			in   string
			want model.TrendGranularity
		}{
			{in: "", want: model.GranularityDaily},
			{in: "daily", want: model.GranularityDaily},
			{in: " WEEKLY ", want: model.GranularityWeekly},
		}
		for _, c := range cases {
			repo := &mockAnalyticsRepo{}
			repo.On("SalesTrend", mock.Anything, rng, c.want).Return(points, nil)
			svc := newAnalyticsService(repo, &mockInventoryService{}, nil)

			trend, err := svc.SalesTrend(context.Background(), query, c.in)

			require.NoError(t, err)
			assert.Equal(t, c.want, trend.Granularity)
			repo.AssertExpectations(t)
		}
	})

	t.Run("unknown granularity", func(t *testing.T) {
		repo := &mockAnalyticsRepo{}
		svc := newAnalyticsService(repo, &mockInventoryService{}, nil)

		_, err := svc.SalesTrend(context.Background(), query, "hourly")

		assert.Equal(t, []string{"granularity"}, validationFields(t, err))
		repo.AssertNotCalled(t, "SalesTrend", mock.Anything, mock.Anything, mock.Anything)
	})

	t.Run("daily and weekly are cached separately", func(t *testing.T) {
		repo := &mockAnalyticsRepo{}
		repo.On("SalesTrend", mock.Anything, rng, model.GranularityDaily).Return(points, nil).Once()
		repo.On("SalesTrend", mock.Anything, rng, model.GranularityWeekly).Return(points, nil).Once()
		cache := newFakeCache()
		svc := newAnalyticsService(repo, &mockInventoryService{}, cache)

		for _, g := range []string{"daily", "weekly", "daily", "weekly"} {
			_, err := svc.SalesTrend(context.Background(), query, g)
			require.NoError(t, err)
		}

		repo.AssertExpectations(t)
		assert.Len(t, cache.entries, 2)
		_, hasDaily := cache.entries["analytics:v1:trend:daily:2026-09-01:2026-09-20"]
		_, hasWeekly := cache.entries["analytics:v1:trend:weekly:2026-09-01:2026-09-20"]
		assert.True(t, hasDaily && hasWeekly)
	})

	t.Run("cached points keep their dates", func(t *testing.T) {
		repo := &mockAnalyticsRepo{}
		repo.On("SalesTrend", mock.Anything, rng, model.GranularityDaily).Return(points, nil).Once()
		cache := newFakeCache()
		svc := newAnalyticsService(repo, &mockInventoryService{}, cache)

		_, err := svc.SalesTrend(context.Background(), query, "daily")
		require.NoError(t, err)
		cached, err := svc.SalesTrend(context.Background(), query, "daily")

		require.NoError(t, err)
		require.Len(t, cached.Points, 1)
		assert.Equal(t, "2026-09-01", cached.Points[0].PeriodStart.Format(model.DateFormat))
		assert.Equal(t, int64(100), cached.Points[0].Revenue)
	})
}

func TestAnalyticsService_TopProductsAndCategories(t *testing.T) {
	rng := rangeOf("2026-09-01", "2026-09-20")
	query := model.AnalyticsQuery{From: "2026-09-01", To: "2026-09-20"}

	limits := []struct {
		in, want int
	}{
		{in: 0, want: 10},   // default
		{in: -5, want: 10},  // nonsense falls back to the default
		{in: 3, want: 3},    // as asked
		{in: 999, want: 50}, // clamped
	}
	for _, l := range limits {
		t.Run("limit", func(t *testing.T) {
			repo := &mockAnalyticsRepo{}
			repo.On("TopProducts", mock.Anything, rng, l.want).Return([]model.TopProduct{}, nil)
			svc := newAnalyticsService(repo, &mockInventoryService{}, nil)

			_, gotRange, err := svc.TopProducts(context.Background(), query, l.in)

			require.NoError(t, err)
			assert.Equal(t, rng.End, gotRange.End)
			repo.AssertExpectations(t)
		})
	}

	t.Run("top products are not cached (cheap and often filtered)", func(t *testing.T) {
		repo := &mockAnalyticsRepo{}
		repo.On("TopProducts", mock.Anything, rng, 10).Return([]model.TopProduct{}, nil).Twice()
		cache := newFakeCache()
		svc := newAnalyticsService(repo, &mockInventoryService{}, cache)

		for range 2 {
			_, _, err := svc.TopProducts(context.Background(), query, 0)
			require.NoError(t, err)
		}

		repo.AssertExpectations(t)
		assert.Empty(t, cache.entries)
	})

	t.Run("category breakdown passes the validated range", func(t *testing.T) {
		repo := &mockAnalyticsRepo{}
		rows := []model.CategoryRevenue{{CategoryName: "Minuman", Revenue: 500, QuantitySold: 2}}
		repo.On("CategoryBreakdown", mock.Anything, rng).Return(rows, nil)
		svc := newAnalyticsService(repo, &mockInventoryService{}, nil)

		got, gotRange, err := svc.CategoryBreakdown(context.Background(), query)

		require.NoError(t, err)
		assert.Equal(t, rows, got)
		assert.Equal(t, rng.Start, gotRange.Start)
	})

	t.Run("invalid dates are rejected before querying", func(t *testing.T) {
		repo := &mockAnalyticsRepo{}
		svc := newAnalyticsService(repo, &mockInventoryService{}, nil)
		bad := model.AnalyticsQuery{From: "2026-13-01"}

		_, _, topErr := svc.TopProducts(context.Background(), bad, 5)
		_, _, catErr := svc.CategoryBreakdown(context.Background(), bad)

		assert.Equal(t, []string{"from"}, validationFields(t, topErr))
		assert.Equal(t, []string{"from"}, validationFields(t, catErr))
		repo.AssertNotCalled(t, "TopProducts", mock.Anything, mock.Anything, mock.Anything)
		repo.AssertNotCalled(t, "CategoryBreakdown", mock.Anything, mock.Anything)
	})
}

func TestAnalyticsService_LowStockAlertCount(t *testing.T) {
	t.Run("delegates to the inventory service and returns its total", func(t *testing.T) {
		inv := &mockInventoryService{}
		inv.On("ListLowStock", mock.Anything, model.ListLowStockParams{Page: 1, PageSize: 1}).
			Return([]model.LowStockItem{{ProductID: 3}}, int64(7), model.ListLowStockParams{}, nil)
		svc := newAnalyticsService(&mockAnalyticsRepo{}, inv, nil)

		count, err := svc.LowStockAlertCount(context.Background())

		require.NoError(t, err)
		assert.Equal(t, int64(7), count)
		inv.AssertExpectations(t)
	})

	t.Run("propagates failures", func(t *testing.T) {
		inv := &mockInventoryService{}
		inv.On("ListLowStock", mock.Anything, mock.Anything).
			Return(nil, int64(0), model.ListLowStockParams{}, errDB)
		svc := newAnalyticsService(&mockAnalyticsRepo{}, inv, nil)

		_, err := svc.LowStockAlertCount(context.Background())

		assert.ErrorIs(t, err, errDB)
	})
}

func TestDateJSON(t *testing.T) {
	d := model.NewDate(day("2026-09-20"))

	raw, err := json.Marshal(d)
	require.NoError(t, err)
	assert.Equal(t, `"2026-09-20"`, string(raw))

	var back model.Date
	require.NoError(t, json.Unmarshal(raw, &back))
	assert.Equal(t, "2026-09-20", back.Format(model.DateFormat))
}
