package service

import (
	"context"
	"encoding/json"
	"fmt"
	"math"
	"strings"
	"time"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

const (
	// defaultRangeDays is the range used when the request has no dates.
	defaultRangeDays = 30
	// maxRangeDays caps how much a single request may aggregate.
	maxRangeDays = 366

	defaultTopProducts = 10
	maxTopProducts     = 50

	// cacheKeyVersion is bumped when a payload shape changes, so old
	// entries can't be read back as the new type.
	cacheKeyVersion = "v1"
)

// Cache is the small part of a cache this service needs. Misses and errors
// look the same (a miss), so caching can never fail a request.
type Cache interface {
	Get(ctx context.Context, key string) ([]byte, bool)
	Set(ctx context.Context, key string, value []byte, ttl time.Duration)
}

type AnalyticsService interface {
	Summary(ctx context.Context, q model.AnalyticsQuery) (model.SalesSummary, error)
	SalesTrend(ctx context.Context, q model.AnalyticsQuery, granularity string) (model.SalesTrend, error)
	TopProducts(ctx context.Context, q model.AnalyticsQuery, limit int) ([]model.TopProduct, model.AnalyticsRange, error)
	CategoryBreakdown(ctx context.Context, q model.AnalyticsQuery) ([]model.CategoryRevenue, model.AnalyticsRange, error)
	// LowStockAlertCount is how many products are currently low on stock.
	LowStockAlertCount(ctx context.Context) (int64, error)
}

type analyticsService struct {
	repo repository.AnalyticsRepository
	// inventory is reused so the alert count uses exactly the same
	// low-stock rule as GET /inventory/low-stock.
	inventory InventoryService
	cache     Cache
	// cacheTTL of 0 disables caching.
	cacheTTL time.Duration
	loc      *time.Location
	now      func() time.Time
}

// NewAnalyticsService creates the service. Caching is off when cache is nil
// or cacheTTL is 0; summary and trend are the only cached queries, because
// they are the heavy ones the dashboard hits on every load.
func NewAnalyticsService(
	repo repository.AnalyticsRepository,
	inventory InventoryService,
	cache Cache,
	cacheTTL time.Duration,
	loc *time.Location,
) AnalyticsService {
	return &analyticsService{
		repo:      repo,
		inventory: inventory,
		cache:     cache,
		cacheTTL:  cacheTTL,
		loc:       loc,
		now:       time.Now,
	}
}

// Summary is cached: it is the most requested query of the dashboard.
func (s *analyticsService) Summary(ctx context.Context, q model.AnalyticsQuery) (model.SalesSummary, error) {
	rng, err := s.parseRange(q)
	if err != nil {
		return model.SalesSummary{}, err
	}

	key := s.cacheKey("summary", rng.From.Format(model.DateFormat), rng.To.Format(model.DateFormat))
	if cached, ok := readCache[model.SalesSummary](ctx, s.cacheStore(), key); ok {
		cached.Range = rng // Start/End aren't serialized; use the parsed range
		return cached, nil
	}

	summary, err := s.repo.Summary(ctx, rng)
	if err != nil {
		return model.SalesSummary{}, err
	}
	if summary.TotalOrders > 0 {
		summary.AverageOrderValue = int64(math.Round(float64(summary.TotalRevenue) / float64(summary.TotalOrders)))
	}

	s.writeCache(ctx, key, summary)
	return summary, nil
}

// SalesTrend is cached for the same reason as Summary.
func (s *analyticsService) SalesTrend(ctx context.Context, q model.AnalyticsQuery, granularity string) (model.SalesTrend, error) {
	rng, err := s.parseRange(q)
	if err != nil {
		return model.SalesTrend{}, err
	}
	g, err := parseGranularity(granularity)
	if err != nil {
		return model.SalesTrend{}, err
	}

	key := s.cacheKey("trend", string(g), rng.From.Format(model.DateFormat), rng.To.Format(model.DateFormat))
	if cached, ok := readCache[model.SalesTrend](ctx, s.cacheStore(), key); ok {
		cached.Range, cached.Granularity = rng, g
		return cached, nil
	}

	points, err := s.repo.SalesTrend(ctx, rng, g)
	if err != nil {
		return model.SalesTrend{}, err
	}
	trend := model.SalesTrend{Range: rng, Granularity: g, Points: points}

	s.writeCache(ctx, key, trend)
	return trend, nil
}

func (s *analyticsService) TopProducts(ctx context.Context, q model.AnalyticsQuery, limit int) ([]model.TopProduct, model.AnalyticsRange, error) {
	rng, err := s.parseRange(q)
	if err != nil {
		return nil, model.AnalyticsRange{}, err
	}
	if limit <= 0 {
		limit = defaultTopProducts
	}
	limit = min(limit, maxTopProducts)

	products, err := s.repo.TopProducts(ctx, rng, limit)
	if err != nil {
		return nil, rng, err
	}
	return products, rng, nil
}

func (s *analyticsService) CategoryBreakdown(ctx context.Context, q model.AnalyticsQuery) ([]model.CategoryRevenue, model.AnalyticsRange, error) {
	rng, err := s.parseRange(q)
	if err != nil {
		return nil, model.AnalyticsRange{}, err
	}
	rows, err := s.repo.CategoryBreakdown(ctx, rng)
	if err != nil {
		return nil, rng, err
	}
	return rows, rng, nil
}

func (s *analyticsService) LowStockAlertCount(ctx context.Context) (int64, error) {
	// Page size 1: only the total matters, the rows are thrown away.
	_, total, _, err := s.inventory.ListLowStock(ctx, model.ListLowStockParams{Page: 1, PageSize: 1})
	if err != nil {
		return 0, err
	}
	return total, nil
}

// parseRange validates the dates and turns them into a half-open time range
// in the app's time zone. Empty dates default to the last 30 days.
func (s *analyticsService) parseRange(q model.AnalyticsQuery) (model.AnalyticsRange, error) {
	v := &ValidationError{}
	today := s.now().In(s.loc)
	today = time.Date(today.Year(), today.Month(), today.Day(), 0, 0, 0, 0, s.loc)

	parse := func(field, value string) (time.Time, bool) {
		t, err := time.ParseInLocation(model.DateFormat, strings.TrimSpace(value), s.loc)
		if err != nil {
			v.add(field, "must be a date in YYYY-MM-DD format")
			return time.Time{}, false
		}
		return t, true
	}

	var from, to time.Time
	fromSet, toSet := strings.TrimSpace(q.From) != "", strings.TrimSpace(q.To) != ""
	if toSet {
		to, _ = parse("to", q.To)
	} else {
		to = today
	}
	if fromSet {
		from, _ = parse("from", q.From)
	} else {
		from = to.AddDate(0, 0, -(defaultRangeDays - 1))
	}
	if err := v.errOrNil(); err != nil {
		return model.AnalyticsRange{}, err
	}

	switch {
	case from.After(to):
		v.add("from", "must be on or before to")
	case int(to.Sub(from).Hours()/24)+1 > maxRangeDays:
		v.add("to", fmt.Sprintf("range must be at most %d days", maxRangeDays))
	}
	if err := v.errOrNil(); err != nil {
		return model.AnalyticsRange{}, err
	}

	return model.AnalyticsRange{
		From:  model.NewDate(from),
		To:    model.NewDate(to),
		Start: from,
		End:   to.AddDate(0, 0, 1), // half-open: includes all of "to"
	}, nil
}

func parseGranularity(value string) (model.TrendGranularity, error) {
	switch g := model.TrendGranularity(strings.ToLower(strings.TrimSpace(value))); g {
	case "":
		return model.GranularityDaily, nil
	case model.GranularityDaily, model.GranularityWeekly:
		return g, nil
	default:
		return "", &ValidationError{Fields: []FieldError{{
			Field: "granularity", Message: "must be daily or weekly",
		}}}
	}
}

func (s *analyticsService) cacheKey(parts ...string) string {
	return "analytics:" + cacheKeyVersion + ":" + strings.Join(parts, ":")
}

// readCache returns the decoded value on a hit. Unreadable entries (an old
// shape, corruption) count as a miss.
func readCache[T any](ctx context.Context, c Cache, key string) (T, bool) {
	var value T
	if c == nil {
		return value, false
	}
	raw, ok := c.Get(ctx, key)
	if !ok {
		return value, false
	}
	if err := json.Unmarshal(raw, &value); err != nil {
		var zero T
		return zero, false
	}
	return value, true
}

// cacheStore is the cache to use, or nil when caching is disabled.
func (s *analyticsService) cacheStore() Cache {
	if s.cacheTTL <= 0 {
		return nil
	}
	return s.cache
}

func (s *analyticsService) writeCache(ctx context.Context, key string, value any) {
	c := s.cacheStore()
	if c == nil {
		return
	}
	if raw, err := json.Marshal(value); err == nil {
		c.Set(ctx, key, raw, s.cacheTTL)
	}
}
