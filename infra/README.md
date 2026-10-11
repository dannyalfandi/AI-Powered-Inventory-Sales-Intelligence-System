# infra

Local development stack via Docker Compose. Plain `docker compose up` starts the infrastructure **and the ML service**; the Go API and the one-shot commands sit behind profiles.

| Service    | Image / build                     | Starts with                | Host port (variable, compose default) | Volume |
|------------|-----------------------------------|----------------------------|---------------------------------------|--------|
| `postgres` | `postgres:16-alpine`              | `up`                       | `POSTGRES_PORT`, 5432                 | `postgres_data` |
| `redis`    | `redis:7-alpine`                  | `up`                       | `REDIS_PORT`, 6379                    | `redis_data` (AOF on) |
| `ml`       | `../ml-service/Dockerfile`        | `up`                       | `ML_PORT`, 8000                       | – |
| `migrate`  | `../backend/Dockerfile` (`/app/migrate`) | profile `app` / `seed`, one-shot | – | – |
| `api`      | `../backend/Dockerfile` (`/app/api`)     | profile `app`              | `API_PORT`, 8080                      | – |
| `seed`     | `../backend/Dockerfile` (`/app/seed`)    | profile `seed`, one-shot   | – | – |

`migrate`, `api` and `seed` share one image (`<COMPOSE_PROJECT_NAME>-backend:local`); the ML image is `<COMPOSE_PROJECT_NAME>-ml:local`. Both run as a non-root user and contain no secrets: every setting comes from the environment at run time.

## Prerequisites

- Docker + Docker Compose v2 (`docker compose version`)

## Setup

All commands run from the `infra/` folder.

```bash
cd infra
cp .env.example .env      # PowerShell: Copy-Item .env.example .env
```

Then edit `.env`:

- change `POSTGRES_PASSWORD` and `REDIS_PASSWORD`. The Postgres password is put into a URL for the API container, so keep it to letters, digits, `-` and `_`;
- **fill `JWT_SECRET`** (at least 32 characters) before using profile `app`. Plain `docker compose up` doesn't need it. The API checks it at startup: if it is empty or too short, the `api` container exits with code 1 and `docker compose logs api` shows `invalid configuration: JWT_SECRET is required to run the API ...` or `... JWT_SECRET must be at least 32 characters`. Generate one with:

  ```bash
  openssl rand -base64 48                       # Git Bash / Linux / macOS
  # PowerShell: [Convert]::ToBase64String((1..48 | ForEach-Object { Get-Random -Maximum 256 }))
  ```

  Paste the output after `JWT_SECRET=`. Never commit it; `.env` is git-ignored.
- set the host ports if the defaults (5432 / 6379 / 8000 / 8080, the same as `backend/.env.example`) are taken on your machine, e.g. `POSTGRES_PORT=5433`, `REDIS_PORT=6380`, `API_PORT=8090`. These machine-specific values belong in `.env` only, never in `.env.example`. Only the host side changes; containers always talk to each other on the standard ports. If you change a port, update the matching URL in `backend/.env` for the API you run on the host.

`.env` holds only what `docker-compose.yml` reads. Don't copy `DATABASE_URL` / `REDIS_ADDR` from `backend/.env` here: the API container gets them from `docker-compose.yml`, built from the Postgres/Redis values above with the service names as hosts (`postgres:5432`, `redis:6379`, `http://ml:8000`).

Compose refuses to start if `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB` or `REDIS_PASSWORD` is missing.

## Run

### Default: infrastructure + ML service (API runs on the host)

```bash
docker compose up -d        # postgres + redis + ml (builds the ML image the first time)
docker compose logs -f      # follow logs
docker compose down         # stop (data kept)
```

The usual dev flow stays the same: run the API with `go run ./cmd/api` in `backend/` and the Flutter app on your machine. The API's default `ML_SERVICE_URL=http://localhost:8000` reaches the `ml` container as long as `ML_PORT` stays 8000. If you change `ML_PORT`, set `ML_SERVICE_URL` in `backend/.env` to match. Don't also start `uvicorn` on the host: it would fight the container for that port.

### Profile `app`: the whole stack

```bash
docker compose --profile app up --build                  # foreground, logs in the terminal
docker compose --profile app up --build -d --wait        # background; exits non-zero if a service never gets healthy
```

Prefer `--wait` with `-d`. Plain `up -d` returns success even when `api` cannot start, for example on a missing `JWT_SECRET`. With `--wait`, compose reports `container ... is unhealthy` and exits 1 within seconds.

`api` uses `restart: on-failure:3`: a crash is retried 3 times (4 attempts in total, a few seconds), then the container stays `Exited (1)` in `docker compose --profile app ps` instead of looping. Read the cause with `docker compose logs api`, fix `.env`, and run `up` again. A clean stop (`docker compose stop`) is not restarted.

Order: postgres + redis + ml healthy → `migrate` runs once and must exit 0 → `api` starts on `localhost:${API_PORT}`. `migrate` is idempotent (AutoMigrate + permission catalog sync), so it runs again on every `up`. The API's `/health` checks Postgres and Redis only. When `ml` is stopped the API stays healthy and forecast/insights answer `200` with `"forecast_available": false` / `"insights_available": false`.

A Flutter app on the emulator/phone points at `http://<host>:${API_PORT}/api/v1` (see `mobile/README.md`). A locally run API on the same port would conflict: stop one of them, or give them different ports.

### Profile `seed`: demo data

```bash
docker compose --profile seed run --rm seed                  # roles, accounts, catalogue, 75 days of sales
docker compose --profile seed run --rm seed --auth-only      # only roles + Super Admin/Staff accounts
docker compose --profile seed run --rm seed --clean          # remove test/demo leftovers
```

Flags go after the service name (they are passed to `/app/seed`). `migrate` runs first, so seeding a fresh database works. The Super Admin comes from `SEED_ADMIN_EMAIL` / `SEED_ADMIN_PASSWORD` in `.env`; left empty, the seeder uses its default credential and logs a warning (see `backend/README.md`).

### End-to-end test against the containers

From `backend/`, with the `app` profile up and the accounts seeded:

```bash
API_URL=http://localhost:${API_PORT:-8080}/api/v1 ML_SERVICE_URL=http://localhost:${ML_PORT:-8000} \
  E2E_SKIP_CLEANUP=1 bash scripts/e2e.sh
# then remove that run's users/roles from the *container* database:
docker compose -f ../infra/docker-compose.yml --profile seed run --rm --no-deps seed --clean-e2e-run=<RUN printed by e2e.sh>
```

`E2E_SKIP_CLEANUP=1` matters. The script's own cleanup runs `go run ./cmd/seed` with `backend/.env`, which points at your *host* database, not the container's.

## Health check

Every long-running service defines a healthcheck: `pg_isready` for postgres, `redis-cli ping` for redis, `GET /health` for ml (Python `urllib`, the image has no curl) and for api (busybox `wget`, from the Dockerfile). Both `ml` and `api` run their server as PID 1, so `docker compose stop` shuts them down gracefully in about a second.

```bash
docker compose --profile app ps
```

The `STATUS` column should show `(healthy)` for postgres, redis, ml and api, and `Exited (0)` for migrate.

Manual checks:

```bash
# Postgres → "/var/run/postgresql:5432 - accepting connections"
docker compose exec postgres sh -c 'pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"'

# Redis → "PONG"  (REDISCLI_AUTH is set inside the container)
docker compose exec redis redis-cli ping

# ML service and API (host ports from .env)
curl http://localhost:8000/health     # {"status":"ok","service":"ml-service",...}
curl http://localhost:8080/health     # {"status":"ok","checks":{"database":"up","redis":"up"}}
```

Open a psql shell:

```bash
docker compose exec postgres sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"'
```

## Cleaning up

```bash
docker compose --profile app --profile seed down              # stop and remove containers (data kept)
docker compose --profile app --profile seed down -v           # ...AND delete volumes (wipes DB + Redis data)
docker image rm inventory-intel-backend:local inventory-intel-ml:local   # built images (prefix = COMPOSE_PROJECT_NAME)
```

Name the profiles you started, so `down` includes their services.

To try the stack next to a running dev stack, use another project name and free ports. Pass the variables in the environment, which overrides `.env` (or use a separate `--env-file`), so container names don't collide:

```bash
COMPOSE_PROJECT_NAME=inventory-try POSTGRES_PORT=15432 REDIS_PORT=16379 ML_PORT=18000 API_PORT=18080 \
  docker compose -p inventory-try --profile app up -d --build --wait
COMPOSE_PROJECT_NAME=inventory-try docker compose -p inventory-try --profile app --profile seed down -v
```

## Connecting from host services

With the compose default ports (adjust to your `.env`):

- Postgres DSN: `postgres://inventory:<POSTGRES_PASSWORD>@localhost:5432/inventory_intel?sslmode=disable`
- Redis: `localhost:6379`, password `<REDIS_PASSWORD>`, DB `0`
- ML service: `http://localhost:8000`

These match the defaults in `backend/.env.example`.

Inside this compose network the hosts are `postgres`, `redis` and `ml` instead of `localhost`.
