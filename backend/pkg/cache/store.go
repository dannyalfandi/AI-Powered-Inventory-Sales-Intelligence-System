package cache

import (
	"context"
	"errors"
	"log/slog"
	"time"

	"github.com/redis/go-redis/v9"
)

// RedisStore is a best-effort byte cache on top of Redis. A cache problem
// must never fail a request, so errors are logged and reported as a miss.
type RedisStore struct {
	client *redis.Client
}

func NewStore(client *redis.Client) *RedisStore {
	return &RedisStore{client: client}
}

// Get returns the cached value and whether it was a hit.
func (s *RedisStore) Get(ctx context.Context, key string) ([]byte, bool) {
	value, err := s.client.Get(ctx, key).Bytes()
	switch {
	case err == nil:
		return value, true
	case errors.Is(err, redis.Nil):
		return nil, false
	default:
		slog.WarnContext(ctx, "cache read failed", "key", key, "error", err)
		return nil, false
	}
}

// Set stores value under key for ttl. Failures are logged, not returned.
func (s *RedisStore) Set(ctx context.Context, key string, value []byte, ttl time.Duration) {
	if err := s.client.Set(ctx, key, value, ttl).Err(); err != nil {
		slog.WarnContext(ctx, "cache write failed", "key", key, "error", err)
	}
}
