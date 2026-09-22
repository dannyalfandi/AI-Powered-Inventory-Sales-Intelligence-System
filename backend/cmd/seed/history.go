package main

import (
	"context"
	"fmt"
	"log/slog"
	"math"
	"time"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
)

// The sales history is generated day by day and then back-dated, because the
// service layer always stamps "now". Three things make the result look real
// rather than synthetic:
//
//   - a weekday rhythm (warungs restock early in the week, Sunday is quiet),
//     so the moving average has something to smooth instead of a flat line;
//   - a per-product trend that only bites in the last `trendWindowDays` days,
//     so "last 14 days vs the 14 before" — what the ML service compares — sees
//     a real change for the rising and falling products;
//   - a status mix: most orders end SHIPPED, the last few days still have
//     PENDING ones, and a few are CANCELLED from either PENDING or CONFIRMED.
const (
	// trendWindowDays is how long the rise/fall takes to play out.
	trendWindowDays = 30
	// stockBuffer is the head-room added to opening stock over total demand,
	// so confirming an order never fails on stock.
	stockBuffer = 40
)

// weekdayFactor is the demand multiplier per weekday: Monday and Tuesday are
// restocking days, Sunday is slow.
var weekdayFactor = map[time.Weekday]float64{
	time.Monday:    1.25,
	time.Tuesday:   1.15,
	time.Wednesday: 1.0,
	time.Thursday:  1.05,
	time.Friday:    1.2,
	time.Saturday:  0.85,
	time.Sunday:    0.45,
}

// plannedOrder is one order before it exists: the seeder builds the whole
// history first so it knows how much opening stock each product needs.
type plannedOrder struct {
	day     time.Time // 00:00 of the business day, in the app time zone
	placed  time.Time // when the order was created
	status  model.OrderStatus
	viaConf bool // cancelled orders: true when cancelled after CONFIRMED
	items   map[uint]int64
	notes   string
}

func (s *seeder) history(ctx context.Context, days int) error {
	today := time.Now().In(s.loc)
	today = time.Date(today.Year(), today.Month(), today.Day(), 0, 0, 0, 0, s.loc)
	start := today.AddDate(0, 0, -(days - 1))

	planned := s.plan(start, today, days)
	if len(planned) == 0 {
		return fmt.Errorf("planner produced no orders for %d days", days)
	}

	if err := s.openingStock(ctx, planned, start); err != nil {
		return err
	}

	stats := map[model.OrderStatus]int{}
	var revenue int64
	for _, p := range planned {
		order, err := s.place(ctx, p)
		if err != nil {
			return err
		}
		stats[order.Status]++
		if order.Status == model.OrderConfirmed || order.Status == model.OrderShipped {
			revenue += order.TotalAmount
		}
	}

	if err := s.settleStock(ctx, today); err != nil {
		return err
	}
	if err := s.syncCounters(ctx); err != nil {
		return err
	}

	slog.Info("sales history created",
		"days", days, "from", start.Format(model.DateFormat), "to", today.Format(model.DateFormat),
		"orders", len(planned), "shipped", stats[model.OrderShipped], "confirmed", stats[model.OrderConfirmed],
		"pending", stats[model.OrderPending], "cancelled", stats[model.OrderCancelled],
		"revenue_counted", revenue)
	return nil
}

// line is one product's sales on one day, before it is packed into an order.
type line struct {
	productID uint
	quantity  int64
}

// plan lays out every order of the window without touching the database.
//
// It works per day and per product first, and packs the resulting lines into
// orders afterwards. Deciding "which products does this order contain" at
// random instead would add so much variance that a product meant to rise 45%
// could come out falling — the trends have to survive into the 14-day windows
// the insights compare.
func (s *seeder) plan(start, today time.Time, days int) []plannedOrder {
	var planned []plannedOrder

	for offset := range days {
		day := start.AddDate(0, 0, offset)
		age := int(today.Sub(day).Hours() / 24)

		lines := s.linesForDay(day, today)
		s.rng.Shuffle(len(lines), func(i, j int) { lines[i], lines[j] = lines[j], lines[i] })

		// Pack the day's lines into orders of 3–6 products.
		for len(lines) > 0 {
			size := min(3+s.rng.IntN(4), len(lines))
			items := make(map[uint]int64, size)
			for _, l := range lines[:size] {
				items[l.productID] = l.quantity
			}
			lines = lines[size:]

			status, viaConf := s.statusFor(age)
			planned = append(planned, plannedOrder{
				day:     day,
				placed:  day.Add(time.Duration(8*60+s.rng.IntN(9*60)) * time.Minute), // 08:00–17:00
				status:  status,
				viaConf: viaConf,
				items:   items,
				notes:   s.note(status),
			})
		}
	}
	return planned
}

// linesForDay is how much of each product sells on one day: the product's
// own profile, times the weekday rhythm, times where its trend has got to,
// plus a little noise. Products that sell less than once a day appear on
// some days only.
func (s *seeder) linesForDay(day, today time.Time) []line {
	factor := weekdayFactor[day.Weekday()]
	var lines []line

	for _, spec := range products {
		trend := trendMultiplier(spec.Demand.Trend, day, today)
		expected := spec.Demand.Base * spec.Demand.Popularity * factor * trend

		var quantity float64
		if expected < 1 {
			// Sparse seller: sells on roughly `expected` days out of ten.
			if s.rng.Float64() < expected {
				quantity = 1 + 2*s.rng.Float64()
			}
		} else {
			quantity = expected * (0.85 + 0.3*s.rng.Float64()) // ±15%
		}

		if q := int64(math.Round(quantity)); q > 0 {
			lines = append(lines, line{productID: s.productIDs[spec.SKU], quantity: q})
		}
	}
	return lines
}

// trendMultiplier ramps from 1 to `end` over the last trendWindowDays days,
// and stays at 1 before that.
func trendMultiplier(end float64, day, today time.Time) float64 {
	if end == 1 {
		return 1
	}
	age := today.Sub(day).Hours() / 24
	if age >= trendWindowDays {
		return 1
	}
	progress := (trendWindowDays - age) / trendWindowDays // 0 → 1 towards today
	return 1 + (end-1)*progress
}

// statusFor mirrors how orders actually age: recent ones may still be
// pending, older ones are almost all shipped, a few never happen.
func (s *seeder) statusFor(age int) (model.OrderStatus, bool) {
	roll := s.rng.Float64()
	if age <= 3 {
		switch {
		case roll < 0.30:
			return model.OrderPending, false
		case roll < 0.90:
			return model.OrderConfirmed, false
		default:
			return model.OrderShipped, false
		}
	}
	// Cancellations are kept to ~5%: every cancelled order removes a whole
	// day of several products from the analytics, and too many of them drown
	// the per-product trends this dataset exists to show.
	switch {
	case roll < 0.77:
		return model.OrderShipped, false
	case roll < 0.95:
		return model.OrderConfirmed, false
	case roll < 0.98:
		return model.OrderCancelled, false // cancelled while still PENDING
	default:
		return model.OrderCancelled, true // confirmed first, so stock came back
	}
}

func (s *seeder) note(status model.OrderStatus) string {
	notes := map[model.OrderStatus][]string{
		model.OrderPending:   {"Menunggu konfirmasi pembayaran", "Pesanan via WhatsApp", ""},
		model.OrderConfirmed: {"Ambil sendiri di gudang", "Kirim sore", ""},
		model.OrderShipped:   {"Dikirim pakai motor", "Titip ke kurir langganan", ""},
		model.OrderCancelled: {"Dibatalkan pelanggan", "Stok tidak sesuai permintaan", "Pelanggan pesan ulang"},
	}
	options := notes[status]
	return options[s.rng.IntN(len(options))]
}

// openingStock gives every product enough stock for the whole history, as one
// IN movement dated the day before the first order.
func (s *seeder) openingStock(ctx context.Context, planned []plannedOrder, start time.Time) error {
	needed := map[uint]int64{}
	for _, p := range planned {
		for id, qty := range p.items {
			needed[id] += qty
		}
	}

	opened := start.AddDate(0, 0, -1).Add(8 * time.Hour)
	for _, spec := range products {
		id := s.productIDs[spec.SKU]
		quantity := needed[id] + spec.EndStock + stockBuffer
		movement, _, err := s.inventory.RecordMovement(ctx, id, model.CreateStockMovementInput{
			Type: string(model.MovementIn), Quantity: &quantity, Reason: "Stok awal gudang",
		})
		if err != nil {
			return fmt.Errorf("opening stock for %q: %w", spec.SKU, err)
		}
		if err := s.backdateMovement(ctx, movement.ID, opened); err != nil {
			return err
		}
	}
	slog.Info("opening stock recorded", "products", len(products), "dated", opened.Format(model.DateFormat))
	return nil
}

// place creates one order through the service layer, walks it to its final
// status, and then moves it into the past.
func (s *seeder) place(ctx context.Context, p plannedOrder) (*model.SalesOrder, error) {
	items := make([]model.CreateOrderItemInput, 0, len(p.items))
	for id, quantity := range p.items {
		items = append(items, model.CreateOrderItemInput{ProductID: id, Quantity: quantity})
	}

	order, err := s.orders.Create(ctx, model.CreateSalesOrderInput{
		CustomerID: s.customerIDs[s.rng.IntN(len(s.customerIDs))],
		Items:      items,
		Notes:      p.notes,
	})
	if err != nil {
		return nil, fmt.Errorf("create order for %s: %w", p.day.Format(model.DateFormat), err)
	}

	for _, status := range transitions(p) {
		order, err = s.orders.ChangeStatus(ctx, order.ID, model.UpdateOrderStatusInput{Status: string(status)})
		if err != nil {
			return nil, fmt.Errorf("move order %s to %s: %w", order.OrderNumber, status, err)
		}
	}

	if err := s.backdateOrder(ctx, order, p); err != nil {
		return nil, err
	}
	return order, nil
}

// transitions is the path from PENDING to the planned status.
func transitions(p plannedOrder) []model.OrderStatus {
	switch p.status {
	case model.OrderPending:
		return nil
	case model.OrderConfirmed:
		return []model.OrderStatus{model.OrderConfirmed}
	case model.OrderShipped:
		return []model.OrderStatus{model.OrderConfirmed, model.OrderShipped}
	case model.OrderCancelled:
		if p.viaConf {
			return []model.OrderStatus{model.OrderConfirmed, model.OrderCancelled}
		}
		return []model.OrderStatus{model.OrderCancelled}
	default:
		return nil
	}
}

// backdateOrder rewrites the timestamps and the order number of an order that
// the services just stamped with "now".
//
// This is the one place the seeder writes SQL directly, and it only touches
// *when* things happened — never amounts, statuses or stock. Analytics groups
// sales by `confirmed_at`, so without this every order would land on today and
// the trend chart would be a single spike.
func (s *seeder) backdateOrder(ctx context.Context, order *model.SalesOrder, p plannedOrder) error {
	created := p.placed
	confirmed := created.Add(time.Duration(20+s.rng.IntN(70)) * time.Minute)
	shipped := confirmed.Add(time.Duration(8+s.rng.IntN(22)) * time.Hour)
	cancelled := created.Add(time.Duration(30+s.rng.IntN(150)) * time.Minute)

	var confirmedAt, shippedAt, cancelledAt *time.Time
	updated := created
	switch p.status {
	case model.OrderConfirmed:
		confirmedAt, updated = &confirmed, confirmed
	case model.OrderShipped:
		confirmedAt, shippedAt, updated = &confirmed, &shipped, shipped
	case model.OrderCancelled:
		cancelledAt, updated = &cancelled, cancelled
		if p.viaConf {
			confirmedAt = &confirmed
		}
	}

	day := created.Format("20060102")
	s.numbering[day]++
	number := model.FormatOrderNumber(day, s.numbering[day])

	err := s.db.WithContext(ctx).Exec(`
		UPDATE sales_orders
		SET order_number = ?, created_at = ?, updated_at = ?,
		    confirmed_at = ?, shipped_at = ?, cancelled_at = ?
		WHERE id = ?`,
		number, created, updated, confirmedAt, shippedAt, cancelledAt, order.ID).Error
	if err != nil {
		return fmt.Errorf("backdate order %d: %w", order.ID, err)
	}
	order.OrderNumber = number

	// The stock movements the transitions produced move with the order: OUT
	// when it was confirmed, IN when a confirmed order was cancelled.
	if confirmedAt != nil {
		if err := s.backdateOrderMovements(ctx, order.ID, string(model.MovementOut), *confirmedAt); err != nil {
			return err
		}
	}
	if cancelledAt != nil && p.viaConf {
		if err := s.backdateOrderMovements(ctx, order.ID, string(model.MovementIn), *cancelledAt); err != nil {
			return err
		}
	}
	return nil
}

func (s *seeder) backdateOrderMovements(ctx context.Context, orderID uint, movementType string, at time.Time) error {
	err := s.db.WithContext(ctx).
		Exec(`UPDATE stock_movements SET created_at = ? WHERE sales_order_id = ? AND type = ?`,
			at, orderID, movementType).Error
	if err != nil {
		return fmt.Errorf("backdate %s movements of order %d: %w", movementType, orderID, err)
	}
	return nil
}

func (s *seeder) backdateMovement(ctx context.Context, movementID uint, at time.Time) error {
	err := s.db.WithContext(ctx).
		Exec(`UPDATE stock_movements SET created_at = ? WHERE id = ?`, at, movementID).Error
	if err != nil {
		return fmt.Errorf("backdate movement %d: %w", movementID, err)
	}
	return nil
}

// settleStock ends the history with a stock count, so the shelves hold the
// numbers the demo wants: a handful of products under their threshold (the
// low-stock screen), the rest comfortable.
func (s *seeder) settleStock(ctx context.Context, today time.Time) error {
	countedAt := today.Add(7 * time.Hour)
	low := 0
	for _, spec := range products {
		id := s.productIDs[spec.SKU]
		target := spec.EndStock
		movement, inventory, err := s.inventory.RecordMovement(ctx, id, model.CreateStockMovementInput{
			Type: string(model.MovementAdjustment), Quantity: &target, Reason: "Stok opname akhir bulan",
		})
		if err != nil {
			return fmt.Errorf("stock count for %q: %w", spec.SKU, err)
		}
		if err := s.backdateMovement(ctx, movement.ID, countedAt); err != nil {
			return err
		}
		if inventory.Quantity <= inventory.LowStockThreshold {
			low++
		}
	}
	slog.Info("closing stock set", "products", len(products), "below_threshold", low)
	return nil
}

// syncCounters rebuilds the per-day order counters from the orders that now
// exist. It cannot just remember what it handed out: every order was created
// today before being moved into the past, so today's counter ended up at the
// total number of orders. Deriving it from the stored order numbers leaves
// each day at its real last sequence, and the next order the API creates
// continues from there instead of jumping to #430.
func (s *seeder) syncCounters(ctx context.Context) error {
	err := s.db.WithContext(ctx).Exec(`
		INSERT INTO sales_order_counters (day, last_value)
		SELECT to_char(created_at, 'YYYYMMDD'),
		       MAX(CAST(split_part(order_number, '-', 3) AS bigint))
		FROM sales_orders
		GROUP BY 1
		ON CONFLICT (day) DO UPDATE SET last_value = EXCLUDED.last_value`).Error
	if err != nil {
		return fmt.Errorf("rebuild order counters: %w", err)
	}
	// Counters for days without orders are leftovers from the run itself.
	err = s.db.WithContext(ctx).Exec(`
		DELETE FROM sales_order_counters
		WHERE day NOT IN (SELECT to_char(created_at, 'YYYYMMDD') FROM sales_orders)`).Error
	if err != nil {
		return fmt.Errorf("drop stale order counters: %w", err)
	}
	return nil
}
