package repository

import (
	"context"
	"fmt"
	"time"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

// RotateFunc inspects the locked token row and returns its replacement. An
// error aborts the rotation (nothing is revoked, nothing is inserted).
type RotateFunc func(old *model.RefreshToken) (*model.RefreshToken, error)

type RefreshTokenRepository interface {
	Create(ctx context.Context, t *model.RefreshToken) error
	// Rotate locks the row with tokenHash (SELECT ... FOR UPDATE), asks fn for
	// the replacement, then revokes the old row and inserts the new one in the
	// same transaction. Two concurrent refreshes with the same token are
	// serialized: the second sees the token already revoked. Returns
	// ErrNotFound if no row has that hash.
	Rotate(ctx context.Context, tokenHash string, now time.Time, fn RotateFunc) error
	// Revoke marks the token revoked. Revoking an unknown or already revoked
	// token is not an error: the outcome — the token can't be used — holds.
	Revoke(ctx context.Context, tokenHash string, now time.Time) error
	// RevokeAllForUser revokes every live refresh token of the user and
	// returns how many it revoked. Tokens already revoked keep their
	// original revoked_at.
	RevokeAllForUser(ctx context.Context, userID uint, now time.Time) (int64, error)
}

type refreshTokenRepository struct {
	db *gorm.DB
}

func NewRefreshTokenRepository(db *gorm.DB) RefreshTokenRepository {
	return &refreshTokenRepository{db: db}
}

func (r *refreshTokenRepository) Create(ctx context.Context, t *model.RefreshToken) error {
	if err := r.db.WithContext(ctx).Omit(clause.Associations).Create(t).Error; err != nil {
		return fmt.Errorf("create refresh token: %w", translate(err))
	}
	return nil
}

func (r *refreshTokenRepository) Rotate(ctx context.Context, tokenHash string, now time.Time, fn RotateFunc) error {
	return r.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var old model.RefreshToken
		err := tx.Clauses(clause.Locking{Strength: "UPDATE"}).
			Where("token_hash = ?", tokenHash).First(&old).Error
		if err != nil {
			return fmt.Errorf("lock refresh token: %w", translate(err))
		}

		next, err := fn(&old)
		if err != nil {
			return err
		}

		if err := tx.Model(&old).Update("revoked_at", now).Error; err != nil {
			return fmt.Errorf("revoke refresh token %d: %w", old.ID, err)
		}
		if err := tx.Omit(clause.Associations).Create(next).Error; err != nil {
			return fmt.Errorf("create rotated refresh token: %w", translate(err))
		}
		return nil
	})
}

func (r *refreshTokenRepository) RevokeAllForUser(ctx context.Context, userID uint, now time.Time) (int64, error) {
	return revokeUserTokens(r.db.WithContext(ctx), userID, now)
}

func (r *refreshTokenRepository) Revoke(ctx context.Context, tokenHash string, now time.Time) error {
	err := r.db.WithContext(ctx).Model(&model.RefreshToken{}).
		Where("token_hash = ? AND revoked_at IS NULL", tokenHash).
		Update("revoked_at", now).Error
	if err != nil {
		return fmt.Errorf("revoke refresh token: %w", err)
	}
	return nil
}
