# ML Service — API Contract

Reference for integrating the Go backend with `/ml-service`. Everything here is
verified by `ml-service/tests/test_api.py`; if a shape changes, that test fails.

- Base URL (local dev): `http://localhost:8000`
- Base URL (docker-compose, later): `http://ml-service:8000`
- Content type: `application/json` in both directions
- The service is **stateless**: it never touches Postgres. Every call carries
  the history it needs, and nothing is stored between calls.
- Interactive schema while the service runs: `http://localhost:8000/docs`
  (OpenAPI JSON at `/openapi.json`).

## Conventions

| Topic | Rule |
|---|---|
| Dates | `"YYYY-MM-DD"` strings, no time, no time zone. The caller decides the business time zone (the Go backend uses `APP_TIMEZONE`). |
| Missing days | A day between the first and the last history date with no row counts as **0 sold**. The caller may gap-fill (as the analytics SQL does with `generate_series`) but does not have to. |
| Duplicate dates | Several rows with the same date are **summed**, so one row per order works as well as pre-aggregated daily totals. |
| Order | History may arrive in any order; it is sorted before use. |
| Quantities | Integers `>= 0` in requests. Predictions are floats `>= 0`, rounded to 2 decimals. |
| Errors | Always HTTP 422 with the envelope below — the same shape the Go backend itself returns. |

### Error envelope

```json
{
  "error": {
    "code": "validation_failed",
    "message": "request validation failed",
    "details": [{ "field": "horizon_days", "message": "horizon_days must be at most 90, got 91" }]
  }
}
```

`details[].field` is the dotted path inside the request body, e.g. `history`,
`horizon_days`, `history.0.quantity_sold`. The list has one entry per problem.

---

## GET /health

No body.

**200**

```json
{ "status": "ok", "service": "ml-service", "version": "0.1.0", "forecast_method": "moving_average" }
```

Suitable as a Docker/compose healthcheck and as a readiness probe from Go
before the first forecast call.

---

## POST /forecast/demand

Projects daily demand for one product.

### Request

| Field | Type | Required | Rules |
|---|---|---|---|
| `product_id` | int | yes | `>= 1`; echoed back untouched |
| `history` | array | yes | at least **3** rows (`MIN_HISTORY_POINTS`) |
| `history[].date` | string `YYYY-MM-DD` | yes | |
| `history[].quantity_sold` | int | yes | `>= 0` |
| `horizon_days` | int | yes | `1..90` (`MAX_HORIZON_DAYS`) |
| `window_days` | int | no | `1..90`; default **7** (`DEFAULT_WINDOW_DAYS`) |

Unknown fields are rejected (422), so a typo never passes silently.

```json
{
  "product_id": 17,
  "history": [
    { "date": "2026-09-01", "quantity_sold": 4 },
    { "date": "2026-09-02", "quantity_sold": 6 },
    { "date": "2026-09-03", "quantity_sold": 8 }
  ],
  "horizon_days": 2
}
```

### Response 200

```json
{
  "product_id": 17,
  "forecast": [
    { "date": "2026-09-04", "predicted_quantity": 6.0 },
    { "date": "2026-09-05", "predicted_quantity": 6.0 }
  ],
  "method": "moving_average",
  "window_days": 3
}
```

| Field | Meaning |
|---|---|
| `forecast` | Exactly `horizon_days` entries, starting the **day after** the last history date, one per consecutive day. |
| `predicted_quantity` | Float, `>= 0`, 2 decimals. |
| `method` | Which model produced it — currently always `"moving_average"`. Treat it as informational; new methods will appear here without the shape changing. |
| `window_days` | The window **actually used**. It is `min(window_days, days of history)`: with 3 days of history and the default window of 7, the response says `3`. |

### Model

Mean of the last `window_days` days of the gap-filled series, held flat across
the whole horizon. A flat line is intentional: feeding a moving average back
into itself only drifts towards the same mean, so the flat projection is both
the honest answer and the easy one to explain.

### Errors

| Case | `field` | Message |
|---|---|---|
| fewer than 3 history rows (incl. empty) | `history` | `history must have at least 3 data points, got 2` |
| `horizon_days` > 90 | `horizon_days` | `horizon_days must be at most 90, got 91` |
| `horizon_days` < 1 or missing | `horizon_days` | pydantic message |
| `window_days` > 90 | `window_days` | `window_days must be at most 90, got 91` |
| negative quantity | `history.0.quantity_sold` | pydantic message |
| unparseable date | `history.0.date` | pydantic message |
| unknown field | that field | `Extra inputs are not permitted` |

---

## POST /insight/trend

Compares the last N days against the N days before them. Pure statistics — no
model, no LLM call; the same input always yields the same sentence.

### Request

| Field | Type | Required | Rules |
|---|---|---|---|
| `product_id` | int | no | `>= 1`; only for logging/traceability, not returned |
| `history` | array | yes | same row shape as above; must span at least **4 days** after gap filling |
| `window_days` | int | no | length of **each** period; default **14** (`TREND_WINDOW_DAYS`) |

```json
{
  "product_id": 17,
  "history": [
    { "date": "2026-09-01", "quantity_sold": 5 },
    { "date": "2026-09-02", "quantity_sold": 5 },
    { "date": "2026-09-03", "quantity_sold": 10 },
    { "date": "2026-09-04", "quantity_sold": 10 }
  ]
}
```

### Response 200

```json
{
  "trend": "increasing",
  "change_percent": 100.0,
  "summary": "Penjualan naik 100,0% dalam 4 hari terakhir (20 unit vs 10 unit periode sebelumnya).",
  "window_days": 2,
  "recent_total": 20,
  "previous_total": 10
}
```

| Field | Meaning |
|---|---|
| `trend` | `"increasing"` \| `"decreasing"` \| `"stable"`. Stable means `abs(change_percent) < 5`. |
| `change_percent` | `(recent - previous) / previous * 100`, 1 decimal. Negative when falling. |
| `summary` | Ready-to-display Indonesian sentence (decimal comma). |
| `window_days` | Window actually used: `min(window_days, total_days // 2)`, so both periods fit. 9 days of history → `4` (a 4-vs-4 comparison, the oldest day unused). |
| `recent_total` / `previous_total` | Units sold in each period, so the caller can render its own wording. |

### Summary templates

| Situation | Sentence |
|---|---|
| up | `Penjualan naik 32,0% dalam 4 minggu terakhir (1848 unit vs 1400 unit periode sebelumnya).` |
| down | `Penjualan turun 45,0% dalam 4 minggu terakhir (154 unit vs 280 unit periode sebelumnya).` |
| stable | `Penjualan relatif stabil dalam 4 minggu terakhir (perubahan 3,3%).` |
| previous period sold nothing | `Penjualan mulai muncul: 42 unit dalam 14 hari terakhir, sebelumnya tidak ada penjualan.` (`change_percent` = `100.0`) |
| nothing sold in either period | `Belum ada penjualan dalam 4 minggu terakhir.` (`trend` = `stable`, `change_percent` = `0.0`) |

The period label is the span of **both** periods together (`window_days * 2`):
weeks when it divides by 7, otherwise days.

### Errors

| Case | `field` | Message |
|---|---|---|
| history spans fewer than 4 days | `history` | `history must cover at least 4 days to compare two periods, got 3` |
| `window_days` < 1 | `window_days` | pydantic message |
| unknown field | that field | `Extra inputs are not permitted` |

---

## Notes for the Go integration (next step)

- Call these synchronously from the Go service layer; no queue, no worker.
- Give the HTTP client a short timeout (the work is milliseconds) and treat a
  timeout or a 5xx as "forecast unavailable" rather than failing the request
  the user made — these numbers are advisory.
- A 422 from this service means the Go side sent something wrong; it should be
  logged as a bug, not forwarded verbatim to the mobile client.
- The history the backend already has: the analytics repository aggregates
  `sales_order_items` per day for CONFIRMED/SHIPPED orders. That output maps to
  `history` directly — `date` + `quantity_sold`, one row per day.
