# backend

Go REST API for the Inventory & Sales Intelligence Platform (Gin + GORM + PostgreSQL + Redis).

## Layout

```
cmd/api            entrypoint: loads config, connects DB/Redis, starts HTTP server
cmd/migrate        runs GORM AutoMigrate for every model in model.All()
internal/config    env-var config loader (godotenv for local dev, fail-fast on missing vars)
internal/model     GORM entities + input/param types
internal/repository data access (GORM) — returns ErrNotFound / ErrDuplicateKey
internal/service   business logic + validation — returns ErrNotFound / ErrConflict / *ValidationError
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
| `APP_TIMEZONE` | IANA time zone for business dates, e.g. the date in order numbers (default `Asia/Jakarta`) |

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

Sales orders are never deleted (no soft delete either). A wrong order is cancelled instead.
`unit_price`, `product_sku` and `product_name` are snapshots taken when the order is created, so changing or deleting a product later doesn't rewrite order history.

`inventories` rows are created lazily on the first stock movement or threshold change. Until then a product has quantity 0 and `LOW_STOCK_DEFAULT_THRESHOLD`.
The threshold is copied into the row when it is created, so changing the env var later only affects products without a row.
`stock_movements` is append-only: there are no update/delete endpoints.

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
```

Smoke test against a real API, which needs Postgres, migrations and `go run ./cmd/api`. It needs bash and curl; on Windows, use Git Bash:

```bash
bash scripts/e2e.sh          # exit 1 on any failure
```

The script covers:
- Category, Product↔Category and Inventory, including 20 concurrent OUTs
- Customers
- the full sales order flow: create → confirm (stock down) → cancel (stock back) → ship, invalid transitions, and a rollback when one item is short
- concurrency: 5 orders racing for the same stock, one order confirmed 10× in parallel, and 20 parallel creates with unique order numbers

It creates uniquely named data and soft-deletes products and categories at the end. Stock movements, inventory rows, orders and customers with orders stay behind.

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
