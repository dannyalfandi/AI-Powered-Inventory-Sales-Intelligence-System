# infra

Local development infrastructure: **PostgreSQL 16** and **Redis 7** via Docker Compose.

| Service  | Image              | Default port | Volume          |
|----------|--------------------|--------------|-----------------|
| postgres | `postgres:16-alpine` | 5432       | `postgres_data` |
| redis    | `redis:7-alpine`     | 6379       | `redis_data` (AOF on) |

## Prerequisites

- Docker + Docker Compose v2 (`docker compose version`)

## Setup

All commands run from the `infra/` folder.

```bash
cd infra
cp .env.example .env      # PowerShell: Copy-Item .env.example .env
# edit .env — at minimum change POSTGRES_PASSWORD and REDIS_PASSWORD
```

Compose refuses to start if `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`, or `REDIS_PASSWORD` is missing.

## Run

```bash
docker compose up -d        # start
docker compose logs -f      # follow logs
docker compose down         # stop (data kept)
docker compose down -v      # stop AND delete volumes (wipes DB + Redis data)
```

## Health check

Both services define a Docker healthcheck. After ~10s:

```bash
docker compose ps
```

The `STATUS` column should show `(healthy)` for both `postgres` and `redis`.

Manual checks:

```bash
# Postgres → "/var/run/postgresql:5432 - accepting connections"
docker compose exec postgres sh -c 'pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"'

# Redis → "PONG"  (REDISCLI_AUTH is set inside the container)
docker compose exec redis redis-cli ping
```

Open a psql shell:

```bash
docker compose exec postgres sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"'
```

## Connecting from host services

With default `.env` values:

- Postgres DSN: `postgres://inventory:<POSTGRES_PASSWORD>@localhost:5432/inventory_intel?sslmode=disable`
- Redis: `localhost:6379`, password `<REDIS_PASSWORD>`, DB `0`

If a service later runs inside this compose network, use hostnames `postgres` / `redis` instead of `localhost`.
