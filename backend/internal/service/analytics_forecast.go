package service

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log/slog"

	"golang.org/x/sync/errgroup"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/client"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

// Forecasting calls a second service (Python, /ml-service) over HTTP while a
// user waits, once per product. Three rules follow from that:
//
//  1. The calls run in parallel, bounded by maxForecastConcurrency, so ten
//     products cost about one round trip instead of ten.
//  2. A product whose call fails carries its own Error; the response is still
//  200. If every product fails, Available is false — the dashboard says
//     "forecasting unavailable" instead of showing an error page.
//  3. Only a fully successful report is cached. Caching a broken one would
//     keep the dashboard degraded for the whole TTL after the ML service is
//     back up.
const (
	// defaultHorizonDays is how far ahead /analytics/forecast predicts.
	defaultHorizonDays = 7
	maxHorizonDays     = 90

	// minHistoryDays is what the ML service needs to answer at all: 3 points
	// for a forecast, 4 days for a trend comparison. Checking here turns one
	// bad range into a single 422 instead of N rejected calls.
	minHistoryDays = 4

	// maxForecastConcurrency bounds how hard one request hits the ML service.
	maxForecastConcurrency = 8

	// mlUnavailableMessage is what a product carries when the ML service
	// could not be reached. Kept generic: the detail is in the log, not in
	// an end-user's dashboard.
	mlUnavailableMessage = "layanan forecasting sedang tidak tersedia"
	mlFailedMessage      = "forecast gagal dihitung untuk produk ini"
)

// Forecast predicts demand for the best-selling products of the range.
func (s *analyticsService) Forecast(
	ctx context.Context,
	q model.AnalyticsQuery,
	limit, horizonDays int,
) (model.ForecastReport, error) {
	rng, products, err := s.forecastTargets(ctx, q, limit)
	if err != nil {
		return model.ForecastReport{}, err
	}
	if horizonDays <= 0 {
		horizonDays = defaultHorizonDays
	}
	horizonDays = min(horizonDays, maxHorizonDays)

	key := s.cacheKey("forecast", rng.From.Format(model.DateFormat), rng.To.Format(model.DateFormat),
		fmt.Sprint(len(products)), fmt.Sprint(horizonDays))
	if cached, ok := readCache[model.ForecastReport](ctx, s.forecastCache(), key); ok {
		cached.Range = rng // Start/End aren't serialized
		return cached, nil
	}

	history, err := s.repo.ProductDailySales(ctx, rng, productIDs(products))
	if err != nil {
		return model.ForecastReport{}, err
	}

	report := model.ForecastReport{Range: rng, HorizonDays: horizonDays, Products: make([]model.ProductForecast, len(products))}
	err = s.eachProduct(ctx, products, func(ctx context.Context, i int, p model.TopProduct) {
		item := model.ProductForecast{ProductID: p.ProductID, ProductName: p.Name, SKU: p.SKU}
		res, err := s.ml.ForecastDemand(ctx, client.ForecastRequest{
			ProductID:   p.ProductID,
			History:     history[p.ProductID],
			HorizonDays: horizonDays,
		})
		if err != nil {
			item.Error = mlErrorMessage(ctx, "forecast", p.ProductID, err)
		} else {
			item.Forecast, item.Method = res.Forecast, res.Method
		}
		report.Products[i] = item
	})
	if err != nil {
		return model.ForecastReport{}, err
	}

	report.Available = anySucceeded(report.Products, func(p model.ProductForecast) bool { return p.Error == "" })
	if report.Available && allSucceeded(report.Products, func(p model.ProductForecast) bool { return p.Error == "" }) {
		s.writeForecastCache(ctx, key, report)
	}
	return report, nil
}

// Insights turns the same history into one sentence per product.
func (s *analyticsService) Insights(ctx context.Context, q model.AnalyticsQuery, limit int) (model.InsightReport, error) {
	rng, products, err := s.forecastTargets(ctx, q, limit)
	if err != nil {
		return model.InsightReport{}, err
	}

	key := s.cacheKey("insights", rng.From.Format(model.DateFormat), rng.To.Format(model.DateFormat), fmt.Sprint(len(products)))
	if cached, ok := readCache[model.InsightReport](ctx, s.forecastCache(), key); ok {
		cached.Range = rng
		return cached, nil
	}

	history, err := s.repo.ProductDailySales(ctx, rng, productIDs(products))
	if err != nil {
		return model.InsightReport{}, err
	}

	report := model.InsightReport{Range: rng, Products: make([]model.ProductInsight, len(products))}
	err = s.eachProduct(ctx, products, func(ctx context.Context, i int, p model.TopProduct) {
		item := model.ProductInsight{ProductID: p.ProductID, ProductName: p.Name, SKU: p.SKU}
		res, err := s.ml.TrendInsight(ctx, client.TrendRequest{
			ProductID: p.ProductID,
			History:   history[p.ProductID],
		})
		if err != nil {
			item.Error = mlErrorMessage(ctx, "insight", p.ProductID, err)
		} else {
			change := res.ChangePercent
			item.Trend, item.ChangePercent, item.Summary = res.Trend, &change, res.Summary
		}
		report.Products[i] = item
	})
	if err != nil {
		return model.InsightReport{}, err
	}

	report.Available = anySucceeded(report.Products, func(p model.ProductInsight) bool { return p.Error == "" })
	if report.Available && allSucceeded(report.Products, func(p model.ProductInsight) bool { return p.Error == "" }) {
		s.writeForecastCache(ctx, key, report)
	}
	return report, nil
}

// forecastTargets resolves the range and the products to work on: the
// best-sellers of the range, reusing the top-products aggregation.
func (s *analyticsService) forecastTargets(
	ctx context.Context,
	q model.AnalyticsQuery,
	limit int,
) (model.AnalyticsRange, []model.TopProduct, error) {
	rng, err := s.parseRange(q)
	if err != nil {
		return model.AnalyticsRange{}, nil, err
	}
	if days := int(rng.End.Sub(rng.Start).Hours() / 24); days < minHistoryDays {
		return model.AnalyticsRange{}, nil, &ValidationError{Fields: []FieldError{{
			Field:   "from",
			Message: fmt.Sprintf("range must cover at least %d days to forecast", minHistoryDays),
		}}}
	}
	if limit <= 0 {
		limit = defaultTopProducts
	}
	limit = min(limit, maxTopProducts)

	products, err := s.repo.TopProducts(ctx, rng, limit)
	if err != nil {
		return model.AnalyticsRange{}, nil, err
	}
	return rng, products, nil
}

// eachProduct runs fn for every product in parallel, bounded, and waits for
// all of them. fn records its own outcome, so a slow or failing product never
// cancels its siblings; the returned error is only a context cancellation.
func (s *analyticsService) eachProduct(
	ctx context.Context,
	products []model.TopProduct,
	fn func(ctx context.Context, i int, p model.TopProduct),
) error {
	if len(products) == 0 {
		return nil
	}
	group, ctx := errgroup.WithContext(ctx)
	group.SetLimit(min(maxForecastConcurrency, len(products)))
	for i, p := range products {
		group.Go(func() error {
			if err := ctx.Err(); err != nil { // client went away
				return err
			}
			fn(ctx, i, p)
			return nil
		})
	}
	return group.Wait()
}

// mlErrorMessage logs the real cause and returns what the API shows.
func mlErrorMessage(ctx context.Context, op string, productID uint, err error) string {
	switch {
	case errors.Is(err, client.ErrUnavailable):
		slog.WarnContext(ctx, "ml service unavailable", "op", op, "product_id", productID, "error", err)
		return mlUnavailableMessage
	case errors.Is(err, client.ErrInvalidRequest):
		// Our payload was wrong — a bug here, not an outage there.
		slog.ErrorContext(ctx, "ml service rejected request", "op", op, "product_id", productID, "error", err)
		return mlFailedMessage
	default:
		slog.ErrorContext(ctx, "ml service call failed", "op", op, "product_id", productID, "error", err)
		return mlFailedMessage
	}
}

func productIDs(products []model.TopProduct) []uint {
	ids := make([]uint, len(products))
	for i, p := range products {
		ids[i] = p.ProductID
	}
	return ids
}

func anySucceeded[T any](items []T, ok func(T) bool) bool {
	if len(items) == 0 {
		return true // nothing to forecast is not an outage
	}
	for _, item := range items {
		if ok(item) {
			return true
		}
	}
	return false
}

func allSucceeded[T any](items []T, ok func(T) bool) bool {
	for _, item := range items {
		if !ok(item) {
			return false
		}
	}
	return true
}

// forecastCache is the cache for forecast/insight reports, or nil when their
// own TTL disables it.
func (s *analyticsService) forecastCache() Cache {
	if s.forecastTTL <= 0 {
		return nil
	}
	return s.cache
}

func (s *analyticsService) writeForecastCache(ctx context.Context, key string, value any) {
	c := s.forecastCache()
	if c == nil {
		return
	}
	if raw, err := json.Marshal(value); err == nil {
		c.Set(ctx, key, raw, s.forecastTTL)
	}
}
