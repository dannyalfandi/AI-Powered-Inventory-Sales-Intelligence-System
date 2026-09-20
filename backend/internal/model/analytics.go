package model

import "time"

// Analytics types are read-only projections computed from sales_orders +
// sales_order_items (+ products/categories). There is no analytics table:
// every number is aggregated from the transactions themselves, so it can't
// go stale.
//
// Only orders that count as real sales are included: status CONFIRMED or
// SHIPPED. PENDING orders haven't taken stock yet and CANCELLED ones were
// undone, so both are excluded. An order's sale date is its `confirmed_at`.

// DateFormat is the date format used by analytics query params and responses.
const DateFormat = "2006-01-02"

// Date is a calendar date (no time) rendered as "2006-01-02" in JSON.
type Date struct {
	time.Time
}

func NewDate(t time.Time) Date { return Date{Time: t} }

func (d Date) MarshalJSON() ([]byte, error) {
	return []byte(`"` + d.Format(DateFormat) + `"`), nil
}

// UnmarshalJSON accepts what MarshalJSON writes, so cached payloads can be
// read back (json.Unmarshal into the embedded time.Time would expect RFC3339).
func (d *Date) UnmarshalJSON(data []byte) error {
	t, err := time.Parse(`"`+DateFormat+`"`, string(data))
	if err != nil {
		return err
	}
	d.Time = t
	return nil
}

// AnalyticsRange is an inclusive range of calendar days in the app's time
// zone. Start is 00:00 of the first day; End is 00:00 of the day *after*
// the last one, so queries can use `>= Start AND < End`.
type AnalyticsRange struct {
	From  Date      `json:"from"`
	To    Date      `json:"to"`
	Start time.Time `json:"-"`
	End   time.Time `json:"-"`
}

type TrendGranularity string

const (
	GranularityDaily  TrendGranularity = "daily"
	GranularityWeekly TrendGranularity = "weekly"
)

// SalesSummary is the dashboard header: totals for one date range.
type SalesSummary struct {
	Range AnalyticsRange `json:"range"`
	// TotalRevenue is the sum of order totals, in whole Rupiah.
	TotalRevenue   int64 `json:"total_revenue"`
	TotalOrders    int64 `json:"total_orders"`
	TotalItemsSold int64 `json:"total_items_sold"`
	// AverageOrderValue is TotalRevenue / TotalOrders, rounded; 0 without orders.
	AverageOrderValue int64 `json:"average_order_value"`
}

// SalesTrendPoint is one point of the time series. Periods without sales are
// included with zeros, so charts don't have gaps.
type SalesTrendPoint struct {
	// PeriodStart is the day, or the Monday of the week for weekly.
	PeriodStart Date  `json:"period_start"`
	PeriodEnd   Date  `json:"period_end"`
	Revenue     int64 `json:"revenue"`
	Orders      int64 `json:"orders"`
}

type SalesTrend struct {
	Range       AnalyticsRange    `json:"range"`
	Granularity TrendGranularity  `json:"granularity"`
	Points      []SalesTrendPoint `json:"points"`
}

// TopProduct is one row of the best-sellers report. SKU and name are the
// snapshots stored on the order item, so the report matches what was sold.
type TopProduct struct {
	ProductID    uint   `json:"product_id"`
	SKU          string `json:"sku"`
	Name         string `json:"name"`
	QuantitySold int64  `json:"quantity_sold"`
	Revenue      int64  `json:"revenue"`
}

// CategoryRevenue is revenue per product category. Category comes from the
// product's *current* category (order items don't snapshot it); products
// without one are grouped under CategoryID nil.
type CategoryRevenue struct {
	CategoryID   *uint  `json:"category_id"`
	CategoryName string `json:"category_name"`
	QuantitySold int64  `json:"quantity_sold"`
	Revenue      int64  `json:"revenue"`
}

// AnalyticsQuery is the parsed, validated query for the analytics endpoints.
type AnalyticsQuery struct {
	From string
	To   string
}
