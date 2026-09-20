package model

// Forecast types are what the API returns for the two endpoints backed by the
// Python ML service (/ml-service, contract in docs/ml-service-contract.md).
//
// The ML service is a separate process, so it can be slow or down while this
// API is healthy. Every product therefore carries its own outcome: a forecast
// or an Error string. A failure of one product never fails the response, and
// a failure of *every* product still returns 200 with Available = false, so
// the dashboard can say "forecasting is unavailable" next to the numbers it
// did get.

// DailySales is one day of sales of one product, gap-filled with zeros. This
// is the history sent to the ML service.
type DailySales struct {
	Date         Date  `json:"date"`
	QuantitySold int64 `json:"quantity_sold"`
}

// ForecastPoint is one predicted day. Quantity is fractional: it is an
// average, not a stock movement.
type ForecastPoint struct {
	Date              Date    `json:"date"`
	PredictedQuantity float64 `json:"predicted_quantity"`
}

// ProductForecast is one product's outcome. Forecast/Method are set when it
// worked, Error when it did not; never both.
type ProductForecast struct {
	ProductID   uint            `json:"product_id"`
	ProductName string          `json:"product_name"`
	SKU         string          `json:"sku"`
	Forecast    []ForecastPoint `json:"forecast,omitempty"`
	Method      string          `json:"method,omitempty"`
	Error       string          `json:"error,omitempty"`
}

// ForecastReport is the body of GET /api/v1/analytics/forecast.
type ForecastReport struct {
	Range       AnalyticsRange `json:"range"`
	HorizonDays int            `json:"horizon_days"`
	// Available is false when there were products to forecast and every one
	// of them failed — the signal for "forecasting is down", not "no data".
	Available bool              `json:"forecast_available"`
	Products  []ProductForecast `json:"products"`
}

// ProductInsight is one product's trend outcome. The statistics fields are
// set when it worked, Error when it did not.
type ProductInsight struct {
	ProductID   uint   `json:"product_id"`
	ProductName string `json:"product_name"`
	SKU         string `json:"sku"`
	// Trend is "increasing", "decreasing" or "stable".
	Trend string `json:"trend,omitempty"`
	// ChangePercent is a pointer so that a real 0% is distinguishable from
	// a product that has no result at all.
	ChangePercent *float64 `json:"change_percent,omitempty"`
	// Summary is a ready-to-display Indonesian sentence, computed from the
	// numbers by the ML service (statistics, not an LLM).
	Summary string `json:"summary,omitempty"`
	Error   string `json:"error,omitempty"`
}

// InsightReport is the body of GET /api/v1/analytics/insights.
type InsightReport struct {
	Range AnalyticsRange `json:"range"`
	// Available is false when every product failed; see ForecastReport.
	Available bool             `json:"insights_available"`
	Products  []ProductInsight `json:"products"`
}
