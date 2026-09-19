package config

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func lookupFrom(env map[string]string) func(string) (string, bool) {
	return func(key string) (string, bool) {
		v, ok := env[key]
		return v, ok
	}
}

func TestFromLookup(t *testing.T) {
	valid := map[string]string{
		"DATABASE_URL":   "postgres://u:p@localhost:5432/db?sslmode=disable",
		"REDIS_ADDR":     "localhost:6379",
		"REDIS_PASSWORD": "secret",
		"REDIS_DB":       "2",
		"PORT":           "9000",

		"LOW_STOCK_DEFAULT_THRESHOLD": "5",
	}

	with := func(overrides map[string]string) map[string]string {
		env := map[string]string{}
		for k, v := range valid {
			env[k] = v
		}
		for k, v := range overrides {
			if v == "<unset>" {
				delete(env, k)
				continue
			}
			env[k] = v
		}
		return env
	}

	tests := []struct {
		name    string
		env     map[string]string
		want    *Config
		wantErr []string
	}{
		{
			name: "all values set",
			env:  valid,
			want: &Config{
				Port:        "9000",
				DatabaseURL: valid["DATABASE_URL"],
				Redis:       RedisConfig{Addr: "localhost:6379", Password: "secret", DB: 2},

				LowStockDefaultThreshold: 5,
			},
		},
		{
			name: "defaults for optional values",
			env: with(map[string]string{
				"PORT": "<unset>", "REDIS_DB": "<unset>", "REDIS_PASSWORD": "<unset>",
				"LOW_STOCK_DEFAULT_THRESHOLD": "<unset>",
			}),
			want: &Config{
				Port:        "8080",
				DatabaseURL: valid["DATABASE_URL"],
				Redis:       RedisConfig{Addr: "localhost:6379"},

				LowStockDefaultThreshold: 10,
			},
		},
		{
			name:    "missing required values are all reported",
			env:     with(map[string]string{"DATABASE_URL": "<unset>", "REDIS_ADDR": "  "}),
			wantErr: []string{"DATABASE_URL is required", "REDIS_ADDR is required"},
		},
		{
			name:    "invalid REDIS_DB",
			env:     with(map[string]string{"REDIS_DB": "abc"}),
			wantErr: []string{"REDIS_DB must be a non-negative integer"},
		},
		{
			name:    "invalid PORT",
			env:     with(map[string]string{"PORT": "70000"}),
			wantErr: []string{"PORT must be a number"},
		},
		{
			name:    "negative LOW_STOCK_DEFAULT_THRESHOLD",
			env:     with(map[string]string{"LOW_STOCK_DEFAULT_THRESHOLD": "-1"}),
			wantErr: []string{"LOW_STOCK_DEFAULT_THRESHOLD must be a non-negative integer"},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := FromLookup(lookupFrom(tt.env))
			if len(tt.wantErr) > 0 {
				require.Error(t, err)
				for _, msg := range tt.wantErr {
					assert.Contains(t, err.Error(), msg)
				}
				return
			}
			require.NoError(t, err)
			assert.Equal(t, tt.want, got)
		})
	}
}
