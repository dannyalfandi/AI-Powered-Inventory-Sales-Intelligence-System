package handler

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/service"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/pkg/response"
)

type AnalyticsHandler struct {
	svc service.AnalyticsService
}

func NewAnalyticsHandler(svc service.AnalyticsService) *AnalyticsHandler {
	return &AnalyticsHandler{svc: svc}
}

// dateQuery reads ?from=&to=; the service validates and defaults them.
func dateQuery(c *gin.Context) model.AnalyticsQuery {
	return model.AnalyticsQuery{From: c.Query("from"), To: c.Query("to")}
}

// Summary handles GET /api/v1/analytics/summary?from=&to=.
func (h *AnalyticsHandler) Summary(c *gin.Context) {
	summary, err := h.svc.Summary(c.Request.Context(), dateQuery(c))
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, summary)
}

// SalesTrend handles GET /api/v1/analytics/sales-trend?from=&to=&granularity=daily|weekly.
func (h *AnalyticsHandler) SalesTrend(c *gin.Context) {
	trend, err := h.svc.SalesTrend(c.Request.Context(), dateQuery(c), c.Query("granularity"))
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, trend)
}

// TopProducts handles GET /api/v1/analytics/top-products?from=&to=&limit=10.
func (h *AnalyticsHandler) TopProducts(c *gin.Context) {
	// An invalid number falls back to 0, which the service turns into the default.
	limit, _ := strconv.Atoi(c.Query("limit"))

	products, rng, err := h.svc.TopProducts(c.Request.Context(), dateQuery(c), limit)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, gin.H{"range": rng, "products": products})
}

// CategoryBreakdown handles GET /api/v1/analytics/category-breakdown?from=&to=.
func (h *AnalyticsHandler) CategoryBreakdown(c *gin.Context) {
	categories, rng, err := h.svc.CategoryBreakdown(c.Request.Context(), dateQuery(c))
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, gin.H{"range": rng, "categories": categories})
}

// LowStockAlertCount handles GET /api/v1/analytics/low-stock-alert-count.
func (h *AnalyticsHandler) LowStockAlertCount(c *gin.Context) {
	count, err := h.svc.LowStockAlertCount(c.Request.Context())
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, gin.H{"count": count})
}

// Forecast handles GET /api/v1/analytics/forecast?from=&to=&limit=10&horizon_days=7.
//
// It always answers 200 when the range is valid, even if the ML service is
// down: every product then carries an "error" and "forecast_available" is
// false, so the dashboard degrades instead of failing.
func (h *AnalyticsHandler) Forecast(c *gin.Context) {
	limit, _ := strconv.Atoi(c.Query("limit"))
	horizon, _ := strconv.Atoi(c.Query("horizon_days"))

	report, err := h.svc.Forecast(c.Request.Context(), dateQuery(c), limit, horizon)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, report)
}

// Insights handles GET /api/v1/analytics/insights?from=&to=&limit=10, with
// the same degradation rules as Forecast.
func (h *AnalyticsHandler) Insights(c *gin.Context) {
	limit, _ := strconv.Atoi(c.Query("limit"))

	report, err := h.svc.Insights(c.Request.Context(), dateQuery(c), limit)
	if err != nil {
		writeError(c, err)
		return
	}
	response.OK(c, http.StatusOK, report)
}
