# backend

Go REST API for the Inventory & Sales Intelligence Platform (Gin + GORM + PostgreSQL + Redis).

## Layout

```
cmd/api            entrypoint: loads config, connects DB/Redis, starts HTTP server
cmd/migrate        runs GORM AutoMigrate for every model in model.All()
cmd/seed           dev-only: demo dataset with ~3 months of back-dated sales (--clean to wipe it),
                   plus the Super Admin / Staff roles and accounts (--auth-only for just those)
internal/auth      permission catalog, JWT issue/parse, bcrypt, the caller in the request context
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
| `JWT_SECRET` | **required by the API**: signs access and refresh tokens (HS256), at least 32 characters. Generate one with `openssl rand -base64 48`. Changing it logs everyone out |
| `JWT_ACCESS_TTL` | access token lifetime (default `15m`) |
| `JWT_REFRESH_TTL` | refresh token lifetime (default `168h` = 7 days); must be longer than the access TTL |
| `SEED_ADMIN_EMAIL` / `SEED_ADMIN_PASSWORD` | read by `cmd/seed` only: the first Super Admin. Empty → `admin@example.com` / `admin12345` and a WARNING in the log |

If the password contains special characters (`@ : / ? #`), URL-encode them in `DATABASE_URL`.

Real environment variables override `.env`. The app refuses to start if `DATABASE_URL` or `REDIS_ADDR` is missing, and the API also refuses to start without `JWT_SECRET`. `cmd/migrate` and `cmd/seed` don't need `JWT_SECRET`, but if it is set it must be valid.

## Migration

```bash
go run ./cmd/migrate
```

Creates/updates tables for every model listed in `internal/model/models.go` (currently `categories`, `products`, `inventories`, `customers`, `sales_orders`, `sales_order_items`, `sales_order_counters`, `stock_movements`, `roles`, `permissions`, `role_permissions`, `users`, `refresh_tokens`). It is additive only — it never drops tables or columns. Run it again after adding a model or a field.

It then **syncs the permission catalog**: the `permissions` table is made to match `auth.Catalog` in `internal/auth/permissions.go` exactly. New keys are inserted, descriptions updated, and keys removed from code are deleted (their role links cascade). Run it after every deploy that changes the catalog.

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
| `roles` | `id`, `name`, `description`, `is_system`, timestamps | `name` unique. `is_system` = the Super Admin role |
| `permissions` | `id`, `key` (`products.create`), `description`, `resource_group` | `key` unique. Synced from code by `cmd/migrate`, never created through the API |
| `role_permissions` | `role_id`, `permission_id` (composite PK) | FKs `ON DELETE CASCADE` on both sides |
| `users` | `id`, `email` (lowercase), `password_hash` (bcrypt), `name`, `role_id`, `is_active`, timestamps, `deleted_at` | `email` unique among non-deleted rows; FK → `roles.id` (`RESTRICT`) |
| `refresh_tokens` | `id`, `user_id`, `token_hash` (SHA-256), `expires_at`, `revoked_at` (nullable), `created_at` | `token_hash` unique; FK → `users.id` (`CASCADE`) |

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
go run ./cmd/seed --clean      # remove test/demo leftovers — explicit, never automatic
go run ./cmd/seed              # create the accounts + the demo data (safe to re-run)
go run ./cmd/seed --auth-only  # only the roles and accounts, no demo data
```

Running the first two, in that order, gives a demo database from scratch. What you get:

| | |
|---|---|
| 2 roles | **Super Admin** (`is_system`, every permission) and **Staff** (12 permissions, see [Roles](#roles)) |
| 2 accounts | the Super Admin from `SEED_ADMIN_EMAIL`/`SEED_ADMIN_PASSWORD` (default `admin@example.com` / `admin12345`, with a WARNING in the log), and `staff@example.com` / `staff12345` |
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
  `CACHE-*` leftovers from `scripts/e2e.sh` and from manual testing (including
  its `e2e.*@example.test` users and `E2E *` roles), plus the demo data this
  seeder created. **The seeded accounts and roles are kept**, so you can still
  log in after `--clean` + seed. Anything else in the database is left alone.
- Accounts are created only if the email doesn't exist yet: a re-run never
  resets a password you changed. The Staff role gets its permissions only
  when it is created, so edits made through the API survive a re-seed.
  Running `scripts/e2e.sh` after seeding adds its own test rows back — clean
  and re-seed before a demo.
- `--clean-e2e-run=<run id>` is the narrow version that `scripts/e2e.sh` calls
  at the end of every run: it hard-deletes only that run's users
  (`e2e.*.<run>@example.test`) and roles (`E2E * <run>`). The API can't
  remove those roles itself — the run's soft-deleted users still reference
  them, so `DELETE /roles/:id` answers 409 by design — which is why earlier
  runs left `E2E …` roles behind. A role still referenced by a user outside
  the run is kept, and the command fails loudly.
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

## Authentication & access control

Every endpoint under `/api/v1` requires a login, except `/auth/login`, `/auth/refresh` and `/auth/logout`. `/health` stays public for probes.

### Login, refresh, logout

```bash
# 1. Log in → an access token (15 min) and a refresh token (7 days)
curl -s -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"admin12345"}'
# 200 {"data":{"access_token":"eyJ…","refresh_token":"eyJ…","token_type":"Bearer","expires_in":900,
#   "user":{"id":1,"email":"admin@example.com","name":"Super Admin",
#           "role":{"id":1,"name":"Super Admin","is_system":true}}}}

TOKEN=eyJ…            # the access_token
AUTH="Authorization: Bearer $TOKEN"

# 2. Call the API with the access token
curl -s -H "$AUTH" http://localhost:8080/api/v1/auth/me
# 200 {"data":{"id":1,"email":"admin@example.com","name":"Super Admin","is_active":true,
#   "role":{"id":1,"name":"Super Admin","is_system":true},
#   "permissions":["products.view","products.create",…,"roles.assign_permissions"]}}

# 3. When the access token expires (401 "token_expired"), exchange the refresh token.
#    You get a NEW pair; the refresh token you sent is revoked (rotation).
curl -s -X POST http://localhost:8080/api/v1/auth/refresh \
  -H "Content-Type: application/json" -d '{"refresh_token":"eyJ…"}'
# 200 {"data":{"access_token":"eyJ…(new)","refresh_token":"eyJ…(new)",…}}
# Sending the same refresh token again → 401: each one works exactly once.

# 4. Log out: revokes the refresh token. 204 (also if it was already revoked).
curl -s -X POST http://localhost:8080/api/v1/auth/logout \
  -H "Content-Type: application/json" -d '{"refresh_token":"eyJ…"}'
```

**401 and 403.** The `code` says what the client should do; the `message` is translated.

| Status | `code` | When | Client reaction |
|---|---|---|---|
| 401 | `invalid_credentials` | wrong email or password, or the account is inactive (one answer for all three, so the endpoint can't be used to probe accounts) | show the message |
| 401 | `token_expired` | the access token expired | call `/auth/refresh`, retry once |
| 401 | `unauthorized` | no token, a malformed/forged token, a refresh token used as an access token, a revoked/expired/reused refresh token, or a user deactivated or deleted since login | go to the login screen |
| 403 | `forbidden` | logged in, but the role lacks the permission (`"anda tidak punya izin products.delete"`) | hide or disable the action |

Every 401 carries `WWW-Authenticate: Bearer realm="api"`.

**Design notes.**

- **Tokens.** Both are HS256 JWTs signed with `JWT_SECRET`. The claims are minimal: `uid`, `rid` (role id), `typ` (`access`/`refresh`), `exp`, `iat`, and a random `jti`. `typ` stops a 7-day refresh token from being accepted as an access token. Permissions are never in the token.
- **Refresh tokens live in the database as a SHA-256 hash**, never in clear text. SHA-256 rather than bcrypt: the token is a signed JWT with 128 random bits, so there is nothing to brute-force, and a deterministic hash is what lets `/auth/refresh` find the row. A refresh token is honoured only if its signature is valid **and** its hash is in `refresh_tokens`, not revoked and not expired.
- **Rotation under a row lock.** `/auth/refresh` locks the token row (`SELECT … FOR UPDATE`), revokes it and inserts the new one in one transaction. Five parallel refreshes with the same token give exactly one 200 and four 401s (`scripts/e2e.sh` checks this).
- **Passwords** are bcrypt (cost 10), 8–72 bytes. bcrypt ignores everything after byte 72, so longer passwords are rejected rather than silently truncated. Login spends the same bcrypt time for an unknown email as for a wrong password.
- **Refresh-token reuse detection.** Every refresh token works exactly once, so a *revoked* one presented again (rotated away, or logged out) means two parties hold it: the user and whoever copied it. The server can't tell which one is asking, so it **revokes every refresh token of that user**. That ends the thief's session (whatever it rotated to) and all of the user's own devices, and the user logs in again with their password.
  - The reply is the same 401 (`unauthorized`, same message) as any other failed refresh, byte for byte, so the caller can't tell the reuse was noticed. The detection only shows in the server log: `WARN refresh token reuse detected; revoked every session of the user user_id=… sessions_revoked=…`.
  - Only a revoked token counts. A forged, expired, unknown or wrong-type token is refused without touching the user's sessions, otherwise anyone could log a user out everywhere by sending garbage.
  - Access tokens already issued are not revoked (they are not stored). They expire within `JWT_ACCESS_TTL`.
  - **Client contract (for the Flutter app):** refresh one request at a time (single-flight), and never blindly retry a refresh whose response was lost. A retried refresh looks exactly like reuse and logs the user out on every device.
- **Deactivating a user, deleting them, or changing their password revokes all their refresh tokens** in the same transaction.
- **Logout doesn't kill the access token.** It stays valid until it expires (at most `JWT_ACCESS_TTL`), and the client discards it. The exception is a deactivated or deleted user: the permission check reads `users.is_active` on every request, so their live access token stops working immediately.

### Permission checks are not cached

`RequirePermission(key)` runs one query per request, joining `users → roles → role_permissions → permissions` by primary key and unique index. It reads the user's **current** role from `users.role_id`, not the role id in the token. So:

- removing a permission from a role applies **on the next request**, even for a token issued earlier;
- moving a user to another role applies on the next request;
- deactivating or deleting a user blocks their next request (401).

This is deliberate. For an access-control decision, being right on the next request is worth one indexed query. A cache would make every revocation take effect only after its TTL. If this ever needs optimising, that is a separate decision (see `service.Authorizer`).

A role with `is_system = true` (Super Admin) passes every check without reading `role_permissions`.

### Permissions

The catalog is fixed in code (`internal/auth/permissions.go`) and synced into `permissions` by `cmd/migrate`. The API only arranges these keys into roles; it never creates new ones. `GET /api/v1/permissions` returns them with descriptions in the request's language.

| Group | Permissions |
|---|---|
| `products` | `products.view`, `products.create`, `products.update`, `products.delete` |
| `categories` | `categories.view`, `categories.create`, `categories.update`, `categories.delete` |
| `inventory` | `inventory.view` (stock, movements, low stock), `inventory.update` (low-stock threshold), `inventory.record_movement` (IN/OUT/ADJUSTMENT) |
| `customers` | `customers.view`, `customers.create`, `customers.update`, `customers.delete` |
| `sales_orders` | `sales_orders.view`, `sales_orders.create`, `sales_orders.confirm` (deducts stock), `sales_orders.ship`, `sales_orders.cancel` |
| `analytics` | `analytics.view` (summary, trend, top products, categories, low-stock count), `analytics.forecast`, `analytics.insights` |
| `users` | `users.view`, `users.create`, `users.update` (includes role and `is_active`), `users.delete` |
| `roles` | `roles.view` (also `GET /permissions`), `roles.create`, `roles.update` (name/description), `roles.delete`, `roles.assign_permissions` |

`GET /api/v1/roles` (the list) is the one route that opens for any of several permissions: `roles.view`, `users.create` or `users.update`, because a user manager picks a user's role from it. The middleware is `RequireAnyPermission`; it asks in that order and stops at the first grant (up to three permission queries for a caller who has none). The detail route `GET /roles/:id`, `GET /permissions` and every role write stay `roles.*` only. Which role a user manager may actually *assign* is decided by the user service (see the rules below), not by what the list shows.

32 permissions in total.

### Roles

| Role | Permissions |
|---|---|
| **Super Admin** (`is_system`) | all, by bypass. Can't be deleted, renamed or given a permission list |
| **Staff** (seeded) | `products.view`, `categories.view`, `inventory.view`, `customers.view`, `sales_orders.view`, `sales_orders.create`, `sales_orders.confirm`, `sales_orders.ship`, `sales_orders.cancel`, `analytics.view`, `analytics.forecast`, `analytics.insights`. So: sees everything, takes and processes orders; can't delete anything, edit the catalogue or stock, or manage users and roles |

**One role per user** is a deliberate simplification for this version. Multi-role would turn `users.role_id` into a join table and the permission check into a union over roles. The catalog, the middleware and the endpoints would stay the same.

Managing roles (as a Super Admin):

```bash
# a role for the warehouse: stock only
curl -s -X POST -H "$AUTH" -H "Content-Type: application/json" \
  http://localhost:8080/api/v1/roles -d '{"name":"Gudang","description":"Staf gudang"}'
# 201 {"data":{"id":3,"name":"Gudang","is_system":false,"user_count":0,"permissions":[],…}}

# set its permissions — REPLACES the list (send [] to clear it)
curl -s -X PUT -H "$AUTH" -H "Content-Type: application/json" \
  http://localhost:8080/api/v1/roles/3/permissions \
  -d '{"permission_keys":["inventory.view","inventory.record_movement","products.view"]}'
# 200 {"data":{"id":3,…,"permissions":["products.view","inventory.view","inventory.record_movement"]}}
# An unknown key → 422 on "permission_keys[i]". Duplicates are ignored.

# give a user that role
curl -s -X POST -H "$AUTH" -H "Content-Type: application/json" \
  http://localhost:8080/api/v1/users \
  -d '{"email":"gudang@example.com","password":"rahasia123","name":"Budi Gudang","role_id":3}'
```

#### `user_count`

Every role in a response (list, detail, create, update, set permissions) carries `user_count`: the number of users whose `role_id` is that role, **soft-deleted users included** (inactive users are included too).

```json
{"id":82,"name":"Gudang","description":"","is_system":false,"user_count":2,
 "created_at":"…","updated_at":"…","permissions":["products.view","products.delete","users.view"]}
```

It counts deleted users on purpose, so that it is the same number that decides `DELETE /roles/:id`. A deleted user keeps `role_id` as history and `users.role_id` is `ON DELETE RESTRICT`, so Postgres itself refuses to delete a role while any user row — deleted or not — points at it. A count of live users only would show `0` for a role that still answers 409. So `user_count > 0` ⇔ the delete answers 409, and the 409 message quotes that number (`role 82 masih terhubung dengan 2 pengguna (termasuk yang sudah dihapus)`). There is one definition (`roleColumnsWithUserCount` in `internal/repository/role_repository.go`), computed in the same `SELECT` that loads the roles (a correlated subquery on the `users.role_id` index), so a page of roles costs the same three statements whatever its size: the total, the page with its counts, the permission keys. `role_repository_integration_test.go` checks both the definition and the statement count against Postgres.

Rules the service enforces:

| Rule | Response |
|---|---|
| The Super Admin role can't be deleted, renamed or given a permission list | 409 |
| A role can't be deleted while `user_count > 0` — any user has it, including soft-deleted users (they keep `role_id` as history) | 409 |
| Nobody can deactivate, delete, or change the role of **their own** account | 409 |
| At least one active Super Admin must remain. Enforced under a lock on every Super Admin row, so two admins demoting each other at once can't both succeed | 409 |
| Only a Super Admin can grant the Super Admin role, or change or delete a Super Admin account | 403 |
| Someone with `roles.assign_permissions` who is not a Super Admin can only grant permissions they hold themselves | 403 |
| A non-Super-Admin can only **give** a user (create, or change `role_id`) a role whose permissions they all hold themselves | 403 `rule.role_exceeds_own_permissions` |
| A non-Super-Admin can only **change** (any field: password, role, `is_active`, name, email) or **delete** a user whose current role they hold in full. Without this, `users.update` could reset a stronger account's password and log in as it | 403 `rule.user_role_exceeds_own_permissions` |
| Roles created through the API are never system roles | — |

The three "only what you hold" rules share one definition of *subset* (`grantScope` in `internal/service/grant_scope.go`): a Super Admin covers every permission; anyone else covers exactly the keys of their own role at the time of the request. Editing your own account is not limited by it (your role is your scope); the self rules above still apply. The 403 body is the usual `{"error":{"code":"forbidden","message":"…"}}` — the i18n key in the table is not sent, only the translated sentence:

```json
{"error":{"code":"forbidden","message":"tidak bisa memberikan role \"Gudang\" karena role itu punya izin \"products.delete\" yang tidak anda miliki sendiri"}}
{"error":{"code":"forbidden","message":"you can't change or delete a user with the \"Gudang\" role because it has the \"products.delete\" permission, which you don't hold yourself"}}
```

## Languages (`Accept-Language`)

Every sentence this API sends back â€” validation messages, conflict and
not-found messages, the envelope message, and the insight summaries that come
from the ML service â€” is available in **Indonesian (`id`)** and **English
(`en`)**.

```bash
curl -H "$AUTH" -i http://localhost:8080/api/v1/products/999999
# Content-Language: id
# 404 {"error":{"code":"not_found","message":"produk 999999 tidak ditemukan"}}

curl -H "$AUTH" -i -H 'Accept-Language: en' http://localhost:8080/api/v1/products/999999
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
curl -H "$AUTH" -H 'Accept-Language: en' "http://localhost:8080/api/v1/analytics/insights?limit=1"
# {"data":{...,"products":[{"product_name":"Kopi Bubuk Robusta 200g","trend":"increasing",
#  "change_percent":61.9,
#  "summary":"Sales increased 61.9% over the last 4 weeks (102 units vs 63 units in the previous period)."}]}}
```

## Endpoints

This table is also the **endpoint → permission map**. "public" needs no token. "login" needs a valid access token but no permission. Anything else needs a token *and* the listed permission (a Super Admin always passes). The same table is asserted route by route in `internal/router/router_test.go`, and that test fails if a route is added without an entry.

| Method | Path | Body / query | Success | Permission |
|---|---|---|---|---|
| GET | `/health` | – | 200 / 503 | public |
| POST | `/api/v1/auth/login` | `{"email","password"}` | 200 (token pair + user) | public |
| POST | `/api/v1/auth/refresh` | `{"refresh_token"}` | 200 (new pair; the old refresh token is revoked) | public |
| POST | `/api/v1/auth/logout` | `{"refresh_token"}` | 204 | public |
| GET | `/api/v1/auth/me` | – | 200 (user, role, permission keys) | login |
| POST | `/api/v1/products` | `{"sku","name","description","price","category_id"}` | 201 | `products.create` |
| GET | `/api/v1/products` | `?page=1&page_size=20&search=kopi` | 200 + `meta` | `products.view` |
| GET | `/api/v1/products/:id` | – | 200 | `products.view` |
| PATCH | `/api/v1/products/:id` | any subset of create fields | 200 | `products.update` |
| DELETE | `/api/v1/products/:id` | – | 204 (soft delete) | `products.delete` |
| POST | `/api/v1/categories` | `{"name","description"}` | 201 | `categories.create` |
| GET | `/api/v1/categories` | `?page=1&page_size=20&search=minum` | 200 + `meta` | `categories.view` |
| GET | `/api/v1/categories/:id` | – | 200 | `categories.view` |
| PATCH | `/api/v1/categories/:id` | any subset of create fields | 200 | `categories.update` |
| DELETE | `/api/v1/categories/:id` | – | 204 (soft delete), **409 while products use it** | `categories.delete` |
| GET | `/api/v1/inventory/low-stock` | `?page=1&page_size=20` | 200 + `meta` | `inventory.view` |
| GET | `/api/v1/inventory/:product_id` | – | 200 | `inventory.view` |
| PATCH | `/api/v1/inventory/:product_id` | `{"low_stock_threshold"}` | 200 | `inventory.update` |
| POST | `/api/v1/inventory/:product_id/movements` | `{"type","quantity","reason"}` | 201 | `inventory.record_movement` |
| GET | `/api/v1/inventory/:product_id/movements` | `?page=1&page_size=20` | 200 + `meta` | `inventory.view` |
| POST | `/api/v1/customers` | `{"name","email","phone","address"}` | 201 | `customers.create` |
| GET | `/api/v1/customers` | `?page=1&page_size=20&search=budi` (name, email or phone) | 200 + `meta` | `customers.view` |
| GET | `/api/v1/customers/:id` | – | 200 | `customers.view` |
| PATCH | `/api/v1/customers/:id` | any subset of create fields | 200 | `customers.update` |
| DELETE | `/api/v1/customers/:id` | – | 204 (soft delete), **409 while it has orders that are not CANCELLED** | `customers.delete` |
| POST | `/api/v1/sales-orders` | `{"customer_id","items":[{"product_id","quantity"}],"notes"}` | 201 (status `PENDING`) | `sales_orders.create` |
| GET | `/api/v1/sales-orders` | `?page=1&page_size=20&status=PENDING&customer_id=3` | 200 + `meta` (with `customer`, without `items`) | `sales_orders.view` |
| GET | `/api/v1/sales-orders/:id` | – | 200 (with `customer` and `items`) | `sales_orders.view` |
| PATCH | `/api/v1/sales-orders/:id/status` | `{"status":"CONFIRMED"}` | 200 | by target status: `CONFIRMED` → `sales_orders.confirm`, `SHIPPED` → `sales_orders.ship`, `CANCELLED` → `sales_orders.cancel`; any other value → any one of the three (the handler then rejects it) |
| GET | `/api/v1/analytics/summary` | `?from=&to=` | 200 | `analytics.view` |
| GET | `/api/v1/analytics/sales-trend` | `?from=&to=&granularity=daily\|weekly` | 200 | `analytics.view` |
| GET | `/api/v1/analytics/top-products` | `?from=&to=&limit=10` | 200 | `analytics.view` |
| GET | `/api/v1/analytics/category-breakdown` | `?from=&to=` | 200 | `analytics.view` |
| GET | `/api/v1/analytics/low-stock-alert-count` | – | 200 | `analytics.view` |
| GET | `/api/v1/analytics/forecast` | `?from=&to=&limit=10&horizon_days=7` | 200 | `analytics.forecast` |
| GET | `/api/v1/analytics/insights` | `?from=&to=&limit=10` | 200 | `analytics.insights` |
| POST | `/api/v1/users` | `{"email","password","name","role_id","is_active"}` (`is_active` defaults to true) | 201, **403 if the role is beyond the caller's permissions** | `users.create` |
| GET | `/api/v1/users` | `?page=1&page_size=20&search=budi&role_id=2` (name or email) | 200 + `meta` (with `role`) | `users.view` |
| GET | `/api/v1/users/:id` | – | 200 | `users.view` |
| PATCH | `/api/v1/users/:id` | any subset of `{"email","password","name","role_id","is_active"}` | 200, **403 if the user's current or new role is beyond the caller's permissions** | `users.update` |
| DELETE | `/api/v1/users/:id` | – | 204 (soft delete + deactivate + revoke sessions), **409 for yourself**, **403 if the user's role is beyond the caller's permissions** | `users.delete` |
| GET | `/api/v1/roles` | `?page=1&page_size=20&search=staff` | 200 + `meta` (with `permissions` and `user_count`) | `roles.view` **or** `users.create` **or** `users.update` |
| GET | `/api/v1/roles/:id` | – | 200 (with `permissions` and `user_count`) | `roles.view` |
| POST | `/api/v1/roles` | `{"name","description"}` | 201 | `roles.create` |
| PATCH | `/api/v1/roles/:id` | `{"name","description"}` | 200 | `roles.update` |
| DELETE | `/api/v1/roles/:id` | – | 204, **409 for the system role or while users have it** | `roles.delete` |
| PUT | `/api/v1/roles/:id/permissions` | `{"permission_keys":[...]}` (replaces the list) | 200 | `roles.assign_permissions` |
| GET | `/api/v1/permissions` | – | 200 (the whole catalog) | `roles.view` |

The status route checks the permission in `RequireStatusPermission`, which reads `status` from the body before the handler runs. The route is one endpoint for three actions, and "may confirm" (takes stock) is not "may cancel".

A user is never returned with its `password_hash`: the field is `json:"-"`.

**Every example below needs a token.** Log in first (see [Authentication](#authentication--access-control)) and add `-H "$AUTH"` with `AUTH="Authorization: Bearer <access_token>"`.

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
curl -H "$AUTH" "http://localhost:8080/api/v1/analytics/summary?from=2026-09-01&to=2026-09-20"
# {"data":{"range":{"from":"2026-09-01","to":"2026-09-20"},
#          "total_revenue":673000,"total_orders":10,"total_items_sold":30,"average_order_value":67300}}

curl -H "$AUTH" "http://localhost:8080/api/v1/analytics/sales-trend?from=2026-09-18&to=2026-09-20&granularity=daily"
# {"data":{"range":{"from":"2026-09-18","to":"2026-09-20"},"granularity":"daily","points":[
#   {"period_start":"2026-09-18","period_end":"2026-09-18","revenue":0,"orders":0},
#   {"period_start":"2026-09-19","period_end":"2026-09-19","revenue":0,"orders":0},
#   {"period_start":"2026-09-20","period_end":"2026-09-20","revenue":928000,"orders":13}]}}
# weekly buckets start on Monday: {"period_start":"2026-09-14","period_end":"2026-09-20",...}

curl -H "$AUTH" "http://localhost:8080/api/v1/analytics/top-products?from=2026-09-20&to=2026-09-20&limit=3"
# {"data":{"range":{...},"products":[
#   {"product_id":17,"sku":"KOPI-001","name":"Kopi Arabica","quantity_sold":3,"revenue":135000}]}}

curl -H "$AUTH" "http://localhost:8080/api/v1/analytics/category-breakdown?from=2026-09-20&to=2026-09-20"
# {"data":{"range":{...},"categories":[
#   {"category_id":null,"category_name":"Tanpa Kategori","quantity_sold":34,"revenue":778000},
#   {"category_id":8,"category_name":"Minuman","quantity_sold":2,"revenue":90000}]}}

curl -H "$AUTH" http://localhost:8080/api/v1/analytics/low-stock-alert-count
# {"data":{"count":11}}

# Forecasting — needs ../ml-service running (uvicorn app.main:app --port 8000)
curl -H "$AUTH" "http://localhost:8080/api/v1/analytics/forecast?limit=2&horizon_days=3"
# {"data":{"range":{"from":"2026-08-22","to":"2026-09-20"},"horizon_days":3,"forecast_available":true,"products":[
#   {"product_id":17,"product_name":"Kopi Arabica","sku":"KOPI-001","method":"moving_average",
#    "forecast":[{"date":"2026-09-21","predicted_quantity":0.43},
#                {"date":"2026-09-22","predicted_quantity":0.43},
#                {"date":"2026-09-23","predicted_quantity":0.43}]}]}}

curl -H "$AUTH" "http://localhost:8080/api/v1/analytics/insights?limit=2"
# {"data":{"range":{...},"insights_available":true,"products":[
#   {"product_id":17,"product_name":"Kopi Arabica","sku":"KOPI-001","trend":"increasing","change_percent":32,
#    "summary":"Penjualan naik 32,0% dalam 4 minggu terakhir (1848 unit vs 1400 unit periode sebelumnya)."}]}}

# Same call with the ML service stopped: still 200, degraded per product.
curl -H "$AUTH" "http://localhost:8080/api/v1/analytics/forecast?limit=2"
# {"data":{"range":{...},"horizon_days":7,"forecast_available":false,"products":[
#   {"product_id":17,"product_name":"Kopi Arabica","sku":"KOPI-001",
#    "error":"layanan forecasting sedang tidak tersedia"}]}}

curl -H "$AUTH" "http://localhost:8080/api/v1/analytics/summary?from=2020-01-01&to=2026-09-20"
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
curl -H "$AUTH" -X POST http://localhost:8080/api/v1/categories \
  -H "Content-Type: application/json" \
  -d '{"name":"Minuman","description":"Kopi, teh"}'

curl -H "$AUTH" -X POST http://localhost:8080/api/v1/products \
  -H "Content-Type: application/json" \
  -d '{"sku":"KOPI-001","name":"Kopi Arabica 250g","price":45000,"category_id":1}'

curl -H "$AUTH" -X POST http://localhost:8080/api/v1/inventory/1/movements \
  -H "Content-Type: application/json" \
  -d '{"type":"IN","quantity":50,"reason":"restock"}'

curl -H "$AUTH" http://localhost:8080/api/v1/inventory/low-stock

curl -H "$AUTH" -X POST http://localhost:8080/api/v1/customers \
  -H "Content-Type: application/json" \
  -d '{"name":"Budi Santoso","email":"budi@example.com","phone":"+62 812-3456-7890"}'

curl -H "$AUTH" -X POST http://localhost:8080/api/v1/sales-orders \
  -H "Content-Type: application/json" \
  -d '{"customer_id":1,"items":[{"product_id":1,"quantity":3}],"notes":"kirim sore"}'

curl -H "$AUTH" -X PATCH http://localhost:8080/api/v1/sales-orders/1/status \
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
go test ./internal/auth -v                                       # JWT issue/parse/expiry/tampering, bcrypt, the catalog
go test -run 'TestAuthService|TestUserService|TestRoleService' ./internal/service -v
go test -run TestUserService_PrivilegeMatrix ./internal/service -v  # who may give/change/delete which role (60 cases)
go test ./internal/handler -run 'TestAuthenticate|TestRequire' -v  # the middleware
go test ./internal/handler -run 'TestRoleHandler|TestUserHandler' -v  # user_count in the JSON, the new 403s
go test ./internal/router -v                                     # every route → its permission; GET /roles access matrix
```

Smoke test against a real API. It needs Postgres, migrations, the seeded accounts and `go run ./cmd/api`, plus bash and curl (on Windows, use Git Bash):

```bash
go run ./cmd/seed --auth-only    # once: roles + the Super Admin the script logs in as
bash scripts/e2e.sh              # exit 1 on any failure
ADMIN_EMAIL=... ADMIN_PASSWORD=... bash scripts/e2e.sh   # if you changed the admin credentials
PORT=8090 go run ./cmd/api       # if 8080 is taken, then:
API_URL=http://localhost:8090/api/v1 bash scripts/e2e.sh
E2E_SKIP_CLEANUP=1 bash scripts/e2e.sh   # keep this run's users and roles for inspection
```

The script logs in as the Super Admin first and sends that token on every request. It covers:
- auth: 401 without or with a garbage token, wrong password vs. unknown email (same answer), refresh rotation (the old refresh token is single-use), logout then refresh (401), access and refresh tokens not interchangeable, and 5 parallel refreshes with one token (exactly one wins)
- reuse detection, with a dedicated user and two sessions (phone, laptop): (a) the phone's refresh token works once, and its rotated successor works too (normal use never trips detection); (b) the phone's first token sent again gets a 401 that is byte-for-byte the answer to an ordinary failed refresh, **and** afterwards the laptop's refresh token and the phone's latest token are both refused, because every session of that user was revoked. The user can then log in again and refresh normally. Earlier sections trip the detection too (reusing a rotated or logged-out token, the losers of the parallel refresh race); they expect 401 either way, and the server log shows each detection
- RBAC: a Staff user gets 403 on deletes, product creation and user/role management, but may create and confirm orders; a custom role whose permission list is replaced mid-session applies on the **same access token** at once (proof that nothing is cached); the Super Admin role can't be deleted, renamed or re-permissioned; nobody can deactivate, delete or re-role themselves; a deactivated user's live token and refresh token stop working immediately
- `user_count`: 0 on a new role; 3 after three users get it, in both the list and the detail; still 3 after one is deactivated and another soft-deleted; the 409 on delete quotes the same 3; 2 once a user moves to another role
- roles list for a user manager (`users.create`/`users.update`, no `roles.view`): `GET /roles` 200 with `user_count`, but `GET /roles/:id`, `GET /permissions` and `POST /roles` 403. `users.view` alone and Staff get 403 on `GET /roles`, naming all three permissions (in both languages)
- guardrails: a user manager (all `users.*` plus Staff's permissions, not a Super Admin) can create Staff users but gets 403 when creating or promoting a Super Admin, or when changing, deactivating or deleting one, and 409 when promoting themselves. Against a "Power" role holding two permissions the user manager lacks, it gets 403 for creating a Power user, giving the Power role, resetting a Power user's password (the new password then doesn't log in, the old one still does), deactivating, demoting and deleting one; a weaker manager with only `users.*` gets 403 even for Staff. Renaming a Staff user and editing their own account still work. A role manager (holds `roles.assign_permissions`) can grant what it holds, but gets 403 for anything else, on another role or its own, and the role is unchanged afterwards. A role whose only user is soft-deleted still can't be deleted. Two Super Admins demote each other in parallel for 5 rounds, and each round must end with exactly one winner and one Super Admin. At the HTTP level the loser is almost always stopped by its own permission check (403) before reaching the lock; the lock itself is proven by the `Guardrail` integration test below
- Category, Product↔Category and Inventory, including 20 concurrent OUTs
- Customers
- the full sales order flow: create → confirm (stock down) → cancel (stock back) → ship, invalid transitions, and a rollback when one item is short
- analytics: orders in four statuses, then checks that only the CONFIRMED/SHIPPED ones show up in summary, top-products and category-breakdown, plus trend shape, the alert count and the date validation.
  Summary and trend are cached, so the script compares them against a baseline taken before its own orders; if it sees a cached response it says so instead of failing. Start the API with `ANALYTICS_CACHE_TTL=0` to assert those numbers exactly.
- forecasting: if the ML service answers on `/health`, the script asserts the happy path (`forecast_available: true`, 7 predicted days per product, an Indonesian `summary` per product). **If it does not answer, the script switches to the degradation checks instead** — 200 with `forecast_available: false` and a per-product error — so running it twice, once with the ML service up and once with it stopped, covers both paths.
- concurrency: 5 orders racing for the same stock, one order confirmed 10× in parallel, and 20 parallel creates with unique order numbers

It creates uniquely named data and soft-deletes products and categories at the end. Stock movements, inventory rows, orders and customers with orders stay behind. Its users and roles are hard-deleted at the very end with `go run ./cmd/seed --clean-e2e-run=$RUN` (so it needs Go and this `.env` pointing at the API's database), and the last checks confirm no role or user of the run is left; `E2E_SKIP_CLEANUP=1` skips that step.

The analytics and role SQL have their own tests against a real Postgres, because "only CONFIRMED and SHIPPED count" and "user_count includes soft-deleted users, in one query" live in the queries and a mock can't prove them. They skip unless `TEST_DATABASE_URL` is set, and run inside a transaction that is rolled back, so the database keeps its data:

```bash
TEST_DATABASE_URL="postgres://inventory:...@localhost:5432/inventory_intel?sslmode=disable" \
  go test ./internal/repository -run 'Analytics|Guardrail|RoleRepository' -v
```

The `RoleRepository` tests seed a role with no user, one with an active, an inactive and a soft-deleted user (3), and one with only a soft-deleted user (1), and check `user_count` through both `FindByID` and `List`, and that exactly the non-zero ones are refused by the foreign key. A GORM logger records every statement: one role or three, `List` runs the same three statements, and only one of them reads `users` (inside the role `SELECT`, without a `deleted_at` filter). They also check that the locked user handed to the service's mutation carries its role's permission keys, which the "only what you hold" rule compares.

The `Guardrail` tests cover the two access-control rules that live in the database, where a mock proves nothing. They need two connections that really commit, so instead of a rolled-back transaction each test creates a throwaway schema (`itest_guardrail_<nanos>`), migrates it, and drops it at the end.

- `TwoSuperAdminsDemotingEachOther`: A's demotion of B is held open inside its transaction. B's demotion of A must then **wait** on the lock, and after A commits it must count one Super Admin (not two) and be refused. Removing `FOR UPDATE OF u` from `lockUser` makes this test fail.
- `SuperAdminCountIgnoresInactiveAndDeleted`: inactive and soft-deleted Super Admins don't count toward "at least one remains".
- `RoleOfSoftDeletedUserCantBeDeleted`: a soft-deleted user still counts in the role's `user_count`, and the foreign key refuses the delete even without the service check.
- `RevokeAllForUser` (reuse detection): revokes exactly the victim's live tokens and reports how many. An already revoked token keeps its original `revoked_at`, and another user's session is untouched.

Unit tests need no database. The service layer is tested with testify mocks of the repository interfaces.
- Refresh-token rotation is tested against an in-memory store with the repository's semantics (`fakeSessions`), so the tests check behaviour: after a refresh, the old token is refused and the new one works exactly once.
- Reuse detection (`TestAuthService_RefreshReuseRevokesEverySession`): two sessions of one user plus another user's session. The first use succeeds. Reusing the token returns an error identical to an ordinary failed refresh. Both other sessions of that user (including the rotated one) are then refused, the other user's session survives, and a fresh login works. `TestAuthService_RefreshFailuresThatAreNotReuse` checks that garbage, an access token, an unknown token and an expired token do **not** revoke anything. Replacing the revoke-all call with a no-op makes the first test fail.
- The user mock's `Mutate`/`Delete` run the service's mutation on a copy with a given Super Admin count, and record whether the sessions were revoked.
- The route→permission contract is a table in `internal/router/router_test.go`. It builds the real router with an authorizer that refuses everything and records what it was asked, then checks 401 without a token and the exact permission key for every route (for `GET /roles`, the three it accepts, in order). A route with no entry fails the test. `roles_access_test.go` then runs `GET /roles` and `GET /roles/:id` through the real router and the real `Authorize` (Super Admin bypass included) for callers holding `roles.view`, `users.create`, `users.update`, `users.view`, `users.delete`, nothing, or the system role.
- `TestUserService_PrivilegeMatrix` is the escalation matrix: Super Admin / user manager covering Staff / user manager with only `users.*`, against Guest / Staff / Power / Super Admin roles, for create, assign role, reset password, deactivate and delete (60 cases). A refusal must save nothing and revoke no session. Disabling the guard (or one half of it) makes exactly the expected cells fail.
- The inventory mock's `Mutate` runs the service's mutation against an in-memory row, the same way the real repository does inside its transaction.
- The sales order tests use an in-memory store whose `InTx` runs the callback on a copy and commits it only on success. That lets the tests check that a failed confirm (short stock, or a write error half way) leaves stock, movements and status untouched.

## Auth follow-ups

Items deferred when authentication was added, and where they stand.

| Item | Status |
|---|---|
| Refresh-token reuse detection (a revoked token used again revokes every session of the user) | ✅ **Done**: see [Design notes](#authentication--access-control) and the tests above |
| Periodic cleanup of expired/revoked rows in `refresh_tokens` (they accumulate; harmless but unbounded) | ⏳ open |
| Change-own-password endpoint (today only `PATCH /users/:id` with `users.update`) | ⏳ open |

## Adding a new resource

Category is the simplest copy; it follows the Product slice exactly.


1. `internal/model/category.go`: entity + input types; add `&Category{}` to `model.All()`.
2. `internal/repository/category_repository.go`: interface + GORM implementation, use `translate(err)`.
3. `internal/service/category_service.go`: validation + `mapRepoError`; table-driven tests with a mock repo.
4. `internal/handler/category_handler.go`: bind JSON, call service, `writeError` on failure.
5. Permissions: add `<resource>.view/create/...` to `auth.Catalog` (`internal/auth/permissions.go`) and a `permission.<key>` description in both languages to `internal/i18n/catalog.go`.
6. Register routes in `internal/router/router.go` inside the authenticated group, each with `can(auth.<Permission>)`, and add them to the table in `internal/router/router_test.go` (the test fails until you do). Wire dependencies in `cmd/api/main.go`.
7. `go run ./cmd/migrate` (creates the table and syncs the new permission keys). Grant the keys to the roles that need them with `PUT /api/v1/roles/:id/permissions`; a Super Admin has them automatically.
