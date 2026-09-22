package client

import (
	"context"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

func day(s string) model.Date {
	t, err := time.Parse(model.DateFormat, s)
	if err != nil {
		panic(err)
	}
	return model.NewDate(t)
}

var history = []model.DailySales{
	{Date: day("2026-09-01"), QuantitySold: 4},
	{Date: day("2026-09-02"), QuantitySold: 6},
	{Date: day("2026-09-03"), QuantitySold: 8},
}

// serve starts a stub ML service and returns a client pointing at it.
func serve(t *testing.T, handler http.HandlerFunc) MLService {
	t.Helper()
	server := httptest.NewServer(handler)
	t.Cleanup(server.Close)
	return NewMLService(server.URL, 2*time.Second)
}

// respond answers every request with status and body.
func respond(status int, body string) http.HandlerFunc {
	return func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(status)
		_, _ = io.WriteString(w, body)
	}
}

func TestForecastDemand(t *testing.T) {
	t.Run("sends the contract shape and decodes the answer", func(t *testing.T) {
		var gotPath string
		var gotBody map[string]any
		c := serve(t, func(w http.ResponseWriter, r *http.Request) {
			gotPath = r.URL.Path
			require.NoError(t, json.NewDecoder(r.Body).Decode(&gotBody))
			respond(http.StatusOK, `{
				"product_id": 17,
				"forecast": [{"date": "2026-09-04", "predicted_quantity": 6.0}],
				"method": "moving_average",
				"window_days": 3
			}`)(w, r)
		})

		res, err := c.ForecastDemand(context.Background(), ForecastRequest{
			ProductID: 17, History: history, HorizonDays: 2,
		})

		require.NoError(t, err)
		assert.Equal(t, "/forecast/demand", gotPath)
		// window_days is omitted so the ML service uses its own default.
		assert.Equal(t, map[string]any{
			"product_id":   float64(17),
			"horizon_days": float64(2),
			"history": []any{
				map[string]any{"date": "2026-09-01", "quantity_sold": float64(4)},
				map[string]any{"date": "2026-09-02", "quantity_sold": float64(6)},
				map[string]any{"date": "2026-09-03", "quantity_sold": float64(8)},
			},
		}, gotBody)
		assert.Equal(t, "moving_average", res.Method)
		assert.Equal(t, 3, res.WindowDays)
		require.Len(t, res.Forecast, 1)
		assert.Equal(t, 6.0, res.Forecast[0].PredictedQuantity)
		assert.Equal(t, "2026-09-04", res.Forecast[0].Date.Format(model.DateFormat))
	})

	t.Run("lang is sent so the ML service answers in the same language", func(t *testing.T) {
		var gotBody map[string]any
		c := serve(t, func(w http.ResponseWriter, r *http.Request) {
			require.NoError(t, json.NewDecoder(r.Body).Decode(&gotBody))
			respond(http.StatusOK, `{"product_id":1,"forecast":[],"method":"moving_average","window_days":3}`)(w, r)
		})

		_, err := c.ForecastDemand(context.Background(), ForecastRequest{
			ProductID: 1, Lang: "en", History: history, HorizonDays: 1,
		})

		require.NoError(t, err)
		assert.Equal(t, "en", gotBody["lang"])
	})

	t.Run("window_days is sent when set", func(t *testing.T) {
		var gotBody map[string]any
		c := serve(t, func(w http.ResponseWriter, r *http.Request) {
			require.NoError(t, json.NewDecoder(r.Body).Decode(&gotBody))
			respond(http.StatusOK, `{"product_id":1,"forecast":[],"method":"moving_average","window_days":3}`)(w, r)
		})

		_, err := c.ForecastDemand(context.Background(), ForecastRequest{
			ProductID: 1, History: history, HorizonDays: 1, WindowDays: 3,
		})

		require.NoError(t, err)
		assert.Equal(t, float64(3), gotBody["window_days"])
	})
}

func TestTrendInsight(t *testing.T) {
	c := serve(t, func(w http.ResponseWriter, r *http.Request) {
		assert.Equal(t, "/insight/trend", r.URL.Path)
		respond(http.StatusOK, `{
			"trend": "increasing",
			"change_percent": 32.0,
			"summary": "Penjualan naik 32,0% dalam 4 minggu terakhir (1848 unit vs 1400 unit periode sebelumnya).",
			"window_days": 14,
			"recent_total": 1848,
			"previous_total": 1400
		}`)(w, r)
	})

	res, err := c.TrendInsight(context.Background(), TrendRequest{ProductID: 17, History: history})

	require.NoError(t, err)
	assert.Equal(t, "increasing", res.Trend)
	assert.Equal(t, 32.0, res.ChangePercent)
	assert.Contains(t, res.Summary, "naik 32,0%")
	assert.Equal(t, int64(1848), res.RecentTotal)
	assert.Equal(t, int64(1400), res.PreviousTotal)
}

func TestFailures(t *testing.T) {
	// Every case must be classified, because the service layer reacts
	// differently: unavailable is an outage, invalid is a bug on our side.
	tests := []struct {
		name    string
		handler http.HandlerFunc
		wantErr error
		message string
	}{
		{
			name: "422 with the shared error envelope",
			handler: respond(http.StatusUnprocessableEntity, `{"error":{"code":"validation_failed",
				"message":"request validation failed",
				"details":[{"field":"history","message":"history must have at least 3 data points, got 2"}]}}`),
			wantErr: ErrInvalidRequest,
			message: "history must have at least 3 data points",
		},
		{
			name:    "500 from the ML service",
			handler: respond(http.StatusInternalServerError, `{"detail":"boom"}`),
			wantErr: ErrUnavailable,
			message: "returned 500",
		},
		{
			name:    "503 while it is restarting",
			handler: respond(http.StatusServiceUnavailable, ``),
			wantErr: ErrUnavailable,
			message: "returned 503",
		},
		{
			name:    "404: wrong URL or an old ML service",
			handler: respond(http.StatusNotFound, `{"detail":"Not Found"}`),
			wantErr: nil,
			message: "unexpected status 404",
		},
		{
			name:    "a body that is not the expected JSON",
			handler: respond(http.StatusOK, `<html>proxy error</html>`),
			wantErr: nil,
			message: "decode",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := serve(t, tt.handler)

			_, err := c.ForecastDemand(context.Background(), ForecastRequest{
				ProductID: 1, History: history, HorizonDays: 7,
			})

			require.Error(t, err)
			assert.Contains(t, err.Error(), tt.message)
			if tt.wantErr != nil {
				assert.ErrorIs(t, err, tt.wantErr)
			} else {
				// Neither bucket: a real bug, not something to retry silently.
				assert.NotErrorIs(t, err, ErrUnavailable)
				assert.NotErrorIs(t, err, ErrInvalidRequest)
			}
		})
	}
}

func TestServiceDown(t *testing.T) {
	// A server that is closed immediately: connection refused, the exact
	// case of "ML service is not running".
	server := httptest.NewServer(http.NotFoundHandler())
	url := server.URL
	server.Close()
	c := NewMLService(url, time.Second)

	_, err := c.ForecastDemand(context.Background(), ForecastRequest{ProductID: 1, History: history, HorizonDays: 7})

	require.Error(t, err)
	assert.ErrorIs(t, err, ErrUnavailable)
}

func TestTimeout(t *testing.T) {
	release := make(chan struct{})
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		<-release // hang until the test ends
	}))
	// Cleanups run last-registered-first: the handler must be released
	// before Close, which waits for outstanding requests.
	t.Cleanup(server.Close)
	t.Cleanup(func() { close(release) })
	c := NewMLService(server.URL, 50*time.Millisecond)

	start := time.Now()
	_, err := c.TrendInsight(context.Background(), TrendRequest{ProductID: 1, History: history})

	require.Error(t, err)
	assert.ErrorIs(t, err, ErrUnavailable, "a slow ML service must look like an outage, not a crash")
	assert.Less(t, time.Since(start), 2*time.Second, "the client must give up quickly")
}

func TestCancelledContext(t *testing.T) {
	c := serve(t, respond(http.StatusOK, `{}`))
	ctx, cancel := context.WithCancel(context.Background())
	cancel()

	_, err := c.ForecastDemand(ctx, ForecastRequest{ProductID: 1, History: history, HorizonDays: 7})

	require.Error(t, err)
	assert.ErrorIs(t, err, ErrUnavailable)
	assert.ErrorIs(t, err, context.Canceled)
}
