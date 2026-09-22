# backend

Go REST API for the Inventory & Sales Intelligence Platform (Gin + GORM + PostgreSQL + Redis).

## Layout

```
cmd/api            entrypoint: loads config, connects DB/Redis, starts HTTP server
cmd/migrate        runs GORM AutoMigrate for every model in model.All()
cmd/seed           dev-only: demo dataset with ~3 months of back-dated sales (--clean to wipe it)
internal/config    env-var config loader (godotenv for local dev, fail-fast on missing vars)
internal/model     GORM entities + input/param types
internal/repository data access (GORM) — returns ErrNotFound / ErrDuplicateKey
internal/service   business logic + validation — returns ErrNotFound / ErrConflict / *ValidationError
internal/client    outbound HTTP clients (the Python ML service)
internal/i18n      message catalog (id/en) + Accept-Language parsing
internal/handler   Gin handlers — parse request, call service, map errors to HTTP
internal/router    route registration
pkg/database       Postgres connection
pkg/cache          Redis connection
pkg/response       shared JSON envelope
```

Request flow: `router → handler → service → repository → model`.

## Prerequisites

- Go **1.25+**
- Postgres + Redis running from `../infra` (`docker compose up -d`, see `../infra/README.md`)

## Setup

```bash
cd backend
cp .env.example .env        # PowerShell: Copy-Item .env.example .env
```

Edit `.env` so the credentials match `../infra/.env`:

| backend/.env | derived from infra/.env |
|---|---|
| `DATABASE_URL` | `postgres://POSTGRES_USER:POSTGRES_PASSWORD@localhost:POSTGRES_PORT/POSTGRES_DB?sslmode=disable` |
| `REDIS_ADDR` | `localhost:REDIS_PORT` |
| `REDIS_PASSWORD` | `REDIS_PASSWORD` |
| `REDIS_DB` | `0` (any 0–15) |
| `PORT` | HTTP port for the API (default `8080`) |
| `LOW_STOCK_DEFAULT_THRESHOLD` | low-stock threshold for products without their own setting (default `10`) |
| `APP_TIMEZONE` | IANA time zone for business dates, e.g. the date in order numbers and the days analytics groups by (default `Asia/Jakarta`) |
| `ANALYTICS_CACHE_TTL` | how long analytics summary/sales-trend stay cached in Redis (default `5m`; `0` disables caching) |
| `ML_SERVICE_URL` | base URL of the Python forecasting service in `/ml-service` (default `http://localhost:8000`) |
| `ML_SERVICE_TIMEOUT` | per-call timeout for that service (default `5s`) — it is called while a request is open |
| `FORECAST_CACHE_TTL` | how long a complete forecast/insight report stays cached (default `10m`; `0` disables) |

If the password contains special characters (`@ : / ? #`), URL-encode them in `DATABASE_URL`.

Real environment variables override `.env`. The app refuses to start if `DATABASE_URL` or `REDIS_ADDR` is missing.

## Migration

```bash
go run ./cmd/migrate
```

Creates/updates tables for every model listed in `internal/model/models.go` (currently `categories`, `products`, `inventories`, `customers`, `sales_orders`, `sales_order_items`, `sales_order_counters`, `stock_movements`). It is additive only — it never drops tables or columns. Run it again after adding a model or a field.

Schema:

| Table | Key columns | Constraints |
|---|---|---|
| `categories` | `id`, `name`, `description`, timestamps, `deleted_at` | `name` unique among non-deleted rows |
| `products` | … + `category_id` (nullable) | FK → `categories.id` (`ON DELETE RESTRICT`) |
| `inventories` | `product_id` (PK, 1-1 with product), `quantity`, `low_stock_threshold`, timestamps | FK → `products.id`; `CHECK quantity >= 0`, `CHECK low_stock_threshold >= 0` |
| `stock_movements` | `id`, `product_id`, `type`, `quantity`, `quantity_before`, `quantity_after`, `reason`, `sales_order_id` (nullable), `created_at` | FK → `products.id`, `sales_orders.id`; `CHECK type IN ('IN','OUT','ADJUSTMENT')`; index `(product_id, id)` |
| `customers` | `id`, `name`, `email` (nullable, lowercase), `phone`, `address`, timestamps, `deleted_at` | `email` unique among non-deleted rows (NULLs don't collide) |
| `sales_orders` | `id`, `order_number`, `customer_id`, `status`, `total_amount`, `notes`, `confirmed_at`/`shipped_at`/`cancelled_at` (nullable), timestamps | `order_number` unique; FK → `customers.id` (`RESTRICT`); `CHECK status IN (...)`, `CHECK total_amount >= 0`; indexes on `status`, `customer_id`, `created_at` |
| `sales_order_items` | `id`, `sales_order_id`, `product_id`, `product_sku`, `product_name`, `quantity`, `unit_price`, `subtotal` | FK → `sales_orders.id`, `products.id` (`RESTRICT`); `CHECK quantity > 0`, prices `>= 0` |
| `sales_order_counters` | `day` (PK, `YYYYMMDD`), `last_value` | per-day sequence for order numbers |

Analytics adds no table. It does add one index, `idx_sales_orders_status_confirmed_at` on `sales_orders (status, confirmed_at)`, because every analytics query filters exactly that pair (`status IN ('CONFIRMED','SHIPPED') AND confirmed_at` in range). It is declared with GORM tags on the model, so `go run ./cmd/migrate` creates it like any other index.

Sales orders are never deleted (no soft delete either). A wrong order is cancelled instead.
`unit_price`, `product_sku` and `product_name` are snapshots taken when the order is created, so changing or deleting a product later doesn't rewrite order history.

`inventories` rows are created lazily on the first stock movement or threshold change. Until then a product has quantity 0 and `LOW_STOCK_DEFAULT_THRESHOLD`.
The threshold is copied into the row when it is created, so changing the env var later only affects products without a row.
`stock_movements` is append-only: there are no update/delete endpoints.

## Demo data (`cmd/seed`)

Development tooling, not part of the running system: it fills the database
with a small Indonesian grocery wholesaler so the dashboard, the forecast and
the insights have something convincing to show.

```bash
go run ./cmd/seed --clean    # remove test/demo leftovers — explicit, never automatic
go run ./cmd/seed            # create the demo data (safe to re-run)
```

Running both, in that order, gives a demo database from scratch. What you get:

| | |
|---|---|
| 5 categories | Minuman, Makanan Ringan, Sembako, Perawatan Diri, Rumah Tangga |
| 26 products | SKUs `MNM-001`…`RTG-004`, realistic Rupiah prices (Rp 4.000 – Rp 120.000) |
| 10 customers | the warungs and kiosks the shop supplies |
| ~430 sales orders | **75 days** of history, ~74% SHIPPED, ~20% CONFIRMED, a few PENDING (last days) and ~5% CANCELLED (from PENDING and from CONFIRMED) |
| 5 products below their low-stock threshold | so the low-stock screen and the dashboard badge are not empty |

The shape of the history is the point:

- **Back-dated.** Orders are created through the normal service layer and then
  moved into the past (`created_at`, `confirmed_at`, `shipped_at`,
  `cancelled_at`, the stock movements and the order number). Analytics groups
  sales by `confirmed_at`, so without this the trend chart would be one spike
  on today.
- **A weekday rhythm** (Monday/Friday busy, Sunday quiet) — a flat daily line
  would make the moving-average forecast look broken.
- **Per-product trends over the last 30 days**, which is what makes the
  insights read like something: Kopi Bubuk Robusta rises ~60%, Telur Ayam
  ~40%, Gula Pasir falls, Sirup Cocopandan falls hard, the rest are stable.

Notes:

- Orders go through `service.SalesOrderService`, so stock movements, price
  snapshots and the state machine are produced by the real business logic, not
  by direct inserts. The seeder writes SQL in exactly one place: rewriting the
  timestamps and the order number of an order it just created.
- **Idempotent.** Categories, products and customers are matched by name / SKU
  / email and updated in place; the sales history is created only when there
  is none, so a second `go run ./cmd/seed` changes nothing. Use `--clean`
  first to regenerate it.
- `--clean` deletes rows it can identify: the `E2E-*`, `SMOKE-*`, `SHAPE-*`,
  `CACHE-*` leftovers from `scripts/e2e.sh` and from manual testing, plus
  everything this seeder created. Anything else in the database is left alone.
  Running `scripts/e2e.sh` after seeding adds its own test rows back — clean
  and re-seed before a demo.
- Flags: `--days` (default 75, minimum 14) and `--seed` (PRNG seed; the same
  seed always produces the same dataset).

## Run

```bash
go run ./cmd/api
```

Check it:

```bash
curl -i http://localhost:8080/health
# 200 {"status":"ok","checks":{"database":"up","redis":"up"}}
# 503 {"status":"degraded","checks":{..."redis":"down: ..."}} if a dependency is unreachable
```

## Languages (`Accept-Language`)

Every sentence this API sends back â€” validation messages, conflict and
not-found messages, the envelope message, and the insight summaries that come
from the ML service â€” is available in **Indonesian (`id`)** and **English
(`en`)**.

```bash
curl -i http://localhost:8080/api/v1/products/999999
# Content-Language: id
# 404 {"error":{"code":"not_found","message":"produk 999999 tidak ditemukan"}}

curl -i -H 'Accept-Language: en' http://localhost:8080/api/v1/products/999999
# Content-Language: en
# 404 {"error":{"code":"not_found","message":"product 999999 not found"}}
```

Rules:

- The header is parsed the way browsers send it: `en`, `en-US`,
  `en-US,en;q=0.9,id;q=0.8`, `*`. The highest-quality supported language wins.
- **Anything unknown or missing falls back to Indonesian**, so a client that
  sends no header (the current Flutter app) keeps the behaviour it had.
- Every response carries `Content-Language` with the language actually used.
- **Only sentences are translated.** Codes (`validation_failed`, `conflict`,
  `not_found`), field names (`category_id`, `items[0].quantity`), enum values
  (`PENDING`, `increasing`), SKUs, product names and numbers are data and
  never change â€” clients can keep matching on them.
- Stored text is not translated either: a stock movement's `reason` is an
  audit trail, written once in one language.

Where the messages live: `internal/i18n/catalog.go` holds every key with its
Indonesian and English text; services build messages with `i18n.T(ctx, key,
argsâ€¦)`, never with a literal. The language travels in the request context
(`internal/router/language.go` puts it there), so no service signature carries
a language parameter. A test enforces that every key exists in both languages
with the same placeholders.

**Forwarded to the ML service.** `/analytics/forecast` and `/analytics/insights`
pass the resolved language on as `"lang"` in the request body, so the sentence
in `summary` comes back in the same language as the rest of the response.

```bash
curl -H 'Accept-Language: en' "http://localhost:8080/api/v1/analytics/insights?limit=1"
# {"data":{...,"products":[{"product_name":"Kopi Bubuk Robusta 200g","trend":"increasing",
#  "change_percent":61.9,
#  "summary":"Sales increased 61.9% over the last 4 weeks (102 units vs 63 units in the previous period)."}]}}
```

## Endpoints

| Method | Path | Body / query | Success |
|---|---|---|---|
| GET | `/health` | – | 200 / 503 |
| POST | `/api/v1/products` | `{"sku","name","description","price","category_id"}` | 201 |
| GET | `/api/v1/products` | `?page=1&page_size=20&search=kopi` | 200 + `meta` |
| GET | `/api/v1/products/:id` | – | 200 |
| PATCH | `/api/v1/products/:id` | any subset of create fields | 200 |
| DELETE | `/api/v1/products/:id` | – | 204 (soft delete) |
| POST | `/api/v1/categories` | `{"name","description"}` | 201 |
| GET | `/api/v1/categories` | `?page=1&page_size=20&search=minum` | 200 + `meta` |
| GET | `/api/v1/categories/:id` | – | 200 |
| PATCH | `/api/v1/categories/:id` | any subset of create fields | 200 |
| DELETE | `/api/v1/categories/:id` | – | 204 (soft delete), **409 while products use it** |
| GET | `/api/v1/inventory/low-stock` | `?page=1&page_size=20` | 200 + `meta` |
| GET | `/api/v1/inventory/:product_id` | – | 200 |
| PATCH | `/api/v1/inventory/:product_id` | `{"low_stock_threshold"}` | 200 |
| POST | `/api/v1/inventory/:product_id/movements` | `{"type","quantity","reason"}` | 201 |
| GET | `/api/v1/inventory/:product_id/movements` | `?page=1&page_size=20` | 200 + `meta` |
| POST | `/api/v1/customers` | `{"name","email","phone","address"}` | 201 |
| GET | `/api/v1/customers` | `?page=1&page_size=20&search=budi` (name, email or phone) | 200 + `meta` |
| GET | `/api/v1/customers/:id` | – | 200 |
| PATCH | `/api/v1/customers/:id` | any subset of create fields | 200 |
| DELETE | `/api/v1/customers/:id` | – | 204 (soft delete), **409 while it has orders that are not CANCELLED** |
| POST | `/api/v1/sales-orders` | `{"customer_id","items":[{"product_id","quantity"}],"notes"}` | 201 (status `PENDING`) |
| GET | `/api/v1/sales-orders` | `?page=1&page_size=20&status=PENDING&customer_id=3` | 200 + `meta` (with `customer`, without `items`) |
| GET | `/api/v1/sales-orders/:id` | – | 200 (with `customer` and `items`) |
| PATCH | `/api/v1/sales-orders/:id/status` | `{"status":"CONFIRMED"}` | 200 |
| GET | `/api/v1/analytics/summary` | `?from=&to=` | 200 |
| GET | `/api/v1/analytics/sales-trend` | `?from=&to=&granularity=daily\|weekly` | 200 |
| GET | `/api/v1/analytics/top-products` | `?from=&to=&limit=10` | 200 |
| GET | `/api/v1/analytics/category-breakdown` | `?from=&to=` | 200 |
| GET | `/api/v1/analytics/low-stock-alert-count` | – | 200 |
| GET | `/api/v1/analytics/forecast` | `?from=&to=&limit=10&horizon_days=7` | 200 |
| GET | `/api/v1/analytics/insights` | `?from=&to=&limit=10` | 200 |

`price` is an integer in whole Rupiah. Responses use `{"data": ...}`; errors use
`{"error": {"code", "message", "details"}}` with status 400 (bad JSON/ID/query), 404, 409 (duplicate SKU/category name/email, category or customer in use), 422 (validation, invalid status transition, insufficient stock), 500.

Products:

- `category_id` is optional. Products include the `category` object when they have one.
- On PATCH, an omitted or `null` `category_id` keeps the current category, and `0` removes it.
- A `category_id` that doesn't exist (or is soft-deleted) returns 422 on the `category_id` field.

Inventory:

- `GET /inventory/:product_id` returns `{"product_id","quantity","low_stock_threshold","is_low_stock","created_at","updated_at"}`. `is_low_stock` means `quantity <= low_stock_threshold`.
- Movement `type` is `IN` (adds `quantity`), `OUT` (subtracts it) or `ADJUSTMENT` (sets stock to `quantity`, e.g. after a stock count). The type is case-insensitive.
  `quantity` is required. It must be > 0 for IN/OUT and >= 0 for ADJUSTMENT.
- An `OUT` larger than the current stock returns 422 on `quantity` (`insufficient stock: 20 available, 21 requested`). Stock never goes negative.
- A movement updates `inventories.quantity` and inserts the `stock_movements` row in one transaction, with the inventory row locked (`SELECT … FOR UPDATE`). Concurrent movements on the same product are serialized.
  The response is `{"movement": {...}, "inventory": {...}}`.
- Movements are listed newest first.
- `low-stock` lists non-deleted products with `quantity <= low_stock_threshold`, lowest stock first. Products with no inventory row count as quantity 0 with the default threshold.

Customers:

- Only `name` is required. `email` is trimmed and lowercased, and must be unique among customers that aren't deleted (409). An empty email is stored as `null`; on PATCH, `""` removes it.
- `phone` accepts digits with an optional leading `+`, spaces, dashes and parentheses (6–32 characters).
- DELETE returns 409 while the customer has any order that is not `CANCELLED`, including `SHIPPED` orders, which stay as history.

Sales orders:

- **Create** (`POST`) validates:
  - The customer exists and isn't deleted (422 `customer_id`).
  - There are 1–100 items.
  - Each product exists and isn't deleted (422 `items[i].product_id`).
  - Each product appears only once (422 `items[i].product_id`; combine the quantities).
  - Each quantity is 1–1,000,000.

  It snapshots each product's current `price` as `unit_price` and computes `subtotal` and `total_amount`. The order starts `PENDING` and **stock is not touched**.
- **Order number**: `SO-YYYYMMDD-NNNN`, where the date is in `APP_TIMEZONE` and the counter restarts every day (4 digits, wider after 9999).
  It comes from `sales_order_counters`, upserted in the same transaction as the order, so parallel creates get unique numbers without gaps.
- **Items can't be edited** after creation; there is no endpoint for it. If an order is wrong, cancel it and create a new one. This keeps stock movements and order history consistent: a confirmed order's items are exactly what was taken from stock.

Status state machine (`PATCH /api/v1/sales-orders/:id/status`, status is case-insensitive):

```
            confirm (stock OUT per item)        ship (no stock change)
  PENDING ───────────────────────────► CONFIRMED ─────────────────────► SHIPPED  (final)
     │                                     │
     │ cancel (no stock change)            │ cancel (stock IN per item: returns what was taken)
     └──────────────► CANCELLED ◄──────────┘                                     (final)
```

| From \ To | PENDING | CONFIRMED | SHIPPED | CANCELLED |
|---|---|---|---|---|
| PENDING | 422 | ✅ deduct stock | 422 | ✅ |
| CONFIRMED | 422 | 422 | ✅ | ✅ return stock |
| SHIPPED | 422 | 422 | 422 | 422 |
| CANCELLED | 422 | 422 | 422 | 422 |

- Every transition runs in one transaction. It locks the order row (`FOR UPDATE`), so concurrent requests on one order are serialized and the second one sees the new status.
  For stock changes it also locks the inventory rows in ascending `product_id` order, the same lock as manual stock movements, which avoids deadlocks between orders.
- **Confirm** checks every item before changing anything. If any item is short (or its product was deleted after ordering), nothing changes and the order stays `PENDING`.
  The 422 lists every problem item, e.g.
  `{"field":"items[1].quantity","message":"insufficient stock for product 7 (TEH-1): 3 available, 10 requested"}`.
  A product with no inventory row counts as stock 0.
- Each stock change is a normal `stock_movements` row with `sales_order_id` set and a reason like `sales order SO-20260920-0001 confirmed` / `… cancelled`, so it also shows up in the product's movement history.
- `confirmed_at`, `shipped_at` and `cancelled_at` record when each transition happened.

Analytics (read-only; there is no analytics table):

- Every number is aggregated by Postgres from `sales_orders` + `sales_order_items` (+ `products`/`categories`) at request time, so nothing can go stale.
- **What counts as a sale:** orders with status `CONFIRMED` or `SHIPPED`. `PENDING` hasn't taken stock yet and `CANCELLED` was undone, so both are left out of every figure.
- **The sale date is `confirmed_at`**, grouped into calendar days in `APP_TIMEZONE`.
- **Date range:** `from`/`to` are `YYYY-MM-DD`, inclusive on both ends. Defaults to the last 30 days; a missing `from` is 29 days before `to`, a missing `to` is today. `from` must be on or before `to` and the range is capped at 366 days (422 otherwise).
- `limit` on top-products defaults to 10 and is capped at 50. Its SKU and name come from the order item snapshot, so a later rename doesn't rewrite history.
- The category breakdown uses the product's *current* category (order items don't snapshot it); products without one are grouped as `"category_id": null`. Soft-deleted products and categories stay included, so the breakdown still adds up to the summary revenue.
- `low-stock-alert-count` calls the same inventory service as `GET /inventory/low-stock`, so the number can't drift from the list.

```bash
curl "http://localhost:8080/api/v1/analytics/summary?from=2026-09-01&to=2026-09-20"
# {"data":{"range":{"from":"2026-09-01","to":"2026-09-20"},
#          "total_revenue":673000,"total_orders":10,"total_items_sold":30,"average_order_value":67300}}

curl "http://localhost:8080/api/v1/analytics/sales-trend?from=2026-09-18&to=2026-09-20&granularity=daily"
# {"data":{"range":{"from":"2026-09-18","to":"2026-09-20"},"granularity":"daily","points":[
#   {"period_start":"2026-09-18","period_end":"2026-09-18","revenue":0,"orders":0},
#   {"period_start":"2026-09-19","period_end":"2026-09-19","revenue":0,"orders":0},
#   {"period_start":"2026-09-20","period_end":"2026-09-20","revenue":928000,"orders":13}]}}
# weekly buckets start on Monday: {"period_start":"2026-09-14","period_end":"2026-09-20",...}

curl "http://localhost:8080/api/v1/analytics/top-products?from=2026-09-20&to=2026-09-20&limit=3"
# {"data":{"range":{...},"products":[
#   {"product_id":17,"sku":"KOPI-001","name":"Kopi Arabica","quantity_sold":3,"revenue":135000}]}}

curl "http://localhost:8080/api/v1/analytics/category-breakdown?from=2026-09-20&to=2026-09-20"
# {"data":{"range":{...},"categories":[
#   {"category_id":null,"category_name":"Tanpa Kategori","quantity_sold":34,"revenue":778000},
#   {"category_id":8,"category_name":"Minuman","quantity_sold":2,"revenue":90000}]}}

curl http://localhost:8080/api/v1/analytics/low-stock-alert-count
# {"data":{"count":11}}

# Forecasting — needs ../ml-service running (uvicorn app.main:app --port 8000)
curl "http://localhost:8080/api/v1/analytics/forecast?limit=2&horizon_days=3"
# {"data":{"range":{"from":"2026-08-22","to":"2026-09-20"},"horizon_days":3,"forecast_available":true,"products":[
#   {"product_id":17,"product_name":"Kopi Arabica","sku":"KOPI-001","method":"moving_average",
#    "forecast":[{"date":"2026-09-21","predicted_quantity":0.43},
#                {"date":"2026-09-22","predicted_quantity":0.43},
#                {"date":"2026-09-23","predicted_quantity":0.43}]}]}}

curl "http://localhost:8080/api/v1/analytics/insights?limit=2"
# {"data":{"range":{...},"insights_available":true,"products":[
#   {"product_id":17,"product_name":"Kopi Arabica","sku":"KOPI-001","trend":"increasing","change_percent":32,
#    "summary":"Penjualan naik 32,0% dalam 4 minggu terakhir (1848 unit vs 1400 unit periode sebelumnya)."}]}}

# Same call with the ML service stopped: still 200, degraded per product.
curl "http://localhost:8080/api/v1/analytics/forecast?limit=2"
# {"data":{"range":{...},"horizon_days":7,"forecast_available":false,"products":[
#   {"product_id":17,"product_name":"Kopi Arabica","sku":"KOPI-001",
#    "error":"layanan forecasting sedang tidak tersedia"}]}}

curl "http://localhost:8080/api/v1/analytics/summary?from=2020-01-01&to=2026-09-20"
# 422 {"error":{"code":"validation_failed","message":"request validation failed",
#      "details":[{"field":"to","message":"range must be at most 366 days"}]}}
```

Trend points include periods without sales (`revenue: 0`), so a chart has no gaps.

Forecasting and insights (`/analytics/forecast`, `/analytics/insights`) — **needs the Python ML service running**:

- Both take the best sellers of the range (the same aggregation as `top-products`), build a gap-filled daily history per product in **one** SQL query, and call the ML service in `/ml-service` once per product, **in parallel** (at most 8 at a time). `forecast` asks `POST /forecast/demand` for `horizon_days` days ahead (default 7, max 90); `insights` asks `POST /insight/trend` for one Indonesian sentence per product. The contract is in [`../docs/ml-service-contract.md`](../docs/ml-service-contract.md).
- **Graceful degradation is the point here.** The ML service is a separate process, so it can be down while this API is fine:
  - a product whose call fails carries `"error"` instead of its numbers, and the others keep theirs;
  - if *every* product fails — the ML service is down, or `ML_SERVICE_URL` is wrong — the response is still **200**, with `"forecast_available": false` (`"insights_available": false` for insights), so a client can show "forecasting sedang tidak tersedia" next to the analytics it did get. It is never a 5xx;
  - the real cause (connection refused, timeout, a 422 from the ML service) is logged here; the response carries a short Indonesian message.
- The range must cover at least 4 days, otherwise 422 on `from` — below that the ML service has nothing to compare and would reject every call.
- Only a **fully successful** report is cached (`FORECAST_CACHE_TTL`, default 10 minutes, key `analytics:v1:forecast|insights:<from>:<to>:<products>[:<horizon>]`). Caching a degraded one would keep the dashboard broken for the whole TTL after the ML service comes back.
- Start the ML service separately: `cd ../ml-service && uvicorn app.main:app --port 8000` (see its README). Without it, everything else in this API keeps working.

**Caching.** `summary` and `sales-trend` are cached in Redis for `ANALYTICS_CACHE_TTL` (default 5 minutes); they are the queries a dashboard hits on every load. The key is `analytics:v1:<query>[:<granularity>]:<from>:<to>`, so each range and granularity is cached separately. There is no invalidation on write: the dashboard may lag up to the TTL behind a new order. `top-products`, `category-breakdown` and `low-stock-alert-count` are not cached (cheap, and usually wanted fresh). A Redis outage is logged and treated as a cache miss, never an error.

Examples:

```bash
curl -X POST http://localhost:8080/api/v1/categories \
  -H "Content-Type: application/json" \
  -d '{"name":"Minuman","description":"Kopi, teh"}'

curl -X POST http://localhost:8080/api/v1/products \
  -H "Content-Type: application/json" \
  -d '{"sku":"KOPI-001","name":"Kopi Arabica 250g","price":45000,"category_id":1}'

curl -X POST http://localhost:8080/api/v1/inventory/1/movements \
  -H "Content-Type: application/json" \
  -d '{"type":"IN","quantity":50,"reason":"restock"}'

curl http://localhost:8080/api/v1/inventory/low-stock

curl -X POST http://localhost:8080/api/v1/customers \
  -H "Content-Type: application/json" \
  -d '{"name":"Budi Santoso","email":"budi@example.com","phone":"+62 812-3456-7890"}'

curl -X POST http://localhost:8080/api/v1/sales-orders \
  -H "Content-Type: application/json" \
  -d '{"customer_id":1,"items":[{"product_id":1,"quantity":3}],"notes":"kirim sore"}'

curl -X PATCH http://localhost:8080/api/v1/sales-orders/1/status \
  -H "Content-Type: application/json" \
  -d '{"status":"CONFIRMED"}'
```

## Test

```bash
go test ./...                  # all unit tests
go test -cover ./...           # with coverage
go test -run TestProductService ./internal/service -v
go test -run 'TestCategoryService|TestInventoryService' ./internal/service -v
go test -run 'TestCustomerService|TestSalesOrderService' ./internal/service -v
go test -run TestAnalyticsService ./internal/service -v
go test -run 'TestForecast|TestInsights' ./internal/service -v   # ML integration, with a fake client
go test ./internal/client -v                                     # the ML HTTP client (httptest)
```

Smoke test against a real API, which needs Postgres, migrations and `go run ./cmd/api`. It needs bash and curl; on Windows, use Git Bash:

```bash
bash scripts/e2e.sh          # exit 1 on any failure
```

The script covers:
- Category, Product↔Category and Inventory, including 20 concurrent OUTs
- Customers
- the full sales order flow: create → confirm (stock down) → cancel (stock back) → ship, invalid transitions, and a rollback when one item is short
- analytics: orders in four statuses, then checks that only the CONFIRMED/SHIPPED ones show up in summary, top-products and category-breakdown, plus trend shape, the alert count and the date validation.
  Summary and trend are cached, so the script compares them against a baseline taken before its own orders; if it sees a cached response it says so instead of failing. Start the API with `ANALYTICS_CACHE_TTL=0` to assert those numbers exactly.
- forecasting: if the ML service answers on `/health`, the script asserts the happy path (`forecast_available: true`, 7 predicted days per product, an Indonesian `summary` per product). **If it does not answer, the script switches to the degradation checks instead** — 200 with `forecast_available: false` and a per-product error — so running it twice, once with the ML service up and once with it stopped, covers both paths.
- concurrency: 5 orders racing for the same stock, one order confirmed 10× in parallel, and 20 parallel creates with unique order numbers

It creates uniquely named data and soft-deletes products and categories at the end. Stock movements, inventory rows, orders and customers with orders stay behind.

The analytics SQL has its own tests against a real Postgres, because "only CONFIRMED and SHIPPED count" lives in the queries and a mock can't prove it. They skip unless `TEST_DATABASE_URL` is set, and run inside a transaction that is rolled back, so the database keeps its data:

```bash
TEST_DATABASE_URL="postgres://inventory:...@localhost:5432/inventory_intel?sslmode=disable" \
  go test ./internal/repository -run Analytics -v
```

Unit tests need no database. The service layer is tested with testify mocks of the repository interfaces.
- The inventory mock's `Mutate` runs the service's mutation against an in-memory row, the same way the real repository does inside its transaction.
- The sales order tests use an in-memory store whose `InTx` runs the callback on a copy and commits it only on success. That lets the tests check that a failed confirm (short stock, or a write error half way) leaves stock, movements and status untouched.

## Adding a new resource

Category is the simplest copy; it follows the Product slice exactly.


1. `internal/model/category.go`: entity + input types; add `&Category{}` to `model.All()`.
2. `internal/repository/category_repository.go`: interface + GORM implementation, use `translate(err)`.
3. `internal/service/category_service.go`: validation + `mapRepoError`; table-driven tests with a mock repo.
4. `internal/handler/category_handler.go`: bind JSON, call service, `writeError` on failure.
5. Register routes in `internal/router/router.go` and wire dependencies in `cmd/api/main.go`.
6. `go run ./cmd/migrate`.
