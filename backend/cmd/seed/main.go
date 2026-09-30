// Command seed fills the database with a realistic demo dataset: an
// Indonesian grocery wholesaler with ~3 months of sales history, shaped so
// the dashboard, the forecast and the insights all have something to show.
//
// It is development tooling, not part of the running system. Nothing in
// cmd/api or cmd/migrate depends on it.
//
//	go run ./cmd/seed --clean    # remove test/demo leftovers (explicit, never automatic)
//	go run ./cmd/seed            # create the demo data (safe to re-run)
//	go run ./cmd/seed --auth-only  # only roles + the Super Admin/Staff accounts
//
// Orders go through the same service layer the API uses, so stock movements,
// order numbers and every invariant are produced by the real business logic.
// The one thing the services cannot do is date an order in the past, so after
// each order is created its timestamps (and its order number) are rewritten to
// the intended day — see backdateOrder.
package main

import (
	"context"
	"flag"
	"fmt"
	"log/slog"
	"math/rand/v2"
	"os"
	"time"

	"gorm.io/gorm"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/config"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/pkg/database"
)

func main() {
	clean := flag.Bool("clean", false, "delete test/demo leftovers instead of seeding")
	authOnly := flag.Bool("auth-only", false, "create only the roles and the Super Admin/Staff accounts, no demo data")
	days := flag.Int("days", 75, "how many days of sales history to generate")
	randomSeed := flag.Uint64("seed", 20260920, "PRNG seed; the same seed always produces the same data")
	flag.Parse()

	if err := run(*clean, *authOnly, *days, *randomSeed); err != nil {
		slog.Error("seed failed", "error", err)
		os.Exit(1)
	}
}

func run(clean, authOnly bool, days int, randomSeed uint64) error {
	ctx := context.Background()

	cfg, err := config.Load()
	if err != nil {
		return err
	}
	db, err := database.NewPostgres(ctx, cfg.DatabaseURL)
	if err != nil {
		return err
	}
	if sqlDB, err := db.DB(); err == nil {
		defer sqlDB.Close()
	}
	loc, err := time.LoadLocation(cfg.Timezone)
	if err != nil {
		return fmt.Errorf("load time zone: %w", err)
	}

	if clean {
		return cleanTestData(ctx, db)
	}
	// Accounts first: without them nobody can log in to look at the demo.
	if err := accounts(ctx, db); err != nil {
		return err
	}
	if authOnly {
		return nil
	}
	if days < 14 {
		return fmt.Errorf("--days must be at least 14 so the trend comparison has two periods, got %d", days)
	}
	return seed(ctx, db, cfg, loc, days, randomSeed)
}

// --- cleaning --------------------------------------------------------------

// cleanTestData removes the rows left behind by the test scripts and by
// manual testing, plus anything this seeder created before, so that a
// following `go run ./cmd/seed` starts from nothing.
//
// It deletes only rows it can identify (see data.go for the patterns) — never
// the whole table — and it deletes hard, including soft-deleted rows, because
// a soft-deleted "E2E Kopi" still blocks nothing but still shows up in the
// database a reviewer looks at.
func cleanTestData(ctx context.Context, db *gorm.DB) error {
	return db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		productIDs, err := idsOf(tx, "products", func(q *gorm.DB) *gorm.DB {
			q = q.Where("1 = 0")
			for _, pattern := range testProductSKUs {
				q = q.Or("sku LIKE ?", pattern)
			}
			for _, pattern := range testNames {
				q = q.Or("name LIKE ?", pattern)
			}
			return q.Or("sku IN ?", seedSKUs())
		})
		if err != nil {
			return err
		}
		customerIDs, err := idsOf(tx, "customers", func(q *gorm.DB) *gorm.DB {
			q = q.Where("1 = 0")
			for _, pattern := range testNames {
				q = q.Or("name LIKE ?", pattern)
			}
			return q.Or("name IN ?", manualCustomerNames).Or("email IN ?", seedEmails())
		})
		if err != nil {
			return err
		}
		categoryIDs, err := idsOf(tx, "categories", func(q *gorm.DB) *gorm.DB {
			q = q.Where("1 = 0")
			for _, pattern := range testNames {
				q = q.Or("name LIKE ?", pattern)
			}
			return q.Or("name IN ?", manualCategoryNames).Or("name IN ?", seedCategoryNames())
		})
		if err != nil {
			return err
		}

		// Any order that touches a doomed product or customer goes too:
		// keeping it would leave an order pointing at nothing.
		orderIDs, err := idsOf(tx, "sales_orders", func(q *gorm.DB) *gorm.DB {
			q = q.Where("1 = 0")
			if len(customerIDs) > 0 {
				q = q.Or("customer_id IN ?", customerIDs)
			}
			if len(productIDs) > 0 {
				q = q.Or("id IN (SELECT sales_order_id FROM sales_order_items WHERE product_id IN ?)", productIDs)
			}
			return q
		})
		if err != nil {
			return err
		}

		// Accounts and roles that scripts/e2e.sh creates. The seeded Super
		// Admin and Staff are not touched: --clean then seed must leave you
		// able to log in with the same credentials.
		userIDs, err := idsOf(tx, "users", func(q *gorm.DB) *gorm.DB {
			return q.Where("email LIKE ?", testUserEmails)
		})
		if err != nil {
			return err
		}
		roleIDs, err := idsOf(tx, "roles", func(q *gorm.DB) *gorm.DB {
			return q.Where("name LIKE ? AND NOT is_system", testRoleNames).
				Where("id NOT IN (SELECT role_id FROM users WHERE email NOT LIKE ?)", testUserEmails)
		})
		if err != nil {
			return err
		}

		deleted := map[string]int64{}
		// Order matters: children first, then parents (the FKs are RESTRICT).
		steps := []struct {
			label string
			run   func() (int64, error)
		}{
			{"stock_movements", func() (int64, error) {
				return deleteWhere(tx, "stock_movements", "product_id IN ?", productIDs)
			}},
			{"stock_movements (orders)", func() (int64, error) {
				return deleteWhere(tx, "stock_movements", "sales_order_id IN ?", orderIDs)
			}},
			{"sales_order_items", func() (int64, error) {
				return deleteWhere(tx, "sales_order_items", "sales_order_id IN ?", orderIDs)
			}},
			{"sales_order_items (products)", func() (int64, error) {
				return deleteWhere(tx, "sales_order_items", "product_id IN ?", productIDs)
			}},
			{"sales_orders", func() (int64, error) {
				return deleteWhere(tx, "sales_orders", "id IN ?", orderIDs)
			}},
			{"inventories", func() (int64, error) {
				return deleteWhere(tx, "inventories", "product_id IN ?", productIDs)
			}},
			{"products", func() (int64, error) { return deleteWhere(tx, "products", "id IN ?", productIDs) }},
			{"categories", func() (int64, error) { return deleteWhere(tx, "categories", "id IN ?", categoryIDs) }},
			{"customers", func() (int64, error) { return deleteWhere(tx, "customers", "id IN ?", customerIDs) }},
			{"refresh_tokens", func() (int64, error) { return deleteWhere(tx, "refresh_tokens", "user_id IN ?", userIDs) }},
			{"users", func() (int64, error) { return deleteWhere(tx, "users", "id IN ?", userIDs) }},
			{"role_permissions", func() (int64, error) { return deleteWhere(tx, "role_permissions", "role_id IN ?", roleIDs) }},
			{"roles", func() (int64, error) { return deleteWhere(tx, "roles", "id IN ?", roleIDs) }},
		}
		for _, step := range steps {
			n, err := step.run()
			if err != nil {
				return fmt.Errorf("delete %s: %w", step.label, err)
			}
			deleted[step.label] += n
		}

		// Order-number counters are only meaningful together with the orders.
		if len(orderIDs) > 0 {
			res := tx.Exec(`DELETE FROM sales_order_counters WHERE day NOT IN (SELECT to_char(created_at, 'YYYYMMDD') FROM sales_orders)`)
			if res.Error != nil {
				return fmt.Errorf("delete sales_order_counters: %w", res.Error)
			}
			deleted["sales_order_counters"] = res.RowsAffected
		}

		slog.Info("cleaned test/demo data",
			"products", len(productIDs), "categories", len(categoryIDs), "customers", len(customerIDs),
			"users", len(userIDs), "roles", len(roleIDs),
			"sales_orders", len(orderIDs), "rows", deleted)
		return nil
	})
}

// idsOf collects primary keys of a table, including soft-deleted rows.
func idsOf(tx *gorm.DB, table string, where func(*gorm.DB) *gorm.DB) ([]uint, error) {
	var ids []uint
	q := where(tx.Table(table).Select(primaryKeyOf(table)))
	if err := q.Scan(&ids).Error; err != nil {
		return nil, fmt.Errorf("collect %s ids: %w", table, err)
	}
	return ids, nil
}

func primaryKeyOf(table string) string {
	if table == "inventories" {
		return "product_id"
	}
	return "id"
}

func deleteWhere(tx *gorm.DB, table, condition string, ids []uint) (int64, error) {
	if len(ids) == 0 {
		return 0, nil
	}
	res := tx.Exec(fmt.Sprintf("DELETE FROM %s WHERE %s", table, condition), ids)
	return res.RowsAffected, res.Error
}

func seedSKUs() []string {
	out := make([]string, len(products))
	for i, p := range products {
		out[i] = p.SKU
	}
	return out
}

func seedEmails() []string {
	out := make([]string, len(customers))
	for i, c := range customers {
		out[i] = c.Email
	}
	return out
}

func seedCategoryNames() []string {
	out := make([]string, len(categories))
	for i, c := range categories {
		out[i] = c.Name
	}
	return out
}

// --- seeding ---------------------------------------------------------------

type seeder struct {
	db        *gorm.DB
	loc       *time.Location
	rng       *rand.Rand
	threshold int64

	categories service.CategoryService
	products   service.ProductService
	customers  service.CustomerService
	inventory  service.InventoryService
	orders     service.SalesOrderService

	categoryIDs map[string]uint
	productIDs  map[string]uint
	customerIDs []uint
	// numbering tracks the per-day order sequence while back-dating.
	numbering map[string]int64
}

func seed(ctx context.Context, db *gorm.DB, cfg *config.Config, loc *time.Location, days int, randomSeed uint64) error {
	productRepo := repository.NewProductRepository(db)
	categoryRepo := repository.NewCategoryRepository(db)
	inventoryRepo := repository.NewInventoryRepository(db)
	customerRepo := repository.NewCustomerRepository(db)
	orderRepo := repository.NewSalesOrderRepository(db)

	s := &seeder{
		db: db, loc: loc,
		rng:       rand.New(rand.NewPCG(randomSeed, randomSeed^0x9e3779b9)),
		threshold: cfg.LowStockDefaultThreshold,

		categories: service.NewCategoryService(categoryRepo),
		products:   service.NewProductService(productRepo, categoryRepo),
		customers:  service.NewCustomerService(customerRepo),
		inventory:  service.NewInventoryService(inventoryRepo, productRepo, cfg.LowStockDefaultThreshold),
		orders:     service.NewSalesOrderService(orderRepo, customerRepo, cfg.LowStockDefaultThreshold, loc),

		categoryIDs: map[string]uint{},
		productIDs:  map[string]uint{},
		numbering:   map[string]int64{},
	}

	if err := s.catalogue(ctx); err != nil {
		return err
	}

	// Idempotency: the catalogue is created or updated in place, the history
	// is not. Re-running without --clean must not double the sales.
	existing, err := s.existingHistory(ctx)
	if err != nil {
		return err
	}
	if existing > 0 {
		slog.Info("sales history already present, nothing else to do",
			"orders", existing, "hint", "run `go run ./cmd/seed --clean` first to regenerate it")
		return nil
	}

	return s.history(ctx, days)
}

// catalogue creates (or updates) categories, products and customers. Every
// row is found by its natural key, so running the seeder twice changes
// nothing the second time.
func (s *seeder) catalogue(ctx context.Context) error {
	for _, spec := range categories {
		id, err := s.ensureCategory(ctx, spec)
		if err != nil {
			return err
		}
		s.categoryIDs[spec.Name] = id
	}
	for _, spec := range products {
		id, err := s.ensureProduct(ctx, spec)
		if err != nil {
			return err
		}
		s.productIDs[spec.SKU] = id
	}
	for _, spec := range customers {
		id, err := s.ensureCustomer(ctx, spec)
		if err != nil {
			return err
		}
		for range spec.Weight { // weight = how often this customer is picked
			s.customerIDs = append(s.customerIDs, id)
		}
	}
	slog.Info("catalogue ready",
		"categories", len(s.categoryIDs), "products", len(s.productIDs), "customers", len(customers))
	return nil
}

func (s *seeder) ensureCategory(ctx context.Context, spec categorySpec) (uint, error) {
	existing, err := findOne[model.Category](ctx, s.db, "name = ?", spec.Name)
	switch {
	case err == nil && existing != nil:
		if existing.Description != spec.Description {
			if _, err := s.categories.Update(ctx, existing.ID,
				model.UpdateCategoryInput{Description: &spec.Description}); err != nil {
				return 0, fmt.Errorf("update category %q: %w", spec.Name, err)
			}
		}
		return existing.ID, nil
	case err != nil:
		return 0, fmt.Errorf("look up category %q: %w", spec.Name, err)
	}

	created, err := s.categories.Create(ctx, model.CreateCategoryInput{Name: spec.Name, Description: spec.Description})
	if err != nil {
		return 0, fmt.Errorf("create category %q: %w", spec.Name, err)
	}
	return created.ID, nil
}

func (s *seeder) ensureProduct(ctx context.Context, spec productSpec) (uint, error) {
	categoryID := s.categoryIDs[spec.Category]

	existing, err := findOne[model.Product](ctx, s.db, "sku = ?", spec.SKU)
	switch {
	case err == nil && existing != nil:
		if _, err := s.products.Update(ctx, existing.ID, model.UpdateProductInput{
			Name: &spec.Name, Description: &spec.Description, Price: &spec.Price, CategoryID: &categoryID,
		}); err != nil {
			return 0, fmt.Errorf("update product %q: %w", spec.SKU, err)
		}
		return existing.ID, s.ensureThreshold(ctx, existing.ID, spec)
	case err != nil:
		return 0, fmt.Errorf("look up product %q: %w", spec.SKU, err)
	}

	created, err := s.products.Create(ctx, model.CreateProductInput{
		SKU: spec.SKU, Name: spec.Name, Description: spec.Description,
		Price: spec.Price, CategoryID: &categoryID,
	})
	if err != nil {
		return 0, fmt.Errorf("create product %q: %w", spec.SKU, err)
	}
	return created.ID, s.ensureThreshold(ctx, created.ID, spec)
}

// ensureThreshold sets a per-product low-stock threshold where the demo wants
// one (a sack of rice is "low" at a different number than sachets of coffee).
func (s *seeder) ensureThreshold(ctx context.Context, productID uint, spec productSpec) error {
	if spec.Threshold == 0 {
		return nil
	}
	if _, err := s.inventory.Update(ctx, productID,
		model.UpdateInventoryInput{LowStockThreshold: &spec.Threshold}); err != nil {
		return fmt.Errorf("set threshold for %q: %w", spec.SKU, err)
	}
	return nil
}

func (s *seeder) ensureCustomer(ctx context.Context, spec customerSpec) (uint, error) {
	existing, err := findOne[model.Customer](ctx, s.db, "email = ?", spec.Email)
	switch {
	case err == nil && existing != nil:
		return existing.ID, nil
	case err != nil:
		return 0, fmt.Errorf("look up customer %q: %w", spec.Email, err)
	}

	created, err := s.customers.Create(ctx, model.CreateCustomerInput{
		Name: spec.Name, Email: spec.Email, Phone: spec.Phone, Address: spec.Address,
	})
	if err != nil {
		return 0, fmt.Errorf("create customer %q: %w", spec.Name, err)
	}
	return created.ID, nil
}

// findOne returns the row matching the condition, or nil when there is none.
// Find rather than First: a miss is the normal case here, and First would log
// "record not found" for every row the seeder creates.
func findOne[T any](ctx context.Context, db *gorm.DB, condition string, args ...any) (*T, error) {
	var rows []T
	if err := db.WithContext(ctx).Where(condition, args...).Limit(1).Find(&rows).Error; err != nil {
		return nil, err
	}
	if len(rows) == 0 {
		return nil, nil
	}
	return &rows[0], nil
}

// existingHistory counts orders that belong to the seeded customers.
func (s *seeder) existingHistory(ctx context.Context) (int64, error) {
	var count int64
	err := s.db.WithContext(ctx).Model(&model.SalesOrder{}).
		Where("customer_id IN (SELECT id FROM customers WHERE email IN ?)", seedEmails()).
		Count(&count).Error
	if err != nil {
		return 0, fmt.Errorf("count existing history: %w", err)
	}
	return count, nil
}
