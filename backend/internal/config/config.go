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

	"github.com/joho/godotenv"
)

type Config struct {
	Port        string
	DatabaseURL string
	Redis       RedisConfig
	// LowStockDefaultThreshold is the threshold given to new inventory rows.
	LowStockDefaultThreshold int64
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

	if port, err := strconv.Atoi(cfg.Port); err != nil || port < 1 || port > 65535 {
		problems = append(problems, "PORT must be a number between 1 and 65535")
	}

	if len(problems) > 0 {
		return nil, fmt.Errorf("invalid configuration: %s", strings.Join(problems, "; "))
	}
	return cfg, nil
}
