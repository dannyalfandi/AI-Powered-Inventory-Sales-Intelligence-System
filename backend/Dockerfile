# One image, three binaries: api (the server), migrate and seed (one-shot
# commands run by infra/docker-compose.yml). Go version follows go.mod.
FROM golang:1.26.0-alpine AS builder

WORKDIR /src
# Dependencies first, so editing code doesn't re-download modules.
COPY go.mod go.sum ./
RUN go mod download

COPY . .
# Pure Go (pgx, no cgo); the IANA zone database is embedded via time/tzdata.
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/api ./cmd/api \
    && CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/migrate ./cmd/migrate \
    && CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/seed ./cmd/seed

FROM alpine:3.23.0 AS runtime

# Non-root, no home directory: the binaries never write to disk.
RUN adduser -D -H -u 10001 app
WORKDIR /app
COPY --from=builder /out/ /app/
USER 10001

# Every setting (DATABASE_URL, REDIS_ADDR, JWT_SECRET, ...) comes from the
# environment at run time; nothing secret is baked in.
ENV PORT=8080 \
    GIN_MODE=release
EXPOSE 8080

# /health pings Postgres and Redis (503 when either is down), not the ML
# service, so the API stays healthy while forecasting degrades. busybox wget
# ships with alpine. Meaningless for migrate/seed; compose disables it there.
HEALTHCHECK --interval=10s --timeout=5s --start-period=10s --retries=5 \
    CMD wget -q -O /dev/null "http://127.0.0.1:${PORT}/health" || exit 1

CMD ["/app/api"]
