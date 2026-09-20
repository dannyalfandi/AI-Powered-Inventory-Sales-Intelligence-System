// Command api runs the Inventory & Sales Intelligence REST API.
package main

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/config"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/handler"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/router"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/pkg/cache"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/pkg/database"
)

func main() {
	if err := run(); err != nil {
		slog.Error("server exited with error", "error", err)
		os.Exit(1)
	}
}

func run() error {
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	cfg, err := config.Load()
	if err != nil {
		return err
	}

	db, err := database.NewPostgres(ctx, cfg.DatabaseURL)
	if err != nil {
		return err
	}
	sqlDB, err := db.DB()
	if err != nil {
		return fmt.Errorf("get sql.DB: %w", err)
	}
	defer sqlDB.Close()

	rdb, err := cache.NewRedis(ctx, cache.Options{
		Addr: cfg.Redis.Addr, Password: cfg.Redis.Password, DB: cfg.Redis.DB,
	})
	if err != nil {
		return err
	}
	defer rdb.Close()

	productRepo := repository.NewProductRepository(db)
	categoryRepo := repository.NewCategoryRepository(db)
	inventoryRepo := repository.NewInventoryRepository(db)
	productSvc := service.NewProductService(productRepo, categoryRepo)
	categorySvc := service.NewCategoryService(categoryRepo)
	inventorySvc := service.NewInventoryService(inventoryRepo, productRepo, cfg.LowStockDefaultThreshold)

	loc, err := time.LoadLocation(cfg.Timezone) // validated by config.Load
	if err != nil {
		return fmt.Errorf("load time zone: %w", err)
	}
	customerRepo := repository.NewCustomerRepository(db)
	salesOrderRepo := repository.NewSalesOrderRepository(db)
	analyticsRepo := repository.NewAnalyticsRepository(db, loc)
	analyticsSvc := service.NewAnalyticsService(analyticsRepo, inventorySvc, cache.NewStore(rdb), cfg.AnalyticsCacheTTL, loc)
	customerSvc := service.NewCustomerService(customerRepo)
	salesOrderSvc := service.NewSalesOrderService(salesOrderRepo, customerRepo, cfg.LowStockDefaultThreshold, loc)

	engine := router.New(router.Handlers{
		Health: handler.NewHealthHandler(map[string]handler.Pinger{
			"database": handler.PingFunc(sqlDB.PingContext),
			"redis":    handler.PingFunc(func(ctx context.Context) error { return rdb.Ping(ctx).Err() }),
		}),
		Product:    handler.NewProductHandler(productSvc),
		Category:   handler.NewCategoryHandler(categorySvc),
		Inventory:  handler.NewInventoryHandler(inventorySvc),
		Customer:   handler.NewCustomerHandler(customerSvc),
		SalesOrder: handler.NewSalesOrderHandler(salesOrderSvc),
		Analytics:  handler.NewAnalyticsHandler(analyticsSvc),
	})

	srv := &http.Server{
		Addr:              ":" + cfg.Port,
		Handler:           engine,
		ReadHeaderTimeout: 10 * time.Second,
	}

	errCh := make(chan error, 1)
	go func() {
		slog.Info("api listening", "addr", srv.Addr)
		if err := srv.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			errCh <- err
		}
		close(errCh)
	}()

	select {
	case err := <-errCh:
		return fmt.Errorf("listen: %w", err)
	case <-ctx.Done():
	}

	slog.Info("shutting down")
	shutdownCtx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	if err := srv.Shutdown(shutdownCtx); err != nil {
		return fmt.Errorf("shutdown: %w", err)
	}
	return nil
}
