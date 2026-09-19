package handler

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestHealthHandler_Check(t *testing.T) {
	gin.SetMode(gin.TestMode)
	up := PingFunc(func(context.Context) error { return nil })
	down := PingFunc(func(context.Context) error { return errors.New("connection refused") })

	tests := []struct {
		name       string
		checks     map[string]Pinger
		wantStatus int
		wantBody   healthResponse
	}{
		{
			name:       "all dependencies up",
			checks:     map[string]Pinger{"database": up, "redis": up},
			wantStatus: http.StatusOK,
			wantBody:   healthResponse{Status: "ok", Checks: map[string]string{"database": "up", "redis": "up"}},
		},
		{
			name:       "redis down",
			checks:     map[string]Pinger{"database": up, "redis": down},
			wantStatus: http.StatusServiceUnavailable,
			wantBody: healthResponse{Status: "degraded", Checks: map[string]string{
				"database": "up", "redis": "down: connection refused",
			}},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			r := gin.New()
			r.GET("/health", NewHealthHandler(tt.checks).Check)

			w := httptest.NewRecorder()
			r.ServeHTTP(w, httptest.NewRequest(http.MethodGet, "/health", nil))

			assert.Equal(t, tt.wantStatus, w.Code)
			var got healthResponse
			require.NoError(t, json.Unmarshal(w.Body.Bytes(), &got))
			assert.Equal(t, tt.wantBody, got)
		})
	}
}
