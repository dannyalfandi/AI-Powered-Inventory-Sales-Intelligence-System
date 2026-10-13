# ml-service

Python/FastAPI service for demand forecasting and trend insight, part of the
Inventory & Sales Intelligence Platform. The Go backend in `../backend` calls it
**synchronously** over REST when it needs a forecast.

Stateless by design: it never touches Postgres or Redis. All historical data
arrives in the request body, and nothing is stored between calls — so it can be
restarted or scaled without any migration or warm-up.

The full request/response reference lives in
[`../docs/ml-service-contract.md`](../docs/ml-service-contract.md). This file is
about running and testing it.

## Endpoints

| Method | Path | Purpose |
|---|---|---|
| GET | `/health` | Liveness + version + which forecaster is active |
| POST | `/forecast/demand` | Daily demand forecast for one product |
| POST | `/insight/trend` | Last N days vs. the N days before (statistics only, no LLM) |

Interactive docs while it runs: <http://localhost:8000/docs>.

## Languages

Both endpoints answer in **Indonesian (`id`, the default)** or **English
(`en`)**, chosen by a `"lang"` field in the request body:

```bash
curl -X POST http://localhost:8000/insight/trend \
  -H 'Content-Type: application/json' \
  -d '{"lang":"en","history":[...]}'
# {"trend":"increasing","change_percent":32.0,
#  "summary":"Sales increased 32.0% over the last 4 weeks (1848 units vs 1400 units in the previous period)."}
```

It is a body field rather than a header because the caller is the Go backend,
which has already resolved the end user's `Accept-Language`; passing the
result explicitly keeps the contract visible and easy to test.

- Omitting `lang`, or sending `"id"`, gives Indonesian.
- `"en"` gives English, including the decimal mark: `32,0%` becomes `32.0%`.
- An unsupported value is a 422 on the `lang` field.
- Translated: the `summary` sentence and the messages of the rules this
  service checks itself (history too short, horizon too large), plus the
  envelope `message`. **Not translated:** `trend` values (`increasing`),
  field names, numbers, and the per-field text pydantic writes for a
  structurally invalid body.
- The catalog is `app/core/i18n.py`; a test asserts every key exists in both
  languages with the same placeholders.

## Layout

```
app/
  main.py                 FastAPI app: routes, logging, the 422 error envelope
  core/config.py          Settings from the environment (.env in dev)
  core/i18n.py            message catalog (id/en) + formatting per language
  models/schemas.py       Pydantic request/response models — the API contract
  services/history.py     history rows → dense daily series (gap filling, dedupe, sorting)
  services/forecasting.py Forecaster protocol + MovingAverageForecaster + registry
  services/trend.py       period comparison + the Indonesian summary
tests/                    pytest, table-driven like the Go service tests
                          (test_i18n.py covers both languages end to end)
Dockerfile                multi-stage python:3.12-slim image (service `ml` in ../infra)
```

Dependency direction: `main → services → models/core`. The services know
nothing about FastAPI, which is why they can be tested without HTTP.

## Prerequisites

- Python 3.12+ (developed on 3.13)

## Setup

```bash
cd ml-service
python -m venv .venv
source .venv/Scripts/activate      # Windows (Git Bash); Linux/macOS: source .venv/bin/activate
pip install -r requirements-dev.txt   # runtime deps + pytest/httpx
cp .env.example .env                  # optional: all values have defaults
```

`requirements.txt` is what the Docker image installs; `requirements-dev.txt`
adds the test tools. `scikit-learn` is already pinned although the moving
average does not need it — it is there for the planned regression model.

## Run

```bash
uvicorn app.main:app --reload --port 8000
```

`PORT` in `.env` is read by the Docker image; when running uvicorn by hand,
pass `--port` yourself.

## Test

```bash
pytest            # 53 tests
pytest -q tests/test_forecasting.py
```

- `tests/test_forecasting.py` — the moving average (full window, short history,
  gaps, duplicate dates, unordered input, all zeros), forecast dates, and the
  data-dependent 422 rules.
- `tests/test_trend.py` — direction and percentage for increasing / decreasing /
  stable, the threshold edges, the zero baseline, window clamping, and the exact
  Indonesian sentences.
- `tests/test_api.py` — the HTTP layer: status codes and the exact JSON of both
  endpoints, plus the 422 envelope for every kind of bad input.

## Configuration

All optional; the defaults below are built in.

| Variable | Default | Meaning |
|---|---|---|
| `PORT` | `8000` | Port the container's uvicorn binds |
| `LOG_LEVEL` | `info` | `critical`/`error`/`warning`/`info`/`debug` |
| `DEFAULT_WINDOW_DAYS` | `7` | Moving-average window when the request omits `window_days` |
| `MAX_WINDOW_DAYS` | `90` | Larger → 422 |
| `MAX_HORIZON_DAYS` | `90` | Larger → 422 |
| `MIN_HISTORY_POINTS` | `3` | Fewer history rows → 422 |
| `TREND_WINDOW_DAYS` | `14` | Length of each compared period in `/insight/trend` |
| `FORECAST_METHOD` | `moving_average` | Which registered forecaster to use |

## Modelling decisions

- **Moving average first.** Mean of the last `window_days` days, projected flat
  over the horizon. Simple, fast, and explainable — which matters more here than
  accuracy on this data volume.
- **Swappable model.** `app/services/forecasting.py` defines a `Forecaster`
  protocol and a registry. A linear-regression forecaster is a new class plus one
  registry entry; the request/response shape does not change, only the `method`
  field in the response.
- **Missing days are zeros.** The series is reindexed to every date between the
  first and last history date. Dropping days with no sales would inflate every
  average. The caller may gap-fill first (like the analytics `generate_series`)
  but does not have to.
- **Short history still answers.** With fewer days than the window, the window
  shrinks to what exists and the response reports the window it actually used,
  instead of returning an error.
- **Trend is arithmetic, not language generation.** The summary is a template
  filled with computed numbers, so it is deterministic and testable. An
  LLM-written insight would be a separate, later phase.

## Examples

```bash
curl http://localhost:8000/health

curl -X POST http://localhost:8000/forecast/demand \
  -H 'Content-Type: application/json' \
  -d '{
        "product_id": 17,
        "history": [
          {"date": "2026-09-01", "quantity_sold": 4},
          {"date": "2026-09-02", "quantity_sold": 6},
          {"date": "2026-09-03", "quantity_sold": 8}
        ],
        "horizon_days": 2
      }'
# {"product_id":17,"forecast":[{"date":"2026-09-04","predicted_quantity":6.0},
#  {"date":"2026-09-05","predicted_quantity":6.0}],"method":"moving_average","window_days":3}

curl -X POST http://localhost:8000/insight/trend \
  -H 'Content-Type: application/json' \
  -d '{
        "product_id": 17,
        "history": [
          {"date": "2026-09-01", "quantity_sold": 5},
          {"date": "2026-09-02", "quantity_sold": 5},
          {"date": "2026-09-03", "quantity_sold": 10},
          {"date": "2026-09-04", "quantity_sold": 10}
        ]
      }'
# {"trend":"increasing","change_percent":100.0,
#  "summary":"Penjualan naik 100,0% dalam 4 hari terakhir (20 unit vs 10 unit periode sebelumnya).",
#  "window_days":2,"recent_total":20,"previous_total":10}

# A rejected request (fewer than 3 history rows):
# {"error":{"code":"validation_failed","message":"request validation failed",
#  "details":[{"field":"history","message":"history must have at least 3 data points, got 2"}]}}
```

## Docker

`docker compose up` in `../infra` builds this image and runs it as the service
`ml`, published on the host at `localhost:${ML_PORT}` (default 8000). It has no
profile, so it starts with Postgres and Redis:

```bash
cd ../infra
docker compose up -d ml         # or plain `docker compose up -d` for the whole infra
docker compose logs -f ml
docker compose stop ml          # e.g. before running uvicorn on the host (same port)
```

Inside the compose network the Go API (profile `app`) reaches it at
`http://ml:8000`; an API run on the host uses its default
`ML_SERVICE_URL=http://localhost:8000`, which matches as long as `ML_PORT` stays
8000. The compose healthcheck calls `GET /health` with Python's `urllib` (the
image has no curl), and the `api` service waits for it to be healthy.

Standalone, without compose:

```bash
docker build -t inventory-ml-service .
docker run --rm -p 8000:8000 -e LOG_LEVEL=debug inventory-ml-service
```

Multi-stage (`python:3.12-slim`), runs as a non-root user, and honours `PORT`.
