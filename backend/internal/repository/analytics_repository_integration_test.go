package repository_test

// Integration tests for the analytics SQL. The rule that only CONFIRMED and
// SHIPPED orders count lives in the queries themselves, so a mock can't
// prove it — this runs against a real Postgres.
//
// Run:
//
//	TEST_DATABASE_URL="postgres://user:pass@localhost:5433/inventory_intel?sslmode=disable" \
//	  go test ./internal/repository -run Analytics -v
//
// Without TEST_DATABASE_URL the tests skip. Everything is written inside one
// transaction that is always rolled back, so the database keeps its data.

import (
	"context"
	"fmt"
	"os"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

var jakarta = func() *time.Location {
	loc, err := time.LoadLocation("Asia/Jakarta")
	if err != nil {
		panic(err)
	}
	return loc
}()

// seeded is the fixture: two sold orders (CONFIRMED + SHIPPED) that must be
// counted, and a PENDING and a CANCELLED one that must not.
type seeded struct {
	kopiID, tehID, gulaID uint
	minumanID             uint
}

// setup opens the test database, starts a transaction, seeds it and returns
// a repository bound to that transaction. The transaction is rolled back
// when the test ends.
func setup(t *testing.T) (repository.AnalyticsRepository, seeded) {
	t.Helper()
	dsn := os.Getenv("TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("set TEST_DATABASE_URL to run analytics SQL tests against a real Postgres")
	}

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{Logger: logger.Default.LogMode(logger.Silent)})
	require.NoError(t, err)
	sqlDB, err := db.DB()
	require.NoError(t, err)
	t.Cleanup(func() { _ = sqlDB.Close() })

	tx := db.Begin()
	require.NoError(t, tx.Error)
	t.Cleanup(func() { tx.Rollback() })

	return repository.NewAnalyticsRepository(tx, jakarta), seed(t, tx)
}

func seed(t *testing.T, tx *gorm.DB) seeded {
	t.Helper()
	unique := time.Now().UnixNano()

	category := model.Category{Name: fmt.Sprintf("Minuman %d", unique)}
	require.NoError(t, tx.Create(&category).Error)

	// Gula has no category, to cover the "Tanpa Kategori" bucket.
	kopi := model.Product{SKU: fmt.Sprintf("IT-KOPI-%d", unique), Name: "Kopi", Price: 45000, CategoryID: &category.ID}
	teh := model.Product{SKU: fmt.Sprintf("IT-TEH-%d", unique), Name: "Teh", Price: 10000, CategoryID: &category.ID}
	gula := model.Product{SKU: fmt.Sprintf("IT-GULA-%d", unique), Name: "Gula", Price: 5000}
	for _, p := range []*model.Product{&kopi, &teh, &gula} {
		require.NoError(t, tx.Create(p).Error)
	}

	customer := model.Customer{Name: fmt.Sprintf("IT Customer %d", unique)}
	require.NoError(t, tx.Create(&customer).Error)

	at := func(day, hour, minute int) *time.Time {
		ts := time.Date(2026, 3, day, hour, minute, 0, 0, jakarta)
		return &ts
	}
	// Sold: 2026-03-10 → Kopi×2 (90k) + Teh×3 (30k) = 120k
	//       2026-03-12 → Kopi×1 (45k) + Gula×4 (20k) = 65k  (SHIPPED)
	// Not sold: PENDING 500k on 2026-03-11, CANCELLED 300k on 2026-03-11.
	newOrder := func(number string, status model.OrderStatus, total int64, confirmed *time.Time, items []model.SalesOrderItem) {
		order := model.SalesOrder{
			OrderNumber: fmt.Sprintf("%s-%d", number, unique),
			CustomerID:  customer.ID,
			Status:      status,
			TotalAmount: total,
			ConfirmedAt: confirmed,
		}
		require.NoError(t, tx.Omit("Customer", "Items").Create(&order).Error)
		for i := range items {
			items[i].SalesOrderID = order.ID
			require.NoError(t, tx.Omit("Product", "SalesOrder").Create(&items[i]).Error)
		}
	}
	item := func(p model.Product, qty int64) model.SalesOrderItem {
		return model.SalesOrderItem{
			ProductID: p.ID, ProductSKU: p.SKU, ProductName: p.Name,
			Quantity: qty, UnitPrice: p.Price, Subtotal: p.Price * qty,
		}
	}

	newOrder("IT-A", model.OrderConfirmed, 120000, at(10, 9, 0), []model.SalesOrderItem{item(kopi, 2), item(teh, 3)})
	newOrder("IT-B", model.OrderShipped, 65000, at(12, 20, 0), []model.SalesOrderItem{item(kopi, 1), item(gula, 4)})
	newOrder("IT-C", model.OrderPending, 500000, nil, []model.SalesOrderItem{item(kopi, 10)})
	newOrder("IT-D", model.OrderCancelled, 300000, at(11, 9, 0), []model.SalesOrderItem{item(teh, 30)})
	// Just outside the range: 2026-03-14 00:30 Jakarta.
	newOrder("IT-E", model.OrderConfirmed, 999000, at(14, 0, 30), []model.SalesOrderItem{item(kopi, 100)})

	return seeded{kopiID: kopi.ID, tehID: teh.ID, gulaID: gula.ID, minumanID: category.ID}
}

// march is the range 2026-03-09 .. 2026-03-13 (inclusive).
func march() model.AnalyticsRange {
	from := time.Date(2026, 3, 9, 0, 0, 0, 0, jakarta)
	to := time.Date(2026, 3, 13, 0, 0, 0, 0, jakarta)
	return model.AnalyticsRange{
		From:  model.NewDate(from),
		To:    model.NewDate(to),
		Start: from,
		End:   to.AddDate(0, 0, 1),
	}
}

func TestAnalyticsRepository_SummaryCountsOnlySoldOrders(t *testing.T) {
	repo, _ := setup(t)

	got, err := repo.Summary(context.Background(), march())

	require.NoError(t, err)
	// 120000 + 65000; the PENDING (500k), CANCELLED (300k) and out-of-range
	// (999k) orders must not show up anywhere.
	assert.Equal(t, int64(185000), got.TotalRevenue)
	assert.Equal(t, int64(2), got.TotalOrders)
	assert.Equal(t, int64(2+3+1+4), got.TotalItemsSold)
}

func TestAnalyticsRepository_RangeBoundaries(t *testing.T) {
	repo, _ := setup(t)
	ctx := context.Background()

	t.Run("the last day is included in full", func(t *testing.T) {
		// 2026-03-12 is the last day: the 20:00 order must count.
		from := time.Date(2026, 3, 12, 0, 0, 0, 0, jakarta)
		rng := model.AnalyticsRange{
			From: model.NewDate(from), To: model.NewDate(from),
			Start: from, End: from.AddDate(0, 0, 1),
		}

		got, err := repo.Summary(ctx, rng)

		require.NoError(t, err)
		assert.Equal(t, int64(65000), got.TotalRevenue)
		assert.Equal(t, int64(1), got.TotalOrders)
	})

	t.Run("an order just after midnight belongs to the next day", func(t *testing.T) {
		from := time.Date(2026, 3, 14, 0, 0, 0, 0, jakarta)
		rng := model.AnalyticsRange{
			From: model.NewDate(from), To: model.NewDate(from),
			Start: from, End: from.AddDate(0, 0, 1),
		}

		got, err := repo.Summary(ctx, rng)

		require.NoError(t, err)
		assert.Equal(t, int64(999000), got.TotalRevenue)
	})
}

func TestAnalyticsRepository_SalesTrend(t *testing.T) {
	repo, _ := setup(t)

	t.Run("daily has one point per day, zeros included", func(t *testing.T) {
		points, err := repo.SalesTrend(context.Background(), march(), model.GranularityDaily)

		require.NoError(t, err)
		require.Len(t, points, 5, "2026-03-09 .. 2026-03-13")
		byDay := map[string]model.SalesTrendPoint{}
		for _, p := range points {
			byDay[p.PeriodStart.Format(model.DateFormat)] = p
		}
		assert.Equal(t, int64(120000), byDay["2026-03-10"].Revenue)
		assert.Equal(t, int64(1), byDay["2026-03-10"].Orders)
		assert.Equal(t, int64(65000), byDay["2026-03-12"].Revenue)
		// 03-11 only had a PENDING and a CANCELLED order.
		assert.Equal(t, int64(0), byDay["2026-03-11"].Revenue)
		assert.Equal(t, int64(0), byDay["2026-03-11"].Orders)
		assert.Equal(t, int64(0), byDay["2026-03-09"].Revenue)
	})

	t.Run("weekly buckets by ISO week (Monday)", func(t *testing.T) {
		points, err := repo.SalesTrend(context.Background(), march(), model.GranularityWeekly)

		require.NoError(t, err)
		// 2026-03-09 is a Monday, so the whole range is one week.
		require.Len(t, points, 1)
		assert.Equal(t, "2026-03-09", points[0].PeriodStart.Format(model.DateFormat))
		assert.Equal(t, "2026-03-15", points[0].PeriodEnd.Format(model.DateFormat))
		assert.Equal(t, int64(185000), points[0].Revenue)
		assert.Equal(t, int64(2), points[0].Orders)
	})
}

func TestAnalyticsRepository_TopProducts(t *testing.T) {
	repo, s := setup(t)

	got, err := repo.TopProducts(context.Background(), march(), 10)

	require.NoError(t, err)
	require.Len(t, got, 3, "only products from sold orders")
	// Gula 4, Kopi 3 (2+1), Teh 3 — ties broken by revenue.
	assert.Equal(t, s.gulaID, got[0].ProductID)
	assert.Equal(t, int64(4), got[0].QuantitySold)
	assert.Equal(t, int64(20000), got[0].Revenue)
	assert.Equal(t, s.kopiID, got[1].ProductID)
	assert.Equal(t, int64(3), got[1].QuantitySold)
	assert.Equal(t, int64(135000), got[1].Revenue, "quantity from two different orders is summed")
	assert.Equal(t, s.tehID, got[2].ProductID)
	assert.Equal(t, int64(3), got[2].QuantitySold)
	assert.Equal(t, int64(30000), got[2].Revenue, "the 30 Teh of the cancelled order are excluded")
}

func TestAnalyticsRepository_TopProductsLimit(t *testing.T) {
	repo, s := setup(t)

	got, err := repo.TopProducts(context.Background(), march(), 1)

	require.NoError(t, err)
	require.Len(t, got, 1)
	assert.Equal(t, s.gulaID, got[0].ProductID)
}

func TestAnalyticsRepository_CategoryBreakdown(t *testing.T) {
	repo, s := setup(t)

	got, err := repo.CategoryBreakdown(context.Background(), march())

	require.NoError(t, err)
	require.Len(t, got, 2)
	// Minuman: Kopi 135k + Teh 30k = 165k; then products without a category.
	assert.Equal(t, &s.minumanID, got[0].CategoryID)
	assert.Equal(t, int64(165000), got[0].Revenue)
	assert.Equal(t, int64(6), got[0].QuantitySold)
	assert.Nil(t, got[1].CategoryID)
	assert.Equal(t, "Tanpa Kategori", got[1].CategoryName)
	assert.Equal(t, int64(20000), got[1].Revenue)

	var total int64
	for _, c := range got {
		total += c.Revenue
	}
	assert.Equal(t, int64(185000), total, "breakdown must add up to the summary revenue")
}

func TestAnalyticsRepository_EmptyRange(t *testing.T) {
	repo, _ := setup(t)
	from := time.Date(2026, 2, 1, 0, 0, 0, 0, jakarta)
	rng := model.AnalyticsRange{
		From: model.NewDate(from), To: model.NewDate(from.AddDate(0, 0, 2)),
		Start: from, End: from.AddDate(0, 0, 3),
	}
	ctx := context.Background()

	summary, err := repo.Summary(ctx, rng)
	require.NoError(t, err)
	top, err := repo.TopProducts(ctx, rng, 10)
	require.NoError(t, err)
	categories, err := repo.CategoryBreakdown(ctx, rng)
	require.NoError(t, err)
	points, err := repo.SalesTrend(ctx, rng, model.GranularityDaily)
	require.NoError(t, err)

	assert.Zero(t, summary.TotalRevenue)
	assert.Zero(t, summary.TotalOrders)
	assert.Zero(t, summary.TotalItemsSold)
	assert.Empty(t, top)
	assert.Empty(t, categories)
	assert.Len(t, points, 3, "empty days are still charted")
}
