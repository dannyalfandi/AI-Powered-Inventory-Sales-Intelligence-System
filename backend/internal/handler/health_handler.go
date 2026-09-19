package handler

import (
	"context"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

// Pinger is anything whose connectivity can be checked (DB, Redis, ...).
type Pinger interface {
	Ping(ctx context.Context) error
}

// PingFunc adapts a function to Pinger.
type PingFunc func(ctx context.Context) error

func (f PingFunc) Ping(ctx context.Context) error { return f(ctx) }

type HealthHandler struct {
	checks  map[string]Pinger
	timeout time.Duration
}

func NewHealthHandler(checks map[string]Pinger) *HealthHandler {
	return &HealthHandler{checks: checks, timeout: 2 * time.Second}
}

type healthResponse struct {
	Status string            `json:"status"`
	Checks map[string]string `json:"checks"`
}

// Check handles GET /health: 200 if every dependency responds, otherwise 503.
func (h *HealthHandler) Check(c *gin.Context) {
	ctx, cancel := context.WithTimeout(c.Request.Context(), h.timeout)
	defer cancel()

	res := healthResponse{Status: "ok", Checks: make(map[string]string, len(h.checks))}
	status := http.StatusOK
	for name, p := range h.checks {
		if err := p.Ping(ctx); err != nil {
			res.Checks[name] = "down: " + err.Error()
			res.Status = "degraded"
			status = http.StatusServiceUnavailable
			continue
		}
		res.Checks[name] = "up"
	}
	c.JSON(status, res)
}
