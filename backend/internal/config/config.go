// Package config loads application configuration from environment variables.
// A .env file (if present) is loaded first for local development; real
// environment variables always take precedence over values in .env.
package config

import (
	"errors"
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"
	// Embeds the IANA time zone database, so APP_TIMEZONE works on hosts
	// without one (Windows, scratch/distroless containers).
	_ "time/tzdata"

	"github.com/joho/godotenv"
)

type Config struct {
	Port        string
	DatabaseURL string
	Redis       RedisConfig
	// LowStockDefaultThreshold is the threshold given to new inventory rows.
	LowStockDefaultThreshold int64
	// Timezone (IANA name) of business dates, e.g. the date in order numbers.
	Timezone string
	// AnalyticsCacheTTL is how long analytics summary/trend responses stay
	// cached in Redis. 0 disables caching (useful for tests and debugging).
	AnalyticsCacheTTL time.Duration
	// ML holds the connection settings of the Python forecasting service.
	ML MLServiceConfig
}

// MLServiceConfig points at the FastAPI service in /ml-service. It is called
// synchronously, so Timeout is what bounds a dashboard request when that
// service is slow, and CacheTTL is what keeps the call rate down.
type MLServiceConfig struct {
	URL     string
	Timeout time.Duration
	// CacheTTL is how long a complete forecast/insight report stays in
	// Redis. 0 disables caching.
	CacheTTL time.Duration
}

type RedisConfig struct {
	Addr     string
	Password string
	DB       int
}

// Load reads .env (optional) and then the process environment.
func Load() (*Config, error) {
	if err := godotenv.Load(); err != nil && !errors.Is(err, os.ErrNotExist) {
		return nil, fmt.Errorf("load .env: %w", err)
	}
	return FromLookup(os.LookupEnv)
}

// FromLookup builds a Config using the given lookup function. It fails fast,
// reporting every missing or invalid variable at once.
func FromLookup(lookup func(string) (string, bool)) (*Config, error) {
	var problems []string

	required := func(key string) string {
		v, ok := lookup(key)
		v = strings.TrimSpace(v)
		if !ok || v == "" {
			problems = append(problems, key+" is required")
		}
		return v
	}
	optional := func(key, def string) string {
		if v, ok := lookup(key); ok && strings.TrimSpace(v) != "" {
			return strings.TrimSpace(v)
		}
		return def
	}

	cfg := &Config{
		Port:        optional("PORT", "8080"),
		DatabaseURL: required("DATABASE_URL"),
		Redis: RedisConfig{
			Addr: required("REDIS_ADDR"),
			// Password may legitimately be empty (Redis without AUTH).
			Password: optional("REDIS_PASSWORD", ""),
		},
	}

	redisDB, err := strconv.Atoi(optional("REDIS_DB", "0"))
	if err != nil || redisDB < 0 {
		problems = append(problems, "REDIS_DB must be a non-negative integer")
	}
	cfg.Redis.DB = redisDB

	threshold, err := strconv.ParseInt(optional("LOW_STOCK_DEFAULT_THRESHOLD", "10"), 10, 64)
	if err != nil || threshold < 0 {
		problems = append(problems, "LOW_STOCK_DEFAULT_THRESHOLD must be a non-negative integer")
	}
	cfg.LowStockDefaultThreshold = threshold

	if ttl, err := time.ParseDuration(optional("ANALYTICS_CACHE_TTL", "5m")); err != nil || ttl < 0 {
		problems = append(problems, "ANALYTICS_CACHE_TTL must be a non-negative duration, e.g. 5m or 0")
	} else {
		cfg.AnalyticsCacheTTL = ttl
	}

	cfg.ML.URL = strings.TrimRight(optional("ML_SERVICE_URL", "http://localhost:8000"), "/")
	if !strings.HasPrefix(cfg.ML.URL, "http://") && !strings.HasPrefix(cfg.ML.URL, "https://") {
		problems = append(problems, "ML_SERVICE_URL must start with http:// or https://")
	}
	if timeout, err := time.ParseDuration(optional("ML_SERVICE_TIMEOUT", "5s")); err != nil || timeout <= 0 {
		problems = append(problems, "ML_SERVICE_TIMEOUT must be a positive duration, e.g. 5s")
	} else {
		cfg.ML.Timeout = timeout
	}
	if ttl, err := time.ParseDuration(optional("FORECAST_CACHE_TTL", "10m")); err != nil || ttl < 0 {
		problems = append(problems, "FORECAST_CACHE_TTL must be a non-negative duration, e.g. 10m or 0")
	} else {
		cfg.ML.CacheTTL = ttl
	}

	cfg.Timezone = optional("APP_TIMEZONE", "Asia/Jakarta")
	if _, err := time.LoadLocation(cfg.Timezone); err != nil {
		problems = append(problems, "APP_TIMEZONE must be an IANA time zone name, e.g. Asia/Jakarta")
	}

	if port, err := strconv.Atoi(cfg.Port); err != nil || port < 1 || port > 65535 {
		problems = append(problems, "PORT must be a number between 1 and 65535")
	}

	if len(problems) > 0 {
		return nil, fmt.Errorf("invalid configuration: %s", strings.Join(problems, "; "))
	}
	return cfg, nil
}
