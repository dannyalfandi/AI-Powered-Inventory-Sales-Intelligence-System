package main

import (
	"context"
	"fmt"
	"log/slog"
	"strings"

	"gorm.io/gorm"
)

// cleanE2ERun hard-deletes the accounts and roles that ONE run of
// scripts/e2e.sh created, identified by its run id (the script's $RUN, a
// Unix timestamp): users e2e.<name>.<run>@example.test and roles
// "E2E <name> <run>". The script calls it at the end of every run.
//
// It exists because the API can't do this on its own, on purpose: the script
// soft-deletes its users, a soft-deleted user keeps role_id as history, and
// users.role_id is ON DELETE RESTRICT — so DELETE /roles/:id answers 409 for
// those roles forever (the same rule the script tests). Without this step
// every run left its roles behind.
//
// Unlike --clean it is narrow (one run, users and roles only; products and
// orders stay soft-deleted, as stock movements are immutable) and safe to run
// automatically. A role still referenced by a user outside the run is kept.
func cleanE2ERun(ctx context.Context, db *gorm.DB, run string) error {
	if run == "" || strings.Trim(run, "0123456789") != "" {
		return fmt.Errorf("--clean-e2e-run wants the numeric run id printed by scripts/e2e.sh, got %q", run)
	}
	emails := "e2e.%." + run + "@example.test"
	roleNames := "E2E % " + run

	return db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		userIDs, err := idsOf(tx, "users", func(q *gorm.DB) *gorm.DB {
			return q.Where("email LIKE ?", emails)
		})
		if err != nil {
			return err
		}
		roleIDs, err := idsOf(tx, "roles", func(q *gorm.DB) *gorm.DB {
			return q.Where("name LIKE ? AND NOT is_system", roleNames).
				Where("id NOT IN (SELECT role_id FROM users WHERE email NOT LIKE ?)", emails)
		})
		if err != nil {
			return err
		}

		steps := []struct {
			table, condition string
			ids              []uint
		}{
			{"refresh_tokens", "user_id IN ?", userIDs},
			{"users", "id IN ?", userIDs},
			{"role_permissions", "role_id IN ?", roleIDs},
			{"roles", "id IN ?", roleIDs},
		}
		deleted := map[string]int64{}
		for _, s := range steps {
			n, err := deleteWhere(tx, s.table, s.condition, s.ids)
			if err != nil {
				return fmt.Errorf("delete %s of e2e run %s: %w", s.table, run, err)
			}
			deleted[s.table] = n
		}

		var kept int64
		if err := tx.Table("roles").Where("name LIKE ?", roleNames).Count(&kept).Error; err != nil {
			return fmt.Errorf("count remaining roles of e2e run %s: %w", run, err)
		}
		slog.Info("cleaned e2e run", "run", run, "users", deleted["users"], "roles", deleted["roles"],
			"refresh_tokens", deleted["refresh_tokens"], "roles_kept", kept)
		if kept > 0 {
			return fmt.Errorf("e2e run %s: %d role(s) still referenced by users outside the run were kept", run, kept)
		}
		return nil
	})
}
