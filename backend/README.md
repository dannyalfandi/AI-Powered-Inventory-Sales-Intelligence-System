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

If the password contains special characters (`@ : / ? #`), URL-encode them in `DATABASE_URL`.

Real environment variables override `.env`. The app refuses to start if `DATABASE_URL` or `REDIS_ADDR` is missing.

## Migration

```bash
go run ./cmd/migrate
```

Creates/updates tables for every model listed in `internal/model/models.go` (currently `categories`, `products`, `inventories`, `stock_movements`). It is additive only — it never drops tables or columns. Run it again after adding a model or a field.

Schema:

| Table | Key columns | Constraints |
|---|---|---|
| `categories` | `id`, `name`, `description`, timestamps, `deleted_at` | `name` unique among non-deleted rows |
| `products` | … + `category_id` (nullable) | FK → `categories.id` (`ON DELETE RESTRICT`) |
| `inventories` | `product_id` (PK, 1-1 with product), `quantity`, `low_stock_threshold`, timestamps | FK → `products.id`; `CHECK quantity >= 0`, `CHECK low_stock_threshold >= 0` |
| `stock_movements` | `id`, `product_id`, `type`, `quantity`, `quantity_before`, `quantity_after`, `reason`, `created_at` | FK → `products.id`; `CHECK type IN ('IN','OUT','ADJUSTMENT')`; index `(product_id, id)` |

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

`price` is an integer in whole Rupiah. Responses use `{"data": ...}`; errors use
`{"error": {"code", "message", "details"}}` with status 400 (bad JSON/ID), 404, 409 (duplicate SKU/category name, category in use), 422 (validation), 500.

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
```

## Test

```bash
go test ./...                  # all unit tests
go test -cover ./...           # with coverage
go test -run TestProductService ./internal/service -v
go test -run 'TestCategoryService|TestInventoryService' ./internal/service -v
```

Smoke test against a real API, which needs Postgres, migrations and `go run ./cmd/api`. It needs bash and curl; on Windows, use Git Bash:

```bash
bash scripts/e2e.sh          # Category + Product↔Category + Inventory, incl. 20 concurrent OUTs; exit 1 on any failure
```

It creates uniquely named data and soft-deletes it at the end. The `stock_movements`/`inventories` rows it creates stay behind.

Unit tests need no database. The service layer is tested with testify mocks of the repository interfaces.
The inventory mock's `Mutate` runs the service's mutation against an in-memory row, the same way the real repository does inside its transaction.

## Adding a new resource

Category is the simplest copy; it follows the Product slice exactly.


1. `internal/model/category.go`: entity + input types; add `&Category{}` to `model.All()`.
2. `internal/repository/category_repository.go`: interface + GORM implementation, use `translate(err)`.
3. `internal/service/category_service.go`: validation + `mapRepoError`; table-driven tests with a mock repo.
4. `internal/handler/category_handler.go`: bind JSON, call service, `writeError` on failure.
5. Register routes in `internal/router/router.go` and wire dependencies in `cmd/api/main.go`.
6. `go run ./cmd/migrate`.
