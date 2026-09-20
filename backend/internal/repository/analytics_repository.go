package repository

import (
	"context"
	"fmt"
	"time"

	"gorm.io/gorm"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

// soldOrders is the definition of a "real sale" shared by every analytics
// query: the order is CONFIRMED or SHIPPED (PENDING hasn't taken stock,
// CANCELLED was undone) and was confirmed inside the range [start, end).
const soldOrders = `
	SELECT id, total_amount, confirmed_at
	FROM sales_orders
	WHERE status IN ('CONFIRMED', 'SHIPPED')
	  AND confirmed_at >= ? AND confirmed_at < ?`

// AnalyticsRepository aggregates sales data. Every query is a single
// aggregation executed by Postgres; rows are never summed in Go.
type AnalyticsRepository interface {
	Summary(ctx context.Context, r model.AnalyticsRange) (model.SalesSummary, error)
	// SalesTrend returns one point per period in the range, including
	// periods without sales (zeros).
	SalesTrend(ctx context.Context, r model.AnalyticsRange, g model.TrendGranularity) ([]model.SalesTrendPoint, error)
	TopProducts(ctx context.Context, r model.AnalyticsRange, limit int) ([]model.TopProduct, error)
	CategoryBreakdown(ctx context.Context, r model.AnalyticsRange) ([]model.CategoryRevenue, error)
}

type analyticsRepository struct {
	db *gorm.DB
	// loc is the time zone that defines calendar days (from config).
	loc *time.Location
}

func NewAnalyticsRepository(db *gorm.DB, loc *time.Location) AnalyticsRepository {
	return &analyticsRepository{db: db, loc: loc}
}

func (r *analyticsRepository) Summary(ctx context.Context, rng model.AnalyticsRange) (model.SalesSummary, error) {
	var row struct {
		TotalRevenue   int64
		TotalOrders    int64
		TotalItemsSold int64
	}
	query := `
		WITH sold AS (` + soldOrders + `)
		SELECT
			(SELECT COALESCE(SUM(total_amount), 0) FROM sold)                    AS total_revenue,
			(SELECT COUNT(*) FROM sold)                                          AS total_orders,
			(SELECT COALESCE(SUM(i.quantity), 0)
			   FROM sales_order_items i JOIN sold ON sold.id = i.sales_order_id) AS total_items_sold`
	if err := r.db.WithContext(ctx).Raw(query, rng.Start, rng.End).Scan(&row).Error; err != nil {
		return model.SalesSummary{}, fmt.Errorf("analytics summary: %w", err)
	}
	return model.SalesSummary{
		Range:          rng,
		TotalRevenue:   row.TotalRevenue,
		TotalOrders:    row.TotalOrders,
		TotalItemsSold: row.TotalItemsSold,
	}, nil
}

func (r *analyticsRepository) SalesTrend(ctx context.Context, rng model.AnalyticsRange, g model.TrendGranularity) ([]model.SalesTrendPoint, error) {
	// date_trunc('week') starts on Monday, so weekly buckets are ISO weeks.
	unit := "day"
	if g == model.GranularityWeekly {
		unit = "week"
	}
	// generate_series gives every period in the range, so a period without
	// sales comes back as zero instead of being missing from the chart.
	query := fmt.Sprintf(`
		WITH sold AS (%s),
		periods AS (
			SELECT generate_series(
				date_trunc('%[2]s', ?::timestamptz AT TIME ZONE ?),
				date_trunc('%[2]s', (?::timestamptz - interval '1 microsecond') AT TIME ZONE ?),
				interval '1 %[2]s'
			) AS period_start
		),
		totals AS (
			SELECT date_trunc('%[2]s', confirmed_at AT TIME ZONE ?) AS period_start,
			       SUM(total_amount) AS revenue,
			       COUNT(*)          AS orders
			FROM sold
			GROUP BY 1
		)
		SELECT p.period_start::date                       AS period_start,
		       (p.period_start + interval '1 %[2]s' - interval '1 day')::date AS period_end,
		       COALESCE(t.revenue, 0)                     AS revenue,
		       COALESCE(t.orders, 0)                      AS orders
		FROM periods p
		LEFT JOIN totals t ON t.period_start = p.period_start
		ORDER BY p.period_start`, soldOrders, unit)

	tz := r.loc.String()
	var rows []struct {
		PeriodStart time.Time
		PeriodEnd   time.Time
		Revenue     int64
		Orders      int64
	}
	err := r.db.WithContext(ctx).
		Raw(query, rng.Start, rng.End, rng.Start, tz, rng.End, tz, tz).
		Scan(&rows).Error
	if err != nil {
		return nil, fmt.Errorf("analytics sales trend: %w", err)
	}

	points := make([]model.SalesTrendPoint, len(rows))
	for i, row := range rows {
		points[i] = model.SalesTrendPoint{
			PeriodStart: model.NewDate(row.PeriodStart),
			PeriodEnd:   model.NewDate(row.PeriodEnd),
			Revenue:     row.Revenue,
			Orders:      row.Orders,
		}
	}
	return points, nil
}

func (r *analyticsRepository) TopProducts(ctx context.Context, rng model.AnalyticsRange, limit int) ([]model.TopProduct, error) {
	// SKU and name come from the order item snapshot, so renaming a product
	// later doesn't rewrite what was sold.
	query := `
		WITH sold AS (` + soldOrders + `)
		SELECT i.product_id,
		       MAX(i.product_sku)  AS sku,
		       MAX(i.product_name) AS name,
		       SUM(i.quantity)     AS quantity_sold,
		       SUM(i.subtotal)     AS revenue
		FROM sales_order_items i
		JOIN sold ON sold.id = i.sales_order_id
		GROUP BY i.product_id
		ORDER BY quantity_sold DESC, revenue DESC, i.product_id
		LIMIT ?`

	var rows []model.TopProduct
	if err := r.db.WithContext(ctx).Raw(query, rng.Start, rng.End, limit).Scan(&rows).Error; err != nil {
		return nil, fmt.Errorf("analytics top products: %w", err)
	}
	return rows, nil
}

func (r *analyticsRepository) CategoryBreakdown(ctx context.Context, rng model.AnalyticsRange) ([]model.CategoryRevenue, error) {
	// Soft-deleted products and categories are included on purpose: their
	// revenue really happened, and leaving it out would make the breakdown
	// disagree with the summary total.
	query := `
		WITH sold AS (` + soldOrders + `)
		SELECT c.id                                   AS category_id,
		       COALESCE(c.name, 'Tanpa Kategori')     AS category_name,
		       SUM(i.quantity)                        AS quantity_sold,
		       SUM(i.subtotal)                        AS revenue
		FROM sales_order_items i
		JOIN sold ON sold.id = i.sales_order_id
		LEFT JOIN products p   ON p.id = i.product_id
		LEFT JOIN categories c ON c.id = p.category_id
		GROUP BY c.id, c.name
		ORDER BY revenue DESC, category_name`

	var rows []model.CategoryRevenue
	if err := r.db.WithContext(ctx).Raw(query, rng.Start, rng.End).Scan(&rows).Error; err != nil {
		return nil, fmt.Errorf("analytics category breakdown: %w", err)
	}
	return rows, nil
}
