// Command migrate creates/updates database tables for every model in
// model.All() using GORM AutoMigrate. It only adds tables, columns and
// indexes; it never drops anything.
package main

import (
	"context"
	"fmt"
	"log/slog"
	"os"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/auth"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/config"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/pkg/database"
)

func main() {
	if err := run(); err != nil {
		slog.Error("migration failed", "error", err)
		os.Exit(1)
	}
	slog.Info("migration completed")
}

func run() error {
	cfg, err := config.Load()
	if err != nil {
		return err
	}
	db, err := database.NewPostgres(context.Background(), cfg.DatabaseURL)
	if err != nil {
		return err
	}
	if sqlDB, err := db.DB(); err == nil {
		defer sqlDB.Close()
	}

	if err := db.AutoMigrate(model.All()...); err != nil {
		return fmt.Errorf("auto migrate: %w", err)
	}

	// The permission catalog is reference data owned by the code, so it is
	// synced with the schema: after a deploy, the table always lists exactly
	// the permissions the routes check.
	if err := repository.NewPermissionRepository(db).SyncCatalog(context.Background(), repository.PermissionCatalog()); err != nil {
		return fmt.Errorf("sync permission catalog: %w", err)
	}
	slog.Info("permission catalog synced", "permissions", len(auth.Catalog))
	return nil
}
